import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/history_provider.dart';
import 'providers/language_provider.dart';
import 'providers/obd2_provider.dart';
import 'providers/subscription_provider.dart';
import 'screens/splash_screen.dart';
import 'services/local_storage_service.dart';
import 'theme/app_theme.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Hive local storage before anything else.
      await LocalStorageService.init();

      // Prevent Google Fonts from fetching over network.
      // The app may run on the OBD2 adapter's WiFi with no internet.
      // Fonts fall back to the platform default when not bundled.
      GoogleFonts.config.allowRuntimeFetching = false;

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      );

      // Catch Flutter framework errors
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        if (kDebugMode) {
          debugPrint('FlutterError: ${details.exceptionAsString()}');
        }
      };

      runApp(const OBD2App());
    },
    (error, stackTrace) {
      // Catch async errors not handled by Flutter
      if (kDebugMode) {
        debugPrint('Unhandled error: $error');
        debugPrint('Stack trace: $stackTrace');
      }
    },
  );
}

class OBD2App extends StatelessWidget {
  const OBD2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = SubscriptionProvider();
            provider.init();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = HistoryProvider();
            provider.loadAll();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = Obd2Provider();
            // Carga el API key de Gemini desde almacenamiento seguro al iniciar.
            provider.loadGeminiApiKey();
            return provider;
          },
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, langProvider, _) {
          return MaterialApp(
            title: 'OBD2 Scanner',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: Locale(langProvider.locale),
            supportedLocales: const [Locale('es'), Locale('en')],
            localizationsDelegates: [
              AppLocalizationsDelegate(langProvider.language),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
