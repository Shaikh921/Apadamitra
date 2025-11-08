import 'package:riverwise/models/user_model.dart';
import 'package:riverwise/supabase/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> initialize() async {
    final session = SupabaseConfig.auth.currentSession;
    if (session != null) {
      await _loadCurrentUser(session.user.id);
    }
  }

  Future<UserModel> signIn(String email, String password) async {
    try {
      final response = await SupabaseConfig.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign in failed');
      }

      await _loadCurrentUser(response.user!.id);
      return _currentUser!;
    } on AuthException catch (e) {
      throw Exception('Authentication failed: ${e.message}');
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  Future<UserModel> signUp(String email, String password, String name) async {
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
      } catch (e) {
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

        await SupabaseService.insert('users', userData);
        await _loadCurrentUser(response.user!.id);
      }

      return _currentUser!;
    } on AuthException catch (e) {
      throw Exception('Sign up failed: ${e.message}');
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    await SupabaseConfig.auth.signOut();
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
