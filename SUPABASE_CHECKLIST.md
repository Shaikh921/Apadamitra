# Supabase Setup Checklist ✅

Complete these steps in order:

## ☐ Step 1: Access Supabase Dashboard
- [ ] Go to https://app.supabase.com
- [ ] Sign in or create account
- [ ] Verify you can see your projects

## ☐ Step 2: Verify/Create Project
- [ ] Check if project `dgepxgnrviugwnxrrsxl` exists
- [ ] If not, create a new project
- [ ] Wait for project to finish setting up (2-3 min)

## ☐ Step 3: Get API Credentials
- [ ] Go to Settings → API
- [ ] Copy Project URL
- [ ] Copy anon/public key
- [ ] Update `lib/supabase/supabase_config.dart` if needed

## ☐ Step 4: Run SQL Script
- [ ] Go to SQL Editor
- [ ] Click "New query"
- [ ] Copy content from `supabase_setup.sql`
- [ ] Paste and click RUN
- [ ] Verify "Success" message appears

## ☐ Step 5: Verify Tables Created
- [ ] Go to Table Editor
- [ ] Check these tables exist:
  - [ ] users
  - [ ] iot_sensors
  - [ ] iot_data
  - [ ] alerts
  - [ ] dams
  - [ ] predictions

## ☐ Step 6: Enable Email Auth
- [ ] Go to Authentication → Providers
- [ ] Verify Email is enabled (toggle ON)
- [ ] Click on Email provider
- [ ] Turn OFF "Confirm email" (for testing)
- [ ] Click Save

## ☐ Step 7: Check RLS Policies
- [ ] Go to Authentication → Policies
- [ ] Select "users" table
- [ ] Verify policies exist:
  - [ ] Users can view own profile
  - [ ] Users can update own profile
  - [ ] Users can insert own profile

## ☐ Step 8: Hot Reload App
- [ ] In terminal, press 'r' for hot reload
- [ ] Or press 'R' for hot restart
- [ ] App should reload with updated code

## ☐ Step 9: Test Registration
- [ ] Open app on emulator
- [ ] Click "Sign Up"
- [ ] Enter test details:
  - Name: Test User
  - Email: test@example.com
  - Password: Test123456
- [ ] Click Sign Up button
- [ ] Check what error appears (should be more detailed now)

## ☐ Step 10: Verify in Supabase
- [ ] Go to Authentication → Users
- [ ] Check if user was created
- [ ] Go to Table Editor → users
- [ ] Check if profile was created

---

## 🎯 Current Status

Your app is running and showing "Authentication failed" error.

**Next Action**: 
1. Follow the checklist above
2. After Step 8 (hot reload), try signing up again
3. The error message should now show the actual problem
4. Tell me what error you see

## 📝 Quick Commands

In your Flutter terminal:
- Press **r** = Hot reload (fast, keeps state)
- Press **R** = Hot restart (full restart)
- Press **q** = Quit app
