-- Fix for users who registered but don't have profiles

-- Check which auth users don't have profiles
SELECT au.id, au.email, au.created_at
FROM auth.users au
LEFT JOIN public.users pu ON au.id = pu.id
WHERE pu.id IS NULL;

-- Create profiles for missing users
-- Run this after checking the above query
INSERT INTO public.users (id, email, name, role, language_code, notifications_enabled, emergency_contacts, created_at, updated_at)
SELECT 
  au.id,
  au.email,
  COALESCE(au.raw_user_meta_data->>'name', 'User') as name,
  'user' as role,
  'en' as language_code,
  true as notifications_enabled,
  '[]'::text[] as emergency_contacts,
  au.created_at,
  NOW() as updated_at
FROM auth.users au
LEFT JOIN public.users pu ON au.id = pu.id
WHERE pu.id IS NULL;

-- Verify all users now have profiles
SELECT COUNT(*) as auth_users FROM auth.users;
SELECT COUNT(*) as profile_users FROM public.users;
