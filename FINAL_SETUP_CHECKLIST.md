# Final Setup Checklist

## ✅ What's Been Done

1. [x] Firebase integrated
2. [x] Multi-language support (6 languages)
3. [x] Admin panel created
4. [x] Dam management implemented
5. [x] Alert management implemented
6. [x] Push notifications ready
7. [x] Dark mode working
8. [x] Role-based access control

## 🔧 If App Doesn't Start

### Run these commands:
```bash
flutter clean
flutter pub get
flutter run
```

## 📝 Before Testing Admin Features

### 1. Make Yourself Admin (Supabase SQL):
```sql
UPDATE users 
SET role = 'admin' 
WHERE email = 'irafanshaikh505@gmail.com';
```

### 2. Fix Missing User Profiles (if needed):
```sql
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

### 3. Set Up RLS Policies (if getting permission errors):
```sql
-- Allow admins to insert dams
CREATE POLICY "Admins can insert dams"
  ON dams FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() 
      AND users.role IN ('admin', 'operator')
    )
  );

-- Allow admins to insert alerts
CREATE POLICY "Admins can insert alerts"
  ON alerts FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() 
      AND users.role IN ('admin', 'operator')
    )
  );
```

## 🎯 Testing Steps

Once app loads:

1. **Login** with your admin account
2. **Go to Profile** tab
3. **Click "Admin Panel"** button
4. **Test Dam Management**:
   - Click "Dam Management"
   - Click "+ Add Dam"
   - Fill form and save
5. **Test Alert Management**:
   - Click "Alert Management"
   - Click "+ Create Alert"
   - Fill form and send

## 📱 Expected Behavior

- Admin Panel button visible in Profile
- Can add dams successfully
- Can create alerts successfully
- Push notifications sent
- Data saved to Supabase

## 🐛 Common Issues

### Issue: "Admin Panel" button not showing
**Solution**: Make sure you ran the UPDATE query to set role='admin'

### Issue: Permission denied when adding dam
**Solution**: Run the RLS policy SQL scripts

### Issue: Can't send notifications
**Solution**: Firebase is set up, notifications will work once FCM token is generated

### Issue: App crashes on startup
**Solution**: Run `flutter clean` and `flutter run` again

## ✅ Success Indicators

- ✅ App starts without errors
- ✅ Can login as admin
- ✅ Admin Panel button visible
- ✅ Can navigate to Dam/Alert Management
- ✅ Forms open and work
- ✅ Data saves to database

---

**The app is building now. It will take 2-3 minutes after flutter clean.**
