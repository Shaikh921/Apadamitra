# Website-App Integration Guide

## 🎯 **Overview**

This guide explains how to integrate your existing website backend with the Apadamitra mobile app, creating a unified system with automatic fallback capabilities.

## 🏗️ **Architecture**

```
Mobile App → Website Backend (Primary) → Supabase (Fallback)
     ↓              ↓                        ↓
Location Share → API Endpoints ←→ Data Sync
SSO Login    → Authentication ←→ User Sync
Data Fetch   → Real-time Data ←→ Backup Storage
```

## 📋 **Requirements Analysis**

Based on your needs:

1. **✅ Location Sharing**: Share user location to website
2. **✅ Data Fetching**: Get data from website when available
3. **✅ SSO Integration**: Auto-login if user is registered on website
4. **✅ Fallback System**: Use Supabase when website is unavailable

## 🔧 **Implementation Steps**

### **Step 1: Website API Requirements**

Your website needs these API endpoints:

```javascript
// Authentication
POST /api/auth/login
POST /api/auth/register
POST /api/auth/logout
POST /api/auth/verify
GET  /api/auth/refresh

// User Management
GET  /api/users/profile
POST /api/users/check
PUT  /api/users/profile
POST /api/users/location
GET  /api/users/locations

// Data Endpoints
GET  /api/dams
GET  /api/alerts
POST /api/alerts
PUT  /api/alerts/:id
DELETE /api/alerts/:id

// Health Check
GET  /api/health
GET  /api/status
```

### **Step 2: Configure Website Integration**

1. **Copy the template file:**
   ```bash
   cp lib/config/website_config.dart.template lib/config/website_config.dart
   ```

2. **Update the configuration:**
   ```dart
   class WebsiteConfig {
     static const String baseUrl = 'https://your-website.com';
     static const String apiBaseUrl = 'https://your-website.com/api';
     static const String websiteName = 'Your Website Name';
     // ... update other settings
   }
   ```

3. **Add to .gitignore:**
   ```
   lib/config/website_config.dart
   ```

### **Step 3: Update Backend Manager**

Uncomment the import in `lib/services/backend_manager.dart`:
```dart
import 'package:riverwise/config/website_config.dart';

// Replace the hardcoded URL with:
static String get _websiteBaseUrl => WebsiteConfig.apiBaseUrl;
```

### **Step 4: Database Schema Updates**

Add these tables to your Supabase database:

```sql
-- User locations table
CREATE TABLE user_locations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  accuracy DOUBLE PRECISION,
  altitude DOUBLE PRECISION,
  speed DOUBLE PRECISION,
  heading DOUBLE PRECISION,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  source TEXT DEFAULT 'mobile_app',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add website integration fields to profiles
ALTER TABLE profiles ADD COLUMN website_user_id TEXT;
ALTER TABLE profiles ADD COLUMN sync_status TEXT DEFAULT 'pending';
ALTER TABLE profiles ADD COLUMN synced_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE profiles ADD COLUMN last_sync TIMESTAMP WITH TIME ZONE;

-- Create indexes
CREATE INDEX idx_user_locations_user_id ON user_locations(user_id);
CREATE INDEX idx_user_locations_timestamp ON user_locations(timestamp);
CREATE INDEX idx_profiles_website_user_id ON profiles(website_user_id);
```

## 🔐 **Website API Specifications**

### **Authentication Endpoints**

#### **POST /api/auth/login**
```json
// Request
{
  "email": "user@example.com",
  "password": "password123",
  "source": "mobile_app"
}

// Response
{
  "success": true,
  "token": "jwt_token_here",
  "user": {
    "id": "user_id",
    "email": "user@example.com",
    "name": "User Name",
    "phone": "+1234567890",
    "role": "user"
  }
}
```

#### **POST /api/users/check**
```json
// Request
{
  "email": "user@example.com"
}

// Response
{
  "success": true,
  "user": {
    "id": "user_id",
    "email": "user@example.com",
    "name": "User Name",
    "exists": true
  }
}
```

### **Location Sharing**

#### **POST /api/users/location**
```json
// Request
{
  "user_id": "user_id",
  "latitude": 19.0760,
  "longitude": 72.8777,
  "timestamp": "2025-01-09T10:30:00Z",
  "source": "mobile_app"
}

// Response
{
  "success": true,
  "message": "Location updated successfully"
}
```

### **Data Fetching**

#### **GET /api/dams**
```json
// Response
{
  "success": true,
  "data": [
    {
      "id": "dam_id",
      "name": "Dam Name",
      "state": "Maharashtra",
      "river": "River Name",
      "water_level": 85.5,
      "capacity": 1000,
      "status": "normal"
    }
  ]
}
```

## 🚀 **Usage Examples**

### **1. Initialize Integration**

```dart
// In your main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize location sharing
  await LocationSyncService.initializeLocationSharing();
  
  // Check for auto-login
  await SSOService.autoLoginFromWebsite();
  
  runApp(MyApp());
}
```

### **2. Login with SSO**

