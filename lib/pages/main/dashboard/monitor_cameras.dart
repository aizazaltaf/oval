import 'dart:async';
import 'dart:typed_data';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/bloc/states/startup_state.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/main/dashboard/cameras/view_all_camera.dart';
import 'package:admin/pages/main/dashboard/components/header_tiles.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/notifications/notification_builder.dart';
import 'package:admin/pages/main/notifications/notification_page.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/components/blur_overlay_live_stream.dart';
import 'package:admin/pages/main/voip/streaming_page.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/list_view_seperated.dart';
import 'package:admin/widgets/smooth_memory_image.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bugfender/flutter_bugfender.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MonitorCameras extends StatelessWidget {
  const MonitorCameras({super.key});

  BuiltList<UserDeviceModel> getListLength(StartupState state) {
    return state.userDeviceModel!
        .where(
          (x) =>
              x.locationId ==
              singletonBloc.profileBloc.state!.selectedDoorBell!.locationId,
        )
        .toBuiltList();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = StartupBloc.of(context);
    return StartupBlocBuilder(
      builder: (context, state) {
        if (singletonBloc.profileBloc.state?.selectedDoorBell == null) {
          return const SizedBox.shrink();
        }
        return StartupBlocSelector.refreshSnapshots(
          builder: (snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HorizontalHeaderTitles(
                  title: context.appLocalizations.monitor_cameras,
                  pinnedOption: false,
                  viewAllClick: () async {
                    unawaited(ViewAllCamera.push(context));
                    CommonFunctions.isNoInternetConnectionDialogShown = false;
                  },
                  pinnedTitle: context.appLocalizations.monitor,
                  viewAllBool: getListLength(state).length > 3,
                ),
                const SizedBox(height: 5),
                IotBlocSelector.iotDeviceModel(
                  builder: (list) {
                    final bool hasSmartDevices =
                        CommonFunctions.getIotFilteredList(list).isNotEmpty;
                    if (!hasSmartDevices) {
                      return ListViewSeparatedWidget(
                        controller: ScrollController(),
                        list: getListLength(state).length > 3
                            ? getListLength(state).sublist(0, 3)
                            : getListLength(state),
                        itemBuilder: (context, index) {
                          return MonitorCamerasWidget(
                            deviceModel: getListLength(state)[index],
                            length: getListLength(state).length,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                      );
                    } else {
                      return CarouselSlider.builder(
                        itemCount: getListLength(state).length > 3
                            ? 3
                            : getListLength(state).length,
                        itemBuilder: (context, index, pageViewIndex) {
                          return Column(
                            children: [
                              MonitorCamerasWidget(
                                deviceModel: getListLength(state)[index],
                                length: getListLength(state).length,
                              ),
                              if (!hasSmartDevices)
                                const SizedBox(height: 10)
                              else
                                const SizedBox.shrink(),
                            ],
                          );
                        },
                        options: CarouselOptions(
                          height: 270,
                          aspectRatio: 1,
                          initialPage: bloc.state.monitorCamerasCarouselIndex,
                          viewportFraction:
                              getListLength(state).length == 1 ? 1 : 0.85,
                          enableInfiniteScroll: false,
                          autoPlayInterval: const Duration(seconds: 3),
                          disableCenter: true,
                          padEnds: false,
                          onPageChanged: (index, reason) {
                            bloc.updateMonitorCamerasCarouselIndex(index);
                          },
                        ),
                      );
                    }
                  },
                ),
                IotBlocSelector.iotDeviceModel(
                  builder: (list) {
                    if (CommonFunctions.getIotFilteredList(list).isNotEmpty) {
                      return SizedBox(height: 2.h);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                IotBlocSelector.iotDeviceModel(
                  builder: (list) {
                    if (CommonFunctions.getIotFilteredList(list).isNotEmpty) {
                      if (getListLength(state).length == 1) {
                        return const SizedBox.shrink();
                      } else {
                        return Align(
                          child: StartupBlocSelector(
                            selector: (state) =>
                                state.monitorCamerasCarouselIndex,
                            builder: (index) {
                              return AnimatedSmoothIndicator(
                                activeIndex: index,
                                count: getListLength(state).length > 3
                                    ? 3
                                    : getListLength(state).length,
                                effect: const ExpandingDotsEffect(
                                  expansionFactor: 1.8,
                                  dotHeight: 6,
                                  dotWidth: 30,
                                  activeDotColor:
                                      AppColors.darkBluePrimaryColor,
                                  dotColor: Color.fromRGBO(189, 189, 189, 1),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class MonitorCamerasWidget extends StatelessWidget {
  const MonitorCamerasWidget({
    super.key,
    required this.deviceModel,
    required this.length,
    this.needPinIcon,
    this.pinValue,
  });

  final bool? needPinIcon;
  final bool? pinValue;
  final UserDeviceModel deviceModel;
  final int length;

  @override
  Widget build(BuildContext context) {
    final sp = GetStorage();
    var imageValue = sp.read("imageValue[${deviceModel.callUserId}]");
    if (imageValue != null && imageValue is List) {
      imageValue = Uint8List.fromList(imageValue.map((e) => e as int).toList());
    }
    final bloc = StartupBloc.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final v = VoipBloc.of(context);
        unawaited(v.streamingPeerConnection?.dispose());
        v.streamingPeerConnection = null;
        CommonFunctions.isNoInternetConnectionDialogShown = true;
        unawaited(
          StreamingPage.push(
            context,
            deviceModel.callUserId,
            deviceModel.id,
            imageValue: imageValue,
          ).then((c) {
            singletonBloc.removeInstance();
            CommonFunctions.isNoInternetConnectionDialogShown = false;
            if (!bloc.state.dashboardApiCalling) {
              // EasyLoading.show();
              Constants.showLoader();
            }
            Future.delayed(
              const Duration(seconds: 1),
              bloc.updateMonitorCamerasSnapshots,
            );
            // Future.delayed(const Duration(seconds: 2), EasyLoading.dismiss);
            Future.delayed(const Duration(seconds: 3), () {
              final navigatorState = singletonBloc.navigatorKey?.currentState;
              if (navigatorState != null) {
                final context = navigatorState.context;
                try {
                  if (context.mounted) {
                    VoiceControlBloc.of(context).reinitializeWakeWord(context);
                  }
                } catch (e) {
                  FlutterBugfender.sendIssue(
                    "Reinitializing WakeWord from MonitorCameras",
                    e.toString(),
                  );
                }
              }
            });
            Future.delayed(const Duration(seconds: 2), Constants.dismissLoader);
            // Future.delayed(const Duration(milliseconds: 1500), () {
            //   unawaited(v.streamingPeerConnection?.dispose());
            //   v.streamingPeerConnection = null;
            // });
          }),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Card(
          elevation: 1,
          shadowColor: Colors.transparent,
          surfaceTintColor: Theme.of(context).appBarTheme.titleTextStyle!.color,
          color: Theme.of(context).appBarTheme.titleTextStyle!.color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 57,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Row(
                      children: [
                        // Horizontal Flip
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..scale(-1.0, 1),
                          child: Icon(
                            MdiIcons.cctv,
                            size: 26,
                            color: CommonFunctions.getThemeBasedWidgetColor(
                              context,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        SizedBox(
                          width: 45.w,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            deviceModel.name ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        if (needPinIcon == true)
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (bloc.state.monitorCameraPinnedList.length ==
                                      3 &&
                                  pinValue == false) {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return AppDialogPopup(
                                      headerWidget: Image.asset(
                                        DefaultImages.INFO_IMAGE,
                                        height: 120,
                                        width: 160,
                                      ),
                                      title: context.appLocalizations.warning,
                                      description: context.appLocalizations
                                          .three_cameras_warning,
                                      confirmButtonLabel:
                                          context.appLocalizations.okay,
                                      confirmButtonOnTap: () {
                                        Navigator.pop(dialogContext);
                                      },
                                    );
                                  },
                                );
                              } else {
                                bloc.updateMonitorCameraPinnedList(
                                  pinValue == true
                                      ? bloc.state.monitorCameraPinnedList
                                          .rebuild(
                                          (a) => a.remove(
                                            deviceModel.isExternalCamera == true
                                                ? deviceModel.entityId
                                                    .toString()
                                                : deviceModel.deviceId
                                                    .toString(),
                                          ),
                                        )
                                      : bloc.state.monitorCameraPinnedList
                                          .rebuild(
                                          (a) => a.insert(
                                            0,
                                            deviceModel.isExternalCamera == true
                                                ? deviceModel.entityId
                                                    .toString()
                                                : deviceModel.deviceId
                                                    .toString(),
                                          ),
                                        ),
                                );
                                final String quotedCameras = bloc
                                    .state.monitorCameraPinnedList
                                    .map((item) => item)
                                    .join(',');
                                singletonBloc.getBox.write(
                                  Constants.pinnedCameras,
                                  quotedCameras,
                                );
                              }
                            },
                            child: (pinValue == true)
                                ? Icon(MdiIcons.pin, size: 26)
                                : Icon(MdiIcons.pinOutline, size: 26),
                          ),
                        const SizedBox(width: 15),
                        NotificationBlocSelector.notificationDeviceStatus(
                          builder: (data) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () async {
                                final bloc = NotificationBloc.of(context)
                                  ..updateFilter(true)
                                  ..updateDeviceId(
                                    deviceModel.isExternalCamera == true
                                        ? deviceModel.entityId.toString()
                                        : deviceModel.deviceId ?? "",
                                  );
                                unawaited(
                                  bloc.callNotificationApi(
                                    refresh: true,
                                    isExternalCamera:
                                        deviceModel.isExternalCamera == true,
                                  ),
                                );
                                unawaited(
                                  NotificationPage.push(
                                    context,
                                    forDevice: true,
                                  ),
                                );
                              },
                              child: NotificationBuilder(
                                status: (data == null
                                        ? false
                                        : deviceModel.isExternalCamera == true
                                            ? data[deviceModel.entityId]
                                            : data[deviceModel.deviceId]) ??
                                    false,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 205,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: Curves.easeIn,
                        switchOutCurve: Curves.easeOut,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          child: (deviceModel.isStreaming != null &&
                                  deviceModel.isStreaming == 0)
                              ? getStreamingOffline(
                                  context: context,
                                  title:
                                      "${deviceModel.isExternalCamera ?? false ? 'Camera' : 'Doorbell'} is offline",
                                )
                              : (deviceModel.image == null ||
                                      deviceModel.image!.isEmpty)
                                  ? Image.asset(
                                      DefaultImages.FRONT_CAMERA_THUMBNAIL,
                                      fit: BoxFit.cover,
                                      width: 100.w,
                                      height: 205,
                                    )
                                  : imageValue == null
                                      ? CachedNetworkImage(
                                          imageUrl: "${deviceModel.image}",
                                          useOldImageOnUrlChange: true,
                                          errorWidget:
                                              (context, exception, stackTrace) {
                                            return Image.asset(
                                              DefaultImages
                                                  .FRONT_CAMERA_THUMBNAIL,
                                              fit: BoxFit.cover,
                                              width: 100.w,
                                              height: 205,
                                            );
                                          },
                                          fit: BoxFit.cover,
                                          height: 205,
                                          width: 100.w,
                                        )
                                      : SmoothMemoryImage(
                                          newImageBytes: imageValue,
                                        ),
                        ),
                      ),
                    ),
                    // Hide Play Button when Streaming is 0 only
                    if (!(deviceModel.isStreaming != null &&
                        deviceModel.isStreaming == 0))
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.black54,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getStreamingOffline({
    required BuildContext context,
    required String title,
  }) {
    return BlurOverlayLiveStream(
      background: Image.asset(
        DefaultImages.FRONT_CAMERA_THUMBNAIL,
        fit: BoxFit.cover,
        width: 100.w,
        height: 205,
      ),
      overlay: SizedBox(
        // color: Theme.of(context).tabBarTheme.indicatorColor,
        height: 205,
        width: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              DefaultIcons.DOORBELL_OFFLINE,
              colorFilter: ColorFilter.mode(
                Theme.of(context).cupertinoOverrideTheme!.barBackgroundColor!,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context)
                    .cupertinoOverrideTheme!
                    .barBackgroundColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
