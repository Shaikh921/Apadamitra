-- ============================================
-- Supabase Database Setup for Apadamitra
-- Flood Monitoring & Safety System
-- ============================================

-- 1. Create Users Table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    role TEXT DEFAULT 'user' CHECK (role IN ('user', 'admin', 'operator')),
    language_code TEXT DEFAULT 'en',
    notifications_enabled BOOLEAN DEFAULT true,
    emergency_contacts JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Enable Row Level Security (RLS)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- 3. RLS Policies for Users Table

-- Allow users to read their own data
CREATE POLICY "Users can view own profile"
    ON users FOR SELECT
    USING (auth.uid() = id);

-- Allow users to update their own data
CREATE POLICY "Users can update own profile"
    ON users FOR UPDATE
    USING (auth.uid() = id);

-- Allow insert during signup (anyone can create their profile)
CREATE POLICY "Users can insert own profile"
    ON users FOR INSERT
    WITH CHECK (auth.uid() = id);

-- 4. Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 5. Create trigger for users table
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 6. Create function to handle new user signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users (id, email, name, role, language_code, notifications_enabled, emergency_contacts)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'name', 'User'),
        'user',
        'en',
        true,
        '[]'::jsonb
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 7. Create trigger on auth.users to auto-create profile
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION handle_new_user();

-- ============================================
-- Additional Tables (if needed for your app)
-- ============================================

-- IoT Sensors Table
CREATE TABLE IF NOT EXISTS iot_sensors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    location TEXT NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    sensor_type TEXT NOT NULL,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'maintenance')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- IoT Data Table
CREATE TABLE IF NOT EXISTS iot_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sensor_id UUID REFERENCES iot_sensors(id) ON DELETE CASCADE,
    water_level DOUBLE PRECISION,
    flow_rate DOUBLE PRECISION,
    temperature DOUBLE PRECISION,
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Alerts Table
CREATE TABLE IF NOT EXISTS alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    location TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Dams Table
CREATE TABLE IF NOT EXISTS dams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    location TEXT NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    capacity DOUBLE PRECISION,
    current_level DOUBLE PRECISION,
    status TEXT DEFAULT 'normal' CHECK (status IN ('normal', 'warning', 'critical')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Predictions Table
CREATE TABLE IF NOT EXISTS predictions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    location TEXT NOT NULL,
    predicted_level DOUBLE PRECISION,
    confidence DOUBLE PRECISION,
    prediction_time TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS for all tables
ALTER TABLE iot_sensors ENABLE ROW LEVEL SECURITY;
ALTER TABLE iot_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE dams ENABLE ROW LEVEL SECURITY;
ALTER TABLE predictions ENABLE ROW LEVEL SECURITY;

-- Public read access for authenticated users
CREATE POLICY "Authenticated users can view sensors"
    ON iot_sensors FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Authenticated users can view iot data"
    ON iot_data FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Authenticated users can view alerts"
    ON alerts FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Authenticated users can view dams"
    ON dams FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Authenticated users can view predictions"
    ON predictions FOR SELECT
    TO authenticated
    USING (true);

-- ============================================
-- Indexes for Performance
-- ============================================

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_iot_data_sensor_id ON iot_data(sensor_id);
CREATE INDEX IF NOT EXISTS idx_iot_data_timestamp ON iot_data(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_alerts_created_at ON alerts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_alerts_is_active ON alerts(is_active);
CREATE INDEX IF NOT EXISTS idx_predictions_prediction_time ON predictions(prediction_time DESC);

-- ============================================
-- Sample Data (Optional - for testing)
-- ============================================

-- Insert sample admin user (update with your email after signup)
-- UPDATE users SET role = 'admin' WHERE email = 'your-email@example.com';
