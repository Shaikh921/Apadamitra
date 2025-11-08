import 'package:flutter/material.dart';
import 'package:riverwise/theme.dart';
import 'package:riverwise/supabase/supabase_config.dart';
import 'package:riverwise/services/auth_service.dart';
import 'package:riverwise/services/iot_data_service.dart';
import 'package:riverwise/services/alert_service.dart';
import 'package:riverwise/services/dam_service.dart';
import 'package:riverwise/services/prediction_service.dart';
import 'package:riverwise/providers/theme_provider.dart';
import 'package:riverwise/screens/auth_screen.dart';
import 'package:riverwise/screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SupabaseConfig.initialize();
  
  final authService = AuthService();
  await authService.initialize();
  
  await Future.wait([
    IoTDataService().initialize(),
    AlertService().initialize(),
    DamService().initialize(),
    PredictionService().initialize(),
  ]);
  
  runApp(MyApp(isAuthenticated: authService.isAuthenticated));
}

class MyApp extends StatefulWidget {
  final bool isAuthenticated;
  
  const MyApp({super.key, required this.isAuthenticated});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeProvider,
      builder: (context, _) {
        return MaterialApp(
          title: 'Apadamitra - Flood Monitoring',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: _themeProvider.themeMode,
          home: widget.isAuthenticated ? const MainNavigationScreen() : const AuthScreen(),
          builder: (context, child) {
            return ThemeProviderScope(
              themeProvider: _themeProvider,
              child: child!,
            );
          },
        );
      },
    );
  }
}

class ThemeProviderScope extends InheritedWidget {
  final ThemeProvider themeProvider;

  const ThemeProviderScope({
    super.key,
    required this.themeProvider,
    required super.child,
  });

  static ThemeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProviderScope>()!.themeProvider;
  }

  @override
  bool updateShouldNotify(ThemeProviderScope oldWidget) => false;
}
