// ignore_for_file: type=lint, unused_element

part of 'chat_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class ChatBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<ChatState>? buildWhen;
  final BlocWidgetBuilder<ChatState> builder;

  const ChatBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class ChatBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<ChatState, T> selector;
  final Widget Function(T state) builder;
  final ChatBloc? bloc;

  const ChatBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static ChatBlocSelector<bool> isChatScreenActive({
    final Key? key,
    required Widget Function(bool isChatScreenActive) builder,
    final ChatBloc? bloc,
  }) {
    return ChatBlocSelector(
      key: key,
      selector: (state) => state.isChatScreenActive,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChatBlocSelector<bool> isDoorbellTyping({
    final Key? key,
    required Widget Function(bool isDoorbellTyping) builder,
    final ChatBloc? bloc,
  }) {
    return ChatBlocSelector(
      key: key,
      selector: (state) => state.isDoorbellTyping,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChatBlocSelector<bool> isAdminTyping({
    final Key? key,
    required Widget Function(bool isAdminTyping) builder,
    final ChatBloc? bloc,
  }) {
    return ChatBlocSelector(
      key: key,
      selector: (state) => state.isAdminTyping,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChatBlocSelector<bool> firstMessageSent({
    final Key? key,
    required Widget Function(bool firstMessageSent) builder,
    final ChatBloc? bloc,
  }) {
    return ChatBlocSelector(
      key: key,
      selector: (state) => state.firstMessageSent,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChatBlocSelector<int?> notificationId({
    final Key? key,
    required Widget Function(int? notificationId) builder,
    final ChatBloc? bloc,
  }) {
    return ChatBlocSelector(
      key: key,
      selector: (state) => state.notificationId,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChatBlocSelector<int> notificationLocationId({
    final Key? key,
    required Widget Function(int notificationLocationId) builder,
    final ChatBloc? bloc,
  }) {
    return ChatBlocSelector(
      key: key,
      selector: (state) => state.notificationLocationId,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChatBlocSelector<String> chatMessage({
    final Key? key,
    required Widget Function(String chatMessage) builder,
    final ChatBloc? bloc,
  }) {
    return ChatBlocSelector(
      key: key,
      selector: (state) => state.chatMessage,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChatBlocSelector<bool> isDoorbellBusy({
    final Key? key,
    required Widget Function(bool isDoorbellBusy) builder,
    final ChatBloc? bloc,
  }) {
    return ChatBlocSelector(
      key: key,
      selector: (state) => state.isDoorbellBusy,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChatBlocSelector<BuiltList<TemporaryChatModel>> chatList({
    final Key? key,
    required Widget Function(BuiltList<TemporaryChatModel> chatList) builder,
    final ChatBloc? bloc,
  }) {
    return ChatBlocSelector(
      key: key,
      selector: (state) => state.chatList,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChatBlocSelector<BuiltList<Map<String, dynamic>>> chatHistory({
    final Key? key,
    required Widget Function(BuiltList<Map<String, dynamic>> chatHistory)
        builder,
    final ChatBloc? bloc,
  }) {
    return ChatBlocSelector(
      key: key,
      selector: (state) => state.chatHistory,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChatBlocSelector<BuiltList<VisitorChatModel>> visitorChatHistory({
    final Key? key,
    required Widget Function(BuiltList<VisitorChatModel> visitorChatHistory)
        builder,
    final ChatBloc? bloc,
  }) {
    return ChatBlocSelector(
      key: key,
      selector: (state) => state.visitorChatHistory,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChatBlocSelector<ApiState<void>> visitorChatHistoryApi({
    final Key? key,
    required Widget Function(ApiState<void> visitorChatHistoryApi) builder,
    final ChatBloc? bloc,
  }) {
    return ChatBlocSelector(
      key: key,
      selector: (state) => state.visitorChatHistoryApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<ChatBloc, ChatState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _ChatBlocMixin on Cubit<ChatState> {
  @mustCallSuper
  void updateIsChatScreenActive(final bool isChatScreenActive) {
    if (this.state.isChatScreenActive == isChatScreenActive) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isChatScreenActive = isChatScreenActive));

    $onUpdateIsChatScreenActive();
  }

  @protected
  void $onUpdateIsChatScreenActive() {}

  @mustCallSuper
  void updateIsDoorbellTyping(final bool isDoorbellTyping) {
    if (this.state.isDoorbellTyping == isDoorbellTyping) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.isDoorbellTyping = isDoorbellTyping));

    $onUpdateIsDoorbellTyping();
  }

  @protected
  void $onUpdateIsDoorbellTyping() {}

  @mustCallSuper
  void updateIsAdminTyping(final bool isAdminTyping) {
    if (this.state.isAdminTyping == isAdminTyping) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isAdminTyping = isAdminTyping));

    $onUpdateIsAdminTyping();
  }

  @protected
  void $onUpdateIsAdminTyping() {}

  @mustCallSuper
  void updateFirstMessageSent(final bool firstMessageSent) {
    if (this.state.firstMessageSent == firstMessageSent) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.firstMessageSent = firstMessageSent));

    $onUpdateFirstMessageSent();
  }

  @protected
  void $onUpdateFirstMessageSent() {}

  @mustCallSuper
  void updateNotificationId(final int? notificationId) {
    if (this.state.notificationId == notificationId) {
      return;
    }

    emit(this.state.rebuild((final b) => b.notificationId = notificationId));

    $onUpdateNotificationId();
  }

  @protected
  void $onUpdateNotificationId() {}

  @mustCallSuper
  void updateNotificationLocationId(final int notificationLocationId) {
    if (this.state.notificationLocationId == notificationLocationId) {
      return;
    }

    emit(this.state.rebuild(
        (final b) => b.notificationLocationId = notificationLocationId));

    $onUpdateNotificationLocationId();
  }

  @protected
  void $onUpdateNotificationLocationId() {}

  @mustCallSuper
  void updateChatMessage(final String chatMessage) {
    if (this.state.chatMessage == chatMessage) {
      return;
    }

    emit(this.state.rebuild((final b) => b.chatMessage = chatMessage));

    $onUpdateChatMessage();
  }

  @protected
  void $onUpdateChatMessage() {}

  @mustCallSuper
  void updateIsDoorbellBusy(final bool isDoorbellBusy) {
    if (this.state.isDoorbellBusy == isDoorbellBusy) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isDoorbellBusy = isDoorbellBusy));

    $onUpdateIsDoorbellBusy();
  }

  @protected
  void $onUpdateIsDoorbellBusy() {}

  @mustCallSuper
  void updateChatList(final BuiltList<TemporaryChatModel> chatList) {
    if (this.state.chatList == chatList) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.chatList.replace(chatList);
    }));

    $onUpdateChatList();
  }

  @protected
  void $onUpdateChatList() {}

  @mustCallSuper
  void updateChatHistory(final BuiltList<Map<String, dynamic>> chatHistory) {
    if (this.state.chatHistory == chatHistory) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.chatHistory.replace(chatHistory);
    }));

    $onUpdateChatHistory();
  }

  @protected
  void $onUpdateChatHistory() {}

  @mustCallSuper
  void updateVisitorChatHistory(
      final BuiltList<VisitorChatModel> visitorChatHistory) {
    if (this.state.visitorChatHistory == visitorChatHistory) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.visitorChatHistory.replace(visitorChatHistory);
    }));

    $onUpdateVisitorChatHistory();
  }

  @protected
  void $onUpdateVisitorChatHistory() {}
}
