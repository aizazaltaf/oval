// import 'dart:async';
// import 'dart:io';
//
// import 'package:admin/constants.dart';
// import 'package:admin/models/data/user_data.dart';
// import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
// import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
// import 'package:admin/pages/main/voip/model/streaming_alerts_data.dart';
// import 'package:admin/pages/main/voip/signaling/signaling_client.dart';
// import 'package:admin/pages/main/voip/streaming_components/render_stream_toggle_button.dart';
// import 'package:admin/pages/main/voip/streaming_components/video_player_buttons.dart';
// import 'package:admin/widgets/custom_button.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// class CustomSeekBar extends StatefulWidget {
//   const CustomSeekBar({
//     super.key,
//     required this.totalVideoDuration,
//     required this.originalVideoDuration,
//     required this.alertChunks,
//     this.signalingClient,
//     this.onInteractionStart,
//     this.onInteractionEnd,
//     this.isFullScreen = false,
//     required this.callUserId,
//   });
//   final SignalingClient? signalingClient;
//   final String callUserId;
//   final bool isFullScreen;
//
//   final double totalVideoDuration;
//   final double originalVideoDuration;
//   final Function? onInteractionStart;
//   final Function? onInteractionEnd;
//   final List<AiAlert> alertChunks;
//
//   @override
//   State<CustomSeekBar> createState() => _CustomSeekBarState();
// }
//
// class _CustomSeekBarState extends State<CustomSeekBar> {
//   final ScrollController _scrollController = ScrollController();
//   late VoipBloc bloc;
//   final double pixelsPerSecond = 5;
//   bool _isUserScrolling = false;
//   bool shouldPlay = false;
//   Timer? _debounceScrollTimer;
//   bool _isSeekingManually = false;
//   bool firstTimePlay = false;
//
//   Timer? shouldPlayTimer;
//   Timer? shouldFirstPlayTimer;
//   Timer? gestureTimer;
//   bool _isProgrammaticScroll = false;
//   Timer? _scrollStopDebounce;
//   bool shouldJump = true;
//   bool isScrollCompleted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // Wait for context to be ready to scroll to center on 0 seconds
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollController
//         ..jumpTo(
//           _scrollController.position.maxScrollExtent,
//         ) // Start at beginning (0 aligned to center)
//         ..addListener(_handleUserScroll);
//     });
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     bloc = VoipBloc.of(context);
//     bloc.videoController?.addListener(() {
//       if (bloc.videoController != null) {
//         bloc.videoController?.addListener(_onVideoProgress);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     bloc.videoController?.removeListener(_onVideoProgress);
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _jumpToAlert(JumpAlertWidget alert) {
//     _scrollController.animateTo(
//       alert.position,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//
//     bloc
//       ..timerDate =
//       DateTime.parse(bloc.state.recordingApi.data!.fileStartTime).toLocal()
//       ..timerDate = bloc.timerDate.add(
//         Duration(
//           seconds: alert.time.toInt(),
//         ),
//       )
//       ..updateVideoTimer(bloc.timerDate);
//
//     bloc.videoController
//         ?.seekTo(Duration(seconds: alert.time.toInt()))
//         .then((_) {
//       Future.delayed(const Duration(seconds: 1), () {
//         _isSeekingManually = false;
//         bloc.videoController?.play();
//         bloc.updatePlaying();
//       });
//       Future.delayed(const Duration(seconds: 3), () {
//         // bloc.videoController?.play();
//         // bloc.updatePlaying();
//       });
//     });
//   }
//
//   void _onVideoProgress() {
//     if (_isSeekingManually) {
//       return;
//     }
//     if (bloc.videoController != null) {
//       final bool isPlaying = bloc.videoController!.value.isPlaying;
//       if (isPlaying) {
//         final bool isBuffering = bloc.videoController!.value.isBuffering;
//         bloc.updateIsBuffering(Platform.isAndroid ? false : isBuffering);
//         if (Platform.isAndroid) {
//           if (!_isUserScrolling && _scrollController.hasClients && isPlaying) {
//             scrollMethod();
//             widget.onInteractionEnd?.call();
//           }
//         } else {
//           if (!_isUserScrolling &&
//               _scrollController.hasClients &&
//               isPlaying &&
//               !isBuffering) {
//             scrollMethod();
//             widget.onInteractionEnd?.call();
//           }
//         }
//       }
//     }
//   }
//
//   void scrollMethod() {
//     final currentTime =
//         bloc.videoController!.value.position.inMilliseconds / 1000;
//     bloc
//       ..timerDate =
//       DateTime.parse(bloc.state.recordingApi.data!.fileStartTime).toLocal()
//       ..timerDate = bloc.timerDate.add(
//         Duration(
//           seconds: currentTime.toInt(),
//         ),
//       )
//       ..updateVideoTimer(bloc.timerDate);
//
//     if (_scrollController.hasClients) {
//       final screenWidth = MediaQuery.of(context).size.width / 1.32;
//       final maxScrollExtent = widget.originalVideoDuration * pixelsPerSecond;
//
//       final double scrollPosition = (currentTime * pixelsPerSecond).clamp(
//         0,
//         maxScrollExtent,
//       );
//
//       _scrollController.jumpTo(
//         scrollPosition.clamp(
//           0,
//           _scrollController.position.maxScrollExtent - (screenWidth / 2),
//         ),
//       );
//     }
//     _isProgrammaticScroll = true;
//   }
//
//   void _onScrollEnd({bool isPlay = false}) {
//     final bool isPlaying = bloc.videoController?.value.isPlaying ?? false;
//     if (bloc.videoController != null && !isPlaying) {
//       if (shouldPlay) {
//         final double centerOffset = _scrollController.offset +
//             (MediaQuery.of(context).size.width / 2) -
//             200;
//         final double seconds = (centerOffset / pixelsPerSecond)
//             .clamp(0, widget.originalVideoDuration);
//
//         // Seek video to new position and play
//         _isSeekingManually = true;
//         _debounceScrollTimer?.cancel();
//         bloc.updateIsScrollLoading(true);
//         _debounceScrollTimer =
//             Timer(const Duration(milliseconds: 200), () async {
//               if (bloc.videoController!.value.isInitialized) {
//                 await bloc.videoController!
//                     .seekTo(Duration(seconds: seconds.toInt()))
//                     .then((_) {
//                   logger.fine(
//                     "🛑 User stopped scrolling (RawGestureDetector) $shouldPlay 222 $isPlay $seconds",
//                   );
//                   if (isPlay) {
//                     Future.delayed(const Duration(seconds: 1), () {
//                       _isUserScrolling = false;
//                       _isSeekingManually = false;
//                       bloc.videoController!.play();
//
//                       bloc.updatePlaying();
//                     });
//                   }
//                 });
//               }
//             });
//       } else {
//         shouldPlayTimer?.cancel();
//         shouldPlayTimer = Timer(const Duration(seconds: 1), () {
//           shouldPlay = true;
//         });
//       }
//     }
//   }
//
//   void _handleUserScroll() {
//     if (_isProgrammaticScroll) {
//       return;
//     }
//
//     if (bloc.videoController != null &&
//         !bloc.videoController!.value.isPlaying) {
//       final double centerOffset = _scrollController.offset +
//           (MediaQuery.of(context).size.width / 2) -
//           200;
//       final double seconds = (centerOffset / pixelsPerSecond)
//           .clamp(0, widget.originalVideoDuration);
//
//       final duration = widget.originalVideoDuration -
//           (widget.originalVideoDuration - seconds.toInt());
//       logger.fine(
//         "Duration is ${widget.originalVideoDuration} $duration $seconds $centerOffset",
//       );
//       bloc
//         ..timerDate =
//         DateTime.parse(bloc.state.recordingApi.data!.fileStartTime)
//             .toLocal()
//         ..timerDate = bloc.timerDate.add(
//           Duration(
//             seconds: seconds.toInt(),
//           ),
//         )
//         ..updateVideoTimer(bloc.timerDate);
//     }
//     // Debounce scroll stop detection
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final height = size.height;
//     final screenWidth =
//         MediaQuery.of(context).size.width / 1.32; // 💡 Actual width
//     final timelineWidth = widget.originalVideoDuration * pixelsPerSecond;
//
//     final List<JumpAlertWidget> alertWidgets = [];
//     final List<AiAlert> aiAlertList = [];
//     final List<List<double>> lanes = [];
//     double? lastAlertTime; // Track the last added alert time
//
//     aiAlertList.clear();
//     for (final chunk in widget.alertChunks) {
//       if (chunk.id == null) {
//         continue;
//       }
//
//       final startTime = DateTime.parse(chunk.createdAt!)
//           .toLocal()
//           .difference(
//         DateTime.parse(bloc.state.recordingApi.data!.fileStartTime)
//             .toLocal(),
//       )
//           .inSeconds
//           .toDouble();
//
//       // Skip alerts that are within 15 seconds of the last one
//       if (lastAlertTime != null && (startTime - lastAlertTime) < 60.0) {
//         continue;
//       }
//       aiAlertList.add(chunk);
//
//       final double durationRatio =
//           widget.originalVideoDuration / widget.totalVideoDuration;
//       final scaledStartTime = startTime * durationRatio;
//
//       final startX = (scaledStartTime / widget.totalVideoDuration) *
//           (timelineWidth - screenWidth / 4);
//       final width = Constants.alertWidth;
//
//       // Find a free lane
//       int laneIndex = 0;
//       for (; laneIndex < lanes.length; laneIndex++) {
//         final lane = lanes[laneIndex];
//         if (!lane.any((usedX) => (startX - usedX).abs() < width)) {
//           lane.add(startX);
//           break;
//         }
//       }
//
//       if (laneIndex == lanes.length) {
//         lanes.add([startX]);
//       }
//       final double centerOffset =
//           startX + (MediaQuery.of(context).size.width / 2) - 200;
//       final double seconds = (centerOffset / pixelsPerSecond)
//           .clamp(0, widget.originalVideoDuration);
//       bloc
//         ..timerDate =
//         DateTime.parse(bloc.state.recordingApi.data!.fileStartTime)
//             .toLocal()
//         ..timerDate = bloc.timerDate.add(
//           Duration(
//             seconds: seconds.toInt(),
//           ),
//         )
//         ..updateVideoTimer(bloc.timerDate);
//
//       final duration = widget.originalVideoDuration -
//           (widget.originalVideoDuration - seconds.toInt());
//
//       alertWidgets.add(JumpAlertWidget(
//           widget: Positioned(
//             left: startX,
//             bottom: laneIndex * 55.0,
//             child: _alertTypeWidget(bloc, chunk, screenWidth),
//           ),
//           position: startX,
//           time: duration));
//       lastAlertTime = startTime; // Update the last alert time only when added
//     }
//
//     if (widget.isFullScreen) {
//       return Row(
//         children: [
//           SizedBox(
//             height: 70,
//             child: DecoratedBox(
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 border: Border.all(
//                   color: const Color(0xFF86dcff),
//                 ),
//               ),
//               child: VoipBlocSelector.isLiveModeActivated(
//                 builder: (isLiveModeActivated) {
//                   if (!isLiveModeActivated) {
//                     return Row(
//                       mainAxisSize: MainAxisSize.min,
//                       // mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CustomWidgetButton(
//                           width: 50,
//                           color: Colors.blue[50],
//                           isButtonEnabled: !isLiveModeActivated &&
//                               bloc.videoController != null,
//                           // shape: BoxShape.circle,
//                           onSubmit: () {
//                             if (!shouldJump) {
//                               Future.delayed(const Duration(milliseconds: 1500),
//                                       () {
//                                     shouldJump = true;
//                                   });
//                               return;
//                             }
//                             shouldJump = false;
//                             Future.delayed(const Duration(milliseconds: 1500),
//                                     () {
//                                   shouldJump = true;
//                                 });
//                             for (int i = alertWidgets.length - 1; i >= 0; i--) {
//                               final alert = alertWidgets[i];
//                               if (alert.position < _scrollController.offset) {
//                                 _jumpToAlert(alert);
//                                 break;
//                               }
//                             }
//                           },
//                           borderColor: Colors.blue[50],
//                           child: Icon(
//                             CupertinoIcons.backward_end_fill,
//                             color: Theme.of(context).indicatorColor,
//                           ),
//                         ),
//                         // SizedBox(width: width * 0.05),
//                         AnimatedSwitcher(
//                           duration: const Duration(milliseconds: 50),
//                           reverseDuration: const Duration(milliseconds: 50),
//                           child: VoipBlocSelector.isPlaying(
//                             builder: (isPlaying) {
//                               return CustomWidgetButton(
//                                 color: Colors.blue[50],
//                                 width: 70,
//                                 isButtonEnabled: !isLiveModeActivated &&
//                                     bloc.videoController != null,
//                                 shape: BoxShape.circle,
//                                 borderColor: Colors.blue[50],
//                                 onSubmit: () async {
//                                   bloc.recordedVideoToggle(isPlaying);
//                                   if (isPlaying) {
//                                     widget.onInteractionEnd?.call();
//                                   }
//                                 },
//                                 child: Center(
//                                   child: Icon(
//                                     isPlaying
//                                         ? CupertinoIcons.pause_fill
//                                         : CupertinoIcons.play_arrow_solid,
//                                     color: Theme.of(context).indicatorColor,
//                                     size: 26,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         // SizedBox(width: width * 0.05),
//                         CustomWidgetButton(
//                           width: 50,
//                           color: Colors.blue[50],
//                           borderColor: Colors.blue[50],
//                           isButtonEnabled: !isLiveModeActivated &&
//                               bloc.videoController != null,
//                           shape: BoxShape.circle,
//                           onSubmit: () {
//                             if (!shouldJump) {
//                               Future.delayed(const Duration(milliseconds: 1500),
//                                       () {
//                                     shouldJump = true;
//                                   });
//                               return;
//                             }
//                             shouldJump = false;
//                             Future.delayed(const Duration(milliseconds: 1500),
//                                     () {
//                                   shouldJump = true;
//                                 });
//                             for (int i = 0; i < alertWidgets.length; i++) {
//                               final alert = alertWidgets[i];
//                               if (alert.position > _scrollController.offset) {
//                                 _jumpToAlert(alert);
//                                 break;
//                               }
//                             }
//                           },
//                           child: Icon(
//                             CupertinoIcons.forward_end_fill,
//                             color: Theme.of(context).indicatorColor,
//                           ),
//                         ),
//                       ],
//                     );
//                   }
//                   return const SizedBox.shrink();
//                 },
//               ),
//             ),
//           ),
//           scrollerWidget(screenWidth, timelineWidth, alertWidgets),
//         ],
//       );
//     }
//     return Column(
//       children: [
//         SizedBox(
//           height: 70,
//           child: Row(
//             children: [
//               scrollerWidget(screenWidth, timelineWidth, alertWidgets),
//               SizedBox(
//                 width: 99,
//                 child: RenderStreamToggleButton(
//                   signalingClient: widget.signalingClient,
//                   callUserId: widget.callUserId,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: height * 0.03),
//         VoipBlocSelector.isLiveModeActivated(
//           builder: (isLiveModeActivated) {
//             if (!isLiveModeActivated) {
//               return VideoPlayerButtons(
//                 backPress: () {
//                   if (!shouldJump) {
//                     Future.delayed(const Duration(milliseconds: 500), () {
//                       shouldJump = true;
//                     });
//                     return;
//                   }
//                   bloc.videoController?.pause();
//                   _isSeekingManually = true;
//                   shouldJump = false;
//                   Future.delayed(const Duration(milliseconds: 500), () {
//                     shouldJump = true;
//                   });
//                   logger.fine(
//                       "_scrollController.offset ${_scrollController.offset}");
//                   for (int i = alertWidgets.length - 1; i >= 0; i--) {
//                     final alert = alertWidgets[i];
//                     if (alert.position < _scrollController.offset - 200) {
//                       _jumpToAlert(alert);
//                       break;
//                     }
//                   }
//                 },
//                 forwardPressPress: () {
//                   if (!shouldJump) {
//                     Future.delayed(const Duration(milliseconds: 500), () {
//                       shouldJump = true;
//                     });
//                     return;
//                   }
//                   bloc.videoController?.pause();
//                   _isSeekingManually = true;
//                   shouldJump = false;
//                   Future.delayed(const Duration(milliseconds: 500), () {
//                     shouldJump = true;
//                   });
//                   for (int i = 0; i < alertWidgets.length; i++) {
//                     final alert = alertWidgets[i];
//                     if (alert.position > _scrollController.offset) {
//                       _jumpToAlert(alert);
//                       break;
//                     }
//                   }
//                 },
//               );
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//       ],
//     );
//   }
//
//   SizedBox scrollerWidget(
//       double screenWidth,
//       double timelineWidth,
//       List<JumpAlertWidget> alertWidgets,
//       ) {
//     return SizedBox(
//       height: 70,
//       width: screenWidth,
//       child: VoipBlocSelector.isRecordedStreamLoading(
//         builder: (isRecordedStreamLoading) {
//           return Listener(
//             onPointerDown: (_) {
//               bloc.updatePlaying(isPlay: false);
//               widget.onInteractionStart?.call();
//               logger.fine("🖐 User touched screen");
//               _scrollStopDebounce?.cancel();
//               _scrollStopDebounce = null;
//               firstTimePlay = true;
//               _isUserScrolling = true;
//               _isProgrammaticScroll = false;
//               bloc.videoController?.pause();
//             },
//             onPointerUp: (_) {
//               logger.fine("👆 User lifted finger");
//             },
//             onPointerMove: (_) {
//               _isUserScrolling = true;
//               _isProgrammaticScroll = false;
//             },
//             child: DecoratedBox(
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 border: Border.all(
//                   color: const Color(0xFF86dcff),
//                 ),
//               ),
//               child: Opacity(
//                 opacity: isRecordedStreamLoading ? 0 : 1,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     NotificationListener<ScrollNotification>(
//                       onNotification: (notification) {
//                         if (notification is ScrollEndNotification) {
//                           if (!bloc.isPlaying && firstTimePlay) {
//                             logger.fine(
//                               "🛑 Scroll has ended (including momentum)",
//                             );
//
//                             _isUserScrolling = false;
//
//                             _scrollStopDebounce =
//                                 Timer(const Duration(milliseconds: 500), () {
//                                   shouldPlay = true;
//                                   _onScrollEnd(
//                                     isPlay: true,
//                                   ); // Seek & maybe play
//                                 });
//                           }
//                           // shouldPlay = true;
//                           // _onScrollEnd(isPlay: true); // Now this is truly when scrolling ends
//                         }
//
//                         return false;
//                       },
//                       child: ListView(
//                         controller: _scrollController,
//                         scrollDirection: Axis.horizontal,
//                         physics: const ClampingScrollPhysics(),
//                         children: [
//                           SizedBox(
//                             width: screenWidth / 2,
//                           ), // Padding before timeline
//                           Stack(
//                             children: [
//                               SizedBox(
//                                 width: timelineWidth - screenWidth,
//                                 height: 80,
//                                 child: CustomPaint(
//                                   painter: _TimelinePainter(
//                                     totalDuration: widget.originalVideoDuration,
//                                     alertChunks: widget.alertChunks,
//                                     bloc: bloc,
//                                     pixelsPerSecond: pixelsPerSecond,
//                                   ),
//                                 ),
//                               ),
//                               ...alertWidgets.map((e) => e.widget),
//                             ],
//                           ),
//                           SizedBox(
//                             width: screenWidth / 2,
//                           ), // Padding after timeline
//                         ],
//                       ),
//                     ),
//
//                     // Center black line (playhead)
//                     Positioned(
//                       left: screenWidth / 2,
//                       top: 0,
//                       bottom: 0,
//                       child: Container(
//                         width: 2,
//                         color: Colors.black,
//                       ),
//                     ),
//
//                     // LIVE label
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _alertTypeWidget(
//       VoipBloc bloc,
//       AiAlert alert,
//       double width,
//       ) {
//     final FeatureModel alertMeta = Constants.alertsMeta.firstWhere(
//           (element) =>
//           alert.title!.toLowerCase().contains(element.title.toLowerCase()),
//       orElse: () => Constants.noAlert,
//     );
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         color: alertMeta.color,
//         borderRadius: BorderRadius.circular(
//           30,
//         ),
//       ),
//       width: Constants.alertWidth,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(width: 5),
//           SvgPicture.asset(
//             alertMeta.image,
//             colorFilter: const ColorFilter.mode(
//               Colors.white,
//               BlendMode.srcIn,
//             ),
//           ),
//           const SizedBox(width: 2.5),
//           Text(
//             alert.title!.toUpperCase(),
//             style: TextStyle(
//               color: Colors.white,
//               fontSize:
//               Orientation.landscape == MediaQuery.of(context).orientation
//                   ? width * 0.020
//                   : width * 0.040,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _TimelinePainter extends CustomPainter {
//   _TimelinePainter({
//     required this.totalDuration,
//     required this.alertChunks,
//     required this.pixelsPerSecond,
//     required this.bloc,
//   });
//
//   final double totalDuration;
//   final VoipBloc bloc;
//   final List<AiAlert> alertChunks;
//   final double pixelsPerSecond;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final tickPaint = Paint()
//       ..color = Colors.grey[600]!
//       ..strokeWidth = 2;
//
//     // Draw ticks for exact duration
//     for (double i = 0; i <= totalDuration; i++) {
//       final x = (i / totalDuration) *
//           size.width; // Calculate x position based on percentage
//       final height = (i % 5 == 0) ? 24.0 : 16.0;
//       canvas.drawLine(
//         Offset(x, size.height - height),
//         Offset(x, size.height),
//         tickPaint,
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
//
// class JumpAlertWidget {
//   JumpAlertWidget({
//     required this.widget,
//     required this.position,
//     required this.time,
//   });
//   Widget widget;
//   double position;
//   double time;
// }
