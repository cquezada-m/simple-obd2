# Tech Stack

## Framework
- Flutter (Dart SDK ^3.10.8)
- Material Design 3 (`useMaterial3: true`)

## Key Dependencies
- `provider` (^6.1.2) — state management
- `flutter_bluetooth_serial` (^0.4.0) — Bluetooth OBD2 communication (Android)
- `permission_handler` (^11.3.1) — runtime permissions
- `google_fonts` (^6.2.1) — Inter font family
- `cupertino_icons` (^1.0.8)

## Linting
- `flutter_lints` (^6.0.0) via `analysis_options.yaml`

## Target Platforms
- Android, iOS, Web, macOS, Linux, Windows (platform directories present)
- Primary targets: Android (Bluetooth) and iOS (WiFi)

## Common Commands
```bash
# Run the app
flutter run

# Run on a specific device
flutter run -d <device_id>

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Run tests
flutter test

# Analyze code
flutter analyze

# Get dependencies
flutter pub get
```
