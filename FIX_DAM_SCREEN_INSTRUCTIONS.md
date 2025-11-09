# Fix Dam Screen - Complete Instructions

## Problem
The dam screen shows empty dropdowns because there's no data in the Supabase database.

## Solution
You need to run a SQL script in Supabase to create the table and insert data.

---

## 🚀 Quick Fix (5 minutes)

### Step 1: Open Supabase
1. Go to https://app.supabase.com
2. Sign in
3. Select your project: `dgepxgnrviugwnxrrsxl`

### Step 2: Run SQL Script
1. Click **SQL Editor** (left sidebar)
2. Click **New query**
3. Open file: `setup_dams_table.sql` in your project
4. Copy ALL content (Ctrl+A, Ctrl+C)
5. Paste into SQL Editor
6. Click **RUN** (green button, bottom right)

### Step 3: Verify
You should see:
```
✅ Dams table created and populated with 21 dams!
✅ total_dams: 21
```

### Step 4: Restart App
In your terminal where Flutter is running:
- Press **R** (capital R) for hot restart
- Or press **q** to quit, then run `flutter run` again

### Step 5: Test
1. Open app
2. Go to **Dams** tab (bottom navigation)
3. Click **State** dropdown
4. You should now see: Maharashtra, Karnataka, Tamil Nadu, Kerala, Gujarat, Madhya Pradesh, Rajasthan
5. Select any state
6. Select a river
7. Select a dam
8. View details!

---

## 📊 What Data Gets Added?

The script adds **21 dams** across **7 Indian states**:

| State | Dams | Rivers |
|-------|------|--------|
| Maharashtra | 3 | Koyna, Pravara, Mula |
| Karnataka | 3 | Kaveri, Tungabhadra, Krishna |
| Tamil Nadu | 3 | Kaveri, Vaigai, Amaravathi |
| Kerala | 3 | Periyar, Kabini |
| Gujarat | 3 | Narmada, Tapi, Mahi |
| Madhya Pradesh | 3 | Narmada, Chambal |
| Rajasthan | 3 | Chambal, Mahi |

---

## 🔍 Troubleshooting

### Problem: Dropdowns still empty after running SQL
**Solution:**
1. Check Supabase Table Editor → dams table
2. Verify 21 rows exist
3. Hot restart app (press R in terminal)
4. Check Flutter console for errors

### Problem: SQL script fails
**Solution:**
1. Check if table already exists: `SELECT * FROM dams LIMIT 1;`
2. If exists, drop it: `DROP TABLE dams CASCADE;`
3. Run the setup script again

### Problem: "Permission denied" error
**Solution:**
1. Check RLS policies in Authentication → Policies
2. The script creates policies automatically
3. Verify "Allow public read access to dams" policy exists

### Problem: App shows "Failed to load dams"
**Solution:**
1. Check Supabase project is active (not paused)
2. Verify internet connection
3. Check Supabase credentials in `lib/supabase/supabase_config.dart`
4. Look at Flutter console for detailed error

---

## 📱 Expected Behavior After Fix

### State Dropdown
Shows: Maharashtra, Karnataka, Tamil Nadu, Kerala, Gujarat, Madhya Pradesh, Rajasthan

### River Dropdown (after selecting Maharashtra)
Shows: Koyna River, Mula River, Pravara River

### Dam Dropdown (after selecting Koyna River)
Shows: Koyna Dam

### Dam Details (after selecting Koyna Dam)
Shows:
- Name: Koyna Dam
- State: Maharashtra
- River: Koyna River
- Height: 103 meters
- Capacity: 2797 MCM
- Current Storage: 2100 MCM (75%)
- Managing Agency: Maharashtra State Electricity Board
- Contact: +91-2162-262345
- Safety Status: Safe
- Location: 17.3967°N, 73.7500°E

---

## ✅ Verification Checklist

- [ ] Opened Supabase Dashboard
- [ ] Ran `setup_dams_table.sql` in SQL Editor
- [ ] Saw success message with "21 dams"
- [ ] Verified data in Table Editor → dams
- [ ] Hot restarted Flutter app
- [ ] Opened Dams tab in app
- [ ] State dropdown shows 7 states
- [ ] Selected state and saw rivers
- [ ] Selected river and saw dams
- [ ] Selected dam and saw full details

---

## 🎯 Next Steps After Fix

Once the dam screen is working:
1. Test all state/river combinations
2. View different dam details
3. Check storage percentages
4. Verify contact information
5. Test the map integration (if implemented)

---

## 💡 Pro Tips

- The script is safe to run multiple times (uses IF NOT EXISTS)
- Data includes real Indian dams with accurate information
- You can add more dams using the INSERT template in the script
- Storage levels are dummy data - update them for real-time monitoring

---

**Run the SQL script NOW and your dam screen will work perfectly!**
