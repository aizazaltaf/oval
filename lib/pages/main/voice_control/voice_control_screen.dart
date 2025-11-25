import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/custom_classes/gradient_fab_btn.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/main/voice_control/component/gradient_loader.dart';
import 'package:admin/pages/main/voice_control/component/listing_devices_widget.dart';
import 'package:admin/pages/main/voice_control/component/voice_control_audio_visualizer.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/components/speaker.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VoiceControlScreen extends StatefulWidget {
  const VoiceControlScreen({super.key});
  static const routeName = "voiceControlScreen";

  static Future<void> push(final BuildContext context) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const VoiceControlScreen(),
    );
  }

  @override
  State<VoiceControlScreen> createState() => _VoiceControlScreenState();
}

class _VoiceControlScreenState extends State<VoiceControlScreen>
    with RouteAware, WidgetsBindingObserver {
  late VoiceControlBloc bloc;
  bool _isThrottled = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    bloc = VoiceControlBloc.of(context)
      ..updateSayingWords(null)
      ..updateIsVoiceControlScreenActive(false)
      ..updateIsVoiceRecording(false)
      ..updateIsListening(false)
      ..updateIsTyping(false)
      ..updateIsLoading(false);
    WidgetsBinding.instance.addPostFrameCallback(
      (C) => Future.delayed(const Duration(seconds: 2), () async {
        // Ensure speakerphone is enabled for voice control
        unawaited(bloc.setSpeakerStatus(true));

        if (bloc.scrollController.hasClients) {
          unawaited(
            bloc.scrollController.animateTo(
              bloc.scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            ),
          );
        }
      }),
    );

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      final voipBloc = VoipBloc.of(context);
      if (voipBloc.streamingPeerConnection == null) {
        if (voipBloc.callingPeerConnection == null) {
          bloc.setSpeakerStatus(true);
        }
      }
    } else if (state == AppLifecycleState.paused) {
      bloc.stopListener();
    } else if (state == AppLifecycleState.inactive) {
      bloc.stopListener();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc.updateIsVoiceControlScreenActive(true);
  }

  @override
  void didPopNext() {
    bloc.updateIsVoiceControlScreenActive(true);
  }

  @override
  void dispose() {
    singletonBloc.speech.stop();
    singletonBloc.speech.cancel();
    bloc
      ..setSpeakerStatus(false)
      ..isListened = true
      ..emptyResponse()
      ..updateIsVoiceControlScreenActive(false)
      ..updateIsVoiceRecording(false)
      ..updateIsListening(false)
      ..updateSayingWords(null)
      ..updateIsTyping(false)
      ..updateIsLoading(false);

    WidgetsBinding.instance.removeObserver(this);
    singletonBloc.textToSpeech.pause();
    singletonBloc.textToSpeech.stop();
    super.dispose();
  }

  Future<void> createVoice(bool isVoiceRecording) async {
    if (_isThrottled) {
      return;
    }

    if (!isVoiceRecording) {
      await singletonBloc.removeInstance();
      await SpeakerphoneController.setSpeakerphoneOn(
        true,
      );
      _isThrottled = true;

      await singletonBloc.textToSpeech.stop();

      Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
        () {
          bloc.updateIsVoiceRecording(
            true,
          );
        },
      );
      _isThrottled = false;

      unawaited(
        bloc.record(
          context.mounted ? context : context,
          fromUseModal: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final bloc = VoiceControlBloc.of(context);
    return VoiceControlBlocSelector.isTyping(
      builder: (isTyping) {
        return PopScope(
          canPop: !isTyping,
          onPopInvokedWithResult: (_, r) {
            if (isTyping) {
              bloc
                ..updateIsTyping(false)
                ..updateTypingCommand(null);
            }
          },
          child: AppScaffold(
            appTitle: bloc.state.chatData.isEmpty
                ? context.appLocalizations.voice_control
                : context.appLocalizations.voice_control_chat,
            onBackPressed: () {
              if (isTyping) {
                bloc
                  ..updateIsTyping(false)
                  ..updateTypingCommand(null);
              } else {
                Navigator.pop(context);
              }
            },
            floatingActionButton: VoiceControlBlocSelector.isLoading(
              builder: (isLoading) {
                return VoiceControlBlocSelector.isListening(
                  builder: (isListening) {
                    return VoiceControlBlocSelector.isVoiceRecording(
                      builder: (isVoiceRecording) {
                        return isTyping || isLoading || isListening
                            ? const SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (isVoiceRecording) {
                                      bloc.isListened = true;
                                      // unawaited(EasyLoading.show());
                                      Constants.dismissLoader();

                                      unawaited(singletonBloc.speech.stop());
                                      unawaited(singletonBloc.speech.cancel());
                                      bloc.emptyResponse();

                                      unawaited(
                                        singletonBloc.textToSpeech.pause(),
                                      );
                                      unawaited(
                                        singletonBloc.textToSpeech.stop(),
                                      );
                                      bloc
                                        ..updateSayingWords(null)
                                        ..updateIsVoiceRecording(false)
                                        ..updateIsListening(false)
                                        ..updateIsLoading(false);
                                      unawaited(bloc.setSpeakerStatus(true));
                                      bloc.emptyResponse();
                                      Future.delayed(
                                        const Duration(milliseconds: 1500),
                                        // EasyLoading.dismiss,
                                        Constants.dismissLoader,
                                      );
                                    } else if (!isTyping) {
                                      bloc.updateIsTyping(true);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(
                                      !isVoiceRecording
                                          ? MdiIcons.keyboardOutline
                                          : Icons.close,
                                      size: 30,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              );
                      },
                    );
                  },
                );
              },
            ),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (bloc.state.chatData.isEmpty)
                    const SizedBox(height: 10)
                  else
                    const SizedBox.shrink(),
                  Expanded(
                    flex: 4,
                    child: ListingDevicesWidget(
                      bloc: bloc,
                      ctx: context,
                    ),
                  ),
                  Expanded(
                    child: VoiceControlBlocSelector.isPermissionAvailable(
                      builder: (isPermissionAvailable) {
                        return VoiceControlBlocSelector.isLoading(
                          builder: (isLoading) {
                            return VoiceControlBlocSelector.isListening(
                              builder: (isListening) {
                                return VoiceControlBlocSelector
                                    .isVoiceRecording(
                                  builder: (isVoiceRecording) {
                                    return Stack(
                                      children: [
                                        if (isVoiceRecording &&
                                            !isLoading &&
                                            !isListening)
                                          Center(
                                            child: SizedBox(
                                              width: 70.w,
                                              child:
                                                  VoiceControlAudioVisualizerIntegration(
                                                bloc: bloc,
                                                height: 120,
                                              ),
                                            ),
                                          ),
                                        // ImageFiltered(
                                        //   imageFilter: ImageFilter.blur(
                                        //     sigmaX: 3,
                                        //     sigmaY: 3,
                                        //   ),
                                        //   child: Image.asset(
                                        //     DefaultImages.VOICE_CONTROL_WAVES,
                                        //   ),
                                        // ),
                                        Positioned.fill(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                  bottom: !isListening &&
                                                          !isVoiceRecording
                                                      ? 10
                                                      : 100,
                                                ),
                                                child: VoiceControlBlocSelector
                                                    .sayingWords(
                                                  builder: (words) {
                                                    if (words == null ||
                                                        words.isEmpty) {
                                                      return const SizedBox
                                                          .shrink();
                                                    } else {
                                                      return SizedBox(
                                                        width: 70.w,
                                                        child: Text(
                                                          words,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: Theme.of(
                                                            context,
                                                          )
                                                              .textTheme
                                                              .displayMedium,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  if (!isPermissionAvailable)
                                                    Expanded(
                                                      child: GestureDetector(
                                                        behavior:
                                                            HitTestBehavior
                                                                .opaque,
                                                        onTap: () {
                                                          bloc.askPermission(
                                                            context,
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 40,
                                                          ),
                                                          child: Text(
                                                            context
                                                                .appLocalizations
                                                                .grant_microphone_permission,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  else if (isTyping)
                                                    typeCommand()
                                                  else if (!isListening &&
                                                      !isVoiceRecording &&
                                                      !isLoading)
                                                    GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .opaque,
                                                      onTap: () {
                                                        createVoice(
                                                          isVoiceRecording,
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: Theme.of(
                                                              context,
                                                            ).primaryColor,
                                                            width: 2,
                                                          ),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(
                                                          8,
                                                        ),
                                                        child:
                                                            const GradientFloatingButton(
                                                          padding:
                                                              EdgeInsets.all(
                                                            15,
                                                          ),
                                                          child: Icon(
                                                            Icons.mic,
                                                            size: 26,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  else if (isListening &&
                                                      !isVoiceRecording &&
                                                      !isLoading)
                                                    const SizedBox.shrink()
                                                  else if (isLoading &&
                                                      !isVoiceRecording &&
                                                      !isListening)
                                                    const Center(
                                                      child: GradientLoader(),
                                                    )
                                                  else
                                                    const SizedBox.shrink(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget typeCommand() {
    return VoiceControlBlocSelector.typingCommand(
      builder: (command) {
        return Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: NameTextFormField(
                        autoFocus: true,
                        customCircularBorder: 30,
                        customDefaultBorderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                        hintText: "Write here ...",
                        onChanged: bloc.updateTypingCommand,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        if (command != null && command.isNotEmpty) {
                          bloc
                            ..updateIsLoading(true)
                            ..recordTypeText(
                              context,
                              typedText: command,
                              fromUseModal: true,
                            );
                        }
                        bloc
                          ..updateIsTyping(false)
                          ..updateTypingCommand(null);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(
                            context,
                          ).primaryColor,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          command == null || command.isEmpty
                              ? Icons.close
                              : Icons.send,
                          size: 26,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
