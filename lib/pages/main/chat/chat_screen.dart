import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/chat/bloc/chat_bloc.dart';
import 'package:admin/pages/main/chat/components/chat_app_bar.dart';
import 'package:admin/pages/main/chat/components/chat_tile.dart';
import 'package:admin/pages/main/chat/components/temporary_chat_model.dart';
import 'package:admin/pages/main/chat/components/typing_tile.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/list_view_seperated.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.doorbellUserId,
    required this.notificationCreatedAt,
    required this.notificationId,
    required this.deviceId,
    required this.visitors,
  });

  static const routeName = 'chatScreen';

  final String doorbellUserId;
  final String notificationCreatedAt;
  final int notificationId;
  final String deviceId;
  final VisitorsModel? visitors;

  static Future<void> push({
    required BuildContext context,
    required String doorbellUserId,
    required String notificationCreatedAt,
    required String deviceId,
    required VisitorsModel? visitors,
    required int notificationId,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => ChatScreen(
        doorbellUserId: doorbellUserId,
        notificationCreatedAt: notificationCreatedAt,
        deviceId: deviceId,
        visitors: visitors,
        notificationId: notificationId,
      ),
    );
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final messageController = TextEditingController();

  late ChatBloc chatBloc;

  @override
  void initState() {
    // implement initState
    WidgetsBinding.instance.addObserver(this); // Add observer

    // Parse ISO string → DateTime
    final dt = DateTime.parse(widget.notificationCreatedAt);

    // Convert to local time
    final localTime = dt.toLocal();

    // Convert back to UTC
    final utcTime = localTime.toUtc();

    // Convert to milliseconds since epoch
    final millis = utcTime.millisecondsSinceEpoch;

    chatBloc = ChatBloc.of(context);
    if (chatBloc.state.notificationId != widget.notificationId) {
      chatBloc.updateChatList(BuiltList<TemporaryChatModel>());
    }
    chatBloc
      ..updateIsChatScreenActive(true)
      ..reInitializeState()
      ..sendMessage(
        deviceId: widget.deviceId,
        command: Constants.openChat,
        dataPayload: null,
      )
      ..updateNotificationId(widget.notificationId)
      ..getChats(widget.visitors?.id, millis)
      ..scrollToBottom()
      ..startIdleTimer(context) // 🔹 Start timer when screen opens
      ..socketListener(
        context,
        millis,
        widget.visitors?.id,
        widget.visitors?.name,
      ); // 🔹 Start listening for messages
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Parse ISO string → DateTime
    final dt = DateTime.parse(widget.notificationCreatedAt);

    // Convert to local time
    final localTime = dt.toLocal();

    // Convert back to UTC
    final utcTime = localTime.toUtc();

    // Convert to milliseconds since epoch
    final millis = utcTime.millisecondsSinceEpoch;
    if (state == AppLifecycleState.paused) {
      disposeScreen();
      Navigator.pop(context);
    } else if (state == AppLifecycleState.resumed) {
      chatBloc
        ..updateIsChatScreenActive(true)
        ..socketListener(
          context,
          millis,
          widget.visitors?.id,
          widget.visitors?.name,
        );
    }
    // else if (state == AppLifecycleState.inactive) {
    //   disposeScreen();
    // }
  }

  void disposeScreen() {
    chatBloc
      ..updateIsChatScreenActive(false)
      ..disposeIdleTimer();
    if (!chatBloc.state.isDoorbellBusy) {
      chatBloc.sendMessage(
        deviceId: widget.deviceId,
        command: Constants.endChat,
        dataPayload: null,
      );
    }
  }

  @override
  void dispose() {
    singletonBloc.socket?.off(Constants.chat);
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    disposeScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = ChatBloc.of(context);
    return ChatBlocBuilder(
      builder: (context, state) {
        return AppScaffold(
          appBar: ChatAppBar(visitor: widget.visitors),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: (state.chatList.isEmpty)
                      ? Center(
                          child: Text(
                            "No chat available.",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  fontSize: 20,
                                ),
                          ),
                        )
                      : ListViewSeparatedWidget(
                          controller: chatBloc.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 5);
                          },
                          list: state.chatList,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ChatBubble(
                                  participantType:
                                      state.chatList[index].participantType,
                                  message: state.chatList[index].message,
                                  readStatus: state.chatList[index].readStatus,
                                  realChatTimeStamp: state.chatList[index].time,
                                ),
                                if (index == state.chatList.length - 1)
                                  // Typing widget
                                  if (state.isDoorbellTyping)
                                    const TypingBubble(),
                              ],
                            );
                          },
                        ),
                ),

                // Bottom Bar
                chatBottomBar(chatBloc),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget chatBottomBar(ChatBloc chatBloc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: NameTextFormField(
              controller: messageController,
              autoFocus: true,
              customCircularBorder: 30,
              customDefaultBorderSide:
                  BorderSide(color: Theme.of(context).primaryColor),
              hintText: "Type a message...",
              onChanged: (val) {
                chatBloc
                  ..updateChatMessage(val.trim())
                  ..onTextChanged(
                    context: context,
                    deviceId: widget.deviceId,
                  );
              },
            ),
          ),
          const SizedBox(width: 10),
          IgnorePointer(
            ignoring: chatBloc.state.chatMessage.isEmpty,
            child: GestureDetector(
              onTap: () {
                // Parse ISO string → DateTime
                final dt = DateTime.parse(widget.notificationCreatedAt);

                final localTime = dt.toLocal();

                final utcTime = localTime.toUtc();

                final millis = utcTime.millisecondsSinceEpoch;

                final chat = TemporaryChatModel(
                  deviceId: widget.deviceId,
                  message: messageController.text.trim(),
                  doorbellCallUserId: widget.doorbellUserId,
                  adminUserId: singletonBloc.profileBloc.state?.id ?? 0,
                  time: DateTime.now().toUtc().millisecondsSinceEpoch,
                  visitorId: widget.visitors?.id ?? 0,
                );

                final list =
                    chatBloc.state.chatList.rebuild((b) => b.add(chat));
                chatBloc
                  ..updateChatList(list)
                  ..scrollToBottom();
                messageController.clear();

                if (widget.visitors != null) {
                  chatBloc.saveChat(
                    widget.visitors!.id.toString(),
                    chat,
                    millis,
                  );
                }

                chatBloc
                  ..sendMessage(
                    deviceId: widget.deviceId,
                    command: Constants.message,
                    context: context,
                    dataPayload: chatBloc.state.firstMessageSent ||
                            widget.visitors == null
                        ? [
                            {
                              "message": chat.message,
                              "visitor_id": chat.visitorId,
                              "admin_user_id": chat.adminUserId,
                              "time": chat.time,
                              "device_id": chat.deviceId,
                              "participant_type": chat.participantType,
                              "read_status": chat.readStatus,
                            }
                          ]
                        : chatBloc.sendChatToSocket(
                            widget.visitors!.id.toString(),
                          ),
                  )
                  ..updateIsAdminTyping(false)
                  ..sendMessage(
                    deviceId: widget.deviceId,
                    command: Constants.typing,
                    context: context,
                    dataPayload: {
                      "status": false,
                      "device_id": widget.deviceId,
                    },
                  );
                if (widget.visitors != null) {
                  apiService.saveChatMessage(
                    chat,
                    chatBloc.state.notificationLocationId,
                    "user",
                    widget.visitors!.name,
                  );
                }
                if (!chatBloc.state.firstMessageSent) {
                  chatBloc.updateFirstMessageSent(true);
                }
                chatBloc.updateChatMessage("");
              },
              child: Container(
                height: 44,
                width: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      // messageController.text.trim().isEmpty
                      //     ? Colors.grey
                      //     :
                      Theme.of(
                    context,
                  ).primaryColor,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.send,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
