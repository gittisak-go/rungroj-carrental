-- Add role column to existing profiles table
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS role TEXT NOT NULL DEFAULT 'User'
CHECK (role IN ('Super_Admin', 'Admin', 'User', 'Visitor'));

ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS email TEXT;

-- Index for role lookups
CREATE INDEX IF NOT EXISTS idx_profiles_role ON public.profiles(role);
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);

-- Function to handle new user creation via Magic Link
-- Assigns Super_Admin role for known admin emails, User role for everyone else
CREATE OR REPLACE FUNCTION public.handle_new_user_role()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    user_email TEXT;
    assigned_role TEXT;
BEGIN
    user_email := LOWER(TRIM(NEW.email));

    -- Determine role based on email
    IF user_email IN (
        'gittisakwannakeeree@gmail.com',
        'info@gtsalphamcp.com',
        'director@gtsalphamcp.com',
        'phongwut.w@gmail.com'
    ) THEN
        assigned_role := 'Super_Admin';
    ELSE
        assigned_role := 'User';
    END IF;

    -- Upsert profile with role and email
    INSERT INTO public.profiles (id, email, role, created_at, updated_at)
    VALUES (NEW.id, user_email, assigned_role, NOW(), NOW())
    ON CONFLICT (id) DO UPDATE
        SET
            email = EXCLUDED.email,
            role = EXCLUDED.role,
            updated_at = NOW();

    RETURN NEW;
END;
$$;

-- Drop existing trigger if any, then create new one
DROP TRIGGER IF EXISTS on_auth_user_created_role ON auth.users;
CREATE TRIGGER on_auth_user_created_role
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user_role();

-- Also handle sign-in (Magic Link creates/updates session)
-- Update role on email confirmation (Magic Link flow)
CREATE OR REPLACE FUNCTION public.handle_user_login_role()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    user_email TEXT;
    assigned_role TEXT;
BEGIN
    -- Only process when email is confirmed (Magic Link confirmation)
    IF NEW.email_confirmed_at IS NOT NULL AND OLD.email_confirmed_at IS NULL THEN
        user_email := LOWER(TRIM(NEW.email));

        IF user_email IN (
            'gittisakwannakeeree@gmail.com',
            'info@gtsalphamcp.com',
            'director@gtsalphamcp.com',
            'phongwut.w@gmail.com'
        ) THEN
            assigned_role := 'Super_Admin';
        ELSE
            assigned_role := 'User';
        END IF;

        INSERT INTO public.profiles (id, email, role, created_at, updated_at)
        VALUES (NEW.id, user_email, assigned_role, NOW(), NOW())
        ON CONFLICT (id) DO UPDATE
            SET
                email = EXCLUDED.email,
                role = EXCLUDED.role,
                updated_at = NOW();
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_updated_role ON auth.users;
CREATE TRIGGER on_auth_user_updated_role
    AFTER UPDATE ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_user_login_role();

-- RLS: Allow authenticated users to read their own profile
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "users_read_own_profile" ON public.profiles;
CREATE POLICY "users_read_own_profile"
    ON public.profiles
    FOR SELECT
    TO authenticated
    USING (id = auth.uid());

DROP POLICY IF EXISTS "users_update_own_profile" ON public.profiles;
CREATE POLICY "users_update_own_profile"
    ON public.profiles
    FOR UPDATE
    TO authenticated
    USING (id = auth.uid())
    WITH CHECK (id = auth.uid());

DROP POLICY IF EXISTS "users_insert_own_profile" ON public.profiles;
CREATE POLICY "users_insert_own_profile"
    ON public.profiles
    FOR INSERT
    TO authenticated
    WITH CHECK (id = auth.uid());
