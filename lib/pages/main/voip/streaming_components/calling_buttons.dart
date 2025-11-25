import 'dart:async';

import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/call_screen.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class CallingButtons extends StatelessWidget {
  const CallingButtons({
    super.key,
    required this.callUserId,
    required this.device,
  });

  final String callUserId;
  final UserDeviceModel device;

  @override
  Widget build(BuildContext context) {
    final VoipBloc bloc = VoipBloc.of(context);
    return VoipBlocSelector.isLiveModeActivated(
      builder: (isLiveModeActivated) {
        if (device.isExternalCamera == false && isLiveModeActivated) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomWidgetButton(
                        isButtonEnabled: true,
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        borderColor: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .onSurface,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              DefaultIcons.ONE_WAY,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .onSurface,
                              height: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              context.appLocalizations.one_way_calling,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                  ),
                            ),
                          ],
                        ),
                        onSubmit: () async {
                          bloc
                            ..resetTimer()
                            ..isOneWayEmit();
                          unawaited(
                            CallingScreen.push(
                              context,
                              callUserId,
                              true,
                              callType: "one_way_video",
                            ),
                          );
                          //   .then((value) {
                          //     Future.delayed(const Duration(seconds: 1), () {
                          //       if (context.mounted) {
                          //         bloc.createPeerConnectionMethod(
                          //           context,
                          //         );
                          //       }
                          //     });
                          //     Future.delayed(const Duration(seconds: 2), () {
                          //       singletonBloc.socketEmitterWithAck(
                          //         roomName: Constants.signaling,
                          //         deviceId: device.deviceId,
                          //         request: Constants.doorbellStreamAudio,
                          //       );
                          //     });
                          //   }),
                          // );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomWidgetButton(
                        isButtonEnabled: true,
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1),
                        borderColor: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .onSurface,
                        borderRadius: BorderRadius.circular(20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              DefaultIcons.TWO_WAY,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .onSurface,
                              height: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              context.appLocalizations.two_way_calling,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                  ),
                            ),
                          ],
                        ),
                        onSubmit: () async {
                          bloc
                            ..resetTimer()
                            ..isTwoWayEmit();

                          if (context.mounted) {
                            unawaited(
                              CallingScreen.push(
                                context,
                                callUserId,
                                true,
                                callType: Constants.doorbellVideoCall,
                              ).then((value) {
                                // Future.delayed(const Duration(seconds: 1), () {
                                //   if (context.mounted) {
                                //     bloc.createPeerConnectionMethod(
                                //       context,
                                //     );
                                //   }
                                // });
                                // Future.delayed(const Duration(seconds: 2), () {
                                //   singletonBloc.socketEmitterWithAck(
                                //     roomName: Constants.signaling,
                                //     deviceId: device.deviceId,
                                //     request: Constants.doorbellStreamAudio,
                                //   );
                                // });
                              }),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomWidgetButton(
                        isButtonEnabled: true,
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1),
                        borderColor: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .onSurface,
                        borderRadius: BorderRadius.circular(20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              DefaultIcons.TWO_WAY,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .onSurface,
                              height: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              context.appLocalizations.audio_call,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                  ),
                            ),
                          ],
                        ),
                        onSubmit: () async {
                          bloc
                            ..resetTimer()
                            ..isAudioEmit();
                          if (context.mounted) {
                            unawaited(
                              CallingScreen.push(
                                context,
                                callUserId,
                                true,
                                callType: "audio",
                              ).then((value) {
                                // singletonBloc.socketEmitterWithAck(
                                //   roomName: Constants.signaling,
                                //   deviceId: device.deviceId,
                                //   request: Constants.doorbellStreamAudio,
                                // );
                              }),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomWidgetButton(
                        isButtonEnabled: true,
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        borderColor: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .onSurface,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fiber_smart_record,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .onSurface,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              context.appLocalizations.goto_recording,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                  ),
                            ),
                          ],
                        ),
                        onSubmit: () {
                          bloc.changeLiveMode(
                            context,
                            callUserId,
                            isStreaming: device.isStreaming == 1 ? true : false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
