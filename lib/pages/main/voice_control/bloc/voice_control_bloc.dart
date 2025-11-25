import 'dart:convert';
import 'dart:io';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/core/config.dart';
import 'package:admin/core/speech_recognition.dart';
import 'package:admin/core/voice_command_handler.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/main.dart';
import 'package:admin/models/enums/environment.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_state.dart';
import 'package:admin/pages/main/voice_control/model/chat_model.dart';
import 'package:admin/pages/main/voice_control/model/status_message_model.dart';
import 'package:admin/pages/main/voice_control/model/voice_control_model.dart';
import 'package:admin/pages/main/voip/components/speaker.dart';
import 'package:admin/pages/themes/create_ai_theme.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/utils/dio.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wake_word/instance_config.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'voice_control_bloc.bloc.g.dart';

final _logger = Logger('voice_control_bloc.dart');

@BlocGen()
class VoiceControlBloc
    extends BVCubit<VoiceControlState, VoiceControlStateBuilder>
    with _VoiceControlBlocMixin, VoiceCommandHandler {
  VoiceControlBloc() : super(VoiceControlState()) {
    initializeSpeech();
    // Check speaker status after a delay to ensure proper initialization
    Future.delayed(const Duration(seconds: 3), () {
      unawaited(_initializeSpeakerStatus());
    });
  }
  factory VoiceControlBloc.of(final BuildContext context) =>
      BlocProvider.of<VoiceControlBloc>(context);

  Future<void> initSpeech(BuildContext context) async {
    unawaited(requestAudioPermissions(context));

    await askPermission(context);

    // SpeechRecognition.instance.initSpeechState(context);
  }

  Future<void> initializeSpeech() async {
    try {
      if (!singletonBloc.speech.isAvailable) {
        _logger.fine("speech initialization");
        final bool isAvailable = await singletonBloc.speech.initialize(

            // onError: (error) {
            //   if (error.errorMsg == "error_no_match") {
            //     Future.delayed(
            //       const Duration(seconds: 3),
            //       useModel.startListening,
            //     );
            //     _logger.fine("error is $error");
            //     unawaited(
            //       singletonBloc.textToSpeech.speak(
            //         "You haven't asked anything.",
            //         focus: true,
            //       ),
            //     );
            //   }
            //   SpeechRecognition.instance.isDetected = false;
            //   statusChange();
            // },
            // onStatus: (status) {
            //   _logger.fine("status is $status");
            //   if (status == "done") {
            //     SpeechRecognition.instance.isDetected = false;
            //     updateIsLoading(true);
            //     updateIsVoiceRecording(false);
            //   } else if (status == "listening") {
            //     updateIsVoiceRecording(true);
            //   }
            // },
            );
        _logger.fine("initialize is $isAvailable");
      }
    } catch (e) {
      _logger.fine("error is $e");
      SpeechRecognition.instance.isDetected = false;
      statusChange();
    }
  }

  void statusChange({bool value = false}) {
    // _logger.fine("speech is $speech");
    // unawaited(speech!.cancel());
    SpeechRecognition.instance.isDetected = false;
    _logger.fine(
      "${state.isListening} ${state.isVoiceRecording} ${state.isLoading}",
    );

    updateIsVoiceRecording(false);
    updateIsLoading(false);
    updateSayingWords(null);
    updateIsListening(false);
    _logger.fine(
      "after ${state.isListening} ${state.isVoiceRecording} ${state.isLoading}",
    );
  }

  Future<void> requestAudioPermissions(BuildContext context) async {
    await Permission.microphone.request();
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }

    if (status.isGranted) {
      await initializeKeywordDetection(context.mounted ? context : context);
    } else {
      if (Platform.isAndroid) {
        unawaited(openSettings());
      }
    }
  }

  Future<void> openSettings() async {
    if (await Permission.microphone.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> setSpeakerStatus(bool status) async {
    try {
      if (Platform.isAndroid) {
        unawaited(Helper.setSpeakerphoneOn(status));
        updateSpeakerStatus(status);
      } else {
        unawaited(SpeakerphoneController.setSpeakerphoneOn(status));
        await Future.delayed(const Duration(milliseconds: 500));
        await getSpeakerStatus();
      }
      // Wait a bit before checking the status to ensure it's been applied
    } catch (e) {
      _logger.severe("Error setting speaker status: $e");
    }
  }

  // final List<InstanceConfig> instanceConfigs = [
  //   InstanceConfig(
  //     id: 'hey_oval_model_28_02072025',
  //     modelName: 'hey_oval_model_28_02072025.onnx',
  //     threshold: 0.9999,
  //     bufferCnt: 5,
  //   ),
  // ];
  final MultiInstanceConfig multiInstanceConfig = MultiInstanceConfig(
    id: 'hey_oval_model_28_02072025',
    modelNames: [
      'hey_oval_model_28_02072025.onnx',
    ],
    thresholds: [0.9999],
    bufferCnts: [5],
    msBetweenCallback: [5000],
  );

  int count = 0;

  Future<void> speakFixer(String text) async {
    await singletonBloc.textToSpeech.stop();
    // await singletonBloc.textToSpeech.setVolume(1);
    //
    // await singletonBloc.textToSpeech.setSpeechRate(0.4);
    // await singletonBloc.textToSpeech.autoStopSharedSession(false);
    if (Platform.isIOS) {
      await SpeakerphoneController.setSpeakerphoneOn(true);
    }
    await Future.delayed(const Duration(milliseconds: 500));
    await singletonBloc.textToSpeech.setVolume(1);
    await singletonBloc.textToSpeech.speak(text, focus: true);
    await singletonBloc.textToSpeech.awaitSpeakCompletion(
      true,
    ); // wait before next
  }

  bool isWordDetected = false;

  bool isDetected = false;
  Timer? detectedTimer;

  ScrollController scrollController = ScrollController();

  int debounce = 0;
  Timer? wakeWordTimer;

  Future<void> askPermission(context) async {
    await checkAndRequestMicrophonePermission(context);
  }

  Future<void> reinitializeWakeWord(BuildContext context) async {
    if (Platform.isAndroid) {
      await initializeKeywordDetection(
        context.mounted ? context : context,
      );
    } else {
      await singletonBloc.useModel.startListening();
    }
  }

  bool isListened = false;
  Future<void> initializeKeywordDetection(BuildContext context) async {
    try {
      final key = await apiService.getKeyForDaVoice();
      await singletonBloc.useModel.setKeywordDetectionLicense(
        key ??
            "MTc1Nzg4MzYwMDAwMA==-lULiXsf2XwqYXN5iJ8XddZTWT/r0T14dWX6zhyWGGO4=",
      );
      void callback(Map<String, dynamic> phrase) {
        onWakeWordDetected(phrase, context);
      }

      await singletonBloc.useModel
          .addInstanceMulti(multiInstanceConfig, callback);
      _logger.fine("After useModel.loadModel:");
    } catch (e) {
      _logger.fine("Error initializing keyword detection: $e");
    }
  }

  Future<void> onWakeWordDetected(
    Map<String, dynamic> wakeWord,
    BuildContext context,
  ) async {
    await singletonBloc.removeInstance();
    await Future.delayed(const Duration(milliseconds: 100));
    _logger.fine("onWakeWordDetected(): $wakeWord");
    await Future.delayed(const Duration(milliseconds: 100));
    await singletonBloc.textToSpeech.speak("Listening", focus: true);
    updateIsListening(true);
    unawaited(record(context.mounted ? context : context, fromUseModal: true));
    updateIsVoiceRecording(true);
    isDetected = true;
  }

  bool needToUpdate = true;
  bool micActive = false;

  Timer? _debounce;
  Timer? callBackTimer;
  void callBacks(BuildContext context) {
    callBackTimer?.cancel();
    callBackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (Platform.isAndroid) {
        if (timer.tick == 7) {
          func(context);
        }
      } else {
        if (timer.tick == 5) {
          func(context);
        }
      }
    });
  }

  Future<void> func(context) async {
    if (needToUpdate && singletonBloc.speech.lastRecognizedWords.isEmpty) {
      await singletonBloc.removeInstance();
      if (Platform.isAndroid) {
        unawaited(
          reinitializeWakeWord(
            context.mounted ? context : context,
          ),
        );
      } else {
        Future.delayed(const Duration(seconds: 3), () async {
          unawaited(
            reinitializeWakeWord(
              context.mounted ? context : context,
            ),
          );
        });
      }
      Future.delayed(const Duration(seconds: 1), () {
        statusChange();
        unawaited(speakVoice("You haven't asked anything."));
      });
      // } else {
      //   Future.delayed(const Duration(seconds: 3), () async {
      //     await initializeKeywordDetection(
      //       context.mounted ? context : context,
      //     );
      //   });
      // }
      unawaited(singletonBloc.speech.stop());
    }
  }

  Future<void> recordTypeText(
    BuildContext context, {
    required String typedText,
    bool fromUseModal = false,
  }) async {
    isListened = false;
    _logger.fine("Typed Command: $typedText");
    String text = typedText.toLowerCase().replaceAll("cullah", "color");
    text = text.toLowerCase().replaceAll("life x", "lifx");
    isListened = true;
    SpeechRecognition.instance.isDetected = false;
    updateIsLoading(true);
    updateIsVoiceRecording(false);
    _startStatusMessageTimer();
    // _logger.fine("final result is $typedText");
    unawaited(
      stopListening(
        context.mounted ? context : context,
        text,
        fromUseModal: fromUseModal,
      ),
    );
  }

  String _mergeWithoutDuplicates(String prevPart, String nextPart) {
    final String prev = prevPart.trim();
    final String next = nextPart.trim();

    if (prev.isEmpty) {
      return next;
    }

    final prevWords = prev.split(' ');
    final nextWords = next.split(' ');

    // Find overlap (suffix of prev == prefix of next)
    int overlap = 0;
    for (int i = 1; i <= prevWords.length && i <= nextWords.length; i++) {
      if (prevWords.sublist(prevWords.length - i).join(' ') ==
          nextWords.sublist(0, i).join(' ')) {
        overlap = i;
      }
    }

    // Merge: keep prev + only the non-overlapping part of next
    return (prevWords + nextWords.sublist(overlap)).join(' ').trim();
  }

  String _collectedText = '';

  Future<void> record(
    BuildContext context, {
    bool fromUseModal = false,
  }) async {
    _collectedText = ''; // reset at start
    isListened = false;
    needToUpdate = true;
    if (context.mounted) {
      callBacks(context);
    } else {
      callBacks(navigatorKeyMain.currentContext!);
    }
    unawaited(
      singletonBloc.speech.listen(
        listenOptions: stt.SpeechListenOptions(
          pauseFor: const Duration(seconds: 5),
        ),
        onResult: (result) {
          if (callBackTimer != null) {
            callBackTimer?.cancel();
            callBackTimer = null;
          }
          needToUpdate = false;

          // Append instead of overwrite
          if (Platform.isAndroid) {
            _collectedText =
                _mergeWithoutDuplicates(_collectedText, result.recognizedWords);
          } else {
            _collectedText = result.recognizedWords;
          }

          _logger.fine("result is: $_collectedText");
          updateSayingWords(_collectedText);

          _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 2500), () async {
            callBackTimer?.cancel();
            _logger.fine("finalResult is finalResult is ${result.finalResult}");

            needToUpdate = true;
            if (!isListened) {
              String text =
                  _collectedText.toLowerCase().replaceAll("cullah", "color");
              text = text.toLowerCase().replaceAll("life x", "lifx");
              if (_collectedText.isNotEmpty) {
                await singletonBloc.speech.stop();
                unawaited(singletonBloc.speech.cancel());
                _debounce?.cancel();
                isListened = true;
                SpeechRecognition.instance.isDetected = false;
                updateIsLoading(true);
                updateIsVoiceRecording(false);
                _startStatusMessageTimer();
                _logger.fine("final result is: $text");

                unawaited(
                  stopListening(
                    context.mounted ? context : context,
                    text,
                    fromUseModal: fromUseModal,
                  ),
                );
              } else {
                statusChange();
                updateSayingWords(null);
                await singletonBloc.speech.stop();
              }
            } else {
              unawaited(reinitializeWakeWord(context));
              updateSayingWords(null);
              await singletonBloc.speech.stop();
            }
          });
        },
      ),
    );
  }

  // void onRecognizedWords(
  //   BuildContext context,
  //   bool fromUseModal,
  //   SpeechRecognitionResult result,
  // ) {
  //   _logger.fine("result is ${result.recognizedWords}");
  //   _debounce?.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 2500), () async {
  //     if (!isListened) {
  //       isListened = true;
  //       Future.delayed(const Duration(seconds: 4), () {
  //         isListened = false;
  //       });
  //       unawaited(speech!.stop());
  //       unawaited(speech!.cancel());
  //       unawaited(speech2!.stop());
  //       unawaited(speech2!.cancel());
  //       _debounce?.cancel();
  //
  //       _logger.fine("final result is ${result.recognizedWords}");
  //
  //       if (result.recognizedWords.isNotEmpty) {
  //         SpeechRecognition.instance.isDetected = false;
  //         updateIsLoading(true);
  //         updateIsVoiceRecording(false);
  //         unawaited(
  //           stopListening(
  //             context,
  //             result.recognizedWords,
  //             fromUseModal: fromUseModal,
  //           ),
  //         );
  //       } else {
  //         _debounce = null;
  //         unawaited(speakVoice("You haven't asked anything"));
  //         isWordDetected = false;
  //         statusChange();
  //
  //         SpeechRecognition.instance.isDetected = false;
  //         Future.delayed(const Duration(seconds: 2), () {
  //           if (fromUseModal) {
  //             if (!useModel!.isListening) {
  //               unawaited(useModel?.startListening());
  //             }
  //           }
  //         });
  //       }
  //     }
  //   });
  // }

  Timer? _statusMessageTimer;
  int _processingStartTime = 0;

  bool initial = false;
  bool midway = false;
  bool nearCompletion = false;
  bool fallback = false;
  void _startStatusMessageTimer() {
    _processingStartTime = DateTime.now().millisecondsSinceEpoch;
    _statusMessageTimer?.cancel();
    _statusMessageTimer = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) async {
      final elapsedSeconds =
          (DateTime.now().millisecondsSinceEpoch - _processingStartTime) ~/
              1000;

      if (elapsedSeconds == 2) {
        if (!initial) {
          initial = true;
          Future.delayed(const Duration(seconds: 1), () {
            if (scrollController.hasClients) {
              unawaited(
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.bounceIn,
                ),
              );
            }
          });
          updateStatusMessage(
            StatusMessageManager.getRandomMessage(StatusCategory.initial),
          );
          emit(
            state.rebuild(
              (b) => b
                ..chatData = List.of(b.chatData ?? [])
                ..chatData!.add(ChatModel(id: 0, text: state.statusMessage)),
            ),
          );
          await singletonBloc.textToSpeech.stop();
          await singletonBloc.textToSpeech
              .speak(state.statusMessage ?? "", focus: true);
        }
      } else if (elapsedSeconds == 7) {
        if (!midway) {
          midway = true;
          Future.delayed(const Duration(seconds: 1), () {
            if (scrollController.hasClients) {
              unawaited(
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.bounceIn,
                ),
              );
            }
          });
          updateStatusMessage(
            StatusMessageManager.getRandomMessage(StatusCategory.midway),
          );
          if (state.chatData.isNotEmpty) {
            if (state.chatData[state.chatData.length - 1].id == 0) {
              emit(
                state.rebuild(
                  (b) => b
                    ..chatData = List.of(b.chatData ?? [])
                    ..chatData?[state.chatData.length - 1] = ChatModel(
                      id: 0,
                      text: state.statusMessage,
                    ),
                ),
              );
            }
          }
          await singletonBloc.textToSpeech.stop();
          await singletonBloc.textToSpeech
              .speak(state.statusMessage ?? "", focus: true);
        }
      } else if (elapsedSeconds == 12) {
        if (!nearCompletion) {
          nearCompletion = true;
          Future.delayed(const Duration(seconds: 1), () {
            if (scrollController.hasClients) {
              unawaited(
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.bounceIn,
                ),
              );
            }
          });
          updateStatusMessage(
            StatusMessageManager.getRandomMessage(
              StatusCategory.nearCompletion,
            ),
          );
          if (state.chatData.isNotEmpty) {
            if (state.chatData[state.chatData.length - 1].id == 0) {
              emit(
                state.rebuild(
                  (b) => b
                    ..chatData = List.of(b.chatData ?? [])
                    ..chatData?[state.chatData.length - 1] = ChatModel(
                      id: 0,
                      text: state.statusMessage,
                    ),
                ),
              );
            }
          }
          await singletonBloc.textToSpeech.stop();
          await singletonBloc.textToSpeech
              .speak(state.statusMessage ?? "", focus: true);
        }
      } else if (elapsedSeconds == 17) {
        if (!fallback) {
          fallback = true;
          Future.delayed(const Duration(seconds: 1), () {
            if (scrollController.hasClients) {
              unawaited(
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.bounceIn,
                ),
              );
            }
          });
          updateStatusMessage(
            StatusMessageManager.getRandomMessage(StatusCategory.fallback),
          );
          if (state.chatData.isNotEmpty) {
            if (state.chatData[state.chatData.length - 1].id == 0) {
              emit(
                state.rebuild(
                  (b) => b
                    ..chatData = List.of(b.chatData ?? [])
                    ..chatData?[state.chatData.length - 1] = ChatModel(
                      id: 0,
                      text: state.statusMessage,
                    ),
                ),
              );
            }
          }
          await singletonBloc.textToSpeech.stop();
          await singletonBloc.textToSpeech
              .speak(state.statusMessage ?? "", focus: true);
        }
      }
    });
  }

  void _stopStatusMessageTimer() {
    initial = false;
    midway = false;
    nearCompletion = false;
    fallback = false;
    _statusMessageTimer?.cancel();
    _statusMessageTimer = null;
    updateStatusMessage(null);
  }

  void updateStatusMessage(String? message) {
    emit(state.rebuild((b) => b..statusMessage = message));
  }

  Future<void> speakVoice(String model) async {
    if (Platform.isIOS) {
      await speakFixer(model);
    } else {
      await singletonBloc.textToSpeech.stop();
      await singletonBloc.textToSpeech.speak(model, focus: true);
    }
  }

  void emptyResponse() {
    emit(state.rebuild((b) => b..getAiResponseApi = ApiStateBuilder()));
  }

  Future<void> getAiResponse(
    BuildContext context,
    String text, {
    bool fromUseModal = false,
  }) async {
    unawaited(setSpeakerStatus(true));
    await Future.delayed(const Duration(milliseconds: 100));
    return CubitUtils.makeApiCall<VoiceControlState, VoiceControlStateBuilder,
        void>(
      cubit: this,
      apiState: state.getAiResponseApi,
      updateApiState: (final b, final apiState) =>
          b.getAiResponseApi.replace(apiState),
      callApi: () async {
        await singletonBloc.textToSpeech.awaitSpeakCompletion(true);
        final result = await apiService.aiServerVoiceControl(text);
        if (Platform.isAndroid) {
          await singletonBloc.removeInstance();
          unawaited(
            reinitializeWakeWord(
              context.mounted ? context : context,
            ),
          );
        }
        await Future.delayed(const Duration(seconds: 1));
        _stopStatusMessageTimer();
        if (Platform.isIOS) {
          await singletonBloc.removeInstance();
          Future.delayed(const Duration(seconds: 3), () {
            unawaited(
              reinitializeWakeWord(
                context.mounted ? context : context,
              ),
            );
          });
        }
        await Future.delayed(const Duration(seconds: 1));
        updateIsListening(false);
        if (result == null) {
          Future.delayed(const Duration(seconds: 1), () {
            updateIsLoading(false);
          });
          updateSayingWords(null);
          SpeechRecognition().isDetected = false;
          if (state.chatData.isNotEmpty) {
            if (state.chatData[state.chatData.length - 1].id == 0) {
              emit(
                state.rebuild(
                  (b) => b
                    ..chatData = List.of(b.chatData ?? [])
                    ..chatData?[state.chatData.length - 1] = ChatModel(
                      id: 0,
                      text: "No response from server",
                    ),
                ),
              );
              unawaited(speakVoice("No response from server"));
            }
          } else {
            emit(
              state.rebuild(
                (b) => b
                  ..chatData = List.of(b.chatData ?? [])
                  ..chatData?.add(ChatModel(text: "No response from server")),
              ),
            );
            unawaited(speakVoice("No response from server"));
          }
          return;
        }

        if (result["error"] != null) {
          Future.delayed(const Duration(seconds: 1), () {
            updateIsLoading(false);
          });
          updateSayingWords(null);
          updateIsVoiceRecording(false);
          SpeechRecognition().isDetected = false;
          if (state.chatData.isNotEmpty) {
            if (state.chatData[state.chatData.length - 1].id == 0) {
              emit(
                state.rebuild(
                  (b) => b
                    ..chatData = List.of(b.chatData ?? [])
                    ..chatData?[state.chatData.length - 1] = ChatModel(
                      id: 0,
                      text:
                          "Unable to process your request. Please try again ${config.environment == Environment.test ? "${result["app_data"]["command"]}" : ""}",
                    ),
                ),
              );
              unawaited(
                speakVoice(
                  "Unable to process your request. Please try again ${config.environment == Environment.test ? "${result["app_data"]["command"]}" : ""}",
                ),
              );
            } else {
              emit(
                state.rebuild(
                  (b) => b
                    ..chatData = List.of(b.chatData ?? [])
                    ..chatData?.add(
                      ChatModel(
                        text:
                            "Unable to process your request. Please try again ${config.environment == Environment.test ? "${result["app_data"]["command"]}" : ""}",
                      ),
                    ),
                ),
              );
              unawaited(
                speakVoice(
                  "Unable to process your request. Please try again ${config.environment == Environment.test ? "${result["app_data"]["command"]}" : ""}",
                ),
              );
            }
          } else {
            emit(
              state.rebuild(
                (b) => b
                  ..chatData = List.of(b.chatData ?? [])
                  ..chatData?.add(
                    ChatModel(
                      text:
                          "Unable to process your request. Please try again ${config.environment == Environment.test ? "${result["app_data"]["command"]}" : ""}",
                    ),
                  ),
              ),
            );
            unawaited(
              speakVoice(
                "Unable to process your request. Please try again ${config.environment == Environment.test ? "${result["app_data"]["command"]}" : ""}",
              ),
            );
          }
          return;
        }

        final data = result["data"];

        updateListener();

        if (data["category"] == "ThemeCreation") {
          if (state.chatData.isNotEmpty) {
            if (state.chatData[state.chatData.length - 1].id == 0) {
              emit(
                state.rebuild(
                  (b) => b
                    ..chatData = List.of(b.chatData ?? [])
                    ..chatData?[state.chatData.length - 1] = ChatModel(
                      id: 0,
                      text: data["read_aloud_text"] ?? "",
                    ),
                ),
              );
            }
          } else {
            emit(
              state.rebuild(
                (b) => b
                  ..chatData = List.of(b.chatData ?? [])
                  ..chatData?.add(
                    ChatModel(text: data["read_aloud_text"] ?? ""),
                  ),
              ),
            );
            unawaited(speakVoice(data["read_aloud_text"] ?? ""));
          }
          unawaited(
            CreateAIThemeScreen.push(
              context.mounted ? context : context,
              text: data["theme_description"] ?? "",
            ),
          );

          return;
        } else if (data["category"] == "AppCommand") {
          data["app_data"]["text"] = data["read_aloud_text"] ?? "";
          data["app_data"]["userQuery"] = data["user_query"];

          final VoiceControlModel model = VoiceControlModel.fromDynamic(
            data["app_data"],
          );

          if (model.command == null || model.command == "null") {
            unawaited(speakVoice(data["read_aloud_text"] ?? ""));
            if (state.chatData[state.chatData.length - 1].id == 0) {
              emit(
                state.rebuild(
                  (b) => b
                    ..chatData = List.of(b.chatData ?? [])
                    ..chatData?[state.chatData.length - 1] = ChatModel(
                      id: 0,
                      text: data["read_aloud_text"],
                    ),
                ),
              );
            }
          } else {
            data["request_parameters"] = {
              "user_id": singletonBloc.profileBloc.state!.id,
              "user_name": singletonBloc.profileBloc.state!.name,
              "text": text,
              // "location_id": singletonBloc.profileBloc.state!.locationId,
              "location_id": singletonBloc
                  .profileBloc.state!.selectedDoorBell?.locationId
                  .toString(),
            };
            unawaited(
              apiService.loggingApiForAiVoiceControl(
                model.command!,
                jsonEncode(data),
              ),
            );
            if (state.chatData.isNotEmpty) {
              if (state.chatData[state.chatData.length - 1].id == 0) {
                emit(
                  state.rebuild(
                    (b) => b
                      ..chatData = List.of(b.chatData ?? [])
                      ..chatData?[state.chatData.length - 1] = ChatModel(
                        id: 0,
                        text: data["read_aloud_text"],
                      ),
                  ),
                );
              } else {
                emit(
                  state.rebuild(
                    (b) => b
                      ..chatData = List.of(b.chatData ?? [])
                      ..chatData?.add(ChatModel(text: data["read_aloud_text"])),
                  ),
                );
                unawaited(speakVoice(data["read_aloud_text"] ?? ""));
              }
            } else {
              emit(
                state.rebuild(
                  (b) => b
                    ..chatData = List.of(b.chatData ?? [])
                    ..chatData?.add(ChatModel(text: data["read_aloud_text"])),
                ),
              );
              unawaited(speakVoice(data["read_aloud_text"] ?? ""));
            }
            Future.delayed(const Duration(seconds: 1), () {
              if (scrollController.hasClients) {
                unawaited(
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceIn,
                  ),
                );
              }
            });
            if (context.mounted) {
              if (model.command!.isEmpty) {
                unawaited(speakVoice(data["read_aloud_text"]));
              }
              updateIsVoiceRecording(false);
              await handleVoiceCommand(context, model, data);
            } else {
              // context = navigatorKeyMain.currentContext!;
              Future.delayed(const Duration(seconds: 1), () async {
                if (navigatorKeyMain.currentContext!.mounted) {
                  if (model.command!.isEmpty) {
                    unawaited(speakVoice(data["read_aloud_text"]));
                  }
                  updateIsVoiceRecording(false);
                  await handleVoiceCommand(
                    navigatorKeyMain.currentContext!,
                    model,
                    data,
                  );
                }
              });
            }
          }
        } else {
          if (state.chatData.isNotEmpty) {
            if (state.chatData[state.chatData.length - 1].id == 0) {
              emit(
                state.rebuild(
                  (b) => b
                    ..chatData = List.of(b.chatData ?? [])
                    ..chatData?[state.chatData.length - 1] = ChatModel(
                      id: 0,
                      text: data["read_aloud_text"],
                    ),
                ),
              );
            }
          } else {
            emit(
              state.rebuild(
                (b) => b
                  ..chatData = List.of(b.chatData ?? [])
                  ..chatData?.add(ChatModel(text: data["read_aloud_text"])),
              ),
            );
            unawaited(speakVoice(data["read_aloud_text"] ?? ""));
          }
          unawaited(speakVoice(data["read_aloud_text"] ?? ""));
          Future.delayed(const Duration(seconds: 1), () {
            if (scrollController.hasClients) {
              unawaited(
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.bounceIn,
                ),
              );
            }
          });
          // if (Platform.isIOS) {
          //   unawaited(
          //     initializeKeywordDetection(context.mounted ? context : context),
          //   );
          // }
        }
      },
      onError: (final e) async {
        _stopStatusMessageTimer();
        statusChange();
        isListened = false;

        if (e is DioException) {
          emit(
            state.rebuild(
              (b) => b
                ..chatData = List.of(b.chatData ?? [])
                ..chatData?[state.chatData.length - 1] = ChatModel(
                  id: 0,
                  text:
                      "Unable to process your request. Please try again ${config.environment == Environment.test ? "${e.response!.data["data"]["app_data"]["command"]}" : ""}",
                ),
            ),
          );
          unawaited(
            speakVoice(
              "Unable to process your request. Please try again ${config.environment == Environment.test ? "${e.response!.data["data"]["app_data"]["command"]}" : ""}",
            ),
          );
          ToastUtils.errorToast(e.response!.data["data"]);
          final responseData = jsonDecode(e.response!.data["data"]);
          responseData['transcription_text'] = text;

          unawaited(
            apiService.loggingApiForAiVoiceControl(
              "Error",
              jsonEncode(responseData),
            ),
          );
        }
      },
    );
  }

  void updateListener() {
    isListened = false;
    Future.delayed(const Duration(seconds: 2), () {
      updateIsLoading(false);
      updateIsVoiceRecording(false);
      SpeechRecognition().isDetected = false;
    });
    updateSayingWords(null);
  }

  void stopListener() {
    isListened = false;
    updateIsLoading(false);
    updateSayingWords(null);
    SpeechRecognition().isDetected = false;
  }

  Timer? stopDebounce;

  Future<void> stopListening(
    BuildContext context,
    String text, {
    bool fromUseModal = false,
  }) async {
    emit(
      state.rebuild(
        (b) => b
          ..chatData = List.of(b.chatData ?? [])
          ..chatData?.add(
            ChatModel(
              text: text,
              senderImage: singletonBloc.profileBloc.state!.image ?? "",
            ),
          ),
      ),
    );
    isWordDetected = false;
    await getAiResponse(
      context.mounted ? context : context,
      text,
      fromUseModal: fromUseModal,
    );

    Future.delayed(const Duration(seconds: 1), () async {
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<bool> checkAndRequestMicrophonePermission(BuildContext context) async {
    try {
      final status = await Permission.microphone.status;

      if (status.isGranted) {
        emit(state.rebuild((b) => b..isPermissionAvailable = true));
        return true;
      } else if (status.isPermanentlyDenied) {
        if (Platform.isAndroid) {
          await openAppSettings();
        } else {
          emit(state.rebuild((b) => b..isPermissionAvailable = false));
        }
        return false;
      } else {
        final result = await Permission.microphone.request();
        if (result.isGranted) {
          return true;
        } else {
          if (context.mounted) {
            unawaited(
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => StatefulBuilder(
                  builder: (dialogContext, snapshot) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              context.appLocalizations.app_setting_microphone,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        Navigator.pop(dialogContext);
                                      },
                                      child: Container(
                                        height: 46,
                                        alignment: Alignment.center,
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          context
                                              .appLocalizations.general_cancel,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: CustomGradientButton(
                                      onSubmit: () async {
                                        Navigator.pop(dialogContext);
                                        unawaited(openAppSettings());
                                      },
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                      label:
                                          context.appLocalizations.open_setting,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
          return false;
        }
      }
    } catch (e) {
      _logger.severe("Error checking and requesting microphone permission: $e");
      return false;
    }
  }

  @override
  Future<void> close() {
    _stopStatusMessageTimer();
    return super.close();
  }

  // Get current speaker status
  Future<void> getSpeakerStatus() async {
    try {
      final bool status = await SpeakerphoneController.getSpeakerphoneStatus();
      updateSpeakerStatus(status);
    } catch (e) {
      _logger.severe("Error getting speaker status: $e");
    }
  }

  Future<void> _initializeSpeakerStatus() async {
    try {
      _logger.fine("Initializing speaker status...");
      // First test if method channel is working
      final bool isChannelWorking =
          await SpeakerphoneController.pingMethodChannel();
      if (isChannelWorking) {
        await getSpeakerStatus();
      } else {
        _logger.severe(
          "Method channel not working, skipping speaker status check",
        );
      }
    } catch (e) {
      _logger.severe("Error initializing speaker status: $e");
    }
  }
}
