// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_control_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VoiceControlState extends VoiceControlState {
  @override
  final bool isVoiceControlScreenActive;
  @override
  final bool isListening;
  @override
  final bool isLoading;
  @override
  final bool isPermissionAvailable;
  @override
  final bool speakerStatus;
  @override
  final bool isVoiceRecording;
  @override
  final bool chatUpdate;
  @override
  final String? sayingWords;
  @override
  final bool isTyping;
  @override
  final String? typingCommand;
  @override
  final String recordingPath;
  @override
  final List<ChatModel> chatData;
  @override
  final BuiltList<ListingViewModel>? listingDevices;
  @override
  final ApiState<void> getAiResponseApi;
  @override
  final String? statusMessage;

  factory _$VoiceControlState(
          [void Function(VoiceControlStateBuilder)? updates]) =>
      (VoiceControlStateBuilder()..update(updates))._build();

  _$VoiceControlState._(
      {required this.isVoiceControlScreenActive,
      required this.isListening,
      required this.isLoading,
      required this.isPermissionAvailable,
      required this.speakerStatus,
      required this.isVoiceRecording,
      required this.chatUpdate,
      this.sayingWords,
      required this.isTyping,
      this.typingCommand,
      required this.recordingPath,
      required this.chatData,
      this.listingDevices,
      required this.getAiResponseApi,
      this.statusMessage})
      : super._();
  @override
  VoiceControlState rebuild(void Function(VoiceControlStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VoiceControlStateBuilder toBuilder() =>
      VoiceControlStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VoiceControlState &&
        isVoiceControlScreenActive == other.isVoiceControlScreenActive &&
        isListening == other.isListening &&
        isLoading == other.isLoading &&
        isPermissionAvailable == other.isPermissionAvailable &&
        speakerStatus == other.speakerStatus &&
        isVoiceRecording == other.isVoiceRecording &&
        chatUpdate == other.chatUpdate &&
        sayingWords == other.sayingWords &&
        isTyping == other.isTyping &&
        typingCommand == other.typingCommand &&
        recordingPath == other.recordingPath &&
        chatData == other.chatData &&
        listingDevices == other.listingDevices &&
        getAiResponseApi == other.getAiResponseApi &&
        statusMessage == other.statusMessage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isVoiceControlScreenActive.hashCode);
    _$hash = $jc(_$hash, isListening.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, isPermissionAvailable.hashCode);
    _$hash = $jc(_$hash, speakerStatus.hashCode);
    _$hash = $jc(_$hash, isVoiceRecording.hashCode);
    _$hash = $jc(_$hash, chatUpdate.hashCode);
    _$hash = $jc(_$hash, sayingWords.hashCode);
    _$hash = $jc(_$hash, isTyping.hashCode);
    _$hash = $jc(_$hash, typingCommand.hashCode);
    _$hash = $jc(_$hash, recordingPath.hashCode);
    _$hash = $jc(_$hash, chatData.hashCode);
    _$hash = $jc(_$hash, listingDevices.hashCode);
    _$hash = $jc(_$hash, getAiResponseApi.hashCode);
    _$hash = $jc(_$hash, statusMessage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VoiceControlState')
          ..add('isVoiceControlScreenActive', isVoiceControlScreenActive)
          ..add('isListening', isListening)
          ..add('isLoading', isLoading)
          ..add('isPermissionAvailable', isPermissionAvailable)
          ..add('speakerStatus', speakerStatus)
          ..add('isVoiceRecording', isVoiceRecording)
          ..add('chatUpdate', chatUpdate)
          ..add('sayingWords', sayingWords)
          ..add('isTyping', isTyping)
          ..add('typingCommand', typingCommand)
          ..add('recordingPath', recordingPath)
          ..add('chatData', chatData)
          ..add('listingDevices', listingDevices)
          ..add('getAiResponseApi', getAiResponseApi)
          ..add('statusMessage', statusMessage))
        .toString();
  }
}

