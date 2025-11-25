import 'dart:async';

import 'package:admin/core/images.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/components/custom_seek_bar.dart';
import 'package:admin/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideo extends StatefulWidget {
  const FullScreenVideo({
    super.key,
    required this.isVlc,
    required this.device,
    required this.tag,
    required this.callUserId,
  });
  final String callUserId;
  final UserDeviceModel device;
  final bool isVlc;
  final String tag;

  static const routeName = 'streamingPage';

  static Future<void> push(
    final BuildContext context,
    String tag,
    UserDeviceModel device,
    bool isVlc,
    String callUserId,
  ) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (_) => FullScreenVideo(
        tag: tag,
        isVlc: isVlc,
        device: device,
        callUserId: callUserId,
      ),
    );
  }

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  bool _showControls = false;
  Timer? _hideControlsTimer;
  bool _isInteracting = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await SystemChrome.setPreferredOrientations([
      //   DeviceOrientation.landscapeLeft,
      //   DeviceOrientation.landscapeRight,
      // ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {});
        }
      });

      _startHideTimer(); // start hiding countdown
    });
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    // restore UI
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void backToPortrait() {
    _hideControlsTimer?.cancel();
    // restore UI
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Navigator.pop(context);
  }

  void _startHideTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        if (!_isInteracting) {
          setState(() => _showControls = false);
        }
      }
    });
  }

  void _onScreenTap() {
    setState(() {
      _showControls = true;
    });
    _startHideTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVlc) {
      return OrientationBuilder(
        builder: (context, orientation) {
          return RotatedBox(
            quarterTurns: 3,
            child: VoipBlocSelector.remoteRenderer(
              builder: (remoteRenderer) {
                if (remoteRenderer != null) {
                  return Hero(
                    tag: widget.tag,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: [
                          RTCVideoView(
                            remoteRenderer,
                            objectFit: RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitCover,
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Image.asset(
                              DefaultImages.STREAM_LOGO,
                              width: 60,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            child: SafeArea(
                              child: DecoratedBox(
                                decoration: const BoxDecoration(
                                  color: Colors.black26,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.fullscreen_exit,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      );
    }
    final bloc = VoipBloc.of(context);
    return RotatedBox(
      quarterTurns: 3,
      child: GestureDetector(
        onTap: _onScreenTap,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              _buildVideoView(bloc),
              Positioned(
                top: 05,
                right: 0,
                child: SafeArea(
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:
                        const Icon(Icons.fullscreen_exit, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoView(VoipBloc bloc) {
    if (widget.isVlc) {
      // VLC player fullscreen
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AspectRatio(
            aspectRatio: bloc.videoController!.value.aspectRatio,
            child: VideoPlayer(bloc.videoController!),
          ),
          // if (_showControls)
          AnimatedOpacity(
            opacity: _showControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: IgnorePointer(
              ignoring: !_showControls,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  child: VoipBlocSelector.recordingApi(
                    builder: (api) {
                      if (api.isApiInProgress ||
                          bloc.state.recordingApi.data == null) {
                        return const SizedBox.shrink();
                      }
                      return CustomSeekBar(
                        isFullScreen: true,
                        device: widget.device,
                        onInteractionStart: () {
                          _isInteracting = true;
                          setState(
                            () => _showControls = true,
                          ); // Ensure it's visible
                        },
                        onInteractionEnd: () {
                          if (_isInteracting) {
                            _isInteracting = false;
                            _startHideTimer();
                          } // Start hide timer only after interaction ends
                        },
                        totalVideoDuration:
                            bloc.state.recordingApi.data!.duration!.toDouble(),
                        originalVideoDuration: bloc
                            .videoController!.value.duration.inSeconds
                            .toDouble(),
                        alertChunks:
                            bloc.state.recordingApi.data!.aiAlert!.toList(),
                        callUserId: widget.callUserId,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ); // Already handles full screen
    } else {
      // WebRTC fullscreen
      return VoipBlocSelector.remoteRenderer(
        builder: (remoteRenderer) {
          if (remoteRenderer != null) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: RTCVideoView(
                remoteRenderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      );
    }
  }
}
