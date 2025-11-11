/// Website Integration Configuration for Apadamitra
/// 
/// This file contains the actual configuration for your website backend.
/// Based on: https://river-water-management-and-life-safety.onrender.com/

class WebsiteConfig {
  /// Your website's base URL
  static const String baseUrl = 'https://river-water-management-and-life-safety.onrender.com';
  
  /// API base URL
  static const String apiBaseUrl = 'https://river-water-management-and-life-safety.onrender.com/api';
  
  /// Website name for display purposes
  static const String websiteName = 'River Water Management';
  
  /// API endpoints mapping (based on your backend routes)
  static const Map<String, String> endpoints = {
    // Authentication endpoints
    'login': '/users/login',
    'register': '/users/register',
    'profile': '/users/profile',
    'refresh': '/users/refresh',
    
    // Dam endpoints
    'dams': '/dams/dam-points', // Get all dams with coordinates
    'damsByState': '/dams/dam-points/state', // Get dams by state
    'damsByRiver': '/dams/dam-points', // Get dams by river
    'damDetails': '/dams/dam', // Get dam details by ID
    'damCore': '/dams/core', // Get core dam info
    
    // State and River endpoints
    'states': '/states',
    'rivers': '/dams/rivers', // Get rivers by state
    
    // Safety endpoints
    'safety': '/safety',
    
    // Sensor endpoints
    'sensors': '/sensors',
    
    // Water usage endpoints
    'waterUsage': '/water-usage',
    
    // Water flow endpoints
    'waterFlow': '/waterflow',
    
    // Supporting info endpoints
    'supportingInfo': '/supporting-info',
    
    // Features endpoints
    'features': '/features',
    
    // User saved dams
    'savedDams': '/users/saved-dams',
    'toggleSavedDam': '/users/saved-dams',
  };
  
  /// API headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'Apadamitra-Mobile-App/1.0',
  };
  
  /// Request timeout settings
  static const Duration requestTimeout = Duration(seconds: 15);
  static const Duration healthCheckTimeout = Duration(seconds: 5);
  
  /// Health check interval (how often to check if website is available)
  static const Duration healthCheckInterval = Duration(minutes: 5);
  
  /// Location sharing settings (your backend doesn't have this yet, will use Supabase)
  static const Duration locationShareInterval = Duration(minutes: 5);
  static const bool enableAutoLocationShare = true;
  
  /// Data sync settings
  static const Duration dataSyncInterval = Duration(minutes: 10);
  static const bool enableAutoDataSync = true;
  
  /// Authentication settings
  static const bool enableSSO = true;
  static const bool enableAutoLogin = true;
  
  /// Token settings (based on your backend JWT config)
  static const Duration accessTokenExpiry = Duration(minutes: 15);
  static const Duration refreshTokenExpiry = Duration(days: 7);
  
  /// Fallback settings
  static const bool enableFallbackToSupabase = true;
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  
  /// Debug settings
  static const bool enableDebugLogs = true;
  static const bool enableNetworkLogs = false;
  
  /// Feature flags
  static const Map<String, bool> features = {
    'location_sharing': false, // Not implemented in website backend yet
    'data_sync': true,
    'sso_login': true,
    'emergency_alerts': true,
    'real_time_updates': true,
    'offline_mode': true,
    'saved_dams': true,
  };
  
  /// Get full API URL for an endpoint
  static String getApiUrl(String endpoint) {
    final endpointPath = endpoints[endpoint] ?? endpoint;
    return '$apiBaseUrl$endpointPath';
  }
  
  /// Check if a feature is enabled
  static bool isFeatureEnabled(String feature) {
    return features[feature] ?? false;
  }
  
  /// Get request headers with optional auth token
  static Map<String, String> getHeaders({String? authToken}) {
    final headers = Map<String, String>.from(defaultHeaders);
    if (authToken != null && authToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }
}

/// Website API Response Models (based on your backend responses)
class WebsiteApiResponse {
  final bool success;
  final String? message;
  final dynamic data;
  final String? error;
  final String? token;
  final WebsiteUser? user;
  
  WebsiteApiResponse({
    required this.success,
    this.message,
    this.data,
    this.error,
    this.token,
    this.user,
  });
  
  factory WebsiteApiResponse.fromJson(Map<String, dynamic> json) {
    return WebsiteApiResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'],
      error: json['error'],
      token: json['token'],
      user: json['user'] != null ? WebsiteUser.fromJson(json['user']) : null,
    );
  }
}

/// Website User Model (based on your User schema)
class WebsiteUser {
  final String id;
  final String name;
  final String email;
  final String? mobile;
  final String? place;
  final String? state;
  final String role;
  final String? profileImage;
  final List<String>? savedDams;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  WebsiteUser({
    required this.id,
    required this.name,
    required this.email,
    this.mobile,
    this.place,
    this.state,
    required this.role,
    this.profileImage,
    this.savedDams,
    this.createdAt,
    this.updatedAt,
  });
  
  factory WebsiteUser.fromJson(Map<String, dynamic> json) {
    return WebsiteUser(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'],
      place: json['place'],
      state: json['state'],
      role: json['role'] ?? 'user',
      profileImage: json['profileImage'],
      savedDams: json['savedDams'] != null 
        ? List<String>.from(json['savedDams'].map((x) => x.toString()))
        : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'place': place,
      'state': state,
      'role': role,
      'profileImage': profileImage,
      'savedDams': savedDams,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

/// Website Dam Model (based on your Dam schema)
class WebsiteDam {
  final String id;
  final String name;
  final String? state;
  final String? riverName;
  final String? river;
  final DamCoordinates? coordinates;
  final String? damType;
  final String? constructionYear;
  final String? operator;
  final double? maxStorage;
  final double? liveStorage;
  final double? deadStorage;
  final String? catchmentArea;
  final String? surfaceArea;
  final String? height;
  final String? length;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  WebsiteDam({
    required this.id,
    required this.name,
    this.state,
    this.riverName,
    this.river,
    this.coordinates,
    this.damType,
    this.constructionYear,
    this.operator,
    this.maxStorage,
    this.liveStorage,
    this.deadStorage,
    this.catchmentArea,
    this.surfaceArea,
    this.height,
    this.length,
    this.createdAt,
    this.updatedAt,
  });
  
  factory WebsiteDam.fromJson(Map<String, dynamic> json) {
    return WebsiteDam(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      state: json['state'],
      riverName: json['riverName'],
      river: json['river'],
      coordinates: json['coordinates'] != null 
        ? DamCoordinates.fromJson(json['coordinates'])
        : null,
      damType: json['damType'],
      constructionYear: json['constructionYear'],
      operator: json['operator'],
      maxStorage: json['maxStorage']?.toDouble(),
      liveStorage: json['liveStorage']?.toDouble(),
      deadStorage: json['deadStorage']?.toDouble(),
      catchmentArea: json['catchmentArea'],
      surfaceArea: json['surfaceArea'],
      height: json['height'],
      length: json['length'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

class DamCoordinates {
  final double lat;
  final double lng;
  
  DamCoordinates({required this.lat, required this.lng});
  
  factory DamCoordinates.fromJson(Map<String, dynamic> json) {
    return DamCoordinates(
      lat: json['lat']?.toDouble() ?? 0.0,
      lng: json['lng']?.toDouble() ?? 0.0,
    );
  }
}
