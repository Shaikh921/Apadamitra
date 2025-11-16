import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Apadamitra/supabase/supabase_config.dart';
import 'package:Apadamitra/config/website_config.dart';

/// Backend Manager that handles primary website backend and fallback to Supabase
class BackendManager {
  static String get _websiteBaseUrl => WebsiteConfig.apiBaseUrl;
  static Duration get _timeout => WebsiteConfig.requestTimeout;
  
  static bool _isWebsiteAvailable = true;
  static DateTime? _lastHealthCheck;
  
  /// Check if website backend is available
  static Future<bool> _checkWebsiteHealth() async {
    // Cache health check for 5 minutes
    if (_lastHealthCheck != null && 
        DateTime.now().difference(_lastHealthCheck!).inMinutes < 5) {
      return _isWebsiteAvailable;
    }
    
    try {
      // Try to access the states endpoint as a health check (since /health doesn't exist)
      final response = await http.get(
        Uri.parse('${WebsiteConfig.getApiUrl('states')}'),
        headers: WebsiteConfig.defaultHeaders,
      ).timeout(WebsiteConfig.healthCheckTimeout);
      
      _isWebsiteAvailable = response.statusCode == 200;
      _lastHealthCheck = DateTime.now();
      return _isWebsiteAvailable;
    } catch (e) {
      print('Website backend unavailable: $e');
      _isWebsiteAvailable = false;
      _lastHealthCheck = DateTime.now();
      return false;
    }
  }
  
  /// Generic API call with fallback
  static Future<Map<String, dynamic>> apiCall({
    required String endpoint,
    required String method,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    bool forceSupabase = false,
  }) async {
    if (!forceSupabase && await _checkWebsiteHealth()) {
      try {
        return await _callWebsiteAPI(endpoint, method, data, headers);
      } catch (e) {
        print('Website API failed, falling back to Supabase: $e');
        return await _callSupabaseAPI(endpoint, method, data);
      }
    } else {
      return await _callSupabaseAPI(endpoint, method, data);
    }
  }
  
  /// Call website backend API
  static Future<Map<String, dynamic>> _callWebsiteAPI(
    String endpoint,
    String method,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  ) async {
    // Get the full URL using WebsiteConfig
    final uri = Uri.parse('$_websiteBaseUrl$endpoint');
    final defaultHeaders = WebsiteConfig.getHeaders(authToken: headers?['Authorization']?.replaceFirst('Bearer ', ''));
    
    http.Response response;
    
    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(uri, headers: defaultHeaders).timeout(_timeout);
        break;
      case 'POST':
        response = await http.post(
          uri,
          headers: defaultHeaders,
          body: data != null ? jsonEncode(data) : null,
        ).timeout(_timeout);
        break;
      case 'PUT':
        response = await http.put(
          uri,
          headers: defaultHeaders,
          body: data != null ? jsonEncode(data) : null,
        ).timeout(_timeout);
        break;
      case 'DELETE':
        response = await http.delete(uri, headers: defaultHeaders).timeout(_timeout);
        break;
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Website API error: ${response.statusCode} - ${response.body}');
    }
  }
  
  /// Call Supabase API (fallback)
  static Future<Map<String, dynamic>> _callSupabaseAPI(
    String endpoint,
    String method,
    Map<String, dynamic>? data,
  ) async {
    // Map website endpoints to Supabase operations
    if (endpoint.contains('/users/profile')) {
      if (method == 'GET') {
        final user = SupabaseConfig.auth.currentUser;
        if (user != null) {
          final profile = await SupabaseService.selectSingle(
            'profiles',
            filters: {'id': user.id},
          );
          return {'success': true, 'data': profile};
        }
      }
    } else if (endpoint.contains('/users/location')) {
      if (method == 'POST' && data != null) {
        await SupabaseService.insert('user_locations', data);
        return {'success': true, 'message': 'Location updated'};
      }
    } else if (endpoint.contains('/dams') || endpoint.contains('/dam-points')) {
      if (method == 'GET') {
        final dams = await SupabaseService.select('dams');
        return {'success': true, 'data': dams};
      }
    } else if (endpoint.contains('/alerts')) {
      if (method == 'GET') {
        final alerts = await SupabaseService.select('alerts');
        return {'success': true, 'data': alerts};
      }
    } else if (endpoint.contains('/states')) {
      if (method == 'GET') {
        // Return states from Supabase or hardcoded list
        return {
          'success': true,
          'data': [
            {'id': '1', 'name': 'Maharashtra'},
            {'id': '2', 'name': 'Karnataka'},
            {'id': '3', 'name': 'Tamil Nadu'},
            {'id': '4', 'name': 'Andhra Pradesh'},
            {'id': '5', 'name': 'Telangana'},
          ]
        };
      }
    }
    
    throw Exception('Endpoint not supported in fallback mode: $endpoint');
  }
  
  /// Share user location to website
  static Future<bool> shareLocation({
    required double latitude,
    required double longitude,
    String? userId,
  }) async {
    try {
      final response = await apiCall(
        endpoint: '/users/location',
        method: 'POST',
        data: {
          'user_id': userId ?? SupabaseConfig.auth.currentUser?.id,
          'latitude': latitude,
          'longitude': longitude,
          'timestamp': DateTime.now().toIso8601String(),
          'source': 'mobile_app',
        },
      );
      return response['success'] == true;
    } catch (e) {
      print('Failed to share location: $e');
      return false;
    }
  }
  
  /// Fetch data from website
  static Future<List<Map<String, dynamic>>> fetchWebsiteData(String dataType) async {
    try {
      final response = await apiCall(
        endpoint: '/$dataType',
        method: 'GET',
      );
      
      if (response['success'] == true && response['data'] is List) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      return [];
    } catch (e) {
      print('Failed to fetch $dataType: $e');
      return [];
    }
  }
  
  /// Check if user is registered on website
  static Future<Map<String, dynamic>?> checkWebsiteRegistration(String email) async {
    try {
      final response = await apiCall(
        endpoint: '/users/check',
        method: 'POST',
        data: {'email': email},
      );
      
      if (response['success'] == true) {
        return response['user'];
      }
      return null;
    } catch (e) {
      print('Failed to check website registration: $e');
      return null;
    }
  }
  
  /// Sync user data between website and app
  static Future<bool> syncUserData() async {
    try {
      final currentUser = SupabaseConfig.auth.currentUser;
      if (currentUser == null) return false;
      
      // Check if user exists on website
      final websiteUser = await checkWebsiteRegistration(currentUser.email!);
      
      if (websiteUser != null) {
        // Sync profile data
        await SupabaseService.update(
          'profiles',
          {
            'website_user_id': websiteUser['id'],
            'synced_at': DateTime.now().toIso8601String(),
            'sync_status': 'synced',
          },
          filters: {'id': currentUser.id},
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Failed to sync user data: $e');
      return false;
    }
  }
  
  /// Get backend status
  static Future<Map<String, dynamic>> getBackendStatus() async {
    final websiteAvailable = await _checkWebsiteHealth();
    return {
      'website_backend': websiteAvailable ? 'available' : 'unavailable',
      'supabase_backend': 'available', // Assuming Supabase is always available
      'primary_backend': websiteAvailable ? 'website' : 'supabase',
      'last_health_check': _lastHealthCheck?.toIso8601String(),
    };
  }
}
