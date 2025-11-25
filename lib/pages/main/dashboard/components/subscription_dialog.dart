import 'dart:async';

import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/subscription_location_model.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/app_drop_down_button.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class SubscriptionDialog extends StatelessWidget {
  const SubscriptionDialog({
    super.key,
    required this.subscription,
    required this.dialogContext,
  });

  final SubscriptionLocationModel subscription;
  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    StartupBloc.of(context).getDoorbells(
      id: singletonBloc.profileBloc.state?.selectedDoorBell?.locationId == null
          ? null
          : int.tryParse(
              singletonBloc.profileBloc.state!.selectedDoorBell!.locationId
                  .toString(),
            ),
    );
    final planExpired = CommonFunctions.isExpired(subscription.expiresAt ?? "");
    final planCancelled = subscription.subscriptionStatus == "canceled";
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context);
              },
              child: const Align(
                alignment: Alignment.centerRight,
                child: Column(
                  children: [
                    Icon(
                      Icons.cancel,
                      color: AppColors.darkBluePrimaryColor,
                      size: 26,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            if (planCancelled || planExpired)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "(${planExpired ? "Expired" : planCancelled ? "Cancelled" : ""})",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.red,
                      ),
                ),
              ),
            if (planCancelled || planExpired) const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${context.appLocalizations.subscription_plan}:",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  subscription.name ?? "",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.red,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${context.appLocalizations.expires_on}:",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  CommonFunctions.formatDateForApi(
                    DateTime.parse(subscription.expiresAt ?? '').toLocal(),
                    dateFormat: 'MM-dd-yyyy',
                  ),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.red,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ProfileBlocSelector.selectedDoorBell(
              builder: (doorbell) {
                return StartupBlocSelector.userDeviceModel(
                  builder: (doorbellList) {
                    if (doorbellList == null || doorbellList.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final newList = doorbellList.toList();
                    final ids = newList.map((e) => e.locationId).toSet();
                    if (ids.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    newList.retainWhere((x) => ids.remove(x.locationId));
                    final BuiltList<UserDeviceModel> list =
                        newList.toBuiltList();
                    if (list.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    if (!doorbellList.contains(doorbell)) {
                      return const SizedBox.shrink();
                    }
                    if (list.length == 1) {
                      return SizedBox(
                        width: 100.w,
                        child: Card(
                          color:
                              CommonFunctions.getReverseThemeBasedWidgetColor(
                            context,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              list.first.doorbellLocations?.name ?? "",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "Switches to Another Location:",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 10),
                        AppDropDownButton<UserDeviceModel>(
                          items: list,
                          selectedValue: doorbell,
                          onChanged: (newLocation) async {
                            if (newLocation?.doorbellLocations?.id !=
                                doorbell?.doorbellLocations?.id) {
                              Navigator.pop(dialogContext);

                              final startUpBloc = StartupBloc.of(context);
                              final iotBloc = IotBloc.of(context);
                              final visitorBloc =
                                  VisitorManagementBloc.of(context);
                              final notificationBloc =
                                  NotificationBloc.of(context);
                              // if (dialogContext.mounted) {
                              // }
                              startUpBloc.updateDashboardApiCalling(true);
                              unawaited(
                                apiService.updateDefaultLocation(
                                  locationId:
                                      newLocation?.doorbellLocations?.id,
                                ),
                              );
                              startUpBloc.socketInitializing = false;
                              singletonBloc.socket?.emit(
                                "leaveRoom",
                                singletonBloc.profileBloc.state!
                                    .selectedDoorBell?.locationId
                                    .toString(),
                              );
                              await startUpBloc.callEverything(
                                id: newLocation?.doorbellLocations?.id,
                                isDismiss: false,
                              );
                              unawaited(startUpBloc.socketMethod());
                              unawaited(
                                iotBloc.callIotRoomsApi(
                                  needLoaderDismiss: false,
                                ),
                              );
                              await iotBloc.callIotApi(
                                needLoaderDismiss: false,
                              );
                              await iotBloc.socketListener();
                              unawaited(
                                Future.delayed(const Duration(seconds: 3), () {
                                  startUpBloc.updateDashboardApiCalling(false);
                                }),
                              );
                              unawaited(
                                visitorBloc.initialCall(isRefresh: true),
                              );
                              notificationBloc.updateFilter(false);
                              await notificationBloc.callStatusApi();
                              unawaited(
                                notificationBloc.callNotificationApi(
                                  refresh: true,
                                ),
                              );
                              visitorBloc.updateVisitorNewNotification(false);
                            }
                          },
                          displayDropDownItems: (item) =>
                              item.doorbellLocations!.name!,
                          buttonHeight: 6.h,
                          dropdownRadius: 10,
                          dropDownWidth: 70.w,
                          dropDownHeight: 22.h,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            CustomGradientButton(
              onSubmit: () {
                Navigator.pop(dialogContext);

                /// if subscription amount is 0 proceeds to onboarding url
                /// otherwise proceeds to upgrade/downgrade url
                if (subscription.amount == "00.00") {
                  CommonFunctions.openUrl(Constants.subscribeOnboardingUrl);
                } else {
                  CommonFunctions.openUrl(Constants.upgradeDowngradeUrl);
                }
              },
              label: context.appLocalizations.change_plan,
            ),
          ],
        ),
      ),
    );
  }
}
