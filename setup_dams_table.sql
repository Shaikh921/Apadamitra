-- Complete Dams Table Setup
-- Run this in Supabase SQL Editor

-- 1. Create dams table if it doesn't exist
CREATE TABLE IF NOT EXISTS dams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    state_name TEXT NOT NULL,
    river_name TEXT NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    height_meters DOUBLE PRECISION NOT NULL,
    capacity_mcm DOUBLE PRECISION NOT NULL,
    current_storage_mcm DOUBLE PRECISION NOT NULL,
    managing_agency TEXT NOT NULL,
    contact_number TEXT,
    safety_status TEXT DEFAULT 'Safe',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Enable Row Level Security
ALTER TABLE dams ENABLE ROW LEVEL SECURITY;

-- 3. Create policy to allow authenticated users to read dams
CREATE POLICY "Allow authenticated users to read dams"
    ON dams FOR SELECT
    TO authenticated
    USING (true);

-- 4. Create policy to allow public read access (for testing)
CREATE POLICY "Allow public read access to dams"
    ON dams FOR SELECT
    TO anon
    USING (true);

-- 5. Insert dummy data
INSERT INTO dams (name, state_name, river_name, latitude, longitude, height_meters, capacity_mcm, current_storage_mcm, managing_agency, contact_number, safety_status)
VALUES
  -- Maharashtra
  ('Koyna Dam', 'Maharashtra', 'Koyna River', 17.3967, 73.7500, 103, 2797, 2100, 'Maharashtra State Electricity Board', '+91-2162-262345', 'Safe'),
  ('Bhandardara Dam', 'Maharashtra', 'Pravara River', 19.5500, 73.7500, 46, 301, 250, 'Irrigation Department Maharashtra', '+91-2422-222111', 'Safe'),
  ('Mulshi Dam', 'Maharashtra', 'Mula River', 18.5167, 73.4833, 58, 372, 320, 'Tata Power Company', '+91-2114-222333', 'Safe'),
  
  -- Karnataka
  ('Krishna Raja Sagara Dam', 'Karnataka', 'Kaveri River', 12.4258, 76.5750, 40, 1368, 1100, 'Karnataka Irrigation Department', '+91-8236-252525', 'Safe'),
  ('Tungabhadra Dam', 'Karnataka', 'Tungabhadra River', 15.2500, 76.3333, 49, 3531, 2800, 'Tungabhadra Board', '+91-8394-252626', 'Safe'),
  ('Almatti Dam', 'Karnataka', 'Krishna River', 16.3167, 75.9000, 52, 3105, 2500, 'Karnataka Water Resources', '+91-8352-262727', 'Safe'),
  
  -- Tamil Nadu
  ('Mettur Dam', 'Tamil Nadu', 'Kaveri River', 11.7833, 77.8000, 65, 2648, 2000, 'Tamil Nadu Water Resources', '+91-4298-222444', 'Safe'),
  ('Vaigai Dam', 'Tamil Nadu', 'Vaigai River', 10.0833, 77.5500, 35, 194, 150, 'Tamil Nadu PWD', '+91-4546-232323', 'Safe'),
  ('Amaravathi Dam', 'Tamil Nadu', 'Amaravathi River', 10.3333, 77.0000, 33, 90, 70, 'Tamil Nadu Irrigation', '+91-4259-242424', 'Safe'),
  
  -- Kerala
  ('Idukki Dam', 'Kerala', 'Periyar River', 9.8500, 77.1000, 169, 1996, 1600, 'Kerala State Electricity Board', '+91-4862-232525', 'Safe'),
  ('Mullaperiyar Dam', 'Kerala', 'Periyar River', 9.5500, 77.1500, 53, 443, 380, 'Tamil Nadu PWD', '+91-4869-242626', 'Warning'),
  ('Banasura Sagar Dam', 'Kerala', 'Kabini River', 11.6167, 76.0833, 37, 193, 150, 'Kerala Irrigation Department', '+91-4936-252727', 'Safe'),
  
  -- Gujarat
  ('Sardar Sarovar Dam', 'Gujarat', 'Narmada River', 21.8333, 73.7500, 163, 9500, 7500, 'Narmada Valley Development Authority', '+91-2640-262828', 'Safe'),
  ('Ukai Dam', 'Gujarat', 'Tapi River', 21.2500, 73.5833, 80, 8511, 6800, 'Gujarat Water Resources', '+91-2626-272929', 'Safe'),
  ('Kadana Dam', 'Gujarat', 'Mahi River', 23.2500, 73.7500, 61, 1465, 1200, 'Gujarat Irrigation Department', '+91-2678-282930', 'Safe'),
  
  -- Madhya Pradesh
  ('Indira Sagar Dam', 'Madhya Pradesh', 'Narmada River', 22.2167, 76.4667, 92, 12220, 10000, 'Narmada Hydroelectric Development Corporation', '+91-7280-293031', 'Safe'),
  ('Omkareshwar Dam', 'Madhya Pradesh', 'Narmada River', 22.2667, 76.1500, 54, 987, 800, 'MP Water Resources', '+91-7280-303132', 'Safe'),
  ('Gandhi Sagar Dam', 'Madhya Pradesh', 'Chambal River', 24.6833, 75.5500, 62, 7322, 6000, 'Chambal Valley Development Authority', '+91-7422-313233', 'Safe'),
  
  -- Rajasthan
  ('Rana Pratap Sagar Dam', 'Rajasthan', 'Chambal River', 24.9167, 75.5833, 53, 2943, 2400, 'Rajasthan Irrigation Department', '+91-7463-323334', 'Safe'),
  ('Jawahar Sagar Dam', 'Rajasthan', 'Chambal River', 24.6167, 75.8167, 45, 79, 60, 'Rajasthan Water Resources', '+91-7463-333435', 'Safe'),
  ('Mahi Bajaj Sagar Dam', 'Rajasthan', 'Mahi River', 23.5833, 74.7167, 39, 3109, 2500, 'Mahi Bajaj Sagar Project', '+91-2953-343536', 'Safe')
ON CONFLICT (id) DO NOTHING;

-- 6. Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_dams_state ON dams(state_name);
CREATE INDEX IF NOT EXISTS idx_dams_river ON dams(river_name);
CREATE INDEX IF NOT EXISTS idx_dams_state_river ON dams(state_name, river_name);

-- Success message
SELECT 'Dams table created and populated with 21 dams!' as message;
SELECT COUNT(*) as total_dams FROM dams;
