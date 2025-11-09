-- Insert Dummy Dam Data for Testing
-- Run this in Supabase SQL Editor

-- Maharashtra Dams
INSERT INTO dams (id, name, state_name, river_name, latitude, longitude, height_meters, capacity_mcm, current_storage_mcm, managing_agency, contact_number, safety_status, created_at, updated_at)
VALUES
  (gen_random_uuid(), 'Koyna Dam', 'Maharashtra', 'Koyna River', 17.3967, 73.7500, 103, 2797, 2100, 'Maharashtra State Electricity Board', '+91-2162-262345', 'Safe', NOW(), NOW()),
  (gen_random_uuid(), 'Bhandardara Dam', 'Maharashtra', 'Pravara River', 19.5500, 73.7500, 46, 301, 250, 'Irrigation Department Maharashtra', '+91-2422-222111', 'Safe', NOW(), NOW()),
  (gen_random_uuid(), 'Mulshi Dam', 'Maharashtra', 'Mula River', 18.5167, 73.4833, 58, 372, 320, 'Tata Power Company', '+91-2114-222333', 'Safe', NOW(), NOW());

-- Karnataka Dams
INSERT INTO dams (id, name, state_name, river_name, latitude, longitude, height_meters, capacity_mcm, current_storage_mcm, managing_agency, contact_number, safety_status, created_at, updated_at)
VALUES
  (gen_random_uuid(), 'Krishna Raja Sagara Dam', 'Karnataka', 'Kaveri River', 12.4258, 76.5750, 40, 1368, 1100, 'Karnataka Irrigation Department', '+91-8236-252525', 'Safe', NOW(), NOW()),
  (gen_random_uuid(), 'Tungabhadra Dam', 'Karnataka', 'Tungabhadra River', 15.2500, 76.3333, 49, 3531, 2800, 'Tungabhadra Board', '+91-8394-252626', 'Safe', NOW(), NOW()),
  (gen_random_uuid(), 'Almatti Dam', 'Karnataka', 'Krishna River', 16.3167, 75.9000, 52, 3105, 2500, 'Karnataka Water Resources', '+91-8352-262727', 'Safe', NOW(), NOW());

-- Tamil Nadu Dams
INSERT INTO dams (id, name, state_name, river_name, latitude, longitude, height_meters, capacity_mcm, current_storage_mcm, managing_agency, contact_number, safety_status, created_at, updated_at)
VALUES
  (gen_random_uuid(), 'Mettur Dam', 'Tamil Nadu', 'Kaveri River', 11.7833, 77.8000, 65, 2648, 2000, 'Tamil Nadu Water Resources', '+91-4298-222444', 'Safe', NOW(), NOW()),
  (gen_random_uuid(), 'Vaigai Dam', 'Tamil Nadu', 'Vaigai River', 10.0833, 77.5500, 35, 194, 150, 'Tamil Nadu PWD', '+91-4546-232323', 'Safe', NOW(), NOW()),
  (gen_random_uuid(), 'Amaravathi Dam', 'Tamil Nadu', 'Amaravathi River', 10.3333, 77.0000, 33, 90, 70, 'Tamil Nadu Irrigation', '+91-4259-242424', 'Safe', NOW(), NOW());

-- Kerala Dams
INSERT INTO dams (id, name, state_name, river_name, latitude, longitude, height_meters, capacity_mcm, current_storage_mcm, managing_agency, contact_number, safety_status, created_at, updated_at)
VALUES
  (gen_random_uuid(), 'Idukki Dam', 'Kerala', 'Periyar River', 9.8500, 77.1000, 169, 1996, 1600, 'Kerala State Electricity Board', '+91-4862-232525', 'Safe', NOW(), NOW()),
  (gen_random_uuid(), 'Mullaperiyar Dam', 'Kerala', 'Periyar River', 9.5500, 77.1500, 53, 443, 350, 'Tamil Nadu PWD', '+91-4869-242626', 'Warning', NOW(), NOW()),
  (gen_random_uuid(), 'Banasura Sagar Dam', 'Kerala', 'Kabini River', 11.6167, 76.0833, 37, 193, 150, 'Kerala Irrigation Department', '+91-4936-252727', 'Safe', NOW(), NOW());

-- Gujarat Dams
INSERT INTO dams (id, name, state_name, river_name, latitude, longitude, height_meters, capacity_mcm, current_storage_mcm, managing_agency, contact_number, safety_status, created_at, updated_at)
VALUES
  (gen_random_uuid(), 'Sardar Sarovar Dam', 'Gujarat', 'Narmada River', 21.8333, 73.7500, 163, 9500, 7500, 'Narmada Valley Development Authority', '+91-2640-262828', 'Safe', NOW(), NOW()),
  (gen_random_uuid(), 'Ukai Dam', 'Gujarat', 'Tapi River', 21.2500, 73.5833, 80, 8511, 6800, 'Gujarat Water Resources', '+91-2626-272929', 'Safe', NOW(), NOW()),
  (gen_random_uuid(), 'Kadana Dam', 'Gujarat', 'Mahi River', 23.2500, 73.7500, 61, 1465, 1200, 'Gujarat Irrigation Department', '+91-2678-282930', 'Safe', NOW(), NOW());

-- Madhya Pradesh Dams
INSERT INTO dams (id, name, state_name, river_name, latitude, longitude, height_meters, capacity_mcm, current_storage_mcm, managing_agency, contact_number, safety_status, created_at, updated_at)
VALUES
  (gen_random_uuid(), 'Indira Sagar Dam', 'Madhya Pradesh', 'Narmada River', 22.2167, 76.4667, 92, 12220, 10000, 'Narmada Hydroelectric Development Corporation', '+91-7280-293031', 'Safe', NOW(), NOW()),
  (gen_random_uuid(), 'Omkareshwar Dam', 'Madhya Pradesh', 'Narmada River', 22.2667, 76.1500, 54, 987, 800, 'MP Water Resources', '+91-7280-303132', 'Safe', NOW(), NOW()),
  (gen_random_uuid(), 'Gandhi Sagar Dam', 'Madhya Pradesh', 'Chambal River', 24.6833, 75.5500, 62, 7322, 6000, 'Chambal Valley Development Authority', '+91-7422-313233', 'Safe', NOW(), NOW());

-- Rajasthan Dams
INSERT INTO dams (id, name, state_name, river_name, latitude, longitude, height_meters, capacity_mcm, current_storage_mcm, managing_agency, contact_number, safety_status, created_at, updated_at)
VALUES
  (gen_random_uuid(), 'Rana Pratap Sagar Dam', 'Rajasthan', 'Chambal River', 24.9167, 75.5833, 53, 2943, 2400, 'Rajasthan Irrigation Department', '+91-7463-323334', 'Safe', NOW(), NOW()),
  (gen_random_uuid(), 'Jawahar Sagar Dam', 'Rajasthan', 'Chambal River', 24.6167, 75.8167, 45, 79, 60, 'Rajasthan Water Resources', '+91-7463-333435', 'Safe', NOW(), NOW()),
  (gen_random_uuid(), 'Mahi Bajaj Sagar Dam', 'Rajasthan', 'Mahi River', 23.5833, 74.7167, 39, 3109, 2500, 'Mahi Bajaj Sagar Project', '+91-2953-343536', 'Safe', NOW(), NOW());

-- Success message
SELECT 'Successfully inserted 21 dummy dams across 7 states!' as message;
