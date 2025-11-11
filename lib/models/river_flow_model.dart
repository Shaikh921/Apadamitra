import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

/// River flow model with real-time data
class RiverFlowModel {
  final String id;
  final String name;
  final String state;
  final List<LatLng> flowPath; // River geometry
  final double flowRate; // m³/s
  final double waterLevel; // meters
  final FloodStatus floodStatus;
  final DateTime lastUpdated;
  final List<RiverStation> stations;
  final List<Dam> nearbyDams;
  final double? rainfall; // mm
  
  RiverFlowModel({
    required this.id,
    required this.name,
    required this.state,
    required this.flowPath,
    required this.flowRate,
    required this.waterLevel,
    required this.floodStatus,
    required this.lastUpdated,
    this.stations = const [],
    this.nearbyDams = const [],
    this.rainfall,
  });
  
  factory RiverFlowModel.fromJson(Map<String, dynamic> json) {
    return RiverFlowModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      state: json['state'] ?? '',
      flowPath: _parseFlowPath(json['geometry']),
      flowRate: (json['flow_rate'] ?? 0).toDouble(),
      waterLevel: (json['water_level'] ?? 0).toDouble(),
      floodStatus: FloodStatus.fromString(json['flood_status'] ?? 'safe'),
      lastUpdated: json['last_updated'] != null 
          ? DateTime.parse(json['last_updated'])
          : DateTime.now(),
      stations: (json['stations'] as List?)
          ?.map((s) => RiverStation.fromJson(s))
          .toList() ?? [],
      nearbyDams: (json['dams'] as List?)
          ?.map((d) => Dam.fromJson(d))
          .toList() ?? [],
      rainfall: json['rainfall']?.toDouble(),
    );
  }
  
  static List<LatLng> _parseFlowPath(dynamic geometry) {
    if (geometry == null) return [];
    
    if (geometry is List) {
      return geometry
          .map((point) => LatLng(
                point['lat']?.toDouble() ?? 0.0,
                point['lng']?.toDouble() ?? 0.0,
              ))
          .toList();
    }
    
    return [];
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'flow_rate': flowRate,
      'water_level': waterLevel,
      'flood_status': floodStatus.name,
      'last_updated': lastUpdated.toIso8601String(),
      'rainfall': rainfall,
    };
  }
}

/// River monitoring station
class RiverStation {
  final String id;
  final String name;
  final LatLng location;
  final double waterLevel;
  final double discharge;
  final DateTime lastUpdated;
  
  RiverStation({
    required this.id,
    required this.name,
    required this.location,
    required this.waterLevel,
    required this.discharge,
    required this.lastUpdated,
  });
  
  factory RiverStation.fromJson(Map<String, dynamic> json) {
    return RiverStation(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: LatLng(
        json['latitude']?.toDouble() ?? 0.0,
        json['longitude']?.toDouble() ?? 0.0,
      ),
      waterLevel: (json['water_level'] ?? 0).toDouble(),
      discharge: (json['discharge'] ?? 0).toDouble(),
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : DateTime.now(),
    );
  }
}

/// Dam model for map overlay
class Dam {
  final String id;
  final String name;
  final LatLng location;
  final double capacity;
  final double currentStorage;
  
  Dam({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.currentStorage,
  });
  
  factory Dam.fromJson(Map<String, dynamic> json) {
    return Dam(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: LatLng(
        json['latitude']?.toDouble() ?? 0.0,
        json['longitude']?.toDouble() ?? 0.0,
      ),
      capacity: (json['capacity'] ?? 0).toDouble(),
      currentStorage: (json['current_storage'] ?? 0).toDouble(),
    );
  }
  
  double get storagePercentage => (currentStorage / capacity) * 100;
}

/// Flood status enum
enum FloodStatus {
  safe,
  moderate,
  high,
  critical;
  
  static FloodStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'safe':
        return FloodStatus.safe;
      case 'moderate':
        return FloodStatus.moderate;
      case 'high':
        return FloodStatus.high;
      case 'critical':
        return FloodStatus.critical;
      default:
        return FloodStatus.safe;
    }
  }
  
  String get displayName {
    switch (this) {
      case FloodStatus.safe:
        return 'Safe';
      case FloodStatus.moderate:
        return 'Moderate';
      case FloodStatus.high:
        return 'High Risk';
      case FloodStatus.critical:
        return 'Critical';
    }
  }
  
  Color get color {
    switch (this) {
      case FloodStatus.safe:
        return const Color(0xFF4CAF50); // Green
      case FloodStatus.moderate:
        return const Color(0xFFFFA726); // Orange
      case FloodStatus.high:
        return const Color(0xFFFF7043); // Deep Orange
      case FloodStatus.critical:
        return const Color(0xFFF44336); // Red
    }
  }
}
