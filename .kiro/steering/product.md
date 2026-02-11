---
inclusion: always
---

# Product: OBD2 Scanner

A Flutter mobile app for vehicle diagnostics via OBD2 (ELM327) adapters. Connects over Bluetooth (Android) or WiFi (iOS/universal) to read live engine parameters, retrieve and clear diagnostic trouble codes (DTCs), and provide maintenance recommendations.

## Core Features

- Bluetooth and WiFi connectivity to ELM327 OBD2 adapters
- Live vehicle parameter monitoring (RPM, speed, coolant temp, engine load, intake pressure, fuel level) with 2-second polling
- DTC reading, display with severity classification (critical/warning/info), and clearing
- AI-powered diagnostics via Google Gemini API (optional, user-initiated)
- Maintenance recommendations based on active DTCs and sensor readings
- Mock/demo mode for development and testing without a physical adapter
- VIN decoding for manufacturer, model year, and region identification
- Splash screen with permission handling flow

## Localization

- The app supports Spanish (es) and English (en), with Spanish as the default locale.
- All user-facing strings live in `lib/l10n/app_localizations.dart` using a custom `AppLocalizations` class with a `_t(es, en)` helper pattern.
- Locale is managed by `LanguageProvider` and toggled at runtime.
- When adding new UI text, add both Spanish and English translations as getter properties in `AppLocalizations` and use `AppLocalizations.of(context)` to access them in widgets.
- DTC descriptions also support locale-aware lookup via `DtcDatabase`.

## Privacy and Data Handling

- All diagnostic data is session-only and kept in memory. Nothing is persisted or sent to external servers (except optional AI diagnostics).
- The Gemini API key is stored via `SecureStorageService`.
- Google Fonts runtime fetching is disabled (`allowRuntimeFetching = false`) because the device may be on the OBD2 adapter's WiFi with no internet.

## AI Diagnostics (Gemini Integration)

- Uses Google Gemini 2.0 Flash via REST API (`GeminiService`).
- Sends vehicle parameters, DTCs, VIN, protocol, and ECU count to generate a structured Spanish-language diagnosis.
- Response is parsed into `AiDiagnostic` (summary, possible causes, check points, urgency, estimated cost).
- This feature is optional and only triggered by explicit user action.

## Platform Considerations

- Android: Bluetooth OBD2 communication via `flutter_bluetooth_serial`. Requires Bluetooth and Location permissions.
- iOS: WiFi/TCP socket communication. Requires local network permission.
- Web/Desktop: Demo mode only (no Bluetooth/WiFi OBD2 support).
