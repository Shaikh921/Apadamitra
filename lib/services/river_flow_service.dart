import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Apadamitra/models/river_flow_model.dart';
import 'package:latlong2/latlong.dart';

/// Service for fetching river flow data from various APIs
class RiverFlowService {
  static const String _openMeteoBaseUrl = 'https://api.open-meteo.com/v1';
  static const String _overpassBaseUrl = 'https://overpass-api.de/api/interpreter';
  
  // Cache for river data
  static List<Map<String, dynamic>>? _cachedRivers;
  static DateTime? _cacheTime;
  static const Duration _cacheDuration = Duration(hours: 3);
  
  /// Get list of available rivers dynamically from OpenStreetMap
  Future<List<Map<String, dynamic>>> getAvailableRivers() async {
    // Return cached data if available and fresh
    if (_cachedRivers != null && 
        _cacheTime != null && 
        DateTime.now().difference(_cacheTime!) < _cacheDuration) {
      return _cachedRivers!;
    }
    
    try {
      // Fetch major Indian rivers from Overpass API
      final rivers = await _fetchRiversFromOSM();
      
      if (rivers.isNotEmpty) {
        _cachedRivers = rivers;
        _cacheTime = DateTime.now();
        return rivers;
      }
    } catch (e) {
      print('Error fetching rivers from OSM: $e');
    }
    
    // Fallback to static list if API fails
    return _getFallbackRivers();
  }
  
  /// Fetch rivers from OpenStreetMap Overpass API
  Future<List<Map<String, dynamic>>> _fetchRiversFromOSM() async {
    // Query for major Indian rivers
    final query = '''
      [out:json][timeout:25];
      (
        relation["waterway"="river"]["name"~"Ganga|Godavari|Krishna|Narmada|Yamuna|Brahmaputra|Mahanadi|Kaveri|Tapti|Indus",i]["name:en"];
      );
      out center;
    ''';
    
    final url = Uri.parse(_overpassBaseUrl);
    final response = await http.post(
      url,
      body: {'data': query},
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    ).timeout(const Duration(seconds: 30));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final elements = data['elements'] as List;
      
      final rivers = <Map<String, dynamic>>[];
      
      for (var element in elements) {
        if (element['tags'] != null && element['center'] != null) {
          final tags = element['tags'];
          final center = element['center'];
          
          rivers.add({
            'id': _sanitizeId(tags['name'] ?? tags['name:en'] ?? 'unknown'),
            'name': tags['name:en'] ?? tags['name'] ?? 'Unknown River',
            'state': tags['is_in:state'] ?? _guessStateFromCoords(center['lat'], center['lon']),
            'latitude': center['lat'],
            'longitude': center['lon'],
            'length': tags['length'] ?? 'N/A',
          });
        }
      }
      
      return rivers;
    }
    
