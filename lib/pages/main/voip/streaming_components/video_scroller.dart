import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/core/app_restrictions.dart';
import 'package:admin/extensions/date_time.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/components/custom_seek_bar.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class VideoScroller extends StatelessWidget {
  const VideoScroller({
    super.key,
    required this.callUserId,
    required this.device,
    required this.isExternalCamera,
    this.alertId,
  });
  final String callUserId;
  final int? alertId;
  final bool isExternalCamera;
  final UserDeviceModel device;

  @override
  Widget build(BuildContext context) {
    final bloc = VoipBloc.of(context);
    bool isRecordingButtonEnabled = false;
    if (singletonBloc.isFeatureCodePresent(AppRestrictions.recordings.code)) {
      isRecordingButtonEnabled = true;
    } else if (!isExternalCamera &&
        singletonBloc
            .isFeatureCodePresent(AppRestrictions.doorbellRecording.code)) {
      isRecordingButtonEnabled = true;
    }
    return VoipBlocSelector.isLiveModeActivated(
      builder: (isLiveModeActivated) {
        if (isLiveModeActivated) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 4,
            ),
            child: GestureDetector(
              onTap: () {
                if (!isRecordingButtonEnabled) {
                  CommonFunctions.showRestrictionDialog(context);
                }
              },
              child: CustomWidgetButton(
                // Recording Button Enabled or Disabled based on 0202
                isButtonEnabled: isRecordingButtonEnabled,
                borderRadius: BorderRadius.circular(20),
                color: isRecordingButtonEnabled
                    ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                    : null,
                borderColor: isRecordingButtonEnabled
                    ? Theme.of(context).buttonTheme.colorScheme!.onPrimary
                    : Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: singletonBloc.isFeatureCodePresent(
                          AppRestrictions.recordings.code,
                        )
                            ? const Color(0xffd51820)
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      "Recordings",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: !singletonBloc.isFeatureCodePresent(
                              AppRestrictions.recordings.code,
                            )
                                ? Colors.white
                                : isLiveModeActivated
                                    ? Theme.of(context)
                                        .buttonTheme
                                        .colorScheme!
                                        .onPrimary
                                    : Theme.of(context)
                                        .buttonTheme
                                        .colorScheme!
                                        .primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                    ),
                  ],
                ),
                onSubmit: () {
                  bloc
                    ..changeLiveMode(context, callUserId)
                    ..calendarDate = DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                    )
                    ..timerDate = bloc.calendarDate
                    ..reinitialize(forRecording: true)
                    ..getRecording(
                      callUserId: callUserId,
                      isExternalCamera: isExternalCamera,
                    );
                },
              ),
            ),
          );
        }
        // if (!isLiveModeActivated) {
        return VoipBlocSelector.recordingApi(
          builder: (streamingAlertData) {
            // if (streamingAlertData.data == null && isLiveModeActivated == true) {
            //   return const SizedBox.shrink();
            // }
            return Column(
              children: [
                CustomWidgetButton(
                  isButtonEnabled: !isLiveModeActivated,
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderColor:
                      Theme.of(context).buttonTheme.colorScheme!.onPrimary,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        color: isLiveModeActivated
                            ? Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .onPrimary
                            : Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        bloc.calendarDate.toPrettyDate(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: isLiveModeActivated
                                  ? Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onPrimary
                                  : Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                      ),
                    ],
                  ),
                  onSubmit: () {
                    bloc.toggleCalendarDate(
                      context,
                      callUserId,
                      isExternalCamera,
                    );
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                VoipBlocSelector.recordingApi(
                  builder: (api) {
                    if (api.isApiInProgress) {
                      return liveModeBtn(context, isLiveModeActivated, bloc);
                    }
                    if (bloc.state.recordingApi.data == null) {
                      return liveModeBtn(context, isLiveModeActivated, bloc);
                    }
                    return VoipBlocSelector.isVideoInitialized(
                      builder: (isVideoInitialized) {
                        return VoipBlocSelector.videoController(
                          builder: (videoController) {
                            if (videoController == null) {
                              return liveModeBtn(
                                context,
                                isLiveModeActivated,
                                bloc,
                              );
                            }
                            if (!isVideoInitialized) {
                              return liveModeBtn(
                                context,
                                isLiveModeActivated,
                                bloc,
                              );
                            }

                            if (bloc.m3u8TimeMapping == null) {
                              return liveModeBtn(
                                context,
                                isLiveModeActivated,
                                bloc,
                              );
                            }

                            return CustomSeekBar(
                              alertId: alertId,
                              totalVideoDuration: bloc
                                  .state.recordingApi.data!.duration!
                                  .toDouble(),
                              originalVideoDuration:
                                  bloc.m3u8TimeMapping!.totalDuration,
                              alertChunks: bloc
                                  .state.recordingApi.data!.aiAlert!
                                  .toList(),
                              device: device,
                              callUserId: callUserId,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
        // }
        // return const SizedBox.shrink();
      },
    );
  }

  Widget liveModeBtn(
    BuildContext context,
    bool isLiveModeActivated,
    VoipBloc bloc,
  ) {
    return CustomWidgetButton(
      isButtonEnabled: !isLiveModeActivated,
      borderRadius: BorderRadius.circular(20),
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      borderColor: Theme.of(context).buttonTheme.colorScheme!.onPrimary,
      child: Center(
        child: Text(
          "Live",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: isLiveModeActivated
                    ? Theme.of(context).buttonTheme.colorScheme!.onPrimary
                    : Theme.of(context).buttonTheme.colorScheme!.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
        ),
      ),
      onSubmit: () {
        unawaited(
          bloc.changeLiveMode(
            context,
            callUserId,
            isStreaming: device.isStreaming == 1 ? true : false,
          ),
        );
      },
    );
  }
}
