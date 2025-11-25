import 'dart:io';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

final _logger = Logger("LogoutDialog");

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key, required this.voiceControlBloc});
  final VoiceControlBloc voiceControlBloc;

  @override
  Widget build(BuildContext context) {
    return LoginBlocSelector(
      selector: (state) => state.logoutApi.isApiInProgress,
      builder: (inProgress) {
        return AppDialogPopup(
          title: context.appLocalizations.logout_popup_title,
          cancelButtonLabel: context.appLocalizations.general_cancel,
          confirmButtonLabel: context.appLocalizations.logout,
          isLoadingEnabled: inProgress,
          needCross: false,
          cancelButtonOnTap: () => Navigator.of(context).pop(),
          confirmButtonOnTap: () {
            singletonBloc.textToSpeech.stop();
            if (Platform.isIOS) {
              singletonBloc.textToSpeech.setIosAudioCategory(
                IosTextToSpeechAudioCategory.playback,
                [
                  IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
                  IosTextToSpeechAudioCategoryOptions.mixWithOthers,
                  IosTextToSpeechAudioCategoryOptions.allowBluetooth,
                  IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
                ],
                IosTextToSpeechAudioMode.voicePrompt,
              );
            }
            singletonBloc.removeInstance();
            voiceControlBloc.close();

            // Verify the bloc is closed
            _logger.fine(
              "Is bloc closed after close(): ${voiceControlBloc.isClosed}",
            );

            LoginBloc.of(context).callLogout(
              successFunction: () async {
                singletonBloc.socket?.emit(
                  "leaveRoom",
                  // singletonBloc.profileBloc.state!.locationId,
                  singletonBloc.profileBloc.state?.selectedDoorBell?.locationId
                      .toString(),
                );

                await singletonBloc.getBox.erase();
                singletonBloc.profileBloc.updateProfile(null);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            );
          },
        );
      },
    );
  }
}
