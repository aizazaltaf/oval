import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/bulb_screen.dart';
import 'package:admin/pages/main/iot_devices/curtain_screen.dart';
import 'package:admin/pages/main/iot_devices/dialogs/delete_dialog.dart';
import 'package:admin/pages/main/iot_devices/dialogs/edit_name_dialog.dart';
import 'package:admin/pages/main/iot_devices/dialogs/move_dialog.dart';
import 'package:admin/pages/main/iot_devices/guides/three_dot_menu_guide.dart';
import 'package:admin/pages/main/iot_devices/lock_screen.dart';
import 'package:admin/pages/main/iot_devices/thermostat_screen.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

final _logger = Logger("room_all_devices.dart");

class RoomAllDevices extends StatefulWidget {
  const RoomAllDevices._({
    this.isEditRoom = false,
    this.isMoveRoom = false,
  });

  static const routeName = 'roomAllDevices';
  final bool isEditRoom;
  final bool isMoveRoom;

  static Future<void> push(
    final BuildContext context, {
    bool isEditRoom = false,
    bool isMoveRoom = false,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => RoomAllDevices._(
        isEditRoom: isEditRoom,
        isMoveRoom: isMoveRoom,
      ),
    );
  }

  @override
  State<RoomAllDevices> createState() => _RoomAllDevicesState();
}

class _RoomAllDevicesState extends State<RoomAllDevices> {
  final _superToolTipController = SuperTooltipController();

  final _superToolTipControllerRoom = SuperTooltipController();

  final threeDotMenuKey = GlobalKey();
  Timer? _debounceUsageCount;
  bool disconnectedFromHere = true;

  @override
  void initState() {
    //  implement initState
    super.initState();

    final IotBloc bloc = IotBloc.of(context);

    if (!bloc.state.threeDotMenuGuideShow) {
      if (singletonBloc.profileBloc.state?.guides == null ||
          singletonBloc.profileBloc.state?.guides?.threeDotMenuGuide == null ||
          singletonBloc.profileBloc.state?.guides?.threeDotMenuGuide == 0) {
        bloc.updateThreeDotMenuGuideShow(false);
      } else {
        bloc.updateThreeDotMenuGuideShow(true);
      }
    }
    if (widget.isEditRoom) {
      Future.delayed(const Duration(seconds: 1), () {
        if (singletonBloc.isViewer()) {
          ToastUtils.errorToast(
            (context.mounted ? context : context)
                .appLocalizations
                .viewer_cannot_edit_room,
          );
        } else {
          showDialog(
            context: context.mounted ? context : context,
            builder: (context) {
              return EditNameDialog(
                bloc: bloc,
                isNotRoom: false,
              );
            },
          );
        }
      });
    }

    if (widget.isMoveRoom) {
      Future.delayed(const Duration(seconds: 1), () {
        if (singletonBloc.isViewer()) {
          ToastUtils.errorToast(
            (context.mounted ? context : context)
                .appLocalizations
                .viewer_cannot_move_room,
          );
        } else {
          showDialog(
            context: context.mounted ? context : context,
            builder: (context) {
              return MoveDialog(
                bloc: bloc,
              );
            },
          ).then((val) {
            if (val != null) {
              if (val && context.mounted) {
                Navigator.pop(
                  context.mounted ? context : context,
                );
              }
            }
          });
        }
      });
    }
  }

