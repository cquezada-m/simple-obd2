import 'package:flutter/material.dart';

/// Animates between numeric values with a smooth count-up/down effect.
class AnimatedValueText extends StatelessWidget {
  final String value;
  final TextStyle? style;

  const AnimatedValueText({super.key, required this.value, this.style});

  @override
  Widget build(BuildContext context) {
    final numValue = double.tryParse(value);
    if (numValue == null) {
      return Text(value, style: style);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: numValue),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, animated, _) {
        return Text(animated.toStringAsFixed(0), style: style);
      },
    );
  }
}
