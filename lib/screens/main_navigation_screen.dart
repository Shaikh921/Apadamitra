import 'package:flutter/material.dart';
import 'package:Apadamitra/screens/dashboard_screen.dart';
import 'package:Apadamitra/screens/dam_info_screen.dart';
import 'package:Apadamitra/screens/alerts_screen.dart';
import 'package:Apadamitra/screens/chatbot_screen.dart';
import 'package:Apadamitra/screens/profile_screen.dart';
import 'package:Apadamitra/l10n/app_localizations.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    DamInfoScreen(),
    ChatbotScreen(),
    AlertsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: isDark ? const Color(0xFF2A3340) : const Color(0xFFE8EDF2), width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          backgroundColor: theme.colorScheme.surface,
          indicatorColor: theme.colorScheme.primaryContainer,
          height: 70,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              selectedIcon: Icon(Icons.dashboard, color: theme.colorScheme.primary),
              label: l10n.translate('dashboard'),
            ),
            NavigationDestination(
              icon: Icon(Icons.water_outlined, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              selectedIcon: Icon(Icons.water, color: theme.colorScheme.primary),
              label: l10n.translate('dams'),
            ),
            NavigationDestination(
              icon: Icon(Icons.support_agent, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              selectedIcon: Icon(Icons.support_agent, color: theme.colorScheme.primary),
              label: l10n.translate('assistant'),
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              selectedIcon: Icon(Icons.notifications, color: theme.colorScheme.primary),
              label: l10n.translate('alerts'),
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              selectedIcon: Icon(Icons.person, color: theme.colorScheme.primary),
              label: l10n.translate('profile'),
            ),
          ],
        ),
      ),
    );
  }
}
