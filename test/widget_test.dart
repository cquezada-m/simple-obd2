import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:simple_obd2/l10n/app_localizations.dart';
import 'package:simple_obd2/providers/language_provider.dart';
import 'package:simple_obd2/providers/obd2_provider.dart';
import 'package:simple_obd2/screens/home_screen.dart';
import 'package:simple_obd2/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Widget _buildTestApp({Widget? home}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ChangeNotifierProvider(create: (_) => Obd2Provider()),
    ],
    child: Consumer<LanguageProvider>(
      builder: (context, langProvider, _) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          locale: Locale(langProvider.locale),
          supportedLocales: const [Locale('es'), Locale('en')],
          localizationsDelegates: [
            AppLocalizationsDelegate(langProvider.language),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: home ?? const HomeScreen(),
        );
      },
    ),
  );
}

void main() {
  testWidgets('HomeScreen renders connection card', (tester) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    // App title should be visible
    expect(find.text('OBD2 Scanner'), findsOneWidget);

    // Connect button should be visible when disconnected
    expect(find.text('Conectar'), findsOneWidget);

    // Disconnected state hint should be visible
    expect(find.text('Conecta tu dispositivo OBD2'), findsOneWidget);
  });

  testWidgets('HomeScreen shows privacy policy button', (tester) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    // Privacy policy icon button should exist
    expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
  });

  testWidgets('Language toggle switches to English', (tester) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    // Initially in Spanish
    expect(find.text('Conectar'), findsOneWidget);

    // Tap language toggle
    final langToggle = find.byIcon(Icons.language_rounded);
    expect(langToggle, findsOneWidget);
    await tester.tap(langToggle);
    await tester.pumpAndSettle();

    // Should now show English
    expect(find.text('Connect'), findsOneWidget);
  });
}
