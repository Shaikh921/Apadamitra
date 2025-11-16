import 'package:flutter/material.dart';
import 'package:Apadamitra/services/auth_service.dart';
import 'package:Apadamitra/screens/auth_screen.dart';
import 'package:Apadamitra/screens/admin/admin_dashboard_screen.dart';
import 'package:Apadamitra/main.dart';
import 'package:Apadamitra/providers/language_provider.dart';
import 'package:Apadamitra/utils/database_helper.dart';
import 'package:Apadamitra/l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  String _locationStatus = 'Not enabled';
  bool _isLoadingData = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    setState(() {
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        _locationStatus = 'Enabled';
      } else {
        _locationStatus = 'Not enabled';
      }
    });
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission denied permanently. Please enable it in settings.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }
    
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      setState(() => _locationStatus = 'Enabled');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location access granted!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _loadSampleData() async {
    setState(() => _isLoadingData = true);
    
    try {
      await DatabaseHelper.seedAllSampleData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Sample data loaded successfully!\n3 Dams and 2 Alerts added.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() => _isLoadingData = false);
    }
  }

  Future<void> _handleSignOut() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = _authService.currentUser;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(l10n.translate('profile'), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1F26) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? const Color(0xFF2A3340) : const Color(0xFFE8EDF2)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, size: 40, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 16),
                  Text(user?.name ?? 'User', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(user?.email ?? '', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(user?.role.name.toUpperCase() ?? 'USER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Admin Panel Button
            if (user?.role.name == 'admin' || user?.role.name == 'operator')
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.admin_panel_settings, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          user?.role.name == 'admin' ? 'Admin Panel' : 'Operator Panel',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            _buildSection(
              theme,
              isDark,
              l10n.translate('settings'),
              [
                _buildDarkModeToggle(theme, l10n),
                _buildLanguageSelector(theme, l10n),
                _buildSettingTile(theme, Icons.notifications_outlined, l10n.translate('notifications'), 'Enabled', () {}),
                _buildSettingTile(theme, Icons.location_on_outlined, 'Location', _locationStatus, _requestLocationPermission),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              theme,
              isDark,
              'Emergency',
              [
                _buildSettingTile(theme, Icons.emergency, 'Emergency Contacts', 'Manage', () {}),
                _buildSettingTile(theme, Icons.shield_outlined, 'Safety Zone', 'Configure', () {}),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              theme,
              isDark,
              'About',
              [
                _buildSettingTile(theme, Icons.info_outline, 'About Apadamitra', '', () {}),
                _buildSettingTile(theme, Icons.privacy_tip_outlined, 'Privacy Policy', '', () {}),
                _buildSettingTile(theme, Icons.help_outline, 'Help & Support', '', () {}),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSignOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Sign Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, bool isDark, String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F26) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF2A3340) : const Color(0xFFE8EDF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDarkModeToggle(ThemeData theme, AppLocalizations l10n) {
    final themeProvider = MultiProviderScope.themeOf(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(child: Text(l10n.translate('dark_mode'), style: theme.textTheme.bodyLarge)),
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              themeProvider.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(ThemeData theme, AppLocalizations l10n) {
    final languageProvider = MultiProviderScope.languageOf(context);
    final currentLanguage = languageProvider.locale.languageCode;
    
    return InkWell(
      onTap: () => _showLanguageDialog(languageProvider),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(Icons.language, color: theme.colorScheme.primary, size: 24),
            const SizedBox(width: 16),
            Expanded(child: Text(l10n.translate('language'), style: theme.textTheme.bodyLarge)),
            Text(
              languageProvider.getLanguageName(currentLanguage),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languageProvider.supportedLanguages.map((lang) {
              final isSelected = languageProvider.locale.languageCode == lang['code'];
              return ListTile(
                title: Text(lang['name']!),
                trailing: isSelected ? Icon(Icons.check, color: theme.colorScheme.primary) : null,
                onTap: () {
                  languageProvider.setLanguage(lang['code']!);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildSettingTile(ThemeData theme, IconData icon, String title, String trailing, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 24),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: theme.textTheme.bodyLarge)),
            if (trailing.isNotEmpty) Text(trailing, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}
