-- ============================================================
-- Migration: cars, bookings, payments
-- Roles: Super_Admin | Admin | User | Guest
-- ============================================================

-- ── CARS ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cars (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id      uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  brand         text NOT NULL,
  model         text NOT NULL,
  year          int  NOT NULL CHECK (year >= 1990 AND year <= 2030),
  plate         text NOT NULL UNIQUE,
  daily_rate    numeric(10,2) NOT NULL CHECK (daily_rate > 0),
  status        text NOT NULL DEFAULT 'available'
                  CHECK (status IN ('available','rented','maintenance','inactive')),
  image_urls    text[]   DEFAULT '{}',
  location      text,
  notes         text,
  created_at    timestamptz DEFAULT now(),
  updated_at    timestamptz DEFAULT now()
);

ALTER TABLE public.cars ENABLE ROW LEVEL SECURITY;

-- Guest/User: ดูรถที่ available
CREATE POLICY "cars_select_available" ON public.cars
  FOR SELECT USING (status = 'available' OR
    (SELECT role FROM public.profiles WHERE id = auth.uid()) IN ('Admin','Super_Admin'));

-- Admin+: จัดการรถทุกคัน
CREATE POLICY "cars_admin_all" ON public.cars
  FOR ALL USING (
    (SELECT role FROM public.profiles WHERE id = auth.uid()) IN ('Admin','Super_Admin')
  );

-- ── BOOKINGS ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.bookings (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  car_id        uuid NOT NULL REFERENCES public.cars(id) ON DELETE RESTRICT,
  user_id       uuid NOT NULL REFERENCES auth.users(id) ON DELETE RESTRICT,
  start_date    date NOT NULL,
  end_date      date NOT NULL CHECK (end_date > start_date),
  total_amount  numeric(10,2) NOT NULL CHECK (total_amount > 0),
  status        text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','confirmed','active','completed','cancelled')),
  checkin_at    timestamptz,
  checkout_at   timestamptz,
  nfc_token     text UNIQUE,
  notes         text,
  created_at    timestamptz DEFAULT now(),
  updated_at    timestamptz DEFAULT now()
);

ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

-- User: ดูและสร้างการจองของตัวเอง
CREATE POLICY "bookings_user_own" ON public.bookings
  FOR SELECT USING (user_id = auth.uid() OR
    (SELECT role FROM public.profiles WHERE id = auth.uid()) IN ('Admin','Super_Admin'));

CREATE POLICY "bookings_user_insert" ON public.bookings
  FOR INSERT WITH CHECK (user_id = auth.uid() AND
    (SELECT role FROM public.profiles WHERE id = auth.uid()) IN ('User','Admin','Super_Admin'));

-- Admin+: จัดการทุกการจอง
CREATE POLICY "bookings_admin_all" ON public.bookings
  FOR ALL USING (
    (SELECT role FROM public.profiles WHERE id = auth.uid()) IN ('Admin','Super_Admin')
  );

-- ── PAYMENTS ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.payments (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id      uuid NOT NULL REFERENCES public.bookings(id) ON DELETE RESTRICT,
  user_id         uuid NOT NULL REFERENCES auth.users(id) ON DELETE RESTRICT,
  amount          numeric(10,2) NOT NULL CHECK (amount > 0),
  method          text NOT NULL
                    CHECK (method IN ('promptpay','bank_transfer','cash','card')),
  status          text NOT NULL DEFAULT 'pending'
                    CHECK (status IN ('pending','paid','failed','refunded')),
  slip_url        text,
  promptpay_ref   text,
  paid_at         timestamptz,
  created_at      timestamptz DEFAULT now()
);

ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;

-- User: ดูและสร้าง payment ของตัวเอง
CREATE POLICY "payments_user_own" ON public.payments
  FOR SELECT USING (user_id = auth.uid() OR
    (SELECT role FROM public.profiles WHERE id = auth.uid()) IN ('Admin','Super_Admin'));

CREATE POLICY "payments_user_insert" ON public.payments
  FOR INSERT WITH CHECK (user_id = auth.uid());

-- Admin+: จัดการทุก payment
CREATE POLICY "payments_admin_all" ON public.payments
  FOR ALL USING (
    (SELECT role FROM public.profiles WHERE id = auth.uid()) IN ('Admin','Super_Admin')
  );

-- ── UPDATED_AT TRIGGER ────────────────────────────────────
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$$;

CREATE TRIGGER cars_updated_at     BEFORE UPDATE ON public.cars     FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER bookings_updated_at BEFORE UPDATE ON public.bookings FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ── AUDIT LOG TRIGGER ─────────────────────────────────────
CREATE OR REPLACE FUNCTION public.audit_trigger()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.audit_log (actor_id, actor_role, action, table_name, record_id, old_data, new_data)
  VALUES (
    auth.uid(),
    COALESCE((SELECT role FROM public.profiles WHERE id = auth.uid()), 'Guest'),
    TG_OP,
    TG_TABLE_NAME,
    COALESCE(NEW.id, OLD.id),
    CASE WHEN TG_OP = 'DELETE' THEN to_jsonb(OLD) ELSE NULL END,
    CASE WHEN TG_OP != 'DELETE' THEN to_jsonb(NEW) ELSE NULL END
  );
  RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE TRIGGER bookings_audit AFTER INSERT OR UPDATE OR DELETE ON public.bookings FOR EACH ROW EXECUTE FUNCTION public.audit_trigger();
CREATE TRIGGER payments_audit AFTER INSERT OR UPDATE OR DELETE ON public.payments FOR EACH ROW EXECUTE FUNCTION public.audit_trigger();
