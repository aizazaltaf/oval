import 'package:admin/pages/main/voice_control/component/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.participantType,
    required this.message,
    required this.readStatus,
    this.realChatTimeStamp,
    this.historyTimeStamp,
    this.isHistory = false,
  });

  final String participantType;
  final String message;
  final bool readStatus;
  final int? realChatTimeStamp;
  final DateTime? historyTimeStamp;
  final bool isHistory;

  @override
  Widget build(BuildContext context) {
    final bg = participantType == "user"
        ? Theme.of(context).primaryColor
        : Colors.grey.withValues(alpha: 0.1);

    final String formattedTime;
    final DateTime dateTimeUtc;

    if (isHistory) {
      //getting dateTime from UTC timeStamp
      dateTimeUtc = historyTimeStamp!;
    } else {
      // getting dateTime from millisecondsSinceEpoch
      dateTimeUtc = DateTime.fromMillisecondsSinceEpoch(
        realChatTimeStamp ?? 0,
        isUtc: true,
      );
    }
    formattedTime = DateFormat.jm().format(dateTimeUtc.toLocal());

    return Row(
      mainAxisAlignment: participantType == "user"
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 70.w, minWidth: 200),
          child: CustomPaint(
            painter: SpecialChatBubbleThree(
              color: bg,
              alignment: participantType == "user"
                  ? Alignment.topRight
                  : Alignment.topLeft,
              tail: false,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: participantType == "user" ? 10 : 20,
                right: participantType == "user" ? 20 : 15,
                top: 6,
                bottom: 6,
              ),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Message text
                    SelectableText(
                      message,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                            color:
                                participantType == "user" ? Colors.white : null,
                          ),
                    ),
                    // Time row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          formattedTime,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                    color: participantType == "user"
                                        ? Colors.white
                                        : null,
                                  ),
                        ),
                        if (participantType == "user") const SizedBox(width: 4),
                        // Optional: check mark for sender
                        if (participantType == "user")
                          Icon(
                            readStatus ? Icons.done_all : Icons.done,
                            size: 14,
                            color:
                                readStatus ? Colors.greenAccent : Colors.grey,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
