import 'package:admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class AnimatedLinearProgressIndicator extends StatelessWidget {
  const AnimatedLinearProgressIndicator({
    super.key,
    required this.value,
  });

  final double value;

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(
      builder: (final _, final ct) => AnimatedContainer(
        color: Colors.white,
        duration: const Duration(milliseconds: 300),
        height: 2,
        width: ct.maxWidth * value,
      ),
    );
  }
}

class ButtonProgressIndicator extends StatelessWidget {
  const ButtonProgressIndicator({
    super.key,
    this.value,
    this.fgColor,
    this.bgColor,
    this.width,
    this.height,
    this.strokeWidth,
    this.showCircularLoader = true,
  });

  final Color? fgColor;
  final Color? bgColor;
  final double? value;
  final double? height;
  final double? width;
  final double? strokeWidth;
  final bool showCircularLoader;

  @override
  Widget build(final BuildContext context) {
    // final buttonStyle = ElevatedButtonTheme.of(context).style;
    // final valueColor = fgColor ??
    //     buttonStyle?.foregroundColor?.resolve({}) ??
    //     DefaultTextStyle.of(context).style.color!;
    // return SizedBox(
    //   width: width ?? 15,
    //   height: height ?? 15,
    //   child: CircularProgressIndicator(
    //     strokeWidth: strokeWidth ?? 2,
    //     value: value,
    //     backgroundColor: bgColor ??
    //         (value == null
    //             ? null
    //             : valueColor.withValues(alpha: 0.5 * valueColor.a)),
    //     valueColor: AlwaysStoppedAnimation(valueColor),
    //   ),
    // );
    Constants.showLoader(showCircularLoader: showCircularLoader);

    return const SizedBox.shrink();
  }
}

