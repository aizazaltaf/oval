import 'dart:async';
import 'dart:math' as math;

import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:flutter/material.dart';

// Clean, minimalist audio visualizer matching the design
class VoiceControlAudioVisualizer extends StatefulWidget {
  const VoiceControlAudioVisualizer({
    super.key,
    this.isActive = false,
    this.isRecording = false,
    this.height = 80,
    this.fromCall = false,
    this.width = double.infinity,
  });
  final bool isActive;
  final bool isRecording;
  final double height;
  final double width;
  final bool fromCall;

  @override
  State<VoiceControlAudioVisualizer> createState() =>
      _VoiceControlAudioVisualizerState();
}

class _VoiceControlAudioVisualizerState
    extends State<VoiceControlAudioVisualizer> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  Timer? _audioLevelTimer;
  List<double> _audioLevels = [];
  final int _maxBars = 20; // Match the image with ~20 bars
  final double _minHeight = 4;
  final double _maxHeight = 60;

  double _currentAudioLevel = 0;
  double _targetAudioLevel = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeAudioLevels();
    _startAudioLevelSimulation();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isActive && widget.isRecording) {
      _startAnimations();
    }
  }

  void _initializeAudioLevels() {
    _audioLevels = List.generate(_maxBars, (index) => _minHeight);
  }

  void _startAudioLevelSimulation() {
    _audioLevelTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (widget.isActive && widget.isRecording) {
        _updateAudioLevels();
      }
    });
  }

  void _updateAudioLevels() {
    if (!mounted) {
      return;
    }

    // Simulate audio level changes
    _targetAudioLevel = math.Random().nextDouble() * 100;
    _currentAudioLevel = _currentAudioLevel * 0.7 + _targetAudioLevel * 0.3;

    // Update audio levels array (shift from right to left)
    setState(() {
      _audioLevels.removeAt(0);
      final double newLevel =
          _minHeight + (_currentAudioLevel / 100) * (_maxHeight - _minHeight);
      _audioLevels.add(newLevel);
    });
  }

  void _startAnimations() {
    _animationController.repeat();
  }

  void _stopAnimations() {
    _animationController.stop();
  }

  @override
  void didUpdateWidget(VoiceControlAudioVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && widget.isRecording) {
      if (!oldWidget.isRecording) {
        _startAnimations();
      }
    } else {
      if (oldWidget.isRecording) {
        _stopAnimations();
      }
    }
  }

  @override
  void dispose() {
    _audioLevelTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive || !widget.isRecording) {
      if (widget.fromCall) {
        return const SizedBox.shrink();
      }
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: Center(
          child: Text(
            'Tap to start recording',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: MinimalistAudioVisualizerPainter(
              audioLevels: _audioLevels,
              primaryColor: Theme.of(context).primaryColor,
              slideOffset: _slideAnimation.value,
              isActive: widget.isActive && widget.isRecording,
            ),
          );
        },
      ),
    );
  }
}

class MinimalistAudioVisualizerPainter extends CustomPainter {
  MinimalistAudioVisualizerPainter({
    required this.audioLevels,
    required this.primaryColor,
    required this.slideOffset,
    required this.isActive,
  });
  final List<double> audioLevels;
  final Color primaryColor;
  final double slideOffset;
  final bool isActive;

  @override
  void paint(Canvas canvas, Size size) {
    if (!isActive || audioLevels.isEmpty) {
      return;
    }

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = primaryColor;

    final barWidth = size.width / audioLevels.length;
    final centerY = size.height / 2;

    for (int i = 0; i < audioLevels.length; i++) {
      final barHeight = audioLevels[i];
      final x = i * barWidth + barWidth / 2;

      // Calculate slide effect (bars move from right to left)
      final slideX = x - (slideOffset * size.width * 0.1);

      if (slideX >= 0 && slideX < size.width) {
        final rect = Rect.fromCenter(
          center: Offset(slideX, centerY),
          width: barWidth * 0.6,
          height: barHeight,
        );

        // Draw rounded rectangle bar (capsule shape like in the image)
        final roundedRect = RRect.fromRectAndRadius(
          rect,
          Radius.circular(barWidth * 0.3),
        );

        canvas.drawRRect(roundedRect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FlowingWavePainter extends CustomPainter {
  FlowingWavePainter({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
  });
  final double animation;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = primaryColor.withValues(alpha: 0.1);

    final path = Path();
    final waveHeight = size.height * 0.3;
    final waveWidth = size.width;

    path.moveTo(0, size.height / 2);

    for (double x = 0; x <= waveWidth; x += 5) {
      final y = size.height / 2 +
          math.sin((x / waveWidth * 4 * math.pi) + (animation * 2 * math.pi)) *
              waveHeight;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Example of how to integrate with existing voice control screen
class VoiceControlAudioVisualizerIntegration extends StatelessWidget {
  const VoiceControlAudioVisualizerIntegration({
    super.key,
    required this.bloc,
    this.height = 80,
    this.width = double.infinity,
  });
  final VoiceControlBloc bloc;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return VoiceControlBlocSelector.isVoiceRecording(
      builder: (isVoiceRecording) {
        return VoiceControlBlocSelector.isListening(
          builder: (isListening) {
            return VoiceControlBlocSelector.isPermissionAvailable(
              builder: (isPermissionAvailable) {
                final isActive =
                    isPermissionAvailable && (isVoiceRecording || isListening);

                return VoiceControlAudioVisualizer(
                  isActive: isActive,
                  isRecording: isVoiceRecording,
                  height: height,
                  width: width,
                );
              },
            );
          },
        );
      },
    );
  }
}
