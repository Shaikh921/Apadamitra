import 'package:flutter/material.dart';
import 'package:riverwise/services/auth_service.dart';
import 'package:riverwise/services/dam_service.dart';
import 'package:riverwise/services/alert_service.dart';
import 'package:riverwise/screens/admin/admin_dams_screen.dart';
import 'package:riverwise/screens/admin/admin_alerts_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _authService = AuthService();
  final _damService = DamService();
  final _alertService = AlertService();
  
  int _totalDams = 0;
  int _activeAlerts = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      final dams = await _damService.getAll();
      final alerts = await _alertService.getActiveAlerts();
      setState(() {
        _totalDams = dams.length;
        _activeAlerts = alerts.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = _authService.currentUser;
    final isAdmin = user?.role.name == 'admin';

    if (!isAdmin && user?.role.name != 'operator') {
      return Scaffold(
        body: Center(
          child: Text('Access Denied', style: theme.textTheme.headlineMedium),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Admin Panel', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dashboard', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Welcome, ${user?.name}', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                    const SizedBox(height: 24),
                    
                    // Statistics Cards
                    Row(
                      children: [
                        Expanded(child: _buildStatCard(theme, 'Total Dams', _totalDams.toString(), Icons.water, Colors.blue)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildStatCard(theme, 'Active Alerts', _activeAlerts.toString(), Icons.warning, Colors.orange)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Quick Actions
                    Text('Quick Actions', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    
                    _buildActionCard(
                      theme,
                      'Dam Management',
                      'Add, edit, or update dam information',
                      Icons.water_drop,
                      Colors.blue,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDamsScreen())),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildActionCard(
                      theme,
                      'Alert Management',
                      'Create and manage flood alerts',
                      Icons.notifications_active,
                      Colors.orange,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAlertsScreen())),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(ThemeData theme, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(value, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  Widget _buildActionCard(ThemeData theme, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}
