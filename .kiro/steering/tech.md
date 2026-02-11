---
inclusion: always
---

# Tech Stack

## Framework & SDK
- Flutter with Dart SDK `^3.10.8`
- Material Design 3 (`useMaterial3: true`)
- Minimum Android SDK: 23

## Dependencies

### Runtime
| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.2 | State management via `ChangeNotifier` |
| `flutter_bluetooth_serial` | ^0.4.0 | Bluetooth OBD2 communication (Android only) |
| `permission_handler` | ^11.3.1 | Runtime permission requests |
| `google_fonts` | ^6.2.1 | Inter font family (runtime fetching disabled) |
| `http` | ^1.2.2 | HTTP client for Gemini REST API |
| `flutter_secure_storage` | ^9.2.4 | Encrypted key-value storage for API keys |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |
| `flutter_localizations` | SDK | Localization support |

### Dev
| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_lints` | ^6.0.0 | Lint rules via `analysis_options.yaml` |
| `flutter_test` | SDK | Widget and unit testing |
| `flutter_launcher_icons` | ^0.14.3 | App icon generation |

## Linting
- Base rule set: `package:flutter_lints/flutter.yaml`
- Run `flutter analyze` before committing to catch issues early.
- Suppress individual lint violations inline with `// ignore: rule_name` rather than disabling rules project-wide.

## Target Platforms
- Primary: Android (Bluetooth OBD2), iOS (WiFi OBD2)
- Secondary: Web, macOS, Linux, Windows (demo/mock mode only, no real OBD2 connectivity)

## Dart Style Rules
- Use `const` constructors wherever possible, especially on model classes and widgets.
- Prefer `final` for local variables that are not reassigned.
- Use named parameters for widget constructors with more than two parameters.
- Follow standard Dart naming: `lowerCamelCase` for variables/functions, `UpperCamelCase` for classes/enums, `lowercase_with_underscores` for file names.

## Common Commands
```bash
flutter pub get          # Install/update dependencies
flutter analyze          # Static analysis
flutter test             # Run all tests
flutter run              # Run on default device
flutter run -d <id>      # Run on specific device
flutter build apk        # Build Android APK
flutter build ios        # Build iOS archive
```
