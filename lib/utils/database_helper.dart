import 'package:riverwise/supabase/supabase_config.dart';

/// Database helper for checking and seeding data
class DatabaseHelper {
  /// Check if dams table has data
  static Future<bool> hasDamsData() async {
    try {
      final data = await SupabaseService.select('dams', limit: 1);
      return data.isNotEmpty;
    } catch (e) {
      print('Error checking dams data: $e');
      return false;
    }
  }

  /// Check if alerts table has data
  static Future<bool> hasAlertsData() async {
    try {
      final data = await SupabaseService.select('alerts', limit: 1);
      return data.isNotEmpty;
    } catch (e) {
      print('Error checking alerts data: $e');
      return false;
    }
  }

  /// Get database status
  static Future<Map<String, dynamic>> getDatabaseStatus() async {
    try {
      final damsCount = await _getTableCount('dams');
      final alertsCount = await _getTableCount('alerts');
      final profilesCount = await _getTableCount('profiles');
      
      return {
        'dams': damsCount,
        'alerts': alertsCount,
        'profiles': profilesCount,
        'has_data': damsCount > 0 || alertsCount > 0,
      };
    } catch (e) {
      print('Error getting database status: $e');
      return {
        'error': e.toString(),
        'has_data': false,
      };
    }
  }

  static Future<int> _getTableCount(String table) async {
    try {
      final data = await SupabaseService.select(table);
      return data.length;
    } catch (e) {
      print('Error counting $table: $e');
      return 0;
    }
  }

  /// Seed sample dam data
  static Future<void> seedSampleDams() async {
    try {
      final hasDams = await hasDamsData();
      if (hasDams) {
        print('Dams data already exists, skipping seed');
        return;
      }

      final sampleDams = [
        {
          'name': 'Vishupuri Dam',
          'state_name': 'Maharashtra',
          'river_name': 'Godavari',
          'latitude': 19.0760,
          'longitude': 72.8777,
          'height_meters': 85.0,
          'capacity_mcm': 1000.0,
          'current_storage_mcm': 850.0,
          'managing_agency': 'Maharashtra Water Resources Department',
          'contact_number': '+91-1234567890',
          'safety_status': 'Safe',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        {
          'name': 'Koyna Dam',
          'state_name': 'Maharashtra',
          'river_name': 'Koyna',
          'latitude': 17.4000,
          'longitude': 73.7500,
          'height_meters': 103.0,
          'capacity_mcm': 2797.0,
          'current_storage_mcm': 2100.0,
          'managing_agency': 'Maharashtra State Electricity Board',
          'contact_number': '+91-2345678901',
          'safety_status': 'Safe',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        {
          'name': 'Bhandardara Dam',
          'state_name': 'Maharashtra',
          'river_name': 'Pravara',
          'latitude': 19.5500,
          'longitude': 73.7500,
          'height_meters': 46.0,
          'capacity_mcm': 300.0,
          'current_storage_mcm': 250.0,
          'managing_agency': 'Irrigation Department',
          'contact_number': '+91-3456789012',
          'safety_status': 'Safe',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      ];

      for (final dam in sampleDams) {
        await SupabaseService.insert('dams', dam);
      }

      print('Successfully seeded ${sampleDams.length} sample dams');
    } catch (e) {
      print('Error seeding sample dams: $e');
      throw Exception('Failed to seed sample dams: $e');
    }
  }

  /// Seed sample alert data
  static Future<void> seedSampleAlerts() async {
    try {
      final hasAlerts = await hasAlertsData();
      if (hasAlerts) {
        print('Alerts data already exists, skipping seed');
        return;
      }

      final now = DateTime.now();
      final sampleAlerts = [
        {
          'type': 'flood',
          'severity': 'medium',
          'title': 'Heavy Rainfall Alert',
          'message': 'Heavy rainfall expected in the next 24 hours. Please stay alert and follow safety guidelines.',
          'river_name': 'Godavari',
          'dam_name': 'Vishupuri Dam',
          'is_active': true,
          'expires_at': now.add(const Duration(days: 2)).toIso8601String(),
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        },
        {
          'type': 'damOverflow',
          'severity': 'high',
          'title': 'Dam Water Level Rising',
          'message': 'Water level at Koyna Dam is rising. Residents in downstream areas should be prepared for possible evacuation.',
          'river_name': 'Koyna',
          'dam_name': 'Koyna Dam',
          'is_active': true,
          'expires_at': now.add(const Duration(days: 3)).toIso8601String(),
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        },
      ];

      for (final alert in sampleAlerts) {
        await SupabaseService.insert('alerts', alert);
      }

      print('Successfully seeded ${sampleAlerts.length} sample alerts');
    } catch (e) {
      print('Error seeding sample alerts: $e');
      throw Exception('Failed to seed sample alerts: $e');
    }
  }

  /// Seed all sample data
  static Future<void> seedAllSampleData() async {
    try {
      print('Starting database seeding...');
      await seedSampleDams();
      await seedSampleAlerts();
      print('Database seeding completed successfully');
    } catch (e) {
      print('Error seeding database: $e');
      throw Exception('Failed to seed database: $e');
    }
  }

  /// Check and seed if needed
  static Future<void> checkAndSeedIfNeeded() async {
    try {
      final status = await getDatabaseStatus();
      print('Database status: $status');

      if (status['dams'] == 0) {
        print('No dams found, seeding sample data...');
        await seedSampleDams();
      }

      if (status['alerts'] == 0) {
        print('No alerts found, seeding sample data...');
        await seedSampleAlerts();
      }
    } catch (e) {
      print('Error in checkAndSeedIfNeeded: $e');
    }
  }
}
