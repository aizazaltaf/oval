import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/data/visitor_chat_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/chat/bloc/chat_state.dart';
import 'package:admin/pages/main/chat/components/temporary_chat_model.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'chat_bloc.bloc.g.dart';

final _logger = Logger('chat_bloc.dart');

@BlocGen()
class ChatBloc extends BVCubit<ChatState, ChatStateBuilder>
    with _ChatBlocMixin {
  ChatBloc() : super(ChatState());

  factory ChatBloc.of(final BuildContext context) =>
      BlocProvider.of<ChatBloc>(context);

  String? sessionId;

  Timer? _debounceTimer;

  void onTextChanged({
    required BuildContext context,
    required String deviceId,
  }) {
    // Cancel previous timer if still active
    _debounceTimer?.cancel();

    // Only set to true if not already true
    if (!state.isAdminTyping) {
      updateIsAdminTyping(true);
      sendMessage(
        deviceId: deviceId,
        command: Constants.typing,
        context: context,
        dataPayload: {
          "status": true,
          "device_id": deviceId,
        },
      );
    }

    // Start a new 2-sec timer
    _debounceTimer = Timer(const Duration(milliseconds: 1500), () {
      updateIsAdminTyping(false);
      sendMessage(
        deviceId: deviceId,
        command: Constants.typing,
        context: context,
        dataPayload: {
          "status": false,
          "device_id": deviceId,
        },
      );
    });
  }

  // Idle timeout timer
  Timer? _idleTimer;
  static const idleDuration = Duration(minutes: 1);

  void reInitializeState() {
    emit(
      state.rebuild(
        (final b) => b
          ..chatMessage = ""
          ..isDoorbellTyping = false
          ..firstMessageSent = false
          ..isDoorbellBusy = false
          ..isAdminTyping = false,
      ),
    );
  }

  void startIdleTimer(BuildContext context) {
    _resetIdleTimer(context);
  }

  void resetIdleTimer(BuildContext context) {
    _resetIdleTimer(context);
  }

  void _resetIdleTimer(BuildContext context) {
    _idleTimer?.cancel();
    _idleTimer = Timer(idleDuration, () {
      if (Navigator.of(context).canPop() && state.isChatScreenActive) {
        Navigator.of(context).pop();
      }
      _idleTimer?.cancel();
    });
  }

  void disposeIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = null;
  }

  // Initialize ScrollControllers
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  final ScrollController _chatHistoryScrollController = ScrollController();
  ScrollController get chatHistoryScrollController =>
      _chatHistoryScrollController;

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        unawaited(
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          ),
        );
      }
    });
  }

  void scrollHistoryToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatHistoryScrollController.hasClients) {
        unawaited(
          chatHistoryScrollController.animateTo(
            chatHistoryScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          ),
        );
      }
    });
  }

  List<Map<String, dynamic>> sendChatToSocket(String visitorId) {
    // find the visitor entry
    final index =
        state.chatHistory.indexWhere((entry) => entry.containsKey(visitorId));
    if (index == -1) {
      return [];
    }

    final visitorData =
        state.chatHistory[index][visitorId] as Map<String, dynamic>;
    final chats = visitorData["chats"] as BuiltList<TemporaryChatModel>;

    // build list of maps
    return chats.map((chat) {
      return {
        "message": chat.message,
        "visitor_id": chat.visitorId,
        "admin_user_id": chat.adminUserId,
        "time": chat.time,
        "device_id": chat.deviceId,
        "participant_type": chat.participantType,
        "read_status": chat.readStatus,
      };
    }).toList();
  }

  void removeVisitor(String visitorId) {
    final index =
        state.chatHistory.indexWhere((entry) => entry.containsKey(visitorId));

    if (index != -1) {
      final updatedList = state.chatHistory.rebuild((b) => b.removeAt(index));
      emit(state.rebuild((b) => b..chatHistory = updatedList.toBuilder()));
    }
  }

  // --- Clean up expired chats (> 3 minutes old) ---
  BuiltList<Map<String, dynamic>> _cleanupExpiredChats(
    BuiltList<Map<String, dynamic>> chatHistory,
  ) {
    final now = DateTime.now();

    return BuiltList<Map<String, dynamic>>(
      chatHistory.where((entry) {
        final visitorId = entry.keys.first;
        final timestamp = entry[visitorId]["timestamp"] as int;
        final time = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
        return now.difference(time).inMinutes < 3;
      }),
    );
  }

  // --- Get chats for visitor ---
  void getChats(
    int? visitorId,
    int newTimestamp,
  ) {
    final cleaned = _cleanupExpiredChats(state.chatHistory);

    if (visitorId == null) {
      updateChatList(BuiltList<TemporaryChatModel>([]));
      return;
    }

    final String visitorIdString = visitorId.toString();

    final index =
        cleaned.indexWhere((entry) => entry.containsKey(visitorIdString));

    if (index != -1) {
      final visitorData =
          cleaned[index][visitorIdString] as Map<String, dynamic>;

      // update timestamp if needed
      if (visitorData["timestamp"] != newTimestamp) {
        final updatedData = {
          "chats": visitorData["chats"],
          "timestamp": newTimestamp,
        };

        final updatedList = cleaned.rebuild((b) {
          b[index] = {visitorIdString: updatedData};
        });

        emit(state.rebuild((b) => b..chatHistory = updatedList.toBuilder()));
      } else {
        emit(state.rebuild((b) => b..chatHistory = cleaned.toBuilder()));
      }

      updateChatList(
        state.chatHistory[index][visitorIdString]["chats"]
            as BuiltList<TemporaryChatModel>,
      );
    } else {
      // create new entry
      final newEntry = {
        visitorIdString: {
          "chats": BuiltList<TemporaryChatModel>(),
          "timestamp": newTimestamp,
        },
      };
      final updatedList = cleaned.rebuild((b) => b.add(newEntry));

      emit(state.rebuild((b) => b..chatHistory = updatedList.toBuilder()));

      updateChatList(BuiltList<TemporaryChatModel>([]));
    }
  }

  void saveChat(String visitorId, TemporaryChatModel chat, int timestamp) {
    final index =
        state.chatHistory.indexWhere((entry) => entry.containsKey(visitorId));

    if (index != -1) {
      final visitorData =
          state.chatHistory[index][visitorId] as Map<String, dynamic>;
      final oldChats = visitorData["chats"] as BuiltList<TemporaryChatModel>;

      final updatedData = {
        "chats": oldChats.rebuild((b) => b.add(chat)),
        "timestamp": timestamp,
      };

      final updatedList = state.chatHistory.rebuild((b) {
        b[index] = {visitorId: updatedData};
      });

      emit(state.rebuild((b) => b..chatHistory = updatedList.toBuilder()));
    } else {
      final newEntry = {
        visitorId: {
          "chats": BuiltList<TemporaryChatModel>([chat]),
          "timestamp": timestamp,
        },
      };
      final updatedList = state.chatHistory.rebuild((b) => b.add(newEntry));

      emit(state.rebuild((b) => b..chatHistory = updatedList.toBuilder()));
    }
  }

  void markMessageAsRead(int? visitorId, int messageTime) {
    // Update chatList first
    final updatedChatList = state.chatList.rebuild((b) {
      for (int i = 0; i < b.length; i++) {
        if (b[i].time == messageTime) {
          b[i] = b[i].copyWith(readStatus: true);
          break;
        }
      }
    });

    // Update chatList in state
    updateChatList(updatedChatList);

    // If visitorId is provided, update chatHistory with updatedChatList
    if (visitorId != null) {
      final String visitorIdString = visitorId.toString();

      final index = state.chatHistory
          .indexWhere((entry) => entry.containsKey(visitorIdString));

      if (index == -1) {
        return; // visitor not found
      }

      final visitorData =
          state.chatHistory[index][visitorIdString] as Map<String, dynamic>;

      final updatedData = {
        "chats": updatedChatList, // replace with updated chatList
        "timestamp": visitorData["timestamp"],
      };

      final updatedList = state.chatHistory
          .rebuild((b) => b[index] = {visitorIdString: updatedData});

      emit(state.rebuild((b) => b..chatHistory = updatedList.toBuilder()));
    }
  }

  void sendMessage({
    String? channelName,
    required String deviceId,
    required String command,
    required dynamic dataPayload,
    BuildContext? context,
  }) {
    singletonBloc.socketEmitterWithAck(
      roomName: channelName ?? Constants.chat,
      roomId: state.notificationLocationId.toString(),
      request: command,
      deviceId: deviceId,
      message: dataPayload,
      acknowledgement: (data) {
        _logger.severe(data);
      },
    );

    if (context != null) {
      resetIdleTimer(context);
    }
  }

  Future<void> socketListener(
    BuildContext context,
    int? notificationTimeStamp,
    int? visitorId,
    String? visitorName,
  ) async {
    sessionId ??= await CommonFunctions.getDeviceModel();
    singletonBloc.socket?.off(Constants.chat);
    singletonBloc.socket?.on(Constants.chat, (data) async {
      final command = data[Constants.command];
      final deviceId = data[Constants.deviceId];
      final session = data[Constants.sessionId];

      if (session != sessionId) {
        return;
      }

      switch (command) {
        case Constants.message:
          final json = data["data"];
          final chat = TemporaryChatModel(
            deviceId: deviceId,
            message: json['message'],
            participantType: "visitor",
            adminUserId: json["admin_user_id"],
            time: int.tryParse(json["time"].toString()),
            visitorId: json["visitor_id"],
            readStatus: true,
          );
          final list = state.chatList.rebuild((b) => b.add(chat));
          updateChatList(list);
          scrollToBottom();
          sendMessage(
            deviceId: deviceId,
            command: Constants.acknowledgement,
            dataPayload: {
              "time": json["time"],
            },
          );
          if (json["visitor_id"] != 0 && notificationTimeStamp != null) {
            saveChat(
              json["visitor_id"].toString(),
              chat,
              notificationTimeStamp,
            );
            unawaited(
              apiService.saveChatMessage(
                chat,
                state.notificationLocationId,
                "visitor",
                visitorName!,
              ),
            );
          }
        case Constants.typing:
          final json = data["data"];
          final isTyping = json['status'];
          updateIsDoorbellTyping(isTyping);
          scrollToBottom();
        case Constants.busy:
          updateIsDoorbellBusy(true);
          ToastUtils.errorToast("Doorbell is busy...");
          if (Navigator.of(context).canPop() && state.isChatScreenActive) {
            Navigator.of(context).pop();
          }
        case Constants.acknowledgement:
          final json = data["data"];
          markMessageAsRead(visitorId, json["time"]);
      }

      if (state.isChatScreenActive) {
        resetIdleTimer(context); // reset on any incoming message
      }
    });
  }

  Future<void> callVisitorChatHistory(int visitorId) {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.visitorChatHistoryApi,
      updateApiState: (final b, final apiState) =>
          b.visitorChatHistoryApi.replace(apiState),
      callApi: () async {
        final list = await apiService.getChatMessages(visitorId);
        updateVisitorChatHistory(list);
        scrollHistoryToBottom();
      },
    );
  }
}
