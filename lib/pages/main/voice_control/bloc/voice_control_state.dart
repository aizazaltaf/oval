import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/voice_control/model/chat_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'voice_control_state.g.dart';

abstract class VoiceControlState
    implements Built<VoiceControlState, VoiceControlStateBuilder> {
  factory VoiceControlState([
    final void Function(VoiceControlStateBuilder) updates,
  ]) = _$VoiceControlState;

  VoiceControlState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final VoiceControlStateBuilder b) => b
    ..isVoiceControlScreenActive = true
    ..speakerStatus = true
    ..isVoiceRecording = false
    ..chatUpdate = false
    ..isTyping = false
    ..recordingPath = "voice_control_recording_file.mp4"
    ..isPermissionAvailable = false
    ..isLoading = false
    ..isListening = false
    ..chatData = [];

  @BlocUpdateField()
  bool get isVoiceControlScreenActive;
  @BlocUpdateField()
  bool get isListening;
  @BlocUpdateField()
  bool get isLoading;
  @BlocUpdateField()
  bool get isPermissionAvailable;
  @BlocUpdateField()
  bool get speakerStatus;
  @BlocUpdateField()
  bool get isVoiceRecording;
  @BlocUpdateField()
  bool get chatUpdate;

  @BlocUpdateField()
  String? get sayingWords;
  @BlocUpdateField()
  bool get isTyping;
  @BlocUpdateField()
  String? get typingCommand;

  @BlocUpdateField()
  String get recordingPath;
  @BlocUpdateField()
  List<ChatModel> get chatData;
  @BlocUpdateField()
  BuiltList<ListingViewModel>? get listingDevices;

  ApiState<void> get getAiResponseApi;

  String? get statusMessage;
}
