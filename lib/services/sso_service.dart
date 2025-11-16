import 'package:Apadamitra/services/backend_manager.dart';
import 'package:Apadamitra/supabase/supabase_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Single Sign-On service for website and app integration
class SSOService {
  static const String _websiteTokenKey = 'website_auth_token';
  static const String _websiteUserKey = 'website_user_data';
  
  /// Check if user is logged in to website and auto-login to app
  static Future<bool> attemptWebsiteSSO(String email, String password) async {
    try {
      print('🌐 Attempting website authentication...');
      // First, try to authenticate with website
      final websiteAuth = await _authenticateWithWebsite(email, password);
      
      print('📦 Website auth response: ${websiteAuth['success']}');
      
      if (websiteAuth['success'] == true) {
        print('✅ Website authentication successful');
        // Store website auth data
        await _storeWebsiteAuth(websiteAuth);
        
        // Check if user exists in Supabase
        print('🔍 Checking if user exists in Supabase...');
        final supabaseUser = await _getSupabaseUser(email);
        
        if (supabaseUser != null) {
          print('👤 User exists in Supabase, signing in...');
          // User exists, sign in to Supabase
          try {
            await SupabaseConfig.auth.signInWithPassword(
              email: email,
              password: password,
            );
            print('✅ Supabase sign-in successful');
          } catch (e) {
            print('⚠️ Supabase sign-in failed (user exists but wrong password): $e');
            // User exists but password might be different
            // This is okay, we'll use website auth
          }
        } else {
          print('➕ User does not exist in Supabase, creating...');
          // Create user in Supabase
          try {
            await _createSupabaseUser(email, password, websiteAuth['user'] ?? {});
            print('✅ User created in Supabase');
          } catch (e) {
            print('⚠️ Failed to create user in Supabase: $e');
            // This is okay, we can still use website auth
          }
        }
        
        // Sync user data
        try {
          await BackendManager.syncUserData();
          print('✅ User data synced');
        } catch (e) {
          print('⚠️ Failed to sync user data: $e');
        }
        
        return true;
      }
      print('❌ Website authentication failed');
      return false;
    } catch (e) {
      print('❌ SSO authentication failed: $e');
      return false;
    }
  }
  
  /// Authenticate with website backend
  static Future<Map<String, dynamic>> _authenticateWithWebsite(
    String email,
    String password,
  ) async {
    return await BackendManager.apiCall(
      endpoint: '/users/login',
      method: 'POST',
      data: {
        'email': email,
        'password': password,
      },
    );
  }
  
  /// Store website authentication data
  static Future<void> _storeWebsiteAuth(Map<String, dynamic> authData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_websiteTokenKey, authData['token'] ?? '');
    await prefs.setString(_websiteUserKey, authData['user'].toString());
  }
  
  /// Get website authentication token
  static Future<String?> getWebsiteToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_websiteTokenKey);
  }
  
  /// Check if user exists in Supabase
  static Future<Map<String, dynamic>?> _getSupabaseUser(String email) async {
    try {
      return await SupabaseService.selectSingle(
        'profiles',
        filters: {'email': email},
      );
    } catch (e) {
      return null;
    }
  }
  
  /// Create user in Supabase from website data
  static Future<void> _createSupabaseUser(
    String email,
    String password,
    Map<String, dynamic> websiteUser,
  ) async {
    try {
      print('📝 Creating Supabase user for: $email');
      // Sign up user in Supabase
      final authResponse = await SupabaseConfig.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': websiteUser['name'] ?? email.split('@')[0],
        },
      );
      
      if (authResponse.user != null) {
        print('✅ Supabase user created with ID: ${authResponse.user!.id}');
        
        // Wait for trigger to create profile
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Update profile with website data if needed
        try {
          await SupabaseConfig.client.from('users').update({
            'name': websiteUser['name'] ?? email.split('@')[0],
            'role': websiteUser['role'] ?? 'user',
            'updated_at': DateTime.now().toIso8601String(),
          }).eq('id', authResponse.user!.id);
          print('✅ Profile updated with website data');
        } catch (e) {
          print('⚠️ Could not update profile: $e');
        }
      } else {
        print('⚠️ No user returned from Supabase signup');
      }
    } catch (e) {
      print('❌ Error creating Supabase user: $e');
      throw e;
    }
  }
  
  /// Check if user is registered on website by email
  static Future<bool> isRegisteredOnWebsite(String email) async {
    try {
      // Try to get user profile with email (website doesn't have a check endpoint)
      // We'll attempt login with a dummy password to check if user exists
      // Better approach: Add a /users/check endpoint to your website backend
      final websiteUser = await BackendManager.checkWebsiteRegistration(email);
      return websiteUser != null;
    } catch (e) {
      return false;
    }
  }
  
  /// Auto-login if user is already authenticated on website
  static Future<bool> autoLoginFromWebsite() async {
    try {
      final token = await getWebsiteToken();
      if (token == null || token.isEmpty) return false;
      
      // Verify token with website
      final response = await BackendManager.apiCall(
        endpoint: '/auth/verify',
        method: 'POST',
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response['success'] == true) {
        final user = response['user'];
        
        // Try to sign in to Supabase
        final supabaseUser = await _getSupabaseUser(user['email']);
        if (supabaseUser != null) {
          // Auto sign-in (this would require a custom auth flow)
          // For now, we'll just sync the data
          await BackendManager.syncUserData();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Auto-login failed: $e');
      return false;
    }
  }
  
  /// Logout from both website and app
  static Future<void> logout() async {
    try {
      // Logout from website
      final token = await getWebsiteToken();
      if (token != null && token.isNotEmpty) {
        await BackendManager.apiCall(
          endpoint: '/auth/logout',
          method: 'POST',
          headers: {'Authorization': 'Bearer $token'},
        );
      }
      
      // Clear website auth data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_websiteTokenKey);
      await prefs.remove(_websiteUserKey);
      
      // Logout from Supabase
      await SupabaseConfig.auth.signOut();
    } catch (e) {
      print('Logout error: $e');
    }
  }
  
  /// Sync user profile between website and app
  static Future<bool> syncProfile() async {
    try {
      final token = await getWebsiteToken();
      if (token == null) return false;
      
      // Get latest profile from website
      final response = await BackendManager.apiCall(
        endpoint: '/users/profile',
        method: 'GET',
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response['success'] == true) {
        final websiteProfile = response['user'];
        final currentUser = SupabaseConfig.auth.currentUser;
        
        if (currentUser != null) {
          // Update Supabase profile
          await SupabaseService.update(
            'profiles',
            {
              'full_name': websiteProfile['name'],
              'phone': websiteProfile['phone'],
              'updated_at': DateTime.now().toIso8601String(),
              'last_sync': DateTime.now().toIso8601String(),
            },
            filters: {'id': currentUser.id},
          );
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Profile sync failed: $e');
      return false;
    }
  }
}
