import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Google-inspired palette
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryLight = Color(0xFFE8F0FE);
  static const Color background = Color(0xFFF8F9FE);
  static const Color surface = Color(0xFFF1F3F9);
  static const Color border = Color(0xFFE0E4EC);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color textPrimary = Color(0xFF202124);
  static const Color textSecondary = Color(0xFF5F6368);
  static const Color textTertiary = Color(0xFF9AA0A6);
  static const Color success = Color(0xFF34A853);
  static const Color successLight = Color(0xFFE6F4EA);
  static const Color warning = Color(0xFFF9AB00);
  static const Color warningLight = Color(0xFFFEF7E0);
  static const Color error = Color(0xFFEA4335);
  static const Color errorLight = Color(0xFFFCE8E6);
  static const Color purple = Color(0xFFA142F4);
  static const Color purpleLight = Color(0xFFF3E8FD);
  static const Color cyan = Color(0xFF24C1E0);
  static const Color cyanLight = Color(0xFFE4F7FB);
  static const Color yellow = Color(0xFFF9AB00);
  static const Color yellowLight = Color(0xFFFEF7E0);

  // Glass constants
  static const double glassBlur = 20.0;
  static const double glassOpacity = 0.65;
  static const double glassBorderOpacity = 0.18;

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        surface: background,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: glassOpacity),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.white.withValues(alpha: glassBorderOpacity),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: border.withValues(alpha: 0.6)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// A reusable glass-morphism container widget.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 20.0;
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppTheme.glassBlur,
            sigmaY: AppTheme.glassBlur,
          ),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: AppTheme.glassOpacity),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: AppTheme.glassBorderOpacity,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
