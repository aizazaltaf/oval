import 'dart:async';

import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class RenderStreamToggleButton extends StatelessWidget {
  const RenderStreamToggleButton({
    super.key,
    required this.device,
    required this.callUserId,
  });
  final UserDeviceModel device;
  final String callUserId;

  @override
  Widget build(BuildContext context) {
    final bloc = VoipBloc.of(context);
    return VoipBlocSelector.isLiveModeActivated(
      builder: (isLiveModeActivated) {
        return CustomWidgetButton(
          height: 70,
          isButtonEnabled: true,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF86dcff),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isLiveModeActivated ? 10 : 30.0,
              vertical: 4,
            ),
            child: Center(
              child: Text(
                isLiveModeActivated
                    ? context.appLocalizations.recording.toUpperCase()
                    : context.appLocalizations.live.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          onSubmit: () async {
            // if (signalingClient != null) {
            unawaited(
              bloc.changeLiveMode(
                context,
                callUserId,
                isStreaming: device.isStreaming == 1 ? true : false,
              ),
            );
            // }
          },
        );
      },
    );
  }
}
