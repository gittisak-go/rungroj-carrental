-- =====================================================
-- Migration: Fix roles (Visitor→Guest) + audit_log
-- Roles: Super_Admin | Admin | User | Guest
-- =====================================================

-- 1. Fix role constraint: Visitor → Guest
ALTER TABLE public.profiles
  DROP CONSTRAINT IF EXISTS profiles_role_check;

ALTER TABLE public.profiles
  ADD CONSTRAINT profiles_role_check
  CHECK (role IN ('Super_Admin', 'Admin', 'User', 'Guest'));

UPDATE public.profiles
  SET role = 'Guest'
  WHERE role = 'Visitor';

-- 2. Fix trigger functions to use Guest instead of Visitor
CREATE OR REPLACE FUNCTION public.handle_new_user_role()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  user_email TEXT;
  assigned_role TEXT;
BEGIN
  user_email := LOWER(TRIM(NEW.email));
  IF user_email IN (
    'gittisakwannakeeree@gmail.com',
    'info@gtsalphamcp.com'
  ) THEN
    assigned_role := 'Super_Admin';
  ELSIF user_email LIKE '%@rungrojcarrental.th' THEN
    assigned_role := 'Admin';
  ELSE
    assigned_role := 'User';
  END IF;
  INSERT INTO public.profiles (id, email, role, created_at, updated_at)
  VALUES (NEW.id, user_email, assigned_role, NOW(), NOW())
  ON CONFLICT (id) DO UPDATE
    SET email = EXCLUDED.email, role = EXCLUDED.role, updated_at = NOW();
  RETURN NEW;
END;
$$;

-- 3. Create audit_log table
CREATE TABLE IF NOT EXISTS public.audit_log (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id    UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  actor_role  TEXT NOT NULL DEFAULT 'Guest',
  action      TEXT NOT NULL,         -- 'create','update','delete','login','approve'
  table_name  TEXT NOT NULL,
  record_id   UUID,
  old_data    JSONB,
  new_data    JSONB,
  ip_address  INET,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_audit_actor    ON public.audit_log(actor_id);
CREATE INDEX IF NOT EXISTS idx_audit_action   ON public.audit_log(action);
CREATE INDEX IF NOT EXISTS idx_audit_table    ON public.audit_log(table_name);
CREATE INDEX IF NOT EXISTS idx_audit_created  ON public.audit_log(created_at DESC);

ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

-- Only Super_Admin and Admin can read audit_log
CREATE POLICY "admins_read_audit"
  ON public.audit_log FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid()
      AND role IN ('Super_Admin', 'Admin')
    )
  );

-- System can insert (SECURITY DEFINER functions only)
CREATE POLICY "system_insert_audit"
  ON public.audit_log FOR INSERT TO authenticated
  WITH CHECK (actor_id = auth.uid());

-- 4. Audit log helper function
CREATE OR REPLACE FUNCTION public.log_audit(
  p_action      TEXT,
  p_table_name  TEXT,
  p_record_id   UUID DEFAULT NULL,
  p_old_data    JSONB DEFAULT NULL,
  p_new_data    JSONB DEFAULT NULL
) RETURNS VOID LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_role TEXT;
BEGIN
  SELECT role INTO v_role FROM public.profiles WHERE id = auth.uid();
  INSERT INTO public.audit_log(actor_id, actor_role, action, table_name, record_id, old_data, new_data)
  VALUES (auth.uid(), COALESCE(v_role,'Guest'), p_action, p_table_name, p_record_id, p_old_data, p_new_data);
END;
$$;

-- 5. Fix vehicles RLS — role-based
DROP POLICY IF EXISTS "Allow authenticated users to insert vehicles" ON public.vehicles;
DROP POLICY IF EXISTS "Allow authenticated users to update vehicles" ON public.vehicles;
DROP POLICY IF EXISTS "Allow authenticated users to delete vehicles" ON public.vehicles;

-- Super_Admin + Admin: full write
CREATE POLICY "admins_write_vehicles"
  ON public.vehicles FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('Super_Admin','Admin'))
  );

CREATE POLICY "admins_update_vehicles"
  ON public.vehicles FOR UPDATE TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('Super_Admin','Admin'))
  );

CREATE POLICY "admins_delete_vehicles"
  ON public.vehicles FOR DELETE TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'Super_Admin')
  );

-- 6. Fix reservations RLS — role-based
ALTER TABLE public.reservations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "reservations_select" ON public.reservations;
DROP POLICY IF EXISTS "reservations_insert" ON public.reservations;
DROP POLICY IF EXISTS "reservations_update" ON public.reservations;

-- User/Guest: read own reservations only
CREATE POLICY "users_read_own_reservations"
  ON public.reservations FOR SELECT TO authenticated
  USING (
    customer_email = (SELECT email FROM public.profiles WHERE id = auth.uid())
    OR EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('Super_Admin','Admin'))
  );

-- Any authenticated user can create reservation
CREATE POLICY "users_create_reservation"
  ON public.reservations FOR INSERT TO authenticated
  WITH CHECK (true);

-- Admin+ can update; user can cancel own
CREATE POLICY "admins_update_reservation"
  ON public.reservations FOR UPDATE TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('Super_Admin','Admin'))
    OR customer_email = (SELECT email FROM public.profiles WHERE id = auth.uid())
  );
