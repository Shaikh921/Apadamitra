# Fix: Network/DNS Error on Login

## 🔴 **Error Message:**
```
Authentication failed: Cien.Exception with SocketFailed host lookup:
'dgepxgnrviugwnxrrsxl.supabase.co' (OS Error: No address associated 
with hostname, errno = 7)
```

## 🔍 **What This Means:**

Your device **cannot connect to Supabase servers**. This is a network/DNS issue, not a code problem.

## ✅ **Solutions (Try in Order):**

### **1. Check Internet Connection**

**Test:**
- Open browser on your device
- Visit: https://dgepxgnrviugwnxrrsxl.supabase.co
- If it loads → Internet works, continue to step 2
- If it doesn't load → Fix internet connection first

**Fix:**
- Make sure WiFi/Mobile Data is ON
- Try switching between WiFi and Mobile Data
- Restart your router
- Restart your device

### **2. Check Supabase Status**

**Test:**
- Visit: https://status.supabase.com
- Check if there are any incidents

**Fix:**
- If Supabase is down, wait for it to come back online
- Or use the website backend fallback (see step 5)

### **3. Disable VPN/Proxy**

**Test:**
- Check if you're using a VPN
- Check if you're behind a corporate firewall

**Fix:**
- Disable VPN temporarily
- Try on a different network (home WiFi, mobile data, etc.)
- If on corporate network, ask IT to whitelist `*.supabase.co`

### **4. Clear DNS Cache**

**Android:**
```
Settings → Apps → Chrome → Storage → Clear Cache
Settings → Apps → Your App → Storage → Clear Cache
Restart device
```

**iOS:**
```
Settings → General → Reset → Reset Network Settings
(This will reset WiFi passwords, so note them down first)
```

### **5. Use Website Backend (Temporary)**

Since you have the website backend integration, you can use that instead:

**Update auth_screen.dart:**

```dart
// Add this import
import 'package:riverwise/services/sso_service.dart';

// In your login function, replace:
await _authService.signIn(email, password);

// With:
try {
  // Try website backend first
  final success = await SSOService.attemptWebsiteSSO(email, password);
  if (success) {
    // Login successful
    Navigator.pushReplacementNamed(context, '/dashboard');
  }
} catch (e) {
  // Show error
  print('Login failed: $e');
}
```

### **6. Check Emulator/Simulator Network**

If you're testing on emulator:

**Android Emulator:**
- Make sure emulator has internet access
- Try: Settings → Network & Internet → Check connection
- Restart emulator

**iOS Simulator:**
- Simulator uses Mac's network
- Make sure Mac has internet
- Restart simulator

### **7. Check Android Network Permissions**

Make sure your app has internet permission:

**android/app/src/main/AndroidManifest.xml:**
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### **8. Test with Different Network**

Try these networks in order:
1. ✅ Home WiFi
2. ✅ Mobile Data (4G/5G)
3. ✅ Public WiFi (coffee shop, etc.)
4. ✅ Friend's WiFi

If it works on one but not another, the problem is with that specific network.

## 🔧 **Debug Steps:**

### **Test 1: Ping Supabase**

On your computer (not phone):
```bash
ping dgepxgnrviugwnxrrsxl.supabase.co
```

If it fails → DNS/Network issue
If it works → Device-specific issue

### **Test 2: Check DNS Resolution**

On your computer:
```bash
nslookup dgepxgnrviugwnxrrsxl.supabase.co
```

Should return an IP address. If not → DNS issue

### **Test 3: Try Direct IP (Advanced)**

Find Supabase IP:
```bash
nslookup dgepxgnrviugwnxrrsxl.supabase.co
```

Then try accessing via IP in browser.

## 🚀 **Quick Workaround:**

While fixing network issues, you can use the website backend:

1. Make sure website is accessible: https://river-water-management-and-life-safety.onrender.com
2. Update login to use SSO service
3. This will use website backend instead of Supabase

## 📱 **Device-Specific Issues:**

### **Android:**
- Check if "Data Saver" is ON (turn it OFF)
- Check if app has "Background Data" permission
- Check if "Battery Optimization" is blocking network

### **iOS:**
- Check if "Low Data Mode" is ON (turn it OFF)
- Check if app has "Cellular Data" permission
- Settings → Cellular → Your App → Enable

## 🔍 **Still Not Working?**

If none of the above works:

1. **Check Supabase Dashboard:**
   - Login to https://supabase.com
   - Check if your project is active
   - Check if there are any billing issues

2. **Verify Supabase URL:**
   - Make sure the URL in `supabase_config.dart` is correct
   - It should be: `https://dgepxgnrviugwnxrrsxl.supabase.co`

3. **Check Firewall:**
   - Some networks block Supabase
   - Try on mobile data to confirm

4. **Contact Support:**
   - If Supabase is consistently unreachable
   - Contact Supabase support: https://supabase.com/support

## ✅ **Expected Result:**

After fixing network:
- Login should work
- No DNS errors
- App connects to Supabase successfully

---

**Most Common Cause**: Device has no internet or VPN is blocking Supabase
**Quick Fix**: Switch to mobile data or disable VPN
**Alternative**: Use website backend fallback
