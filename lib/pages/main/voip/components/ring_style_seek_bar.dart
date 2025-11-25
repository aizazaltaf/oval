import 'dart:async';
import 'dart:io';

import 'package:admin/constants.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/model/streaming_alerts_data.dart';
import 'package:admin/pages/main/voip/streaming_components/render_stream_toggle_button.dart';
import 'package:admin/pages/main/voip/streaming_components/video_player_buttons.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RingStyleSeekBar extends StatefulWidget {
  const RingStyleSeekBar({
    super.key,
    required this.totalVideoDuration,
    required this.originalVideoDuration,
    required this.alertChunks,
    required this.device,
    this.onInteractionStart,
    this.alertId,
    this.onInteractionEnd,
    this.isFullScreen = false,
    required this.callUserId,
  });
  final String callUserId;
  final bool isFullScreen;

  final double totalVideoDuration;
  final int? alertId;
  final double originalVideoDuration;
  final Function? onInteractionStart;
  final Function? onInteractionEnd;
  final UserDeviceModel device;
  final List<AiAlert> alertChunks;

  @override
  State<RingStyleSeekBar> createState() => _CustomSeekBarState();
}

class _CustomSeekBarState extends State<RingStyleSeekBar> {
  final ScrollController _scrollController = ScrollController();
  late VoipBloc bloc;
  // double pixelsPerSecond = 5;
  bool _isUserScrolling = false;
  bool shouldPlay = false;
  Timer? _debounceScrollTimer;
  bool _isSeekingManually = false;
  bool firstTimePlay = false;

  Timer? shouldPlayTimer;
  Timer? shouldFirstPlayTimer;
  Timer? gestureTimer;
  bool _isProgrammaticScroll = false;
  Timer? _scrollStopDebounce;
  bool shouldJump = true;
  bool isScrollCompleted = false;

  @override
  void initState() {
    super.initState();
    // Wait for context to be ready to scroll to center on 0 seconds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController
        ..jumpTo(
          _scrollController.position.maxScrollExtent,
        ) // Start at beginning (0 aligned to center)
        ..addListener(_handleUserScroll);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = VoipBloc.of(context);
    bloc.videoController?.addListener(() {
      if (bloc.videoController != null) {
        bloc.videoController?.addListener(_onVideoProgress);
      }
    });
  }

  @override
  void dispose() {
    bloc.videoController?.removeListener(_onVideoProgress);
    _scrollController.dispose();
    super.dispose();
  }