    throw Exception('Failed to fetch rivers from OSM');
  }
  
  /// Fallback static river list
  List<Map<String, dynamic>> _getFallbackRivers() {
    return [
      {
        'id': 'ganga',
        'name': 'Ganga',
        'state': 'Uttar Pradesh',
        'latitude': 25.3176,
        'longitude': 82.9739,
        'length': '2525 km',
      },
      {
        'id': 'godavari',
        'name': 'Godavari',
        'state': 'Maharashtra',
        'latitude': 19.0760,
        'longitude': 73.8777,
        'length': '1465 km',
      },
      {
        'id': 'krishna',
        'name': 'Krishna',
        'state': 'Maharashtra',
        'latitude': 16.7050,
        'longitude': 74.2433,
        'length': '1400 km',
      },
      {
        'id': 'narmada',
        'name': 'Narmada',
        'state': 'Madhya Pradesh',
        'latitude': 22.7196,
        'longitude': 75.8577,
        'length': '1312 km',
      },
      {
        'id': 'yamuna',
        'name': 'Yamuna',
        'state': 'Uttar Pradesh',
        'latitude': 25.4358,
        'longitude': 81.8463,
        'length': '1376 km',
      },
      {
        'id': 'brahmaputra',
        'name': 'Brahmaputra',
        'state': 'Assam',
        'latitude': 26.2006,
        'longitude': 92.9376,
        'length': '2900 km',
      },
    ];
  }
  
  /// Sanitize river name to create ID
  String _sanitizeId(String name) {
    return name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
  }
  
  /// Guess state from coordinates (simplified)
  String _guessStateFromCoords(double lat, double lon) {
    if (lat > 26 && lon > 90) return 'Assam';
    if (lat > 25 && lon < 83) return 'Uttar Pradesh';
    if (lat < 20 && lon > 73 && lon < 78) return 'Maharashtra';
    if (lat > 21 && lat < 24 && lon > 74 && lon < 78) return 'Madhya Pradesh';
    return 'India';
  }
  
  /// Get river flow data with real-time rainfall and hydrology data
  Future<RiverFlowModel> getRiverFlowData(String riverId) async {
    final rivers = await getAvailableRivers();
    final river = rivers.firstWhere((r) => r['id'] == riverId);
    
    final lat = river['latitude'];
    final lon = river['longitude'];
    
    // Fetch real-time data from Open-Meteo
    final weatherData = await _getWeatherAndHydrologyData(lat, lon);
    
    // Fetch river geometry from OSM
    final flowPath = await _fetchRiverGeometry(river['name'], lat, lon);
    
    // Fetch nearby dams
    final dams = await _fetchNearbyDams(river['name'], lat, lon);
    
    // Calculate dynamic water level and flow rate
    final baseLevel = 10.0; // Can be fetched from database
    final baseFlow = 500.0; // Can be fetched from database
    
    final rainfall = weatherData['rainfall'] ?? 0.0;
    final discharge = weatherData['discharge'];
    
    final waterLevel = baseLevel + (rainfall / 10);
    final flowRate = discharge ?? (baseFlow + (rainfall * 20));
    
    // Determine flood status
    final floodStatus = _determineFloodStatus(waterLevel, flowRate);
    
    // Generate monitoring stations
    final stations = await _generateStationsFromData(river['name'], lat, lon, rainfall);
    
    return RiverFlowModel(
      id: riverId,
      name: river['name'],
      state: river['state'],
      flowPath: flowPath,
      flowRate: flowRate,
      waterLevel: waterLevel,
      floodStatus: floodStatus,
      lastUpdated: DateTime.now(),
      rainfall: rainfall,
      stations: stations,
      nearbyDams: dams,
    );
  }
  
  /// Fetch weather and hydrology data from Open-Meteo
  Future<Map<String, dynamic>> _getWeatherAndHydrologyData(double lat, double lon) async {
    try {
      final url = Uri.parse(
        '$_openMeteoBaseUrl/forecast?latitude=$lat&longitude=$lon&hourly=precipitation,river_discharge&past_days=1&forecast_days=1',
      );
      
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final hourly = data['hourly'];
        
        // Get last 24 hours of data
        final precipitation = hourly['precipitation'] as List?;
        final riverDischarge = hourly['river_discharge'] as List?;
        
        // Calculate total rainfall
        double totalRainfall = 0.0;
        if (precipitation != null) {
          totalRainfall = precipitation.fold<double>(
            0.0,
            (sum, value) => sum + ((value ?? 0.0) as num).toDouble(),
          );
        }
        
        // Get latest discharge value
        double? latestDischarge;
        if (riverDischarge != null && riverDischarge.isNotEmpty) {
          latestDischarge = (riverDischarge.last as num?)?.toDouble();
        }
        
        return {
          'rainfall': totalRainfall,
          'discharge': latestDischarge,
          'timestamp': DateTime.now(),
        };
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
    
    // Fallback to mock data
    return {
      'rainfall': 25.0 + (DateTime.now().millisecond % 50),
      'discharge': null,
      'timestamp': DateTime.now(),
    };
  }
  
  /// Fetch river geometry from OpenStreetMap
  Future<List<LatLng>> _fetchRiverGeometry(String riverName, double centerLat, double centerLon) async {
    try {
      final query = '''
        [out:json][timeout:25];
        (
          way["waterway"="river"]["name"~"$riverName",i](around:50000,$centerLat,$centerLon);
          relation["waterway"="river"]["name"~"$riverName",i](around:50000,$centerLat,$centerLon);
        );
        out geom;
      ''';
      
      final url = Uri.parse(_overpassBaseUrl);
      final response = await http.post(
        url,
        body: {'data': query},
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final elements = data['elements'] as List;
        
        final points = <LatLng>[];
        
        for (var element in elements) {
          if (element['geometry'] != null) {
            final geometry = element['geometry'] as List;
            for (var point in geometry) {
              points.add(LatLng(point['lat'], point['lon']));
            }
          } else if (element['nodes'] != null) {
            // For ways without geometry
            final nodes = element['nodes'] as List;
            for (var node in nodes) {
              if (node['lat'] != null && node['lon'] != null) {
                points.add(LatLng(node['lat'], node['lon']));
              }
            }
          }
        }
        
        if (points.isNotEmpty) {
          return points;
        }
      }
    } catch (e) {
      print('Error fetching river geometry: $e');
    }
    
    // Fallback to generated path
    return _generateMockFlowPath(centerLat, centerLon);
  }
  
  /// Fetch nearby dams (mock implementation - can be replaced with India-WRIS API)
  Future<List<Dam>> _fetchNearbyDams(String riverName, double lat, double lon) async {
    // TODO: Integrate with India-WRIS API or Supabase database
    // For now, return mock data based on river name
    
    final damData = {
      'Ganga': [
        {'name': 'Tehri Dam', 'lat': 30.3753, 'lon': 78.4804, 'capacity': 3540.0},
        {'name': 'Farakka Barrage', 'lat': 24.8000, 'lon': 87.9333, 'capacity': 0.0},
      ],
      'Godavari': [
        {'name': 'Sriram Sagar Dam', 'lat': 18.7833, 'lon': 78.4500, 'capacity': 3153.0},
        {'name': 'Polavaram Dam', 'lat': 17.2500, 'lon': 81.6500, 'capacity': 7200.0},
      ],
      'Krishna': [
        {'name': 'Nagarjuna Sagar Dam', 'lat': 16.5667, 'lon': 79.3167, 'capacity': 11472.0},
        {'name': 'Almatti Dam', 'lat': 16.3167, 'lon': 75.9000, 'capacity': 3530.0},
      ],
      'Narmada': [
        {'name': 'Sardar Sarovar Dam', 'lat': 21.8333, 'lon': 73.7500, 'capacity': 9500.0},
        {'name': 'Indira Sagar Dam', 'lat': 22.2500, 'lon': 76.4667, 'capacity': 12220.0},
      ],
      'Yamuna': [
        {'name': 'Lakhwar Dam', 'lat': 30.4833, 'lon': 77.8167, 'capacity': 330.0},
      ],
    };
    
    final dams = <Dam>[];
    final riverDams = damData[riverName] ?? [];
    
    for (var dam in riverDams) {
      dams.add(Dam(
        id: _sanitizeId(dam['name'] as String),
        name: dam['name'] as String,
        location: LatLng(dam['lat'] as double, dam['lon'] as double),
        capacity: dam['capacity'] as double,
        currentStorage: (dam['capacity'] as double) * (0.6 + (DateTime.now().millisecond % 30) / 100),
      ));
    }
    
    return dams;
  }
  
  /// Generate monitoring stations from available data
  Future<List<RiverStation>> _generateStationsFromData(
    String riverName,
    double centerLat,
    double centerLon,
    double rainfall,
  ) async {
    // In production, fetch from CWC API or database
    return _generateMockStations(centerLat, centerLon);
  }
  
  /// Fetch rainfall data from Open-Meteo API
  Future<double> _getRainfallData(double lat, double lon) async {
    try {
      final url = Uri.parse(
        '$_openMeteoBaseUrl/forecast?latitude=$lat&longitude=$lon&hourly=precipitation&past_days=1',
      );
      
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final precipitation = data['hourly']['precipitation'] as List;
        
        // Calculate total rainfall in last 24 hours
        final total = precipitation.fold<double>(
          0.0,
          (sum, value) => sum + (value ?? 0.0),
        );
        
        return total;
      }
    } catch (e) {
      print('Error fetching rainfall data: $e');
    }
    
    // Return mock data if API fails
    return 25.0 + (DateTime.now().millisecond % 50);
  }
  
  /// Generate mock flow path for river
  List<LatLng> _generateMockFlowPath(double centerLat, double centerLon) {
    final path = <LatLng>[];
    
    // Generate a curved path (simulating river flow)
    for (int i = 0; i < 20; i++) {
      final offset = i * 0.01;
      final curve = (i % 5) * 0.002;
      path.add(LatLng(
        centerLat + offset,
        centerLon + curve - 0.005,
      ));
    }
    
    return path;
  }
  
  /// Generate mock monitoring stations
  List<RiverStation> _generateMockStations(double centerLat, double centerLon) {
    return [
      RiverStation(
        id: 'station_1',
        name: 'Upstream Station',
        location: LatLng(centerLat + 0.05, centerLon),
        waterLevel: 8.5,
        discharge: 450.0,
        lastUpdated: DateTime.now(),
      ),
      RiverStation(
        id: 'station_2',
        name: 'Midstream Station',
        location: LatLng(centerLat + 0.10, centerLon + 0.01),
        waterLevel: 10.2,
        discharge: 520.0,
        lastUpdated: DateTime.now(),
      ),
      RiverStation(
        id: 'station_3',
        name: 'Downstream Station',
        location: LatLng(centerLat + 0.15, centerLon - 0.01),
        waterLevel: 12.8,
        discharge: 680.0,
        lastUpdated: DateTime.now(),
      ),
    ];
  }
  
  /// Determine flood status based on water level and flow rate
  FloodStatus _determineFloodStatus(double waterLevel, double flowRate) {
    if (waterLevel > 15 || flowRate > 1000) {
      return FloodStatus.critical;
    } else if (waterLevel > 12 || flowRate > 800) {
      return FloodStatus.high;
    } else if (waterLevel > 10 || flowRate > 600) {
      return FloodStatus.moderate;
    } else {
      return FloodStatus.safe;
    }
  }
}
