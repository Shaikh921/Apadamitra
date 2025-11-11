# Fix: No Data Visible for Regular Users

## 🔍 **Problem Identified**

Regular users cannot see dams or alerts because the database is empty. There's no data to display!

## ✅ **Solution Implemented**

I've created an automatic database seeding system that will add sample data when the app starts.

### **What Was Added:**

1. **Database Helper** (`lib/utils/database_helper.dart`)
   - Checks if database has data
   - Seeds sample dams and alerts if empty
   - Provides database status information

2. **Auto-Seeding on App Start** (`lib/main.dart`)
   - Automatically checks database on app launch
   - Seeds sample data if needed
   - Only runs for authenticated users

### **Sample Data Included:**

#### **3 Sample Dams:**
1. **Vishupuri Dam** - Maharashtra, Godavari River
2. **Koyna Dam** - Maharashtra, Koyna River
3. **Bhandardara Dam** - Maharashtra, Pravara River

#### **2 Sample Alerts:**
1. **Heavy Rainfall Alert** - Medium severity
2. **Dam Water Level Rising** - High severity

## 🚀 **How to Fix**

### **Option 1: Automatic (Recommended)**

Just restart the app! The system will automatically:
1. Check if database is empty
2. Seed sample data if needed
3. Display data to all users

```bash
# Stop the app
# Then run again
flutter run
```

### **Option 2: Manual Seeding**

If you want to manually seed data, you can call:

```dart
import 'package:riverwise/utils/database_helper.dart';

// In any screen or button
await DatabaseHelper.seedAllSampleData();
```

### **Option 3: Check Database Status**

To see what's in the database:

```dart
final status = await DatabaseHelper.getDatabaseStatus();
print('Database Status: $status');
// Output: {dams: 3, alerts: 2, profiles: X, has_data: true}
```

## 🔧 **Testing Steps**

1. **Logout** from admin account
2. **Login** as regular user
3. **Navigate** to Dams tab
4. **You should see** 3 sample dams
5. **Navigate** to Alerts tab
6. **You should see** 2 sample alerts

## 📊 **Verify Data**

### **Check Dams:**
```dart
// In dam_info_screen.dart
final dams = await DamService().getAll();
print('Total dams: ${dams.length}');
```

### **Check Alerts:**
```dart
// In alerts_screen.dart
final alerts = await AlertService().getActiveAlerts();
print('Active alerts: ${alerts.length}');
```

## 🐛 **If Still No Data**

### **Check Supabase RLS Policies**

The issue might be Row Level Security (RLS) in Supabase. Check your policies:

1. Go to Supabase Dashboard
2. Navigate to Authentication → Policies
3. Check `dams` table policies
4. Check `alerts` table policies

**Required Policies:**

```sql
-- Allow all authenticated users to read dams
CREATE POLICY "Allow authenticated users to read dams"
ON dams FOR SELECT
TO authenticated
USING (true);

-- Allow all authenticated users to read alerts
CREATE POLICY "Allow authenticated users to read alerts"
ON alerts FOR SELECT
TO authenticated
USING (true);
```

### **Check User Authentication**

Make sure the user is properly authenticated:

```dart
final user = SupabaseConfig.auth.currentUser;
print('Current user: ${user?.email}');
print('User ID: ${user?.id}');
```

## 📝 **Add More Data**

### **Add More Dams:**

```dart
await SupabaseService.insert('dams', {
  'name': 'Your Dam Name',
  'state_name': 'State',
  'river_name': 'River',
  'latitude': 19.0,
  'longitude': 72.0,
  'height_meters': 100.0,
  'capacity_mcm': 1000.0,
  'current_storage_mcm': 800.0,
  'managing_agency': 'Agency Name',
  'contact_number': '+91-1234567890',
  'safety_status': 'Safe',
  'created_at': DateTime.now().toIso8601String(),
  'updated_at': DateTime.now().toIso8601String(),
});
```

### **Add More Alerts:**

```dart
await SupabaseService.insert('alerts', {
  'type': 'flood',
  'severity': 'medium',
  'title': 'Alert Title',
  'message': 'Alert message here',
  'river_name': 'River Name',
  'dam_name': 'Dam Name',
  'is_active': true,
  'expires_at': DateTime.now().add(Duration(days: 7)).toIso8601String(),
  'created_at': DateTime.now().toIso8601String(),
  'updated_at': DateTime.now().toIso8601String(),
});
```

## 🎯 **Expected Result**

After implementing this fix:

✅ Regular users can see dams
✅ Regular users can see alerts
✅ Data is automatically seeded on first launch
✅ No manual intervention needed

## 📞 **Still Having Issues?**

If you still can't see data:

1. Check Supabase dashboard for RLS policies
2. Verify user is authenticated
3. Check console logs for errors
4. Try manually seeding data
5. Check network connectivity

---

**Status**: ✅ Fix Implemented
**Next Step**: Restart the app and test with regular user account
