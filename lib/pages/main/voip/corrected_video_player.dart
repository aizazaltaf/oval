import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Wrapper around VideoPlayerController that applies duration correction
class CorrectedVideoPlayerController {
  CorrectedVideoPlayerController.network(
    String url, {
    required this.realDuration,
  }) : _controller = VideoPlayerController.networkUrl(
          Uri.parse(url),
          formatHint: VideoFormat.hls,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        ) {
    _controller.initialize().then((_) {
      // Calculate ratio once initialized
      final reported = _controller.value.duration;
      if (reported.inSeconds > 0) {
        _ratio = realDuration.inSeconds / reported.inSeconds;
      } else {
        _ratio = 1.0;
      }
    });
  }
  final VideoPlayerController _controller;
  final Duration realDuration;
  late double _ratio;

  /// Expose the underlying controller
  VideoPlayerController get inner => _controller;

  /// Always return corrected duration
  Duration get duration => realDuration;

  /// Get corrected position
  Duration get position {
    final reported = _controller.value.position;
    return Duration(
      seconds: (reported.inSeconds * _ratio).round(),
    );
  }

  /// Corrected seek
  Future<void> seekTo(Duration target) {
    final mappedSeconds = (target.inSeconds / _ratio).round();
    return _controller.seekTo(Duration(seconds: mappedSeconds));
  }

  Future<void> play() => _controller.play();
  Future<void> pause() => _controller.pause();
  Future<void> dispose() => _controller.dispose();

  ValueNotifier<VideoPlayerValue> get notifier => _controller;
}
