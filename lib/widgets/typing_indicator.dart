import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Animated three-dot typing indicator for the AI chat.
class TypingIndicator extends StatefulWidget {
  final String label;
  const TypingIndicator({super.key, required this.label});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final delay = i * 0.25;
                    final t = (_controller.value - delay) % 1.0;
                    final scale = 0.6 + 0.4 * sin(t * pi);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: scale),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