  void _jumpToAlert(JumpAlertWidget alert) {
    _scrollController.animateTo(
      alert.position,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    // Use accurate time synchronization for alert jumping
    final alertTime =
        DateTime.parse(alert.createdAt ?? DateTime.now().toIso8601String())
            .toLocal();
    final videoPosition = bloc.getVideoPositionForRealTimestamp(alertTime);

    if (videoPosition != null) {
      // Use the accurate video position from M3U8 time mapping
      logger.fine(
        "alertPosition ${alert.position} - videoPosition $videoPosition",
      );
      double ratio = 1;
      final reported = bloc.videoController!.value.duration;
      if (reported.inSeconds > 0) {
        ratio = reported.inSeconds / widget.originalVideoDuration;
      } else {
        ratio = 1.0;
      }
      bloc.videoController
          ?.seekTo(Duration(seconds: (videoPosition * ratio).toInt()))
          .then((_) {
        Future.delayed(const Duration(seconds: 1), () {
          _isSeekingManually = false;
          bloc.videoController?.play();
          bloc.updatePlaying();
        });
      });

      // Update timer with accurate time
      bloc.updateVideoTimer(alertTime);
    } else {
      // Fallback to original calculation
      bloc
        ..timerDate =
            DateTime.parse(bloc.state.recordingApi.data!.fileStartTime)
                .toLocal()
        ..timerDate = bloc.timerDate.add(
          Duration(
            seconds: alert.time.toInt(),
          ),
        )
        ..updateVideoTimer(bloc.timerDate);

      bloc.videoController
          ?.seekTo(Duration(seconds: alert.time.toInt()))
          .then((_) {
        Future.delayed(const Duration(seconds: 1), () {
          _isSeekingManually = false;
          bloc.videoController?.play();
          bloc.updatePlaying();
        });
      });
    }
  }

  void _onVideoProgress() {
    if (_isSeekingManually) {
      return;
    }

    // logger.fine(
    //     "pixels per second ${bloc.m3u8TimeMapping!.totalDuration / bloc.m3u8TimeMapping!.segments.length}");
    if (bloc.videoController != null) {
      final bool isPlaying = bloc.videoController!.value.isPlaying;
      if (isPlaying) {
        final bool isBuffering = bloc.videoController!.value.isBuffering;
        bloc.updateIsBuffering(Platform.isAndroid ? false : isBuffering);
        if (Platform.isAndroid) {
          if (!_isUserScrolling && _scrollController.hasClients && isPlaying) {
            scrollMethod();
            widget.onInteractionEnd?.call();
          }
        } else {
          if (!_isUserScrolling &&
              _scrollController.hasClients &&
              isPlaying &&
              !isBuffering) {
            scrollMethod();
            widget.onInteractionEnd?.call();
          }
        }
      }
    }
  }

  void scrollMethod() {
    final currentTime =
        bloc.videoController!.value.position.inSeconds.toDouble() *
            (widget.originalVideoDuration /
                bloc.videoController!.value.duration.inSeconds);

    // Use accurate time synchronization if M3U8 time mapping is available
    final realTimestamp = bloc.getRealTimestampForVideoPosition(currentTime);

    if (realTimestamp != null) {
      bloc.updateVideoTimer(realTimestamp);
    } else {
      // Fallback to original calculation
      bloc
        ..timerDate =
            DateTime.parse(bloc.state.recordingApi.data!.fileStartTime)
                .toLocal()
        ..timerDate = bloc.timerDate.add(
          Duration(
            seconds: currentTime.toInt(),
          ),
        )
        ..updateVideoTimer(bloc.timerDate);
    }

    if (_scrollController.hasClients) {
      // final screenWidth = MediaQuery.of(context).size.width / 1.32;
      final maxScrollExtent = widget.originalVideoDuration *
          (bloc.m3u8TimeMapping!.totalDuration /
              bloc.m3u8TimeMapping!.segments.length);

      final double scrollPosition = (currentTime *
              (bloc.m3u8TimeMapping!.totalDuration /
                  bloc.m3u8TimeMapping!.segments.length))
          .clamp(
        0,
        maxScrollExtent,
      );

      _scrollController.jumpTo(
        scrollPosition.clamp(
          0,
          _scrollController.position.maxScrollExtent /*- (screenWidth / 2)*/,
        ),
      );
    }
    _isProgrammaticScroll = true;
  }

  void _onScrollEnd({bool isPlay = false}) {
    final bool isPlaying = bloc.videoController?.value.isPlaying ?? false;
    if (bloc.videoController != null && !isPlaying) {
      if (shouldPlay) {
        final double centerOffset = _scrollController.offset +
            (MediaQuery.of(context).size.width / 2) -
            200;
        final pix = bloc.m3u8TimeMapping!.totalDuration /
            bloc.m3u8TimeMapping!.segments.length;
        final double seconds =
            (centerOffset / pix).clamp(0, widget.originalVideoDuration);

        // Use accurate time synchronization for seeking
        final realTimestamp = bloc.getRealTimestampForScrollPosition(seconds);

        if (realTimestamp != null) {
          // Use accurate seeking with M3U8 time mapping
          _isSeekingManually = true;
          _debounceScrollTimer?.cancel();
          bloc.updateIsScrollLoading(true);
          _debounceScrollTimer =
              Timer(const Duration(milliseconds: 200), () async {
            if (bloc.videoController!.value.isInitialized) {
              double ratio = 1;
              final reported = bloc.videoController!.value.duration;
              if (reported.inSeconds > 0) {
                ratio = reported.inSeconds / widget.originalVideoDuration;
              } else {
                ratio = 1.0;
              }
              (seconds * ratio).toInt();
              await bloc.videoController!
                  .seekTo(Duration(seconds: seconds.toInt()))
                  .then((_) {
                logger.fine(
                  "🛑 User stopped scrolling with accurate time mapping: $seconds seconds -> $realTimestamp ${realTimestamp.segment}",
                );
                bloc.updateVideoTimer(realTimestamp.dateTime);
                if (isPlay) {
                  Future.delayed(const Duration(seconds: 1), () {
                    _isUserScrolling = false;
                    _isSeekingManually = false;
                    bloc.videoController!.play();
                    bloc.updatePlaying();
                  });
                }
              });
            }
          });
        } else {
          // Fallback to original seeking logic
          _isSeekingManually = true;
          _debounceScrollTimer?.cancel();
          bloc.updateIsScrollLoading(true);
          _debounceScrollTimer =
              Timer(const Duration(milliseconds: 200), () async {
            if (bloc.videoController!.value.isInitialized) {
              await bloc.videoController!
                  .seekTo(Duration(seconds: seconds.toInt()))
                  .then((_) {
                logger.fine(
                  "🛑 User stopped scrolling (RawGestureDetector) $shouldPlay 222 $isPlay $seconds",
                );
                if (isPlay) {
                  Future.delayed(const Duration(seconds: 1), () {
                    _isUserScrolling = false;
                    _isSeekingManually = false;
                    bloc.videoController!.play();
                    bloc.updatePlaying();
                  });
                }
              });
            }
          });
        }
      } else {
        shouldPlayTimer?.cancel();
        shouldPlayTimer = Timer(const Duration(seconds: 1), () {
          shouldPlay = true;
        });
      }
    }
  }

  void _handleUserScroll() {
    if (_isProgrammaticScroll) {
      return;
    }

    if (bloc.videoController != null &&
        !bloc.videoController!.value.isPlaying) {
      final double centerOffset = _scrollController.offset +
          (MediaQuery.of(context).size.width / 2) -
          200;
      final double seconds = (centerOffset /
              (bloc.m3u8TimeMapping!.totalDuration /
                  bloc.m3u8TimeMapping!.segments.length))
          .clamp(0, widget.originalVideoDuration);

      logger.fine(
        "Duration is ${widget.originalVideoDuration} $seconds $centerOffset",
      );

      // Use accurate time synchronization for timer updates
      final realTimestamp = bloc.getRealTimestampForVideoPosition(seconds);
      if (realTimestamp != null) {
        bloc.updateVideoTimer(realTimestamp);
      } else {
        // Fallback to original calculation
        bloc
          ..timerDate =
              DateTime.parse(bloc.state.recordingApi.data!.fileStartTime)
                  .toLocal()
          ..timerDate = bloc.timerDate.add(
            Duration(
              seconds: seconds.toInt(),
            ),
          )
          ..updateVideoTimer(bloc.timerDate);
      }
    }
    // Debounce scroll stop detection
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final screenWidth =
        MediaQuery.of(context).size.width / 1.32; // 💡 Actual width

    final timelineWidth = widget.originalVideoDuration *
        (bloc.m3u8TimeMapping!.totalDuration /
            bloc.m3u8TimeMapping!.segments.length);
    logger.fine(bloc.m3u8TimeMapping);
    final List<JumpAlertWidget> alertWidgets = [];
    final List<AiAlert> aiAlertList = [];
    double? lastAlertTime; // Track the last added alert time

    aiAlertList.clear();
    for (final chunk in widget.alertChunks) {
      if (chunk.id == null) {
        continue;
      }

      // Use accurate time synchronization for alert positioning
      final alertTime = DateTime.parse(chunk.createdAt!).toLocal();
      final videoPosition = bloc.getVideoPositionForRealTimestamp(alertTime);

      double startTime;
      if (videoPosition != null) {
        // Use accurate video position from M3U8 time mapping
        startTime = videoPosition;
        logger
            .fine("Using accurate time mapping for alert: $startTime seconds");
      } else {
        // Fallback to original calculation
        startTime = alertTime
            .difference(
              DateTime.parse(bloc.state.recordingApi.data!.fileStartTime)
                  .toLocal(),
            )
            .inSeconds
            .toDouble();
        logger.fine("Using fallback calculation for alert: $startTime seconds");
      }

      logger.fine("startTime - lastAlertTime $startTime  $lastAlertTime");
      // Skip alerts that are within 15 seconds of the last one

      aiAlertList.add(chunk);

      final startX = (startTime / widget.originalVideoDuration) *
          (timelineWidth - screenWidth / 4);

      // Find a free lane

      final double centerOffset =
          startX + (MediaQuery.of(context).size.width / 2) - 200;
      final double seconds = (centerOffset /
              (bloc.m3u8TimeMapping!.totalDuration /
                  bloc.m3u8TimeMapping!.segments.length))
          .clamp(0, widget.originalVideoDuration);

      // Update timer with accurate time
      final realTimestamp = bloc.getRealTimestampForVideoPosition(seconds);
      if (realTimestamp != null) {
        bloc.updateVideoTimer(realTimestamp);
      } else {
        // Fallback to original calculation
        bloc
          ..timerDate =
              DateTime.parse(bloc.state.recordingApi.data!.fileStartTime)
                  .toLocal()
          ..timerDate = bloc.timerDate.add(
            Duration(
              seconds: seconds.toInt(),
            ),
          )
          ..updateVideoTimer(bloc.timerDate);
      }

      final duration = widget.originalVideoDuration -
          (widget.originalVideoDuration - seconds.toInt());

      // if (lastAlertTime != null && (duration - lastAlertTime) < 60.0) {
      //   continue;
      // }
      logger.fine("startTime is $startTime");
      final newCreatedAt = chunk.createdAt;

      final bool isDuplicate = alertWidgets.any((existing) {
        final existingCreatedAt = existing.createdAt;
        final difference = DateTime.parse(newCreatedAt!)
            .difference(DateTime.parse(existingCreatedAt!))
            .inSeconds
            .abs();
        return difference < 30;
      });

      if (!isDuplicate) {
        alertWidgets.add(
          JumpAlertWidget(
            id: chunk.id ?? 0,
            widget: Positioned(
              left: startX,
              bottom: 20,
              child: _alertTypeWidget(bloc, chunk, screenWidth),
            ),
            position: startX,
            time: duration,
            createdAt: newCreatedAt,
          ),
        );
      }
      lastAlertTime = duration; // Update the last alert time only when added
    }

    if (widget.isFullScreen) {
      return Row(
        children: [
          SizedBox(
            height: 70,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border.all(
                  color: const Color(0xFF86dcff),
                ),
              ),
              child: VoipBlocSelector.isLiveModeActivated(
                builder: (isLiveModeActivated) {
                  if (!isLiveModeActivated) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomWidgetButton(
                          width: 50,
                          color: Colors.blue[50],
                          isButtonEnabled: !isLiveModeActivated &&
                              bloc.videoController != null,
                          // shape: BoxShape.circle,
                          onSubmit: () {
                            if (!shouldJump) {
                              Future.delayed(const Duration(milliseconds: 1500),
                                  () {
                                shouldJump = true;
                              });
                              return;
                            }
                            shouldJump = false;
                            Future.delayed(const Duration(milliseconds: 1500),
                                () {
                              shouldJump = true;
                            });
                            for (int i = alertWidgets.length - 1; i >= 0; i--) {
                              final alert = alertWidgets[i];
                              if (alert.position < _scrollController.offset) {
                                _jumpToAlert(alert);
                                break;
                              }
                            }
                          },
                          borderColor: Colors.blue[50],
                          child: Icon(
                            CupertinoIcons.backward_end_fill,
                            color: Theme.of(context).tabBarTheme.indicatorColor,
                          ),
                        ),
                        // SizedBox(width: width * 0.05),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 50),
                          reverseDuration: const Duration(milliseconds: 50),
                          child: VoipBlocSelector.isPlaying(
                            builder: (isPlaying) {
                              return CustomWidgetButton(
                                color: Colors.blue[50],
                                width: 70,
                                isButtonEnabled: !isLiveModeActivated &&
                                    bloc.videoController != null,
                                shape: BoxShape.circle,
                                borderColor: Colors.blue[50],
                                onSubmit: () async {
                                  bloc.recordedVideoToggle(isPlaying);
                                  if (isPlaying) {
                                    widget.onInteractionEnd?.call();
                                  }
                                },
                                child: Center(
                                  child: Icon(
                                    isPlaying
                                        ? CupertinoIcons.pause_fill
                                        : CupertinoIcons.play_arrow_solid,
                                    color: Theme.of(context)
                                        .tabBarTheme
                                        .indicatorColor,
                                    size: 26,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // SizedBox(width: width * 0.05),
                        CustomWidgetButton(
                          width: 50,
                          color: Colors.blue[50],
                          borderColor: Colors.blue[50],
                          isButtonEnabled: !isLiveModeActivated &&
                              bloc.videoController != null,
                          shape: BoxShape.circle,
                          onSubmit: () {
                            if (!shouldJump) {
                              Future.delayed(const Duration(milliseconds: 1500),
                                  () {
                                shouldJump = true;
                              });
                              return;
                            }
                            shouldJump = false;
                            Future.delayed(const Duration(milliseconds: 1500),
                                () {
                              shouldJump = true;
                            });
                            for (int i = 0; i < alertWidgets.length; i++) {
                              final alert = alertWidgets[i];
                              if (alert.position > _scrollController.offset) {
                                _jumpToAlert(alert);
                                break;
                              }
                            }
                          },
                          child: Icon(
                            CupertinoIcons.forward_end_fill,
                            color: Theme.of(context).tabBarTheme.indicatorColor,
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          scrollerWidget(screenWidth, timelineWidth, alertWidgets),
        ],
      );
    }

    if (widget.alertId != null) {
      final JumpAlertWidget? alertJump =
          alertWidgets.firstWhereOrNull((e) => e.id == widget.alertId);
      Future.delayed(const Duration(milliseconds: 200), () {
        if (alertJump != null) {
          _jumpToAlert(alertJump);
        }
      });
    }
    return Column(
      children: [
        SizedBox(
          height: 70,
          child: Row(
            children: [
              scrollerWidget(screenWidth, timelineWidth, alertWidgets),
              SizedBox(
                width: 99,
                child: RenderStreamToggleButton(
                  callUserId: widget.callUserId,
                  device: widget.device,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.03),
        VoipBlocSelector.isLiveModeActivated(
          builder: (isLiveModeActivated) {
            if (!isLiveModeActivated) {
              return VideoPlayerButtons(
                backPress: () {
                  if (!shouldJump) {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      shouldJump = true;
                    });
                    return;
                  }

                  for (int i = alertWidgets.length - 1; i >= 0; i--) {
                    final alert = alertWidgets[i];
                    if (alert.position < _scrollController.offset - 200) {
                      bloc.videoController?.pause();
                      _isSeekingManually = true;
                      shouldJump = false;
                      Future.delayed(const Duration(milliseconds: 500), () {
                        shouldJump = true;
                      });
                      _jumpToAlert(alert);
                      break;
                    }
                  }
                },
                forwardPressPress: () {
                  if (!shouldJump) {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      shouldJump = true;
                    });
                    return;
                  }

                  for (int i = 0; i < alertWidgets.length; i++) {
                    final alert = alertWidgets[i];
                    if (alert.position > _scrollController.offset) {
                      bloc.videoController?.pause();
                      _isSeekingManually = true;
                      shouldJump = false;
                      Future.delayed(const Duration(milliseconds: 500), () {
                        shouldJump = true;
                      });
                      _jumpToAlert(alert);
                      break;
                    }
                  }
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  SizedBox scrollerWidget(
    double screenWidth,
    double timelineWidth,
    List<JumpAlertWidget> alertWidgets,
  ) {
    return SizedBox(
      height: 70,
      width: screenWidth,
      child: VoipBlocSelector.isRecordedStreamLoading(
        builder: (isRecordedStreamLoading) {
          return Listener(
            onPointerDown: (_) {
              bloc.updatePlaying(isPlay: false);
              widget.onInteractionStart?.call();
              logger.fine("🖐 User touched screen");
              _scrollStopDebounce?.cancel();
              _scrollStopDebounce = null;
              firstTimePlay = true;
              _isUserScrolling = true;
              _isProgrammaticScroll = false;
              bloc.videoController?.pause();
            },
            onPointerUp: (_) {
              logger.fine("👆 User lifted finger");
            },
            onPointerMove: (_) {
              _isUserScrolling = true;
              _isProgrammaticScroll = false;
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border.all(
                  color: const Color(0xFF86dcff),
                ),
              ),
              child: Opacity(
                opacity: isRecordedStreamLoading ? 0 : 1,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification) {
                          if (!bloc.isPlaying && firstTimePlay) {
                            logger.fine(
                              "🛑 Scroll has ended (including momentum)",
                            );

                            _isUserScrolling = false;

                            _scrollStopDebounce =
                                Timer(const Duration(milliseconds: 500), () {
                              shouldPlay = true;
                              _onScrollEnd(
                                isPlay: true,
                              ); // Seek & maybe play
                            });
                          }
                          // shouldPlay = true;
                          // _onScrollEnd(isPlay: true); // Now this is truly when scrolling ends
                        }

                        return false;
                      },
                      child: ListView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        children: [
                          SizedBox(
                            width: screenWidth / 2,
                          ), // Padding before timeline
                          Stack(
                            children: [
                              SizedBox(
                                width: timelineWidth,
                                height: 80,
                                child: CustomPaint(
                                  painter: _TimelinePainter(
                                    totalDuration: widget.originalVideoDuration,
                                    bloc: bloc,
                                    timelineWidth: timelineWidth,
                                    pixelsPerSecond: bloc
                                            .m3u8TimeMapping!.totalDuration /
                                        bloc.m3u8TimeMapping!.segments.length,
                                  ),
                                ),
                              ),
                              ...alertWidgets.map((e) => e.widget),
                            ],
                          ),
                          SizedBox(
                            width: screenWidth / 2,
                          ), // Padding after timeline
                        ],
                      ),
                    ),

                    /// Center black line (playhead)
                    Positioned(
                      left: screenWidth / 2,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),

                    // LIVE label
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _alertTypeWidget(
    VoipBloc bloc,
    AiAlert alert,
    double width,
  ) {
    final FeatureModel alertMeta = Constants.alertsMeta.firstWhere(
      (element) =>
          alert.title!.toLowerCase().contains(element.title.toLowerCase()),
      orElse: () => Constants.noAlert,
    );
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: alertMeta.color,
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      // width: Constants.alertWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 5),
            SvgPicture.asset(
              alertMeta.image,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 2.5),
            Text(
              alert.title!.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize:
                    Orientation.landscape == MediaQuery.of(context).orientation
                        ? width * 0.015
                        : width * 0.035,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  _TimelinePainter({
    required this.totalDuration,
    required this.pixelsPerSecond,
    required this.bloc,
    required this.timelineWidth,
  });

  final double totalDuration;
  final double timelineWidth;
  final VoipBloc bloc;
  final double pixelsPerSecond;

  @override
  void paint(Canvas canvas, Size size) {
    final tickPaint = Paint()
      ..color = Colors.grey[600]!
      ..strokeWidth = 2;

    // Draw ticks for exact duration
    for (double i = 0; i < totalDuration; i++) {
      final x = ((i / totalDuration) * timelineWidth).ceilToDouble();
      final height = (i.toInt().isEven) ? 24.0 : 12.0;

      // Calculate Y positions to center the tick
      final centerY = size.height / 2;
      final startY = centerY - height / 2 + 2;
      final endY = centerY + height / 2 - 2;

      canvas.drawLine(
        Offset(x, startY),
        Offset(x, endY),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class JumpAlertWidget {
  JumpAlertWidget({
    required this.widget,
    required this.id,
    required this.position,
    required this.time,
    this.createdAt,
  });
  Widget widget;
  double position;
  int id;
  double time;
  String? createdAt;
}
