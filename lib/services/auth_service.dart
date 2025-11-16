import 'package:Apadamitra/models/user_model.dart';
import 'package:Apadamitra/supabase/supabase_config.dart';
import 'package:Apadamitra/services/sso_service.dart';
import 'package:Apadamitra/services/backend_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> initialize() async {
    // Try to auto-login from website first
    try {
      final websiteAutoLogin = await SSOService.autoLoginFromWebsite();
      if (websiteAutoLogin) {
        print('Auto-logged in from website');
        return;
      }
    } catch (e) {
      print('Website auto-login failed: $e');
    }

    // Fallback to Supabase session
    try {
      final session = SupabaseConfig.auth.currentSession;
      if (session != null) {
        await _loadCurrentUser(session.user.id);
      }
    } catch (e) {
      print('Supabase session check failed: $e');
    }
  }

  Future<UserModel> signIn(String email, String password) async {
    print('🔐 Starting login for: $email');
    
    // PRIORITY 1: Try website backend first
    try {
      print('📡 Attempting login via website backend...');
      final websiteSuccess = await SSOService.attemptWebsiteSSO(email, password).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          print('⏱️ Website backend timeout');
          return false;
        },
      );
      
      if (websiteSuccess) {
        print('✅ Website login successful!');
        // Load user from Supabase (SSO should have created/synced the user)
        try {
          final session = SupabaseConfig.auth.currentSession;
          if (session != null) {
            await _loadCurrentUser(session.user.id);
            return _currentUser!;
          }
        } catch (e) {
          print('⚠️ Could not load user from Supabase after website login: $e');
        }
        
        // Create a temporary user model from website data
        final now = DateTime.now();
        _currentUser = UserModel(
          id: 'website_user',
          email: email,
          name: email.split('@')[0],
          role: UserRole.user,
          createdAt: now,
          updatedAt: now,
        );
        return _currentUser!;
      }
    } catch (e) {
      print('❌ Website login failed: $e');
      print('🔄 Falling back to Supabase...');
    }

    // PRIORITY 2: Fallback to Supabase (with timeout)
    try {
      print('📡 Attempting Supabase login...');
      final response = await SupabaseConfig.auth.signInWithPassword(
        email: email,
        password: password,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout - Please check your internet connection');
        },
      );

      if (response.user == null) {
        throw Exception('Sign in failed - no user returned');
      }

      print('✅ Supabase login successful!');
      await _loadCurrentUser(response.user!.id);
      return _currentUser!;
    } on AuthException catch (e) {
      print('❌ Supabase auth error: ${e.message}');
      // Check if it's an invalid credentials error
      if (e.message.toLowerCase().contains('invalid') || 
          e.message.toLowerCase().contains('credentials') ||
          e.message.toLowerCase().contains('password')) {
        throw Exception('Invalid email or password. Please check your credentials and try again.');
      }
      throw Exception('Authentication failed: ${e.message}');
    } catch (e) {
      print('❌ Supabase login error: $e');
      // If both backends fail, show a clear error message
      if (e.toString().contains('SocketFailed') || e.toString().contains('host lookup')) {
        throw Exception('Cannot connect to server. Please check your internet connection and try again.');
      }
      if (e.toString().contains('timeout')) {
        throw Exception('Connection timeout. Please check your internet connection and try again.');
      }
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  Future<UserModel> signUp(String email, String password, String name) async {
    // PRIORITY 1: Try website backend registration first
    try {
      print('Attempting registration via website backend...');
      final websiteSuccess = await _registerOnWebsite(email, password, name);
      
      if (websiteSuccess) {
        print('Website registration successful!');
        // Now try to login
        return await signIn(email, password);
      }
    } catch (e) {
      print('Website registration failed: $e');
      print('Falling back to Supabase registration...');
    }

    // PRIORITY 2: Fallback to Supabase
    try {
      // Sign up with user metadata
      final response = await SupabaseConfig.auth.signUp(
        email: email,
        password: password,
        data: {'name': name}, // This will be used by the trigger
      );

      if (response.user == null) {
        throw Exception('Sign up failed - no user returned');
      }

      // Wait a bit for the trigger to create the user profile
      await Future.delayed(const Duration(milliseconds: 500));

      // Try to load the user profile
      try {
        await _loadCurrentUser(response.user!.id);
        if (_currentUser == null) {
          throw Exception('User profile not found');
        }
      } catch (e) {
        print('Profile not found, creating manually: $e');
        // If trigger didn't work, manually create the profile
        final now = DateTime.now();
        final userData = {
          'id': response.user!.id,
          'email': email,
          'name': name,
          'role': 'user',
          'language_code': 'en',
          'notifications_enabled': true,
          'emergency_contacts': [],
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        };

        try {
          await SupabaseService.insert('users', userData);
          await Future.delayed(const Duration(milliseconds: 300));
          await _loadCurrentUser(response.user!.id);
        } catch (insertError) {
          print('Error inserting user: $insertError');
          throw Exception('Failed to create user profile: $insertError');
        }
      }

      if (_currentUser == null) {
        throw Exception('Failed to load user profile after creation');
      }

      return _currentUser!;
    } on AuthException catch (e) {
      throw Exception('Sign up failed: ${e.message}');
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  Future<bool> _registerOnWebsite(String email, String password, String name) async {
    try {
      final response = await BackendManager.apiCall(
        endpoint: '/users/register',
        method: 'POST',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'mobile': '',
          'place': '',
          'state': '',
          'role': 'user',
        },
      );
      
      return response['success'] == true;
    } catch (e) {
      print('Website registration error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    // Logout from website
    try {
      await SSOService.logout();
    } catch (e) {
      print('Website logout failed: $e');
    }
    
    // Logout from Supabase
    try {
      await SupabaseConfig.auth.signOut();
    } catch (e) {
      print('Supabase logout failed: $e');
    }
    
    _currentUser = null;
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await SupabaseService.update(
        'users',
        user.toJson(),
        filters: {'id': user.id},
      );
      _currentUser = user;
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
  }

  Future<void> _loadCurrentUser(String userId) async {
    try {
      final userData = await SupabaseService.selectSingle(
        'users',
        filters: {'id': userId},
      );
      
      if (userData != null) {
        _currentUser = UserModel.fromJson(userData);
      }
    } catch (e) {
      throw Exception('Failed to load user: ${e.toString()}');
    }
  }
}
