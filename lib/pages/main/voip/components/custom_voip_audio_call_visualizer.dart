import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:admin/core/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

class CustomVoipAudioCallVisualizer extends StatefulWidget {
  const CustomVoipAudioCallVisualizer({
    super.key,
    this.radius = 60,
    this.visitorImage,
    this.notificationImage,
    this.isActive = false,
  });

  final double radius;
  final String? visitorImage;
  final String? notificationImage;
  final bool isActive;

  @override
  State<CustomVoipAudioCallVisualizer> createState() =>
      _CustomVoipAudioCallVisualizerState();
}

class _CustomVoipAudioCallVisualizerState
    extends State<CustomVoipAudioCallVisualizer>
    with SingleTickerProviderStateMixin {
  final FlutterAudioCapture _audioCapture = FlutterAudioCapture();
  double _currentLevel = 0;
  bool _hasVoice = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    if (widget.isActive) {
      _startRecorder();
    }
  }

  Future<void> _startRecorder() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      return;
    }

    try {
      // ✅ Must initialize first
      await _audioCapture.init();

      // ✅ Then start capturing
      await _audioCapture.start(
        _processAudio,
        _onError,
        bufferSize: 3000,
      );

      debugPrint('Audio capture started successfully');
    } catch (e) {
      debugPrint('Audio start error: $e');
    }
  }

  Future<void> _stopRecorder() async {
    try {
      await _audioCapture.stop();
    } catch (e) {
      debugPrint('Audio stop error: $e');
    }
  }

  void _onError(Object e) {
    debugPrint('Audio capture error: $e');
  }

  void _processAudio(dynamic obj) {
    if (!mounted) {
      return;
    }

    // Convert dynamic array of float samples into Float32List
    final Float32List buffer = Float32List.fromList(List<double>.from(obj));

    // Compute RMS amplitude
    double sum = 0;
    for (final sample in buffer) {
      sum += sample * sample;
    }

    final double rms = math.sqrt(sum / buffer.length);
    final double normalized = rms.clamp(0.0, 1.0);
    final double boosted = math.pow(normalized, 0.5).toDouble();

    setState(() {
      _currentLevel = _currentLevel * 0.6 + boosted * 0.4;

      if (_currentLevel > 0.02) {
        _hasVoice = true;
        if (!_controller.isAnimating) {
          _controller.forward(from: 0).then((_) {
            if (mounted) {
              _controller.stop();
            }
          });
        }
      } else {
        _hasVoice = false;
      }
    });
  }

  @override
  void didUpdateWidget(CustomVoipAudioCallVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startRecorder();
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopRecorder();
    }
  }

  @override
  void dispose() {
    _stopRecorder();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const maxExpansion = 120.0;

    return SizedBox(
      width: (widget.radius + maxExpansion) * 2,
      height: (widget.radius + maxExpansion) * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ✅ Show pulse only while speaking
          if (_hasVoice)
            AnimatedBuilder(
              animation: _animation,
              builder: (_, __) {
                final expansion =
                    _currentLevel * maxExpansion * _animation.value;
                final radius = widget.radius + expansion;
                final opacity = (1 - _animation.value) * 0.4;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Container(
                    width: radius * 2,
                    height: radius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .primaryColor
                          .withValues(alpha: opacity),
                    ),
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: CircleAvatar(
              radius: widget.radius,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl:
                      widget.visitorImage ?? widget.notificationImage ?? "",
                  fit: BoxFit.cover,
                  width: widget.radius * 2,
                  height: widget.radius * 2,
                  // ✅ Show shimmer while loading
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: widget.radius * 2,
                      height: widget.radius * 2,
                      color: Colors.white,
                    ),
                  ),

                  // FallBack Scenario
                  errorWidget: (context, url, error) => CachedNetworkImage(
                    imageUrl: widget.notificationImage ?? "",
                    fit: BoxFit.cover,
                    width: widget.radius * 2,
                    height: widget.radius * 2,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: widget.radius * 2,
                        height: widget.radius * 2,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      DefaultImages.USER_IMG_PLACEHOLDER,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