// class ElegantButtonLoader extends StatefulWidget {
//   const ElegantButtonLoader({
//     super.key,
//     this.value, // 0.0 → 1.0 or null for infinite (auto increment)
//     this.progressColor,
//     this.backgroundColor,
//     this.height,
//     this.iconSize,
//     this.showPercentage = true,
//   });
//
//   final double? value;
//   final Color? progressColor;
//   final Color? backgroundColor;
//   final double? height;
//   final double? iconSize;
//   final bool showPercentage;
//
//   @override
//   State<ElegantButtonLoader> createState() => _ElegantButtonLoaderState();
// }
//
// class _ElegantButtonLoaderState extends State<ElegantButtonLoader>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _animation;
//   Timer? _progressTimer;
//
//   final List<String> _icons = [
//     DefaultVectors.AIR_CONDITIONER,
//     DefaultVectors.IOT_BULB,
//     DefaultVectors.CAMERA,
//   ];
//
//   int _currentIcon = 0;
//   double _lastValue = 0;
//   double _fakeProgress = 0;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat();
//
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOutCubic,
//     );
//
//     // Icon cycling logic
//     _controller.addListener(() {
//       if (_lastValue > 0.95 && _controller.value < 0.05) {
//         setState(() {
//           _currentIcon = (_currentIcon + 1) % _icons.length;
//         });
//       }
//       _lastValue = _controller.value;
//     });
//
//     // Start fake percentage timer if indeterminate with percentage
//     if (widget.value == null && widget.showPercentage) {
//       _startFakeProgressTimer();
//     }
//   }
//
//   void _startFakeProgressTimer() {
//     _progressTimer?.cancel();
//
//     // 1-minute (60s) total simulated progress reaching ~99%
//     const totalDuration = Duration(minutes: 1);
//     const tick = Duration(milliseconds: 600); // ~100 updates/minute
//
//     final totalTicks = totalDuration.inMilliseconds / tick.inMilliseconds;
//     final increment = 99 / totalTicks;
//
//     _progressTimer = Timer.periodic(tick, (timer) {
//       if (_fakeProgress >= 99) {
//         _fakeProgress = 99;
//         timer.cancel();
//       } else {
//         setState(() {
//           _fakeProgress += increment;
//         });
//       }
//     });
//   }
//
//   @override
//   void didUpdateWidget(covariant ElegantButtonLoader oldWidget) {
//     super.didUpdateWidget(oldWidget);
//
//     // Restart timer if switched to auto progress
//     if (widget.value == null && oldWidget.value != null) {
//       _fakeProgress = 0;
//       _startFakeProgressTimer();
//       if (!_controller.isAnimating) {
//         _controller.repeat();
//       }
//     }
//
//     // Stop timer if switched to determinate mode
//     if (widget.value != null && oldWidget.value == null) {
//       _progressTimer?.cancel();
//       if (!_controller.isAnimating) {
//         _controller.repeat();
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _progressTimer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final progressColor =
//         widget.progressColor ?? Theme.of(context).colorScheme.primary;
//     final bgColor = widget.backgroundColor ??
//         Theme.of(context).colorScheme.surfaceContainerHighest;
//     final height = widget.height ?? 18.0;
//     final iconSize = widget.iconSize ?? 20.0;
//     const width = 120.0;
//
//     final actualProgress = widget.value != null
//         ? widget.value!.clamp(0.0, 1.0)
//         : _fakeProgress / 100;
//     final percentage = (actualProgress * 100).clamp(0, 99).toInt();
//
//     // Reserve space on right for percentage text so bar doesn't overlap it
//     const double reservedForText = 35; // width reserved for "%"
//
//     return SizedBox(
//       width: width,
//       height: height + 10,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Background bar
//           Container(
//             width: width,
//             height: height,
//             decoration: BoxDecoration(
//               color: bgColor.withValues(alpha: 0.4),
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//
//           // Animated blue progress bar
//           AnimatedBuilder(
//             animation: _animation,
//             builder: (context, _) {
//               const chunkWidth = 35.0;
//               final position =
//                   (width - reservedForText - chunkWidth) * _animation.value;
//
//               return ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Stack(
//                   children: [
//                     if (widget.value != null)
//                       // Determinate progress fill (limit bar width to avoid overlap)
//                       Container(
//                         width: (width - reservedForText) * actualProgress,
//                         height: height,
//                         color: progressColor.withValues(alpha: 0.8),
//                       )
//                     else
//                       // Moving chunk (infinite mode)
//                       Positioned(
//                         left: position,
//                         child: Container(
//                           width: chunkWidth,
//                           height: height,
//                           decoration: BoxDecoration(
//                             color: progressColor,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               );
//             },
//           ),
//
//           // Animated moving icon
//           AnimatedBuilder(
//             animation: _animation,
//             builder: (context, _) {
//               final movePos = widget.value != null
//                   ? ((width - reservedForText) * actualProgress) -
//                       (iconSize / 2)
//                   : (width - reservedForText - iconSize) * _animation.value;
//
//               return Positioned(
//                 left: movePos.clamp(0.0, width - reservedForText - iconSize),
//                 child: SvgPicture.asset(
//                   _icons[_currentIcon],
//                   height: iconSize,
//                   colorFilter: const ColorFilter.mode(
//                     Colors.white,
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           // Optional percentage text (only if enabled)
//           if (widget.showPercentage)
//             Positioned(
//               right: 6,
//               child: Container(
//                 alignment: Alignment.centerRight,
//                 width: reservedForText,
//                 color: Colors.transparent, // keep clean separation
//                 child: Text(
//                   "${percentage.toString().padLeft(2, '0')}%",
//                   style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

class PrimaryCircularLoading extends StatelessWidget {
  const PrimaryCircularLoading({
    super.key,
    this.value,
    this.fgColor,
    this.bgColor,
  });

  final Color? fgColor;
  final Color? bgColor;
  final double? value;

  @override
  Widget build(BuildContext context) {
    // final buttonStyle = ElevatedButtonTheme.of(context).style;
    // final valueColor = fgColor ??
    //     buttonStyle?.foregroundColor?.resolve({}) ??
    //     DefaultTextStyle.of(context).style.color!;
    return SizedBox(
      width: 100.w,
      height: 10.h,
      child: const Align(
        child: CircularProgressIndicator(
          color: Colors.grey,
          backgroundColor: Colors.transparent,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
