// import 'package:flutter/material.dart';
//
// class TimelineSegment {
//   TimelineSegment({required this.start, required this.duration});
//   final DateTime start;
//   final Duration duration;
// }
//
// class AiAlertMarker {
//   AiAlertMarker(this.time, this.label);
//   final DateTime time;
//   final String label;
// }
//
// class RingStyleScroller extends StatefulWidget {
//   const RingStyleScroller({
//     required this.segments,
//     required this.aiAlerts,
//     required this.onSeek,
//     super.key,
//   });
//   final List<TimelineSegment> segments;
//   final List<AiAlertMarker> aiAlerts;
//   final Function(Duration) onSeek;
//
//   @override
//   State<RingStyleScroller> createState() => _RingStyleScrollerState();
// }
//
// class _RingStyleScrollerState extends State<RingStyleScroller> {
//   final ScrollController _controller = ScrollController();
//   final double pxPerSecond = 2;
//
//   double? _hoverX;
//   Duration? _hoverTime;
//
//   Duration getTimeFromOffset(double offset) {
//     double position = 0;
//
//     for (final seg in widget.segments) {
//       final segWidth = seg.duration.inSeconds * pxPerSecond;
//       if (offset < position + segWidth) {
//         final delta = (offset - position) / pxPerSecond;
//         return seg.start.difference(widget.segments[0].start) +
//             Duration(seconds: delta.round());
//       }
//       position += segWidth;
//     }
//     return Duration.zero;
//   }
//
//   double getOffsetFromTime(DateTime target) {
//     double offset = 0;
//     final base = widget.segments[0].start;
//
//     for (final seg in widget.segments) {
//       final segEnd = seg.start.add(seg.duration);
//       if (target.isAfter(seg.start) && target.isBefore(segEnd)) {
//         final delta = target.difference(seg.start).inSeconds.toDouble();
//         return offset + delta * pxPerSecond;
//       }
//       offset += seg.duration.inSeconds * pxPerSecond;
//     }
//     return offset;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final totalWidth = widget.segments.fold<double>(
//         0, (sum, seg) => sum + seg.duration.inSeconds * pxPerSecond);
//     final baseStart = widget.segments[0].start;
//
//     return Stack(
//       children: [
//         GestureDetector(
//           onTapDown: (details) {
//             final pos = details.localPosition.dx + _controller.offset;
//             final time = getTimeFromOffset(pos);
//             widget.onSeek(time);
//           },
//           onHorizontalDragUpdate: (details) {
//             setState(() {
//               _hoverX = details.localPosition.dx + _controller.offset;
//               _hoverTime = getTimeFromOffset(_hoverX!);
//             });
//           },
//           child: SingleChildScrollView(
//             controller: _controller,
//             scrollDirection: Axis.horizontal,
//             child: SizedBox(
//               width: totalWidth,
//               height: 80,
//               child: Stack(
//                 children: [
//                   Row(
//                     children: widget.segments.map((seg) {
//                       final width = seg.duration.inSeconds * pxPerSecond;
//                       return Container(
//                         width: width,
//                         height: 60,
//                         margin: const EdgeInsets.symmetric(horizontal: 1),
//                         color: Colors.blueAccent,
//                         child: Center(
//                           child: Text(
//                             "${seg.start.hour}:${seg.start.minute.toString().padLeft(2, '0')}",
//                             style: const TextStyle(
//                                 color: Colors.white, fontSize: 12),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   // AI alert markers
//                   ...widget.aiAlerts.map((alert) {
//                     final left = getOffsetFromTime(alert.time);
//                     return Positioned(
//                       left: left,
//                       top: 0,
//                       child: Container(
//                         width: 4,
//                         height: 60,
//                         color: Colors.red,
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         // Floating time tooltip
//         if (_hoverTime != null)
//           Positioned(
//             top: 0,
//             left: (_hoverX ?? 0) - _controller.offset,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.black87,
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Text(
//                 _hoverTime!.toString().split('.').first,
//                 style: const TextStyle(color: Colors.white, fontSize: 12),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
