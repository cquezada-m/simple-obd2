import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<double>(
      begin: 30,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F0FE), Color(0xFFF8F9FE), Color(0xFFF3E8FD)],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeIn.value,
                child: Transform.translate(
                  offset: Offset(0, _slideUp.value),
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo container with glass effect
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: AppTheme.glassBlur,
                      sigmaY: AppTheme.glassBlur,
                    ),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: AppTheme.glassOpacity,
                        ),
                        borderRadius: BorderRadius.circular(28),
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
                      child: const Icon(
                        Icons.directions_car_rounded,
                        size: 44,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // App title
                Builder(
                  builder: (context) {
                    final l = AppLocalizations.of(context);
                    return Column(
                      children: [
                        Text(
                          l.appTitle,
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l.appSubtitle,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 48),
                // Minimal loader
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppTheme.primary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
