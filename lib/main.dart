import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:riverwise/theme.dart';
import 'package:riverwise/supabase/supabase_config.dart';
import 'package:riverwise/services/auth_service.dart';
import 'package:riverwise/services/iot_data_service.dart';
import 'package:riverwise/services/alert_service.dart';
import 'package:riverwise/services/dam_service.dart';
import 'package:riverwise/services/prediction_service.dart';
import 'package:riverwise/services/notification_service.dart';
import 'package:riverwise/providers/theme_provider.dart';
import 'package:riverwise/providers/language_provider.dart';
import 'package:riverwise/l10n/app_localizations.dart';
import 'package:riverwise/screens/auth_screen.dart';
import 'package:riverwise/screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Supabase
  await SupabaseConfig.initialize();
  
  // Initialize Auth
  final authService = AuthService();
  await authService.initialize();
  
  // Initialize other services
  await Future.wait([
    IoTDataService().initialize(),
    AlertService().initialize(),
    DamService().initialize(),
    PredictionService().initialize(),
    NotificationService().initialize(),
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
  final LanguageProvider _languageProvider = LanguageProvider();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_themeProvider, _languageProvider]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Apadamitra - Flood Monitoring',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: _themeProvider.themeMode,
          locale: _languageProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget.isAuthenticated ? const MainNavigationScreen() : const AuthScreen(),
          builder: (context, child) {
            return MultiProviderScope(
              themeProvider: _themeProvider,
              languageProvider: _languageProvider,
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

class MultiProviderScope extends InheritedWidget {
  final ThemeProvider themeProvider;
  final LanguageProvider languageProvider;

  const MultiProviderScope({
    super.key,
    required this.themeProvider,
    required this.languageProvider,
    required super.child,
  });

  static ThemeProvider themeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MultiProviderScope>()!.themeProvider;
  }

  static LanguageProvider languageOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MultiProviderScope>()!.languageProvider;
  }

  @override
  bool updateShouldNotify(MultiProviderScope oldWidget) => false;
}
