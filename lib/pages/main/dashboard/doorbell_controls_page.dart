import 'dart:async';
import 'dart:convert';

import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/main/dashboard/components/ai_alert_preferences_dialog.dart';
import 'package:admin/pages/main/dashboard/components/camera_settings_tile.dart';
import 'package:admin/pages/main/dashboard/main_dashboard.dart';
import 'package:admin/pages/main/device_onboarding/bloc/device_onboarding_bloc.dart';
import 'package:admin/pages/main/device_onboarding/wifi_list_page.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/components/app_switch.dart';
import 'package:admin/pages/main/iot_devices/dialogs/move_dialog.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/components/profile_otp_page.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/app_drop_down_button.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/loading_widget.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:admin/widgets/validate_password_dialog.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DoorbellControlsPage extends StatefulWidget {
  const DoorbellControlsPage({
    super.key,
    required this.doorbellId,
    this.entityId,
    this.isCamera = false,
    this.fromVoice = false,
    this.isEditing = false,
    this.isDelete = false,
    this.forMove = false,
  });

  final int doorbellId;
  final String? entityId;
  final bool isCamera;
  final bool fromVoice;
  final bool forMove;
  final bool isDelete;
  final bool isEditing;

  static const routeName = "doorbellControls";

  static Future<void> push(
    final BuildContext context,
    int doorbellId, {
    bool isCamera = false,
    String? entityId,
    bool forMove = false,
    bool fromVoice = false,
    bool isDelete = false,
    bool isEditing = false,
  }) {
    StartupBloc.of(context).doorbellControlScreenInitialize();
    DeviceOnboardingBloc.of(context).updateConnectedSsid(null);
    DeviceOnboardingBloc.of(context).updateWifiNetworks(BuiltList());
    DeviceOnboardingBloc.of(context).updateCheckDoorbellWifiConnection(true);
    DeviceOnboardingBloc.of(context).getWifiList();
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => DoorbellControlsPage(
        doorbellId: doorbellId,
        isCamera: isCamera,
        fromVoice: fromVoice,
        isDelete: isDelete,
        entityId: entityId,
        forMove: forMove,
        isEditing: isEditing,
      ),
    );
  }

  @override
  State<DoorbellControlsPage> createState() => _DoorbellControlsPageState();
}

