# Setup Dams Database - Quick Guide

## ⚠️ IMPORTANT: You MUST run this SQL script first!

The dam screen is empty because there's no data in the database yet.

## Step-by-Step Instructions:

### 1. Open Supabase Dashboard
- Go to: https://app.supabase.com
- Sign in to your account
- Select your project

### 2. Go to SQL Editor
- Click **SQL Editor** in the left sidebar
- Click **New query** button

### 3. Copy and Run the SQL Script
- Open the file: `setup_dams_table.sql`
- Copy ALL the content
- Paste it into the SQL Editor
- Click **RUN** button (bottom right)

### 4. Verify Success
You should see:
```
Dams table created and populated with 21 dams!
total_dams: 21
```

### 5. Restart Your App
- Stop the Flutter app (press 'q' in terminal)
- Run: `flutter run`
- Or just hot restart (press 'R')

### 6. Test the Dam Screen
1. Open app → Go to "Dams" tab
2. Click "State" dropdown → You should see 7 states
3. Select "Maharashtra"
4. Click "River" dropdown → You should see rivers
5. Select "Koyna River"
6. Click "Dam" dropdown → You should see "Koyna Dam"
7. Select it → View full dam details!

## What Data Will Be Added?

**21 Dams across 7 States:**
- Maharashtra (3 dams)
- Karnataka (3 dams)
- Tamil Nadu (3 dams)
- Kerala (3 dams)
- Gujarat (3 dams)
- Madhya Pradesh (3 dams)
- Rajasthan (3 dams)

## Troubleshooting

### If dropdowns are still empty:
1. Check Supabase logs for errors
2. Verify the SQL script ran successfully
3. Check Table Editor → dams table has data
4. Make sure RLS policies are created
5. Restart the app completely

### If you get RLS policy errors:
The script includes policies for both authenticated and anonymous users, so it should work.

### If table already exists:
The script uses `CREATE TABLE IF NOT EXISTS` so it's safe to run multiple times.

## Quick Check in Supabase

After running the script, go to:
- **Table Editor** → **dams**
- You should see 21 rows of dam data

## Next Steps

Once data is loaded:
- Test all state/river/dam combinations
- View dam details
- Check storage percentages
- Verify contact information

---

**Run the SQL script NOW to make the dam screen work!**
