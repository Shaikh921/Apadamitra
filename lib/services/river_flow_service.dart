import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:riverwise/models/river_flow_model.dart';
import 'package:latlong2/latlong.dart';

/// Service for fetching river flow data from various APIs
class RiverFlowService {
  static const String _openMeteoBaseUrl = 'https://api.open-meteo.com/v1';
  
  /// Get list of available rivers (from local data or Supabase)
  Future<List<Map<String, dynamic>>> getAvailableRivers() async {
    // For now, return sample Indian rivers
    // In production, fetch from Supabase or OSM
    return [
      {
        'id': 'godavari',
        'name': 'Godavari',
        'state': 'Maharashtra',
        'latitude': 19.0760,
        'longitude': 73.8777,
      },
      {
        'id': 'krishna',
        'name': 'Krishna',
        'state': 'Maharashtra',
        'latitude': 16.7050,
        'longitude': 74.2433,
      },
      {
        'id': 'narmada',
        'name': 'Narmada',
        'state': 'Madhya Pradesh',
        'latitude': 22.7196,
        'longitude': 75.8577,
      },
      {
        'id': 'yamuna',
        'name': 'Yamuna',
        'state': 'Uttar Pradesh',
        'latitude': 25.4358,
        'longitude': 81.8463,
      },
      {
        'id': 'ganga',
        'name': 'Ganga',
        'state': 'Uttar Pradesh',
        'latitude': 25.3176,
        'longitude': 82.9739,
      },
    ];
  }
  
  /// Get river flow data with rainfall and water level
  Future<RiverFlowModel> getRiverFlowData(String riverId) async {
    final rivers = await getAvailableRivers();
    final river = rivers.firstWhere((r) => r['id'] == riverId);
    
    // Fetch rainfall data from Open-Meteo
    final rainfall = await _getRainfallData(
      river['latitude'],
      river['longitude'],
    );
    
    // Generate mock flow path (in production, fetch from OSM)
    final flowPath = _generateMockFlowPath(
      river['latitude'],
      river['longitude'],
    );
    
    // Generate mock water level and flow rate
    final waterLevel = 10.0 + (rainfall / 10); // Simple calculation
    final flowRate = 500.0 + (rainfall * 20); // Simple calculation
    
    // Determine flood status based on water level
    final floodStatus = _determineFloodStatus(waterLevel, flowRate);
    
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
      stations: _generateMockStations(river['latitude'], river['longitude']),
      nearbyDams: [],
    );
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