```dart
// In your login screen
Future<void> _login(String email, String password) async {
  // Try SSO login first
  final ssoSuccess = await SSOService.attemptWebsiteSSO(email, password);
  
  if (ssoSuccess) {
    // User logged in successfully
    Navigator.pushReplacementNamed(context, '/dashboard');
  } else {
    // Fallback to regular Supabase login
    await _regularLogin(email, password);
  }
}
```

### **3. Share Location**

```dart
// Enable automatic location sharing
await LocationSyncService.startLocationSharing();

// Or share location once
await LocationSyncService.shareLocationOnce();

// Emergency location share
await LocationSyncService.emergencyLocationShare();
```

### **4. Fetch Data with Fallback**

```dart
// Fetch dams data (automatically falls back to Supabase if website is down)
final dams = await BackendManager.fetchWebsiteData('dams');

// Check backend status
final status = await BackendManager.getBackendStatus();
print('Primary backend: ${status['primary_backend']}');
```

## 🔧 **Website Backend Implementation**

### **Example Node.js/Express Implementation**

```javascript
// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ success: true, status: 'healthy', timestamp: new Date() });
});

// Login endpoint
app.post('/api/auth/login', async (req, res) => {
  const { email, password, source } = req.body;
  
  try {
    // Authenticate user
    const user = await authenticateUser(email, password);
    const token = generateJWT(user);
    
    res.json({
      success: true,
      token,
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        phone: user.phone,
        role: user.role
      }
    });
  } catch (error) {
    res.status(401).json({
      success: false,
      error: 'Invalid credentials'
    });
  }
});

// Location sharing endpoint
app.post('/api/users/location', authenticateToken, async (req, res) => {
  const { user_id, latitude, longitude, timestamp } = req.body;
  
  try {
    await saveUserLocation({
      user_id,
      latitude,
      longitude,
      timestamp,
      source: 'mobile_app'
    });
    
    res.json({
      success: true,
      message: 'Location updated successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to save location'
    });
  }
});
```

## 📱 **Mobile App Integration**

### **Update Auth Screen**

```dart
// Add SSO check in your auth screen
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }
  
  Future<void> _checkAutoLogin() async {
    final autoLoginSuccess = await SSOService.autoLoginFromWebsite();
    if (autoLoginSuccess) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }
  
  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    
    // Check if user is registered on website
    final isWebsiteUser = await SSOService.isRegisteredOnWebsite(email);
    
    if (isWebsiteUser) {
      // Use SSO login
      final success = await SSOService.attemptWebsiteSSO(email, password);
      if (success) {
        Navigator.pushReplacementNamed(context, '/dashboard');
        return;
      }
    }
    
    // Fallback to regular login
    // ... regular Supabase login code
  }
}
```

## 🔍 **Testing & Debugging**

### **Test Backend Status**

```dart
// Add this to your dashboard or settings screen
Future<void> _checkBackendStatus() async {
  final status = await BackendManager.getBackendStatus();
  print('Backend Status: $status');
  
  // Show status to user
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Backend Status'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Website: ${status['website_backend']}'),
          Text('Supabase: ${status['supabase_backend']}'),
          Text('Primary: ${status['primary_backend']}'),
        ],
      ),
    ),
  );
}
```

### **Debug Location Sharing**

```dart
// Check location sharing status
final locationStatus = LocationSyncService.getLocationSharingStatus();
print('Location Status: $locationStatus');

// Get last shared location
final lastLocation = await LocationSyncService.getLastSharedLocation();
print('Last Location: $lastLocation');
```

## 🔒 **Security Considerations**

1. **API Keys**: Never hardcode API keys in the app
2. **HTTPS**: Always use HTTPS for API communication
3. **Token Expiry**: Implement proper JWT token refresh
4. **Rate Limiting**: Implement rate limiting on your website API
5. **Input Validation**: Validate all inputs on both client and server
6. **CORS**: Configure CORS properly for mobile app requests

## 📊 **Monitoring & Analytics**

### **Add Logging**

```dart
// Add to your backend manager
static Future<void> _logApiCall(String endpoint, String method, bool success) async {
  // Log to analytics service
  print('API Call: $method $endpoint - ${success ? 'SUCCESS' : 'FAILED'}');
}
```

## 🚀 **Deployment Checklist**

- [ ] Website API endpoints implemented
- [ ] Database schema updated
- [ ] Configuration files set up
- [ ] SSL certificates configured
- [ ] CORS configured for mobile app
- [ ] Rate limiting implemented
- [ ] Monitoring set up
- [ ] Error logging configured
- [ ] Backup systems tested
- [ ] Load testing completed

## 📞 **Next Steps**

1. **Share your website details** - URL, API structure, database schema
2. **Provide source code** - So I can analyze the exact integration points
3. **Test the integration** - We'll test the fallback system
4. **Optimize performance** - Fine-tune the sync intervals
5. **Deploy and monitor** - Set up monitoring and alerts

---

**Ready to integrate?** Share your website details and let's make this happen! 🚀