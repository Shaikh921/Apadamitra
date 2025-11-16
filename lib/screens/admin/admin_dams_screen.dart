import 'package:flutter/material.dart';
import 'package:Apadamitra/models/dam_model.dart';
import 'package:Apadamitra/services/dam_service.dart';

class AdminDamsScreen extends StatefulWidget {
  const AdminDamsScreen({super.key});

  @override
  State<AdminDamsScreen> createState() => _AdminDamsScreenState();
}

class _AdminDamsScreenState extends State<AdminDamsScreen> {
  final _damService = DamService();
  List<DamModel> _dams = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDams();
  }

  Future<void> _loadDams() async {
    setState(() => _isLoading = true);
    try {
      final dams = await _damService.getAll();
      setState(() {
        _dams = dams;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showDamDetails(DamModel dam) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dam.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('State', dam.stateName),
              _buildDetailRow('River', dam.riverName),
              _buildDetailRow('Location', '${dam.latitude}, ${dam.longitude}'),
              _buildDetailRow('Height', '${dam.heightMeters} m'),
              _buildDetailRow('Capacity', '${dam.capacityMcm} MCM'),
              _buildDetailRow('Current Storage', '${dam.currentStorageMcm} MCM'),
              _buildDetailRow('Storage %', '${dam.storagePercentage.toStringAsFixed(1)}%'),
              _buildDetailRow('Managing Agency', dam.managingAgency),
              if (dam.contactNumber != null)
                _buildDetailRow('Contact', dam.contactNumber!),
              _buildDetailRow('Safety Status', dam.safetyStatus ?? 'Unknown'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showEditDamDialog(dam);
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showEditDamDialog(DamModel dam) {
    final nameController = TextEditingController(text: dam.name);
    final stateController = TextEditingController(text: dam.stateName);
    final riverController = TextEditingController(text: dam.riverName);
    final latController = TextEditingController(text: dam.latitude.toString());
    final lonController = TextEditingController(text: dam.longitude.toString());
    final heightController = TextEditingController(text: dam.heightMeters.toString());
    final capacityController = TextEditingController(text: dam.capacityMcm.toString());
    final currentStorageController = TextEditingController(text: dam.currentStorageMcm.toString());
    final agencyController = TextEditingController(text: dam.managingAgency);
    final contactController = TextEditingController(text: dam.contactNumber ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Dam'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Dam Name*')),
              TextField(controller: stateController, decoration: const InputDecoration(labelText: 'State*')),
              TextField(controller: riverController, decoration: const InputDecoration(labelText: 'River*')),
              TextField(controller: latController, decoration: const InputDecoration(labelText: 'Latitude*'), keyboardType: TextInputType.number),
              TextField(controller: lonController, decoration: const InputDecoration(labelText: 'Longitude*'), keyboardType: TextInputType.number),
              TextField(controller: heightController, decoration: const InputDecoration(labelText: 'Height (m)*'), keyboardType: TextInputType.number),
              TextField(controller: capacityController, decoration: const InputDecoration(labelText: 'Capacity (MCM)*'), keyboardType: TextInputType.number),
              TextField(controller: currentStorageController, decoration: const InputDecoration(labelText: 'Current Storage (MCM)*'), keyboardType: TextInputType.number),
              TextField(controller: agencyController, decoration: const InputDecoration(labelText: 'Managing Agency*')),
              TextField(controller: contactController, decoration: const InputDecoration(labelText: 'Contact Number')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                final updatedDam = dam.copyWith(
                  name: nameController.text,
                  stateName: stateController.text,
                  riverName: riverController.text,
                  latitude: double.tryParse(latController.text) ?? dam.latitude,
                  longitude: double.tryParse(lonController.text) ?? dam.longitude,
                  heightMeters: double.tryParse(heightController.text) ?? dam.heightMeters,
                  capacityMcm: double.tryParse(capacityController.text) ?? dam.capacityMcm,
                  currentStorageMcm: double.tryParse(currentStorageController.text) ?? dam.currentStorageMcm,
                  managingAgency: agencyController.text,
                  contactNumber: contactController.text.isEmpty ? null : contactController.text,
                  updatedAt: DateTime.now(),
                );

                await _damService.update(updatedDam);
                Navigator.pop(context);
                _loadDams();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dam updated successfully!'), backgroundColor: Colors.green),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(DamModel dam) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Dam'),
        content: Text('Are you sure you want to delete ${dam.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _damService.deleteDam(dam.id);
                Navigator.pop(context);
                _loadDams();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dam deleted successfully!'), backgroundColor: Colors.green),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddDamDialog() {
    final nameController = TextEditingController();
    final stateController = TextEditingController();
    final riverController = TextEditingController();
    final latController = TextEditingController();
    final lonController = TextEditingController();
    final heightController = TextEditingController();
    final capacityController = TextEditingController();
    final currentStorageController = TextEditingController();
    final agencyController = TextEditingController();
    final contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Dam'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Dam Name*')),
              TextField(controller: stateController, decoration: const InputDecoration(labelText: 'State*')),
              TextField(controller: riverController, decoration: const InputDecoration(labelText: 'River*')),
              TextField(controller: latController, decoration: const InputDecoration(labelText: 'Latitude*'), keyboardType: TextInputType.number),
              TextField(controller: lonController, decoration: const InputDecoration(labelText: 'Longitude*'), keyboardType: TextInputType.number),
              TextField(controller: heightController, decoration: const InputDecoration(labelText: 'Height (m)*'), keyboardType: TextInputType.number),
              TextField(controller: capacityController, decoration: const InputDecoration(labelText: 'Capacity (MCM)*'), keyboardType: TextInputType.number),
              TextField(controller: currentStorageController, decoration: const InputDecoration(labelText: 'Current Storage (MCM)*'), keyboardType: TextInputType.number),
              TextField(controller: agencyController, decoration: const InputDecoration(labelText: 'Managing Agency*')),
              TextField(controller: contactController, decoration: const InputDecoration(labelText: 'Contact Number')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty || stateController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill required fields')),
                );
                return;
              }

              try {
                final now = DateTime.now();
                final damData = {
                  'name': nameController.text,
                  'state_name': stateController.text,
                  'river_name': riverController.text,
                  'latitude': double.tryParse(latController.text) ?? 0.0,
                  'longitude': double.tryParse(lonController.text) ?? 0.0,
                  'height_meters': double.tryParse(heightController.text) ?? 0.0,
                  'capacity_mcm': double.tryParse(capacityController.text) ?? 0.0,
                  'current_storage_mcm': double.tryParse(currentStorageController.text) ?? 0.0,
                  'managing_agency': agencyController.text,
                  'contact_number': contactController.text,
                  'safety_status': 'Safe',
                  'created_at': now.toIso8601String(),
                  'updated_at': now.toIso8601String(),
                };

                await _damService.insertDam(damData);
                Navigator.pop(context);
                _loadDams();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dam added successfully!'), backgroundColor: Colors.green),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Add Dam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dam Management'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDams,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dams.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.water_drop_outlined, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text('No dams found', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Add your first dam', style: theme.textTheme.bodyMedium),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _dams.length,
                  itemBuilder: (context, index) {
                    final dam = _dams[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(Icons.water, color: theme.colorScheme.primary),
                        title: Text(dam.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${dam.stateName} • ${dam.riverName}\nStorage: ${dam.storagePercentage.toStringAsFixed(1)}%'),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showEditDamDialog(dam);
                            } else if (value == 'delete') {
                              _showDeleteConfirmation(dam);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () => _showDamDetails(dam),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDamDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Dam'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
