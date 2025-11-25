import 'package:flutter/material.dart';

class MotionTabBarController extends TabController {
  MotionTabBarController({
    super.initialIndex,
    super.animationDuration,
    required super.length,
    required super.vsync,
  });

  // programmatic tab change
  @override
  set index(int index) {
    super.index = index;
    _changeIndex!(index);
  }

  // callback for tab change
  Function(int)? _changeIndex;

  set onTabChange(Function(int)? fx) {
    _changeIndex = fx;
  }
}
