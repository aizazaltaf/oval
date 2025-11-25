import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class FullScreenRTCVideo extends StatefulWidget {
  const FullScreenRTCVideo({
    super.key,
    required this.renderer,
    required this.fromLiveStreaming,
    this.fit = RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
  });
  final RTCVideoRenderer renderer;
  final RTCVideoViewObjectFit fit;
  final bool fromLiveStreaming;

  @override
  State<FullScreenRTCVideo> createState() => _FullScreenRTCVideoState();
}

class _FullScreenRTCVideoState extends State<FullScreenRTCVideo> {
  bool _isFullScreen = false;

  Future<void> _toggleFullScreen() async {
    if (_isFullScreen) {
      Navigator.of(context).pop(); // exit fullscreen
    } else {
      await Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (_, __, ___) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: Stack(
                  children: [
                    Center(
                      child: RTCVideoView(
                        widget.renderer,
                        objectFit: widget.fit,
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 16,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }

    setState(() => _isFullScreen = !_isFullScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RTCVideoView(
          widget.renderer,
          objectFit: widget.fit,
        ),
        if (widget.fromLiveStreaming)
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: _toggleFullScreen,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(6),
                child: Icon(
                  _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