class _DoorbellControlsPageState extends State<DoorbellControlsPage> {
  @override
  void initState() {
    // implement initState
    super.initState();
    final bloc = StartupBloc.of(context);
    final iotBloc = IotBloc.of(context)
      ..updateCanOpenBottomSheetFormOnStreaming(false);

    // Initialize Notification Settings
    final UserDeviceModel? doorbell = bloc.state.userDeviceModel!
        .singleWhereOrNull((e) => e.id == widget.doorbellId);
    bloc.getAiAlertPreferences(doorbell?.callUserId ?? "", widget.isCamera);

    if (widget.fromVoice) {
      Future.delayed(const Duration(seconds: 1), () {
        final bloc = StartupBloc.of(context.mounted ? context : context);
        final bool isCamera = widget.isCamera;
        final BuiltList<UserDeviceModel> filterDoorbells = getListLength(bloc);
        final UserDeviceModel? doorbell = bloc.state.userDeviceModel!
            .singleWhereOrNull((e) => e.id == widget.doorbellId);

        final int roleId = CommonFunctions.getRoleId(singletonBloc.getRole());
        if (singletonBloc.isViewer()) {
          ToastUtils.errorToast(
            !isCamera
                ? (context.mounted ? context : context)
                    .appLocalizations
                    .viewer_cannot_release_doorbell
                : (context.mounted ? context : context)
                    .appLocalizations
                    .viewer_cannot_delete_device,
          );
        } else if (filterDoorbells.length == 1 &&
            roleId == 3 &&
            !widget.isCamera) {
          showDialog(
            context: context.mounted ? context : context,
            builder: adminCannotReleaseDoorbellDialog,
          );
        } else {
          if (!isCamera) {
            showDialog(
              context: context.mounted ? context : context,
              builder: (innerContext) {
                return BlocProvider.value(
                  value: bloc,
                  child: StartupBlocSelector(
                    selector: (state) =>
                        state.releaseDoorbellApi.isApiInProgress,
                    builder: (isApiInProgress) {
                      return AppDialogPopup(
                        isConfirmButtonEnabled: !isApiInProgress,
                        title:
                            "${context.appLocalizations.are_sure_to_release_permanently}"
                            "\n${context.appLocalizations.action_will_delete_data} "
                            "device.",
                        cancelButtonLabel:
                            context.appLocalizations.general_cancel,
                        confirmButtonLabel:
                            context.appLocalizations.general_proceed,
                        cancelButtonOnTap: () {
                          if (!isApiInProgress) {
                            Navigator.pop(innerContext);
                          }
                        },
                        confirmButtonOnTap: () {
                          Navigator.pop(innerContext);
                          showDialog(
                            context: context,
                            builder: (validatePasswordContext) {
                              return ValidatePasswordDialog(
                                userProfileBloc: UserProfileBloc(),
                                successFunction: () {
                                  if (!isApiInProgress) {
                                    if (doorbell != null) {
                                      releaseDoorbellOTPCheck(
                                        context: context,
                                        doorbell: doorbell,
                                        filterDoorbells: filterDoorbells,
                                        bloc: bloc,
                                      );
                                    }
                                  }
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else {
            final blocIot = IotBloc.of(context.mounted ? context : context);
            showDialog(
              context: context.mounted ? context : context,
              builder: (context) {
                return deleteDevice(
                  bloc: blocIot,
                  context: context,
                  doorbell: doorbell,
                );
              },
            ).then((val) async {
              if (val != null) {
                if (val && context.mounted) {
                  unawaited(
                    MainDashboard.pushRemove(
                      context.mounted ? context : context,
                    ),
                  );
                  await bloc.callEverything();
                }
              }
            });
          }
        }
      });
    }
    if (widget.forMove) {
      Future.delayed(const Duration(seconds: 1), () {
        if (doorbell != null) {
          final IotDeviceModel camera = iotBloc.state.iotDeviceModel!
              .where(
                (iot) => iot.entityId == widget.entityId,
              )
              .first;
          showDialog(
            context: context.mounted ? context : context,
            builder: (dialogContext) {
              return MoveDialog(
                bloc: iotBloc,
                iotCamera: camera,
                cameraRoomId: camera.roomId,
              );
            },
          );
        }
      });
    }
    if (widget.isEditing) {
      Future.delayed(const Duration(seconds: 1), () {
        StartupBloc.of(context.mounted ? context : context)
            .updateDoorbellNameEdit(true);
        UserDeviceModel? dBell;
        if (widget.entityId == null) {
          dBell = bloc.state.userDeviceModel!
              .singleWhereOrNull((e) => e.id == widget.doorbellId);
        } else {
          dBell = bloc.state.userDeviceModel!.firstWhereOrNull(
            (e) => e.entityId == widget.entityId,
          );
        }
        showModalBottomSheet(
          context: context.mounted ? context : context,
          isScrollControlled: true,
          backgroundColor: CommonFunctions.getReverseThemeBasedWidgetColor(
            context.mounted ? context : context,
          ),
          showDragHandle: true,
          builder: (bottomSheetContext) {
            bloc.updateCanUpdateDoorbellName(false);
            return showEditBottomSheet(
              bottomSheetContext,
              bloc,
              dBell!,
            );
          },
        );
      });
    }
    if (widget.isDelete) {
      Future.delayed(const Duration(seconds: 1), () {
        final BuiltList<UserDeviceModel> filterDoorbells = getListLength(bloc);

        final int roleId = CommonFunctions.getRoleId(
          singletonBloc.getRole(),
        );
        if (singletonBloc.isViewer()) {
          ToastUtils.errorToast(
            !widget.isCamera
                ? (context.mounted ? context : context)
                    .appLocalizations
                    .viewer_cannot_release_doorbell
                : (context.mounted ? context : context)
                    .appLocalizations
                    .viewer_cannot_delete_device,
          );
        } else if (filterDoorbells.length == 1 &&
            roleId == 3 &&
            !widget.isCamera) {
          showDialog(
            context: (context.mounted ? context : context),
            builder: adminCannotReleaseDoorbellDialog,
          );
        } else {
          if (!widget.isCamera) {
            showDialog(
              context: (context.mounted ? context : context),
              builder: (innerContext) {
                return BlocProvider.value(
                  value: bloc,
                  child: StartupBlocSelector(
                    selector: (state) =>
                        state.releaseDoorbellApi.isApiInProgress,
                    builder: (isApiInProgress) {
                      return AppDialogPopup(
                        isConfirmButtonEnabled: !isApiInProgress,
                        title:
                            "${context.appLocalizations.are_sure_to_release_permanently}"
                            "\n${context.appLocalizations.action_will_delete_data} "
                            "device.",
                        cancelButtonLabel:
                            context.appLocalizations.general_cancel,
                        confirmButtonLabel:
                            context.appLocalizations.general_proceed,
                        cancelButtonOnTap: () {
                          if (!isApiInProgress) {
                            Navigator.pop(innerContext);
                          }
                        },
                        confirmButtonOnTap: () {
                          Navigator.pop(innerContext);
                          showDialog(
                            context: context,
                            builder: (validatePasswordContext) {
                              return ValidatePasswordDialog(
                                userProfileBloc: UserProfileBloc(),
                                successFunction: () {
                                  if (!isApiInProgress) {
                                    releaseDoorbellOTPCheck(
                                      context: context,
                                      doorbell: doorbell!,
                                      filterDoorbells: filterDoorbells,
                                      bloc: bloc,
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else {
            final blocIot = IotBloc.of(context.mounted ? context : context);
            showDialog(
              context: (context.mounted ? context : context),
              builder: (context) {
                return deleteDevice(
                  bloc: blocIot,
                  context: context,
                  doorbell: doorbell,
                );
              },
            ).then((val) async {
              if (val != null) {
                if (val && context.mounted) {
                  unawaited(
                    MainDashboard.pushRemove(
                      context.mounted ? context : context,
                    ),
                  );
                  await bloc.callEverything();
                  Future.delayed(const Duration(seconds: 10), () {
                    blocIot.callIotApi(clear: false);
                  });
                }
              }
            });
          }
        }
      });
    }

    if (widget.isCamera) {
      iotBloc.getAllStateDevicesWithSubDevices();
    }
  }

  BuiltList<UserDeviceModel> getListLength(StartupBloc bloc) {
    return bloc.state.userDeviceModel!
        .where(
          (x) =>
              x.locationId ==
                  singletonBloc
                      .profileBloc.state!.selectedDoorBell!.locationId &&
              x.entityId == null,
        )
        .toBuiltList();
  }

  Future<void> doorbellSuccessRelease(
    BuildContext context,
    int? anyOtherLocationId,
    doorbellId, {
    required bool needSelectedDoorbellNull,
  }) async {
    final startupBloc = StartupBloc.of(context);
    unawaited(
      singletonBloc.socketEmitter(
        roomName: Constants.doorbell,
        deviceId: doorbellId,
        request: Constants.doorbellRelease,
      ),
    );
    startupBloc.clearPageIndexes();
    if (needSelectedDoorbellNull) {
      ProfileBloc.of(context).updateSelectedDoorBellToNull();
    }
    // this is for switching for remaining on same location
    if (!needSelectedDoorbellNull && context.mounted) {
      unawaited(
        MainDashboard.pushRemove(
          context.mounted ? context : context,
        ),
      );
    }
    singletonBloc.socket?.emit(
      "leaveRoom",
      // singletonBloc.profileBloc.state!.locationId,
      singletonBloc.profileBloc.state!.selectedDoorBell?.locationId.toString(),
    );
    singletonBloc.joinRoom = false;

    await startupBloc.callEverything(id: anyOtherLocationId);
    // this is for switching for switching location
    if (needSelectedDoorbellNull && context.mounted) {
      startupBloc.updateDashboardApiCalling(true);
      unawaited(CommonFunctions.updateLocationData(context));
      unawaited(
        MainDashboard.pushRemove(
          context.mounted ? context : context,
        ),
      );
    } else {
      startupBloc.updateDashboardApiCalling(false);
    }
  }

  void successRelease(
    BuildContext context,
    UserDeviceModel doorbell,
    doorbellId,
  ) {
    final startupBloc = StartupBloc.of(context);
    int? anyOtherLocationId;
    try {
      bool hasAnyOtherDoorbellExist = false;
      final BuiltList<UserDeviceModel>? doorbells =
          startupBloc.state.userDeviceModel;
      for (int i = 0; i < doorbells!.length; i++) {
        if (doorbells[i].locationId == doorbell.locationId &&
            doorbells[i].deviceId != doorbell.deviceId &&
            doorbells[i].entityId == null) {
          hasAnyOtherDoorbellExist = true;
          break;
        }
      }
      if (!hasAnyOtherDoorbellExist) {
        anyOtherLocationId = startupBloc.state.userDeviceModel!
            .where(
              (element) =>
                  element.locationId != doorbell.doorbellLocations!.id &&
                  element.entityId == null,
            )
            .firstOrNull!
            .locationId;
      }
      doorbellSuccessRelease(
        context,
        hasAnyOtherDoorbellExist ? doorbell.locationId : anyOtherLocationId,
        doorbellId,
        needSelectedDoorbellNull: !hasAnyOtherDoorbellExist,
      );
    } catch (e) {
      doorbellSuccessRelease(
        context,
        anyOtherLocationId,
        doorbellId,
        needSelectedDoorbellNull: true,
      );
    }
  }

  Future<void> releaseDoorbellOTPCheck({
    required BuildContext context,
    required UserDeviceModel doorbell,
    required BuiltList<UserDeviceModel> filterDoorbells,
    required StartupBloc bloc,
  }) async {
    if (filterDoorbells.length == 1) {
      await ProfileOtpPage.push(
        context,
        otpFor: "release_doorbell",
        successReleaseTransferFunction: () {
          bloc.callReleaseDoorbell(
            successFunction: () {
              successRelease(context, doorbell, doorbell.deviceId);
            },
            successReleaseToast: () {
              ToastUtils.successToast(
                  "${doorbell.name} was released successfully "
                  "from ${doorbell.doorbellLocations?.name} location.");
            },
            doorbellId: doorbell.id,
          );
        },
      );
    } else {
      await bloc.callReleaseDoorbell(
        successFunction: () {
          successRelease(context, doorbell, doorbell.deviceId);
        },
        successReleaseToast: () {
          ToastUtils.successToast("${doorbell.name} was released successfully "
              "from ${doorbell.doorbellLocations?.name} location.");
        },
        doorbellId: doorbell.id,
      );
    }
  }

  Widget showEditBottomSheet(
    BuildContext bottomSheetContext,
    StartupBloc bloc,
    UserDeviceModel doorbell,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom, // shift up with keyboard
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            Text(
              "Edit ${widget.isCamera ? "Camera" : "Doorbell"} Name",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontWeight: FontWeight.w600, fontSize: 22),
            ),
            const SizedBox(height: 20),
            Text(
              "${widget.isCamera ? "Camera" : "Doorbell"} Name",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 20),
            NameTextFormField(
              autoFocus: true,
              prefix: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(-1.0, 1),
                child: Icon(MdiIcons.cctv),
              ),
              initialValue: doorbell.name,
              hintText: context.appLocalizations.name,
              onFieldSubmitted: (val) => editDeviceName(
                context: context,
                bottomSheetContext: bottomSheetContext,
                isEditing: true,
                bloc: bloc,
                doorbell: doorbell,
              ),
              onChanged: (val) {
                bloc.updateNewDoorbellName(val.trim());
                if (val.trim().isEmpty || val.length < 3) {
                  bloc.updateCanUpdateDoorbellName(false);
                } else if (val.trim() == doorbell.name) {
                  bloc.updateCanUpdateDoorbellName(false);
                } else {
                  bloc.updateCanUpdateDoorbellName(true);
                }
              },
              validator: (val) {
                return null;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z\s]'),
                ),
                // Allow alphabets & spaces
                LengthLimitingTextInputFormatter(
                  15,
                ),
                // Limit to 15 characters
              ],
            ),
            const SizedBox(height: 20),
            StartupBlocSelector.editDoorbellNameApi(
              builder: (editDoorbellApi) {
                return IotBlocSelector.editIotDevice(
                  builder: (editCameraApi) {
                    return StartupBlocSelector.canUpdateDoorbellName(
                      builder: (canUpdate) {
                        return CustomGradientButton(
                          isButtonEnabled: canUpdate,
                          isLoadingEnabled: editDoorbellApi.isApiInProgress ||
                              editCameraApi.isApiInProgress,
                          onSubmit: () => editDeviceName(
                            context: context,
                            bottomSheetContext: bottomSheetContext,
                            isEditing: true,
                            bloc: bloc,
                            doorbell: doorbell,
                          ),
                          label: context.appLocalizations.general_save,
                        );
                      },
                    );
                  },
                );
              },
            ),
            SizedBox(height: 5.5.h),
          ],
        ),
      ),
    );
  }

  Future<void> editDeviceName({
    required BuildContext context,
    required BuildContext bottomSheetContext,
    required bool isEditing,
    required StartupBloc bloc,
    required UserDeviceModel doorbell,
  }) async {
    if (isEditing &&
        bloc.state.newDoorbellName.isNotEmpty &&
        bloc.state.newDoorbellName.length >= 3 &&
        bloc.state.newDoorbellName.trim() != doorbell.name!.trim()) {
      final startupBloc = StartupBloc.of(context);

      final nameAllowed = startupBloc.state.userDeviceModel!.firstWhereOrNull(
        (e) =>
            e.locationId.toString() ==
                singletonBloc
                    // .profileBloc.state!.locationId
                    .profileBloc
                    .state!
                    .selectedDoorBell
                    ?.locationId
                    .toString() &&
            (bloc.state.newDoorbellName.toLowerCase() == e.name!.toLowerCase()),
      );
      if (nameAllowed == null) {
        final iotBloc = IotBloc.of(context);
        if (!widget.isCamera) {
          // await EasyLoading.show();
          await bloc.callEditDoorbellName(deviceId: doorbell.deviceId!);
          // await EasyLoading.dismiss();
        } else {
          // await EasyLoading.show();
          await iotBloc.editIotDevice(
            widget.doorbellId,
            bloc.state.newDoorbellName.trim(),
            doorbell.entityId,
            doorbell.roomId,
            () async {
              // await EasyLoading.dismiss();
              unawaited(bloc.callEverything());
            },
            camera: true,
          );
          // await EasyLoading.dismiss();
        }
      } else {
        ToastUtils.warningToast(
          !widget.isCamera
              ? context.appLocalizations.unique_doorbellName
              : context.appLocalizations.unique_cameraName,
        );
      }
    } else {
      bloc.updateNewDoorbellName(doorbell.name!);
    }
    bloc.updateDoorbellNameEdit(!isEditing);
    if (!isEditing) {
      bloc.updateCanUpdateDoorbellName(false);
    }
    if (bottomSheetContext.mounted) {
      Navigator.pop(bottomSheetContext);
    }
  }

  Map<String, dynamic>? subDevices;

  List<dynamic>? subDevicesEntities;

  bool isSleep(String input) {
    return input.contains("sleep");
  }

  bool isSetSystemDateAndTime(String input) {
    return input.contains("set_system_date_and_time");
  }

  bool isReboot(String input) {
    return input.contains("reboot");
  }

  bool isNumberEntity(String input) {
    final parts = input.split('.');
    return parts.isNotEmpty && parts.first == "number";
  }

  List<String> listForSecondBox = [];

  // String isLoadingEntity = "";

  @override
  Widget build(BuildContext context) {
    final bloc = StartupBloc.of(context);
    final iotBloc = IotBloc.of(context);
    final themeCardColor =
        CommonFunctions.getThemePrimaryLightWhiteColor(context);
    return StartupBlocSelector.userDeviceModel(
      builder: (model) {
        return IotBlocSelector(
          selector: (state) =>
              state.getAllDevicesWithSubDevices.isSocketInProgress ||
              state.iotApi.isApiInProgress,
          builder: (isLoading) {
            return IotBlocSelector.allDevicesWithSubDevices(
              builder: (data) {
                return StartupBlocSelector.doorbellNameEdit(
                  builder: (isEditing) {
                    UserDeviceModel? doorbell;
                    if (widget.entityId == null) {
                      doorbell = bloc.state.userDeviceModel!
                          .singleWhereOrNull((e) => e.id == widget.doorbellId);
                    } else {
                      doorbell = bloc.state.userDeviceModel!.firstWhereOrNull(
                        (e) => e.entityId == widget.entityId,
                      );
                    }

                    if (widget.isCamera) {
                      // isLoadingEntity = "";
                      if (data != null) {
                        final raw = jsonDecode(data.isEmpty ? "[]" : data);

                        final List<dynamic> decodedJson = (raw is List)
                            ? raw
                            : (raw is Map && raw.isNotEmpty ? [raw] : []);
                        subDevices = decodedJson.firstWhereOrNull(
                          (e) => e['entity_id'] == doorbell?.entityId,
                        );
                        subDevicesEntities = subDevices?["entities"];
                        subDevicesEntities =
                            subDevicesEntities?.where((subDevices) {
                          return CommonFunctions.containsAnyFromList(
                            subDevices['entity_id'],
                          );
                        }).toList();
                      }
                    }
                    if (doorbell == null) {
                      return const SizedBox.shrink();
                    }
                    return StartupBlocSelector(
                      selector: (state) => state.isInternetConnected,
                      builder: (isInternetConnected) {
                        final themeBasedWidgetColor = isInternetConnected
                            ? CommonFunctions.getThemeBasedWidgetColor(
                                context,
                              )
                            : Colors.grey;
                        return AppScaffold(
                          appTitle: widget.isCamera
                              ? context.appLocalizations.camera_controls
                              : context.appLocalizations.doorbell_controls,
                          body: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: [
                                SizedBox(height: 1.h),
                                CameraSettingTile(
                                  isCard: true,
                                  isDisabled: !isInternetConnected,
                                  leading: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..scale(-1.0, 1),
                                    child: widget.isCamera
                                        ? Icon(
                                            MdiIcons.cctv,
                                            size: 26,
                                            color: themeBasedWidgetColor,
                                          )
                                        : SvgPicture.asset(
                                            DefaultImages
                                                .DOORBELL_SETTINGS_ICON,
                                            width: 26,
                                            height: 26,
                                            colorFilter: ColorFilter.mode(
                                              themeBasedWidgetColor,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                  ),
                                  title: widget.isCamera
                                      ? context.appLocalizations.camera_name
                                      : context.appLocalizations.doorbell_name,
                                  subtitle: Text(
                                    doorbell?.name ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: isInternetConnected
                                              ? null
                                              : Colors.grey,
                                        ),
                                  ),
                                  trailing: IconButton(
                                    // behavior: HitTestBehavior.opaque,
                                    onPressed: () => showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: CommonFunctions
                                          .getReverseThemeBasedWidgetColor(
                                        context,
                                      ),
                                      showDragHandle: true,
                                      builder: (bottomSheetContext) {
                                        bloc.updateCanUpdateDoorbellName(
                                          false,
                                        );
                                        return showEditBottomSheet(
                                          bottomSheetContext,
                                          bloc,
                                          doorbell!,
                                        );
                                      },
                                    ),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    style: IconButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    icon: Icon(
                                      Icons.border_color_outlined,
                                      size: 20,
                                      color: themeBasedWidgetColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (!widget.isCamera)
                                  DeviceOnboardingBlocSelector
                                      .checkDoorbellWifiConnection(
                                    builder: (checkingWifi) {
                                      return DeviceOnboardingBlocSelector
                                          .connectedSSID(
                                        builder: (connectedWifiName) {
                                          return DeviceOnboardingBlocSelector
                                              .isDoorbellWifiConnected(
                                            builder: (wifiConnected) {
                                              return Card(
                                                color: themeCardColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    splashColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                  ),
                                                  child: ListTile(
                                                    onTap: () {
                                                      if (!checkingWifi) {
                                                        if (!wifiConnected) {
                                                          DeviceOnboardingBloc
                                                              .of(
                                                            context,
                                                          ).initializeBluetooth(
                                                            doorbellBluetoothName:
                                                                "${doorbell?.name}",
                                                          );
                                                        }
                                                        WifiListPage.push(
                                                          context,
                                                          fromDoorbellControlsPage:
                                                              true,
                                                          isDoorbellWifiConnected:
                                                              wifiConnected,
                                                        );
                                                      }
                                                    },
                                                    leading: Icon(
                                                      Icons.language,
                                                      color: checkingWifi
                                                          ? Colors.grey
                                                          : themeBasedWidgetColor,
                                                      size: 20,
                                                    ),
                                                    horizontalTitleGap: 20,
                                                    title: Text(
                                                      context.appLocalizations
                                                          .network_settings,
                                                      style:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .displayMedium
                                                              ?.copyWith(
                                                                color: isInternetConnected
                                                                    ? checkingWifi
                                                                        ? Colors.grey
                                                                        : null
                                                                    : Colors.grey,
                                                              ),
                                                    ),
                                                    subtitle:
                                                        connectedWifiName ==
                                                                null
                                                            ? null
                                                            : Text(
                                                                connectedWifiName,
                                                                style: Theme.of(
                                                                  context,
                                                                )
                                                                    .textTheme
                                                                    .displayMedium
                                                                    ?.copyWith(
                                                                      color: checkingWifi
                                                                          ? Colors
                                                                              .grey
                                                                          : Colors
                                                                              .green,
                                                                    ),
                                                              ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                const SizedBox(height: 10),
                                CameraSettingTile(
                                  onTap: () {
                                    bloc.setTempAiAlertPreferencesList();
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return AiAlertPreferencesDialog(
                                          device: doorbell!,
                                          startupBloc: bloc,
                                          isCamera: widget.isCamera,
                                          dialogContext: dialogContext,
                                        );
                                      },
                                    );
                                  },
                                  leading: SvgPicture.asset(
                                    DefaultIcons.NOTIFICATION_SETTINGS,
                                    colorFilter: ColorFilter.mode(
                                      themeBasedWidgetColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  isCard: true,
                                  isDisabled: !isInternetConnected,
                                  title: "Notifications Settings",
                                ),
                                const SizedBox(height: 10),
                                Card(
                                  color: themeCardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      if (!widget.isCamera) ...[
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                          ),
                                          child: ExpansionTile(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            expansionAnimationStyle:
                                                const AnimationStyle(
                                              curve: Curves.easeInOutCubic,
                                              reverseCurve:
                                                  Curves.easeInOutCubic,
                                              duration:
                                                  Duration(milliseconds: 400),
                                              reverseDuration:
                                                  Duration(milliseconds: 400),
                                            ),
                                            leading: Transform(
                                              alignment: Alignment.center,
                                              transform: Matrix4.identity()
                                                ..scale(-1.0, 1),
                                              child: SvgPicture.asset(
                                                DefaultIcons.IOT_BULB,
                                                colorFilter: ColorFilter.mode(
                                                  themeBasedWidgetColor,
                                                  BlendMode.srcIn,
                                                ),
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                            title: Text(
                                              context.appLocalizations
                                                  .light_settings,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium
                                                  ?.copyWith(
                                                    color: isInternetConnected
                                                        ? null
                                                        : Colors.grey,
                                                  ),
                                            ),
                                            children: [
                                              CameraSettingTile(
                                                title: "Edge Light",
                                                isDisabled:
                                                    !isInternetConnected,
                                                subtitle: Text(
                                                  "Turning this on will light up the doorbell edges when someone approaches or rings.",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Colors.grey,
                                                      ),
                                                ),
                                                trailing: AppSwitchWidget(
                                                  thumbSize: 18,
                                                  value:
                                                      doorbell?.edge ?? false,
                                                  onChanged: (val) {
                                                    bloc.updateLightState(
                                                      val,
                                                      doorbell!.deviceId,
                                                      message: {
                                                        "switch": val,
                                                      },
                                                      isEdge: true,
                                                    );
                                                    // singletonBloc.socketEmitter(
                                                    //   roomName: Constants.doorbell,
                                                    //   deviceId: doorbell.deviceId,
                                                    //   request: Constants.doorbellEdgeLight,
                                                    // );
                                                  },
                                                ),
                                              ),
                                              CameraSettingTile(
                                                title: "Night Lights",
                                                isDisabled:
                                                    !isInternetConnected,
                                                subtitle: Text(
                                                  "Turning this on will keep the doorbell area softly lit at night.",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Colors.grey,
                                                      ),
                                                ),
                                                trailing: AppSwitchWidget(
                                                  thumbSize: 18,
                                                  value:
                                                      doorbell?.flash ?? false,
                                                  onChanged: (val) {
                                                    bloc.updateLightState(
                                                      val,
                                                      doorbell!.deviceId,
                                                      message: {
                                                        "switch": val,
                                                      },
                                                    );
                                                    // singletonBloc.socketEmitter(
                                                    //   roomName: Constants.doorbell,
                                                    //   deviceId: doorbell.deviceId,
                                                    //   request: Constants.doorbellLuminousLight,
                                                    //   message: {"switch": val},
                                                    // );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ] else ...[
                                        cameraSettingWidget(
                                          context,
                                          doorbell!,
                                          isLoading,
                                          iotBloc,
                                          bloc,
                                          !isInternetConnected,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                if ((subDevicesEntities ?? []).any(
                                      (e) => isSetSystemDateAndTime(
                                        e['entity_id'],
                                      ),
                                    ) ||
                                    (subDevicesEntities ?? []).any(
                                      (e) => isSleep(e['entity_id']),
                                    ) ||
                                    (subDevicesEntities ?? [])
                                        .any((e) => isReboot(e['entity_id'])))
                                  const SizedBox(height: 10),
                                Card(
                                  color: themeCardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      if ((subDevicesEntities ?? []).any(
                                        (e) => isSetSystemDateAndTime(
                                          e['entity_id'],
                                        ),
                                      ))
                                        ListTile(
                                          leading: Icon(
                                            MdiIcons.calendarOutline,
                                            color: themeBasedWidgetColor,
                                          ),
                                          onTap: () {
                                            iotBloc.operateIotDevice(
                                              (subDevicesEntities ?? [])
                                                  .firstWhereOrNull(
                                                (e) => isSetSystemDateAndTime(
                                                  e['entity_id'],
                                                ),
                                              )['entity_id'],
                                              "button/press",
                                              fromControls: true,
                                              entityIdForControls:
                                                  doorbell!.entityId,
                                            );
                                          },
                                          title: Text(
                                            context.appLocalizations
                                                .set_system_date_and_time,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        )
                                      else
                                        const SizedBox(),
                                      if ((subDevicesEntities ?? []).any(
                                        (e) => isSleep(e['entity_id']),
                                      ))
                                        CameraSettingTile(
                                          leading: Icon(
                                            MdiIcons.sleep,
                                            color: themeBasedWidgetColor,
                                          ),
                                          isDisabled: !isInternetConnected,
                                          title: context.appLocalizations.sleep,
                                          trailing: AppSwitchWidget(
                                            thumbSize: 18,
                                            value: (subDevicesEntities ?? [])
                                                    .firstWhereOrNull(
                                                  (e) => isSleep(
                                                    e['entity_id'],
                                                  ),
                                                )['state'] ==
                                                'on',
                                            onChanged: (val) {
                                              iotBloc.operateIotDevice(
                                                (subDevicesEntities ?? [])
                                                    .firstWhereOrNull(
                                                  (e) => isSleep(
                                                    e['entity_id'],
                                                  ),
                                                )['entity_id'],
                                                "${(subDevicesEntities ?? []).firstWhereOrNull((e) => isSleep(e['entity_id']))['entity_id'].toString().split(".").first}/${(subDevicesEntities ?? []).firstWhereOrNull((e) => isSleep(e['entity_id']))['state'] == 'off' ? Constants.turnOnSimple : Constants.turnOffSimple}",
                                                fromControls: true,
                                                entityIdForControls:
                                                    doorbell!.entityId,
                                              );
                                            },
                                          ),
                                        )
                                      else
                                        const SizedBox(),
                                      if ((subDevicesEntities ?? []).any(
                                        (e) => isReboot(e['entity_id']),
                                      ))
                                        ListTile(
                                          leading: Icon(
                                            MdiIcons.restart,
                                            color: themeBasedWidgetColor,
                                          ),
                                          onTap: () {
                                            iotBloc.operateIotDevice(
                                              (subDevicesEntities ?? [])
                                                  .firstWhereOrNull(
                                                (e) => isReboot(
                                                  e['entity_id'],
                                                ),
                                              )['entity_id'],
                                              "button/press",
                                              fromControls: true,
                                              entityIdForControls:
                                                  doorbell!.entityId,
                                            );
                                          },
                                          title: Text(
                                            context.appLocalizations.reboot,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        )
                                      else
                                        const SizedBox(),
                                    ],
                                  ),
                                ),
                                if ((subDevicesEntities ?? []).any(
                                      (e) => isSetSystemDateAndTime(
                                        e['entity_id'],
                                      ),
                                    ) ||
                                    (subDevicesEntities ?? []).any(
                                      (e) => isSleep(e['entity_id']),
                                    ) ||
                                    (subDevicesEntities ?? [])
                                        .any((e) => isReboot(e['entity_id'])))
                                  const SizedBox(height: 10),
                                if (widget.isCamera)
                                  Card(
                                    color: themeCardColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: SizedBox(
                                      height: 50,
                                      child: ListTile(
                                        onTap: () {
                                          if (singletonBloc.isViewer()) {
                                            ToastUtils.errorToast(
                                              context.appLocalizations
                                                  .viewer_cannot_move_room,
                                            );
                                          } else {
                                            final IotDeviceModel camera =
                                                iotBloc.state.iotDeviceModel!
                                                    .where(
                                                      (iot) =>
                                                          iot.id ==
                                                          doorbell!.id,
                                                    )
                                                    .first;
                                            showDialog(
                                              context: context,
                                              builder: (dialogContext) {
                                                return MoveDialog(
                                                  bloc: iotBloc,
                                                  iotCamera: camera,
                                                  cameraRoomId:
                                                      doorbell!.roomId,
                                                );
                                              },
                                            );
                                          }
                                        },
                                        leading: Icon(
                                          Icons.keyboard_tab,
                                          color: themeBasedWidgetColor,
                                        ),
                                        title: Text(
                                          context.appLocalizations.move_camera,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium
                                              ?.copyWith(
                                                color: themeBasedWidgetColor,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    final BuiltList<UserDeviceModel>
                                        filterDoorbells = getListLength(bloc);

                                    final int roleId =
                                        CommonFunctions.getRoleId(
                                      singletonBloc.getRole(),
                                    );
                                    if (singletonBloc.isViewer()) {
                                      ToastUtils.errorToast(
                                        !widget.isCamera
                                            ? context.appLocalizations
                                                .viewer_cannot_release_doorbell
                                            : context.appLocalizations
                                                .viewer_cannot_delete_device,
                                      );
                                    } else if (filterDoorbells.length == 1 &&
                                        roleId == 3 &&
                                        !widget.isCamera) {
                                      showDialog(
                                        context: context,
                                        builder:
                                            adminCannotReleaseDoorbellDialog,
                                      );
                                    } else {
                                      if (!widget.isCamera) {
                                        showDialog(
                                          context: context,
                                          builder: (innerContext) {
                                            return BlocProvider.value(
                                              value: bloc,
                                              child: StartupBlocSelector(
                                                selector: (state) => state
                                                    .releaseDoorbellApi
                                                    .isApiInProgress,
                                                builder: (isApiInProgress) {
                                                  return AppDialogPopup(
                                                    isConfirmButtonEnabled:
                                                        !isApiInProgress,
                                                    title:
                                                        "${context.appLocalizations.are_sure_to_release_permanently}"
                                                        "\n${context.appLocalizations.action_will_delete_data} "
                                                        "device.",
                                                    cancelButtonLabel: context
                                                        .appLocalizations
                                                        .general_cancel,
                                                    confirmButtonLabel: context
                                                        .appLocalizations
                                                        .general_proceed,
                                                    cancelButtonOnTap: () {
                                                      if (!isApiInProgress) {
                                                        Navigator.pop(
                                                          innerContext,
                                                        );
                                                      }
                                                    },
                                                    confirmButtonOnTap: () {
                                                      Navigator.pop(
                                                        innerContext,
                                                      );
                                                      showDialog(
                                                        context: context,
                                                        builder:
                                                            (validatePasswordContext) {
                                                          return ValidatePasswordDialog(
                                                            userProfileBloc:
                                                                UserProfileBloc(),
                                                            successFunction:
                                                                () {
                                                              if (!isApiInProgress) {
                                                                releaseDoorbellOTPCheck(
                                                                  context:
                                                                      context,
                                                                  doorbell:
                                                                      doorbell!,
                                                                  filterDoorbells:
                                                                      filterDoorbells,
                                                                  bloc: bloc,
                                                                );
                                                              }
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        final blocIot = IotBloc.of(context);
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return deleteDevice(
                                              bloc: blocIot,
                                              context: context,
                                              doorbell: doorbell,
                                            );
                                          },
                                        ).then((val) async {
                                          if (val != null) {
                                            if (val && context.mounted) {
                                              unawaited(
                                                MainDashboard.pushRemove(
                                                  context.mounted
                                                      ? context
                                                      : context,
                                                ),
                                              );
                                              await bloc.callEverything();
                                              Future.delayed(
                                                  const Duration(seconds: 10),
                                                  () {
                                                blocIot.callIotApi(
                                                  clear: false,
                                                );
                                              });
                                            }
                                          }
                                        });
                                      }
                                    }
                                  },
                                  child: Card(
                                    color: themeCardColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete_outline,
                                            color: isInternetConnected
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 16),
                                          Text(
                                            !widget.isCamera
                                                ? context.appLocalizations
                                                    .release_doorbell
                                                : context.appLocalizations
                                                    .remove_camera,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium
                                                ?.copyWith(
                                                  color: isInternetConnected
                                                      ? Colors.red
                                                      : Colors.grey,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  List<String> position = ["Indoor", "Outdoor"];

  Theme cameraSettingWidget(
    BuildContext context,
    UserDeviceModel doorbell,
    bool isLoading,
    IotBloc iotBloc,
    StartupBloc bloc,
    bool isDisabled,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        leading: SvgPicture.asset(
          DefaultIcons.CAMERA_VIDEO,
          colorFilter: ColorFilter.mode(
            isDisabled
                ? Colors.grey
                : CommonFunctions.getThemeBasedWidgetColor(
                    context,
                  ),
            BlendMode.srcIn,
          ),
        ),
        expansionAnimationStyle: const AnimationStyle(
          curve: Curves.easeInOutCubic,
          reverseCurve: Curves.easeInOutCubic,
          duration: Duration(milliseconds: 400),
          reverseDuration: Duration(milliseconds: 400),
        ),
        title: Text(
          context.appLocalizations.camera_controls,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: isDisabled ? Colors.grey : null,
              ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        children: [
          if ((jsonDecode(
                    doorbell.details ?? "{}",
                  )["placement"] ??
                  "")
              .toString()
              .isNotEmpty)
            GestureDetector(
              onTap: () {
                iotBloc.updateSelectedFormPosition(
                  jsonDecode(
                    doorbell.details!,
                  )["placement"],
                );

                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        30,
                      ),
                      topRight: Radius.circular(
                        30,
                      ),
                    ),
                  ),
                  backgroundColor:
                      CommonFunctions.getReverseThemeBasedWidgetColor(
                    context,
                  ),
                  elevation: 8,
                  context: context,
                  builder: (context2) {
                    return SizedBox(
                      width: 100.w,
                      height: 30.h,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: StartupBlocSelector(
                          selector: (state) =>
                              state.editCameraDevice.isApiInProgress,
                          builder: (isLoadingEdit) {
                            return Column(
                              spacing: 12,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Edit Camera Placement",
                                  style: Theme.of(context2)
                                      .textTheme
                                      .headlineLarge,
                                ),
                                Text(context.appLocalizations.select_position),
                                IotBlocSelector.selectedFormPosition(
                                  builder: (selectedPosition) {
                                    return IgnorePointer(
                                      ignoring: isLoadingEdit,
                                      child: AppDropDownButton(
                                        dropDownTextStyle: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                        items: position.toBuiltList(),
                                        selectedValue:
                                            selectedPosition ?? position.first,
                                        onChanged:
                                            iotBloc.updateSelectedFormPosition,
                                        displayDropDownItems: (item) => item,
                                        buttonHeight: 6.h,
                                        dropdownRadius: 10,
                                        dropDownWidth: 100.w,
                                        dropDownHeight: 22.h,
                                      ),
                                    );
                                  },
                                ),
                                CustomGradientButton(
                                  isLoadingEnabled: isLoadingEdit,
                                  label: context.appLocalizations.edit,
                                  onSubmit: () {
                                    bloc.editPlacementCamera(
                                      iotBloc.state.selectedFormPosition,
                                      doorbell.id,
                                      context2,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              child: CameraSettingTile(
                title: "Camera Placement",
                isDisabled: isDisabled,
                trailing: Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                  ),
                  child: Text(
                    jsonDecode(
                          doorbell.details!,
                        )["placement"] ??
                        "",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: isLoading ? const EdgeInsets.all(8) : EdgeInsets.zero,
            child: LoadingWidget(
              isLoading: isLoading,
              label: (subDevicesEntities?.length ?? 0) == 0 ||
                      (subDevicesEntities ?? []).every((e) {
                        return e['state'] == "unavailable";
                      })
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Doorbell might not be responding",
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        if (isSleep(
                              subDevicesEntities![i]['entity_id'],
                            ) ||
                            CommonFunctions.isMoveAble(
                              subDevicesEntities![i]['entity_id'],
                            ) ||
                            isReboot(
                              subDevicesEntities![i]['entity_id'],
                            ) ||
                            isSetSystemDateAndTime(
                              subDevicesEntities![i]['entity_id'],
                            )) {
                          return Container();
                        }
                        final isSlider = isNumberEntity(
                          subDevicesEntities![i]['entity_id'].toString(),
                        );
                        final subDeviceEntity = subDevicesEntities![i];

                        return CameraSettingTile(
                          needSlider: isSlider,
                          isDisabled: isDisabled,
                          sliderOnChanged: (val) {
                            iotBloc.operateIotDevice(
                              subDeviceEntity['entity_id'],
                              "${subDeviceEntity['entity_id'].toString().split(".").first}/${Constants.setValue}",
                              fromControls: true,
                              otherValues: {
                                "value": val.toString(),
                              },
                              entityIdForControls: doorbell.entityId,
                            );
                          },
                          sliderVal: isSlider
                              ? double.parse(
                                  subDeviceEntity['state'] == "unavailable"
                                      ? 1.toString()
                                      : subDeviceEntity['state'] ??
                                          1.toString(),
                                )
                              : null,
                          minSliderVal: isSlider
                              ? subDeviceEntity['attributes']['min'].toDouble()
                              : null,
                          maxSliderVal: isSlider
                              ? subDeviceEntity['attributes']['max'].toDouble()
                              : null,
                          title: subDeviceEntity['name']
                              .toString()
                              .capitalizeFirstOfEach(),
                          trailing: AppSwitchWidget(
                            thumbSize: 18,
                            value: subDeviceEntity['state'] == 'on',
                            onChanged: (val) {
                              iotBloc.operateIotDevice(
                                subDeviceEntity['entity_id'],
                                "${subDeviceEntity['entity_id'].toString().split(".").first}/${subDeviceEntity['state'] == 'off' ? Constants.turnOnSimple : Constants.turnOffSimple}",
                                fromControls: true,
                                entityIdForControls: doorbell.entityId,
                              );
                            },
                          ),
                        );
                      },
                      shrinkWrap: true,
                      itemCount: subDevicesEntities?.length ?? 0,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Dialog adminCannotReleaseDoorbellDialog(BuildContext dialogContext) {
    return Dialog(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: CommonFunctions.getThemePrimaryLightWhiteColor(dialogContext),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dialogContext.appLocalizations.admin_cannot_release_doorbell,
                textAlign: TextAlign.center,
                style: Theme.of(dialogContext).textTheme.titleLarge!.copyWith(
                      color: CommonFunctions.getThemeBasedWidgetColor(
                        dialogContext,
                      ),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomGradientButton(
                onSubmit: () {
                  Navigator.pop(dialogContext);
                },
                customWidth: 20.w,
                customHeight: 5.h,
                label: dialogContext.appLocalizations.general_ok,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget deleteDevice({
    required IotBloc bloc,
    required BuildContext context,
    required UserDeviceModel? doorbell,
  }) {
    bool isMultiCamerasDelete = false;
    if (doorbell != null) {
      final details = jsonDecode(doorbell.details.toString());
      if (details != null) {
        if (details["extra_param"] != null &&
            details["extra_param"] is String) {
          isMultiCamerasDelete =
              details["extra_param"].toString().isMultiCamerasDelete();
        }
      }
    }
    return BlocProvider.value(
      value: bloc,
      child: IotBlocSelector(
        selector: (state) => state.deleteIotDevice.isSocketInProgress,
        builder: (isLoading) {
          return AppDialogPopup(
            needCross: false,
            title: isMultiCamerasDelete
                ? context.appLocalizations.delete_multi_camera
                : context.appLocalizations.delete_iot_device,
            isLoadingEnabled: isLoading,
            cancelButtonLabel: context.appLocalizations.general_no,
            cancelButtonOnTap: () {
              if (!isLoading) {
                Navigator.pop(context);
              }
            },
            confirmButtonLabel: context.appLocalizations.general_yes,
            confirmButtonOnTap: () {
              if (doorbell != null) {
                bloc.deleteIotDevice(doorbell.id, doorbell.entityId!, () {
                  // Future.delayed(
                  //   Duration(
                  //     seconds: Constants.durationRefreshSeconds,
                  //   ),
                  //   bloc.withDebounceUpdateWhenDeviceUnreachable,
                  // );
                  Navigator.pop(context, true);
                  bloc.callIotApi();
                });
              }
            },
          );
        },
      ),
    );
  }
}
