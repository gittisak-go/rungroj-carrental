@echo off
if "%SUPABASE_URL%"=="" (
  echo ERROR: SUPABASE_URL is not set. Run: set SUPABASE_URL=...
  exit /b 1
)
if "%SUPABASE_ANON_KEY%"=="" (
  echo ERROR: SUPABASE_ANON_KEY is not set. Run: set SUPABASE_ANON_KEY=...
  exit /b 1
)

flutter run ^
  --dart-define=SUPABASE_URL=%SUPABASE_URL% ^
  --dart-define=SUPABASE_ANON_KEY=%SUPABASE_ANON_KEY%
