# Quick Supabase Connection Test

## Your Current Configuration

**Supabase URL**: `https://dgepxgnrviugwnxrrsxl.supabase.co`
**Anon Key**: `eyJhbGci...` (configured)

## Step-by-Step Connection Guide

### 1️⃣ Verify Supabase Project Exists

1. Go to: https://app.supabase.com
2. Sign in with your account
3. Look for project: **dgepxgnrviugwnxrrsxl**
4. If you don't see it, you need to create a new project

### 2️⃣ If Project Doesn't Exist - Create New One

1. Click "New Project"
2. Choose organization
3. Enter:
   - **Name**: Apadamitra (or any name)
   - **Database Password**: (save this somewhere safe)
   - **Region**: Choose closest to you
4. Click "Create new project"
5. Wait 2-3 minutes for setup

### 3️⃣ Get Your NEW Credentials

1. After project is created, go to **Settings** → **API**
2. Copy:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon public key**: Long string starting with `eyJhbGci...`

### 4️⃣ Update Flutter App with NEW Credentials

Open `lib/supabase/supabase_config.dart` and replace:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_PROJECT_URL_HERE';
  static const String anonKey = 'YOUR_ANON_KEY_HERE';
  // ... rest of code
}
```

### 5️⃣ Run the SQL Setup Script

1. In Supabase Dashboard, go to **SQL Editor**
2. Click **New query**
3. Copy ALL content from `supabase_setup.sql`
4. Paste and click **RUN**
5. Should see "Success. No rows returned"

### 6️⃣ Enable Email Authentication

1. Go to **Authentication** → **Providers**
2. Make sure **Email** is enabled (toggle ON)
3. Click on Email provider
4. **IMPORTANT**: Turn OFF "Confirm email" for testing
5. Click Save

### 7️⃣ Hot Reload Your App

In the terminal where Flutter is running, press:
- **r** for hot reload
- Or **R** for hot restart

### 8️⃣ Test Registration

1. In your app, enter:
   - **Name**: Test User
   - **Email**: test@example.com (use a NEW email each time)
   - **Password**: Test123456
2. Click "Sign Up"
3. Watch the error message - it should now show the actual error

### 9️⃣ Common Errors & Solutions

**Error: "Invalid API key"**
- Solution: Your anon key is wrong. Get it from Settings → API

**Error: "Failed to load user"**
- Solution: Run the SQL script (Step 5)

**Error: "User already registered"**
- Solution: Use a different email OR delete user from Authentication → Users

**Error: "Network request failed"**
- Solution: Check internet connection, verify Supabase URL is correct

**Error: "Row Level Security policy violation"**
- Solution: Make sure SQL script ran successfully

### 🔟 Verify Everything Works

After successful signup:
1. Go to **Authentication** → **Users** - should see your user
2. Go to **Table Editor** → **users** - should see user profile
3. Try logging out and logging in again

## Need More Help?

If you're still stuck, tell me:
1. What error message you see in the app
2. Did you create a new Supabase project or using existing one?
3. Did the SQL script run successfully?
