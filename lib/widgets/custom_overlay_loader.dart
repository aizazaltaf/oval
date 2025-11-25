import 'dart:async';

import 'package:admin/core/images.dart';
import 'package:admin/main.dart' as main_app;
import 'package:admin/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

mixin CustomOverlayLoader {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;
  static VoidCallback? _requestDismissHandler;
  static int _activeRequests = 0;

  /// Show the custom overlay loader
  static void show({
    Color? progressColor,
    Color? backgroundColor,
    double? progressBarHeight,
    double? iconSize,
    bool showPercentage = false,
    bool showCircularLoader = true,
  }) {
    // Duration? duration;
    // if (showPercentage) {
    //   duration = const Duration(minutes: 5);
    // } else {
    //   duration = const Duration(minutes: 1);
    // }
    // Increment reference count for concurrent callers
    _activeRequests = (_activeRequests + 1).clamp(0, 1 << 30);
    if (_isShowing) {
      // Already visible; just schedule auto-dismiss for this caller
      // Future.delayed(duration, dismiss);
      // return;
      // dismiss();
      // reset();
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => _CustomOverlayWidget(
        progressColor: progressColor,
        backgroundColor: backgroundColor,
        progressBarHeight: progressBarHeight,
        iconSize: iconSize,
        showPercentage: showPercentage,
        showCircularLoader: showCircularLoader,
      ),
    );

    try {
      final context = main_app.navigatorKeyMain.currentContext;
      if (context != null) {
        Overlay.of(context).insert(_overlayEntry!);
        _isShowing = true;
      }
    } catch (e) {
      // Handle case where overlay system is not available (e.g., in tests)
      _isShowing = false;
      _overlayEntry = null;
      _activeRequests = 0;
      return;
    }

    // Auto dismiss after duration if specified
    // Future.delayed(duration, dismiss);
  }

  /// Dismiss the custom overlay loader
  static void dismiss() {
    if (_overlayEntry == null || !_isShowing) {
      _activeRequests = 0;
      return;
    }

    // Decrement and keep showing if there are still active requests
    if (_activeRequests > 0) {
      _activeRequests -= 1;
    }
    if (_activeRequests > 0) {
      _removeOverlayEntry();
      return;
    }

    // If the widget has registered a special dismiss handler (e.g., to show 100%), let it handle it
    if (_requestDismissHandler != null) {
      _requestDismissHandler!.call();
      return;
    }

    _removeOverlayEntry();
  }

  /// Check if loader is currently showing
  static bool get isShowing => _isShowing;

  /// Reset the overlay state (useful for tests)
  static void reset() {
    if (_overlayEntry != null) {
      try {
        _overlayEntry!.remove();
      } catch (e) {
        // Ignore errors when removing
      }
    }
    _overlayEntry = null;
    _isShowing = false;
    _requestDismissHandler = null;
    _activeRequests = 0;
  }

  static void _removeOverlayEntry() {
    try {
      _overlayEntry?.remove();
    } catch (e) {
      // Ignore errors when removing
    }
    _overlayEntry = null;
    _isShowing = false;
    _requestDismissHandler = null;
    _activeRequests = 0;
  }
}

class _CustomOverlayWidget extends StatefulWidget {
  const _CustomOverlayWidget({
    this.progressColor,
    this.backgroundColor,
    this.progressBarHeight,
    this.iconSize,
    this.showPercentage = false,
    this.showCircularLoader = true,
  });

  final Color? progressColor;
  final Color? backgroundColor;
  final double? progressBarHeight;
  final double? iconSize;
  final bool showPercentage;
  final bool showCircularLoader;

  @override
  State<_CustomOverlayWidget> createState() => _CustomOverlayWidgetState();
}

