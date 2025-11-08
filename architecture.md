# Apadamitra - Flood Monitoring System Architecture

## Overview
Multi-platform flood monitoring and safety system integrating IoT river data, AI-driven predictions, and multilingual citizen alerts.

## Technology Stack
- **Frontend**: Flutter (Dreamflow)
- **Backend**: Firebase (real-time IoT) + Supabase (structured data)
- **AI/ML**: Google Cloud AI Platform / REST API
- **Maps**: Google Maps API
- **Weather**: OpenWeatherMap API
- **Notifications**: Firebase Cloud Messaging
- **Translation**: Flutter intl + Google Translate API

## Core Features & Implementation Plan

### Phase 1: Foundation & Authentication
1. **User Authentication System**
   - Firebase Auth (Email/Password, Google, OTP)
   - Role-based access (User, Admin, Authority)
   - User profile with location preferences
   - Language selection on first launch

2. **Data Models**
   - User model (profile, role, location, preferences)
   - IoT Data model (water level, rainfall, flow rate, timestamp)
   - Dam model (name, location, capacity, safety status)
   - River model (name, state, associated dams)
   - State model (name, rivers)
   - Alert model (type, severity, message, timestamp)
   - Prediction model (risk level, confidence, timestamp)

3. **Service Layer**
   - AuthService (Firebase)
   - IoTDataService (Firebase Firestore)
   - DamService (Supabase PostgreSQL)
   - RiverService (Supabase PostgreSQL)
   - StateService (Supabase PostgreSQL)
   - AlertService (Firebase + FCM)
   - PredictionService (AI API integration)
   - LocationService (GPS tracking)
   - NotificationService (FCM)
   - LocalizationService (intl + translations)

### Phase 2: Dashboard & Monitoring
4. **Real-Time Dashboard**
   - Live IoT sensor data display
   - Color-coded risk indicators (🟢 Safe, 🟡 Caution, 🔴 Danger)
   - River water level gauges
   - Rainfall metrics
   - Flow rate monitoring
   - Last updated timestamp

5. **Map Integration**
   - Google Maps showing user location
   - Nearby rivers and flood zones overlay
   - Dam locations with status indicators
   - Danger zone radius visualization
   - Real-time GPS tracking

### Phase 3: Dam Information System
6. **Hierarchical Dam Browser**
   - State selection dropdown
   - River selection (filtered by state)
   - Dam selection (filtered by river)
   - Detailed dam information display
   - Safety alerts and capacity status
   - Managing agency contact info

### Phase 4: AI Prediction & Analytics
7. **Flood Prediction Module**
   - AI model integration (LSTM/Prophet API)
   - Risk level prediction (Low/Medium/High)
   - Confidence score display
   - Historical prediction accuracy
   - Trend visualization with charts

8. **Reports & Analytics**
   - Rainfall trend graphs
   - Water level rise charts
   - Dam storage visualization
   - Prediction history
   - Export functionality for admins

### Phase 5: Admin Panel
9. **Admin Dashboard**
   - IoT data verification interface
   - Manual data override capability
   - Alert broadcast system
   - Sensor approval workflow
   - User management
   - System health monitoring

### Phase 6: Safety Features
10. **Alerts & Notifications**
    - Real-time flood alerts (FCM)
    - Dam overflow notifications
    - AI prediction warnings
    - Multilingual alert messages
    - Local notifications for offline users
    - Notification preferences

11. **Emergency System**
    - SOS button with location sharing
    - Emergency contact management
    - Authority notification system
    - Safety radius alerts
    - Quick action buttons

12. **Multilingual Support**
    - Languages: English, Hindi, Marathi, Tamil, Telugu, Bengali
    - Dynamic UI translation
    - Language selector
    - Automatic detection based on device locale
    - Translated alerts and notifications

## UI/UX Design Principles
- **Modern & Sleek**: No Material Design, generous spacing, elegant fonts
- **Color Palette**: Blue (water), Green (safe), Orange (caution), Red (danger), White/Dark backgrounds
- **Typography**: Clean sans-serif fonts with clear hierarchy
- **Layout**: Card-based with rounded corners, minimal shadows
- **Accessibility**: Large buttons, voice support, high contrast
- **Responsive**: Adaptive for mobile and tablet

## Widget Structure
```
App
├── SplashScreen
├── LanguageSelectionScreen
├── AuthScreen (Login/Signup)
├── MainNavigationScreen
│   ├── DashboardScreen (Home)
│   │   ├── IoTDataCard
│   │   ├── RiskIndicator
│   │   ├── QuickActions
│   │   └── MapPreview
│   ├── MapScreen
│   │   ├── GoogleMap
│   │   ├── RiverMarkers
│   │   ├── DamMarkers
│   │   └── DangerZoneOverlay
│   ├── DamInfoScreen
│   │   ├── StateDropdown
│   │   ├── RiverDropdown
│   │   ├── DamDropdown
│   │   └── DamDetailsCard
│   ├── AlertsScreen
│   │   └── AlertList
│   ├── PredictionScreen
│   │   ├── RiskLevelCard
│   │   ├── ConfidenceIndicator
│   │   └── TrendCharts
│   └── ProfileScreen
│       ├── UserInfo
│       ├── PreferencesSettings
│       └── LanguageSelector
├── AdminDashboard (Role: Admin)
│   ├── DataVerificationScreen
│   ├── AlertBroadcastScreen
│   └── AnalyticsScreen
└── EmergencyScreen (SOS)
    ├── LocationDisplay
    ├── EmergencyContacts
    └── SendAlertButton
```

## Data Flow
1. **IoT → Firebase**: Sensors POST data via HTTPS/MQTT to Firebase Firestore
2. **Firebase → App**: Real-time listeners update dashboard
3. **Admin Verification**: Admins approve/reject sensor data
4. **Firebase → Supabase**: Cloud Function forwards verified data
5. **Supabase → AI**: Historical data sent to prediction API
6. **AI → App**: Predictions stored in Supabase, displayed in app
7. **Alerts**: Critical conditions trigger FCM notifications to all users
8. **Location**: GPS monitors user proximity to danger zones

## Security
- Firebase Authentication with role-based access
- Firestore security rules for data protection
- Supabase Row Level Security (RLS)
- API keys in environment variables
- Encrypted user data
- GDPR compliance

## Current Status (MVP Completed)
- [x] Phase 1: Foundation & Authentication
  - User authentication with email/password
  - Local storage implementation
  - User profile management
- [x] Phase 2: Dashboard & Monitoring
  - Real-time IoT data display
  - Color-coded risk indicators
  - Live monitoring cards
- [x] Phase 3: Dam Information System
  - Hierarchical dam browser (State → River → Dam)
  - Detailed dam information
  - Storage percentage visualization
- [x] Phase 4: AI Prediction & Analytics
  - Risk level predictions
  - Confidence score display
  - Prediction cards
- [ ] Phase 5: Admin Panel (Future)
  - Data verification interface
  - Alert broadcast system
- [ ] Phase 6: Safety Features (Future)
  - Maps integration with Google Maps
  - SOS emergency system
  - Location tracking
  - Multilingual support

## Next Steps
1. Connect Firebase/Supabase backends via Dreamflow panel
2. Integrate Google Maps API for location features
3. Add multilingual support with translation system
4. Implement admin dashboard for data verification
5. Add FCM for push notifications
6. Integrate weather API for rainfall forecasts
