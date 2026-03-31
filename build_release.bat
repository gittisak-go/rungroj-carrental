@echo off
set SUPABASE_URL=https://hkkddlxhcttnejlblmsc.supabase.co
set SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhra2RkbHhoY3R0bmVqbGJsbXNjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzNTkxNjksImV4cCI6MjA4OTkzNTE2OX0.3kkLr5hOHquEjR2dqAX8jGpSKZ9j6ZSZLUaXWYJdm4o

flutter build apk --release ^
  --dart-define=SUPABASE_URL=%SUPABASE_URL% ^
  --dart-define=SUPABASE_ANON_KEY=%SUPABASE_ANON_KEY%

echo.
echo APK: build\app\outputs\flutter-apk\app-release.apk
