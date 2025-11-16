import 'package:Apadamitra/models/dam_model.dart';
import 'package:Apadamitra/supabase/supabase_config.dart';
import 'package:Apadamitra/services/backend_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DamService {
  static final DamService _instance = DamService._internal();
  factory DamService() => _instance;
  DamService._internal();

  static const String _websiteBaseUrl = 'https://river-water-management-and-life-safety.onrender.com';

  Future<void> initialize() async {
    // No initialization needed
  }

  Future<List<DamModel>> getAll() async {
    // PRIORITY 1: Try website backend first
    try {
      print('🌐 Fetching dams from website backend...');
      final response = await http.get(
        Uri.parse('$_websiteBaseUrl/api/dams/dam-points'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('✅ Loaded ${data.length} dams from website backend');
        
        // Convert website format to DamModel
        final dams = data.map((json) {
          return DamModel(
            id: json['_id'] ?? '',
            name: json['name'] ?? 'Unknown Dam',
            stateName: json['state'] ?? '',
            riverName: json['river'] ?? '',
            latitude: _parseCoordinate(json['coordinates'], 0),
            longitude: _parseCoordinate(json['coordinates'], 1),
            heightMeters: 0.0, // Not provided by website API
            capacityMcm: 0.0, // Not provided by website API
            currentStorageMcm: 0.0, // Not provided by website API
            managingAgency: 'Unknown',
            contactNumber: null,
            safetyStatus: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }).toList();
        
        return dams;
      } else {
        print('⚠️ Website backend returned status: ${response.statusCode}');
        throw Exception('Website backend error');
      }
    } catch (e) {
      print('❌ Website backend failed: $e');
      print('🔄 Falling back to Supabase...');
    }

    // PRIORITY 2: Fallback to Supabase
    try {
      print('📡 Fetching dams from Supabase...');
      final data = await SupabaseService.select('dams', orderBy: 'name');
      print('✅ Loaded ${data.length} dams from Supabase');
      return data.map((json) => DamModel.fromJson(json)).toList();
    } catch (e) {
      print('❌ Supabase failed: $e');
      throw Exception('Failed to load dams from both sources: ${e.toString()}');
    }
  }

  double _parseCoordinate(dynamic coordinates, int index) {
    if (coordinates == null) return 0.0;
    
    if (coordinates is List && coordinates.length > index) {
      return (coordinates[index] as num).toDouble();
    }
    
    if (coordinates is String) {
      final parts = coordinates.split(',');
      if (parts.length > index) {
        return double.tryParse(parts[index].trim()) ?? 0.0;
      }
    }
    
    return 0.0;
  }



  Future<List<String>> getStates() async {
    // PRIORITY 1: Try website backend first
    try {
      print('🌐 Fetching states from website backend...');
      final response = await http.get(
        Uri.parse('$_websiteBaseUrl/api/dams/states'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('✅ Loaded ${data.length} states from website backend');
        return data.map((state) => state['name'] as String).toList()..sort();
      }
    } catch (e) {
      print('❌ Website backend failed: $e');
      print('🔄 Falling back to local data...');
    }

    // PRIORITY 2: Fallback to getting states from dams
    try {
      final dams = await getAll();
      return dams.map((d) => d.stateName).toSet().toList()..sort();
    } catch (e) {
      throw Exception('Failed to load states: ${e.toString()}');
    }
  }

  Future<List<String>> getRiversByState(String state) async {
    try {
      final dams = await getAll();
      return dams.where((d) => d.stateName == state).map((d) => d.riverName).toSet().toList()..sort();
    } catch (e) {
      throw Exception('Failed to load rivers: ${e.toString()}');
    }
  }

  Future<List<DamModel>> getDamsByStateAndRiver(String state, String river) async {
    try {
      dynamic query = SupabaseConfig.client
          .from('dams')
          .select()
          .eq('state_name', state)
          .eq('river_name', river);

      final data = await query as List<dynamic>;
      return data.map((json) => DamModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to load dams: ${e.toString()}');
    }
  }

  Future<DamModel?> getById(String id) async {
    // PRIORITY 1: Try website backend first
    try {
      print('🌐 Fetching dam details from website backend...');
      final response = await http.get(
        Uri.parse('$_websiteBaseUrl/api/dams/dam/$id'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('✅ Loaded dam details from website backend');
        
        return DamModel(
          id: json['_id'] ?? id,
          name: json['name'] ?? 'Unknown Dam',
          stateName: json['state'] ?? '',
          riverName: json['river'] ?? '',
          latitude: _parseCoordinate(json['coordinates'], 0),
          longitude: _parseCoordinate(json['coordinates'], 1),
          capacity: (json['capacity'] as num?)?.toDouble() ?? 0.0,
          currentStorage: (json['currentStorage'] as num?)?.toDouble() ?? 0.0,
          lastUpdated: DateTime.now(),
        );
      } else if (response.statusCode == 404) {
        print('⚠️ Dam not found on website backend');
        return null;
      }
    } catch (e) {
      print('❌ Website backend failed: $e');
      print('🔄 Falling back to Supabase...');
    }

    // PRIORITY 2: Fallback to Supabase
    try {
      print('📡 Fetching dam from Supabase...');
      final data = await SupabaseService.selectSingle('dams', filters: {'id': id});
      if (data == null) {
        print('⚠️ Dam not found in Supabase');
        return null;
      }
      print('✅ Loaded dam from Supabase');
      return DamModel.fromJson(data);
    } catch (e) {
      print('❌ Supabase failed: $e');
      throw Exception('Failed to load dam: ${e.toString()}');
    }
  }

  Future<DamModel> update(DamModel dam) async {
    try {
      final result = await SupabaseService.update(
        'dams',
        dam.toJson(),
        filters: {'id': dam.id},
      );
      return DamModel.fromJson(result.first);
    } catch (e) {
      throw Exception('Failed to update dam: ${e.toString()}');
    }
  }

  Future<void> insertDam(Map<String, dynamic> damData) async {
    try {
      await SupabaseService.insert('dams', damData);
      print('Dam inserted successfully');
    } catch (e) {
      print('Error inserting dam: $e');
      throw Exception('Failed to insert dam: ${e.toString()}');
    }
  }

  Future<void> deleteDam(String id) async {
    try {
      await SupabaseService.delete('dams', filters: {'id': id});
      print('Dam deleted successfully');
    } catch (e) {
      throw Exception('Failed to delete dam: ${e.toString()}');
    }
  }
}
