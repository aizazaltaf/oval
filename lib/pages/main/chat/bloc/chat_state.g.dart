// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatState extends ChatState {
  @override
  final bool isChatScreenActive;
  @override
  final bool isDoorbellTyping;
  @override
  final bool isAdminTyping;
  @override
  final bool firstMessageSent;
  @override
  final int? notificationId;
  @override
  final int notificationLocationId;
  @override
  final String chatMessage;
  @override
  final bool isDoorbellBusy;
  @override
  final BuiltList<TemporaryChatModel> chatList;
  @override
  final BuiltList<Map<String, dynamic>> chatHistory;
  @override
  final BuiltList<VisitorChatModel> visitorChatHistory;
  @override
  final ApiState<void> visitorChatHistoryApi;

  factory _$ChatState([void Function(ChatStateBuilder)? updates]) =>
      (ChatStateBuilder()..update(updates))._build();

  _$ChatState._(
      {required this.isChatScreenActive,
      required this.isDoorbellTyping,
      required this.isAdminTyping,
      required this.firstMessageSent,
      this.notificationId,
      required this.notificationLocationId,
      required this.chatMessage,
      required this.isDoorbellBusy,
      required this.chatList,
      required this.chatHistory,
      required this.visitorChatHistory,
      required this.visitorChatHistoryApi})
      : super._();
  @override
  ChatState rebuild(void Function(ChatStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatStateBuilder toBuilder() => ChatStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatState &&
        isChatScreenActive == other.isChatScreenActive &&
        isDoorbellTyping == other.isDoorbellTyping &&
        isAdminTyping == other.isAdminTyping &&
        firstMessageSent == other.firstMessageSent &&
        notificationId == other.notificationId &&
        notificationLocationId == other.notificationLocationId &&
        chatMessage == other.chatMessage &&
        isDoorbellBusy == other.isDoorbellBusy &&
        chatList == other.chatList &&
        chatHistory == other.chatHistory &&
        visitorChatHistory == other.visitorChatHistory &&
        visitorChatHistoryApi == other.visitorChatHistoryApi;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isChatScreenActive.hashCode);
    _$hash = $jc(_$hash, isDoorbellTyping.hashCode);
    _$hash = $jc(_$hash, isAdminTyping.hashCode);
    _$hash = $jc(_$hash, firstMessageSent.hashCode);
    _$hash = $jc(_$hash, notificationId.hashCode);
    _$hash = $jc(_$hash, notificationLocationId.hashCode);
    _$hash = $jc(_$hash, chatMessage.hashCode);
    _$hash = $jc(_$hash, isDoorbellBusy.hashCode);
    _$hash = $jc(_$hash, chatList.hashCode);
    _$hash = $jc(_$hash, chatHistory.hashCode);
    _$hash = $jc(_$hash, visitorChatHistory.hashCode);
    _$hash = $jc(_$hash, visitorChatHistoryApi.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatState')
          ..add('isChatScreenActive', isChatScreenActive)
          ..add('isDoorbellTyping', isDoorbellTyping)
          ..add('isAdminTyping', isAdminTyping)
          ..add('firstMessageSent', firstMessageSent)
          ..add('notificationId', notificationId)
          ..add('notificationLocationId', notificationLocationId)
          ..add('chatMessage', chatMessage)
          ..add('isDoorbellBusy', isDoorbellBusy)
          ..add('chatList', chatList)
          ..add('chatHistory', chatHistory)
          ..add('visitorChatHistory', visitorChatHistory)
          ..add('visitorChatHistoryApi', visitorChatHistoryApi))
        .toString();
  }
}

class ChatStateBuilder implements Builder<ChatState, ChatStateBuilder> {
  _$ChatState? _$v;

  bool? _isChatScreenActive;
  bool? get isChatScreenActive => _$this._isChatScreenActive;
  set isChatScreenActive(bool? isChatScreenActive) =>
      _$this._isChatScreenActive = isChatScreenActive;

  bool? _isDoorbellTyping;
  bool? get isDoorbellTyping => _$this._isDoorbellTyping;
  set isDoorbellTyping(bool? isDoorbellTyping) =>
      _$this._isDoorbellTyping = isDoorbellTyping;

  bool? _isAdminTyping;
  bool? get isAdminTyping => _$this._isAdminTyping;
  set isAdminTyping(bool? isAdminTyping) =>
      _$this._isAdminTyping = isAdminTyping;

  bool? _firstMessageSent;
  bool? get firstMessageSent => _$this._firstMessageSent;
  set firstMessageSent(bool? firstMessageSent) =>
      _$this._firstMessageSent = firstMessageSent;

  int? _notificationId;
  int? get notificationId => _$this._notificationId;
  set notificationId(int? notificationId) =>
      _$this._notificationId = notificationId;

