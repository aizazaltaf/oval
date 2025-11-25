import 'package:admin/models/data/visitor_chat_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/chat/components/temporary_chat_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'chat_state.g.dart';

abstract class ChatState implements Built<ChatState, ChatStateBuilder> {
  factory ChatState([
    final void Function(ChatStateBuilder) updates,
  ]) = _$ChatState;

  ChatState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final ChatStateBuilder b) => b
    ..chatList.replace([])
    ..chatHistory.replace([])
    ..visitorChatHistory.replace([])
    ..chatMessage = ""
    ..notificationLocationId = 0
    ..firstMessageSent = false
    ..isDoorbellBusy = false
    ..isChatScreenActive = false
    ..isDoorbellTyping = false
    ..isAdminTyping = false;

  @BlocUpdateField()
  bool get isChatScreenActive;

  @BlocUpdateField()
  bool get isDoorbellTyping;

  @BlocUpdateField()
  bool get isAdminTyping;

  @BlocUpdateField()
  bool get firstMessageSent;

  @BlocUpdateField()
  int? get notificationId;

  @BlocUpdateField()
  int get notificationLocationId;

  @BlocUpdateField()
  String get chatMessage;

  @BlocUpdateField()
  bool get isDoorbellBusy;

  @BlocUpdateField()
  BuiltList<TemporaryChatModel> get chatList;

  @BlocUpdateField()
  BuiltList<Map<String, dynamic>> get chatHistory;

  @BlocUpdateField()
  BuiltList<VisitorChatModel> get visitorChatHistory;

  ApiState<void> get visitorChatHistoryApi;
}
