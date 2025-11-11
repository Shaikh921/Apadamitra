import 'dart:io';
import 'package:http/http.dart' as http;

/// Simple connectivity checker
class ConnectivityChecker {
  /// Check if device has internet connection
  static Future<bool> hasInternetConnection() async {
    try {
      // Try to reach Google's DNS
      final result = await InternetAddress.lookup('google.com').timeout(
        const Duration(seconds: 5),
      );
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      print('Internet check failed: $e');
      return false;
    }
  }

  /// Check if Supabase is reachable
  static Future<bool> canReachSupabase(String supabaseUrl) async {
    try {
      final response = await http.get(Uri.parse(supabaseUrl)).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode < 500;
    } catch (e) {
      print('Supabase check failed: $e');
      return false;
    }
  }

  /// Check if website backend is reachable
  static Future<bool> canReachWebsite(String websiteUrl) async {
    try {
      final response = await http.get(Uri.parse(websiteUrl)).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode < 500;
    } catch (e) {
      print('Website check failed: $e');
      return false;
    }
  }

  /// Get connectivity status
  static Future<Map<String, dynamic>> getConnectivityStatus({
    String? supabaseUrl,
    String? websiteUrl,
  }) async {
    final hasInternet = await hasInternetConnection();
    
    if (!hasInternet) {
      return {
        'has_internet': false,
        'can_reach_supabase': false,
        'can_reach_website': false,
        'message': 'No internet connection',
      };
    }

    final canReachSupa = supabaseUrl != null 
        ? await canReachSupabase(supabaseUrl)
        : false;
    
    final canReachWeb = websiteUrl != null
        ? await canReachWebsite(websiteUrl)
        : false;

    return {
      'has_internet': true,
      'can_reach_supabase': canReachSupa,
      'can_reach_website': canReachWeb,
      'message': canReachSupa || canReachWeb
          ? 'Connected'
          : 'Cannot reach servers',
    };
  }
}
