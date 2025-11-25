import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/models/data/room_items_model.dart';
import 'package:admin/pages/main/iot_devices/add_room.dart';
import 'package:admin/pages/main/iot_devices/auto_scanner_page.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/components/room_widget.dart';
import 'package:admin/pages/main/iot_devices/components/theremostat_card.dart';
import 'package:admin/pages/main/iot_devices/iot_device.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:admin/pages/main/iot_devices/room_all_devices.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/loading_widget.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ViewAllDevices extends StatefulWidget {
  const ViewAllDevices._();

  static const routeName = 'viewAllDevices';

  static Future<void> push(final BuildContext context, {bool isRoom = true}) {
    final bloc = IotBloc.of(context);
    // if (singletonBloc.profileBloc.state!.locationId != null) {
    if (singletonBloc.profileBloc.state!.selectedDoorBell?.locationId != null) {
      bloc
        ..callIotRoomsApi()
        ..updateViewAllDevicesScreenIsRoom(isRoom);
      // if (bloc.needIotStatesCall()) {
      //   bloc.withDebounceUpdateWhenDeviceUnreachable();
      // }
    }
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const ViewAllDevices._(),
    );
  }

  static Future<void> pushUntil(final BuildContext context) {
    final bloc = IotBloc.of(context);
    // if (singletonBloc.profileBloc.state!.locationId != null) {
    if (singletonBloc.profileBloc.state!.selectedDoorBell?.locationId != null) {
      bloc
        ..updateViewAllDevicesScreenIsRoom(true)
        ..callIotRoomsApi()
        ..callIotApi();
    }
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const ViewAllDevices._(),
    );
  }

  @override
  State<ViewAllDevices> createState() => _ViewAllDevicesState();
}

class _ViewAllDevicesState extends State<ViewAllDevices> {
  @override
  void initState() {
    super.initState();
    final IotBloc bloc = IotBloc.of(context);

    if (singletonBloc.profileBloc.state?.guides == null ||
        singletonBloc.profileBloc.state?.guides?.manageDevicesGuide == null ||
        singletonBloc.profileBloc.state?.guides?.manageDevicesGuide == 0) {
      bloc.updateManageDevicesGuideShow(false);
    } else {
      bloc.updateManageDevicesGuideShow(true);
    }
  }

  BuiltList<String?> getMostIotDevices(BuiltList<IotDeviceModel> iotDevices) {
    final sortedDevices = iotDevices
        .where(
          (device) => (!(device.entityId!.contains("camera") ||
                  device.entityId!.contains("climate")) &&
              // singletonBloc.profileBloc.state!.locationId.toString() ==
              singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
                      .toString() ==
                  device.locationId.toString() &&
              !device.entityId!.isHub()),
        )
        .toList()
      ..sort((a, b) => b.usageCount.compareTo(a.usageCount));
    return sortedDevices
        .map((device) => device.entityId)
        .take(4)
        .toList()
        .toBuiltList();
  }

  BuiltList<String?> getIotDevicesWithoutThermostat(
    BuiltList<IotDeviceModel> iotDevices,
  ) {
    final sortedDevices = iotDevices
        .where(
          (device) => (!(device.entityId!.contains("camera") ||
                  device.entityId!.contains("climate")) &&
              // singletonBloc.profileBloc.state!.locationId.toString() ==
              singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
                      .toString() ==
                  device.locationId.toString() &&
              !device.entityId!.isHub()),
        )
        .toList()
      ..sort((a, b) => b.usageCount.compareTo(a.usageCount));
    return sortedDevices
        .map((device) => device.entityId)
        .toList()
        .toBuiltList();
  }

