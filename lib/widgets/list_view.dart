import 'package:flutter/material.dart';

class NoGlowListViewWrapper extends StatelessWidget {
  const NoGlowListViewWrapper({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (final overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: child,
    );
  }
}
