# Fix Registration Error

## 🐛 Problem
Users can register in Supabase Auth, but their profile isn't created in the `users` table, causing "Null check operator" error.

## ✅ Solution

### Step 1: Fix Existing Users
Run this in Supabase SQL Editor:

```sql
-- Create profiles for users who don't have them
INSERT INTO public.users (id, email, name, role, language_code, notifications_enabled, emergency_contacts, created_at, updated_at)
SELECT 
  au.id,
  au.email,
  COALESCE(au.raw_user_meta_data->>'name', 'User') as name,
  'user' as role,
  'en' as language_code,
  true as notifications_enabled,
  '{}'::text[] as emergency_contacts,
  au.created_at,
  NOW() as updated_at
FROM auth.users au
LEFT JOIN public.users pu ON au.id = pu.id
WHERE pu.id IS NULL
ON CONFLICT (id) DO NOTHING;
```

### Step 2: Verify the Trigger Exists
Check if the auto-profile creation trigger exists:

```sql
-- Check if trigger exists
SELECT * FROM pg_trigger WHERE tgname = 'on_auth_user_created';

-- Check if function exists
SELECT * FROM pg_proc WHERE proname = 'handle_new_user';
```

If they don't exist, run the `supabase_setup.sql` script again.

### Step 3: Hot Restart App
- Press **R** in Flutter terminal
- Try logging in with existing users
- Try registering new users

---

## 🔧 Updated Code
I've updated `auth_service.dart` to:
- ✅ Better error handling
- ✅ Automatic profile creation if trigger fails
- ✅ More detailed error messages
- ✅ Retry logic

---

## 📝 Test Registration

1. **Use a NEW email** (not one you tried before)
2. **Wait 60 seconds** (Supabase rate limit)
3. **Try registering again**
4. **Should work now!**

---

## ⚠️ Rate Limit Issue
If you see "For security purposes, you can only request this after X seconds":
- This is Supabase's anti-spam protection
- Wait 60 seconds between signup attempts
- Or use different email addresses

---

## ✅ After Fix
- Existing users can log in
- New users can register
- Profiles are created automatically
- No more null errors

**Run the SQL fix script now, then hot restart the app!**
