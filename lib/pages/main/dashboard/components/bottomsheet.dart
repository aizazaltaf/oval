import 'dart:async';

import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/main/device_onboarding/bluetooth_scan_page.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/services/api_service.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

class DisplayLocationBottomSheet extends StatelessWidget {
  DisplayLocationBottomSheet({super.key});

  final ScrollController c1 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StartupBlocSelector.doorbellApi(
      builder: (doorbellApi) {
        return ProfileBlocSelector.selectedDoorBell(
          builder: (doorbell) {
            return StartupBlocSelector.userDeviceModel(
              builder: (doorbellList) {
                if (doorbellList == null) {
                  return const SizedBox.shrink();
                }
                final List<UserDeviceModel> newList = doorbellList.toList();
                final ids = newList.map((e) => e.locationId).toSet();
                newList.retainWhere((x) => ids.remove(x.locationId));
                final BuiltList<UserDeviceModel> list = newList.toBuiltList();
                final selectedDoorbell =
                    singletonBloc.profileBloc.state?.selectedDoorBell;

                // if no doorbell is selected, just return empty UI safely
                if (selectedDoorbell?.doorbellLocations?.id == null) {
                  return const SizedBox.shrink();
                }

                final selectedIndex = list.indexWhere(
                  (element) =>
                      element.doorbellLocations?.id ==
                      selectedDoorbell?.doorbellLocations?.id,
                );

                if (selectedIndex == -1) {
                  return const SizedBox.shrink();
                }

                return ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 249),
                  child: (doorbellApi.isApiInProgress)
                      ? const Center(child: CircularProgressIndicator())
                      : RawScrollbar(
                          thumbColor: Theme.of(context).secondaryHeaderColor,
                          trackColor: Colors.white,
                          trackBorderColor: Colors.white,
                          controller: c1,
                          thumbVisibility: true,
                          trackVisibility: true,
                          interactive: true,
                          thickness: 4,
                          padding: const EdgeInsets.only(right: 20),
                          radius: const Radius.circular(34),
                          child: ListView.builder(
                            controller: c1,
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              if (index == list.length - 1) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    radioListTile(
                                      index,
                                      selectedIndex,
                                      list,
                                      context,
                                    ),
                                    TextButton(
                                      // behavior: HitTestBehavior.opaque,
                                      style: const ButtonStyle(
                                        overlayColor: WidgetStatePropertyAll(
                                          Colors.transparent,
                                        ),
                                        splashFactory: NoSplash.splashFactory,
                                        padding: WidgetStatePropertyAll(
                                          EdgeInsets.zero,
                                        ),
                                      ),
                                      onPressed: () {
                                        // ScanDoorbell.push(context);
                                        BluetoothScanPage.push(context);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 26,
                                          bottom: 15,
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .secondaryHeaderColor,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: "  ",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              TextSpan(
                                                text: "Add New Doorbell",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .secondaryHeaderColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return radioListTile(
                                index,
                                selectedIndex,
                                list,
                                context,
                              );
                            },
                          ),
                        ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget radioListTile(
    int index,
    int selectedIndex,
    BuiltList<UserDeviceModel> list,
    BuildContext context,
  ) {
    if (list[index].entityId != null) {
      return const SizedBox.shrink();
    }
    return RadioListTile<int>(
      value: index,
      activeColor: Theme.of(context).textTheme.titleMedium!.color,
      groupValue: selectedIndex,
      onChanged: (value) async {
        final startUpBloc = StartupBloc.of(context);
        final iotBloc = IotBloc.of(context);
        final visitorBloc = VisitorManagementBloc.of(context);
        final notificationBloc = NotificationBloc.of(context);
        if (context.mounted) {
          Navigator.pop(context);
        }
        unawaited(
          apiService.updateDefaultLocation(
            locationId: list[value ?? 0].locationId,
          ),
        );
        // unawaited(EasyLoading.show());
        startUpBloc.socketInitializing = false;
        singletonBloc.socket?.emit(
          "leaveRoom",
          // singletonBloc.profileBloc.state!.locationId,
          singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
              .toString(),
        );

        // singletonBloc.socket?.emit("joinRoom", {
        //   // "room": singletonBloc.profileBloc.state!.locationId,
        //   "room": list[value!].locationId
        //       .toString(),
        //   "device_id": await CommonFunctions.getDeviceModel(),
        // });
        startUpBloc.updateDashboardApiCalling(true);
        await startUpBloc.callEverything(
          id: list[value!].locationId,
          isDismiss: false,
        );
        unawaited(startUpBloc.socketMethod());
        unawaited(iotBloc.callIotRoomsApi(needLoaderDismiss: false));
        await iotBloc.callIotApi(needLoaderDismiss: false);
        await iotBloc.socketListener();
        unawaited(
          Future.delayed(const Duration(seconds: 3), () {
            startUpBloc.updateDashboardApiCalling(false);
          }),
        );
        // unawaited(EasyLoading.dismiss());
        unawaited(visitorBloc.initialCall(isRefresh: true));
        notificationBloc.updateFilter(false);
        await notificationBloc.callStatusApi();
        unawaited(notificationBloc.callNotificationApi(refresh: true));
        visitorBloc.updateVisitorNewNotification(false);
      },
      title: Text(
        list[index].doorbellLocations!.name.toString(),
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        "${list[index].doorbellLocations!.houseNo}, "
        "${list[index].doorbellLocations!.street}, "
        "${list[index].doorbellLocations!.city}, "
        "${list[index].doorbellLocations!.state}, "
        "${list[index].doorbellLocations!.country}",
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 13, fontWeight: FontWeight.w300),
      ),
    );
  }
}
