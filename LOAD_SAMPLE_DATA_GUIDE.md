# How to Load Sample Data for General Users

## ✅ **Solution Implemented!**

I've added a **"Load Sample Data"** button in the Profile screen that any user can use to populate the database with sample dams and alerts.

## 📱 **How to Use:**

### **Step 1: Open Profile Screen**
1. Login to the app (as any user - admin or general)
2. Navigate to the **Profile** tab (bottom navigation)

### **Step 2: Find Database Section**
1. Scroll down in the Profile screen
2. Look for the **"Database"** section
3. You'll see **"Load Sample Data"** option

### **Step 3: Load Data**
1. Tap on **"Load Sample Data"**
2. Wait a few seconds (loading indicator will show)
3. You'll see a success message: ✅ "Sample data loaded successfully! 3 Dams and 2 Alerts added."

### **Step 4: View Data**
1. Go to **Dams** tab → You'll see 3 sample dams
2. Go to **Alerts** tab → You'll see 2 sample alerts

## 📊 **What Data Gets Loaded:**

### **3 Sample Dams:**
1. **Vishupuri Dam**
   - State: Maharashtra
   - River: Godavari
   - Capacity: 1000 MCM
   - Current Storage: 850 MCM (85%)

2. **Koyna Dam**
   - State: Maharashtra
   - River: Koyna
   - Capacity: 2797 MCM
   - Current Storage: 2100 MCM (75%)

3. **Bhandardara Dam**
   - State: Maharashtra
   - River: Pravara
   - Capacity: 300 MCM
   - Current Storage: 250 MCM (83%)

### **2 Sample Alerts:**
1. **Heavy Rainfall Alert**
   - Type: Flood
   - Severity: Medium
   - River: Godavari
   - Dam: Vishupuri Dam
   - Expires: 2 days

2. **Dam Water Level Rising**
   - Type: Dam Overflow
   - Severity: High
   - River: Koyna
   - Dam: Koyna Dam
   - Expires: 3 days

## 🔄 **Can I Load Data Multiple Times?**

Yes! The system checks if data already exists:
- If dams already exist → Skips adding more dams
- If alerts already exist → Skips adding more alerts
- You'll see a message indicating what was added

## 🎯 **Who Can Use This?**

**Everyone!** Both admin and general users can load sample data:
- ✅ Admin users
- ✅ General users
- ✅ Any authenticated user

## 🔍 **Troubleshooting:**

### **Issue: Button doesn't work**
**Solution:** Make sure you're logged in and have internet connection

### **Issue: Data doesn't appear**
**Solution:** 
1. After loading data, navigate away and come back
2. Or pull down to refresh the Dams/Alerts screen

### **Issue: Error message appears**
**Solution:** Check the error message:
- If it says "already exists" → Data is already loaded
- If it says "connection error" → Check internet connection
- If it says "permission denied" → Check Supabase RLS policies

## 📝 **Alternative: Automatic Loading**

The app also tries to load sample data automatically when:
- You first login (if database is empty)
- App starts (if authenticated and database is empty)

But the manual button gives you control!

## 🎨 **UI Location:**

```
Profile Screen
  ↓
Settings Section
  ↓
Database Section
  ↓
"Load Sample Data" button
```

## ✅ **Expected Result:**

After loading:
- **Dams Tab**: Shows 3 dams in Maharashtra
- **Alerts Tab**: Shows 2 active alerts
- **Dashboard**: Shows updated statistics
- **All users** can see the data

## 🚀 **Quick Steps:**

1. Open app
2. Go to Profile tab
3. Scroll to "Database" section
4. Tap "Load Sample Data"
5. Wait for success message
6. Go to Dams/Alerts tabs
7. See the data! 🎉

---

**Status**: ✅ Feature Added
**Location**: Profile Screen → Database Section
**Access**: All authenticated users
**Data**: 3 Dams + 2 Alerts
