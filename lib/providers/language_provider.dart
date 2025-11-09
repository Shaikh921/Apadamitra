import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'language_code';
  Locale _locale = const Locale('en', '');

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'en';
    _locale = Locale(languageCode, '');
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    _locale = Locale(languageCode, '');
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी (Hindi)';
      case 'mr':
        return 'मराठी (Marathi)';
      case 'te':
        return 'తెలుగు (Telugu)';
      case 'kn':
        return 'ಕನ್ನಡ (Kannada)';
      case 'ta':
        return 'தமிழ் (Tamil)';
      default:
        return 'English';
    }
  }

  List<Map<String, String>> get supportedLanguages => [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'हिंदी (Hindi)'},
    {'code': 'mr', 'name': 'मराठी (Marathi)'},
    {'code': 'te', 'name': 'తెలుగు (Telugu)'},
    {'code': 'kn', 'name': 'ಕನ್ನಡ (Kannada)'},
    {'code': 'ta', 'name': 'தமிழ் (Tamil)'},
  ];
}
