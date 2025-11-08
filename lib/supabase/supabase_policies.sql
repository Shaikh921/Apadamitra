-- Apadamitra Row Level Security Policies

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.iot_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.predictions ENABLE ROW LEVEL SECURITY;

-- Users table policies
CREATE POLICY "Allow users to read their own data" ON public.users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Allow users to insert their own data" ON public.users
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow users to update their own data" ON public.users
  FOR UPDATE USING (auth.uid() = id) WITH CHECK (true);

CREATE POLICY "Allow admins to read all users" ON public.users
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.users
      WHERE id = auth.uid() AND role IN ('admin', 'authority')
    )
  );

-- IoT Data policies
CREATE POLICY "Allow authenticated users to read iot_data" ON public.iot_data
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to insert iot_data" ON public.iot_data
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to update iot_data" ON public.iot_data
  FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to delete iot_data" ON public.iot_data
  FOR DELETE USING (auth.role() = 'authenticated');

-- Alerts policies
CREATE POLICY "Allow authenticated users to read alerts" ON public.alerts
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to insert alerts" ON public.alerts
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to update alerts" ON public.alerts
  FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to delete alerts" ON public.alerts
  FOR DELETE USING (auth.role() = 'authenticated');

-- Dams policies
CREATE POLICY "Allow authenticated users to read dams" ON public.dams
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to insert dams" ON public.dams
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to update dams" ON public.dams
  FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to delete dams" ON public.dams
  FOR DELETE USING (auth.role() = 'authenticated');

-- Predictions policies
CREATE POLICY "Allow authenticated users to read predictions" ON public.predictions
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to insert predictions" ON public.predictions
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to update predictions" ON public.predictions
  FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to delete predictions" ON public.predictions
  FOR DELETE USING (auth.role() = 'authenticated');
