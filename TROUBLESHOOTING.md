# Troubleshooting Registration Failure

## Current Issue
Registration is failing with "Authentication failed. Please try again."

## Most Likely Causes

### 1. Supabase Database Not Set Up ⚠️ (MOST COMMON)

**Problem**: The `users` table doesn't exist in your Supabase database.

**Solution**:
1. Go to https://app.supabase.com
2. Open your project
3. Go to **SQL Editor** (left sidebar)
4. Click **New query**
5. Copy ALL content from `supabase_setup.sql`
6. Paste and click **RUN**
7. Wait for "Success" message

**How to verify**:
- Go to **Table Editor**
- You should see a `users` table
- If not, the SQL script didn't run

### 2. Email Confirmation Enabled ⚠️

**Problem**: Supabase is waiting for email confirmation, but you can't receive the email.

**Solution**:
1. Go to **Authentication** → **Providers**
2. Click on **Email**
3. Find "Confirm email" setting
4. Turn it **OFF** for testing
5. Click **Save**

### 3. Wrong Supabase Credentials ⚠️

**Problem**: The URL or anon key in your app doesn't match your Supabase project.

**Solution**:
1. Go to **Settings** → **API** in Supabase
2. Copy your **Project URL**
3. Copy your **anon public** key
4. Update `lib/supabase/supabase_config.dart`:

```dart
static const String supabaseUrl = 'YOUR_URL_HERE';
static const String anonKey = 'YOUR_KEY_HERE';
```

### 4. User Already Exists ⚠️

**Problem**: You're trying to register with an email that's already registered.

**Solution**:
- Use a different email address
- OR delete the existing user:
  1. Go to **Authentication** → **Users**
  2. Find the user
  3. Click the three dots → Delete user

### 5. Row Level Security (RLS) Issue ⚠️

**Problem**: RLS policies are blocking the insert operation.

**Solution**:
1. Go to **Authentication** → **Policies**
2. Select `users` table
3. Make sure these policies exist:
   - "Users can insert own profile"
   - "Users can view own profile"
4. If not, run the SQL script again

## Step-by-Step Debugging

### Step 1: Verify Supabase Project

```
✅ Go to https://app.supabase.com
✅ Can you see your project?
✅ Is the project active (not paused)?
```

### Step 2: Check Database Tables

```
✅ Go to Table Editor
✅ Do you see a 'users' table?
✅ Click on 'users' - what columns do you see?
```

Expected columns:
- id (uuid)
- email (text)
- name (text)
- role (text)
- language_code (text)
- notifications_enabled (bool)
- emergency_contacts (jsonb)
- created_at (timestamptz)
- updated_at (timestamptz)

### Step 3: Check Authentication Settings

```
✅ Go to Authentication → Providers
✅ Is Email enabled?
✅ Click on Email - is "Confirm email" OFF?
```

### Step 4: Test with Different Email

Try registering with a completely new email:
- test1@example.com
- test2@example.com
- yourname123@example.com

### Step 5: Check Supabase Logs

```
✅ Go to Logs (left sidebar)
✅ Look for recent errors
✅ What do the error messages say?
```

## Quick Fix Commands

### If app needs restart:
In Flutter terminal, press **R** (capital R) for hot restart

### If you need to rebuild:
```bash
flutter clean
flutter pub get
flutter run
```

## Common Error Messages

### "Invalid API key"
- Your anon key is wrong
- Get correct key from Settings → API

### "Failed to load user"
- Users table doesn't exist
- Run SQL setup script

### "User already registered"
- Email is already used
- Use different email or delete user

### "Network request failed"
- Check internet connection
- Verify Supabase URL is correct
- Check if Supabase project is active

### "Row Level Security policy violation"
- RLS policies not set up correctly
- Run SQL setup script again

## Still Not Working?

### Option 1: Start Fresh

1. Delete your Supabase project
2. Create a new project
3. Get new URL and anon key
4. Update `lib/supabase/supabase_config.dart`
5. Run SQL setup script
6. Enable Email auth (disable confirmation)
7. Try again

### Option 2: Manual Database Setup

If SQL script fails, create table manually:

1. Go to Table Editor
2. Click "New table"
3. Name: `users`
4. Add columns as listed in Step 2 above
5. Set RLS policies manually

### Option 3: Check Flutter Console

After the app restarts, try signing up and immediately check the Flutter console output. Look for lines starting with "Auth Error:" - that will tell us the exact problem.

## Need More Help?

Tell me:
1. ✅ Did you run the SQL script? (Yes/No)
2. ✅ Do you see the `users` table? (Yes/No)
3. ✅ Is Email auth enabled? (Yes/No)
4. ✅ Is "Confirm email" turned OFF? (Yes/No)
5. ✅ What email are you trying to register with?
6. ✅ Any error messages in Supabase Logs?
