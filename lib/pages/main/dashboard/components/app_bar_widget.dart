import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/dashboard/components/doorbell_appbar.dart';
import 'package:admin/pages/main/dashboard/components/no_doorbell_appbar.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/notifications/notification_builder.dart';
import 'package:admin/pages/main/notifications/notification_page.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StartupBlocSelector.isInternetConnected(
      builder: (isInternetConnected) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StartupBlocBuilder(
                builder: (context, state) {
                  return StartupBlocSelector.userDeviceModel(
                    builder: (userDeviceModel) {
                      if (!isInternetConnected &&
                          singletonBloc.profileBloc.state?.selectedDoorBell !=
                              null) {
                        return const DoorbellAppbar(isDisabled: true);
                      }
                      if (userDeviceModel == null) {
                        return StartupBlocSelector(
                          selector: (startupState) =>
                              startupState.dashboardApiCalling,
                          builder: (isDashboardApiCalling) {
                            if (!isDashboardApiCalling) {
                              return const NoDoorbellAppbar();
                            }
                            return const ButtonProgressIndicator();
                          },
                        );
                      } else if (userDeviceModel.isEmpty) {
                        return const NoDoorbellAppbar();
                      } else {
                        return const DoorbellAppbar();
                      }
                    },
                  );
                },
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StartupBlocSelector.userDeviceModel(
                    builder: (devices) {
                      if (devices == null || devices.isEmpty) {
                        return const SizedBox.shrink();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              // CommonFunctions.displayModesBottomSheet(context);
                              ToastUtils.infoToast(
                                context.appLocalizations.coming_soon,
                                context.appLocalizations
                                    .system_modes_available_soon,
                              );
                            },
                            child: SvgPicture.asset(
                              DefaultVectors.MODES_DASH_ICON,
                              width: 23,
                              height: 23,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  StartupBlocSelector.userDeviceModel(
                    builder: (devices) {
                      if (devices == null || devices.isEmpty) {
                        return const SizedBox.shrink();
                      } else {
                        return const SizedBox(width: 10);
                      }
                    },
                  ),
                  StartupBlocSelector.userDeviceModel(
                    builder: (devices) {
                      if (devices == null) {
                        return const SizedBox.shrink();
                      }
                      return NotificationBlocSelector.newNotification(
                        builder: (isNew) {
                          return NotificationBlocSelector
                              .notificationDeviceStatus(
                            builder: (data) {
                              return IgnorePointer(
                                ignoring: !isInternetConnected,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () async {
                                    if (devices.isEmpty) {
                                      ToastUtils.infoToast(
                                        context.appLocalizations
                                            .disable_notification_title,
                                        context.appLocalizations
                                            .disable_notification_desc,
                                      );
                                    } else {
                                      unawaited(NotificationPage.push(context));
                                    }
                                  },
                                  child: NotificationBuilder(
                                    // ignore: avoid_bool_literals_in_conditional_expressions
                                    status: (devices.isEmpty)
                                        ? false
                                        : isNew ||
                                            (data?.values
                                                    .any((value) => value) ??
                                                false),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
