import 'package:flutter/material.dart';
import 'package:riverwise/screens/dashboard_screen.dart';
import 'package:riverwise/screens/dam_info_screen.dart';
import 'package:riverwise/screens/alerts_screen.dart';
import 'package:riverwise/screens/chatbot_screen.dart';
import 'package:riverwise/screens/profile_screen.dart';

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
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.water_outlined, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              selectedIcon: Icon(Icons.water, color: theme.colorScheme.primary),
              label: 'Dams',
            ),
            NavigationDestination(
              icon: Icon(Icons.support_agent, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              selectedIcon: Icon(Icons.support_agent, color: theme.colorScheme.primary),
              label: 'Assistant',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              selectedIcon: Icon(Icons.notifications, color: theme.colorScheme.primary),
              label: 'Alerts',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              selectedIcon: Icon(Icons.person, color: theme.colorScheme.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
