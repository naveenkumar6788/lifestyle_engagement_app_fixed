
# Lifestyle & Engagement App — Ready (embedded Supabase)

This project is prepared to run on Flutter web with your Supabase project embedded.

Supabase project URL: https://hrrqvftglaeznovlkkxz.supabase.co

## Quickstart (web)
1. Open the folder in VS Code.
2. Run:
   ```bash
   flutter pub get
   flutter run -d chrome
   ```
3. The app will open in your browser and use the Supabase project configured in `lib/config.dart`.

## Notes
- Email verification requires SMTP to be configured in Supabase dashboard (Project -> Authentication -> SMTP). If you want email verification to work, add SMTP details there.
- After initial testing, rotate your anon key if desired.

