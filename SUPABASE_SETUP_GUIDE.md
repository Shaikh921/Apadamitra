# Supabase Setup Guide for Apadamitra

## Step 1: Run the SQL Script

1. Go to your Supabase Dashboard: https://app.supabase.com
2. Select your project (or create a new one)
3. Go to **SQL Editor** in the left sidebar
4. Click **New Query**
5. Copy and paste the entire content from `supabase_setup.sql`
6. Click **Run** to execute the script

This will create:
- ✅ Users table with proper schema
- ✅ Row Level Security (RLS) policies
- ✅ Automatic user profile creation on signup
- ✅ Additional tables for IoT data, alerts, dams, and predictions
- ✅ Proper indexes for performance

## Step 2: Verify Your Supabase Configuration

Your current configuration in `lib/supabase/supabase_config.dart`:
```dart
supabaseUrl: 'https://dgepxgnrviugwnxrrsxl.supabase.co'
anonKey: 'eyJhbGci...' (already configured)
```

## Step 3: Enable Email Authentication

1. In Supabase Dashboard, go to **Authentication** → **Providers**
2. Make sure **Email** is enabled
3. Configure email settings:
   - **Enable email confirmations**: Turn OFF for testing (turn ON for production)
   - **Secure email change**: Recommended to enable
   - **Secure password change**: Recommended to enable

## Step 4: Test Registration & Login

### Test Registration:
1. Run your Flutter app
2. Click "Sign Up"
3. Enter:
   - Name: Test User
   - Email: test@example.com
   - Password: Test123456
4. Click Sign Up

### What Should Happen:
- ✅ User created in `auth.users` table
- ✅ Profile automatically created in `users` table (via trigger)
- ✅ User logged in and redirected to main screen

### Test Login:
1. Sign out
2. Click "Sign In"
3. Enter the same email and password
4. Should log in successfully

## Step 5: Troubleshooting

### Problem: "Sign up failed: User already registered"
**Solution**: Email already exists. Use a different email or delete the user from Supabase Dashboard.

### Problem: "Failed to load user"
**Solution**: 
1. Check if the `users` table was created
2. Verify RLS policies are set correctly
3. Check if the trigger `on_auth_user_created` exists

### Problem: "Authentication failed: Invalid login credentials"
**Solution**: 
1. Make sure you're using the correct email/password
2. Check if email confirmation is required (disable for testing)

### Problem: "Row Level Security policy violation"
**Solution**: 
1. Make sure RLS policies are created correctly
2. Run the SQL script again to recreate policies

## Step 6: Check Database Tables

Go to **Table Editor** in Supabase Dashboard and verify:

1. **auth.users** - Should have your registered users
2. **users** - Should have matching profiles with additional data
3. **iot_sensors**, **iot_data**, **alerts**, **dams**, **predictions** - Should be empty initially

## Step 7: Make Your First User an Admin (Optional)

After signing up, run this SQL to make yourself an admin:

```sql
UPDATE users 
SET role = 'admin' 
WHERE email = 'your-email@example.com';
```

## Step 8: Security Best Practices

### For Production:
1. ✅ Enable email confirmation
2. ✅ Set up password requirements (min 8 characters)
3. ✅ Enable rate limiting
4. ✅ Review and tighten RLS policies
5. ✅ Use environment variables for Supabase credentials
6. ✅ Enable 2FA for admin accounts

### Environment Variables (Recommended):
Instead of hardcoding credentials, use:
```dart
// Create a .env file (add to .gitignore)
SUPABASE_URL=https://dgepxgnrviugwnxrrsxl.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
```

## Need Help?

If you encounter any issues:
1. Check Supabase logs: Dashboard → Logs
2. Check Flutter console for error messages
3. Verify your internet connection
4. Make sure Supabase project is not paused

## Next Steps

Once authentication is working:
1. ✅ Test user profile updates
2. ✅ Add IoT sensor data
3. ✅ Create alerts
4. ✅ Test the full app flow
