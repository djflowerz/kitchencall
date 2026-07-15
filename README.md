# KitchenCall — Customer App (Flutter source)

Production-intent Dart/Flutter source for the KitchenCall Customer App,
covering the full booking journey: browse cooks → book → pay → track →
rate. Built against the screen list and navigation flows from the
KitchenCall spec (26 customer screens).

> **This code was written outside a Flutter environment and has not
> been compiled or run.** It follows correct Flutter/Dart syntax and
> current package APIs, but budget time for the normal first-run
> fixes (a missing import, a version mismatch) — see "First run" below.

## What's included

- **26 screens**, wired together with `go_router` (see `lib/core/router/app_router.dart`)
- **State management** via Riverpod (`lib/providers/`)
- **Repository pattern** (`lib/data/repositories/`) so mock data is a drop-in
  replacement for Firebase/Supabase later — screens never talk to `MockData` directly
- **Theme system** matching the KitchenCall brand (`lib/core/theme/`) — green `#1F7A3D`,
  orange `#F97316`, 16px radius, per the brand guide — with a **full dark mode**
  (System/Light/Dark, under Profile → Settings → Appearance)
- **Reusable widgets**: buttons, cook cards, category chips, status badges

## Screens covered

Splash · Onboarding (3) · Login · Sign Up · Forgot Password · Home ·
Explore · Search · Search Results · Cook Profile (About/Menu/Reviews/Gallery) ·
Select Service · Select Date & Time · Choose Menu · Ingredients ·
Booking Summary · Payment · Booking Confirmed · Live Tracking · Chat ·
My Bookings (Upcoming/Active/Completed/Cancelled) · Booking Details ·
Favorites · Notifications · Subscription Plans · Wallet · Profile ·
Rate & Review.

## First run

1. Install Flutter (3.19+) and Dart (3.3+): https://docs.flutter.dev/get-started/install
2. Create a fresh project shell (this gives you the `android/`, `ios/`, `web/`
   folders that aren't included here) and copy this `lib/` folder and
   `pubspec.yaml` in, overwriting the generated ones:
   ```
   flutter create kitchencall_customer
   cd kitchencall_customer
   # copy this repo's lib/, pubspec.yaml, assets/, analysis_options.yaml over
   flutter pub get
   flutter run
   ```
3. The app runs immediately on mock data — no backend required to click through
   every screen end to end.

## Connecting a real backend

Every screen depends only on the abstract repositories in
`lib/data/repositories/` (`CookRepository`, `BookingRepository`,
`AuthRepository`), not on `MockData` directly. To go live:

1. Run `flutterfire configure` to generate `firebase_options.dart`.
2. Uncomment the Firebase packages in `pubspec.yaml` and the
   `Firebase.initializeApp(...)` call in `lib/main.dart`.
3. Write `FirestoreCookRepository`, `FirestoreBookingRepository`, etc.
   implementing the same abstract classes.
4. Swap the `Provider<...Repository>` bindings in
   `lib/providers/*_provider.dart` to point at the new classes — no
   screen code changes.

## Known gaps / TODOs (search the codebase for `TODO`)

- **Payments**: `payment_screen.dart` simulates success. Wire in
  M-Pesa Daraja (STK Push) and/or a card processor before launch.
- **Maps**: `live_tracking_screen.dart` uses a placeholder in place of
  a live `GoogleMap` widget — add your Google Maps API key and stream
  the cook's location from your backend.
- **Chat**: `chat_screen.dart` uses local mock messages — connect to
  Firestore or Stream Chat for real-time delivery, and push
  notifications via FCM.
- **Auth**: session persistence (auto-login on relaunch) isn't wired
  up yet — `splash_screen.dart` always routes to onboarding.
- **Dark mode** is fully wired (toggle in Settings actually switches every
  themed screen, custom cards included) but the chosen mode isn't persisted
  across app restarts yet — see the `TODO` in `providers/theme_provider.dart`.
- Cook, Driver, and Admin apps are separate builds — ask for those
  next when you're ready.

## Architecture

```
lib/
├── core/           theme, router, constants, shared widgets
├── models/         plain Dart data classes
├── data/           mock data + repository interfaces/implementations
├── providers/      Riverpod state (auth, cooks, booking flow, bookings)
└── screens/        one folder per feature area
```
