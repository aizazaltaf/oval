import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/main.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/room_items_model.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/pages/main/dashboard/cameras/view_all_camera.dart';
import 'package:admin/pages/main/dashboard/components/logout_dialog.dart';
import 'package:admin/pages/main/dashboard/doorbell_controls_page.dart';
import 'package:admin/pages/main/dashboard/main_dashboard.dart';
import 'package:admin/pages/main/dashboard/view_model/filters_model.dart';
import 'package:admin/pages/main/doorbell_management/bloc/doorbell_management_bloc.dart';
import 'package:admin/pages/main/doorbell_management/doorbell_map.dart';
import 'package:admin/pages/main/doorbell_management/scan_doorbell.dart';
import 'package:admin/pages/main/iot_devices/add_room.dart';
import 'package:admin/pages/main/iot_devices/auto_scanner_page.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/dialogs/delete_dialog.dart';
import 'package:admin/pages/main/iot_devices/dialogs/edit_name_dialog.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:admin/pages/main/iot_devices/room_all_devices.dart';
import 'package:admin/pages/main/iot_devices/view_all_devices.dart';
import 'package:admin/pages/main/locations/bloc/location_bloc.dart';
import 'package:admin/pages/main/locations/location_settings_page.dart';
import 'package:admin/pages/main/logout/bloc/logout_bloc.dart';
import 'package:admin/pages/main/logout/login_activity_page.dart';
import 'package:admin/pages/main/more_dashboard/dashboard_more_page.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/notifications/notification_page.dart';
import 'package:admin/pages/main/statistics/bloc/statistics_bloc.dart';
import 'package:admin/pages/main/statistics/components/statistics_filters_widget.dart';
import 'package:admin/pages/main/statistics/statistics_page.dart';
import 'package:admin/pages/main/user_management/add_new_user_page.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_bloc.dart';
import 'package:admin/pages/main/user_management/user_management_page.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/change_password_page.dart';
import 'package:admin/pages/main/user_profile/components/profile_otp_page.dart';
import 'package:admin/pages/main/user_profile/main_profile.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/visitor_history_page.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/main/voice_control/model/chat_model.dart';
import 'package:admin/pages/main/voice_control/model/voice_control_model.dart';
import 'package:admin/pages/main/voice_control/voice_control_screen.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/call_screen.dart';
import 'package:admin/pages/main/voip/streaming_page.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/category_detail_grid.dart';
import 'package:admin/pages/themes/componenets/theme_preview.dart';
import 'package:admin/pages/themes/componenets/view_category_screen.dart';
import 'package:admin/pages/themes/componenets/view_my_themes_screen.dart';
import 'package:admin/pages/themes/create_ai_theme.dart';
import 'package:admin/pages/themes/main_theme_screen.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/validate_password_dialog.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