  final carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);
    return IotBlocSelector(
      selector: (state) => state.threeDotMenuGuideShow,
      builder: (guideShow) {
        return ShowCaseWidget(
          builder: (_) => Builder(
            builder: (innerContext) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                if (!guideShow) {
                  ShowCaseWidget.of(innerContext).startShowCase(
                    [
                      threeDotMenuKey,
                    ],
                  );
                }
              });

              return AppScaffold(
                decorated: true,
                // appTitle: bloc.state.selectedRoom!.roomName,
                appBar: AppBar(
                  leading: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: AppColors.darkBlueColor,
                      size: 30,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  title: IotBlocSelector.selectedRoom(
                    builder: (room) {
                      // if (room?.roomName == null) {
                      //   bloc
                      //     ..callIotApi()
                      //     ..callIotRoomsApi();
                      //   Navigator.pop(context);
                      // }
                      return Text(
                        room?.roomName ?? "",
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: AppColors.darkBlueColor,
                                ),
                      );
                    },
                  ),
                  bottom: CommonFunctions.noInternetBar(context),
                  centerTitle: true,
                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SuperTooltip(
                        arrowTipDistance: 20,
                        arrowLength: 8,
                        arrowTipRadius: 6,
                        shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
                        backgroundColor:
                            CommonFunctions.getThemePrimaryLightWhiteColor(
                          context,
                        ),
                        borderColor: Colors.white,
                        barrierColor: Colors.transparent,
                        shadowBlurRadius: 7,
                        shadowSpreadRadius: 0,
                        showBarrier: true,
                        controller: _superToolTipControllerRoom,
                        content: IntrinsicWidth(
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _superToolTipControllerRoom.hideTooltip();

                                    if (singletonBloc.isViewer()) {
                                      ToastUtils.errorToast(
                                        context.appLocalizations
                                            .viewer_cannot_edit_room,
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return EditNameDialog(
                                            bloc: bloc,
                                            isNotRoom: false,
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: SizedBox(
                                    width: 20.w,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          DefaultVectors.EDIT_SMART_DEVICES,
                                          height: 20,
                                          width: 20,
                                          colorFilter: ColorFilter.mode(
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
                                          context.appLocalizations.edit,
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const PopupMenuDivider(),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _superToolTipControllerRoom.hideTooltip();

                                    if (singletonBloc.isViewer()) {
                                      ToastUtils.errorToast(
                                        context.appLocalizations
                                            .viewer_cannot_delete_room,
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return DeleteDialog(
                                            bloc: bloc,
                                            isNotRoom: false,
                                          );
                                        },
                                      ).then((val) {
                                        if (val != null) {
                                          if (val && context.mounted) {
                                            ToastUtils.successToast(
                                              context.appLocalizations
                                                  .room_deleted,
                                            );
                                            Navigator.pop(context);
                                          }
                                        }
                                      });
                                    }
                                  },
                                  child: SizedBox(
                                    width: 20.w,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          DefaultVectors.DELETE_SMART_DEVICES,
                                          height: 20,
                                          width: 20,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          context
                                              .appLocalizations.general_delete,
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        child: Icon(
                          CupertinoIcons.gear_big,
                          color: AppColors.darkBlueColor,
                        ),
                      ),
                    ),
                  ],
                ),
                body: ((bloc.state.inRoomIotDeviceModel?.length ?? 0) != 0)
                    ? IotBlocSelector.inRoomIotDeviceModel(
                        builder: (device) {
                          if (device == null) {
                            Navigator.pop(context);
                            return const SizedBox.shrink();
                          } else if (device.isEmpty) {
                            Navigator.pop(context);
                            return const SizedBox.shrink();
                          }
                          if (bloc.state.selectedIotIndex >=
                              (bloc.state.inRoomIotDeviceModel?.length ?? 0)) {
                            bloc.updateSelectedIotIndex(
                              (device.length) - 1,
                            );
                          }
                          return IotBlocSelector.selectedIotIndex(
                            builder: (index) {
                              if (index >= (device.length)) {
                                bloc.updateSelectedIotIndex(
                                  (device.length) - 1,
                                );
                                return const SizedBox.shrink();
                              }
                              return Column(
                                children: [
                                  CarouselSlider.builder(
                                    carouselController: carouselController,
                                    itemCount: bloc.state.inRoomIotDeviceModel
                                            ?.length ??
                                        0,
                                    itemBuilder: (context, index, realIndex) {
                                      return GestureDetector(
                                        onTap: () {
                                          bloc.updateSelectedIotIndex(index);
                                          carouselController.animateToPage(
                                            index,
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            curve: Curves.easeInOutCirc,
                                          );
                                        },
                                        child: getRoomIotDeviceCarouselWidget(
                                          index: index,
                                          bloc: bloc,
                                        ),
                                      );
                                    },
                                    options: CarouselOptions(
                                      height: 90,
                                      initialPage: bloc.state.selectedIotIndex,
                                      enableInfiniteScroll: false,
                                      viewportFraction: 0.3,
                                      onPageChanged: (index, reason) {
                                        bloc
                                            // ..withDebounceUpdateWhenDeviceUnreachable()
                                            .updateSelectedIotIndex(index);
                                        _debounceUsageCount?.cancel();
                                        _debounceUsageCount = Timer(
                                            const Duration(seconds: 1), () {
                                          unawaited(
                                            bloc.updateIotDeviceUsageCount(
                                              bloc
                                                  .state
                                                  .inRoomIotDeviceModel![bloc
                                                      .state.selectedIotIndex]
                                                  .id,
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        /// Was Row Hamza asked me to make Stack
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IotBlocSelector(
                                              selector: (state) {
                                                // Add bounds checking in the selector itself
                                                if (state.inRoomIotDeviceModel ==
                                                        null ||
                                                    state.selectedIotIndex >=
                                                        state
                                                            .inRoomIotDeviceModel!
                                                            .length) {
                                                  return null;
                                                }
                                                return state
                                                    .inRoomIotDeviceModel![
                                                        state.selectedIotIndex]
                                                    .deviceName;
                                              },
                                              builder: (name) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 20,
                                                  ),
                                                  child: SizedBox(
                                                    width: 70.w,
                                                    child: Text(
                                                      name ?? "",
                                                      maxLines: 2,
                                                      textAlign: TextAlign.left,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineLarge
                                                          ?.copyWith(
                                                            color: AppColors
                                                                .darkBlueColor,
                                                          ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            Showcase.withWidget(
                                              key: threeDotMenuKey,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              targetBorderRadius:
                                                  BorderRadius.circular(20),
                                              tooltipPosition:
                                                  TooltipPosition.bottom,
                                              container: ThreeRoomDotGuide(
                                                innerContext: innerContext,
                                                bloc: bloc,
                                              ),
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  right: 10,
                                                ),
                                                child: SuperTooltip(
                                                  arrowTipDistance: 20,
                                                  arrowLength: 8,
                                                  arrowTipRadius: 6,
                                                  shadowColor:
                                                      const Color.fromRGBO(
                                                    0,
                                                    0,
                                                    0,
                                                    0.1,
                                                  ),
                                                  backgroundColor: CommonFunctions
                                                      .getThemePrimaryLightWhiteColor(
                                                    context,
                                                  ),
                                                  borderColor: Colors.white,
                                                  barrierColor:
                                                      Colors.transparent,
                                                  shadowBlurRadius: 7,
                                                  shadowSpreadRadius: 0,
                                                  showBarrier: true,
                                                  controller:
                                                      _superToolTipController,
                                                  content: IntrinsicWidth(
                                                    child: IntrinsicHeight(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          GestureDetector(
                                                            behavior:
                                                                HitTestBehavior
                                                                    .opaque,
                                                            onTap: () {
                                                              _superToolTipController
                                                                  .hideTooltip();

                                                              if (singletonBloc
                                                                  .isViewer()) {
                                                                ToastUtils
                                                                    .errorToast(
                                                                  context
                                                                      .appLocalizations
                                                                      .viewer_cannot_edit_device,
                                                                );
                                                              } else {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return EditNameDialog(
                                                                      bloc:
                                                                          bloc,
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                            },
                                                            child: SizedBox(
                                                              width: 20.w,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    DefaultVectors
                                                                        .EDIT_SMART_DEVICES,
                                                                    height: 20,
                                                                    width: 20,
                                                                    colorFilter:
                                                                        ColorFilter
                                                                            .mode(
                                                                      CommonFunctions
                                                                          .getThemeBasedWidgetColor(
                                                                        context,
                                                                      ),
                                                                      BlendMode
                                                                          .srcIn,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Text(
                                                                    context
                                                                        .appLocalizations
                                                                        .edit,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: Theme
                                                                            .of(
                                                                      context,
                                                                    )
                                                                        .textTheme
                                                                        .bodyMedium,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const PopupMenuDivider(),
                                                          GestureDetector(
                                                            behavior:
                                                                HitTestBehavior
                                                                    .opaque,
                                                            onTap: () {
                                                              _superToolTipController
                                                                  .hideTooltip();

                                                              if (singletonBloc
                                                                  .isViewer()) {
                                                                ToastUtils
                                                                    .errorToast(
                                                                  context
                                                                      .appLocalizations
                                                                      .viewer_cannot_move_room,
                                                                );
                                                              } else {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return MoveDialog(
                                                                      bloc:
                                                                          bloc,
                                                                    );
                                                                  },
                                                                ).then((val) {
                                                                  if (val !=
                                                                      null) {
                                                                    if (val &&
                                                                        context
                                                                            .mounted) {
                                                                      Navigator
                                                                          .pop(
                                                                        context,
                                                                      );
                                                                    }
                                                                  }
                                                                });
                                                              }
                                                            },
                                                            child: SizedBox(
                                                              width: 20.w,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    DefaultVectors
                                                                        .MOVE_SMART_DEVICES,
                                                                    height: 20,
                                                                    width: 20,
                                                                    colorFilter:
                                                                        ColorFilter
                                                                            .mode(
                                                                      CommonFunctions
                                                                          .getThemeBasedWidgetColor(
                                                                        context,
                                                                      ),
                                                                      BlendMode
                                                                          .srcIn,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Text(
                                                                    context
                                                                        .appLocalizations
                                                                        .move,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: Theme
                                                                            .of(
                                                                      context,
                                                                    )
                                                                        .textTheme
                                                                        .bodyMedium,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const PopupMenuDivider(),
                                                          GestureDetector(
                                                            behavior:
                                                                HitTestBehavior
                                                                    .opaque,
                                                            onTap: () {
                                                              _superToolTipController
                                                                  .hideTooltip();

                                                              if (singletonBloc
                                                                  .isViewer()) {
                                                                ToastUtils
                                                                    .errorToast(
                                                                  context
                                                                      .appLocalizations
                                                                      .viewer_cannot_delete_device,
                                                                );
                                                              } else {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return DeleteDialog(
                                                                      bloc:
                                                                          bloc,
                                                                    );
                                                                  },
                                                                ).then((val) {
                                                                  if (val !=
                                                                      null) {
                                                                    if (val &&
                                                                        context
                                                                            .mounted) {
                                                                      Navigator
                                                                          .pop(
                                                                        context,
                                                                      );
                                                                    }
                                                                  }
                                                                });
                                                              }
                                                            },
                                                            child: SizedBox(
                                                              width: 20.w,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    DefaultVectors
                                                                        .DELETE_SMART_DEVICES,
                                                                    height: 20,
                                                                    width: 20,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Text(
                                                                    context
                                                                        .appLocalizations
                                                                        .general_delete,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: Theme
                                                                            .of(
                                                                      context,
                                                                    )
                                                                        .textTheme
                                                                        .bodyMedium,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.more_vert_outlined,
                                                    color:
                                                        AppColors.darkBlueColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Expanded(
                                          child: StartupBlocSelector
                                              .isInternetConnected(
                                            builder: (isConnected) {
                                              _logger.info(isConnected);
                                              if (!isConnected &&
                                                  disconnectedFromHere) {
                                                disconnectedFromHere = false;
                                                bloc.updateDeviceStateWhenInternetDisconnected();
                                              } else if (isConnected &&
                                                  !disconnectedFromHere) {
                                                disconnectedFromHere = true;
                                                bloc.updateDeviceStateWhenInternetConnected();
                                              }
                                              return getWidget(
                                                bloc
                                                    .state
                                                    .inRoomIotDeviceModel![
                                                        index]
                                                    .entityId!,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          context.appLocalizations.no_device_available,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
              );
            },
          ),
        );
      },
    );
  }

  Widget getRoomIotDeviceCarouselWidget({
    required int index,
    required IotBloc bloc,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(15),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: index == bloc.state.selectedIotIndex
                ? AppColors.enabledColorButton
                : [
                    CommonFunctions.getThemeWidgetColor(
                      context,
                    ),
                    CommonFunctions.getThemeWidgetColor(
                      context,
                    ),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child:
            bloc.state.inRoomIotDeviceModel![index].entityId!.isSwitchBotBlind()
                ? Image.asset(
                    DefaultVectors.BLIND_OPEN_ICON,
                    color: index == bloc.state.selectedIotIndex
                        ? Colors.white
                        : AppColors.disabledColorButton,
                  )
                :
                // bloc.state.inRoomIotDeviceModel![index].entityId!
                //             .isSwitchBotCurtain()
                //         ? Image.asset(
                //             DefaultVectors.CURTAIN_OPEN,
                //             color: index == bloc.state.selectedIotIndex
                //                 ? Colors.white
                //                 : AppColors.disabledColorButton,
                //           )
                //         :
                SvgPicture.asset(
                    bloc.state.inRoomIotDeviceModel![index].imagePreview!,
                    colorFilter: ColorFilter.mode(
                      index == bloc.state.selectedIotIndex
                          ? Colors.white
                          : AppColors.disabledColorButton,
                      BlendMode.srcIn,
                    ),
                  ),
      ),
    );
  }

  Widget getWidget(String entityId) {
    final data = entityId.split(".").first;
    final bloc = IotBloc.of(context);

    final device =
        bloc.state.inRoomIotDeviceModel![bloc.state.selectedIotIndex];
    switch (data) {
      case Constants.climate:
        return ThermostatScreen(
          key: Key(device.entityId!),
          device: device,
        );

      case Constants.light:
        return BulbScreen(
          key: Key(device.entityId!),
          device: device,
        );

      case Constants.curtain:
        return CurtainScreen(
          device: device,
          key: Key(device.entityId!),
        );

      case Constants.smartLock:
        return LockScreen(
          key: Key(device.entityId!),
          device: device,
        );

      default:
        return BulbScreen(
          key: Key(device.entityId!),
          device: device,
        );
    }
  }
}
