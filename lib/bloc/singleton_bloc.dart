import 'dart:async';
import 'dart:io';

import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_wake_word/use_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

final _logger = Logger("singleton.dart");

class _SingletonBloc {
  ProfileBloc? _profileBloc;
  GetStorage _getBox = GetStorage();
  SpeechToText speech = SpeechToText();
  UseModel useModel = UseModel();
  // Allow injection for tests
  GetStorage get getBox => _getBox;
  @visibleForTesting
  set getBox(GetStorage box) => _getBox = box;

  Socket? socket;

  IotBloc? iotBloc;
  VoipBloc? voipBloc;

  ProfileBloc get profileBloc => _profileBloc ??= ProfileBloc();

  // Test setter for profile bloc
  @visibleForTesting
  set testProfileBloc(ProfileBloc bloc) => _profileBloc = bloc;

  // Test setter for textToSpeech
  @visibleForTesting
  set testTextToSpeech(FlutterTts tts) => textToSpeech = tts;

  GlobalKey<NavigatorState>? navigatorKey;

  bool isNotificationNavigationExecuted = false;

  bool joinRoom = false;
  bool isInternetConnected = true;

  FlutterTts textToSpeech = FlutterTts();

  Future<void> removeInstance() async {
    if (Platform.isAndroid) {
      try {
        await useModel.removeInstance("hey_oval_model_28_02072025");
      } catch (e) {
        _logger.fine(e);
      }
    } else {
      await useModel.stopListening();
    }
  }

  Future<void> socketEmitter({
    roomName,
    roomId,
    String? request,
    deviceId,
    themeId,
    message,
  }) async {
    try {
      socket!.emit(
        roomName,
        {
          // Constants.roomId: roomId ?? profileBloc.state!.locationId,
          Constants.roomId: roomId ??
              profileBloc.state!.selectedDoorBell?.locationId.toString(),
          Constants.command: request,
          Constants.uuid: profileBloc.state?.callUserId,
          Constants.deviceId: deviceId,
          if (themeId != null) "theme_id": themeId,
          Constants.sessionId: await CommonFunctions.getDeviceModel(),
          "message": message ?? "",
        },
      );
    } catch (e) {
      _logger.severe(e.toString());
    }
  }

  Future<void> socketEmitterWithAck({
    roomName,
    roomId,
    String? request,
    deviceId,
    themeId,
    obj,
    message,
    Function? acknowledgement,
  }) async {
    try {
      final String adminDeviceId = await CommonFunctions.getDeviceModel();
      socket!.emitWithAck(roomName, {
        // Constants.roomId: roomId ?? profileBloc.state!.locationId,
        Constants.roomId: roomId ??
            profileBloc.state!.selectedDoorBell?.locationId.toString(),
        Constants.command: request,
        Constants.uuid: profileBloc.state?.callUserId,
        Constants.deviceId: deviceId,
        // Constants.adminDeviceId: adminDeviceId,
        if (themeId != null) "theme_id": themeId,
        Constants.sessionId: adminDeviceId,
        if (obj != null) "data": obj ?? "",
        if (message != null) "message": message ?? "",
      });
    } catch (e) {
      _logger.severe(e.toString());
    }
  }

  String getRole() {
    return profileBloc.state!.locations!
            .where(
              (element) =>
                  element.id == profileBloc.state!.selectedDoorBell!.locationId,
            )
            .firstOrNull
            ?.roles[0] ??
        '';
  }

  bool isViewer() {
    final int roleId = CommonFunctions.getRoleId(
      getRole(),
    );
    return roleId == 4;
  }

  bool isFeatureCodePresent(String code) {
    if (singletonBloc.profileBloc.state != null) {
      if (singletonBloc.profileBloc.state?.planFeaturesList == null ||
          singletonBloc.profileBloc.state!.planFeaturesList!.isEmpty) {
        return false;
      }
      return singletonBloc.profileBloc.state!.planFeaturesList!
          .any((feature) => feature.code == code);
    }
    return false;
  }
}

final singletonBloc = _SingletonBloc();

class TestSingletonBloc extends _SingletonBloc {}