class VoiceControlStateBuilder
    implements Builder<VoiceControlState, VoiceControlStateBuilder> {
  _$VoiceControlState? _$v;

  bool? _isVoiceControlScreenActive;
  bool? get isVoiceControlScreenActive => _$this._isVoiceControlScreenActive;
  set isVoiceControlScreenActive(bool? isVoiceControlScreenActive) =>
      _$this._isVoiceControlScreenActive = isVoiceControlScreenActive;

  bool? _isListening;
  bool? get isListening => _$this._isListening;
  set isListening(bool? isListening) => _$this._isListening = isListening;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _isPermissionAvailable;
  bool? get isPermissionAvailable => _$this._isPermissionAvailable;
  set isPermissionAvailable(bool? isPermissionAvailable) =>
      _$this._isPermissionAvailable = isPermissionAvailable;

  bool? _speakerStatus;
  bool? get speakerStatus => _$this._speakerStatus;
  set speakerStatus(bool? speakerStatus) =>
      _$this._speakerStatus = speakerStatus;

  bool? _isVoiceRecording;
  bool? get isVoiceRecording => _$this._isVoiceRecording;
  set isVoiceRecording(bool? isVoiceRecording) =>
      _$this._isVoiceRecording = isVoiceRecording;

  bool? _chatUpdate;
  bool? get chatUpdate => _$this._chatUpdate;
  set chatUpdate(bool? chatUpdate) => _$this._chatUpdate = chatUpdate;

  String? _sayingWords;
  String? get sayingWords => _$this._sayingWords;
  set sayingWords(String? sayingWords) => _$this._sayingWords = sayingWords;

  bool? _isTyping;
  bool? get isTyping => _$this._isTyping;
  set isTyping(bool? isTyping) => _$this._isTyping = isTyping;

  String? _typingCommand;
  String? get typingCommand => _$this._typingCommand;
  set typingCommand(String? typingCommand) =>
      _$this._typingCommand = typingCommand;

  String? _recordingPath;
  String? get recordingPath => _$this._recordingPath;
  set recordingPath(String? recordingPath) =>
      _$this._recordingPath = recordingPath;

  List<ChatModel>? _chatData;
  List<ChatModel>? get chatData => _$this._chatData;
  set chatData(List<ChatModel>? chatData) => _$this._chatData = chatData;

  ListBuilder<ListingViewModel>? _listingDevices;
  ListBuilder<ListingViewModel> get listingDevices =>
      _$this._listingDevices ??= ListBuilder<ListingViewModel>();
  set listingDevices(ListBuilder<ListingViewModel>? listingDevices) =>
      _$this._listingDevices = listingDevices;

  ApiStateBuilder<void>? _getAiResponseApi;
  ApiStateBuilder<void> get getAiResponseApi =>
      _$this._getAiResponseApi ??= ApiStateBuilder<void>();
  set getAiResponseApi(ApiStateBuilder<void>? getAiResponseApi) =>
      _$this._getAiResponseApi = getAiResponseApi;

  String? _statusMessage;
  String? get statusMessage => _$this._statusMessage;
  set statusMessage(String? statusMessage) =>
      _$this._statusMessage = statusMessage;

  VoiceControlStateBuilder() {
    VoiceControlState._initialize(this);
  }

  VoiceControlStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isVoiceControlScreenActive = $v.isVoiceControlScreenActive;
      _isListening = $v.isListening;
      _isLoading = $v.isLoading;
      _isPermissionAvailable = $v.isPermissionAvailable;
      _speakerStatus = $v.speakerStatus;
      _isVoiceRecording = $v.isVoiceRecording;
      _chatUpdate = $v.chatUpdate;
      _sayingWords = $v.sayingWords;
      _isTyping = $v.isTyping;
      _typingCommand = $v.typingCommand;
      _recordingPath = $v.recordingPath;
      _chatData = $v.chatData;
      _listingDevices = $v.listingDevices?.toBuilder();
      _getAiResponseApi = $v.getAiResponseApi.toBuilder();
      _statusMessage = $v.statusMessage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VoiceControlState other) {
    _$v = other as _$VoiceControlState;
  }

  @override
  void update(void Function(VoiceControlStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VoiceControlState build() => _build();

  _$VoiceControlState _build() {
    _$VoiceControlState _$result;
    try {
      _$result = _$v ??
          _$VoiceControlState._(
            isVoiceControlScreenActive: BuiltValueNullFieldError.checkNotNull(
                isVoiceControlScreenActive,
                r'VoiceControlState',
                'isVoiceControlScreenActive'),
            isListening: BuiltValueNullFieldError.checkNotNull(
                isListening, r'VoiceControlState', 'isListening'),
            isLoading: BuiltValueNullFieldError.checkNotNull(
                isLoading, r'VoiceControlState', 'isLoading'),
            isPermissionAvailable: BuiltValueNullFieldError.checkNotNull(
                isPermissionAvailable,
                r'VoiceControlState',
                'isPermissionAvailable'),
            speakerStatus: BuiltValueNullFieldError.checkNotNull(
                speakerStatus, r'VoiceControlState', 'speakerStatus'),
            isVoiceRecording: BuiltValueNullFieldError.checkNotNull(
                isVoiceRecording, r'VoiceControlState', 'isVoiceRecording'),
            chatUpdate: BuiltValueNullFieldError.checkNotNull(
                chatUpdate, r'VoiceControlState', 'chatUpdate'),
            sayingWords: sayingWords,
            isTyping: BuiltValueNullFieldError.checkNotNull(
                isTyping, r'VoiceControlState', 'isTyping'),
            typingCommand: typingCommand,
            recordingPath: BuiltValueNullFieldError.checkNotNull(
                recordingPath, r'VoiceControlState', 'recordingPath'),
            chatData: BuiltValueNullFieldError.checkNotNull(
                chatData, r'VoiceControlState', 'chatData'),
            listingDevices: _listingDevices?.build(),
            getAiResponseApi: getAiResponseApi.build(),
            statusMessage: statusMessage,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'listingDevices';
        _listingDevices?.build();
        _$failedField = 'getAiResponseApi';
        getAiResponseApi.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VoiceControlState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
