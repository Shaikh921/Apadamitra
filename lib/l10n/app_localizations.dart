import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('hi', ''), // Hindi
    Locale('mr', ''), // Marathi
    Locale('te', ''), // Telugu
    Locale('kn', ''), // Kannada
    Locale('ta', ''), // Tamil
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'Apadamitra',
      'dashboard': 'Dashboard',
      'dams': 'Dams',
      'assistant': 'Assistant',
      'alerts': 'Alerts',
      'profile': 'Profile',
      'water_level': 'Water Level',
      'water_usage': 'Water Usage',
      'water_flow': 'Water Flow',
      'view_dams': 'VIEW DAMS',
      'current_status': 'Current status\nreservoir levels',
      'statistics': 'Statistics on water\nconsumption',
      'notifications': 'Notifications of\npotential hazards',
      'rates_direction': 'Rates and direction\nof river flow',
      'welcome_back': 'Welcome Back',
      'create_account': 'Create Account',
      'full_name': 'Full Name',
      'email': 'Email',
      'password': 'Password',
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'sign_out': 'Sign Out',
      'already_account': 'Already have an account? Sign In',
      'no_account': 'Don\'t have an account? Sign Up',
      'settings': 'Settings',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'location': 'Location',
      'emergency': 'Emergency',
      'emergency_contacts': 'Emergency Contacts',
    },
    'hi': {
      'app_name': 'आपदामित्र',
      'dashboard': 'डैशबोर्ड',
      'dams': 'बांध',
      'assistant': 'सहायक',
      'alerts': 'चेतावनी',
      'profile': 'प्रोफ़ाइल',
      'water_level': 'जल स्तर',
      'water_usage': 'जल उपयोग',
      'water_flow': 'जल प्रवाह',
      'view_dams': 'बांध देखें',
      'current_status': 'वर्तमान स्थिति\nजलाशय स्तर',
      'statistics': 'जल उपभोग\nपर आंकड़े',
      'notifications': 'संभावित खतरों\nकी सूचनाएं',
      'rates_direction': 'नदी प्रवाह की\nदर और दिशा',
      'welcome_back': 'वापसी पर स्वागत है',
      'create_account': 'खाता बनाएं',
      'full_name': 'पूरा नाम',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'sign_in': 'साइन इन करें',
      'sign_up': 'साइन अप करें',
      'sign_out': 'साइन आउट',
      'already_account': 'पहले से खाता है? साइन इन करें',
      'no_account': 'खाता नहीं है? साइन अप करें',
      'settings': 'सेटिंग्स',
      'dark_mode': 'डार्क मोड',
      'language': 'भाषा',
      'location': 'स्थान',
      'emergency': 'आपातकाल',
      'emergency_contacts': 'आपातकालीन संपर्क',
    },
    'mr': {
      'app_name': 'आपदामित्र',
      'dashboard': 'डॅशबोर्ड',
      'dams': 'धरणे',
      'assistant': 'सहाय्यक',
      'alerts': 'सूचना',
      'profile': 'प्रोफाइल',
      'water_level': 'पाणी पातळी',
      'water_usage': 'पाणी वापर',
      'water_flow': 'पाणी प्रवाह',
      'view_dams': 'धरणे पहा',
      'current_status': 'सध्याची स्थिती\nजलाशय पातळी',
      'statistics': 'पाणी वापराची\nआकडेवारी',
      'notifications': 'संभाव्य धोक्यांच्या\nसूचना',
      'rates_direction': 'नदी प्रवाहाचा\nदर आणि दिशा',
      'welcome_back': 'परत स्वागत आहे',
      'create_account': 'खाते तयार करा',
      'full_name': 'पूर्ण नाव',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'sign_in': 'साइन इन करा',
      'sign_up': 'साइन अप करा',
      'sign_out': 'साइन आउट',
      'already_account': 'आधीच खाते आहे? साइन इन करा',
      'no_account': 'खाते नाही? साइन अप करा',
      'settings': 'सेटिंग्ज',
      'dark_mode': 'डार्क मोड',
      'language': 'भाषा',
      'location': 'स्थान',
      'emergency': 'आणीबाणी',
      'emergency_contacts': 'आणीबाणी संपर्क',
    },
    'te': {
      'app_name': 'ఆపదామిత్ర',
      'dashboard': 'డాష్‌బోర్డ్',
      'dams': 'ఆనకట్టలు',
      'assistant': 'సహాయకుడు',
      'alerts': 'హెచ్చరికలు',
      'profile': 'ప్రొఫైల్',
      'water_level': 'నీటి స్థాయి',
      'water_usage': 'నీటి వినియోగం',
      'water_flow': 'నీటి ప్రవాహం',
      'view_dams': 'ఆనకట్టలు చూడండి',
      'current_status': 'ప్రస్తుత స్థితి\nజలాశయ స్థాయిలు',
      'statistics': 'నీటి వినియోగంపై\nగణాంకాలు',
      'notifications': 'సంభావ్య ప్రమాదాల\nనోటిఫికేషన్లు',
      'rates_direction': 'నది ప్రవాహం యొక్క\nరేట్లు మరియు దిశ',
      'welcome_back': 'తిరిగి స్వాగతం',
      'create_account': 'ఖాతా సృష్టించండి',
      'full_name': 'పూర్తి పేరు',
      'email': 'ఇమెయిల్',
      'password': 'పాస్‌వర్డ్',
      'sign_in': 'సైన్ ఇన్',
      'sign_up': 'సైన్ అప్',
      'sign_out': 'సైన్ అవుట్',
      'already_account': 'ఇప్పటికే ఖాతా ఉందా? సైన్ ఇన్',
      'no_account': 'ఖాతా లేదా? సైన్ అప్',
      'settings': 'సెట్టింగ్‌లు',
      'dark_mode': 'డార్క్ మోడ్',
      'language': 'భాష',
      'location': 'స్థానం',
      'emergency': 'అత్యవసరం',
      'emergency_contacts': 'అత్యవసర పరిచయాలు',
    },
    'kn': {
      'app_name': 'ಆಪದಾಮಿತ್ರ',
      'dashboard': 'ಡ್ಯಾಶ್‌ಬೋರ್ಡ್',
      'dams': 'ಅಣೆಕಟ್ಟುಗಳು',
      'assistant': 'ಸಹಾಯಕ',
      'alerts': 'ಎಚ್ಚರಿಕೆಗಳು',
      'profile': 'ಪ್ರೊಫೈಲ್',
      'water_level': 'ನೀರಿನ ಮಟ್ಟ',
      'water_usage': 'ನೀರಿನ ಬಳಕೆ',
      'water_flow': 'ನೀರಿನ ಹರಿವು',
      'view_dams': 'ಅಣೆಕಟ್ಟುಗಳನ್ನು ವೀಕ್ಷಿಸಿ',
      'current_status': 'ಪ್ರಸ್ತುತ ಸ್ಥಿತಿ\nಜಲಾಶಯ ಮಟ್ಟಗಳು',
      'statistics': 'ನೀರಿನ ಬಳಕೆಯ\nಅಂಕಿಅಂಶಗಳು',
      'notifications': 'ಸಂಭಾವ್ಯ ಅಪಾಯಗಳ\nಅಧಿಸೂಚನೆಗಳು',
      'rates_direction': 'ನದಿ ಹರಿವಿನ\nದರಗಳು ಮತ್ತು ದಿಕ್ಕು',
      'welcome_back': 'ಮರಳಿ ಸ್ವಾಗತ',
      'create_account': 'ಖಾತೆ ರಚಿಸಿ',
      'full_name': 'ಪೂರ್ಣ ಹೆಸರು',
      'email': 'ಇಮೇಲ್',
      'password': 'ಪಾಸ್‌ವರ್ಡ್',
      'sign_in': 'ಸೈನ್ ಇನ್',
      'sign_up': 'ಸೈನ್ ಅಪ್',
      'sign_out': 'ಸೈನ್ ಔಟ್',
      'already_account': 'ಈಗಾಗಲೇ ಖಾತೆ ಇದೆಯೇ? ಸೈನ್ ಇನ್',
      'no_account': 'ಖಾತೆ ಇಲ್ಲವೇ? ಸೈನ್ ಅಪ್',
      'settings': 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು',
      'dark_mode': 'ಡಾರ್ಕ್ ಮೋಡ್',
      'language': 'ಭಾಷೆ',
      'location': 'ಸ್ಥಳ',
      'emergency': 'ತುರ್ತು',
      'emergency_contacts': 'ತುರ್ತು ಸಂಪರ್ಕಗಳು',
    },
    'ta': {
      'app_name': 'ஆபதாமித்ரா',
      'dashboard': 'டாஷ்போர்டு',
      'dams': 'அணைகள்',
      'assistant': 'உதவியாளர்',
      'alerts': 'எச்சரிக்கைகள்',
      'profile': 'சுயவிவரம்',
      'water_level': 'நீர் மட்டம்',
      'water_usage': 'நீர் பயன்பாடு',
      'water_flow': 'நீர் ஓட்டம்',
      'view_dams': 'அணைகளைக் காண்க',
      'current_status': 'தற்போதைய நிலை\nநீர்த்தேக்க நிலைகள்',
      'statistics': 'நீர் நுகர்வு\nபற்றிய புள்ளிவிவரங்கள்',
      'notifications': 'சாத்தியமான\nஆபத்துகளின் அறிவிப்புகள்',
      'rates_direction': 'ஆற்று ஓட்டத்தின்\nவீதங்கள் மற்றும் திசை',
      'welcome_back': 'மீண்டும் வரவேற்கிறோம்',
      'create_account': 'கணக்கை உருவாக்கவும்',
      'full_name': 'முழு பெயர்',
      'email': 'மின்னஞ்சல்',
      'password': 'கடவுச்சொல்',
      'sign_in': 'உள்நுழைக',
      'sign_up': 'பதிவு செய்க',
      'sign_out': 'வெளியேறு',
      'already_account': 'ஏற்கனவே கணக்கு உள்ளதா? உள்நுழைக',
      'no_account': 'கணக்கு இல்லையா? பதிவு செய்க',
      'settings': 'அமைப்புகள்',
      'dark_mode': 'இருண்ட பயன்முறை',
      'language': 'மொழி',
      'location': 'இடம்',
      'emergency': 'அவசரநிலை',
      'emergency_contacts': 'அவசர தொடர்புகள்',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Getters for easy access
  String get appName => translate('app_name');
  String get dashboard => translate('dashboard');
  String get dams => translate('dams');
  String get assistant => translate('assistant');
  String get alerts => translate('alerts');
  String get profile => translate('profile');
  String get waterLevel => translate('water_level');
  String get waterUsage => translate('water_usage');
  String get waterFlow => translate('water_flow');
  String get viewDams => translate('view_dams');
  String get currentStatus => translate('current_status');
  String get statistics => translate('statistics');
  String get notifications => translate('notifications');
  String get ratesDirection => translate('rates_direction');
  String get welcomeBack => translate('welcome_back');
  String get createAccount => translate('create_account');
  String get fullName => translate('full_name');
  String get email => translate('email');
  String get password => translate('password');
  String get signIn => translate('sign_in');
  String get signUp => translate('sign_up');
  String get signOut => translate('sign_out');
  String get alreadyAccount => translate('already_account');
  String get noAccount => translate('no_account');
  String get settings => translate('settings');
  String get darkMode => translate('dark_mode');
  String get language => translate('language');
  String get location => translate('location');
  String get emergency => translate('emergency');
  String get emergencyContacts => translate('emergency_contacts');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'mr', 'te', 'kn', 'ta'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
