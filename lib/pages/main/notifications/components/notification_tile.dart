import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/app_restrictions.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/date_time.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/models/data/notification_data.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/notifications/components/button_notification.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/streaming_page.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatefulWidget {
  const NotificationTile({
    super.key,
    required this.body,
    required this.title,
    required this.createdAt,
    required this.isExpanded,
    required this.onChange,
    required this.receiveType,
    required this.notification,
    this.image,
    this.callUserId,
    this.visitor,
    this.doorbell,
    required this.date,
  });

  final String? title;
  final NotificationData notification;
  final String? body;
  final String? image;
  final String? date;
  final VisitorsModel? visitor;
  final String? receiveType;
  final String? createdAt;
  final String? callUserId;
  final bool isExpanded;
  final Function? onChange;
  final UserDeviceModel? doorbell;

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  String getIcon(title, body, receiveType) {
    final String notificationTitle = title.toLowerCase().toString();
    final String notificationText = body.toLowerCase().toString();
    if (notificationTitle.contains(Constants.visitor) ||
        notificationTitle.contains(Constants.unwanted)) {
      return DefaultVectors.VISITOR_NOTIF;
    } else if (notificationTitle.contains(Constants.baby) &&
        notificationTitle.contains(Constants.run)) {
      return DefaultVectors.BABYRUN_NOTIF;
    } else if ((notificationTitle.contains(Constants.pet) &&
            notificationTitle.contains(Constants.run)) ||
        notificationTitle.contains(Constants.wildAnimal)) {
      return DefaultVectors.PETRUN_NOTIF;
    } else if (notificationTitle.contains(Constants.fire)) {
      return DefaultVectors.FIRE_NOTIF;
    } else if (notificationTitle.contains(Constants.parcel)) {
      return DefaultVectors.PARCEL_NOTIF;
    } else if (notificationTitle.contains(Constants.dog) &&
        notificationTitle.contains(Constants.poop)) {
      return DefaultVectors.DOGPOOP_NOTIF;
    } else if (notificationTitle.contains(Constants.eavesdropper)) {
      return DefaultVectors.EAVESDROPPER_NOTIF;
    } else if (notificationTitle.contains(Constants.intruder)) {
      return DefaultVectors.INTRUDER_NOTIF;
    } else if (notificationTitle.contains(Constants.weapon)) {
      return DefaultVectors.WEAPON_NOTIF;
    } else if (notificationTitle.contains(Constants.humanFall)) {
      return DefaultVectors.HUMANFALL_NOTIF;
    } else if (notificationTitle.contains(Constants.drowning)) {
      return DefaultVectors.DROWNING_NOTIF;
    } else if (notificationTitle.contains(Constants.boundaryBreach)) {
      return DefaultVectors.BOUNDARYBREACH_NOTIF;
    } else if (notificationTitle.contains(Constants.motion) ||
        notificationTitle.contains(Constants.monitoring)) {
      return DefaultVectors.MOTION_NOTIF;
    } else if (notificationTitle == Constants.onlyAlert) {
      return DefaultVectors.SMARTLOCK_NOTIF;
    } else if (notificationTitle.contains(Constants.doorbellTheft)) {
      return DefaultVectors.DOORBELLTHEFT_NOTIF;
    } else if (notificationTitle.contains(Constants.wifi) ||
        notificationTitle.contains(Constants.interruptions)) {
      return DefaultVectors.DOORBELLWIFI_NOTIF;
    } else if (notificationTitle.contains(Constants.powerDisconnect) ||
        notificationTitle.contains(Constants.powerOff) ||
        notificationTitle.contains(Constants.doorbellRelease) ||
        notificationTitle.contains(Constants.doorbellAccessRelease)) {
      return DefaultVectors.DOORBELL_NOTIF;
    } else if (notificationTitle.contains(Constants.lowBattery)) {
      return DefaultVectors.BATTERYLOW_NOTIF;
    } else if (notificationTitle.contains(Constants.subscription)) {
      return DefaultVectors.SUBSCRIPTIONS_NOTIF;
    } else if (notificationTitle.contains(Constants.creditCard) ||
        notificationTitle.contains(Constants.paymentDeclined)) {
      return DefaultVectors.CREDITCARD_NOTIF;
    } else if (notificationTitle.contains(Constants.requestNotif) ||
        notificationTitle.contains(Constants.spam)) {
      return DefaultVectors.NEIGHBOURHOOD_NOTIF;
    } else if (notificationTitle.contains(Constants.congratulations) ||
        notificationTitle.contains(Constants.reminder) ||
        notificationTitle.contains(Constants.paymentSchedule) ||
        notificationTitle.contains(Constants.paymentSuccessful)) {
      return DefaultVectors.PAYMENTSCHEDULE_NOTIF;
    } else if (notificationTitle.contains(Constants.voicemail)) {
      return DefaultVectors.LEAVEVOICEMAIL_NOTIF;
    } else if (notificationTitle.contains(Constants.location)) {
      return DefaultVectors.LOCATION_NOTIF;
    } else if (notificationTitle.contains(Constants.irvineiTitle) &&
        notificationText.contains(Constants.stream) &&
        receiveType!.contains('external_cam')) {
      return DefaultVectors.CAMERA_NOTIF;
    } else if (notificationTitle.contains(Constants.irvineiTitle) &&
        notificationText.contains(Constants.stream) &&
        (receiveType!.contains('AI') ||
            receiveType!.contains('face_recognition'))) {
      return DefaultVectors.DOORBELL_NOTIF;
    } else if (notificationTitle.contains(Constants.smartDevice) ||
        notificationText.contains(Constants.smartDevice)) {
      return DefaultVectors.SMARTDEVICE_NOTIF;
    } else if (notificationTitle.contains(Constants.flashlightEnabled)) {
      return DefaultVectors.FLASHLIGHT_ENABLED_NOTIF;
    } else if (notificationTitle.contains(Constants.flashlightEnabled)) {
      return DefaultVectors.FLASHLIGHT_DISABLED_NOTIF;
    } else {
      return DefaultVectors.DOORBELL_NOTIF;
    }
  }

  bool isSchedule(String title) {
    if (title.toLowerCase().contains("schedule")) {
      return true;
    }
    return false;
  }

  String pluckDeviceName(String text) {
    final regex = RegExp(r'Doorbell device (.*?) to be');
    final match = regex.firstMatch(text);

    if (match != null && match.groupCount >= 1) {
      final String deviceName = match.group(1)!;
      return deviceName; // Output: Back Door
    } else {
      logger.severe("Device name not found.");
      return "Device name not found.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime localDate = DateTime.parse(widget.createdAt!).toLocal();
    final DateTime newDate = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
    );

    // final String formattedDate = DateFormat('MMM dd').format(localDate);
    final String formattedTime = DateFormat('h:mm a').format(localDate);

    final bloc = NotificationBloc.of(context);
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (widget.title!.getExpansion() || isSchedule(widget.title!)) {
              widget.onChange!.call();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SvgPicture.asset(
                        getIcon(
                          widget.title,
                          widget.body,
                          widget.receiveType,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 1.h,
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                widget.title!,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const Spacer(),
                              if (widget.title!.getExpansion() ||
                                  isSchedule(widget.title!))
                                Icon(
                                  widget.isExpanded
                                      ? Icons.keyboard_arrow_up_outlined
                                      : Icons.keyboard_arrow_down_outlined,
                                )
                              else
                                const SizedBox.shrink(),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.body!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontSize: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .fontSize! -
                                            2,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    formattedTime,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: CommonFunctions.getThemeBasedWidgetColor(
                            context,
                          ),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        if (!isSchedule(widget.title!))
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                // Notification Snap shown or hidden based on 010102
                if (singletonBloc.isFeatureCodePresent(
                  AppRestrictions.notificationSnap.code,
                ))
                  SizedBox(height: 1.h),
                if (singletonBloc.isFeatureCodePresent(
                  AppRestrictions.notificationSnap.code,
                ))
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      final voipBloc = VoipBloc.of(context);
                      if (DateTime.parse(widget.createdAt!)
                          .isAudioVideoChatDisabled()) {
                        voipBloc.activateLiveMode(true);
                        unawaited(
                          StreamingPage.push(
                            context,
                            widget.callUserId!,
                            widget.doorbell!.id,
                          ).then((_) {
                            final v = VoipBloc.of(
                              context.mounted ? context : context,
                            );
                            Future.delayed(const Duration(seconds: 3), () {
                              unawaited(v.streamingPeerConnection?.dispose());
                              v.streamingPeerConnection = null;
                              final navigatorState =
                                  singletonBloc.navigatorKey?.currentState;
                              if (navigatorState == null) {
                                return;
                              }
                              final context = navigatorState.context;
                              if (!context.mounted) {
                                return;
                              }
                              VoiceControlBloc.of(context)
                                  .reinitializeWakeWord(context);
                            });
                          }),
                        );
                      } else {
                        voipBloc
                          ..calendarDate = newDate
                          ..activateLiveMode(false);
                        unawaited(
                          voipBloc.getRecording(callUserId: widget.callUserId!),
                        );
                        unawaited(
                          StreamingPage.push(
                            context,
                            alertId: widget.notification.id,
                            widget.callUserId!,
                            widget.doorbell!.id,
                            date: localDate,
                          ).then((_) {
                            Future.delayed(const Duration(seconds: 3), () {
                              unawaited(
                                voipBloc.streamingPeerConnection?.dispose(),
                              );
                              voipBloc.streamingPeerConnection = null;
                              final navigatorState =
                                  singletonBloc.navigatorKey?.currentState;
                              if (navigatorState == null) {
                                return;
                              }
                              final context = navigatorState.context;
                              if (!context.mounted) {
                                return;
                              }
                              VoiceControlBloc.of(context)
                                  .reinitializeWakeWord(context);
                            });
                          }),
                        );
                      }
                    },
                    child: Container(
                      height: 20.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.h),
                        image: DecorationImage(
                          image: NetworkImage(
                            "${widget.image}",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 1.h,
                ),
                if (widget.title!.getCanCall() &&
                    (widget.notification.entityId == null ||
                        widget.notification.entityId!.isEmpty))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Buttons(
                        callUserId: widget.callUserId,
                        icon: Icons.phone,
                        isCodePresent: singletonBloc.isFeatureCodePresent(
                          AppRestrictions.audioVideoCallButtons.code,
                        ),
                        stateUpdate: () {
                          setState(() {});
                        },
                        callType: "audio",
                        visitor: widget.visitor,
                        createdAt: widget.createdAt!,
                        notification: widget.notification,
                        enable: DateTime.parse(widget.createdAt!)
                            .isAudioVideoChatDisabled(),
                        text: context.appLocalizations.audio_call,
                      ),
                      Buttons(
                        callUserId: widget.callUserId,
                        icon: Icons.videocam,
                        callType: "video",
                        visitor: widget.visitor,
                        isCodePresent: singletonBloc.isFeatureCodePresent(
                          AppRestrictions.audioVideoCallButtons.code,
                        ),
                        notification: widget.notification,
                        stateUpdate: () {
                          setState(() {});
                        },
                        createdAt: widget.createdAt!,
                        enable: DateTime.parse(widget.createdAt!)
                            .isAudioVideoChatDisabled(),
                        text: context.appLocalizations.video_call,
                      ),
                      Buttons(
                        callUserId: widget.callUserId,
                        icon: Icons.chat_bubble,
                        notification: widget.notification,
                        isCodePresent: true,
                        stateUpdate: () {
                          setState(() {});
                        },
                        callType: "chat",
                        createdAt: widget.createdAt!,
                        enable: DateTime.parse(widget.createdAt!)
                            .isAudioVideoChatDisabled(),
                        text: context.appLocalizations.start_chat,
                      ),
                    ],
                  )
                else
                  const SizedBox.shrink(),
                SizedBox(
                  height: 1.h,
                ),
              ],
            ),
            crossFadeState: widget.isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        if (isSchedule(widget.title!))
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                SizedBox(
                  height: 1.h,
                ),
                NotificationBlocSelector(
                  selector: (state) =>
                      state.updateDoorbellSchedule.isApiInProgress,
                  builder: (isLoading) {
                    return CustomGradientButton(
                      isLoadingEnabled: isLoading,
                      label: context.appLocalizations.schedule(
                        widget.doorbell?.name ?? pluckDeviceName(widget.body!),
                      ),
                      customButtonFontSize: 12,
                      onSubmit: () async {
                        final selectedDateTime = await showCustomDateTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: DateTime.now().hour,
                            minute: DateTime.now().minute,
                          ),
                        );

                        if (selectedDateTime != null) {
                          bloc.updateScheduleOfDoorbell(
                            deviceId: widget.doorbell?.deviceId,
                            time: selectedDateTime.toUtc(),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            crossFadeState: widget.isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
      ],
    );
  }
}
