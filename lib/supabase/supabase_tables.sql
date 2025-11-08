-- Apadamitra Supabase Database Schema

-- Ensure UUID generation is available
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Users table (linked to auth.users)
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'admin', 'authority')),
  phone_number TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  address TEXT,
  language_code TEXT NOT NULL DEFAULT 'en',
  notifications_enabled BOOLEAN NOT NULL DEFAULT true,
  emergency_contacts TEXT[] DEFAULT ARRAY[]::TEXT[],
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- IoT Data table for sensor readings
CREATE TABLE IF NOT EXISTS public.iot_data (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sensor_id TEXT NOT NULL,
  river_name TEXT NOT NULL,
  water_level DOUBLE PRECISION NOT NULL,
  rainfall DOUBLE PRECISION NOT NULL,
  flow_rate DOUBLE PRECISION NOT NULL,
  temperature DOUBLE PRECISION,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'verified', 'rejected')),
  verified_by UUID REFERENCES public.users(id),
  timestamp TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Alerts table
CREATE TABLE IF NOT EXISTS public.alerts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type TEXT NOT NULL CHECK (type IN ('flood', 'damOverflow', 'prediction', 'safety', 'system')),
  severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  river_name TEXT,
  dam_name TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  is_active BOOLEAN NOT NULL DEFAULT true,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Dams table
CREATE TABLE IF NOT EXISTS public.dams (
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
  safety_status TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Predictions table for AI flood predictions
CREATE TABLE IF NOT EXISTS public.predictions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  river_name TEXT NOT NULL,
  risk_level TEXT NOT NULL CHECK (risk_level IN ('low', 'medium', 'high', 'critical')),
  confidence_score DOUBLE PRECISION NOT NULL,
  predicted_water_level DOUBLE PRECISION NOT NULL,
  predicted_rainfall DOUBLE PRECISION NOT NULL,
  prediction_details TEXT NOT NULL,
  predicted_for TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_iot_data_river_timestamp ON public.iot_data(river_name, timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_iot_data_status ON public.iot_data(status);
CREATE INDEX IF NOT EXISTS idx_alerts_active ON public.alerts(is_active, expires_at);
CREATE INDEX IF NOT EXISTS idx_alerts_river ON public.alerts(river_name);
CREATE INDEX IF NOT EXISTS idx_dams_state_river ON public.dams(state_name, river_name);
CREATE INDEX IF NOT EXISTS idx_predictions_river ON public.predictions(river_name, created_at DESC);
