// import 'dart:async';
// import 'dart:io';
//
// import 'package:admin/models/data/user_device_model.dart';
// import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
// import 'package:admin/pages/main/voip/model/streaming_alerts_data.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class TimeSkipAwareScroller extends StatefulWidget {
//   const TimeSkipAwareScroller({
//     super.key,
//     required this.totalVideoDuration,
//     required this.originalVideoDuration,
//     required this.alertChunks,
//     required this.device,
//     this.onInteractionStart,
//     this.alertId,
//     this.onInteractionEnd,
//     this.isFullScreen = false,
//     required this.callUserId,
//   });
//
//   final String callUserId;
//   final bool isFullScreen;
//   final double totalVideoDuration; // Total time span (e.g., 5 hours)
//   final int? alertId;
//   final double originalVideoDuration; // Actual video duration (e.g., 2 hours)
//   final Function? onInteractionStart;
//   final Function? onInteractionEnd;
//   final UserDeviceModel device;
//   final List<AiAlert> alertChunks;
//
//   @override
//   State<TimeSkipAwareScroller> createState() => _TimeSkipAwareScrollerState();
// }
//
// class _TimeSkipAwareScrollerState extends State<TimeSkipAwareScroller> {
//   final ScrollController _scrollController = ScrollController();
//   late VoipBloc bloc;
//   double pixelsPerSecond = 5;
//   bool _isUserScrolling = false;
//   bool shouldPlay = false;
//   Timer? _debounceScrollTimer;
//   bool _isSeekingManually = false;
//   bool firstTimePlay = false;
//   Timer? shouldPlayTimer;
//   Timer? shouldFirstPlayTimer;
//   Timer? gestureTimer;
//   bool _isProgrammaticScroll = false;
//   Timer? _scrollStopDebounce;
//   bool shouldJump = true;
//   bool isScrollCompleted = false;
//
//   // Time skip specific variables
//   bool _isInTimeSkip = false;
//   Timer? _timeSkipScrollTimer;
//   double _timeSkipScrollSpeed = 3.0; // Speed multiplier for time skip scrolling
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollController
//         ..jumpTo(_scrollController.position.maxScrollExtent)
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
//     _timeSkipScrollTimer?.cancel();
//     super.dispose();
//   }
//
//   /// Check if current position is in a time skip
//   bool _isPositionInTimeSkip(double videoPosition) {
//     if (bloc.m3u8TimeMapping == null) return false;
//
//     // Check if there's a discontinuity at this position
//     return bloc.m3u8TimeMapping!.hasDiscontinuityAt(videoPosition);
//   }
//
//   /// Get the next video content position after a time skip
//   double? _getNextVideoContentPosition(double currentPosition) {
//     if (bloc.m3u8TimeMapping == null) return null;
//
//     for (final segment in bloc.m3u8TimeMapping!.segments) {
//       if (segment.videoPosition > currentPosition &&
//           !segment.hasDiscontinuity) {
//         return segment.videoPosition;
//       }
//     }
//     return null;
//   }
//
//   /// Get the previous video content position before a time skip
//   double? _getPreviousVideoContentPosition(double currentPosition) {
//     if (bloc.m3u8TimeMapping == null) return null;
//
//     for (int i = bloc.m3u8TimeMapping!.segments.length - 1; i >= 0; i--) {
//       final segment = bloc.m3u8TimeMapping!.segments[i];
//       if (segment.videoPosition < currentPosition &&
//           !segment.hasDiscontinuity) {
//         return segment.videoPosition;
//       }
//     }
//     return null;
//   }
//
//   /// Handle fast scrolling during time skips
//   void _handleTimeSkipScrolling(double startPosition, double endPosition) {
//     _isInTimeSkip = true;
//
//     // Pause video during time skip scrolling
//     bloc.videoController?.pause();
//     bloc.updatePlaying();
//
//     // Calculate scroll distance and duration
//     final scrollDistance = (endPosition - startPosition) * pixelsPerSecond;
//     final scrollDuration =
//         Duration(milliseconds: (scrollDistance / _timeSkipScrollSpeed).round());
//
//     // Animate scroll through time skip
//     _scrollController
//         .animateTo(
//       _scrollController.offset + scrollDistance,
//       duration: scrollDuration,
//       curve: Curves.easeInOut,
//     )
//         .then((_) {
//       _isInTimeSkip = false;
//
//       // Resume video after time skip
//       bloc.videoController?.play();
//       bloc.updatePlaying();
//     });
//   }
//
//   void _jumpToAlert(JumpAlertWidget alert) {
//     _scrollController.animateTo(
//       alert.position,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//
//     final alertTime =
//         DateTime.parse(alert.createdAt ?? DateTime.now().toIso8601String())
//             .toLocal();
//     final videoPosition = bloc.getVideoPositionForRealTimestamp(alertTime);
//
//     if (videoPosition != null) {
//       // Check if jumping to a time skip area
//       if (_isPositionInTimeSkip(videoPosition)) {
//         // Find the next video content position
//         final nextContentPosition = _getNextVideoContentPosition(videoPosition);
//         if (nextContentPosition != null) {
//           bloc.videoController
//               ?.seekTo(Duration(seconds: nextContentPosition.toInt()));
//         }
//       } else {
//         bloc.videoController?.seekTo(Duration(seconds: videoPosition.toInt()));
//       }
//
//       bloc.videoController
//           ?.seekTo(Duration(seconds: videoPosition.toInt()))
//           .then((_) {
//         Future.delayed(const Duration(seconds: 1), () {
//           _isSeekingManually = false;
//           bloc.videoController?.play();
//           bloc.updatePlaying();
//         });
//       });
//
//       bloc.updateVideoTimer(alertTime);
//     } else {
//       // Fallback to original calculation
//       bloc
//         ..timerDate =
//             DateTime.parse(bloc.state.recordingApi.data!.fileStartTime)
//                 .toLocal()
//         ..timerDate = bloc.timerDate.add(Duration(seconds: alert.time.toInt()))
//         ..updateVideoTimer(bloc.timerDate);
//
//       bloc.videoController
//           ?.seekTo(Duration(seconds: alert.time.toInt()))
//           .then((_) {
//         Future.delayed(const Duration(seconds: 1), () {
//           _isSeekingManually = false;
//           bloc.videoController?.play();
//           bloc.updatePlaying();
//         });
//       });
//     }
//   }
//
//   void _onVideoProgress() {
//     if (_isSeekingManually || _isInTimeSkip) return;
//
//     if (bloc.videoController != null) {
//       final bool isPlaying = bloc.videoController!.value.isPlaying;
//       if (isPlaying) {
//         final bool isBuffering = bloc.videoController!.value.isBuffering;
//         bloc.updateIsBuffering(Platform.isAndroid ? false : isBuffering);
//
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
//
//     // Use accurate time synchronization if M3U8 time mapping is available
//     final realTimestamp = bloc.getRealTimestampForVideoPosition(currentTime);
//     if (realTimestamp != null) {
//       bloc.updateVideoTimer(realTimestamp);
//     } else {
//       // Fallback to original calculation
//       bloc
//         ..timerDate =
//             DateTime.parse(bloc.state.recordingApi.data!.fileStartTime)
//                 .toLocal()
//         ..timerDate = bloc.timerDate.add(
//           Duration(
//             seconds: currentTime.toInt(),
//           ),
//         )
//         ..updateVideoTimer(bloc.timerDate);
//     }
//
//     if (_scrollController.hasClients) {
//       // Calculate the scroll position based on the total timeline (including skips)
//       final maxScrollExtent = widget.totalVideoDuration * pixelsPerSecond;
//
//       // Map the current video position to the correct place on the full timeline
//       double timelinePosition = _mapVideoPositionToTimeline(currentTime);
//
//       _scrollController.jumpTo(
//         timelinePosition.clamp(
//           0,
//           _scrollController.position.maxScrollExtent,
//         ),
//       );
//     }
//     _isProgrammaticScroll = true;
//   }
//
//   // Map the video position (seconds in video) to the timeline position (seconds in full span)
//   double _mapVideoPositionToTimeline(double videoPosition) {
//     if (bloc.m3u8TimeMapping == null) {
//       // Fallback: assume no skips
//       return videoPosition * pixelsPerSecond;
//     }
//     // Find the segment for this video position
//     for (final segment in bloc.m3u8TimeMapping!.segments) {
//       if (videoPosition >= segment.videoPosition &&
//           videoPosition < segment.videoPosition + segment.duration) {
//         // Timeline position is the start time of the segment (in seconds since fileStartTime)
//         final timelineStart = segment.startTime
//             .difference(
//                 DateTime.parse(bloc.state.recordingApi.data!.fileStartTime)
//                     .toLocal())
//             .inSeconds
//             .toDouble();
//         final offset = videoPosition - segment.videoPosition;
//         return (timelineStart + offset) * pixelsPerSecond;
//       }
//     }
//     // If not found, fallback
//     return videoPosition * pixelsPerSecond;
//   }
//
//   // Map a timeline position (seconds in full span) to the video position (seconds in video)
//   double? _mapTimelineToVideoPosition(double timelineSeconds) {
//     if (bloc.m3u8TimeMapping == null) {
//       return timelineSeconds;
//     }
//     final timelineDate =
//         DateTime.parse(bloc.state.recordingApi.data!.fileStartTime)
//             .toLocal()
//             .add(Duration(seconds: timelineSeconds.toInt()));
//     return bloc.getVideoPositionForRealTimestamp(timelineDate);
//   }
//
//   void _onScrollEnd({bool isPlay = false}) {
//     final bool isPlaying = bloc.videoController?.value.isPlaying ?? false;
//     if (bloc.videoController != null && !isPlaying) {
//       if (shouldPlay) {
//         final double centerOffset = _scrollController.offset +
//             (MediaQuery.of(context).size.width / 2) -
//             200;
//         final double timelineSeconds = (centerOffset / pixelsPerSecond)
//             .clamp(0, widget.totalVideoDuration);
//
//         // Map timeline position to video position
//         final videoPosition = _mapTimelineToVideoPosition(timelineSeconds);
//
//         if (videoPosition != null) {
//           // If this is a time skip, scroll fast and pause video
//           if (_isPositionInTimeSkip(videoPosition)) {
//             bloc.videoController?.pause();
//             bloc.updatePlaying();
//             // Optionally, jump to the next available content
//             final nextContent = _getNextVideoContentPosition(videoPosition);
//             if (nextContent != null) {
//               bloc.videoController
//                   ?.seekTo(Duration(seconds: nextContent.toInt()));
//             }
//           } else {
//             _isSeekingManually = true;
//             _debounceScrollTimer?.cancel();
//             bloc.updateIsScrollLoading(true);
//             _debounceScrollTimer =
//                 Timer(const Duration(milliseconds: 200), () async {
//               if (bloc.videoController!.value.isInitialized) {
//                 await bloc.videoController!
//                     .seekTo(Duration(seconds: videoPosition.toInt()))
//                     .then((_) {
//                   if (isPlay) {
//                     Future.delayed(const Duration(seconds: 1), () {
//                       _isUserScrolling = false;
//                       _isSeekingManually = false;
//                       bloc.videoController!.play();
//                       bloc.updatePlaying();
//                     });
//                   }
//                 });
//               }
//             });
//           }
//         }
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
//       _isProgrammaticScroll = false;
//       return;
//     }
//
//     if (bloc.videoController != null &&
//         !bloc.videoController!.value.isPlaying) {
//       final double centerOffset = _scrollController.offset +
//           (MediaQuery.of(context).size.width / 2) -
//           200;
//       final double timelineSeconds =
//           (centerOffset / pixelsPerSecond).clamp(0, widget.totalVideoDuration);
//
//       // Map timeline position to video position
//       final videoPosition = _mapTimelineToVideoPosition(timelineSeconds);
//
//       if (videoPosition != null) {
//         if (_isPositionInTimeSkip(videoPosition)) {
//           bloc.videoController?.pause();
//           bloc.updatePlaying();
//         } else {
//           // Optionally, update timer
//           final realTimestamp =
//               bloc.getRealTimestampForVideoPosition(videoPosition);
//           if (realTimestamp != null) {
//             bloc.updateVideoTimer(realTimestamp);
//           }
//         }
//       }
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
//
//     final timelineWidth = widget.totalVideoDuration * pixelsPerSecond;
//     // ... (rest of your build logic, including alert rendering, etc.)
//     return Container(
//       height: 60,
//       width: timelineWidth,
//       child: ListView(
//         controller: _scrollController,
//         scrollDirection: Axis.horizontal,
//         children: [
//           // ... your timeline widgets, alert markers, etc.
//         ],
//       ),
//     );
//   }
// }
//
// class JumpAlertWidget {
//   JumpAlertWidget({
//     required this.widget,
//     required this.id,
//     required this.position,
//     required this.time,
//     this.createdAt,
//   });
//   Widget widget;
//   double position;
//   int id;
//   double time;
//   String? createdAt;
// }
