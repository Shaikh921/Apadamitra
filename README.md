# Apadamitra - Flood Monitoring & Safety System

A comprehensive multi-platform flood monitoring and safety system that integrates real-time IoT river data, AI-driven flood predictions, and multilingual citizen alerts to keep communities safe and informed.

## Features

- 🌊 **Real-time IoT Monitoring** - Live water level and flow rate data from sensors
- 🤖 **AI Flood Predictions** - Machine learning-based flood forecasting
- 📢 **Multi-language Alerts** - Emergency notifications in multiple languages
- 🗺️ **Interactive Maps** - Visualize flood zones and dam locations
- 🌓 **Dark Mode** - Eye-friendly dark theme support
- 📍 **Location Services** - Location-based alerts and monitoring
- 👤 **User Authentication** - Secure login with Supabase
- 💬 **AI Chatbot Assistant** - Get instant help and information

## Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth
- **Maps**: Google Maps Flutter
- **Notifications**: Firebase Cloud Messaging
- **State Management**: Provider pattern
- **Local Storage**: Shared Preferences

## Prerequisites

- Flutter SDK (3.6.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Java JDK 17
- Supabase account
- Firebase account (for notifications)
- Google Maps API key

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/apadamitra.git
   cd apadamitra
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase**
   - Create a Supabase project at https://supabase.com
   - Run the SQL script from `supabase_setup.sql` in SQL Editor
   - Update credentials in `lib/supabase/supabase_config.dart`

4. **Configure Firebase**
   - Add your `google-services.json` to `android/app/`
   - Add your `GoogleService-Info.plist` to `ios/Runner/`

5. **Add Google Maps API Key**
   - Update `android/app/src/main/AndroidManifest.xml`
   - Update `ios/Runner/AppDelegate.swift`

6. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── theme.dart               # Light & dark themes
├── models/                  # Data models
├── screens/                 # UI screens
│   ├── auth_screen.dart
│   ├── dashboard_screen.dart
│   ├── profile_screen.dart
│   └── ...
├── services/               # Business logic
│   ├── auth_service.dart
│   ├── iot_data_service.dart
│   └── ...
├── providers/              # State management
│   └── theme_provider.dart
└── supabase/              # Supabase configuration
    └── supabase_config.dart
```

## Configuration

### Supabase Setup

1. Go to your Supabase Dashboard
2. Navigate to SQL Editor
3. Copy and run the content from `supabase_setup.sql`
4. Enable Email authentication in Authentication → Providers
5. Update your credentials in `lib/supabase/supabase_config.dart`

See `SUPABASE_SETUP_GUIDE.md` for detailed instructions.

## Features in Detail

### Authentication
- Email/password registration and login
- Secure session management
- User profile creation
- Automatic location permission request

### Dark Mode
- System-based theme detection
- Manual toggle in profile settings
- Persistent theme preference

### Location Services
- Request location permission on first login
- Location-based flood alerts
- Manual permission management in settings

### Real-time Monitoring
- Live IoT sensor data
- Water level tracking
- Flow rate monitoring
- Dam status updates

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@apadamitra.com or open an issue in the repository.

## Acknowledgments

- Flutter team for the amazing framework
- Supabase for backend infrastructure
- Community contributors

---

**Made with ❤️ for safer communities**