  bool checkIOTDevices(BuiltList<IotDeviceModel> iotDevices) {
    final List<IotDeviceModel> sortingDevices = iotDevices
        .where(
          (element) =>
              !(element.entityId!.split('.').first.contains('camera') ||
                  element.entityId!.split('.').first.contains('climate')) &&
              // singletonBloc.profileBloc.state!.locationId.toString() ==
              singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
                      .toString() ==
                  element.locationId.toString(),
        )
        .toList();

    return sortingDevices.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);
    return AppScaffold(
      appTitle: context.appLocalizations.smart_devices,
      floatingActionButton: GestureDetector(
        onTap: () {
          if (bloc.state.viewAllDevicesScreenIsRoom) {
            if (singletonBloc.isViewer()) {
              ToastUtils.errorToast(
                context.appLocalizations.viewer_cannot_add_room,
              );
            } else {
              bloc.resetRoomSelection();

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor:
                    CommonFunctions.getThemeBasedWidgetColorInverted(context),
                builder: (context) {
                  return const AddRoom();
                },
                showDragHandle: true,
              );
            }
          } else {
            if (singletonBloc.isViewer()) {
              ToastUtils.errorToast(
                context.appLocalizations.viewer_cannot_add_device,
              );
            } else {
              AutoScannerPage.push(context);
            }
          }
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          child: const Padding(
            padding: EdgeInsets.all(15),
            child: Icon(Icons.add, size: 25, color: Colors.white),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(
          context,
        ).cupertinoOverrideTheme!.barBackgroundColor,
        onRefresh: () {
          bloc.callIotRoomsApi();
          return bloc.callIotApi();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Showcase.withWidget(
              //   key: bloc.thermostatGuideKey,
              //   height: 400,
              //   width: MediaQuery.of(context).size.width,
              //   targetBorderRadius: BorderRadius.circular(20),
              //   tooltipPosition: TooltipPosition.bottom,
              //   container: ThermostatGuide(
              //     innerContext: innerContext,
              //     bloc: bloc,
              //   ),
              //   child:
              const ThermostatCard(),
              // ),
              IotBlocSelector.viewAllDevicesScreenIsRoom(
                builder: (isSelected) {
                  final List<String?> devicesString = [];
                  // final List<SuperTooltipController> controllers = [];

                  if (!isSelected) {
                    if (bloc.state.iotDeviceModel != null) {
                      devicesString.addAll(
                        getIotDevicesWithoutThermostat(
                          bloc.state.iotDeviceModel!,
                        ).toList(),
                      );

                      // controllers.addAll(
                      //   devicesString
                      //       .map((e) => SuperTooltipController())
                      //       .toList(),
                      // );
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 26,
                          children: [
                            headingWidget(
                              context,
                              context.appLocalizations.rooms,
                              isSelected,
                              true,
                              bloc,
                            ),
                            headingWidget(
                              context,
                              context.appLocalizations.devices,
                              !isSelected,
                              false,
                              bloc,
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.all(12),
                      //   height: 150,
                      //   child: Stack(
                      //     alignment: AlignmentDirectional.centerStart,
                      //     children: [
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: GestureDetector(
                      //     behavior: HitTestBehavior.opaque,
                      //     onTap: () {
                      //       if (singletonBloc.isViewer()) {
                      //         ToastUtils.errorToast(
                      //           context.appLocalizations
                      //               .viewer_cannot_add_room,
                      //         );
                      //       } else {
                      //         AddRoom.push(context);
                      //       }
                      //     },
                      //     child: Showcase.withWidget(
                      //       key: bloc.addRoomGuideKey,
                      //       height: MediaQuery.of(context).size.height,
                      //       width: MediaQuery.of(context).size.width,
                      //       container: AddRoomGuide(
                      //         innerContext: innerContext,
                      //         bloc: bloc,
                      //       ),
                      //       targetBorderRadius:
                      //           BorderRadius.circular(60),
                      //       tooltipPosition: TooltipPosition.top,
                      //       child: SvgPicture.asset(
                      //         DefaultIcons.PLUS_CIRCLE,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      if (isSelected)
                        IotBlocSelector(
                          selector: (state) => state.getIotRoomsApi.data,
                          builder: (data) {
                            return IotBlocSelector.getIotRoomsApi(
                              builder: (list) {
                                if (list.data == null ||
                                    (list.data?.isEmpty ?? true)) {
                                  return SizedBox(
                                    height: MediaQuery.of(
                                          context,
                                        ).size.height /
                                        2,
                                    child: Center(
                                      child: Text(
                                        context.appLocalizations.no_rooms,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    ),
                                  );
                                }
                                return GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5,
                                    // childAspectRatio: 1.5,
                                    mainAxisExtent: 15.h,
                                  ),
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(10),
                                  itemCount: list.data!.length,
                                  itemBuilder: (context, index) {
                                    final RoomItemsModel roomItemsModel =
                                        list.data![index];
                                    return GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        bloc.updateSelectedRoom(
                                          roomItemsModel,
                                        );
                                        RoomAllDevices.push(
                                          context,
                                        );
                                      },
                                      child: RoomWidget(
                                        roomName: roomItemsModel.roomName,
                                        images: roomItemsModel.image,
                                        color: roomItemsModel.color,
                                        svgColor: roomItemsModel.svgColor,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        )
                      // ],
                      // ),
                      // ),
                      else
                        IotBlocSelector.operateIotDeviceResponse(
                          builder: (justUpdate) {
                            return IotBlocSelector.iotDeviceModel(
                              builder: (data) {
                                final List<IotDeviceModel> devices = [];
                                for (int index = 0;
                                    index < devicesString.length;
                                    index++) {
                                  final device = devicesString[index];
                                  if (bloc.state.iotDeviceModel!.indexWhere(
                                        (element) =>
                                            element.entityId!.contains(device!),
                                      ) !=
                                      -1) {
                                    final IotDeviceModel iotDevice =
                                        bloc.state.iotDeviceModel!.elementAt(
                                      bloc.state.iotDeviceModel!.indexWhere(
                                        (element) =>
                                            element.entityId!.contains(device!),
                                      ),
                                    );
                                    devices.add(iotDevice);
                                  }
                                }
                                return Center(
                                  child:
                                      // Showcase.withWidget(
                                      //   key: bloc.recentDevicesGuideKey,
                                      //   height: MediaQuery.of(
                                      //     context,
                                      //   ).size.height,
                                      //   disposeOnTap: false,
                                      //   width: MediaQuery.of(
                                      //     context,
                                      //   ).size.width,
                                      // container: RecentDevicesGuide(
                                      //   innerContext: innerContext,
                                      //   bloc: bloc,
                                      // ),
                                      // targetBorderRadius:
                                      // BorderRadius.circular(
                                      //   20,
                                      // ),
                                      // tooltipPosition:
                                      // TooltipPosition.top,
                                      // child:
                                      gridWidget(
                                    bloc: bloc,
                                    context: context,
                                    devices: devices,
                                    // controllers: controllers,
                                  ),
                                  // ),
                                );
                              },
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        )
        // IotBlocSelector(
        //   selector: (state) => state.manageDevicesGuideShow,
        //   builder: (guideShow) {
        //     return
        //         //   ShowCaseWidget(
        //         //   builder: (_) => Builder(
        //         //     builder: (innerContext) {
        //         //       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //         //         if (bloc.state.iotDeviceModel != null) {
        //         //           if (bloc.state.iotDeviceModel!.isNotEmpty && !guideShow) {
        //         //             ShowCaseWidget.of(innerContext).startShowCase([
        //         //               bloc.addRoomGuideKey,
        //         //               bloc.thermostatGuideKey,
        //         //               bloc.addDeviceGuideKey,
        //         //               bloc.recentDevicesGuideKey,
        //         //             ]);
        //         //           }
        //         //         }
        //         //       });
        //         //       return ;
        //         //     },
        //         //   ),
        //         // )
        //
        //     ;
        //   },
        // ),
        ,
      ),
    );
  }

  Widget headingWidget(
    BuildContext context,
    String title,
    bool isSelected,
    bool value,
    IotBloc bloc,
  ) {
    return GestureDetector(
      onTap: () {
        bloc.updateViewAllDevicesScreenIsRoom(value);
      },
      child: Container(
        width: 35.w,
        // margin: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : CommonFunctions.getThemeBasedWidgetColorInverted(context),
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontSize: 18,
                    color: !isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget gridWidget({
    required BuildContext context,
    required IotBloc bloc,
    devices,
    controllers,
  }) {
    if (bloc.state.iotDeviceModel != null) {
      if (checkIOTDevices(bloc.state.iotDeviceModel!)) {
        return Container(
          padding: const EdgeInsets.all(6),
          margin: const EdgeInsets.only(top: 150),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                context.appLocalizations.recently_used,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                context.appLocalizations.listed_here,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        );
      }
      return IotBlocSelector.isAllStatesExecuted(
        builder: (isLoading) {
          return LoadingWidget(
            isLoading: isLoading,
            showCircularLoader: false,
            label: IotBlocSelector(
              selector: (state) =>
                  state.curtainApis.isApiInProgress ||
                  state.operateIotDeviceResponse.isSocketInProgress,
              builder: (isLoading) {
                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.2,
                        mainAxisExtent:
                            MediaQuery.of(context).size.height / 5.95,
                      ),
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(6),
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        final IotDeviceModel iotDevice = devices[index];
                        if (iotDevice.entityId?.split(".").first == "climate") {
                          return const SizedBox.shrink();
                        }
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            bloc
                              ..updateSelectedRoom(
                                bloc.state.getIotRoomsApi.data!
                                    .firstWhereOrNull(
                                  (e) => e.roomId == iotDevice.roomId,
                                ),
                              )
                              ..updateSelectedIotIndex(
                                bloc.state.inRoomIotDeviceModel!.indexWhere(
                                  (e) => e.id == iotDevice.id,
                                ),
                              );
                            controllers[index].hideTooltip();
                            RoomAllDevices.push(context);
                          },
                          child: SmartDevicesWidget(
                            deviceModel: iotDevice,
                            bloc: bloc,
                            // superTooltipController: controllers[index],
                          ),
                          // IotDeviceCard(
                          //   deviceItem: iotDevice,
                          //   onChanged: (val) async {
                          //     if (iotDevice.stateAvailable != 3) {
                          //       bloc.assignSelectedIndex(
                          //         iotDevice.entityId,
                          //         roomId: iotDevice.roomId,
                          //       );
                          //       if (!iotDevice.entityId!.isLock()) {
                          //         await bloc.operateIotDevice(
                          //           iotDevice.entityId,
                          //           iotDevice.stateAvailable == 1
                          //               ? Constants.turnOff
                          //               : Constants.turnOn,
                          //           brightness: iotDevice.brightness != 0
                          //               ? iotDevice.brightness.round()
                          //               : 255,
                          //           otherValues: iotDevice.brightness != 0
                          //               ? {
                          //                   if (iotDevice.entityId!.isBulb() &&
                          //                       iotDevice.stateAvailable != 1)
                          //                     "brightness":
                          //                         "${iotDevice.brightness.round()}",
                          //                 }
                          //               : null,
                          //           fromOutsideRoom: true,
                          //         );
                          //       } else {
                          //         await bloc.operateIotDevice(
                          //           iotDevice.entityId,
                          //           iotDevice.stateAvailable == 2
                          //               ? Constants.lock
                          //               : Constants.unlock,
                          //           fromOutsideRoom: true,
                          //           // ifNeededToUse: () async {
                          //           //   unawaited(EasyLoading.show());
                          //           //
                          //           //   await Future.delayed(
                          //           //     const Duration(seconds: 5),
                          //           //   );
                          //           //   bloc.withDebounceUpdateWhenDeviceUnreachable(
                          //           //     fromOutsideRoom: true,
                          //           //     entityId: iotDevice.entityId,
                          //           //   );
                          //           //   unawaited(EasyLoading.dismiss());
                          //           // },
                          //         );
                          //       }
                          //     }
                          //   },
                          // ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}
