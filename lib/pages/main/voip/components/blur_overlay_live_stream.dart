import 'dart:ui';

import 'package:flutter/material.dart';

class BlurOverlayLiveStream extends StatelessWidget {
  const BlurOverlayLiveStream({
    super.key,
    this.background,
    required this.overlay,
    this.needOverlay = false,
  });
  final Widget? background;
  final Widget overlay;
  final bool needOverlay;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background layer (with optional background widget)
        Positioned.fill(
          child: background ??
              Container(
                color: Theme.of(context).tabBarTheme.indicatorColor,
              ),
        ),

        // Blur layer applied over the background
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: Container(
              color: Colors.black
                  .withValues(alpha: 0), // Important: must not be fully opaque
            ),
          ),
        ),

        // Foreground overlay (on top of blur)
        Positioned.fill(
          child: overlay,
        ),
      ],
    );
  }
}
