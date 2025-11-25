import 'dart:convert';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/pages/main/dashboard/components/header_tiles.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/components/app_switch.dart';
import 'package:admin/pages/main/iot_devices/dialogs/delete_dialog.dart';
import 'package:admin/pages/main/iot_devices/dialogs/edit_name_dialog.dart';
import 'package:admin/pages/main/iot_devices/dialogs/move_dialog.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:admin/pages/main/iot_devices/room_all_devices.dart';
import 'package:admin/pages/main/iot_devices/view_all_devices.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_tooltip/super_tooltip.dart';

class SmartDevices extends StatelessWidget {
  const SmartDevices({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);
    return IotBlocSelector.iotDeviceModel(
      builder: (list) {
        if (list == null) {
          // return const ;
          return const Center(child: ButtonProgressIndicator());
        }
        Constants.dismissLoader();

        if (CommonFunctions.getIotFilteredList(list).isEmpty) {
          return const SizedBox.shrink();
        }
        // final List<SuperTooltipController> controllers = [
        //   ...CommonFunctions.getIotFilteredList(list)
        //       .map((e) => SuperTooltipController()),
        // ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HorizontalHeaderTitles(
              title: context.appLocalizations.smart_devices,
              pinnedOption: false,
              pinnedTitle: context.appLocalizations.smart,
              viewAllClick: () => ViewAllDevices.push(context),
              viewAllBool: CommonFunctions.getIotFilteredList(list).length > 3,
            ),
            const SizedBox(height: 10),
            CarouselSlider.builder(
              itemCount: CommonFunctions.getIotFilteredList(list).length > 3
                  ? 3
                  : CommonFunctions.getIotFilteredList(list).length,
              itemBuilder: (context, index, pageViewIndex) {
                // final controller = SuperTooltipController();
                return SmartDevicesWidget(
                  deviceModel: CommonFunctions.getIotFilteredList(list)[index],
                  bloc: bloc,
                  // superTooltipController: controllers[index],
                );
              },
              options: CarouselOptions(
                height: 160,
                aspectRatio: 1,
                viewportFraction: 0.55,
                enableInfiniteScroll: false,
                autoPlayInterval: const Duration(seconds: 3),
                disableCenter: true,
                padEnds: false,
                onPageChanged: (value, reason) {
                  // _currentIndex.value = value;
                },
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
          ],
        );
      },
    );
  }
}

class SmartDevicesWidget extends StatelessWidget {
  const SmartDevicesWidget({
    super.key,
    required this.deviceModel,
    required this.bloc,
    // required this.superTooltipController,
  });

  final IotBloc bloc;
  final IotDeviceModel deviceModel;

  // final SuperTooltipController superTooltipController;

