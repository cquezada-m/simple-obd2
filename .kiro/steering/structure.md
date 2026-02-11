---
inclusion: always
---

# Project Structure

```
lib/
├── main.dart                    # Entry point, MultiProvider setup, MaterialApp with localization
├── data/
│   └── dtc_database.dart        # Static DTC code lookup with locale-aware descriptions
├── l10n/
│   └── app_localizations.dart   # AppLanguage enum, AppLocalizations class, delegate
├── models/                      # Immutable data classes with const constructors
│   ├── ai_diagnostic.dart       # AiDiagnostic (summary, causes, urgency, cost)
│   ├── dtc_code.dart            # DtcCode + DtcSeverity enum
│   ├── recommendation.dart      # Recommendation + RecommendationPriority enum
│   └── vehicle_parameter.dart   # VehicleParameter with copyWith
├── providers/                   # ChangeNotifier classes exposed via Provider
│   ├── language_provider.dart   # Locale toggle (es/en)
│   └── obd2_provider.dart       # Central app state: connection, polling, DTCs, AI diagnostics
├── screens/                     # Full-page route widgets
│   ├── home_screen.dart         # Tab layout (Diagnóstico / En Vivo)
│   ├── privacy_policy_screen.dart
│   └── splash_screen.dart       # Permission handling flow
├── services/                    # I/O and external communication
│   ├── gemini_service.dart      # Google Gemini REST API client
│   ├── obd2_base_service.dart   # Abstract OBD2 interface + static ELM327 parsing helpers
│   ├── obd2_service.dart        # Bluetooth implementation (BluetoothConnection)
│   ├── secure_storage_service.dart # Encrypted key-value storage for API keys
│   └── wifi_obd2_service.dart   # WiFi/TCP socket implementation
├── theme/
│   └── app_theme.dart           # Color palette, ThemeData, GlassCard widget
└── widgets/                     # Reusable stateless UI components
    ├── connection_card.dart
    ├── device_picker_sheet.dart
    ├── diagnostic_codes_card.dart
    ├── live_parameters_card.dart
    ├── recommendations_card.dart
    └── vehicle_info_card.dart
test/
└── widget_test.dart
ui/                              # Design reference only, not part of the build
├── React Code/
├── Screenshots/
└── LogoApp.png
```

## Architecture Rules

- Single-provider pattern: `Obd2Provider` owns all OBD2/vehicle state; `LanguageProvider` owns locale. Both are `ChangeNotifier` subclasses registered via `MultiProvider` in `main.dart`.
- Service abstraction: `Obd2BaseService` is the abstract interface. `Obd2Service` (Bluetooth) and `WifiObd2Service` (WiFi/TCP) are the concrete implementations. Static helper methods for ELM327 response parsing live on the base class.
- Widgets in `lib/widgets/` are stateless. They receive data through constructor parameters or read state via `Consumer<Obd2Provider>`.
- Screens in `lib/screens/` are full-page views that compose widgets and may hold local UI state (e.g., tab index).
- Timer-based polling at a 2-second interval drives live parameter updates while connected.

## Model Conventions

- All model classes use `const` constructors and are immutable.
- Use `copyWith` when a model needs to produce modified copies (see `VehicleParameter`).
- Enums co-locate with their model (e.g., `DtcSeverity` in `dtc_code.dart`, `RecommendationPriority` in `recommendation.dart`).

## Localization Conventions

- Custom localization via `AppLocalizations` class with a `_t(es, en)` helper that returns the string matching the active `AppLanguage`.
- Spanish is the default locale.
- Access strings with `AppLocalizations.of(context)`.
- When adding new UI text, add a getter property to `AppLocalizations` using the `_t` pattern with both Spanish and English values.
- DTC descriptions support locale-aware lookup through `DtcDatabase`.

## UI / Theme Conventions

- Material Design 3 (`useMaterial3: true`) with a Google-inspired color palette defined as static constants on `AppTheme`.
- Glass-morphism style: use the `GlassCard` widget (backdrop blur + translucent container) for card surfaces.
- Typography uses `GoogleFonts.inter()`. Runtime font fetching is disabled (`allowRuntimeFetching = false`) because the device may be on the OBD2 adapter's WiFi with no internet.
- Use `AppTheme` color constants (e.g., `AppTheme.primary`, `AppTheme.textSecondary`) rather than inline color literals.

## Adding New Code

- New data classes go in `lib/models/` with `const` constructors.
- New state goes in an existing provider or a new `ChangeNotifier` in `lib/providers/`, registered in `MultiProvider`.
- New I/O or external API clients go in `lib/services/`.
- New reusable UI components go in `lib/widgets/` as stateless widgets.
- New full-page views go in `lib/screens/`.
- All user-facing strings must be added to `AppLocalizations` with both `es` and `en` translations.
