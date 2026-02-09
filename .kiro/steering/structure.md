# Project Structure

```
lib/
├── main.dart              # App entry point, Provider setup, MaterialApp config
├── models/                # Immutable data classes
│   ├── dtc_code.dart      # DtcCode + DtcSeverity enum
│   ├── recommendation.dart # Recommendation + RecommendationPriority enum
│   └── vehicle_parameter.dart # VehicleParameter with copyWith
├── providers/             # State management (ChangeNotifier + Provider)
│   └── obd2_provider.dart # Central app state: connection, polling, DTCs, recommendations
├── screens/               # Full-page views
│   └── home_screen.dart   # Single-screen app with tab layout (Diagnóstico / En Vivo)
├── services/              # OBD2 communication layer
│   ├── obd2_base_service.dart  # Abstract interface + shared ELM327 parsing helpers
│   ├── obd2_service.dart       # Bluetooth implementation (BluetoothConnection)
│   └── wifi_obd2_service.dart  # WiFi/TCP socket implementation
├── theme/
│   └── app_theme.dart     # Color palette, ThemeData, GlassCard widget
└── widgets/               # Reusable UI components
    ├── connection_card.dart
    ├── device_picker_sheet.dart
    ├── diagnostic_codes_card.dart
    ├── live_parameters_card.dart
    ├── recommendations_card.dart
    └── vehicle_info_card.dart
test/
└── widget_test.dart       # Basic widget smoke test
ui/
├── React Code/            # Reference React implementation
└── Screenshots/           # UI reference screenshots
```

## Architecture Patterns
- Single-provider architecture: `Obd2Provider` holds all app state
- Service abstraction: `Obd2BaseService` defines the OBD2 interface, with Bluetooth and WiFi implementations
- Widgets are stateless and receive data via constructor params or `Consumer<Obd2Provider>`
- Glass-morphism UI style using `GlassCard` (backdrop blur + translucent containers)
- Models are immutable with `const` constructors; `VehicleParameter` has `copyWith`
- Timer-based polling (2s interval) for live parameter updates
