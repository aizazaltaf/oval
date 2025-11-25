import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/main/voice_control/component/grouped_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.index, this.isSender = false});
  final int index;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    final bloc = VoiceControlBloc.of(context);
    final chatData = bloc.state.chatData[index];

    final bool hasImage = chatData.senderImage != null;
    final bool hasListing = chatData.listingViewModel != null;
    final bool isListingEmpty =
        hasListing && chatData.listingViewModel!.isEmpty;

    return CustomPaint(
      painter: SpecialChatBubbleThree(
        color: hasImage
            ? Theme.of(context).primaryColor
            : Colors.grey.withValues(alpha: 0.1),
        alignment: !isSender ? Alignment.topRight : Alignment.topLeft,
        tail: true,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: isSender ? 20 : 15,
          right: isSender ? 15 : 20,
          top: 10,
          bottom: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatData.text ?? "",
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: !isSender ? Colors.white : null),
            ),
            Visibility(
              visible: hasListing,
              child: const SizedBox(height: 10),
            ),
            if (hasListing)
              isListingEmpty
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Text(
                        context.appLocalizations.no_device_found,
                        maxLines: 3,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.start,
                      ),
                    )
                  : Stack(
                      children: [
                        if (chatData.listingViewModel!.first.roomName != null)
                          GroupedData(items: chatData.listingViewModel!)
                        else
                          ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(), // Prevents nested scroll issues
                            itemBuilder: (context, indexListing) {
                              final listing =
                                  chatData.listingViewModel![indexListing];
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: MarkdownBody(
                                  data: listing.showNumbers == false
                                      ? "${listing.name}${listing.roomName != null ? " (${listing.roomName})" : ""}"
                                      : "${indexListing + 1}. ${listing.name}${listing.roomName != null ? " (${listing.roomName})" : ""}",
                                  styleSheet: MarkdownStyleSheet(
                                    p: Theme.of(context).textTheme.bodyMedium,
                                    strong: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ), // Bold text
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 1),
                            itemCount: chatData.listingViewModel!.length,
                          ),
                      ],
                    ),
          ],
        ),
      ),
    );
  }
}

class SpecialChatBubbleThree extends CustomPainter {
  SpecialChatBubbleThree({
    required this.color,
    required this.alignment,
    required this.tail,
  });
  final Color color;
  final Alignment alignment;
  final bool tail;

  final double _radius = 10;

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;
    if (alignment == Alignment.topRight) {
      if (tail) {
        final path = Path()

          /// starting point
          ..moveTo(_radius * 2, 0)

          /// top-left corner
          ..quadraticBezierTo(0, 0, 0, _radius * 1.5)

          /// left line
          ..lineTo(0, h - _radius * 1.5)

          /// bottom-left corner
          ..quadraticBezierTo(0, h, _radius * 2, h)

          /// bottom line
          ..lineTo(w - _radius * 3, h)

          /// bottom-right bubble curve
          ..quadraticBezierTo(
            w - _radius * 1.5,
            h,
            w - _radius * 1.5,
            h - _radius * 0.6,
          )

          /// bottom-right tail curve 1
          ..quadraticBezierTo(w - _radius * 1, h, w, h)

          /// bottom-right tail curve 2
          ..quadraticBezierTo(
            w - _radius * 0.8,
            h,
            w - _radius,
            h - _radius * 1.5,
          )

          /// right line
          ..lineTo(w - _radius, _radius * 1.5)

          /// top-right curve
          ..quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas
          ..clipPath(path)
          ..drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill,
          );
      } else {
        final path = Path()

          /// starting point
          ..moveTo(_radius * 2, 0)

          /// top-left corner
          ..quadraticBezierTo(0, 0, 0, _radius * 1.5)

          /// left line
          ..lineTo(0, h - _radius * 1.5)

          /// bottom-left corner
          ..quadraticBezierTo(0, h, _radius * 2, h)

          /// bottom line
          ..lineTo(w - _radius * 3, h)

          /// bottom-right curve
          ..quadraticBezierTo(w - _radius, h, w - _radius, h - _radius * 1.5)

          /// right line
          ..lineTo(w - _radius, _radius * 1.5)

          /// top-right curve
          ..quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas
          ..clipPath(path)
          ..drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill,
          );
      }
    } else {
      if (tail) {
        final path = Path()

          /// starting point
          ..moveTo(_radius * 3, 0)

          /// top-left corner
          ..quadraticBezierTo(_radius, 0, _radius, _radius * 1.5)

          /// left line
          ..lineTo(_radius, h - _radius * 1.5)
          // bottom-right tail curve 1
          ..quadraticBezierTo(_radius * .8, h, 0, h)

          /// bottom-right tail curve 2
          ..quadraticBezierTo(
            _radius * 1,
            h,
            _radius * 1.5,
            h - _radius * 0.6,
          )

          /// bottom-left bubble curve
          ..quadraticBezierTo(_radius * 1.5, h, _radius * 3, h)

          /// bottom line
          ..lineTo(w - _radius * 2, h)

          /// bottom-right curve
          ..quadraticBezierTo(w, h, w, h - _radius * 1.5)

          /// right line
          ..lineTo(w, _radius * 1.5)

          /// top-right curve
          ..quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas
          ..clipPath(path)
          ..drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill,
          );
      } else {
        final path = Path()

          /// starting point
          ..moveTo(_radius * 3, 0)

          /// top-left corner
          ..quadraticBezierTo(_radius, 0, _radius, _radius * 1.5)

          /// left line
          ..lineTo(_radius, h - _radius * 1.5)

          /// bottom-left curve
          ..quadraticBezierTo(_radius, h, _radius * 3, h)

          /// bottom line
          ..lineTo(w - _radius * 2, h)

          /// bottom-right curve
          ..quadraticBezierTo(w, h, w, h - _radius * 1.5)

          /// right line
          ..lineTo(w, _radius * 1.5)

          /// top-right curve
          ..quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas
          ..clipPath(path)
          ..drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill,
          );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
