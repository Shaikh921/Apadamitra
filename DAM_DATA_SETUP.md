# Dam Data Setup Guide

## Option 1: Use Dummy Data (Already Working!)

The app now automatically uses dummy data if the database is empty or unavailable. You can use the app right away with 12 pre-loaded dams across 5 states:

### States Available:
- **Maharashtra** (3 dams)
- **Karnataka** (3 dams)
- **Tamil Nadu** (2 dams)
- **Kerala** (2 dams)
- **Gujarat** (2 dams)

### Rivers Covered:
- Koyna River, Pravara River, Mula River
- Kaveri River, Tungabhadra River, Krishna River
- Vaigai River, Periyar River
- Narmada River, Tapi River

## Option 2: Insert Real Data into Supabase

If you want to use the database instead of dummy data:

### Step 1: Run the SQL Script

1. Go to Supabase Dashboard → SQL Editor
2. Click "New query"
3. Copy the content from `insert_dummy_dams.sql`
4. Click "RUN"
5. You should see "Successfully inserted 21 dummy dams across 7 states!"

This will add 21 dams across 7 states to your database.

### Step 2: Verify Data

1. Go to Table Editor → dams
2. You should see all 21 dams
3. Restart your app

## Dam Screen Features

### 1. State Selection
- Select from available states
- Dropdown shows all unique states

### 2. River Selection
- After selecting state, choose river
- Only shows rivers in selected state

### 3. Dam Selection
- After selecting river, choose specific dam
- Shows all dams on that river in that state

### 4. Dam Details
Once you select a dam, you'll see:
- Dam name and location
- Height and capacity
- Current storage level
- Storage percentage
- Managing agency
- Contact number
- Safety status
- Coordinates (latitude/longitude)

## Testing the Dam Screen

1. Open the app
2. Go to "Dams" tab (bottom navigation)
3. Select a state (e.g., "Maharashtra")
4. Select a river (e.g., "Koyna River")
5. Select a dam (e.g., "Koyna Dam")
6. View detailed information

## Adding More Dams

To add more dams to the database:

```sql
INSERT INTO dams (
  id, name, state_name, river_name, 
  latitude, longitude, height_meters, 
  capacity_mcm, current_storage_mcm, 
  managing_agency, contact_number, 
  safety_status, created_at, updated_at
)
VALUES (
  gen_random_uuid(),
  'Your Dam Name',
  'State Name',
  'River Name',
  12.3456,  -- latitude
  78.9012,  -- longitude
  50,       -- height in meters
  1000,     -- capacity in MCM
  800,      -- current storage in MCM
  'Managing Agency Name',
  '+91-1234-567890',
  'Safe',   -- or 'Warning' or 'Critical'
  NOW(),
  NOW()
);
```

## Current Status

✅ Dam service updated with dummy data fallback
✅ 12 dams available immediately
✅ No database required for testing
✅ SQL script ready for production data

The app will work perfectly with dummy data right now!