class _CustomOverlayWidgetState extends State<_CustomOverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _progressController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _progressAnimation;

  int _currentIconIndex = 0;
  double _lastProgressValue = 0;

  double _fakeProgress = 0;
  Timer? _progressTimer;
  bool _handlingDismiss = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeController.forward();

    // Cycle icons with progress
    _progressController
      ..addListener(() {
        final currentValue = _progressController.value;
        if (_lastProgressValue > 0.9 && currentValue < 0.1) {
          setState(() {
            _currentIconIndex = (_currentIconIndex + 1) % 3;
          });
        }
        _lastProgressValue = currentValue;
      })
      ..repeat();

    // Start fake progress if enabled
    if (widget.showPercentage) {
      _startFakeProgressTimer();
    }

    // Register a handler so dismiss() can ask us to complete to 100% first
    CustomOverlayLoader._requestDismissHandler = _onRequestDismiss;
  }

  void _startFakeProgressTimer() {
    _progressTimer?.cancel();

    // 1-minute total, reaching 99%
    const totalDuration = Duration(minutes: 1);
    const tick = Duration(milliseconds: 600); // 100 ticks per min
    final totalTicks = totalDuration.inMilliseconds / tick.inMilliseconds;
    final increment = 99 / totalTicks;

    _progressTimer = Timer.periodic(tick, (timer) {
      if (_fakeProgress >= 99) {
        _fakeProgress = 99;
        timer.cancel();
      } else {
        setState(() => _fakeProgress += increment);
      }
    });
  }

  @override
  void dispose() {
    if (CustomOverlayLoader._requestDismissHandler == _onRequestDismiss) {
      CustomOverlayLoader._requestDismissHandler = null;
    }
    _fadeController.dispose();
    _progressController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  void _cancelFakeProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  Future<void> _onRequestDismiss() async {
    if (_handlingDismiss) {
      return;
    }
    _handlingDismiss = true;

    // Ensure we show 100% if percentage is enabled
    if (widget.showPercentage) {
      _cancelFakeProgressTimer();
      if (mounted) {
        setState(() => _fakeProgress = 100);
      } else {
        _fakeProgress = 100;
      }
      await Future.delayed(const Duration(milliseconds: 150));
    }

    // Remove the overlay entry
    CustomOverlayLoader._removeOverlayEntry();
  }

  @override
  Widget build(BuildContext context) {
    final progressColor =
        widget.progressColor ?? Theme.of(context).primaryColor;
    final progressBarHeight = widget.progressBarHeight ?? 8.0;
    final iconSize = widget.iconSize ?? 24.0;
    const progressBarWidth = 200.0;

    final icons = [
      DefaultVectors.AIR_CONDITIONER,
      DefaultVectors.IOT_BULB,
      DefaultVectors.CAMERA,
    ];

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated cycling icon
                    if (!widget.showCircularLoader) ...[
                      SizedBox(
                        width: progressBarWidth,
                        height: iconSize + 10,
                        child: Stack(
                          children: [
                            AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                final progressValue = _progressAnimation.value;
                                final currentIcon = icons[_currentIconIndex];
                                final iconOpacity =
                                    progressValue > 0.8 ? 0.6 : 1.0;

                                const blueProgressWidth = 50.0;
                                final blueProgressPosition =
                                    (progressBarWidth - blueProgressWidth) *
                                        progressValue;
                                final blueProgressCenter =
                                    blueProgressPosition +
                                        (blueProgressWidth / 2);

                                return Positioned(
                                  left: blueProgressCenter - (iconSize / 2),
                                  child: Opacity(
                                    opacity: iconOpacity.clamp(0.0, 1.0),
                                    child: SvgPicture.asset(
                                      currentIcon,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Progress bar
                      Container(
                        width: progressBarWidth,
                        height: progressBarHeight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            final progressValue = _progressAnimation.value;
                            const blueProgressWidth = 50.0;
                            final blueProgressPosition =
                                (progressBarWidth - blueProgressWidth) *
                                    progressValue;

                            return Stack(
                              children: [
                                Positioned(
                                  left: blueProgressPosition,
                                  child: Container(
                                    height: progressBarHeight,
                                    width: blueProgressWidth,
                                    decoration: BoxDecoration(
                                      color: progressColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      // Optional auto-incrementing percentage text
                      if (widget.showPercentage) ...[
                        const SizedBox(height: 8),
                        Text(
                          "${_fakeProgress.toInt()}%",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ] else
                      const PrimaryCircularLoading(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
