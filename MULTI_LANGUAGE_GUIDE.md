# Multi-Language Feature Guide

## ✅ Languages Supported

The app now supports 6 languages:

1. **English** (en) - Default
2. **हिंदी Hindi** (hi)
3. **मराठी Marathi** (mr)
4. **తెలుగు Telugu** (te)
5. **ಕನ್ನಡ Kannada** (kn)
6. **தமிழ் Tamil** (ta)

## 🎯 How to Change Language

### From Profile Screen:
1. Open the app
2. Go to **Profile** tab (bottom navigation)
3. Under **Settings** section
4. Click on **Language**
5. Select your preferred language from the dialog
6. App will immediately switch to the selected language

## 📱 What Gets Translated

Currently translated elements:
- App name (Apadamitra)
- Bottom navigation labels (Dashboard, Dams, Assistant, Alerts, Profile)
- Dashboard cards (Water Level, Water Usage, Water Flow, Alerts)
- Auth screen (Sign In, Sign Up, Welcome Back, Create Account)
- Profile screen (Settings, Dark Mode, Language, Location, Emergency)
- Common buttons and labels

## 🔧 How It Works

### Language Persistence
- Selected language is saved in SharedPreferences
- Language preference persists across app restarts
- Each user can have their own language preference

### Implementation Details

1. **AppLocalizations** (`lib/l10n/app_localizations.dart`)
   - Contains all translations
   - Provides easy access to translated strings

2. **LanguageProvider** (`lib/providers/language_provider.dart`)
   - Manages current language state
   - Saves/loads language preference
   - Provides language switching functionality

3. **Main App** (`lib/main.dart`)
   - Configured with localization delegates
   - Supports all 6 languages
   - Updates UI when language changes

## 📝 Adding More Translations

To add translations for new screens:

1. Open `lib/l10n/app_localizations.dart`
2. Add new keys to each language map:

```dart
'en': {
  'new_key': 'English Text',
  // ... other keys
},
'hi': {
  'new_key': 'हिंदी पाठ',
  // ... other keys
},
// ... other languages
```

3. Add getter method:

```dart
String get newKey => translate('new_key');
```

4. Use in your widget:

```dart
Text(AppLocalizations.of(context).newKey)
```

## 🌍 Adding New Languages

To add a new language (e.g., Bengali):

1. Add to supported locales in `app_localizations.dart`:
```dart
static const List<Locale> supportedLocales = [
  // ... existing
  Locale('bn', ''), // Bengali
];
```

2. Add translations:
```dart
'bn': {
  'app_name': 'আপদামিত্র',
  // ... all other keys
},
```

3. Add to language provider:
```dart
case 'bn':
  return 'বাংলা (Bengali)';
```

4. Update delegate:
```dart
return ['en', 'hi', 'mr', 'te', 'kn', 'ta', 'bn'].contains(locale.languageCode);
```

## 🎨 UI Considerations

### Text Direction
- All supported languages use LTR (Left-to-Right)
- If adding RTL languages (Arabic, Urdu), update:
```dart
textDirection: TextDirection.rtl,
```

### Font Support
- Current fonts support all Indian languages
- Devanagari, Tamil, Telugu, Kannada scripts are supported
- Google Fonts automatically handles font fallbacks

## 🧪 Testing

Test each language:
1. Switch to language in Profile
2. Navigate through all screens
3. Verify all text is translated
4. Check for text overflow issues
5. Verify special characters display correctly

## 📊 Current Translation Coverage

| Screen | Coverage |
|--------|----------|
| Dashboard | ✅ 100% |
| Profile | ✅ 100% |
| Auth | ✅ 100% |
| Navigation | ✅ 100% |
| Dams | ⏳ Partial |
| Alerts | ⏳ Partial |
| Chatbot | ⏳ Partial |

## 🚀 Next Steps

To complete translation:
1. Add translations for Dam screen
2. Add translations for Alert screen
3. Add translations for Chatbot screen
4. Add translations for error messages
5. Add translations for notifications

## 💡 Best Practices

1. **Keep keys consistent** - Use snake_case for keys
2. **Short and clear** - Keep translations concise
3. **Context matters** - Same English word may need different translations
4. **Test thoroughly** - Check all languages before release
5. **User feedback** - Get native speakers to review translations

---

**Language feature is now live! Users can switch languages from their profile.**
