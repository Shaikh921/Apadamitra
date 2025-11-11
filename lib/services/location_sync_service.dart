import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:riverwise/services/backend_manager.dart';
import 'package:riverwise/supabase/supabase_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for syncing user location between app and website
class LocationSyncService {
  static const String _locationSharingKey = 'location_sharing_enabled';
  static const String _lastLocationKey = 'last_shared_location';
  static Timer? _locationTimer;
  static bool _isSharing = false;
  
  /// Start automatic location sharing
  static Future<bool> startLocationSharing({
    Duration interval = const Duration(minutes: 5),
  }) async {
    try {
      // Check permissions
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied) {
          return false;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return false;
      }
      
      // Save preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_locationSharingKey, true);
      
      _isSharing = true;
      
      // Start periodic location sharing
      _locationTimer = Timer.periodic(interval, (timer) async {
        await _shareCurrentLocation();
      });
      
      // Share location immediately
      await _shareCurrentLocation();
      
      return true;
    } catch (e) {
      print('Failed to start location sharing: $e');
      return false;
    }
  }
  
  /// Stop location sharing
  static Future<void> stopLocationSharing() async {
    _locationTimer?.cancel();
    _locationTimer = null;
    _isSharing = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_locationSharingKey, false);
  }
  
  /// Check if location sharing is enabled
  static Future<bool> isLocationSharingEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_locationSharingKey) ?? false;
  }
  
  /// Share current location
  static Future<bool> _shareCurrentLocation() async {
    try {
      if (!_isSharing) return false;
      
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      final currentUser = SupabaseConfig.auth.currentUser;
      if (currentUser == null) return false;
      
      // Share to website backend
      final websiteSuccess = await BackendManager.shareLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        userId: currentUser.id,
      );
      
      // Also store in Supabase as backup
      await _storeLocationInSupabase(position, currentUser.id);
      
      // Save last shared location
      await _saveLastLocation(position);
      
      print('Location shared: ${position.latitude}, ${position.longitude}');
      return websiteSuccess;
    } catch (e) {
      print('Failed to share location: $e');
      return false;
    }
  }
  
  /// Store location in Supabase
  static Future<void> _storeLocationInSupabase(Position position, String userId) async {
    try {
      await SupabaseService.insert('user_locations', {
        'user_id': userId,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'altitude': position.altitude,
        'speed': position.speed,
        'heading': position.heading,
        'timestamp': DateTime.now().toIso8601String(),
        'source': 'mobile_app',
      });
    } catch (e) {
      print('Failed to store location in Supabase: $e');
    }
  }
  
  /// Save last shared location
  static Future<void> _saveLastLocation(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLocationKey, 
      '${position.latitude},${position.longitude},${DateTime.now().toIso8601String()}');
  }
  
  /// Get last shared location
  static Future<Map<String, dynamic>?> getLastSharedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationString = prefs.getString(_lastLocationKey);
      
      if (locationString != null) {
        final parts = locationString.split(',');
        if (parts.length >= 3) {
          return {
            'latitude': double.parse(parts[0]),
            'longitude': double.parse(parts[1]),
            'timestamp': parts[2],
          };
        }
      }
      return null;
    } catch (e) {
      print('Failed to get last location: $e');
      return null;
    }
  }
  
  /// Share location once (manual)
  static Future<bool> shareLocationOnce() async {
    return await _shareCurrentLocation();
  }
  
  /// Get user locations from website
  static Future<List<Map<String, dynamic>>> getUserLocationsFromWebsite({
    String? userId,
    int limit = 50,
  }) async {
    try {
      final response = await BackendManager.apiCall(
        endpoint: '/users/locations',
        method: 'GET',
        data: {
          'user_id': userId ?? SupabaseConfig.auth.currentUser?.id,
          'limit': limit,
        },
      );
      
      if (response['success'] == true && response['data'] is List) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      return [];
    } catch (e) {
      print('Failed to get locations from website: $e');
      return [];
    }
  }
  
  /// Initialize location sharing on app start
  static Future<void> initializeLocationSharing() async {
    final isEnabled = await isLocationSharingEnabled();
    if (isEnabled) {
      await startLocationSharing();
    }
  }
  
  /// Get location sharing status
  static Map<String, dynamic> getLocationSharingStatus() {
    return {
      'is_sharing': _isSharing,
      'timer_active': _locationTimer?.isActive ?? false,
      'next_share': _locationTimer != null 
        ? DateTime.now().add(const Duration(minutes: 5)).toIso8601String()
        : null,
    };
  }
  
  /// Emergency location share (high priority)
  static Future<bool> emergencyLocationShare() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 5),
      );
      
      final currentUser = SupabaseConfig.auth.currentUser;
      if (currentUser == null) return false;
      
      // Share to both backends immediately
      final websiteTask = BackendManager.shareLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        userId: currentUser.id,
      );
      
      final supabaseTask = _storeLocationInSupabase(position, currentUser.id);
      
      // Wait for both to complete
      await Future.wait([websiteTask, supabaseTask]);
      
      return true;
    } catch (e) {
      print('Emergency location share failed: $e');
      return false;
    }
  }
}