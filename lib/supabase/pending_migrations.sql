-- Pending migrations to align with current schema and policies

-- Ensure UUID generation extension is enabled
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Drop previously created triggers and function if they exist
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'update_users_updated_at'
  ) THEN
    EXECUTE 'DROP TRIGGER IF EXISTS update_users_updated_at ON public.users';
  END IF;

  IF EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'update_iot_data_updated_at'
  ) THEN
    EXECUTE 'DROP TRIGGER IF EXISTS update_iot_data_updated_at ON public.iot_data';
  END IF;

  IF EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'update_alerts_updated_at'
  ) THEN
    EXECUTE 'DROP TRIGGER IF EXISTS update_alerts_updated_at ON public.alerts';
  END IF;

  IF EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'update_dams_updated_at'
  ) THEN
    EXECUTE 'DROP TRIGGER IF EXISTS update_dams_updated_at ON public.dams';
  END IF;

  IF EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'update_predictions_updated_at'
  ) THEN
    EXECUTE 'DROP TRIGGER IF EXISTS update_predictions_updated_at ON public.predictions';
  END IF;

  IF EXISTS (
    SELECT 1 FROM pg_proc WHERE proname = 'update_updated_at_column'
  ) THEN
    EXECUTE 'DROP FUNCTION IF EXISTS update_updated_at_column()';
  END IF;
END
$$;