  @override
  Widget build(BuildContext context) {
    final entityType = deviceModel.entityId?.split('.').first ?? '';
    final bool isDisabled = deviceModel.stateAvailable == 3;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        deviceModel.superTooltipController!.hideTooltip();
        bloc
          ..updateSelectedRoom(
            deviceModel.room,
          )
          ..updateSelectedIotIndex(
            bloc.state.inRoomIotDeviceModel!
                .indexWhere((e) => e.id == deviceModel.id),
          );
        RoomAllDevices.push(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Card(
          elevation: 1,
          shadowColor: Colors.grey,
          surfaceTintColor: Theme.of(context).appBarTheme.titleTextStyle!.color,
          color: isDisabled
              ? Colors.grey
              : Theme.of(context).appBarTheme.titleTextStyle!.color,
          child: Container(
            margin: const EdgeInsets.only(left: 5, top: 10),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                top: 12,
                right: 10,
                bottom: 6,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (deviceModel.entityId!.isSwitchBotBlind())
                        Image.asset(
                          DefaultVectors.BLIND_CLOSE,
                          color: AppColors.switchBotColor,
                          height: 30,
                          width: 30,
                        )
                      else
                        // deviceModel.entityId!.isSwitchBotCurtain()
                        //     ? Image.asset(
                        //         DefaultVectors.CURTAIN_OPEN,
                        //         color: AppColors.switchBotColor,
                        //         height: 30,
                        //         width: 30,
                        //       )
                        //     :
                        SvgPicture.asset(
                          deviceModel.imagePreview!,
                          height: 30,
                          // colorFilter: ColorFilter.mode(
                          //   CommonFunctions.getThemeBasedWidgetColor(context),
                          //   BlendMode.srcIn,
                          // ),
                          width: 30,
                        ),
                      if (entityType.isThermostat() ||
                          deviceModel.entityId!.isSwitchBotBlind())
                        const SizedBox.shrink()
                      else
                        IotBlocSelector.operateIotDeviceResponse(
                          builder: (justUpdateCurtain) {
                            return IotBlocSelector.operateIotDeviceResponse(
                              builder: (justUpdate) {
                                return AppSwitchWidget(
                                  thumbSize: 20,
                                  value: returnState(),
                                  text: returnText(),
                                  onChanged: (val) async {
                                    if (deviceModel.stateAvailable != 3) {
                                      bloc.assignSelectedIndex(
                                        deviceModel.entityId,
                                        roomId: deviceModel.roomId,
                                      );
                                      if (deviceModel.entityId!.isLock()) {
                                        if (deviceModel.stateAvailable == 2) {
                                          await bloc.operateIotDevice(
                                            deviceModel.entityId,
                                            Constants.lock,
                                            fromOutsideRoom: true,
                                          );
                                        }
                                        if (deviceModel.stateAvailable == 1) {
                                          await bloc.operateIotDevice(
                                            deviceModel.entityId,
                                            Constants.unlock,
                                            fromOutsideRoom: true,
                                          );
                                        }
                                      } else if (deviceModel.entityId!
                                          .isSwitchBot()) {
                                        // final json = jsonDecode(
                                        //   deviceModel.details?['extra_param'] ??
                                        //       "{}",
                                        // );
                                        //
                                        // await bloc.operateCurtain(
                                        //   deviceId:
                                        //       deviceModel.curtainDeviceId!,
                                        //   command: returnCurtainCommand(
                                        //     conditionForSwitchBot(),
                                        //   ),
                                        //   entityId: deviceModel.entityId!,
                                        //   parameter: "default",
                                        //   val: conditionForSwitchBot()
                                        //       ? 0.toString()
                                        //       : 100.toString(),
                                        //   callback: () async {
                                        //     // for (int i = 0; i < 10; i++) {
                                        //     //   if (position == 0 || !mounted) {
                                        //     //     break;
                                        //     //   }
                                        //     //   setState(() {
                                        //     //     position = (position - 10) >= 0 ? position - 10 : 0;
                                        //     //   });
                                        //     //   await Future.delayed(const Duration(milliseconds: 1));
                                        //     // }
                                        //   },
                                        //   token: json["api_token"],
                                        //   secret: json['api_key'],
                                        //   fromOutsideRoom: true,
                                        // );
                                        final json = jsonDecode(
                                          deviceModel.details?['extra_param'] ??
                                              "{}",
                                        );

                                        // Read current position safely (0=open, 100=closed per SwitchBot API)
                                        final rawPos = double.tryParse(
                                              deviceModel.curtainPosition ?? "",
                                            ) ??
                                            0.0;
                                        final isClosed = rawPos >=
                                            50.0; // threshold; adjust if needed

                                        // If user taps toggle, we invert: closed → open, open → closed
                                        final targetClosed = !isClosed;

                                        await bloc.operateCurtain(
                                          deviceId:
                                              deviceModel.curtainDeviceId!,
                                          command: returnCurtainCommand(
                                            targetClosed,
                                          ),
                                          entityId: deviceModel.entityId!,
                                          parameter: "default",
                                          val: targetClosed ? "100" : "0",
                                          // universal 0=open, 100=closed
                                          token: json["api_token"],
                                          secret: json['api_key'],
                                          fromOutsideRoom: true,
                                        );
                                      } else {
                                        await bloc.operateIotDevice(
                                          deviceModel.entityId,
                                          deviceModel.stateAvailable == 1
                                              ? Constants.turnOff
                                              : Constants.turnOn,
                                          brightness: deviceModel.brightness !=
                                                  0
                                              ? deviceModel.brightness.round()
                                              : 255,
                                          otherValues:
                                              deviceModel.brightness != 0
                                                  ? {
                                                      if (deviceModel.entityId!
                                                              .isBulb() &&
                                                          deviceModel
                                                                  .stateAvailable !=
                                                              1)
                                                        "brightness":
                                                            "${deviceModel.brightness.round()}",
                                                    }
                                                  : null,
                                          fromOutsideRoom: true,
                                        );
                                      }
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                deviceModel.deviceName ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 14,
                                      color: CommonFunctions
                                          .getThemeBasedWidgetColor(context),
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                deviceModel.room?.roomName ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 14,
                                      // color: CommonFunctions
                                      //     .getThemeBasedWidgetColor(context),
                                      color: deviceModel.stateAvailable != 3
                                          ? Colors.grey
                                          : CommonFunctions
                                              .getThemeBasedWidgetColor(
                                              context,
                                            ),
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IotBlocSelector(
                            selector: (state) => state
                                .operateIotDeviceResponse.isSocketInProgress,
                            builder: (isLoading) {
                              // deviceModel.superTooltipController!.hideTooltip();
                              return IgnorePointer(
                                ignoring: isLoading,
                                child: SuperTooltip(
                                  key: ValueKey(deviceModel.entityId),
                                  arrowTipDistance: 20,
                                  popupDirectionBuilder: () {
                                    final screenSize =
                                        MediaQuery.of(context).size;
                                    final box = context.findRenderObject()!
                                        as RenderBox;
                                    final position =
                                        box.localToGlobal(Offset.zero);

                                    // Flip vertically if target is in lower half
                                    if (position.dy > screenSize.height / 2) {
                                      return TooltipDirection.up;
                                    } else {
                                      return TooltipDirection.down;
                                    }
                                  },
                                  arrowLength: 8,
                                  arrowTipRadius: 6,
                                  shadowColor:
                                      const Color.fromRGBO(0, 0, 0, 0.1),
                                  backgroundColor: CommonFunctions
                                      .getThemePrimaryLightWhiteColor(
                                    context,
                                  ),
                                  borderColor: Colors.white,
                                  barrierColor: Colors.transparent,
                                  shadowBlurRadius: 7,
                                  shadowSpreadRadius: 0,
                                  showBarrier: true,
                                  controller:
                                      deviceModel.superTooltipController,
                                  content: IntrinsicWidth(
                                    child: IntrinsicHeight(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              bloc
                                                ..updateSelectedRoom(
                                                  bloc.state.getIotRoomsApi
                                                      .data!
                                                      .firstWhereOrNull(
                                                    (e) =>
                                                        e.roomId ==
                                                        deviceModel.roomId,
                                                  ),
                                                )
                                                ..updateSelectedIotIndex(
                                                  bloc.state
                                                      .inRoomIotDeviceModel!
                                                      .indexWhere(
                                                    (e) =>
                                                        e.id ==
                                                        deviceModel.roomId,
                                                  ),
                                                );
                                              deviceModel
                                                  .superTooltipController!
                                                  .hideTooltip();
                                              bloc.assignSelectedIndex(
                                                deviceModel.entityId,
                                                roomId: deviceModel.roomId,
                                              );

                                              if (singletonBloc.isViewer()) {
                                                ToastUtils.errorToast(
                                                  context.appLocalizations
                                                      .viewer_cannot_edit_room,
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return EditNameDialog(
                                                      bloc: bloc,
                                                    );
                                                  },
                                                ).then(
                                                  (val) {
                                                    deviceModel
                                                        .superTooltipController!
                                                        .hideTooltip();
                                                  },
                                                );
                                              }
                                            },
                                            child: SizedBox(
                                              width: 20.w,
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    DefaultVectors
                                                        .EDIT_SMART_DEVICES,
                                                    height: 20,
                                                    width: 20,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      CommonFunctions
                                                          .getThemeBasedWidgetColor(
                                                        context,
                                                      ),
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    context
                                                        .appLocalizations.edit,
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const PopupMenuDivider(),
                                          GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              deviceModel
                                                  .superTooltipController!
                                                  .hideTooltip();
                                              bloc
                                                ..updateSelectedRoom(
                                                  bloc.state.getIotRoomsApi
                                                      .data!
                                                      .firstWhereOrNull(
                                                    (e) =>
                                                        e.roomId ==
                                                        deviceModel.roomId,
                                                  ),
                                                )
                                                ..updateSelectedIotIndex(
                                                  bloc.state
                                                      .inRoomIotDeviceModel!
                                                      .indexWhere(
                                                    (e) =>
                                                        e.id ==
                                                        deviceModel.roomId,
                                                  ),
                                                )
                                                ..assignSelectedIndex(
                                                  deviceModel.entityId,
                                                  roomId: deviceModel.roomId,
                                                );

                                              if (singletonBloc.isViewer()) {
                                                ToastUtils.errorToast(
                                                  context.appLocalizations
                                                      .viewer_cannot_move_room,
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return MoveDialog(
                                                      bloc: bloc,
                                                    );
                                                  },
                                                ).then(
                                                  (val) {
                                                    deviceModel
                                                        .superTooltipController!
                                                        .hideTooltip();
                                                  },
                                                );
                                              }
                                            },
                                            child: SizedBox(
                                              width: 20.w,
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    DefaultVectors
                                                        .MOVE_SMART_DEVICES,
                                                    height: 20,
                                                    width: 20,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      CommonFunctions
                                                          .getThemeBasedWidgetColor(
                                                        context,
                                                      ),
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    context
                                                        .appLocalizations.move,
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const PopupMenuDivider(),
                                          GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              deviceModel
                                                  .superTooltipController!
                                                  .hideTooltip();
                                              bloc
                                                ..updateSelectedRoom(
                                                  bloc.state.getIotRoomsApi
                                                      .data!
                                                      .firstWhereOrNull(
                                                    (e) =>
                                                        e.roomId ==
                                                        deviceModel.roomId,
                                                  ),
                                                )
                                                ..updateSelectedIotIndex(
                                                  bloc.state
                                                      .inRoomIotDeviceModel!
                                                      .indexWhere(
                                                    (e) =>
                                                        e.id ==
                                                        deviceModel.roomId,
                                                  ),
                                                )
                                                ..assignSelectedIndex(
                                                  deviceModel.entityId,
                                                  roomId: deviceModel.roomId,
                                                );

                                              if (singletonBloc.isViewer()) {
                                                ToastUtils.errorToast(
                                                  context.appLocalizations
                                                      .viewer_cannot_delete_device,
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return DeleteDialog(
                                                      bloc: bloc,
                                                    );
                                                  },
                                                ).then(
                                                  (val) {
                                                    deviceModel
                                                        .superTooltipController!
                                                        .hideTooltip();
                                                  },
                                                );
                                              }
                                            },
                                            child: SizedBox(
                                              width: 20.w,
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    DefaultVectors
                                                        .DELETE_SMART_DEVICES,
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    context.appLocalizations
                                                        .general_delete,
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.more_vert_outlined,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // String returnCurtainCommand(bool toDo) {
  //   if (toDo) {
  //     return deviceModel.entityId!.isSwitchBotBlind() ? "closeUp" : "turnOn";
  //   } else {
  //     return deviceModel.entityId!.isSwitchBotBlind() ? "closeDown" : "turnOff";
  //   }
  // }
  String returnCurtainCommand(bool targetClosed) {
    if (deviceModel.entityId!.isSwitchBotBlind()) {
      // Blind Tilt
      return targetClosed ? "closeUp" : "fullyOpen";
    } else {
      // Curtain / Curtain 3
      return targetClosed ? "turnOff" : "turnOn";
    }
  }

  //
  // bool returnState() {
  //   if (deviceModel.entityId?.isLock() ?? false) {
  //     return deviceModel.stateAvailable == 1;
  //   } else if (deviceModel.entityId?.isSwitchBot() ?? false) {
  //     return !(double.parse(deviceModel.curtainPosition ?? 0.toString()) >= 0);
  //   } else {
  //     return deviceModel.stateAvailable == 1;
  //   }
  // }
  //
  // String returnText() {
  //   String status = "";
  //   if (deviceModel.entityId?.isLock() ?? false) {
  //     if (deviceModel.stateAvailable == 1) {
  //       status = "Locked";
  //     } else {
  //       status = "Unlocked";
  //     }
  //   } else if (deviceModel.entityId?.isSwitchBot() ?? false) {
  //     if (deviceModel.stateAvailable == 1) {
  //       if (double.parse(deviceModel.curtainPosition ?? 0.toString()) >= 0) {
  //         status = "Closed";
  //       } else {
  //         status = "Opened";
  //       }
  //     } else {
  //       status = "Closed";
  //     }
  //   } else {
  //     if (deviceModel.stateAvailable == 1) {
  //       status = "On";
  //     } else {
  //       status = "Off";
  //     }
  //   }
  //   return status;
  // }
  bool returnState() {
    final entityId = deviceModel.entityId;

    if (entityId?.isSwitchBot() ?? false) {
      // Parse curtain/slide position safely
      final rawPos = double.tryParse(deviceModel.curtainPosition ?? "") ?? 0.0;

      // For Curtain / Curtain 3 / Roller Shade:
      // 0 = open, 100 = closed → consider closed if >= 50
      final isClosed = rawPos >= 50.0;

      // Toggle should be ON when closed
      return isClosed;
    }

    if (entityId?.isLock() ?? false) {
      return deviceModel.stateAvailable == 1;
    }

    // Default case for bulbs / switches
    return deviceModel.stateAvailable == 1;
  }

  String returnText() {
    final entityId = deviceModel.entityId;

    if (entityId?.isSwitchBot() ?? false) {
      final rawPos = double.tryParse(deviceModel.curtainPosition ?? "") ?? 0.0;
      final isClosed = rawPos >= 50.0;

      if (deviceModel.stateAvailable == 1) {
        return isClosed ? "Closed" : "Opened";
      } else {
        // When offline/unavailable → show "Closed" (fallback)
        return "Closed";
      }
    }

    if (entityId?.isLock() ?? false) {
      return deviceModel.stateAvailable == 1 ? "Locked" : "Unlocked";
    }

    // Default
    return deviceModel.stateAvailable == 1 ? "On" : "Off";
  }

  bool conditionForSwitchBot() {
    final rawPos = double.tryParse(deviceModel.curtainPosition ?? "") ?? 0.0;
    // True = Closed, False = Open
    return rawPos >= 50.0;
  }
}
