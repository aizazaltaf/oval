import 'dart:async';

import 'package:admin/models/data/visitor_chat_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/chat/bloc/chat_bloc.dart';
import 'package:admin/pages/main/chat/components/chat_app_bar.dart';
import 'package:admin/pages/main/chat/components/chat_tile.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/list_view_seperated.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

class VisitorChatHistoryScreen extends StatefulWidget {
  const VisitorChatHistoryScreen({super.key, required this.visitor});

  static const routeName = 'visitorChatHistoryScreen';

  final VisitorsModel visitor;

  static Future<void> push({
    required BuildContext context,
    required VisitorsModel visitor,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => VisitorChatHistoryScreen(visitor: visitor),
    );
  }

  @override
  State<VisitorChatHistoryScreen> createState() =>
      _VisitorChatHistoryScreenState();
}

class _VisitorChatHistoryScreenState extends State<VisitorChatHistoryScreen> {
  late ChatBloc chatBloc;

  @override
  void initState() {
    // implement initState
    chatBloc = ChatBloc.of(context)..callVisitorChatHistory(widget.visitor.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: ChatAppBar(visitor: widget.visitor),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ChatBlocSelector.visitorChatHistoryApi(
          builder: (api) {
            if (api.isApiInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ChatBlocSelector.visitorChatHistory(
                builder: (history) {
                  if (history.isEmpty) {
                    return Center(
                      child: Text(
                        "No Chat History available.",
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontSize: 18,
                                ),
                      ),
                    );
                  } else {
                    final groupedChats = groupBy(
                      history,
                      (chat) => DateFormat('MMMM dd, yyyy').format(
                        chat.createdAt.toLocal(),
                      ),
                    );

                    final groupedEntries = groupedChats.entries.toBuiltList();

                    return Column(
                      children: [
                        Expanded(
                          child: ListViewSeparatedWidget(
                            controller: chatBloc.chatHistoryScrollController,
                            list: groupedEntries,
                            padding: EdgeInsets.zero,
                            physics: const AlwaysScrollableScrollPhysics(),
                            separatorBuilder: (context, groupIndex) =>
                                const SizedBox.shrink(),
                            itemBuilder: (context, groupIndex) {
                              final dateTitle = groupedEntries[groupIndex].key;
                              final BuiltList<VisitorChatModel> chats =
                                  groupedEntries[groupIndex]
                                      .value
                                      .toBuiltList();
                              return StickyHeader(
                                header: stickyHeaderWidget(dateTitle),
                                content: ListViewSeparatedWidget(
                                  list: chats,
                                  padding: EdgeInsets.zero,
                                  separatorBuilder: (context, subIndex) {
                                    if (subIndex == chats.length - 1) {
                                      return const SizedBox.shrink();
                                    }
                                    return const SizedBox(height: 5);
                                  },
                                  itemBuilder: (context, subIndex) {
                                    final chat = chats[subIndex];
                                    return Column(
                                      crossAxisAlignment:
                                          chat.participantType == "user"
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                      children: [
                                        if (chat.participantType == "user")
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: Text(
                                              chat.participant.user.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ),
                                        if (chat.participantType == "user")
                                          const SizedBox(height: 4),
                                        ChatBubble(
                                          participantType: chat.participantType,
                                          message: chat.message,
                                          readStatus: true,
                                          isHistory: true,
                                          historyTimeStamp: chat.createdAt,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget stickyHeaderWidget(String dateTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              formatDateHeader(dateTitle),
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Theme.of(context).disabledColor),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  String formatDateHeader(String dateTitle) {
    // Parse string to DateTime
    final DateTime date = DateFormat("MMMM dd, y").parse(dateTitle);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);
    final difference = today.difference(checkDate).inDays;

    if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Yesterday";
    } else if (difference > 1 && difference < 7) {
      return DateFormat.EEEE().format(date); // Monday, Tuesday, etc.
    } else {
      return DateFormat("MMMM dd, y").format(date); // September 22, 2025
    }
  }
}