mixin VoiceCommandHandler {
  List hexToColorArray(String hexColor) {
    if (!hexColor.startsWith("#") ||
        (hexColor.length != 7 && hexColor.length != 9)) {
      throw ArgumentError(
        "Invalid hex color format. Use #RRGGBB or #RRGGBBAA.",
      );
    }

    final color = Color(
      int.parse(hexColor.substring(1), radix: 16) |
          (hexColor.length == 7 ? 0xFF000000 : 0x00000000),
    );

    return [color.r * 255, color.g * 255, color.b * 255, color.a * 255];
  }

  Future<void> speak(VoiceControlModel? model, {String? text}) async {
    if (text != null) {
      text = text.replaceAll("*", "");
    }

    if (Platform.isAndroid) {
      await singletonBloc.textToSpeech
          .stop(); // ensure previous speech is cleared
      await Future.delayed(const Duration(milliseconds: 500));
      await singletonBloc.textToSpeech
          .speak(text ?? model!.text.replaceAll("*", ""), focus: true);
      await singletonBloc.textToSpeech.awaitSpeakCompletion(true);
    } else {
      // await singletonBloc.textToSpeech.stop();
      await singletonBloc.textToSpeech.setSpeechRate(0.4);
      await singletonBloc.textToSpeech.autoStopSharedSession(false);

      await Future.delayed(const Duration(milliseconds: 500));
      await singletonBloc.textToSpeech.setVolume(1);
      await singletonBloc.textToSpeech
          .speak(text ?? model!.text.replaceAll("*", ""), focus: true);
      await singletonBloc.textToSpeech.awaitSpeakCompletion(
        true,
      );
    }
  }

  Future<void> handleVoiceCommand(
    BuildContext context,
    VoiceControlModel m,
    data,
  ) async {
    final model = VoiceControlModel.fromDynamic(data["app_data"]);
    switch (model.command) {
      case VCConstants.showDoorBellLocationAgainstAccount:

        /// SHOW_DOORBELL_LOCATION_AGAINST_ACCOUNT
        await _handleShowDoorBellLocationAgainstAccount(context, model, data);

      case VCConstants.addLight:

        /// ADD_LIGHT
        await _handleAddLight(context, model, data);
      case VCConstants.roomScreen:

        /// ROOM_SCREEN
        await _handleRoomScreen(context, model, data);
      case VCConstants.recentlyUsedIotDevices:

        /// RECENTLY_USED_IOT_DEVICES
        await _handleRecentlyUsedIotDevices(context, model, data);
      case VCConstants.showConnectedDevices:

        /// SHOW_CONNECTED_DEVICES
        await _handleShowConnectedDevices(context, model, data);

      case VCConstants.viewRoom:

        /// VIEW_ROOM
        await _handleViewRoom(context, model, data);
      case VCConstants.listDevicesByStatus:

        /// LIST_DEVICES_BY_STATUS
        await _handleListDevicesByStatus(context, model, data);
      case VCConstants.listDeviceLightStatus:

        /// LIST_DEVICE_LIGHT_STATUS
        await _handleListDeviceLightStatus(context, model, data);
      case VCConstants.showDevicesByStatus:

        /// SHOW_DEVICES_BY_STATUS
        await _handleShowDevicesByStatus(context, model, data);
      case VCConstants.showLoggedInDevices:

        /// SHOW_LOGGED_IN_DEVICES
        await _handleShowLoggedInDevices(context, model, data);
      case VCConstants.logoutUserSession:

        /// LOGOUT_USER_SESSION
        await _handleLogoutUserSession(context, model, data);
      case VCConstants.showFeaturesIrvinei:

        /// SHOW_FEATURES_IRVINEI
        await _handleShowFeaturesIrvinei(context, model, data);

      case VCConstants.openHomeScreen:

        /// OPEN_HOME_SCREEN
        await _handleOpenHomeScreen(context, model, data);
      case VCConstants.openHomeScreenDashboard:

        /// OPEN_HOME_SCREEN_DASHBOARD
        await _handleOpenHomeScreenDashboard(context, model, data);
      case VCConstants.openUserManagement:

        /// OPEN_USER_MANAGEMENT
        await _handleOpenUserManagement(context, model, data);
      case VCConstants.addNewUser:

        /// ADD_NEW_USER
        await _handleAddNewUser(context, model, data);

      case VCConstants.showMyProfile:

        /// SHOW_MY_PROFILE
        await _handleShowMyProfile(context, model, data);
      case VCConstants.editMyProfile:

        /// EDIT_MY_PROFILE
        await _handleEditMyProfile(context, model, data);

      case VCConstants.openThemeWindow:

        /// OPEN_THEME_WINDOW
        await _handleOpenThemeWindow(context, model, data);
      case VCConstants.uploadThemeFromGallery:

        /// UPLOAD_THEME_FROM_GALLERY
        await _handleUploadThemeFromGallery(context, model, data);
      case VCConstants.addDoorbell:

        /// ADD_DOORBELL
        await _handleAddDoorbell(context, model, data);
      case VCConstants.addNewDoorbell:

        /// ADD_NEW_DOORBELL
        await _handleAddDoorbell(context, model, data);
      case VCConstants.addNewDoorbellCamera:

        /// ADD_NEW_DOORBELL_CAMERA
        await _handleAddNewDoorbellCamera(context, model, data);
      case VCConstants.purchaseDoorbell:

        /// PURCHASE_DOORBELL
        await _handlePurchaseDoorbell(context, model, data);
      case VCConstants.openManageDoorbellsWindow:

        /// OPEN_MANAGE_DOORBELLS_WINDOW
        await _handleOpenManageDoorbellsWindow(context, model, data);
      case VCConstants.openCameraMonitoring:

        /// OPEN_CAMERA_MONITORING
        await _handleOpenManageDoorbellsWindow(context, model, data);
      case VCConstants.openLocationSettings:

        /// OPEN_LOCATION_SETTINGS
        await _handleOpenLocationSettings(context, model, data);
      case VCConstants.status:

        /// STATUS
        await _handleStatus(context, model, data);
      case VCConstants.countCameraMonitoring:

        /// COUNT_CAMERA_MONITORING
        await _handleCountCameraMonitoring(context, model, data);
      case VCConstants.list:

        /// LIST
        await _handleListAvailableLocations(context, model, data);
      case VCConstants.listDoorbellNameGroupedByLocation:

        /// LIST_DOORBELL_NAME_GROUPED_BY_LOCATION
        await _handleListDoorbellNameGroupedByLocation(context, model, data);

      case VCConstants.editLocationByName:

        /// EDIT_LOCATION_BY_NAME
        await _handleEditLocationByName(context, model, data);
      case VCConstants.openDeviceManagement:

        /// OPEN_DEVICE_MANAGEMENT
        await _handleOpenDeviceManagement(context, model, data);
      case VCConstants.addNewDevice:

        /// ADD_NEW_DEVICE
        await _handleAddNewDevice(context, model, data);
      case VCConstants.delete:

        /// DELETE
        await _handleDeleteLight(context, model, data);
      case VCConstants.addRoom:

        /// ADD_ROOM
        await _handleAddRoom(context, model, data);

      case VCConstants.setThermostatTemperature:

        /// SET_THERMOSTAT_TEMPERATURE
        await _handleSetThermostatTemperature(context, model, data);
      case VCConstants.connect:

        /// CONNECT
        await _handleConnect(context, model, data);
      case VCConstants.disconnect:

        /// DISCONNECT
        await _handleDisconnect(context, model, data);
      case VCConstants.edit:

        /// EDIT_LIGHT
        await _handleEditLight(context, model, data);
      case VCConstants.showDeviceLightStatus:

        /// SHOW_DEVICE_LIGHT_STATUS
        await _handleShowDeviceLightStatus(context, model, data);
      case VCConstants.changeThermostatTemperature:

        /// CHANGE_THERMOSTAT_TEMPERATURE
        await _handleSetThermostatTemperature(context, model, data);
      case VCConstants.setCurtainPosition:

        /// SET_CURTAIN_POSITION
        await _handleSetCurtainPosition(context, model, data);
      case VCConstants.transferOwnership:

        /// TRANSFER_OWNERSHIP
        await _handleTransferOwnership(context, model, data);
      case VCConstants.createAiTheme:

        /// CREATE_AI_THEME
        await _handleCreateAiTheme(context, model, data);

      case VCConstants.increaseThermostatTemperature:

        /// INCREASE_THERMOSTAT_TEMPERATURE
        await _handleIncreaseThermostatTemperature(context, model, data);
      case VCConstants.decreaseThermostatTemperature:

        /// DECREASE_THERMOSTAT_TEMPERATURE
        await _handleDecreaseThermostatTemperature(context, model, data);
      case VCConstants.switchThermostatModesHeat:

        /// SWITCH_THERMOSTAT_MODES_HEAT
        await _handleSwitchThermostatModesHeat(context, model, data);
      case VCConstants.switchThermostatModesCool:

        /// SWITCH_THERMOSTAT_MODES_COOL
        await _handleSwitchThermostatModesCool(context, model, data);
      case VCConstants.switchThermostatModesOff:

        /// SWITCH_THERMOSTAT_MODES_OFF
        await _handleSwitchThermostatModesOff(context, model, data);
      case VCConstants.checkCameraStatusByName:

        /// CHECK_CAMERA_STATUS_BY_CAMERA_NAME
        await _handleOpenCameraStatusByCameraName(context, model, data);
      case VCConstants.switchThermostatFanOn:

        /// SWITCH_THERMOSTAT_FAN_ON
        await _handleSwitchThermostatFanOn(context, model, data);
      case VCConstants.switchThermostatFanAuto:

        /// SWITCH_THERMOSTAT_FAN_AUTO
        await _handleSwitchThermostatFanAuto(context, model, data);
      case VCConstants.switchThermostatFanDiffuse:

        /// SWITCH_THERMOSTAT_FAN_DIFFUSE
        await _handleSwitchThermostatFanDiffuse(context, model, data);
      case VCConstants.locationReleaseByName:

        /// LOCATION_RELEASE_BY_NAME
        await _handleLocationReleaseByName(context, model, data);

      case VCConstants.changeLightColor:

        /// CHANGE_LIGHT_COLOR
        await _handleChangeLightColor(context, model, data);
      case VCConstants.changeColor:

        /// CHANGE_COLOR
        await _handleChangeColor(context, model, data);
      case VCConstants.changeBrightness:

        /// CHANGE_BRIGHTNESS
        await _handleChangeBrightness(context, model, data);
      case VCConstants.changeLightMode:

        /// CHANGE_LIGHT_MODE
        await _handleChangeLightMode(context, model, data);
      case VCConstants.showCurrentThemeApplied:

        /// SHOW_CURRENT_THEME_APPLIED
        await _handleShowCurrentThemeApplied(context, model, data);

      case VCConstants.makeVideoCall:

        /// MAKE_A_CALL_WITH_VISITOR
        await _handleMakeACallWithVisitor(context, model, data);
      case VCConstants.makeAudioCall:

        /// MAKE_A_CALL_WITH_VISITOR
        await _handleMakeACallWithVisitor(context, model, data);

      case VCConstants.addNameToUnwantedVisitor:

        /// ADD_NAME_TO_UNWANTED_VISITOR
        await _handleAddNameToUnwantedVisitor(context, model, data);
      // case VCConstants.showVisitorChatHistoryByName:
      //
      //   /// SHOW_VISITOR_CHAT_HISTORY_BY_NAME
      //   await _handleShowVisitorChatHistoryByName(context, model, data);
      case VCConstants.devicesByRoom:

        /// DEVICES_BY_ROOM
        await _handleDevicesByRoom(context, model, data);
      case VCConstants.showThermostatTemperature:

        /// SHOW_THERMOSTAT_TEMPERATURE
        await _handleShowThermostatTemperature(context, model, data);

      case VCConstants.showCurtainPosition:

        /// SHOW_CURTAIN_POSITION
        await _handleShowCurtainPosition(context, model, data);
      case VCConstants.showBlindsPosition:

        /// SHOW_BLINDS_STATUS
        await _handleShowBlindsStatus(context, model, data);
      case VCConstants.showTemperatureInside:

        /// SHOW_TEMPERATURE_INSIDE
        await _handleShowTemperatureInside(context, model, data);
      case VCConstants.increaseCooling:

        /// INCREASE_COOLING
        await _handleIncreaseCooling(context, model, data);
      case VCConstants.decreaseCooling:

        /// DECREASE_COOLING
        await _handleDecreaseCooling(context, model, data);
      case VCConstants.decreaseHeating:

        /// DECREASE_HEATING
        await _handleDecreaseHeating(context, model, data);
      case VCConstants.increaseHeating:

        /// INCREASE_HEATING
        await _handleIncreaseHeating(context, model, data);
      case VCConstants.showDevicesByRoom:

        /// SHOW_DEVICES_BY_ROOM
        await _handleShowDevicesByRoom(context, model, data);
      case VCConstants.moveDeviceToRoom:

        /// MOVE_DEVICE_TO_ROOM
        await _handleMoveDevicesToRoom(context, model, data);

      case VCConstants.doorbellStream:

        /// DOORBELL_STREAM
        await _handleOpenDoorbellStream(context, model, data);
      case VCConstants.showTemperatureOutside:

        /// SHOW_TEMPERATURE_OUTSIDE
        await _handleShowTemperatureOutside(context, model, data);
      case VCConstants.openStatistic:

        /// OPEN_STATISTIC
        await _handleOpenStatistic(context, model, data);

      case VCConstants.openVisitorManagement:

        /// OPEN_VISITOR_MANAGEMENT
        await _handleOpenVisitorManagement(context, model, data);

      case VCConstants.openNotification:

        /// OPEN_NOTIFICATION
        await _handleOpenNotification(context, model, data);

      default:
        throw UnimplementedError(
          'Voice command not implemented: ${model.command}',
        );
    }
  }

  Future<void> _handleShowDoorBellLocationAgainstAccount(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    unawaited(LocationSettingsPage.push(context.mounted ? context : context));
  }

  // Private handler methods
  Future<void> _handleAddLight(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
      unawaited(AutoScannerPage.push(context.mounted ? context : context));
    }
  }

  Future<void> _handleRecentlyUsedIotDevices(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    // if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
    unawaited(
      ViewAllDevices.push(
        context.mounted ? context : context,
        isRoom: false,
      ),
    );
    // }
  }

  Future<void> _handleRoomScreen(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    unawaited(
      ViewAllDevices.push(
        context.mounted ? context : context,
      ),
    );
  }

  Future<void> _handleShowConnectedDevices(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
      unawaited(
        ViewAllDevices.push(
          context.mounted ? context : context,
          isRoom: false,
        ),
      );
    }
  }

  Future<void> _handleListDevicesByStatus(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    final iotBloc = IotBloc.of(context.mounted ? context : context);
    final list = iotBloc.state.getIotRoomsApi.data?.map((e) {
      final List<IotDeviceModel> matchingListings = iotBloc
          .state.iotDeviceModel!
          .toList()
          .where((listing) => listing.roomId.toString() == e.roomId.toString())
          .toList();

      return ListingViewModel(
        name: matchingListings.isEmpty
            ? ""
            : "**Room Name: ${e.roomName}** \n\n ${matchingListings.mapIndexed((index, e) {
                return " ${index + 1}. ${e.deviceName!} ${'(${e.stateAvailable == 1 ? 'On' : e.stateAvailable == 2 ? 'Off' : 'Unavailable'})'}";
              }).join("\n\n")}",
        roomId: e.roomId.toString(),
        imageIcon: "",
        showNumbers: false,
      );
    }).toBuiltList();

    if (list!.isNotEmpty) {
      bloc.state.chatData.last.listingViewModel = list;
      bloc.updateListingDevices(list);
    }

    if (!bloc.state.isVoiceControlScreenActive) {
      unawaited(VoiceControlScreen.push(context.mounted ? context : context));
    }
  }

  Future<void> _handleListDeviceLightStatus(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    final iotBloc = IotBloc.of(context.mounted ? context : context);
    final list = iotBloc.state.iotDeviceModel!
        .where(
          (device) => device.entityId!.contains(Constants.light),
        )
        .toList()
        .map((e) {
      return ListingViewModel(
        name:
            "${e.deviceName!} ${'(${e.stateAvailable == 1 ? 'On' : e.stateAvailable == 2 ? 'Off' : 'Unavailable'})'}",
        roomId: e.roomId.toString(),
        imageIcon: e.room!.image,
      );
    }).toBuiltList();

    bloc.state.chatData.last.listingViewModel = list;
    bloc.updateListingDevices(list);

    if (!bloc.state.isVoiceControlScreenActive) {
      unawaited(VoiceControlScreen.push(context.mounted ? context : context));
    }
  }

  Future<void> _handleShowDevicesByStatus(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
      unawaited(
        ViewAllDevices.push(
          context.mounted ? context : context,
          isRoom: false,
        ),
      );
    }
  }

  Future<void> _handleShowLoggedInDevices(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);

    unawaited(LoginActivityPage.push(context.mounted ? context : context));
  }

  Future<void> _handleOpenHomeScreen(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    Future.delayed(const Duration(seconds: 2), () {
      MainDashboard.pushRemove(
        context.mounted
            ? context
            : context.mounted
                ? context
                : context,
      );
    });
  }

  Future<void> _handleOpenHomeScreenDashboard(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    Future.delayed(const Duration(seconds: 2), () {
      MainDashboard.pushRemove(context.mounted ? context : context);
    });
  }

  Future<void> _handleOpenUserManagement(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
      unawaited(UserManagementPage.push(context.mounted ? context : context));
    }
  }

  Future<void> _handleAddNewUser(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
      final bloc = UserManagementBloc.of(context.mounted ? context : context);
      unawaited(bloc.callSubUsers());
      await bloc.callRoles();
      bloc.reInitializeAddUserFields();
      unawaited(AddNewUserPage.push(context.mounted ? context : context));
    }
  }

  Future<void> _handleLogoutUserSession(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final voiceControlBloc =
        VoiceControlBloc.of(context.mounted ? context : context);
    if (data["app_data"]["data"]["session"] == "CURRENT") {
      unawaited(
        showDialog(
          context: context.mounted ? context : context,
          builder: (context) =>
              LogoutDialog(voiceControlBloc: voiceControlBloc),
        ),
      );
    } else {
      final bloc = LogoutBloc.of(context.mounted ? context : context);
      unawaited(bloc.callLoginActivities());
      final userProfileBloc =
          UserProfileBloc.of(context.mounted ? context : context)
            ..updatePasswordErrorMessage("");
      unawaited(
        showDialog(
          context: context.mounted ? context : context,
          builder: (innerContext) => ValidatePasswordDialog(
            successFunction: () async {
              await bloc.callLogoutAllSessions();
            },
            userProfileBloc: userProfileBloc,
          ),
        ),
      );
    }
  }

  Future<void> _handleShowMyProfile(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    unawaited(ProfileMainPage.push(context.mounted ? context : context));
  }

  Future<void> _handleEditMyProfile(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    switch (data["app_data"]["data"]["update"]) {
      case "USERNAME":
        unawaited(
          editProfileFunction(
            context.mounted ? context : context,
            nameFocus: true,
          ),
        );
      case "EMAIL":
        unawaited(
          editProfileFunction(
            context.mounted ? context : context,
            emailFocus: true,
          ),
        );
      case "IMAGE":
        unawaited(editProfileFunction(context.mounted ? context : context));
        Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) {
            ProfileMainPage.showBottomSheet(context);
          }
        });
      case "NUMBER":
        unawaited(
          editProfileFunction(
            context.mounted ? context : context,
            phoneFocus: true,
          ),
        );
      case "PASSWORD":
        unawaited(ChangePasswordPage.push(context.mounted ? context : context));
      default:
        unawaited(editProfileFunction(context.mounted ? context : context));
    }
  }

  Future<void> editProfileFunction(
    BuildContext context, {
    bool nameFocus = false,
    bool emailFocus = false,
    bool phoneFocus = false,
  }) async {
    final profileBloc = singletonBloc.profileBloc;
    final userProfileBloc = UserProfileBloc.of(context);
    final String countryCode = CommonFunctions.getDialCode(
      profileBloc.state!.phone!,
    );
    final String phoneNumberWithoutDialCode =
        profileBloc.state!.phone!.replaceFirst(countryCode, '');
    userProfileBloc
      ..updateEditName(profileBloc.state!.name!)
      ..updateEditEmail(profileBloc.state!.email!)
      ..updateCountryCode(countryCode)
      ..updateEditPhoneNumber(phoneNumberWithoutDialCode)
      ..updateIsProfileEditing(true)
      ..updateUpdateProfileButtonEnabled(false);
    unawaited(
      ProfileMainPage.push(
        context,
        nameFocus: nameFocus,
        emailFocus: emailFocus,
        phoneFocus: phoneFocus,
      ),
    );
  }

  Future<void> _handleOpenThemeWindow(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);

    switch (data["app_data"]["data"]["tab"]) {
      case "HOME":
        ThemeBloc.of(context.mounted ? context : context)
            .updateActiveType("Feed");
        unawaited(
          MainThemeScreen.push(
            context.mounted ? context : context,
            false,
            key: UniqueKey(),
          ),
        );
      case "MY_THEMES":
        ThemeBloc.of(context.mounted ? context : context)
            .updateActiveType("My Themes");
        unawaited(ViewMyThemesScreen.push(context.mounted ? context : context));
      case "FAVOURITE":
        ThemeBloc.of(context.mounted ? context : context)
            .updateActiveType("Favourite");
        unawaited(
          MainThemeScreen.push(
            context.mounted ? context : context,
            false,
            type: "Favourite",
          ),
        );
      case "POPULAR":
        ThemeBloc.of(context.mounted ? context : context)
            .updateActiveType("Popular");
        unawaited(
          MainThemeScreen.push(
            context.mounted ? context : context,
            false,
            type: "Popular",
          ),
        );
      case "VIDEO":
        ThemeBloc.of(context.mounted ? context : context)
            .updateActiveType("Videos");
        unawaited(
          MainThemeScreen.push(
            context.mounted ? context : context,
            false,
            type: "Videos",
          ),
        );
      case "GIFS":
        ThemeBloc.of(context.mounted ? context : context)
            .updateActiveType("Gif");
        unawaited(
          MainThemeScreen.push(
            context.mounted ? context : context,
            false,
            type: "Gif",
          ),
        );
      case "CATEGORY":
        final bloc = ThemeBloc.of(context.mounted ? context : context);
        final voiceBloc =
            VoiceControlBloc.of(context.mounted ? context : context);
        bloc.updateActiveType("Category");

        final String? themeMap = data["app_data"]["data"]["category"];

        if (themeMap == null) {
          unawaited(
            ViewCategoryScreen.push(context.mounted ? context : context),
          );
          return;
        } else {
          if (bloc.state.categoryThemesApi.data == null) {
            await bloc.callCategoryThemesApi();
          }
          final themeCategory =
              bloc.state.categoryThemesApi.data!.data.firstWhereOrNull(
            (e) => themeMap.contains(e.name.toLowerCase().split(" ")[0]),
          );

          if (themeCategory != null) {
            voiceBloc.state.chatData.last.text = model.text;
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);

            bloc.updateCategoryApiId(themeCategory.id);
            unawaited(
              bloc.callThemesApi(
                type: "Category",
                categoryId: themeCategory.id,
                refresh: true,
                isPageChangeRefreshTheme: true,
              ),
            );
            logger.fine("opening themes");
            unawaited(
              CategoryDetailGrid.push(
                context.mounted ? context : context,
                themeCategory.name,
                themeCategory.id,
              ),
            );
          }
        }
    }
  }

  Future<void> _handleUploadThemeFromGallery(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    unawaited(
      ThemeBloc.of(context.mounted ? context : context)
          .pickThemeAsset(context.mounted ? context : context),
    );
  }

  Future<void> _handleAddDoorbell(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    unawaited(ScanDoorbell.push(context.mounted ? context : context));
  }

  Future<void> _handleAddNewDoorbellCamera(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    unawaited(ScanDoorbell.push(context.mounted ? context : context));
  }

  Future<void> _handlePurchaseDoorbell(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    unawaited(
      CommonFunctions.openUrl(
        (context.mounted ? context : context)
            .appLocalizations
            .shop_doorbell_url,
      ),
    );
  }

  Future<void> _handleOpenManageDoorbellsWindow(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    unawaited(ViewAllCamera.push(context.mounted ? context : context));
  }

  Future<void> _handleOpenLocationSettings(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
      unawaited(LocationSettingsPage.push(context.mounted ? context : context));
    }
  }

  Future<void> _handleStatus(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    final iotBloc = IotBloc.of(context.mounted ? context : context);
    final startUpBloc = StartupBloc.of(context.mounted ? context : context);

    final String deviceType = data["app_data"]["device_type"];
    final String locationId = data["app_data"]["location_id"];
    final list = (data["app_data"]["result"] ?? []) as List;

    switch (deviceType) {
      case "camera":
        if (list.length == 1) {
          await speak(model);
          final UserDeviceModel? device =
              startUpBloc.state.userDeviceModel?.firstWhereOrNull(
            (e) => e.entityId == list[0]["entity_id"],
          );
          if (device != null) {
            if (data["app_data"]["is_active"] == true) {
              bloc.state.chatData.last.text
                  .toString()
                  .replaceAll("[Device Status]", "[Active]");
            }
          }
        } else {
          unawaited(
            multiListShowStatus(
              data,
              bloc,
              model,
            ),
          );
        }
      case "doorbell":
        if (list.length == 1) {
          await speak(model);
          final UserDeviceModel? device =
              startUpBloc.state.userDeviceModel?.firstWhereOrNull(
            (e) => e.deviceId == list[0]["device_id"],
          );
          if (device != null) {
            if (data["app_data"]["is_active"] == true) {
              bloc.state.chatData.last.text
                  .toString()
                  .replaceAll("[Device Status]", "[Active]");
            }
          }
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in data["app_data"]["result"]) {
            final isStreaming = item["is_streaming"] == null
                ? ""
                : item["is_streaming"].toString();
            final cameraName = item["name"] ?? "";

            if (locationId == item["location_id"].toString()) {
              groupedByRoom.putIfAbsent(isStreaming, () => []).add(cameraName);
            }
          }

          final list = groupedByRoom.entries.map((entry) {
            final cameraNames = entry.value;
            final isStreaming = entry.key;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name:
                  "$formattedText **Status: ${isStreaming == "0" ? 'off' : 'on'}**",
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (list.isNotEmpty) {
            bloc.state.chatData.last.listingViewModel = list;
            if (list.length == 1) {
              await speak(model, text: "${model.text} ${list[0].name}");
            } else {
              logger.fine("${model.text} ${list.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${list.map((e) => e.name)}",
              );
            }
            bloc
              ..updateListingDevices(list)
              ..updateChatUpdate(!bloc.state.chatUpdate);
          }
        }

      // else {
      //   final Map<String, List<String>> groupedByRoom = {};
      //   for (final item in list) {
      //     final roomName = item["name"] ?? "";
      //
      //     groupedByRoom.putIfAbsent("Cameras", () => []).add(roomName);
      //   }
      //
      //   final resultList = groupedByRoom.entries.map((entry) {
      //     final cameraNames = entry.value;
      //
      //     final formattedText = cameraNames.mapIndexed((index, name) {
      //       return " ${index + 1}. $name";
      //     }).join("\n\n");
      //
      //     return ListingViewModel(
      //       name: " $formattedText",
      //       roomId: "", // Or assign if you have roomId separately
      //       imageIcon: "",
      //       showNumbers: false,
      //     );
      //   }).toBuiltList();
      //
      //   if (resultList.isNotEmpty) {
      //     bloc.state.chatData.last.listingViewModel = resultList;
      //     bloc
      //       ..updateListingDevices(resultList)
      //       ..updateChatUpdate(!bloc.state.chatUpdate);
      //     if (resultList.length == 1) {
      //       await speak(model, text: "${model.text} ${resultList[0].name}");
      //     } else {
      //       logger.fine("${model.text} ${resultList.map((e) => e.name)}");
      //       await speak(
      //         model,
      //         text: "${model.text} ${resultList.map((e) => e.name)}",
      //       );
      //     }
      //   }
      // }

      case "climate":
        if (list.length == 1) {
          final IotDeviceModel? device = iotBloc.state.iotDeviceModel
              ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
          if (device != null) {
            if (device.stateAvailable != 3) {
              await Future.delayed(const Duration(seconds: 2));
              bloc.state.chatData.last.text =
                  "Thermostat Temperature is ${device.temperature}${device.thermostatTemperatureUnit}, Fan mode is ${device.fanMode}, Preset Mode is ${device.presetMode}, Thermostat mode is ${device.mode}";
              bloc.updateChatUpdate(!bloc.state.chatUpdate);
              await speak(
                model,
                text:
                    "Thermostat Temperature is ${device.temperature}${device.thermostatTemperatureUnit}, Fan mode is ${device.fanMode}, Preset Mode is ${device.presetMode}, Thermostat mode is ${device.mode}",
              );
            } else {
              bloc.state.chatData.last.text = "Device Unreachable";
              bloc.updateChatUpdate(!bloc.state.chatUpdate);
              await speak(model, text: "Device Unreachable");
            }
          } else {
            bloc.state.chatData.last.text = "Please connect Thermostat";
            bloc.updateChatUpdate(!bloc.state.chatUpdate);
            await speak(model, text: "Please connect Thermostat");
          }
        } else {
          unawaited(
            multiListShowStatus(
              data,
              bloc,
              model,
            ),
          );
        }
      case "curtain":
        if (list.length == 1) {
          unawaited(iotDevicesStatus(list, bloc, iotBloc, model, deviceType));
        } else {
          unawaited(
            multiListShowStatus(
              data,
              bloc,
              model,
            ),
          );
        }
      case "lock":
        if (list.length == 1) {
          final IotDeviceModel? device = iotBloc.state.iotDeviceModel
              ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
          if (device != null) {
            if (device.stateAvailable == 3) {
              bloc.state.chatData.last.text = "Device Unreachable";
              bloc.updateChatUpdate(!bloc.state.chatUpdate);
              await speak(model, text: "Device Unreachable");
            }
          } else {
            bloc.state.chatData.last.text = "Please connect Smart Lock";
            bloc.updateChatUpdate(!bloc.state.chatUpdate);
            await speak(model, text: "Please connect Smart Lock");
          }
        } else {
          unawaited(
            multiListShowStatus(
              data,
              bloc,
              model,
            ),
          );
        }
      case "blind":
        if (list.length == 1) {
          unawaited(iotDevicesStatus(list, bloc, iotBloc, model, deviceType));
        } else {
          unawaited(
            multiListShowStatus(
              data,
              bloc,
              model,
            ),
          );
        }
      case "light":
        if (list.length == 1) {
          unawaited(iotDevicesStatus(list, bloc, iotBloc, model, deviceType));
        } else {
          unawaited(
            multiListShowStatus(
              data,
              bloc,
              model,
            ),
          );
        }
    }
  }

  Future<void> _handleCountCameraMonitoring(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    final iotBloc = IotBloc.of(context.mounted ? context : context);
    final length = iotBloc.state.iotDeviceModel!
        .where(
          (device) => device.entityId!.contains(Constants.camera),
        )
        .toList()
        .length;
    if (length != 0) {
      await speak(
        model,
        text: "$length ${length == 1 ? 'Camera is' : 'Cameras are'} connected",
      );
    }
    if (iotBloc.state.iotDeviceModel!.isNotEmpty) {
      final list = iotBloc.state.iotDeviceModel!
          .where(
            (device) => device.entityId!.contains(Constants.camera),
          )
          .toList()
          .map((e) {
        return ListingViewModel(
          name: e.deviceName ?? "",
          roomId: e.roomId.toString(),
          imageIcon: e.room!.image,
        );
      }).toBuiltList();

      bloc.state.chatData.last.listingViewModel = list;
      bloc
        ..updateListingDevices(list)
        ..updateChatUpdate(!bloc.state.chatUpdate);
    }

    if (!bloc.state.isVoiceControlScreenActive) {
      unawaited(
        VoiceControlScreen.push(context.mounted ? context : context),
      );
    }
  }

  Future<void> iotDevicesStatus(list, bloc, iotBloc, model, deviceType) async {
    if (list.length == 1) {
      final IotDeviceModel? device = iotBloc.state.iotDeviceModel
          ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
      if (device != null) {
        if (device.stateAvailable != 3) {
          bloc.state.chatData.last.text =
              "${deviceType.toString().capitalizeFirstOfEach()} is ${double.parse(device.curtainPosition!) > 90 ? "Closed" : double.parse(device.curtainPosition!).toInt() == 0 ? "Fully Opened" : deviceType == "blind" ? "${double.parse(device.curtainPosition!).toInt()}% Close" : "Partially Closed"}";
          bloc.updateChatUpdate(!bloc.state.chatUpdate);
          await speak(
            model,
            text:
                "${deviceType.toString().capitalizeFirstOfEach()} is ${double.parse(device.curtainPosition!) > 90 ? "Closed" : double.parse(device.curtainPosition!).toInt() == 0 ? "Fully Opened" : deviceType == "blind" ? "${double.parse(device.curtainPosition!).toInt()}% Close" : "Partially Closed"}",
          );
        } else {
          bloc.state.chatData.last.text = "Device Unreachable";
          bloc.updateChatUpdate(!bloc.state.chatUpdate);
          await speak(model, text: "Device Unreachable");
        }
      } else {
        bloc.state.chatData.last.text = "Please connect $deviceType";
        bloc.updateChatUpdate(!bloc.state.chatUpdate);
        await speak(model, text: "Please connect $deviceType");
      }
    }
  }

  Future<void> _handleListAvailableLocations(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final String deviceType = data["app_data"]["device_type"];
    // final String locationId = data["app_data"]["location_id"];
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    final iotBloc = IotBloc.of(context.mounted ? context : context);
    final profileBloc = ProfileBloc.of(context.mounted ? context : context);

    switch (deviceType) {
      case "locations":
        final list = profileBloc.state!.locations!.map((e) {
          return ListingViewModel(
            name: e.name!,
            roomId: e.id.toString(),
            imageIcon: "",
          );
        }).toBuiltList();
        bloc.state.chatData.last.listingViewModel = list;
        bloc
          ..updateListingDevices(list)
          ..updateChatUpdate(!bloc.state.chatUpdate);
        if (list.length == 1) {
          await speak(model, text: "${model.text} ${list[0].name}");
        } else {
          logger.fine("${model.text} ${list.map((e) => e.name)}");
          await speak(
            model,
            text: "${model.text} ${list.map((e) => e.name)}",
          );
        }
      case "doorbell":
        final Map<String, List<String>> groupedByRoom = {};
        for (final item in data["app_data"]["result"]) {
          final cameraName = item["name"] ?? "";

          // if (locationId == item["location_id"].toString()) {
          groupedByRoom.putIfAbsent("", () => []).add(cameraName);
          // }
        }

        final list = groupedByRoom.entries.map((entry) {
          final cameraNames = entry.value;

          final formattedText = cameraNames.mapIndexed((index, name) {
            return " ${index + 1}. $name";
          }).join("\n\n");

          return ListingViewModel(
            name: formattedText,
            roomId: "", // Or assign if you have roomId separately
            imageIcon: "",
            showNumbers: false,
          );
        }).toBuiltList();

        if (list.isNotEmpty) {
          bloc.state.chatData.last.listingViewModel = list;
          if (list.length == 1) {
            await speak(model, text: "${model.text} ${list[0].name}");
          } else {
            logger.fine("${model.text} ${list.map((e) => e.name)}");
            await speak(
              model,
              text: "${model.text} ${list.map((e) => e.name)}",
            );
          }
          bloc
            ..updateListingDevices(list)
            ..updateChatUpdate(!bloc.state.chatUpdate);
        }
      case "light":
        unawaited(multiListShow(data, bloc, model));
      case "camera":
        final list = data["app_data"]["result"] as List;
        final Map<String, List<String>> groupedByRoom = {};
        for (final item in list) {
          final roomName = item["name"] ?? "";

          groupedByRoom.putIfAbsent("Cameras", () => []).add(roomName);
        }

        final resultList = groupedByRoom.entries.map((entry) {
          final cameraNames = entry.value;

          final formattedText = cameraNames.mapIndexed((index, name) {
            return " ${index + 1}. $name";
          }).join("\n\n");

          return ListingViewModel(
            name: " $formattedText",
            roomId: "", // Or assign if you have roomId separately
            imageIcon: "",
            showNumbers: false,
          );
        }).toBuiltList();

        if (resultList.isNotEmpty) {
          bloc.state.chatData.last.listingViewModel = resultList;
          bloc
            ..updateListingDevices(resultList)
            ..updateChatUpdate(!bloc.state.chatUpdate);
          if (resultList.length == 1) {
            await speak(model, text: "${model.text} ${resultList[0].name}");
          } else {
            logger.fine("${model.text} ${resultList.map((e) => e.name)}");
            await speak(
              model,
              text: "${model.text} ${resultList.map((e) => e.name)}",
            );
          }
        }
      case "device":
        final list = iotBloc.state.getIotRoomsApi.data?.map((e) {
          final List<IotDeviceModel> matchingListings =
              iotBloc.state.iotDeviceModel!
                  .toList()
                  .where(
                    (listing) =>
                        listing.roomId.toString() == e.roomId.toString(),
                  )
                  .toList();

          return ListingViewModel(
            name: matchingListings.isEmpty
                ? ""
                : "**Room Name: ${e.roomName}** \n\n ${matchingListings.mapIndexed((index, entry) {
                    return " ${index + 1}. ${entry.deviceName}";
                  }).join("\n\n")}",
            roomId: e.roomId.toString(),
            imageIcon: "",
            showNumbers: false,
          );
        }).toBuiltList();

        bloc.state.chatData.last.listingViewModel = list;
        bloc.updateListingDevices(list);
        if (list != null) {
          if (list.length == 1) {
            await speak(model, text: "${model.text} ${list[0].name}");
          } else {
            logger.fine("${model.text} ${list.map((e) => e.name)}");
            await speak(
              model,
              text: "${model.text} ${list.map((e) => e.name)}",
            );
          }
        } else {
          await speak(model);
        }
      case "room":
        final list = iotBloc.state.getIotRoomsApi.data?.map((e) {
          return ListingViewModel(
            name: e.roomName!,
            roomId: e.roomId.toString(),
            imageIcon: e.image,
          );
        }).toBuiltList();

        bloc.state.chatData.last.listingViewModel = list;
        bloc.updateListingDevices(list);

        unawaited(ViewAllDevices.push(context.mounted ? context : context));
        if (list != null) {
          if (list.length == 1) {
            await speak(model, text: "${model.text} ${list[0].name}");
          } else {
            logger.fine("${model.text} ${list.map((e) => e.name)}");
            await speak(
              model,
              text: "${model.text} ${list.map((e) => e.name)}",
            );
          }
        } else {
          await speak(model);
        }
      default:
        final Map<String, List<String>> groupedByRoom = {};
        for (final item in data["app_data"]["result"]) {
          final cameraName = item["name"] ?? "";

          // if (locationId == item["location_id"].toString()) {
          groupedByRoom.putIfAbsent("", () => []).add(cameraName);
          // }
        }

        final list = groupedByRoom.entries.map((entry) {
          final cameraNames = entry.value;

          final formattedText = cameraNames.mapIndexed((index, name) {
            return " ${index + 1}. $name";
          }).join("\n\n");

          return ListingViewModel(
            name: formattedText,
            roomId: "", // Or assign if you have roomId separately
            imageIcon: "",
            showNumbers: false,
          );
        }).toBuiltList();

        if (list.isNotEmpty) {
          bloc.state.chatData.last.listingViewModel = list;
          if (list.length == 1) {
            await speak(model, text: "${model.text} ${list[0].name}");
          } else {
            logger.fine("${model.text} ${list.map((e) => e.name)}");
            await speak(
              model,
              text: "${model.text} ${list.map((e) => e.name)}",
            );
          }
          bloc
            ..updateListingDevices(list)
            ..updateChatUpdate(!bloc.state.chatUpdate);
        }
    }

    if (!bloc.state.isVoiceControlScreenActive) {
      unawaited(VoiceControlScreen.push(context.mounted ? context : context));
    }
  }

  Future<void> _handleListDoorbellNameGroupedByLocation(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    final profileBloc = ProfileBloc.of(context.mounted ? context : context);
    final startUpBloc = StartupBloc.of(context.mounted ? context : context);

    final list = profileBloc.state!.locations!.map((e) {
      final List<UserDeviceModel> matchingListings =
          startUpBloc.state.userDeviceModel!
              .toList()
              .where(
                (listing) =>
                    listing.locationId.toString() == e.id?.toString() &&
                    listing.entityId == null,
              )
              .toList();

      return ListingViewModel(
        name:
            "**Location Name: ${e.name!}** \n\n ${matchingListings.mapIndexed((index, entry) {
          return " ${index + 1}. ${entry.name}";
        }).join("\n\n")}",
        roomId: e.id.toString(),
        imageIcon: "",
        showNumbers: false,
      );
    }).toBuiltList();

    bloc.state.chatData.last.listingViewModel = list;
    bloc
      ..updateListingDevices(list)
      ..updateChatUpdate(!bloc.state.chatUpdate);

    if (!bloc.state.isVoiceControlScreenActive) {
      unawaited(VoiceControlScreen.push(context.mounted ? context : context));
    }
  }

  Future<void> _handleEditLocationByName(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
      unawaited(LocationSettingsPage.push(context.mounted ? context : context));
    }
  }

  Future<void> _handleOpenDeviceManagement(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
      unawaited(
        ViewAllDevices.push(
          context.mounted ? context : context,
          isRoom: false,
        ),
      );
    }
  }

  Future<void> _handleAddNewDevice(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    unawaited(AutoScannerPage.push(context.mounted ? context : context));
  }

  Future<void> _handleDeleteLight(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final iotBloc = IotBloc.of(context.mounted ? context : context);
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    final profileBloc = ProfileBloc.of(context.mounted ? context : context);

    final deviceType = data["app_data"]["device_type"];
    final list = data["app_data"]["result"] as List;
    // final locationId = data["app_data"]["location_id"].toString();
    switch (deviceType) {
      case "light":
        if (list.length == 1) {
          await speak(model);
          editOrDeleteDevice(
            context.mounted ? context : context,
            data,
            edit: false,
          );
        } else {
          unawaited(multiListShow(data, bloc, model));
        }
      case "room":
        if (list.length == 1) {
          await speak(model);
          editOrDeleteDevice(
            context.mounted ? context : context,
            data,
            edit: false,
            isNotRoom: false,
          );
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in list) {
            final roomName = item["name"] ?? "";

            groupedByRoom.putIfAbsent("Rooms", () => []).add(roomName);
          }

          final resultList = groupedByRoom.entries.map((entry) {
            final cameraNames = entry.value;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name: " $formattedText",
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (resultList.isNotEmpty) {
            bloc.state.chatData.last.listingViewModel = resultList;
            bloc
              ..updateListingDevices(resultList)
              ..updateChatUpdate(!bloc.state.chatUpdate);
            if (resultList.length == 1) {
              await speak(model, text: "${model.text} ${resultList[0].name}");
            } else {
              logger.fine("${model.text} ${resultList.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${resultList.map((e) => e.name)}",
              );
            }
          }
        }
      case "rooms":
        if (list.length == 1) {
          await speak(model);
          editOrDeleteDevice(
            context.mounted ? context : context,
            data,
            edit: false,
            isNotRoom: false,
          );
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in list) {
            final roomName = item["name"] ?? "";

            groupedByRoom.putIfAbsent("Rooms", () => []).add(roomName);
          }

          final resultList = groupedByRoom.entries.map((entry) {
            final cameraNames = entry.value;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name: " $formattedText",
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (resultList.isNotEmpty) {
            bloc.state.chatData.last.listingViewModel = resultList;
            bloc
              ..updateListingDevices(resultList)
              ..updateChatUpdate(!bloc.state.chatUpdate);
            if (resultList.length == 1) {
              await speak(model, text: "${model.text} ${resultList[0].name}");
            } else {
              logger.fine("${model.text} ${resultList.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${resultList.map((e) => e.name)}",
              );
            }
          }
        }
      case "doorbell":
        if (list.length == 1) {
          unawaited(
            DoorbellControlsPage.push(
              context.mounted ? context : context,
              list[0]["id"],
              isDelete: true,
            ),
          );
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in data["app_data"]["result"]) {
            final cameraName = item["name"] ?? "";

            // if (locationId == item["location_id"].toString()) {
            groupedByRoom.putIfAbsent("", () => []).add(cameraName);
            // }
          }

          final list = groupedByRoom.entries.map((entry) {
            final cameraNames = entry.value;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name: formattedText,
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (list.isNotEmpty) {
            bloc.state.chatData.last.listingViewModel = list;
            if (list.length == 1) {
              await speak(model, text: "${model.text} ${list[0].name}");
            } else {
              logger.fine("${model.text} ${list.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${list.map((e) => e.name)}",
              );
            }
            bloc
              ..updateListingDevices(list)
              ..updateChatUpdate(!bloc.state.chatUpdate);
          }
        }
      case "camera":
        if (list.length == 1) {
          if (iotBloc.state.iotDeviceModel == null) {
            await iotBloc.callIotApi();
          }
          unawaited(
            DoorbellControlsPage.push(
              context.mounted ? context : context,
              list[0]["doorbell_id"],
              isCamera: true,
              isDelete: true,
              entityId: list[0]["entity_id"],
            ),
          );
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in list) {
            final roomName = item["name"] ?? "";

            groupedByRoom.putIfAbsent("Cameras", () => []).add(roomName);
          }

          final resultList = groupedByRoom.entries.map((entry) {
            final cameraNames = entry.value;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name: " $formattedText",
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (resultList.isNotEmpty) {
            bloc.state.chatData.last.listingViewModel = resultList;
            bloc
              ..updateListingDevices(resultList)
              ..updateChatUpdate(!bloc.state.chatUpdate);
            if (resultList.length == 1) {
              await speak(model, text: "${model.text} ${resultList[0].name}");
            } else {
              logger.fine("${model.text} ${resultList.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${resultList.map((e) => e.name)}",
              );
            }
          }
        }
      case "locations":
        if (list.length == 1) {
          await speak(model);
          if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
            final DoorbellLocations location =
                DoorbellLocations.fromDynamic(list[0]);
            unawaited(
              LocationSettingsPage.push(
                context.mounted ? context : context,
                location: location,
                isDelete: true,
              ),
            );
          }
        } else {
          final resultList = profileBloc.state!.locations!.map((e) {
            return ListingViewModel(
              name: e.name!,
              roomId: e.id.toString(),
              imageIcon: "",
            );
          }).toBuiltList();
          bloc.state.chatData.last.listingViewModel = resultList;
          bloc
            ..updateListingDevices(resultList)
            ..updateChatUpdate(!bloc.state.chatUpdate);
          if (resultList.length == 1) {
            await speak(model, text: "${model.text} ${resultList[0].name}");
          } else {
            logger.fine("${model.text} ${resultList.map((e) => e.name)}");
            await speak(
              model,
              text: "${model.text} ${resultList.map((e) => e.name)}",
            );
          }
        }
      default:
        if (list.length == 1) {
          await speak(model);
          editOrDeleteDevice(
            context.mounted ? context : context,
            data,
            edit: false,
          );
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in data["app_data"]["result"]) {
            final cameraName = item["name"] ?? "";

            groupedByRoom.putIfAbsent("", () => []).add(cameraName);
          }

          final list = groupedByRoom.entries.map((entry) {
            final cameraNames = entry.value;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name: formattedText,
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (list.isNotEmpty) {
            bloc.state.chatData.last.listingViewModel = list;
            if (list.length == 1) {
              await speak(model, text: "${model.text} ${list[0].name}");
            } else {
              logger.fine("${model.text} ${list.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${list.map((e) => e.name)}",
              );
            }
            bloc
              ..updateListingDevices(list)
              ..updateChatUpdate(!bloc.state.chatUpdate);
          }
        }
    }
  }

  Future<void> _handleAddRoom(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final IotBloc iotBloc = IotBloc.of(context.mounted ? context : context);

    if (singletonBloc.isViewer()) {
      await speak(model, text: "Viewer cannot add room");
      ToastUtils.errorToast(
        (context.mounted ? context : context)
            .appLocalizations
            .viewer_cannot_add_room,
      );
    } else {
      await speak(
        model,
      );
      iotBloc.resetRoomSelection();

      unawaited(
        showModalBottomSheet(
          context: context.mounted ? context : context,
          isScrollControlled: true,
          backgroundColor: CommonFunctions.getThemeBasedWidgetColorInverted(
            context.mounted ? context : context,
          ),
          builder: (context) {
            return const AddRoom();
          },
          showDragHandle: true,
        ),
      );
    }
  }

  Future<void> multiListShow(
    data,
    voiceBloc,
    model,
  ) async {
    final Map<String, List<String>> groupedByRoom = {};
    for (final item in data["app_data"]["result"]) {
      final roomName = item["room_name"] ?? "Unknown Room";
      final cameraName = item["name"] ?? "";

      groupedByRoom.putIfAbsent(roomName, () => []).add(
            cameraName,
          );
    }

    final list = groupedByRoom.entries.map((entry) {
      final roomName = entry.key;
      final cameraNames = entry.value;

      final formattedText = cameraNames.mapIndexed((index, name) {
        return " ${index + 1}. $name";
      }).join("\n\n");

      // if (resultList == null) {
      //   return ListingViewModel(
      //     name: "**Room Name: $roomName** \n\n $formattedText",
      //     roomId: "", // Or assign if you have roomId separately
      //     imageIcon: "",
      //     showNumbers: false,
      //   );
      // }
      return ListingViewModel(
        name: "**Room Name: $roomName** \n\n $formattedText",
        roomId: "", // Or assign if you have roomId separately
        imageIcon: "",
        showNumbers: false,
      );
    }).toBuiltList();

    if (list.isNotEmpty) {
      voiceBloc.state.chatData.last.listingViewModel = list;
      if (list.length == 1) {
        await speak(model, text: "${model.text} ${list[0].name}");
      } else {
        logger.fine("${model.text} ${list.map((e) => e.name)}");
        await speak(
          model,
          text: "${model.text} ${list.map((e) => e.name)}",
        );
      }
      voiceBloc
        ..updateListingDevices(list)
        ..updateChatUpdate(!voiceBloc.state.chatUpdate);
    }
  }

  Future<void> multiListShowStatus(
    data,
    voiceBloc,
    model,
  ) async {
    final Map<String, Map<String, String>> groupedByRoom = {};
    for (final item in data["app_data"]["result"]) {
      final cameraName = item["name"] ?? "";
      final status = item["status"] ?? "";
      final roomName = item["room_name"] ?? "Unknown Room";

      // Ensure the room entry exists
      groupedByRoom.putIfAbsent(roomName, () => {});

      // Add cameraName → status
      groupedByRoom[roomName]![cameraName] = status;
    }

    final list = groupedByRoom.entries.map((entry) {
      final roomName = entry.key; // e.g. "Living Room"
      final cameras = entry.value; // Map<String, String> (cameraName → status)

      // Format each camera
      final formattedText = cameras.entries.mapIndexed((index, cam) {
        final cameraName = cam.key;
        final status = cam.value;
        return " ${index + 1}. $cameraName **Status: $status**";
      }).join("\n\n");

      return ListingViewModel(
        name: "**Room: $roomName**\n\n$formattedText",
        roomId: "", // Or assign if you have roomId separately
        imageIcon: "",
        showNumbers: false,
      );
    }).toBuiltList();

    if (list.isNotEmpty) {
      voiceBloc.state.chatData.last.listingViewModel = list;
      if (list.length == 1) {
        await speak(model, text: "${model.text} ${list[0].name}");
      } else {
        logger.fine("${model.text} ${list.map((e) => e.name)}");
        await speak(
          model,
          text: "${model.text} ${list.map((e) => e.name)}",
        );
      }
      voiceBloc
        ..updateListingDevices(list)
        ..updateChatUpdate(!voiceBloc.state.chatUpdate);
    }
  }

  Future<void> _handleConnect(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    final startUpBloc = StartupBloc.of(context.mounted ? context : context);
    final list = (data["app_data"]["result"] ?? []) as List;
    final deviceType = data["app_data"]["device_type"];
    // final locationId = data["app_data"]["location_id"].toString();
    switch (deviceType) {
      case "light":
        if (list.length == 1) {
          final IotDeviceModel? device = bloc.state.iotDeviceModel
              ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
          if (device != null) {
            if (device.stateAvailable != 3) {
              await speak(model);
              voiceBloc.state.chatData.last.text =
                  model.text.replaceAll("[]", device.deviceName!);
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);

              unawaited(
                bloc.operateIotDevice(
                  device.entityId,
                  Constants.turnOn,
                ),
              );
            } else {
              voiceBloc.state.chatData.last.text = "Device Unreachable";
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
              await speak(model, text: "Device Unreachable");
            }
          }
        } else {
          unawaited(multiListShow(data, voiceBloc, model));
        }
      case "camera":
        if (list.length == 1) {
          await speak(model);
          final UserDeviceModel? device =
              startUpBloc.state.userDeviceModel?.firstWhereOrNull(
            (e) =>
                e.entityId == data["app_data"]["result"][0]["entity_id"] &&
                e.locationId == data["app_data"]["result"][0]["location_id"],
          );
          if (device != null) {
            unawaited(
              StreamingPage.push(
                context.mounted ? context : context,
                device.callUserId,
                device.id,
              ).then((_) {
                final v = VoipBloc.of(context.mounted ? context : context);
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
                  VoiceControlBloc.of(context).reinitializeWakeWord(context);
                });
              }),
            );
          }
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in list) {
            final roomName = item["name"] ?? "";

            groupedByRoom.putIfAbsent("Cameras", () => []).add(roomName);
          }

          final resultList = groupedByRoom.entries.map((entry) {
            final cameraNames = entry.value;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name: " $formattedText",
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (resultList.isNotEmpty) {
            voiceBloc.state.chatData.last.listingViewModel = resultList;
            voiceBloc
              ..updateListingDevices(resultList)
              ..updateChatUpdate(!voiceBloc.state.chatUpdate);
            if (resultList.length == 1) {
              await speak(model, text: "${model.text} ${resultList[0].name}");
            } else {
              logger.fine("${model.text} ${resultList.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${resultList.map((e) => e.name)}",
              );
            }
          }
        }
      case "doorbell":
        if (list.length == 1) {
          await speak(model);
          final UserDeviceModel? device =
              startUpBloc.state.userDeviceModel?.firstWhereOrNull(
            (e) => e.entityId == list[0]["entity_id"],
          );
          if (device != null) {
            unawaited(
              StreamingPage.push(
                context.mounted ? context : context,
                device.callUserId,
                device.id,
              ).then((_) {
                final v = VoipBloc.of(context.mounted ? context : context);
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
                  VoiceControlBloc.of(context).reinitializeWakeWord(context);
                });
              }),
            );
          }
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in data["app_data"]["result"]) {
            final cameraName = item["name"] ?? "";

            // if (locationId == item["location_id"].toString()) {
            groupedByRoom.putIfAbsent("", () => []).add(cameraName);
            // }
          }

          final list = groupedByRoom.entries.map((entry) {
            final cameraNames = entry.value;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name: formattedText,
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (list.isNotEmpty) {
            voiceBloc.state.chatData.last.listingViewModel = list;
            if (list.length == 1) {
              await speak(model, text: "${model.text} ${list[0].name}");
            } else {
              logger.fine("${model.text} ${list.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${list.map((e) => e.name)}",
              );
            }
            voiceBloc
              ..updateListingDevices(list)
              ..updateChatUpdate(!voiceBloc.state.chatUpdate);
          }
        }
      case "lock":
        if (list.length == 1) {
          final IotDeviceModel? device = bloc.state.iotDeviceModel
              ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
          if (device != null) {
            if (device.stateAvailable != 3) {
              unawaited(bloc.operateIotDevice(device.entityId, Constants.lock));
              await speak(model);
            } else {
              voiceBloc.state.chatData.last.text = "Device Unreachable";
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
              await speak(model, text: "Device Unreachable");
            }
          } else {
            voiceBloc.state.chatData.last.text = "Please connect lock";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Please connect lock");
          }
        } else {
          unawaited(multiListShow(data, voiceBloc, model));
        }
      case "curtain":
        if (list.length == 1) {
          final IotDeviceModel? device = bloc.state.iotDeviceModel
              ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
          if (device != null) {
            if (device.stateAvailable != 3) {
              final json = jsonDecode(device.details?['extra_param'] ?? "{}");

              await bloc.operateCurtain(
                deviceId: device.curtainDeviceId!,
                command: returnCurtainCommand(
                  false,
                  // device,
                ),
                entityId: device.entityId!,
                parameter: "default",
                val: 0.toString(),
                token: json["api_token"],
                secret: json['api_key'],
                fromOutsideRoom: true,
              );

              await speak(model);
            } else {
              voiceBloc.state.chatData.last.text = "Device Unreachable";
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
              await speak(model, text: "Device Unreachable");
            }
          } else {
            voiceBloc.state.chatData.last.text = "Please connect Curtains";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Please connect Curtains");
          }
        } else {
          unawaited(multiListShow(data, voiceBloc, model));
        }
      case "blind":
        if (list.length == 1) {
          final IotDeviceModel? device = bloc.state.iotDeviceModel
              ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
          if (device != null) {
            if (device.stateAvailable != 3) {
              final json = jsonDecode(device.details?['extra_param'] ?? "{}");

              unawaited(
                bloc.operateCurtain(
                  deviceId: device.curtainDeviceId!,
                  command: "setPosition",
                  parameter: device.entityId!.isSwitchBotBlind()
                      ? (setPositionBlinds(device, 0))
                      : "0,ff,${0}",
                  val: 0.toString(),
                  entityId: device.entityId!,
                  callback: () async {},
                  token: json["api_token"],
                  secret: json['api_key'],
                ),
              );
              await speak(model);
            } else {
              voiceBloc.state.chatData.last.text = "Device Unreachable";
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
              await speak(model, text: "Device Unreachable");
            }
          } else {
            voiceBloc.state.chatData.last.text = "Please connect Curtains";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Please connect Curtains");
          }
        } else {
          unawaited(multiListShow(data, voiceBloc, model));
        }
    }
  }

  String setPositionBlinds(IotDeviceModel device, val) {
    final currentPos = double.tryParse(
          device.curtainPosition!,
        ) ??
        0.0;

// Blind Tilt → must be multiple of 2
    final adjustedVal = (val.round() / 2).round() * 2;

    return currentPos > val ? "up;$adjustedVal" : "down;$adjustedVal";
  }

  String returnCurtainCommand(
    bool targetClosed,
  ) {
    return targetClosed ? "turnOff" : "turnOn";

    // return isBlind ? "closeDown" : "turnOff";
    // }
  }

  Future<void> _handleDisconnect(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final voiceBloc = VoiceControlBloc.of(context);
    final bloc = IotBloc.of(context);
    final startUpBloc = StartupBloc.of(context.mounted ? context : context);
    // final locationId = data["app_data"]["location_id"].toString();
    final list = (data["app_data"]["result"] ?? []) as List;
    final deviceType = data["app_data"]["device_type"];
    switch (deviceType) {
      case "light":
        if (list.length == 1) {
          await speak(model);
          final IotDeviceModel? device = bloc.state.iotDeviceModel
              ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
          if (device != null) {
            if (device.stateAvailable != 3) {
              voiceBloc.state.chatData.last.text =
                  model.text.replaceAll("[]", device.deviceName!);
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
              unawaited(
                bloc.operateIotDevice(
                  device.entityId,
                  Constants.turnOff,
                ),
              );
            } else {
              voiceBloc.state.chatData.last.text = "Device Unreachable";
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
              await speak(model, text: "Device Unreachable");
            }
          }
        } else {
          unawaited(multiListShow(data, voiceBloc, model));
        }
      case "camera":
        if (list.length == 1) {
          await speak(model);
          final UserDeviceModel? device =
              startUpBloc.state.userDeviceModel?.firstWhereOrNull(
            (e) =>
                e.entityId == data["app_data"]["result"][0]["entity_id"] &&
                e.locationId == data["app_data"]["result"][0]["location_id"],
          );
          if (bloc.state.iotDeviceModel == null) {
            await bloc.callIotApi();
          }
          if (device != null) {
            unawaited(
              DoorbellControlsPage.push(
                context.mounted ? context : context,
                device.id,
                isDelete: true,
                fromVoice: true,
              ),
            );

            // unawaited(
            //   StreamingPage.push(
            //     context.mounted ? context : context,
            //     device.callUserId,
            //     device.id,
            //   ).then((_) {
            //     final v = VoipBloc.of(context.mounted ? context : context);
            //     Future.delayed(const Duration(seconds: 3), () {
            //       unawaited(v.streamingPeerConnection?.dispose());
            //       v.streamingPeerConnection = null;
            //       VoiceControlBloc.of(context.mounted ? context : context)
            //           .reinitializeWakeWord(
            //         context.mounted ? context : context,
            //       );
            //     });
            //   }),
            // );
          }
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in list) {
            final roomName = item["name"] ?? "";

            groupedByRoom.putIfAbsent("Cameras", () => []).add(roomName);
          }

          final resultList = groupedByRoom.entries.map((entry) {
            final cameraNames = entry.value;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name: " $formattedText",
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (resultList.isNotEmpty) {
            voiceBloc.state.chatData.last.listingViewModel = resultList;
            voiceBloc
              ..updateListingDevices(resultList)
              ..updateChatUpdate(!voiceBloc.state.chatUpdate);
            if (resultList.length == 1) {
              await speak(model, text: "${model.text} ${resultList[0].name}");
            } else {
              logger.fine("${model.text} ${resultList.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${resultList.map((e) => e.name)}",
              );
            }
          }
        }
      case "doorbell":
        if (list.length == 1) {
          await speak(model);
          final device =
              UserDeviceModel.fromDynamic(data["app_data"]["result"][0]);
          unawaited(
            StreamingPage.push(
              context.mounted ? context : context,
              device.callUserId,
              device.id,
            ).then((_) {
              final v = VoipBloc.of(context.mounted ? context : context);
              Future.delayed(const Duration(seconds: 3), () {
                unawaited(v.streamingPeerConnection?.dispose());
                v.streamingPeerConnection = null;
                final navigatorState = singletonBloc.navigatorKey?.currentState;
                if (navigatorState == null) {
                  return;
                }
                final context = navigatorState.context;
                if (!context.mounted) {
                  return;
                }
                VoiceControlBloc.of(context).reinitializeWakeWord(context);
              });
            }),
          );
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in data["app_data"]["result"]) {
            final cameraName = item["name"] ?? "";

            // if (locationId == item["location_id"].toString()) {
            groupedByRoom.putIfAbsent("", () => []).add(cameraName);
            // }
          }

          final list = groupedByRoom.entries.map((entry) {
            final cameraNames = entry.value;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name: formattedText,
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (list.isNotEmpty) {
            voiceBloc.state.chatData.last.listingViewModel = list;
            if (list.length == 1) {
              await speak(model, text: "${model.text} ${list[0].name}");
            } else {
              logger.fine("${model.text} ${list.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${list.map((e) => e.name)}",
              );
            }
            voiceBloc
              ..updateListingDevices(list)
              ..updateChatUpdate(!voiceBloc.state.chatUpdate);
          }
        }
      case "lock":
        if (list.length == 1) {
          final IotDeviceModel? device = bloc.state.iotDeviceModel
              ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
          if (device != null) {
            if (device.stateAvailable != 3) {
              unawaited(
                bloc.operateIotDevice(device.entityId, Constants.unlock),
              );
              await speak(model);
            } else {
              voiceBloc.state.chatData.last.text = "Device Unreachable";
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
              await speak(model, text: "Device Unreachable");
            }
          } else {
            voiceBloc.state.chatData.last.text = "Please connect lock";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Please connect lock");
          }
        } else {
          unawaited(multiListShow(data, voiceBloc, model));
        }
      case "curtain":
        if (list.length == 1) {
          final IotDeviceModel? device =
              bloc.state.iotDeviceModel?.firstWhereOrNull(
            (e) =>
                e.entityId == data["app_data"]["result"][0]["entity_id"] &&
                e.locationId == data["app_data"]["result"][0]["location_id"],
          );
          if (device != null) {
            if (device.stateAvailable != 3) {
              final json = jsonDecode(device.details?['extra_param'] ?? "{}");
              await bloc.operateCurtain(
                deviceId: device.curtainDeviceId!,
                command: returnCurtainCommand(
                  true,
                  // device,
                ),
                entityId: device.entityId!,
                parameter: "default",
                val: 100.toString(),
                token: json["api_token"],
                secret: json['api_key'],
                fromOutsideRoom: true,
              );

              await speak(model);
            } else {
              voiceBloc.state.chatData.last.text = "Device Unreachable";
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
              await speak(model, text: "Device Unreachable");
            }
          } else {
            voiceBloc.state.chatData.last.text = "Please connect Curtains";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Please connect Curtains");
          }
        } else {
          unawaited(multiListShow(data, voiceBloc, model));
        }
      case "blind":
        if (list.length == 1) {
          final IotDeviceModel? device =
              bloc.state.iotDeviceModel?.firstWhereOrNull(
            (e) =>
                e.entityId == data["app_data"]["result"][0]["entity_id"] &&
                e.locationId == data["app_data"]["result"][0]["location_id"],
          );
          if (device != null) {
            if (device.stateAvailable != 3) {
              final json = jsonDecode(device.details?['extra_param'] ?? "{}");
              unawaited(
                bloc.operateCurtain(
                  deviceId: device.curtainDeviceId!,
                  command: "setPosition",
                  parameter: device.entityId!.isSwitchBotBlind()
                      ? (setPositionBlinds(device, 100))
                      : "0,ff,${100}",
                  val: 100.toString(),
                  entityId: device.entityId!,
                  callback: () async {},
                  token: json["api_token"],
                  secret: json['api_key'],
                ),
              );

              await speak(model);
            } else {
              voiceBloc.state.chatData.last.text = "Device Unreachable";
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
              await speak(model, text: "Device Unreachable");
            }
          } else {
            voiceBloc.state.chatData.last.text = "Please connect Curtains";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Please connect Curtains");
          }
        } else {
          unawaited(multiListShow(data, voiceBloc, model));
        }
      case "climate":
        if (list.length == 1) {
          await speak(model);
          editOrDeleteDevice(
            context.mounted ? context : context,
            data,
            edit: false,
          );
        } else {
          unawaited(multiListShow(data, voiceBloc, model));
        }
    }
  }

  Future<void> _handleEditLight(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    final profileBloc = ProfileBloc.of(context.mounted ? context : context);
    final iotBloc = IotBloc.of(context.mounted ? context : context);
    final deviceType = data["app_data"]["device_type"];
    final list = data["app_data"]["result"] as List;
    // final locationId = data["app_data"]["location_id"].toString();

    switch (deviceType) {
      case "light":
        if (list.length == 1) {
          await speak(model);
          editOrDeleteDevice(
            context.mounted ? context : context,
            data,
          );
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in data["app_data"]["result"]) {
            final roomName = item["room_name"] ?? "Unknown Room";
            final cameraName = item["name"] ?? "";

            groupedByRoom.putIfAbsent(roomName, () => []).add(cameraName);
          }

          final list = groupedByRoom.entries.map((entry) {
            final roomName = entry.key;
            final cameraNames = entry.value;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name: "**Room Name: $roomName** \n\n $formattedText",
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (list.isNotEmpty) {
            bloc.state.chatData.last.listingViewModel = list;
            if (list.length == 1) {
              await speak(model, text: "${model.text} ${list[0].name}");
            } else {
              logger.fine("${model.text} ${list.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${list.map((e) => e.name)}",
              );
            }
            bloc
              ..updateListingDevices(list)
              ..updateChatUpdate(!bloc.state.chatUpdate);
          }
        }
      case "doorbell":
        if (list.length == 1) {
          await speak(model);
          unawaited(
            DoorbellControlsPage.push(
              context.mounted ? context : context,
              list[0]["id"],
              isEditing: true,
            ),
          );
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in data["app_data"]["result"]) {
            final cameraName = item["name"] ?? "";

            // if (locationId == item["location_id"].toString()) {
            groupedByRoom.putIfAbsent("", () => []).add(cameraName);
            // }
          }

          final list = groupedByRoom.entries.map((entry) {
            final cameraNames = entry.value;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name: formattedText,
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (list.isNotEmpty) {
            bloc.state.chatData.last.listingViewModel = list;
            if (list.length == 1) {
              await speak(model, text: "${model.text} ${list[0].name}");
            } else {
              logger.fine("${model.text} ${list.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${list.map((e) => e.name)}",
              );
            }
            bloc
              ..updateListingDevices(list)
              ..updateChatUpdate(!bloc.state.chatUpdate);
          }
        }
      case "camera":
        if (list.length == 1) {
          await speak(model);
          if (iotBloc.state.iotDeviceModel == null) {
            await iotBloc.callIotApi();
          }
          unawaited(
            DoorbellControlsPage.push(
              context.mounted ? context : context,
              list[0]["doorbell_id"],
              isEditing: true,
              isCamera: true,
              entityId: list[0]["entity_id"],
            ),
          );
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in data["app_data"]["result"]) {
            final cameraName = item["name"] ?? "";

            // if (locationId == item["location_id"].toString()) {
            groupedByRoom.putIfAbsent("", () => []).add(cameraName);
            // }
          }

          final list = groupedByRoom.entries.map((entry) {
            final cameraNames = entry.value;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name: formattedText,
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (list.isNotEmpty) {
            bloc.state.chatData.last.listingViewModel = list;
            if (list.length == 1) {
              await speak(model, text: "${model.text} ${list[0].name}");
            } else {
              logger.fine("${model.text} ${list.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${list.map((e) => e.name)}",
              );
            }
            bloc
              ..updateListingDevices(list)
              ..updateChatUpdate(!bloc.state.chatUpdate);
          }
        }
      case "room":
        if (list.length == 1) {
          await speak(model);
          final IotBloc iotBloc =
              IotBloc.of(context.mounted ? context : context);
          if (iotBloc.state.getIotRoomsApi.data != null) {
            final RoomItemsModel roomItemsModel = iotBloc
                .state.getIotRoomsApi.data!
                .firstWhere((element) => element.roomType == list[0]["type"]);
            iotBloc.updateSelectedRoom(
              roomItemsModel,
            );
            unawaited(
              RoomAllDevices.push(
                context.mounted ? context : context,
                isEditRoom: true,
              ),
            );
          } else {
            await iotBloc.callIotRoomsApi();
            final RoomItemsModel roomItemsModel =
                iotBloc.state.getIotRoomsApi.data!.firstWhere(
              (element) => element.roomType == list[0]["room_type"],
            );
            iotBloc.updateSelectedRoom(
              roomItemsModel,
            );
            unawaited(
              RoomAllDevices.push(
                context.mounted ? context : context,
                isEditRoom: true,
              ),
            );
          }
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in data["app_data"]["result"]) {
            final roomName = item["room_name"] ?? "";
            final cameraName = item["name"] ?? "";

            groupedByRoom.putIfAbsent(roomName, () => []).add(cameraName);
          }

          final list = groupedByRoom.entries.map((entry) {
            final cameraNames = entry.value;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name: " $formattedText",
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (list.isNotEmpty) {
            bloc.state.chatData.last.listingViewModel = list;
            if (list.length == 1) {
              await speak(model, text: "${model.text} ${list[0].name}");
            } else {
              logger.fine("${model.text} ${list.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${list.map((e) => e.name)}",
              );
            }
            bloc
              ..updateListingDevices(list)
              ..updateChatUpdate(!bloc.state.chatUpdate);
          }
        }
      case "rooms":
        if (list.length == 1) {
          await speak(model);
          final IotBloc iotBloc =
              IotBloc.of(context.mounted ? context : context);
          if (iotBloc.state.getIotRoomsApi.data != null) {
            final RoomItemsModel roomItemsModel = iotBloc
                .state.getIotRoomsApi.data!
                .firstWhere((element) => element.roomType == list[0]["type"]);
            iotBloc.updateSelectedRoom(
              roomItemsModel,
            );
            unawaited(
              RoomAllDevices.push(
                context.mounted ? context : context,
                isEditRoom: true,
              ),
            );
          } else {
            await iotBloc.callIotRoomsApi();
            final RoomItemsModel roomItemsModel =
                iotBloc.state.getIotRoomsApi.data!.firstWhere(
              (element) => element.roomType == list[0]["room_type"],
            );
            iotBloc.updateSelectedRoom(
              roomItemsModel,
            );
            unawaited(
              RoomAllDevices.push(
                context.mounted ? context : context,
                isEditRoom: true,
              ),
            );
          }
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in data["app_data"]["result"]) {
            final roomName = item["room_name"] ?? "";
            final cameraName = item["name"] ?? "";

            groupedByRoom.putIfAbsent(roomName, () => []).add(cameraName);
          }

          final list = groupedByRoom.entries.map((entry) {
            final cameraNames = entry.value;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name: " $formattedText",
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (list.isNotEmpty) {
            bloc.state.chatData.last.listingViewModel = list;
            if (list.length == 1) {
              await speak(model, text: "${model.text} ${list[0].name}");
            } else {
              logger.fine("${model.text} ${list.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${list.map((e) => e.name)}",
              );
            }
            bloc
              ..updateListingDevices(list)
              ..updateChatUpdate(!bloc.state.chatUpdate);
          }
        }
      case "locations":
        if (list.length == 1) {
          await speak(model);
          if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
            final DoorbellLocations locations =
                DoorbellLocations.fromDynamic(list[0]);

            DoorbellManagementBloc.of(context.mounted ? context : context)
              ..updateCenter(
                LatLng(locations.latitude!, locations.longitude!),
              )
              ..updateMarkerPosition(
                LatLng(locations.latitude!, locations.longitude!),
              )
              ..updateCompanyAddress(locations.houseNo!)
              ..updateLocationName(locations.name!);

            unawaited(
              DoorbellMapPage.pushFromLocationScreen(
                context.mounted ? context : context,
                isEdit: true,
                location: locations,
                openPopUp: true,
                fromLocationSettings: true,
              ),
            );
          }
        } else {
          final resultList = profileBloc.state!.locations!.map((e) {
            return ListingViewModel(
              name: e.name!,
              roomId: e.id.toString(),
              imageIcon: "",
            );
          }).toBuiltList();
          bloc.state.chatData.last.listingViewModel = resultList;
          bloc
            ..updateListingDevices(resultList)
            ..updateChatUpdate(!bloc.state.chatUpdate);
          if (resultList.length == 1) {
            await speak(model, text: "${model.text} ${resultList[0].name}");
          } else {
            logger.fine("${model.text} ${resultList.map((e) => e.name)}");
            await speak(
              model,
              text: "${model.text} ${resultList.map((e) => e.name)}",
            );
          }
        }
      default:
        if (list.length == 1) {
          await speak(model);
          editOrDeleteDevice(
            context.mounted ? context : context,
            data,
          );
        } else {
          final Map<String, List<String>> groupedByRoom = {};
          for (final item in data["app_data"]["result"]) {
            final cameraName = item["name"] ?? "";

            groupedByRoom.putIfAbsent("", () => []).add(cameraName);
          }

          final list = groupedByRoom.entries.map((entry) {
            final cameraNames = entry.value;

            final formattedText = cameraNames.mapIndexed((index, name) {
              return " ${index + 1}. $name";
            }).join("\n\n");

            return ListingViewModel(
              name: formattedText,
              roomId: "", // Or assign if you have roomId separately
              imageIcon: "",
              showNumbers: false,
            );
          }).toBuiltList();

          if (list.isNotEmpty) {
            bloc.state.chatData.last.listingViewModel = list;
            if (list.length == 1) {
              await speak(model, text: "${model.text} ${list[0].name}");
            } else {
              logger.fine("${model.text} ${list.map((e) => e.name)}");
              await speak(
                model,
                text: "${model.text} ${list.map((e) => e.name)}",
              );
            }
            bloc
              ..updateListingDevices(list)
              ..updateChatUpdate(!bloc.state.chatUpdate);
          }
        }
    }
  }

  Future<void> _handleShowDeviceLightStatus(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    final iotBloc = IotBloc.of(context.mounted ? context : context);
    if (iotBloc.state.iotDeviceModel!.isNotEmpty) {
      final IotDeviceModel? device =
          iotBloc.state.iotDeviceModel?.firstWhereOrNull(
        (e) =>
            e.entityId == data["app_data"]["result"][0]["entity_id"] &&
            e.locationId == data["app_data"]["result"][0]["location_id"],
      );
      bloc.state.chatData.last.text =
          "${bloc.state.chatData.last.text?.replaceAll("[]", device?.deviceName ?? "")} is ${device?.stateAvailable == 1 ? "ON" : "OFF or Unavailable."}";
      bloc.updateChatUpdate(!bloc.state.chatUpdate);
      await speak(model, text: bloc.state.chatData.last.text);
      if (!bloc.state.isVoiceControlScreenActive) {
        unawaited(VoiceControlScreen.push(context.mounted ? context : context));
      }
    } else {
      await speak(model, text: "No light Connected");

      bloc.state.chatData.last.text = "No light Connected";
      bloc.updateChatUpdate(!bloc.state.chatUpdate);
    }

    /// Implement show device light status logic
  }

  Future<void> _handleSetThermostatTemperature(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    // await speak(
    //   model,
    // );
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            final double f;
            if (data["attributes"]["scale"] == "C") {
              if (device.thermostatTemperatureUnit!.contains("F")) {
                f = celsiusToFahrenheit(
                  double.parse(data["attributes"]["temperature"].toString()),
                );
              } else {
                f = double.parse(data["attributes"]["temperature"].toString());
              }
            } else {
              if (device.thermostatTemperatureUnit!.contains("C")) {
                f = fahrenheitToCelsius(
                  double.parse(data["attributes"]["temperature"].toString()),
                );
              } else {
                f = double.parse(data["attributes"]["temperature"].toString());
              }
            }
            final json = jsonDecode(device.configuration ?? "{}");
            if (f >=
                    double.parse(
                      (json["a"]?["min_temp"] ?? 0).toString(),
                    ) &&
                f <=
                    double.parse(
                      (json["a"]?["max_temp"] ?? 100).toString(),
                    )) {
              unawaited(
                bloc.operateIotDevice(
                  device.entityId,
                  Constants.setTemperature,
                  otherValues: {
                    "entity_id": "${device.entityId}",
                    "temperature": f,
                  },
                ),
              );
              await Future.delayed(const Duration(seconds: 2));
              voiceBloc.state.chatData.last.text =
                  "The thermostat temperature is set to ${f.toStringAsFixed(0)}${device.thermostatTemperatureUnit}";
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
              await speak(
                model,
                text:
                    "The thermostat temperature is set to ${f.toStringAsFixed(0)}${device.thermostatTemperatureUnit}",
              );
            } else {
              await Future.delayed(const Duration(seconds: 2));
              voiceBloc.state.chatData.last.text =
                  "The requested temperature is not in between ${double.parse(
                (json["a"]?["min_temp"] ?? 0).toString(),
              ).toStringAsFixed(0)} - ${double.parse(
                (json["a"]?["max_temp"] ?? 100).toString(),
              ).toStringAsFixed(0)}${device.thermostatTemperatureUnit}";
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
              await speak(
                model,
                text:
                    "The requested temperature is not in between ${double.parse(
                  (json["a"]?["min_temp"] ?? 0).toString(),
                ).toStringAsFixed(0)} - ${double.parse(
                  (json["a"]?["max_temp"] ?? 100).toString(),
                ).toStringAsFixed(0)}${device.thermostatTemperatureUnit}",
              );
            }
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          voiceBloc.state.chatData.last.text = "Please connect Thermostat";
          voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
          await speak(model, text: "Please connect Thermostat");
        }
      }
    }
  }

  Future<void> _handleSetCurtainPosition(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);

    /// Implement set curtain position logic
  }

  Future<void> _handleTransferOwnership(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
      unawaited(LocationSettingsPage.push(context.mounted ? context : context));
    }

    /// Implement transfer ownership logic
  }

  Future<void> _handleCreateAiTheme(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    unawaited(CreateAIThemeScreen.push(context.mounted ? context : context));
  }

  Future<void> _handleIncreaseThermostatTemperature(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    // await speak(model);
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            final double f;

            final int temp = data["attributes"]["temp_change"] == null
                ? 1
                : data["attributes"]["temp_change"].toString().isEmpty
                    ? 1
                    : int.parse(data["attributes"]["temp_change"].toString());

            f = double.parse(device.temperature!) + temp;

            final json = jsonDecode(device.configuration ?? "{}");
            if (f >=
                    double.parse(
                      (json["a"]?["min_temp"] ?? 0).toString(),
                    ) &&
                f <=
                    double.parse(
                      (json["a"]?["max_temp"] ?? 100).toString(),
                    )) {
              unawaited(
                bloc.operateIotDevice(
                  device.entityId,
                  Constants.setTemperature,
                  otherValues: {
                    "entity_id": "${device.entityId}",
                    "temperature": f,
                  },
                ),
              );
              await Future.delayed(const Duration(seconds: 2));
              voiceBloc.state.chatData.last.text =
                  "The thermostat temperature is set to ${f.toStringAsFixed(0)}${device.thermostatTemperatureUnit}";
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
              await speak(
                model,
                text:
                    "The thermostat temperature is set to ${f.toStringAsFixed(0)}${device.thermostatTemperatureUnit}",
              );
            } else {
              voiceBloc.state.chatData.last.text =
                  "The requested temperature is not in between ${double.parse(
                (json["a"]?["min_temp"] ?? 0).toString(),
              )} - ${double.parse(
                (json["a"]?["max_temp"] ?? 100).toString(),
              )}${device.thermostatTemperatureUnit}";
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
              await speak(
                model,
                text:
                    "The requested temperature is not in between ${double.parse(
                  (json["a"]?["min_temp"] ?? 0).toString(),
                )} - ${double.parse(
                  (json["a"]?["max_temp"] ?? 100).toString(),
                )}${device.thermostatTemperatureUnit}",
              );
            }
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          voiceBloc.state.chatData.last.text = "Please connect Thermostat";
          voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
          await speak(model, text: "Please connect Thermostat");
        }
      }
    }

    /// Implement increase thermostat temperature logic
  }

  Future<void> _handleDecreaseThermostatTemperature(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            final double f;

            final int temp = data["attributes"]["temp_change"] == null
                ? 1
                : data["attributes"]["temp_change"].toString().isEmpty
                    ? 1
                    : int.parse(data["attributes"]["temp_change"].toString());
            f = double.parse(device.temperature!) - temp;
            final json = jsonDecode(device.configuration ?? "{}");
            if (f >=
                    double.parse(
                      (json["a"]?["min_temp"] ?? 0).toString(),
                    ) &&
                f <=
                    double.parse(
                      (json["a"]?["max_temp"] ?? 100).toString(),
                    )) {
              unawaited(
                bloc.operateIotDevice(
                  device.entityId,
                  Constants.setTemperature,
                  otherValues: {
                    "entity_id": "${device.entityId}",
                    "temperature": f,
                  },
                ),
              );
              await Future.delayed(const Duration(seconds: 2));
              voiceBloc.state.chatData.last.text =
                  "The thermostat temperature is set to ${f.toStringAsFixed(0)}${device.thermostatTemperatureUnit}";
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
              await speak(
                model,
                text:
                    "The thermostat temperature is set to ${f.toStringAsFixed(0)}${device.thermostatTemperatureUnit}",
              );
            } else {
              await Future.delayed(const Duration(seconds: 2));
              voiceBloc.state.chatData.last.text =
                  "The requested temperature is not in between ${double.parse(
                (json["a"]?["min_temp"] ?? 0).toString(),
              )} - ${double.parse(
                (json["a"]?["max_temp"] ?? 100).toString(),
              )}${device.thermostatTemperatureUnit}";
              voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
              await speak(
                model,
                text:
                    "The requested temperature is not in between ${double.parse(
                  (json["a"]?["min_temp"] ?? 0).toString(),
                )} - ${double.parse(
                  (json["a"]?["max_temp"] ?? 100).toString(),
                )}${device.thermostatTemperatureUnit}",
              );
            }
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          voiceBloc.state.chatData.last.text = "Please connect Thermostat";
          voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
          await speak(model, text: "Please connect Thermostat");
        }
      }
    }

    /// Implement increase thermostat temperature logic
  }

  Future<void> _handleSwitchThermostatModesHeat(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    await speak(
      model,
    );
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            unawaited(
              bloc.operateIotDevice(
                device.entityId,
                "climate/set_hvac_mode",
                otherValues: {
                  "entity_id": "${device.entityId}",
                  "hvac_mode": "heat".toLowerCase(),
                },
              ),
            );
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          voiceBloc.state.chatData.last.text = "Please connect Thermostat";
          voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
          await speak(model, text: "Please connect Thermostat");
        }
      }
    }

    /// Implement switch thermostat modes heat logic
  }

  Future<void> _handleSwitchThermostatModesCool(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    await speak(
      model,
    );
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            unawaited(
              bloc.operateIotDevice(
                device.entityId,
                "climate/set_hvac_mode",
                otherValues: {
                  "entity_id": "${device.entityId}",
                  "hvac_mode": "cool".toLowerCase(),
                },
              ),
            );
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          voiceBloc.state.chatData.last.text = "Please connect Thermostat";
          voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
          await speak(model, text: "Please connect Thermostat");
        }
      }
    }

    /// Implement switch thermostat modes cool logic
  }

  Future<void> _handleSwitchThermostatModesOff(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    await speak(
      model,
    );
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            unawaited(
              bloc.operateIotDevice(
                device.entityId,
                "climate/set_hvac_mode",
                otherValues: {
                  "entity_id": "${device.entityId}",
                  "hvac_mode": "off".toLowerCase(),
                },
              ),
            );
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          voiceBloc.state.chatData.last.text = "Please connect Thermostat";
          voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
          await speak(model, text: "Please connect Thermostat");
        }
      }
    }

    /// Implement switch thermostat modes off logic
  }

  Future<void> _handleOpenCameraStatusByCameraName(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    await speak(
      model,
    );
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        bloc.state.chatData.last.text =
            "${list[0]["name"]} is ${list[0]["is_active"] == true ? 'Active' : 'Inactive'}";
        bloc.updateChatUpdate(!bloc.state.chatUpdate);
      }
    }

    /// Implement open live stream by room and camera name logic
  }

  Future<void> _handleSwitchThermostatFanOn(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    await speak(
      model,
    );
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            unawaited(
              bloc.operateIotDevice(
                device.entityId,
                "climate/set_fan_mode",
                otherValues: {
                  "entity_id": "${device.entityId}",
                  "fan_mode": "ON".toLowerCase(),
                },
              ),
            );
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          voiceBloc.state.chatData.last.text = "Please connect Thermostat";
          voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
          await speak(model, text: "Please connect Thermostat");
        }
      }
    }

    /// Implement switch thermostat fan on logic
  }

  Future<void> _handleSwitchThermostatFanAuto(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    await speak(
      model,
    );
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            unawaited(
              bloc.operateIotDevice(
                device.entityId,
                "climate/set_fan_mode",
                otherValues: {
                  "entity_id": "${device.entityId}",
                  "fan_mode": "AUTO".toLowerCase(),
                },
              ),
            );
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          voiceBloc.state.chatData.last.text = "Please connect Thermostat";
          voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
          await speak(model, text: "Please connect Thermostat");
        }
      }
    }

    /// Implement switch thermostat fan auto logic
  }

  Future<void> _handleSwitchThermostatFanDiffuse(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    await speak(
      model,
    );
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            unawaited(
              bloc.operateIotDevice(
                device.entityId,
                "climate/set_fan_mode",
                otherValues: {
                  "entity_id": "${device.entityId}",
                  "fan_mode": "DIFFUSE".toLowerCase(),
                },
              ),
            );
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          voiceBloc.state.chatData.last.text = "Please connect Thermostat";
          voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
          await speak(model, text: "Please connect Thermostat");
        }
      }
    }

    /// Implement switch thermostat fan diffuse logic
  }

  Future<void> _handleLocationReleaseByName(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    if (data["app_data"]["result"] != null) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final DoorbellLocations? location = singletonBloc
            .profileBloc.state!.locations
            ?.firstWhereOrNull((e) => e.id == list[0]["id"]);
        if (location != null) {
          await speak(model);
          final bloc = LocationBloc.of(context.mounted ? context : context);
          final userProfileBloc =
              UserProfileBloc.of(context.mounted ? context : context);
          unawaited(
            showDialog(
              context: context.mounted ? context : context,
              builder: (validatePasswordContext) {
                return ValidatePasswordDialog(
                  userProfileBloc: userProfileBloc,
                  successFunction: () {
                    ProfileOtpPage.push(
                      context,
                      otpFor: "release_location",
                      successReleaseTransferFunction: () {
                        unawaited(
                          bloc.callReleaseLocation(
                            locationId: location.id!,
                            successFunction: () {
                              bloc.successRelease(context, location);
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        }
      } else {
        final bloc = VoiceControlBloc.of(context.mounted ? context : context);
        final profileBloc = ProfileBloc.of(context.mounted ? context : context);

        final locationList = <ListingViewModel>[
          ListingViewModel(
            name:
                "**Location Name** \n\n ${profileBloc.state!.locations!.mapIndexed((index, entry) {
              return " ${index + 1}. ${entry.name}";
            }).join("\n\n")}",
            imageIcon: "",
            showNumbers: false,
          ),
        ].toBuiltList();

        bloc.state.chatData.last.listingViewModel = locationList;
        if (list.length == 1) {
          await speak(model, text: "${model.text} ${locationList[0].name}");
        } else {
          logger.fine("${model.text} ${locationList.map((e) => e.name)}");
          await speak(
            model,
            text: "${model.text} ${locationList.map((e) => e.name)}",
          );
        }
        bloc
          ..updateListingDevices(locationList)
          ..updateChatUpdate(!bloc.state.chatUpdate);

        if (!bloc.state.isVoiceControlScreenActive) {
          unawaited(
            VoiceControlScreen.push(context.mounted ? context : context),
          );
        }
      }
    }

    /// Implement location release by name logic
  }

  Future<void> deleteDevice(BuildContext context, data, text, model) async {
    final bloc = IotBloc.of(context.mounted ? context : context);
    final startUpBloc = StartupBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null) {
      final UserDeviceModel? device =
          startUpBloc.state.userDeviceModel?.firstWhereOrNull(
        (e) =>
            e.entityId == data["app_data"]["result"][0]["entity_id"] &&
            e.locationId == data["app_data"]["result"][0]["location_id"],
      );

      await bloc.deleteIotDevice(device!.id, device.entityId!, () async {
        await speak(model);
        unawaited(startUpBloc.callEverything());
      });
    }
  }

  Future<void> _handleChangeLightColor(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    // await speak(model);
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            voiceBloc.state.chatData.last.text = model.text;
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(
              model,
              text: model.text.replaceAll("[]", device.deviceName!),
            );
            unawaited(
              bloc.operateIotDevice(
                device.entityId,
                Constants.turnOn,
                otherValues: {
                  Constants.rgbwColor:
                      hexToColorArray(data["attributes"]["color"]),
                },
              ),
            );
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        }
      } else {
        unawaited(
          multiListShowStatus(
            data,
            bloc,
            model,
          ),
        );
      }
    }
  }

  Future<void> _handleChangeColor(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            voiceBloc.state.chatData.last.text =
                model.text.replaceAll("[]", device.deviceName!);
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(
              model,
              text: model.text.replaceAll("[]", device.deviceName!),
            );
            unawaited(
              bloc.operateIotDevice(
                device.entityId,
                Constants.turnOn,
                otherValues: {
                  Constants.rgbwColor:
                      hexToColorArray(data["attributes"]["color"]),
                },
              ),
            );
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        }
      }
    }

    /// Implement change color logic
  }

  Future<void> _handleChangeBrightness(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            voiceBloc.state.chatData.last.text =
                model.text.replaceAll("[]", device.deviceName!);
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);

            final value = ((double.parse(
                          data["attributes"]["brightness"]
                              .toString()
                              .split("%")[0],
                        ) /
                        100) *
                    255)
                .round();
            unawaited(
              bloc.operateIotDevice(
                device.entityId,
                Constants.turnOn,
                otherValues: {"brightness": "$value"},
              ),
            );
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        }
      } else {
        unawaited(
          multiListShowStatus(
            data,
            bloc,
            model,
          ),
        );
      }
    }
  }

  Future<void> _handleChangeLightMode(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            if (list[0]["mode"] != null) {
              if (list[0]["mode"] == "Wake up") {
                list[0]["mode"] = "Wake up";
              } else if (list[0]["mode"] == "Warm White") {
                list[0]["mode"] = "Warm white";
              }
            }
            voiceBloc.state.chatData.last.text =
                model.text.replaceAll("[]", device.deviceName!);
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(
              model,
              text: model.text.replaceAll("[]", device.deviceName!),
            );
            unawaited(
              bloc.operateIotDevice(
                device.entityId,
                Constants.turnOn,
                otherValues: {"effect": "${list[0]["mode"]}"},
              ),
            );
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        }
      } else {
        unawaited(
          multiListShowStatus(
            data,
            bloc,
            model,
          ),
        );
      }
    }
  }

  Future<void> _handleShowCurrentThemeApplied(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final ThemeDataModel theme = ThemeDataModel.fromDynamic(data["app_data"]);
    unawaited(
      PreviewWidget.push(
        context.mounted ? context : context,
        BoxFit.fill,
        [theme].toBuiltList(),
        0,
        showForPreviewOnly: true,
        true,
      ),
    );

    /// Implement show current theme applied logic
  }

  Future<void> _handleMakeACallWithVisitor(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    final finalList = data["app_data"]["result"] as List;
    if (finalList.length == 1) {
      await speak(model);

      final startupBloc = StartupBloc.of(context.mounted ? context : context);
      final UserDeviceModel? deviceModel =
          startupBloc.state.userDeviceModel!.firstWhereOrNull(
        (e) => e.deviceId == data["app_data"]["result"][0]["device_id"],
      );
      if (deviceModel != null) {
        final voipBloc = VoipBloc.of(context.mounted ? context : context);
        if (model.command!.contains("VIDEO")) {
          if (data["attributes"]["call_type"] == null ||
              data["attributes"]["call_type"].toString().isEmpty) {
            voipBloc
              ..resetTimer()
              ..isTwoWayEmit();
            unawaited(
              CallingScreen.push(
                context.mounted ? context : context,
                deviceModel.callUserId,
                false,
                callType: Constants.doorbellVideoCall,
              ),
            );
          } else {
            if (data["attributes"]["call_type"] == "one-way") {
              voipBloc
                ..resetTimer()
                ..isOneWayEmit();
              unawaited(
                CallingScreen.push(
                  context.mounted ? context : context,
                  deviceModel.callUserId,
                  false,
                  callType: "one_way_video",
                ),
              );
            } else {
              voipBloc
                ..resetTimer()
                ..isTwoWayEmit();
              unawaited(
                CallingScreen.push(
                  context.mounted ? context : context,
                  deviceModel.callUserId,
                  false,
                  callType: Constants.doorbellVideoCall,
                ),
              );
            }
          }

          // data["app_data"][0][4]
        } else {
          voipBloc
            ..resetTimer()
            ..isAudioEmit();
          unawaited(
            CallingScreen.push(
              context.mounted ? context : context,
              deviceModel.callUserId,
              false,
              callType: Constants.doorbellAudioCall,
            ),
          );
        }
      }
    } else {
      // final locationId = data["app_data"]["location_id"].toString();
      final Map<String, List<String>> groupedByRoom = {};
      for (final item in data["app_data"]["result"]) {
        final cameraName = item["name"] ?? "";

        // if (locationId == item["location_id"].toString()) {
        groupedByRoom.putIfAbsent("", () => []).add(cameraName);
        // }

        final list = groupedByRoom.entries.map((entry) {
          final cameraNames = entry.value;

          final formattedText = cameraNames.mapIndexed((index, name) {
            return " ${index + 1}. $name";
          }).join("\n\n");

          return ListingViewModel(
            name: formattedText,
            roomId: "", // Or assign if you have roomId separately
            imageIcon: "",
            showNumbers: false,
          );
        }).toBuiltList();

        if (list.isNotEmpty) {
          bloc.state.chatData.last.listingViewModel = list;
          if (list.length == 1) {
            await speak(model, text: "${model.text} ${list[0].name}");
          } else {
            logger.fine("${model.text} ${list.map((e) => e.name)}");
            await speak(
              model,
              text: "${model.text} ${list.map((e) => e.name)}",
            );
          }
          bloc
            ..updateListingDevices(list)
            ..updateChatUpdate(!bloc.state.chatUpdate);
        }
      }
    }

    /// Implement make a call with visitor logic
  }

  Future<void> _handleAddNameToUnwantedVisitor(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final vBloc = VisitorManagementBloc.of(context.mounted ? context : context);
    final VisitorsModel visitorsModel =
        VisitorsModel.fromDynamic(data["app_data"]);
    unawaited(vBloc.callMarkWantedOrUnwantedVisitor(visitorsModel));

    /// Implement add name to unwanted visitor logic
  }

  // Future<void> _handleShowVisitorChatHistoryByName(
  //   BuildContext context,
  //   VoiceControlModel model,
  //   data,
  // ) async {
  //   await speak(model);
  //
  //   /// Implement show visitor chat history by name logic
  // }

  Future<void> _handleDevicesByRoom(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);

    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final Map<String, List<String>> groupedByRoom = {};

      for (final item in data["app_data"]["result"]) {
        final roomName = item["room_name"] ?? "Unknown Room";
        final cameraName = item["name"] ?? "";

        groupedByRoom.putIfAbsent(roomName, () => []).add(cameraName);
      }

      final list = groupedByRoom.entries.map((entry) {
        final roomName = entry.key;
        final cameraNames = entry.value;

        final formattedText = cameraNames.mapIndexed((index, name) {
          return " ${index + 1}. $name";
        }).join("\n\n");

        return ListingViewModel(
          name: "**Room Name: $roomName** \n\n $formattedText",
          roomId: "", // Or assign if you have roomId separately
          imageIcon: "",
          showNumbers: false,
        );
      }).toBuiltList();

      if (list.isNotEmpty) {
        bloc.state.chatData.last.listingViewModel = list;
        bloc
          ..updateListingDevices(list)
          ..updateChatUpdate(!bloc.state.chatUpdate);
      }
    }
  }

  Future<void> _handleShowThermostatTemperature(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    await speak(
      model,
    );
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            await Future.delayed(const Duration(seconds: 2));
            voiceBloc.state.chatData.last.text =
                "Thermostat Temperature is ${device.temperature}${device.thermostatTemperatureUnit}.";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(
              model,
              text:
                  "Thermostat Temperature is ${device.temperature}${device.thermostatTemperatureUnit}.",
            );
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          voiceBloc.state.chatData.last.text = "Please connect Thermostat";
          voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
          await speak(model, text: "Please connect Thermostat");
        }
      }
    }

    /// Implement show thermostat temperature logic
  }

  Future<void> _handleShowCurtainPosition(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            await Future.delayed(const Duration(seconds: 2));
            voiceBloc.state.chatData.last.text =
                "Curtain is ${double.parse(device.curtainPosition!) > 90 ? "Closed" : double.parse(device.curtainPosition!).toInt() == 0 ? "Fully Opened" : "${double.parse(device.curtainPosition!).toInt()}% Close"}";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(
              model,
              text:
                  "Curtain is ${double.parse(device.curtainPosition!) > 90 ? "Closed" : double.parse(device.curtainPosition!).toInt() == 0 ? "Fully Opened" : "${double.parse(device.curtainPosition!).toInt()}% Close"}",
            );
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          voiceBloc.state.chatData.last.text = "Please connect Curtains";
          voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
          await speak(model, text: "Please connect Curtains");
        }
      }
    }

    /// Implement show curtain position logic
  }

  Future<void> _handleShowBlindsStatus(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    /// Implement show curtain status logic
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            voiceBloc.state.chatData.last.text =
                "Blind is ${double.parse(device.curtainPosition!) > 90 ? "Closed" : double.parse(device.curtainPosition!).toInt() == 0 ? "Fully Opened" : "Partially Closed"}";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(
              model,
              text:
                  "Blind is ${double.parse(device.curtainPosition!) > 90 ? "Closed" : double.parse(device.curtainPosition!).toInt() == 0 ? "Fully Opened" : "Partially Closed"}",
            );
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          voiceBloc.state.chatData.last.text = "Please connect Blinds";
          voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
          await speak(model, text: "Please connect Blinds");
        }
      }
    }
  }

  Future<void> _handleShowTemperatureInside(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);
    final bloc = IotBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = bloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            await Future.delayed(const Duration(seconds: 2));
            final json = jsonDecode(device.configuration ?? "{}");
            voiceBloc.state.chatData.last.text =
                "Thermostat Temperature is ${json["a"]?["current_temperature"]}${device.thermostatTemperatureUnit}.";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(
              model,
              text:
                  "Thermostat Temperature is ${json["a"]?["current_temperature"]}${device.thermostatTemperatureUnit}.",
            );
          } else {
            voiceBloc.state.chatData.last.text = "Device Unreachable";
            voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          voiceBloc.state.chatData.last.text = "Please connect Thermostat";
          voiceBloc.updateChatUpdate(!voiceBloc.state.chatUpdate);
          await speak(model, text: "Please connect Thermostat");
        }
      }
    }

    /// Implement show temperature inside logic
  }

  Future<void> _handleIncreaseCooling(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    final iotBloc = IotBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = iotBloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            final double f;

            if (device.mode.toString().toLowerCase().contains("cool")) {
              f = double.parse(device.temperature!) - 2;
              unawaited(
                iotBloc.operateIotDevice(
                  device.entityId,
                  Constants.setTemperature,
                  otherValues: {
                    "entity_id": "${device.entityId}",
                    "temperature": f,
                  },
                ),
              );
            } else {
              await Future.delayed(const Duration(seconds: 2));
              bloc.state.chatData.last.text =
                  "Sorry, your thermostat is Heat mode";
              bloc.updateChatUpdate(!bloc.state.chatUpdate);
              await speak(model, text: "Sorry, your thermostat is Heat mode");
            }
          } else {
            bloc.state.chatData.last.text = "Device Unreachable";
            bloc.updateChatUpdate(!bloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          bloc.state.chatData.last.text = "Please connect Thermostat";
          bloc.updateChatUpdate(!bloc.state.chatUpdate);
          await speak(model, text: "Please connect Thermostat");
        }
      }
    }

    /// Implement increase heating logic
  }

  Future<void> _handleDecreaseCooling(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    final iotBloc = IotBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = iotBloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            final double f;

            if (device.mode.toString().toLowerCase().contains("cool")) {
              f = double.parse(device.temperature!) + 2;
              unawaited(
                iotBloc.operateIotDevice(
                  device.entityId,
                  Constants.setTemperature,
                  otherValues: {
                    "entity_id": "${device.entityId}",
                    "temperature": f,
                  },
                ),
              );
            } else {
              await Future.delayed(const Duration(seconds: 2));
              bloc.state.chatData.last.text =
                  "Sorry, your thermostat is Heat mode";
              bloc.updateChatUpdate(!bloc.state.chatUpdate);

              await speak(model, text: "Sorry, your thermostat is Heat mode");
            }
          } else {
            bloc.state.chatData.last.text = "Device Unreachable";
            bloc.updateChatUpdate(!bloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          bloc.state.chatData.last.text = "Please connect Thermostat";
          bloc.updateChatUpdate(!bloc.state.chatUpdate);
          await speak(model, text: "Please connect Thermostat");
        }
      }
    }

    /// Implement increase heating logic
  }

  Future<void> _handleDecreaseHeating(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    final iotBloc = IotBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = iotBloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            final double f;

            if (device.mode.toString().toLowerCase().contains("cool")) {
              await Future.delayed(const Duration(seconds: 2));
              bloc.state.chatData.last.text =
                  "Sorry, your thermostat is Cool mode";
              bloc.updateChatUpdate(!bloc.state.chatUpdate);

              await speak(model, text: "Sorry, your thermostat is Cool mode");
            } else {
              f = double.parse(device.temperature!) - 2;
              unawaited(
                iotBloc.operateIotDevice(
                  device.entityId,
                  Constants.setTemperature,
                  otherValues: {
                    "entity_id": "${device.entityId}",
                    "temperature": f,
                  },
                ),
              );
            }
          } else {
            bloc.state.chatData.last.text = "Device Unreachable";
            bloc.updateChatUpdate(!bloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          bloc.state.chatData.last.text = "Please connect Thermostat";
          bloc.updateChatUpdate(!bloc.state.chatUpdate);
          await speak(model, text: "Please connect Thermostat");
        }
      }
    }

    /// Implement increase heating logic
  }

  Future<void> _handleIncreaseHeating(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    final iotBloc = IotBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final list = data["app_data"]["result"] as List;
      if (list.length == 1) {
        final IotDeviceModel? device = iotBloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        if (device != null) {
          if (device.stateAvailable != 3) {
            final double f;

            if (device.mode.toString().toLowerCase().contains("cool")) {
              await Future.delayed(const Duration(seconds: 2));
              bloc.state.chatData.last.text =
                  "Sorry, your thermostat is Cool mode";
              bloc.updateChatUpdate(!bloc.state.chatUpdate);

              await speak(model, text: "Sorry, your thermostat is Cool mode");
            } else {
              f = double.parse(device.temperature!) + 2;
              unawaited(
                iotBloc.operateIotDevice(
                  device.entityId,
                  Constants.setTemperature,
                  otherValues: {
                    "entity_id": "${device.entityId}",
                    "temperature": f,
                  },
                ),
              );
            }
          } else {
            bloc.state.chatData.last.text = "Device Unreachable";
            bloc.updateChatUpdate(!bloc.state.chatUpdate);
            await speak(model, text: "Device Unreachable");
          }
        } else {
          bloc.state.chatData.last.text = "Please connect Thermostat";
          bloc.updateChatUpdate(!bloc.state.chatUpdate);
          await speak(model, text: "Please connect Thermostat");
        }
      }
    }

    /// Implement increase heating logic
  }

  Future<void> _handleShowDevicesByRoom(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);
    if (data["app_data"]["result"] != null &&
        data["app_data"]["result"] is List) {
      final Map<String, List<String>> groupedByRoom = {};

      for (final item in data["app_data"]["result"]) {
        final roomName = item["room_name"] ?? "Unknown Room";
        final cameraName = item["name"] ?? "";

        groupedByRoom.putIfAbsent(roomName, () => []).add(cameraName);
      }

      final list = groupedByRoom.entries.map((entry) {
        final roomName = entry.key;
        final cameraNames = entry.value;

        final formattedText = cameraNames.mapIndexed((index, name) {
          return " ${index + 1}. $name";
        }).join("\n\n");

        return ListingViewModel(
          name: "**Room Name: $roomName** \n\n $formattedText",
          roomId: "", // Or assign if you have roomId separately
          imageIcon: "",
          showNumbers: false,
        );
      }).toBuiltList();

      if (list.isNotEmpty) {
        bloc.state.chatData.last.listingViewModel = list;
        bloc.updateListingDevices(list);
      }
    }
  }

  Future<void> _handleMoveDevicesToRoom(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final bloc = VoiceControlBloc.of(context.mounted ? context : context);

    final list = data["app_data"]["result"] as List;
    if (list.length == 1) {
      await speak(model);
      final IotBloc iotBloc = IotBloc.of(context.mounted ? context : context);
      if (iotBloc.state.getIotRoomsApi.data != null) {
        final IotDeviceModel? device = iotBloc.state.iotDeviceModel
            ?.firstWhereOrNull((e) => e.entityId == list[0]["entity_id"]);
        iotBloc
          ..updateSelectedRoom(
            iotBloc.state.getIotRoomsApi.data!
                .firstWhereOrNull((e) => e.roomId == device?.roomId),
          )
          ..updateSelectedIotIndex(
            iotBloc.state.inRoomIotDeviceModel!
                .indexWhere((e) => e.id == device?.id),
          );

        if (iotBloc.state.iotDeviceModel == null) {
          await iotBloc.callIotApi();
        }
        if (data["app_data"]["device_type"] == "camera") {
          unawaited(
            DoorbellControlsPage.push(
              context.mounted ? context : context,
              list[0]["doorbell_id"],
              isCamera: true,
              forMove: true,
              entityId: list[0]["entity_id"],
            ),
          );
        } else {
          unawaited(
            RoomAllDevices.push(
              context.mounted ? context : context,
              isMoveRoom: true,
            ),
          );
        }
      } else {
        await iotBloc.callIotRoomsApi();
        final RoomItemsModel roomItemsModel = iotBloc.state.getIotRoomsApi.data!
            .firstWhere((element) => element.roomId == list[0]["room_id"]);
        iotBloc.updateSelectedRoom(
          roomItemsModel,
        );
        unawaited(
          RoomAllDevices.push(
            context.mounted ? context : context,
            isEditRoom: true,
          ),
        );
      }
    } else {
      final Map<String, List<String>> groupedByRoom = {};
      for (final item in data["app_data"]["result"]) {
        final roomName = item["room_name"] ?? "";
        final cameraName = item["name"] ?? "";

        groupedByRoom.putIfAbsent(roomName, () => []).add(cameraName);
      }

      final list = groupedByRoom.entries.map((entry) {
        final cameraNames = entry.value;

        final formattedText = cameraNames.mapIndexed((index, name) {
          return " ${index + 1}. $name";
        }).join("\n\n");

        return ListingViewModel(
          name: " $formattedText",
          roomId: "", // Or assign if you have roomId separately
          imageIcon: "",
          showNumbers: false,
        );
      }).toBuiltList();

      if (list.isNotEmpty) {
        bloc.state.chatData.last.listingViewModel = list;
        if (list.length == 1) {
          await speak(model, text: "${model.text} ${list[0].name}");
        } else {
          logger.fine("${model.text} ${list.map((e) => e.name)}");
          await speak(model, text: "${model.text} ${list.map((e) => e.name)}");
        }
        bloc
          ..updateListingDevices(list)
          ..updateChatUpdate(!bloc.state.chatUpdate);
      }
    }
  }

  Future<void> _handleOpenDoorbellStream(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final device = UserDeviceModel.fromDynamic(data["app_data"]);
    unawaited(
      StreamingPage.push(
        context.mounted ? context : context,
        device.callUserId,
        device.id,
      ).then((_) {
        final v = VoipBloc.of(context.mounted ? context : context);
        Future.delayed(const Duration(seconds: 3), () {
          unawaited(v.streamingPeerConnection?.dispose());
          v.streamingPeerConnection = null;
          final navigatorState = singletonBloc.navigatorKey?.currentState;
          if (navigatorState == null) {
            return;
          }
          final context = navigatorState.context;
          if (!context.mounted) {
            return;
          }
          VoiceControlBloc.of(context).reinitializeWakeWord(context);
        });
      }),
    );

    /// Implement open doorbell stream by name logic
  }

  Future<void> _handleShowTemperatureOutside(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);

    /// Implement show temperature outside logic
  }

  String? getCurrentScreenName(BuildContext context) {
    return ModalRoute.of(context.mounted ? context : context)?.settings.name;
  }

  Future<void> _handleOpenStatistic(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    final bloc = StatisticsBloc.of(context.mounted ? context : context);
    StatisticsFiltersWidget.clearTimeIntervals();
    if (model.statistics == null) {
      StatisticsFiltersWidget.timeIntervalFilters[0].isSelected = true;
      bloc
        ..updateSelectedDropDownValue(Constants.peakVisitorsHourKey)
        ..updateSelectedTimeInterval(
          FiltersModel(
            title: "This Week",
            value: "this_week",
            isSelected: true,
          ),
        );
      unawaited(bloc.callStatistics());
      unawaited(
        StatisticsPage.push(
          context: context.mounted ? context : context,
          noInitState: true,
        ),
      );
    } else if (model.statistics!.thisWeek) {
      StatisticsFiltersWidget.timeIntervalFilters[0].isSelected = true;
      bloc.updateSelectedTimeInterval(
        FiltersModel(
          title: "This Week",
          value: "this_week",
          isSelected: true,
        ),
      );
    } else if (model.statistics!.lastWeek) {
      StatisticsFiltersWidget.timeIntervalFilters[1].isSelected = true;
      bloc.updateSelectedTimeInterval(
        FiltersModel(
          title: "Last Week",
          value: "last_week",
          isSelected: true,
        ),
      );
    } else if (model.statistics!.thisMonth) {
      StatisticsFiltersWidget.timeIntervalFilters[2].isSelected = true;
      bloc.updateSelectedTimeInterval(
        FiltersModel(
          title: "This Month",
          value: "this_month",
          isSelected: true,
        ),
      );
    } else if (model.statistics!.threeMonths) {
      StatisticsFiltersWidget.timeIntervalFilters[3].isSelected = true;
      bloc.updateSelectedTimeInterval(
        FiltersModel(
          title: "Three Months",
          value: "three_months",
          isSelected: true,
        ),
      );
    } else {
      StatisticsFiltersWidget.timeIntervalFilters[0].isSelected = true;
      bloc.updateSelectedTimeInterval(
        FiltersModel(
          title: "This Week",
          value: "this_week",
          isSelected: true,
        ),
      );
    }

    if (model.statistics != null) {
      if (model.statistics!.daysOfTheWeek) {
        bloc.updateSelectedDropDownValue(Constants.daysOfWeekKey);
      } else if (model.statistics!.peakVisitingHours) {
        bloc.updateSelectedDropDownValue(Constants.peakVisitorsHourKey);
      } else if (model.statistics!.frequencyOfVisits) {
        bloc.updateSelectedDropDownValue(Constants.frequencyOfVisitsKey);
      } else if (model.statistics!.unknownVisitors) {
        bloc.updateSelectedDropDownValue(Constants.unknownVisitorsKey);
      } else {
        // StatisticsFiltersWidget.timeIntervalFilters[0].isSelected = true;
        bloc
          ..updateSelectedDropDownValue(Constants.peakVisitorsHourKey)
          ..updateSelectedTimeInterval(
            FiltersModel(
              title: "This Week",
              value: "this_week",
              isSelected: true,
            ),
          );
      }

      unawaited(bloc.callStatistics());
      unawaited(
        StatisticsPage.push(
          context: context.mounted ? context : context,
          noInitState: true,
        ),
      );
    }
  }

  Future<void> _handleOpenVisitorManagement(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    if (data["app_data"]["result"] == null) {
      if (context.mounted) {
        await speak(model);
        StartupBloc.of(context.mounted ? context : context).pageIndexChanged(1);
        unawaited(
          MainDashboard.pushRemove(
            context.mounted ? context : context,
            isUpdate: true,
          ),
        );
      }
    } else {
      await speak(model);
      final bool isAnyFilterApplied = model.visitors!.today! ||
          model.visitors!.yesterday! ||
          model.visitors!.thisWeek! ||
          model.visitors!.thisMonth! ||
          model.visitors!.lastWeek! ||
          model.visitors!.lastMonth! ||
          model.visitors!.customDate != "false";
      final bloc =
          VisitorManagementBloc.of(context.mounted ? context : context);
      if (bloc.state.visitorManagementApi.data == null) {
        await bloc.callVisitorManagement();
      }

      final list = data["app_data"]["result"] as List;

      if (model.visitors!.customName != "false") {
        if (list.isNotEmpty) {
          final VisitorsModel? v =
              bloc.state.visitorManagementApi.data?.data.firstWhereOrNull((e) {
            return e.name == list[0]["name"];
          });

          if (v != null) {
            bloc.updateSelectedVisitor(v);
            unawaited(
              VisitorHistoryPage.push(context.mounted ? context : context),
            );
            if (model.visitors!.customDate != "false") {
              try {
                await bloc.callFilters(
                  visitorId: v.id.toString(),
                  filterValue: DateFormat("dd-MM-yyyy").format(
                    DateFormat("yyyy-MM-dd").parse(model.visitors!.customDate!),
                  ),
                  forVisitorHistoryPage:
                      model.visitors!.customName == "false" ||
                              model.visitors!.customName == "true"
                          ? false
                          : true,
                );
              } catch (e) {
                logger.fine(e);
              }
            }
          } else {
            unawaited(
              bloc.visitorNameTap(
                context.mounted ? context : context,
                v!,
                date: model.visitors!.customDate,
              ),
            );
          }
        } else {
          // await speak(model);
          StartupBloc.of(context.mounted ? context : context)
              .pageIndexChanged(1);
          unawaited(
            MainDashboard.pushRemove(
              context.mounted ? context : context,
              isUpdate: true,
            ),
          );
        }
      } else {
        // await speak(model);
        StartupBloc.of(context.mounted ? context : context).pageIndexChanged(1);
        unawaited(
          MainDashboard.pushRemove(
            context.mounted ? context : context,
            isUpdate: true,
          ),
        );
      }

      if (!isAnyFilterApplied) {
        final VisitorsModel? v =
            bloc.state.visitorManagementApi.data?.data.firstWhereOrNull((e) {
          return e.name == list[0]["name"];
        });
        if (v != null) {
          await bloc.callFilters(
            visitorId: v.id.toString(),
            forVisitorHistoryPage: model.visitors!.customName == "false" ||
                    model.visitors!.customName == "true"
                ? false
                : true,
          );
        }
      } else {
        final VisitorsModel? v =
            bloc.state.visitorManagementApi.data?.data.firstWhereOrNull((e) {
          return e.name == list[0]["name"];
        });
        if (model.visitors!.today!) {
          await bloc.callFilters(
            visitorId: v?.id.toString(),
            filterValue: "today",
            forVisitorHistoryPage: model.visitors!.customName == "false" ||
                    model.visitors!.customName == "true"
                ? true
                : false,
          );
        } else if (model.visitors!.yesterday!) {
          await bloc.callFilters(
            visitorId: v?.id.toString(),
            filterValue: "yesterday",
            forVisitorHistoryPage: model.visitors!.customName == "false" ||
                    model.visitors!.customName == "true"
                ? true
                : false,
          );
        } else if (model.visitors!.thisWeek!) {
          await bloc.callFilters(
            visitorId: v?.id.toString(),
            filterValue: "this_week",
            forVisitorHistoryPage: model.visitors!.customName == "false" ||
                    model.visitors!.customName == "true"
                ? true
                : false,
          );
        } else if (model.visitors!.thisMonth!) {
          await bloc.callFilters(
            visitorId: v?.id.toString(),
            filterValue: "this_month",
            forVisitorHistoryPage: model.visitors!.customName == "false" ||
                    model.visitors!.customName == "true"
                ? true
                : false,
          );
        } else if (model.visitors!.lastWeek!) {
          await bloc.callFilters(
            visitorId: v?.id.toString(),
            filterValue: "last_week",
            forVisitorHistoryPage: model.visitors!.customName == "false" ||
                    model.visitors!.customName == "true"
                ? true
                : false,
          );
        } else if (model.visitors!.lastMonth!) {
          await bloc.callFilters(
            visitorId: v?.id.toString(),
            filterValue: "last_month",
            forVisitorHistoryPage: model.visitors!.customName == "false" ||
                    model.visitors!.customName == "true"
                ? true
                : false,
          );
        }

        if (model.visitors!.customDate != "false") {
          try {
            await bloc.callFilters(
              visitorId: v?.id.toString(),
              filterValue: DateFormat("dd-MM-yyyy").format(
                DateFormat("yyyy-MM-dd").parse(model.visitors!.customDate!),
              ),
              forVisitorHistoryPage: model.visitors!.customName == "false" ||
                      model.visitors!.customName == "true"
                  ? false
                  : true,
            );
          } catch (e) {
            logger.fine(e);
          }
        }
      }
    }
  }

  Future<void> _handleOpenNotification(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final bloc = NotificationBloc.of(context.mounted ? context : context);
    // ..resetFilters();
    final voiceBloc = VoiceControlBloc.of(context.mounted ? context : context);

    bloc.voiceControlEmit(model);
    if (model.notifications!.customDate != "false") {
      try {
        final date = DateFormat("yyyy-MM-dd")
            .parse(model.notifications!.customDate ?? "");
        bloc
          ..updateCustomDate(date)
          ..updateFilter(true)
          ..updateNoDeviceAvailable("");
        unawaited(bloc.callNotificationApi());
      } catch (e) {
        logger.fine(e);
      }
    }

    if (data["app_data"]["result"] == null) {
      unawaited(
        NotificationPage.push(
          context.mounted ? context : context,
          fromVoiceControl: true,
        ),
      );
      return;
    }
    final list = data["app_data"]["result"] as List;
    if (list.length == 1) {
      bloc
        ..updateDeviceId(list[0]["device_id"].toString())
        ..updateFilter(true)
        ..updateNoDeviceAvailable("");
      unawaited(bloc.callNotificationApi());

      await speak(model);
      unawaited(
        NotificationPage.push(
          context.mounted ? context : context,
          fromVoiceControl: true,
        ),
      );
    } else {
      final Map<String, List<String>> groupedByRoom = {};
      for (final item in data["app_data"]["result"]) {
        final cameraName = item["name"] ?? "";

        groupedByRoom.putIfAbsent("", () => []).add(cameraName);
      }

      final list = groupedByRoom.entries.map((entry) {
        final cameraNames = entry.value;

        final formattedText = cameraNames.mapIndexed((index, name) {
          return " ${index + 1}. $name";
        }).join("\n\n");

        return ListingViewModel(
          name: " $formattedText",
          roomId: "", // Or assign if you have roomId separately
          imageIcon: "",
          showNumbers: false,
        );
      }).toBuiltList();

      if (list.isNotEmpty) {
        voiceBloc.state.chatData.last.listingViewModel = list;
        if (list.length == 1) {
          await speak(model, text: "${model.text} ${list[0].name}");
        } else {
          logger.fine("${model.text} ${list.map((e) => e.name)}");
          await speak(model, text: "${model.text} ${list.map((e) => e.name)}");
        }
        voiceBloc
          ..updateListingDevices(list)
          ..updateChatUpdate(!voiceBloc.state.chatUpdate);
      }
    }
  }

  Future<void> _handleViewRoom(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    final IotBloc iotBloc = IotBloc.of(context.mounted ? context : context);
    await speak(model);
    final list = data["app_data"]["result"] as List;
    final RoomItemsModel? roomItemsModel = iotBloc.state.getIotRoomsApi.data
        ?.firstWhereOrNull((element) => element.roomType == list[0]["type"]);
    iotBloc.updateSelectedRoom(
      roomItemsModel,
    );
    unawaited(RoomAllDevices.push(context.mounted ? context : context));
  }

  Future<void> _handleShowFeaturesIrvinei(
    BuildContext context,
    VoiceControlModel model,
    data,
  ) async {
    await speak(model);
    StartupBloc.of(context.mounted ? context : context)
        .updateMoreCustomFeatureTileExpanded(true);
    StartupBloc.of(context.mounted ? context : context)
        .updateMoreCustomSettingsTileExpanded(false);
    unawaited(
      DashboardMorePage.push(context.mounted ? context : context, true),
    );
  }

  void editOrDeleteDevice(
    BuildContext context,
    Map<String, dynamic> data, {
    bool edit = true,
    bool isNotRoom = true,
  }) {
    if (singletonBloc.isViewer()) {
      if (edit) {
        ToastUtils.errorToast(
          context.appLocalizations.viewer_cannot_edit_device,
        );
      } else {
        ToastUtils.errorToast(
          context.appLocalizations.viewer_cannot_delete_device,
        );
      }
    } else {
      final bloc = IotBloc.of(context.mounted ? context : context);
      if (isNotRoom) {
        final IotDeviceModel? device =
            bloc.state.iotDeviceModel?.firstWhereOrNull(
          (e) =>
              e.entityId == data["app_data"]["result"][0]["entity_id"] &&
              e.locationId == data["app_data"]["result"][0]["location_id"],
        );
        bloc
          ..updateSelectedRoom(
            bloc.state.getIotRoomsApi.data!
                .firstWhereOrNull((e) => e.roomId == device?.roomId),
          )
          ..updateSelectedIotIndex(
            bloc.state.inRoomIotDeviceModel!
                .indexWhere((e) => e.id == device?.id),
          )
          ..assignSelectedIndex(
            device?.entityId,
            roomId: device?.roomId,
          );
      } else {
        bloc.updateSelectedRoom(
          bloc.state.getIotRoomsApi.data!.firstWhereOrNull(
            (e) => e.roomType == data["app_data"]["result"][0]["type"],
          ),
        );
      }

      if (edit) {
        unawaited(
          showDialog(
            context: context,
            builder: (context) {
              return EditNameDialog(
                bloc: bloc,
                isNotRoom: isNotRoom,
              );
            },
          ),
        );
      } else {
        unawaited(
          showDialog(
            context: context,
            builder: (context) {
              return DeleteDialog(
                bloc: bloc,
                isNotRoom: isNotRoom,
                fromVoice: true,
              );
            },
          ).then((_) {
            // if(fromVoice){
            if (Navigator.canPop(
              context.mounted ? context : navigatorKeyMain.currentContext!,
            )) {
              Navigator.pop(
                context.mounted ? context : navigatorKeyMain.currentContext!,
              );
            }

            // }
          }),
        );
      }
      unawaited(RoomAllDevices.push(context.mounted ? context : context));
    }
  }

