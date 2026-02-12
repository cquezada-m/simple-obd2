import 'package:flutter/material.dart';

/// Shared slide-fade page route for consistent navigation transitions.
class SlideFadeRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideFadeRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(curved),
            child: FadeTransition(opacity: curved, child: child),
          );
        },
      );
}