  int? _notificationLocationId;
  int? get notificationLocationId => _$this._notificationLocationId;
  set notificationLocationId(int? notificationLocationId) =>
      _$this._notificationLocationId = notificationLocationId;

  String? _chatMessage;
  String? get chatMessage => _$this._chatMessage;
  set chatMessage(String? chatMessage) => _$this._chatMessage = chatMessage;

  bool? _isDoorbellBusy;
  bool? get isDoorbellBusy => _$this._isDoorbellBusy;
  set isDoorbellBusy(bool? isDoorbellBusy) =>
      _$this._isDoorbellBusy = isDoorbellBusy;

  ListBuilder<TemporaryChatModel>? _chatList;
  ListBuilder<TemporaryChatModel> get chatList =>
      _$this._chatList ??= ListBuilder<TemporaryChatModel>();
  set chatList(ListBuilder<TemporaryChatModel>? chatList) =>
      _$this._chatList = chatList;

  ListBuilder<Map<String, dynamic>>? _chatHistory;
  ListBuilder<Map<String, dynamic>> get chatHistory =>
      _$this._chatHistory ??= ListBuilder<Map<String, dynamic>>();
  set chatHistory(ListBuilder<Map<String, dynamic>>? chatHistory) =>
      _$this._chatHistory = chatHistory;

  ListBuilder<VisitorChatModel>? _visitorChatHistory;
  ListBuilder<VisitorChatModel> get visitorChatHistory =>
      _$this._visitorChatHistory ??= ListBuilder<VisitorChatModel>();
  set visitorChatHistory(ListBuilder<VisitorChatModel>? visitorChatHistory) =>
      _$this._visitorChatHistory = visitorChatHistory;

  ApiStateBuilder<void>? _visitorChatHistoryApi;
  ApiStateBuilder<void> get visitorChatHistoryApi =>
      _$this._visitorChatHistoryApi ??= ApiStateBuilder<void>();
  set visitorChatHistoryApi(ApiStateBuilder<void>? visitorChatHistoryApi) =>
      _$this._visitorChatHistoryApi = visitorChatHistoryApi;

  ChatStateBuilder() {
    ChatState._initialize(this);
  }

  ChatStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isChatScreenActive = $v.isChatScreenActive;
      _isDoorbellTyping = $v.isDoorbellTyping;
      _isAdminTyping = $v.isAdminTyping;
      _firstMessageSent = $v.firstMessageSent;
      _notificationId = $v.notificationId;
      _notificationLocationId = $v.notificationLocationId;
      _chatMessage = $v.chatMessage;
      _isDoorbellBusy = $v.isDoorbellBusy;
      _chatList = $v.chatList.toBuilder();
      _chatHistory = $v.chatHistory.toBuilder();
      _visitorChatHistory = $v.visitorChatHistory.toBuilder();
      _visitorChatHistoryApi = $v.visitorChatHistoryApi.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatState other) {
    _$v = other as _$ChatState;
  }

  @override
  void update(void Function(ChatStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatState build() => _build();

  _$ChatState _build() {
    _$ChatState _$result;
    try {
      _$result = _$v ??
          _$ChatState._(
            isChatScreenActive: BuiltValueNullFieldError.checkNotNull(
                isChatScreenActive, r'ChatState', 'isChatScreenActive'),
            isDoorbellTyping: BuiltValueNullFieldError.checkNotNull(
                isDoorbellTyping, r'ChatState', 'isDoorbellTyping'),
            isAdminTyping: BuiltValueNullFieldError.checkNotNull(
                isAdminTyping, r'ChatState', 'isAdminTyping'),
            firstMessageSent: BuiltValueNullFieldError.checkNotNull(
                firstMessageSent, r'ChatState', 'firstMessageSent'),
            notificationId: notificationId,
            notificationLocationId: BuiltValueNullFieldError.checkNotNull(
                notificationLocationId, r'ChatState', 'notificationLocationId'),
            chatMessage: BuiltValueNullFieldError.checkNotNull(
                chatMessage, r'ChatState', 'chatMessage'),
            isDoorbellBusy: BuiltValueNullFieldError.checkNotNull(
                isDoorbellBusy, r'ChatState', 'isDoorbellBusy'),
            chatList: chatList.build(),
            chatHistory: chatHistory.build(),
            visitorChatHistory: visitorChatHistory.build(),
            visitorChatHistoryApi: visitorChatHistoryApi.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'chatList';
        chatList.build();
        _$failedField = 'chatHistory';
        chatHistory.build();
        _$failedField = 'visitorChatHistory';
        visitorChatHistory.build();
        _$failedField = 'visitorChatHistoryApi';
        visitorChatHistoryApi.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