// String parseAndFormatDate(String inputDate) {
//   final formats = [
//     "d MMM yyyy",
//     "d MMMM yyyy",
//     "yyyy-MM-dd",
//     "MM/dd/yyyy",
//     "dd-MM-yyyy",
//     "dd/MM/yyyy",
//     "d MMM, yyyy",
//     "MMM d, yyyy",
//     "d MMMM, yyyy",
//     "MMMM yyyy",
//     "MMM yyyy",
//     "MMMM",
//     "MMM",
//     "MM-dd-yyyy",
//   ];
//
//   inputDate = inputDate.replaceAll(RegExp(r'(st|nd|rd|th)'), '').trim();
//
//   final currentYear = DateTime.now().year;
//
//   if (!RegExp(r'\d{4}').hasMatch(inputDate)) {
//     inputDate = "$inputDate $currentYear";
//   }
//
//   for (final format in formats) {
//     try {
//       final DateFormat dateFormat = DateFormat(format);
//       final DateTime parsedDate = dateFormat.parseStrict(inputDate);
//
//       if (format == "MMMM yyyy" ||
//           format == "MMM yyyy" ||
//           format == "MMMM" ||
//           format == "MMM") {
//         return DateFormat("yyyy-MM-dd")
//             .format(DateTime(parsedDate.year, parsedDate.month));
//       }
//
//       return DateFormat("yyyy-MM-dd").format(parsedDate);
//     } catch (e) {
//       logger.fine(e);
//     }
//   }
//
//   throw FormatException("Date format not recognized: $inputDate");
// }

  double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }
}
