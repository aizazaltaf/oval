import 'dart:async';

import 'package:admin/constants.dart';
import 'package:admin/core/config.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/date_time.dart';
import 'package:admin/models/data/notification_data.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/chat/bloc/chat_bloc.dart';
import 'package:admin/pages/main/chat/chat_screen.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/call_screen.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class Buttons extends StatelessWidget {
  const Buttons({
    super.key,
    required this.icon,
    required this.stateUpdate,
    required this.enable,
    required this.createdAt,
    required this.isCodePresent,
    this.callUserId,
    this.callType,
    this.visitor,
    this.notification,
    required this.text,
  });
  final IconData icon;
  final VisitorsModel? visitor;
  final String text;
  final Function stateUpdate;
  final bool isCodePresent;
  final String? callUserId;
  final String createdAt;
  final bool enable;
  final String? callType;
  final NotificationData? notification;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          if (config.environment.name.contains("develop")) {
            final bloc = VoipBloc.of(context);

            if (callType == "video") {
              bloc
                ..updateEnabledSpeakerInCall(false)
                ..shiftToVideoCallOverlay(
                  context: context,
                  callUserId: callUserId,
                  callType: Constants.doorbellVideoCall,
                  visitor: visitor,
                  notificationImage: notification?.imageUrl,
                );
            } else if (callType == "audio") {
              bloc
                ..resetTimer()
                ..updateEnabledSpeakerInCall(false)
                ..isAudioEmit();
              unawaited(
                CallingScreen.push(
                  context,
                  callUserId!,
                  false,
                  notificationImage: notification?.imageUrl,
                  callType: Constants.doorbellAudioCall,
                  visitor: visitor,
                ),
              );
            } else {
              ChatBloc.of(context)
                  .updateNotificationLocationId(notification!.locationId);
              unawaited(
                ChatScreen.push(
                  context: context,
                  doorbellUserId: callUserId!, // callUserId -> doorbellUserId
                  notificationId: notification!.id,
                  notificationCreatedAt: notification!.createdAt,
                  visitors: notification?.visitor,
                  deviceId: notification!.deviceId.toString(),
                ),
              );
            }
          } else {
            if (!isCodePresent) {
              CommonFunctions.showRestrictionDialog(context);
            } else if (DateTime.parse(createdAt).isAudioVideoChatDisabled()) {
              if (callType != null) {
                if (!enable) {
                  ToastUtils.infoToast(
                    context.appLocalizations.visitor_has_left,
                    context.appLocalizations.visitor_left,
                  );
                } else {
                  final bloc = VoipBloc.of(context);
                  if (callType == "video") {
                    bloc.shiftToVideoCallOverlay(
                      context: context,
                      callUserId: callUserId,
                      callType: callType,
                      visitor: visitor,
                      notificationImage: notification?.imageUrl,
                    );
                  } else if (callType == "audio") {
                    bloc
                      ..resetTimer()
                      ..isAudioEmit();
                    unawaited(
                      CallingScreen.push(
                        context,
                        callUserId!,
                        false,
                        visitor: visitor,
                        notificationImage: notification?.imageUrl,
                        callType: Constants.doorbellAudioCall,
                      ),
                    );
                  } else {
                    ChatBloc.of(context)
                        .updateNotificationLocationId(notification!.locationId);
                    unawaited(
                      ChatScreen.push(
                        context: context,
                        doorbellUserId: callUserId!,
                        notificationId: notification!.id,
                        notificationCreatedAt: notification!.createdAt,
                        visitors: notification?.visitor,
                        deviceId: notification!.deviceId.toString(),
                      ),
                    );
                  }
                }
              }
            } else {
              stateUpdate.call();
              ToastUtils.infoToast(
                context.appLocalizations.visitor_has_left,
                context.appLocalizations.visitor_left,
              );
            }
          }
        },
        child: Row(
          children: [
            Icon(
              size: 15,
              icon,
              color: !isCodePresent
                  ? Colors.grey
                  : enable
                      ? AppColors.blueLinearGradientColor
                      : Colors.grey,
            ),
            SizedBox(
              width: 1.w,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: !isCodePresent
                        ? Colors.grey
                        : enable
                            ? AppColors.darkBluePrimaryColor
                            : Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
