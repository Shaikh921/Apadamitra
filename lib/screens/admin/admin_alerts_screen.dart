import 'package:flutter/material.dart';
import 'package:Apadamitra/models/alert_model.dart';
import 'package:Apadamitra/services/alert_service.dart';
import 'package:Apadamitra/services/notification_service.dart';
import 'package:Apadamitra/supabase/supabase_config.dart';

class AdminAlertsScreen extends StatefulWidget {
  const AdminAlertsScreen({super.key});

  @override
  State<AdminAlertsScreen> createState() => _AdminAlertsScreenState();
}

class _AdminAlertsScreenState extends State<AdminAlertsScreen> {
  final _alertService = AlertService();
  final _notificationService = NotificationService();
  List<AlertModel> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() => _isLoading = true);
    try {
      final alerts = await _alertService.getAll();
      setState(() {
        _alerts = alerts;
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

  void _showAlertDetails(AlertModel alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Type', alert.type.name.toUpperCase()),
              _buildDetailRow('Message', alert.message),
              _buildDetailRow('Severity', alert.severity.name.toUpperCase()),
              if (alert.riverName != null)
                _buildDetailRow('River', alert.riverName!),
              if (alert.damName != null)
                _buildDetailRow('Dam', alert.damName!),
              _buildDetailRow('Status', alert.isActive ? 'Active' : 'Inactive'),
              _buildDetailRow('Created', _formatDate(alert.createdAt)),
              _buildDetailRow('Updated', _formatDate(alert.updatedAt)),
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
              _showEditAlertDialog(alert);
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
            width: 100,
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showEditAlertDialog(AlertModel alert) {
    final titleController = TextEditingController(text: alert.title);
    final messageController = TextEditingController(text: alert.message);
    final riverController = TextEditingController(text: alert.riverName ?? '');
    final damController = TextEditingController(text: alert.damName ?? '');
    String selectedSeverity = alert.severity.name;
    String selectedType = alert.type.name;
    bool isActive = alert.isActive;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Alert'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Alert Title*',
                    hintText: 'e.g., Flood Warning',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    labelText: 'Message*',
                    hintText: 'Detailed alert message',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: riverController,
                  decoration: const InputDecoration(
                    labelText: 'River Name',
                    hintText: 'e.g., Godavari',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: damController,
                  decoration: const InputDecoration(
                    labelText: 'Dam Name',
                    hintText: 'e.g., Vishupuri Dam',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Type:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'flood', child: Text('Flood')),
                    DropdownMenuItem(value: 'damOverflow', child: Text('Dam Overflow')),
                    DropdownMenuItem(value: 'prediction', child: Text('Prediction')),
                    DropdownMenuItem(value: 'safety', child: Text('Safety')),
                    DropdownMenuItem(value: 'system', child: Text('System')),
                  ],
                  onChanged: (value) {
                    setDialogState(() => selectedType = value!);
                  },
                ),
                const SizedBox(height: 16),
                const Text('Severity:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedSeverity,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'high', child: Text('High')),
                    DropdownMenuItem(value: 'critical', child: Text('Critical')),
                  ],
                  onChanged: (value) {
                    setDialogState(() => selectedSeverity = value!);
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Active'),
                  value: isActive,
                  onChanged: (value) {
                    setDialogState(() => isActive = value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty || messageController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill required fields')),
                  );
                  return;
                }

                try {
                  final alertData = {
                    'title': titleController.text,
                    'message': messageController.text,
                    'type': selectedType,
                    'severity': selectedSeverity,
                    'river_name': riverController.text.isEmpty ? null : riverController.text,
                    'dam_name': damController.text.isEmpty ? null : damController.text,
                    'is_active': isActive,
                    'updated_at': DateTime.now().toIso8601String(),
                  };

                  await SupabaseService.update('alerts', alertData, filters: {'id': alert.id});

                  Navigator.pop(context);
                  _loadAlerts();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alert updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
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
      ),
    );
  }

  void _showDeleteConfirmation(AlertModel alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Alert'),
        content: Text('Are you sure you want to delete "${alert.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await SupabaseService.delete('alerts', filters: {'id': alert.id});
                Navigator.pop(context);
                _loadAlerts();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Alert deleted successfully!'),
                    backgroundColor: Colors.green,
                  ),
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

  void _showCreateAlertDialog() {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    final riverController = TextEditingController();
    final damController = TextEditingController();
    String selectedSeverity = 'medium';
    String selectedType = 'flood';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create Alert'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Alert Title*',
                    hintText: 'e.g., Flood Warning',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    labelText: 'Message*',
                    hintText: 'Detailed alert message',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: riverController,
                  decoration: const InputDecoration(
                    labelText: 'River Name',
                    hintText: 'e.g., Godavari',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: damController,
                  decoration: const InputDecoration(
                    labelText: 'Dam Name',
                    hintText: 'e.g., Vishupuri Dam',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Type:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'flood', child: Text('Flood')),
                    DropdownMenuItem(value: 'damOverflow', child: Text('Dam Overflow')),
                    DropdownMenuItem(value: 'prediction', child: Text('Prediction')),
                    DropdownMenuItem(value: 'safety', child: Text('Safety')),
                    DropdownMenuItem(value: 'system', child: Text('System')),
                  ],
                  onChanged: (value) {
                    setDialogState(() => selectedType = value!);
                  },
                ),
                const SizedBox(height: 16),
                const Text('Severity:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedSeverity,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'high', child: Text('High')),
                    DropdownMenuItem(value: 'critical', child: Text('Critical')),
                  ],
                  onChanged: (value) {
                    setDialogState(() => selectedSeverity = value!);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty || messageController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill required fields')),
                  );
                  return;
                }

                try {
                  final now = DateTime.now();
                  final expiresAt = now.add(const Duration(days: 7)); // Alert expires in 7 days
                  final alertData = {
                    'title': titleController.text,
                    'message': messageController.text,
                    'type': selectedType,
                    'severity': selectedSeverity,
                    'river_name': riverController.text.isEmpty ? null : riverController.text,
                    'dam_name': damController.text.isEmpty ? null : damController.text,
                    'is_active': true,
                    'expires_at': expiresAt.toIso8601String(),
                    'created_at': now.toIso8601String(),
                    'updated_at': now.toIso8601String(),
                  };

                  await SupabaseService.insert('alerts', alertData);
                  
                  // Send push notification
                  await _notificationService.sendNotificationToAll(
                    titleController.text,
                    messageController.text,
                  );

                  Navigator.pop(context);
                  _loadAlerts();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alert created and sent!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Create & Send'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.low:
        return Colors.blue;
      case AlertSeverity.medium:
        return Colors.orange;
      case AlertSeverity.high:
        return Colors.deepOrange;
      case AlertSeverity.critical:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Management'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAlerts,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _alerts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_outlined, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text('No alerts found', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Create your first alert', style: theme.textTheme.bodyMedium),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _alerts.length,
                  itemBuilder: (context, index) {
                    final alert = _alerts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getSeverityColor(alert.severity).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.warning,
                            color: _getSeverityColor(alert.severity),
                          ),
                        ),
                        title: Text(alert.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${alert.message}\n${alert.severity.name.toUpperCase()} • ${alert.isActive ? "Active" : "Inactive"}'),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showEditAlertDialog(alert);
                            } else if (value == 'delete') {
                              _showDeleteConfirmation(alert);
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
                        onTap: () => _showAlertDetails(alert),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateAlertDialog,
        icon: const Icon(Icons.add_alert),
        label: const Text('Create Alert'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
