// ignore_for_file: type=lint, unused_element

part of 'voice_control_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class VoiceControlBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<VoiceControlState>? buildWhen;
  final BlocWidgetBuilder<VoiceControlState> builder;

  const VoiceControlBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<VoiceControlBloc, VoiceControlState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class VoiceControlBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<VoiceControlState, T> selector;
  final Widget Function(T state) builder;
  final VoiceControlBloc? bloc;

  const VoiceControlBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static VoiceControlBlocSelector<bool> isVoiceControlScreenActive({
    final Key? key,
    required Widget Function(bool isVoiceControlScreenActive) builder,
    final VoiceControlBloc? bloc,
  }) {
    return VoiceControlBlocSelector(
      key: key,
      selector: (state) => state.isVoiceControlScreenActive,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoiceControlBlocSelector<bool> isListening({
    final Key? key,
    required Widget Function(bool isListening) builder,
    final VoiceControlBloc? bloc,
  }) {
    return VoiceControlBlocSelector(
      key: key,
      selector: (state) => state.isListening,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoiceControlBlocSelector<bool> isLoading({
    final Key? key,
    required Widget Function(bool isLoading) builder,
    final VoiceControlBloc? bloc,
  }) {
    return VoiceControlBlocSelector(
      key: key,
      selector: (state) => state.isLoading,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoiceControlBlocSelector<bool> isPermissionAvailable({
    final Key? key,
    required Widget Function(bool isPermissionAvailable) builder,
    final VoiceControlBloc? bloc,
  }) {
    return VoiceControlBlocSelector(
      key: key,
      selector: (state) => state.isPermissionAvailable,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoiceControlBlocSelector<bool> speakerStatus({
    final Key? key,
    required Widget Function(bool speakerStatus) builder,
    final VoiceControlBloc? bloc,
  }) {
    return VoiceControlBlocSelector(
      key: key,
      selector: (state) => state.speakerStatus,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoiceControlBlocSelector<bool> isVoiceRecording({
    final Key? key,
    required Widget Function(bool isVoiceRecording) builder,
    final VoiceControlBloc? bloc,
  }) {
    return VoiceControlBlocSelector(
      key: key,
      selector: (state) => state.isVoiceRecording,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoiceControlBlocSelector<bool> chatUpdate({
    final Key? key,
    required Widget Function(bool chatUpdate) builder,
    final VoiceControlBloc? bloc,
  }) {
    return VoiceControlBlocSelector(
      key: key,
      selector: (state) => state.chatUpdate,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoiceControlBlocSelector<String?> sayingWords({
    final Key? key,
    required Widget Function(String? sayingWords) builder,
    final VoiceControlBloc? bloc,
  }) {
    return VoiceControlBlocSelector(
      key: key,
      selector: (state) => state.sayingWords,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoiceControlBlocSelector<bool> isTyping({
    final Key? key,
    required Widget Function(bool isTyping) builder,
    final VoiceControlBloc? bloc,
  }) {
    return VoiceControlBlocSelector(
      key: key,
      selector: (state) => state.isTyping,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoiceControlBlocSelector<String?> typingCommand({
    final Key? key,
    required Widget Function(String? typingCommand) builder,
    final VoiceControlBloc? bloc,
  }) {
    return VoiceControlBlocSelector(
      key: key,
      selector: (state) => state.typingCommand,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoiceControlBlocSelector<String> recordingPath({
    final Key? key,
    required Widget Function(String recordingPath) builder,
    final VoiceControlBloc? bloc,
  }) {
    return VoiceControlBlocSelector(
      key: key,
      selector: (state) => state.recordingPath,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoiceControlBlocSelector<List<ChatModel>> chatData({
    final Key? key,
    required Widget Function(List<ChatModel> chatData) builder,
    final VoiceControlBloc? bloc,
  }) {
    return VoiceControlBlocSelector(
      key: key,
      selector: (state) => state.chatData,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoiceControlBlocSelector<BuiltList<ListingViewModel>?> listingDevices({
    final Key? key,
    required Widget Function(BuiltList<ListingViewModel>? listingDevices)
        builder,
    final VoiceControlBloc? bloc,
  }) {
    return VoiceControlBlocSelector(
      key: key,
      selector: (state) => state.listingDevices,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoiceControlBlocSelector<ApiState<void>> getAiResponseApi({
    final Key? key,
    required Widget Function(ApiState<void> getAiResponseApi) builder,
    final VoiceControlBloc? bloc,
  }) {
    return VoiceControlBlocSelector(
      key: key,
      selector: (state) => state.getAiResponseApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoiceControlBlocSelector<String?> statusMessage({
    final Key? key,
    required Widget Function(String? statusMessage) builder,
    final VoiceControlBloc? bloc,
  }) {
    return VoiceControlBlocSelector(
      key: key,
      selector: (state) => state.statusMessage,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<VoiceControlBloc, VoiceControlState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _VoiceControlBlocMixin on Cubit<VoiceControlState> {
  @mustCallSuper
  void updateIsVoiceControlScreenActive(final bool isVoiceControlScreenActive) {
    if (this.state.isVoiceControlScreenActive == isVoiceControlScreenActive) {
      return;
    }

    emit(this.state.rebuild((final b) =>
        b.isVoiceControlScreenActive = isVoiceControlScreenActive));

    $onUpdateIsVoiceControlScreenActive();
  }

  @protected
  void $onUpdateIsVoiceControlScreenActive() {}

  @mustCallSuper
  void updateIsListening(final bool isListening) {
    if (this.state.isListening == isListening) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isListening = isListening));

    $onUpdateIsListening();
  }

  @protected
  void $onUpdateIsListening() {}

  @mustCallSuper
  void updateIsLoading(final bool isLoading) {
    if (this.state.isLoading == isLoading) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isLoading = isLoading));

    $onUpdateIsLoading();
  }

  @protected
  void $onUpdateIsLoading() {}

  @mustCallSuper
  void updateIsPermissionAvailable(final bool isPermissionAvailable) {
    if (this.state.isPermissionAvailable == isPermissionAvailable) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isPermissionAvailable = isPermissionAvailable));

    $onUpdateIsPermissionAvailable();
  }

  @protected
  void $onUpdateIsPermissionAvailable() {}

  @mustCallSuper
  void updateSpeakerStatus(final bool speakerStatus) {
    if (this.state.speakerStatus == speakerStatus) {
      return;
    }

    emit(this.state.rebuild((final b) => b.speakerStatus = speakerStatus));

    $onUpdateSpeakerStatus();
  }

  @protected
  void $onUpdateSpeakerStatus() {}

  @mustCallSuper
  void updateIsVoiceRecording(final bool isVoiceRecording) {
    if (this.state.isVoiceRecording == isVoiceRecording) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.isVoiceRecording = isVoiceRecording));

    $onUpdateIsVoiceRecording();
  }

  @protected
  void $onUpdateIsVoiceRecording() {}

  @mustCallSuper
  void updateChatUpdate(final bool chatUpdate) {
    if (this.state.chatUpdate == chatUpdate) {
      return;
    }

    emit(this.state.rebuild((final b) => b.chatUpdate = chatUpdate));

    $onUpdateChatUpdate();
  }

  @protected
  void $onUpdateChatUpdate() {}

  @mustCallSuper
  void updateSayingWords(final String? sayingWords) {
    if (this.state.sayingWords == sayingWords) {
      return;
    }

    emit(this.state.rebuild((final b) => b.sayingWords = sayingWords));

    $onUpdateSayingWords();
  }

  @protected
  void $onUpdateSayingWords() {}

  @mustCallSuper
  void updateIsTyping(final bool isTyping) {
    if (this.state.isTyping == isTyping) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isTyping = isTyping));

    $onUpdateIsTyping();
  }

  @protected
  void $onUpdateIsTyping() {}

  @mustCallSuper
  void updateTypingCommand(final String? typingCommand) {
    if (this.state.typingCommand == typingCommand) {
      return;
    }

    emit(this.state.rebuild((final b) => b.typingCommand = typingCommand));

    $onUpdateTypingCommand();
  }

  @protected
  void $onUpdateTypingCommand() {}

  @mustCallSuper
  void updateRecordingPath(final String recordingPath) {
    if (this.state.recordingPath == recordingPath) {
      return;
    }

    emit(this.state.rebuild((final b) => b.recordingPath = recordingPath));

    $onUpdateRecordingPath();
  }

  @protected
  void $onUpdateRecordingPath() {}

  @mustCallSuper
  void updateChatData(final List<ChatModel> chatData) {
    if (this.state.chatData == chatData) {
      return;
    }

    emit(this.state.rebuild((final b) => b.chatData = chatData));

    $onUpdateChatData();
  }

  @protected
  void $onUpdateChatData() {}

  @mustCallSuper
  void updateListingDevices(final BuiltList<ListingViewModel>? listingDevices) {
    if (this.state.listingDevices == listingDevices) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (listingDevices == null)
        b.listingDevices = null;
      else
        b.listingDevices.replace(listingDevices);
    }));

    $onUpdateListingDevices();
  }

  @protected
  void $onUpdateListingDevices() {}
}
