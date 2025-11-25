import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

final _logger = Logger('signalling_client.dart');

class SignalingClient {
  SignalingClient(this.voipBloc);
  final VoipBloc voipBloc;

  void sendOffer(
    RTCSessionDescription sdp,
    String callType,
    BuildContext context,
  ) {
    final offer = {
      "type": "offer",
      "call_type": callType,
      "sdp": sdp.sdp.toString(),
      "from": singletonBloc.profileBloc.state!.callUserId,
      "target": singletonBloc.profileBloc.state!.streamingId,
    };

    unawaited(
      singletonBloc.socketEmitterWithAck(
        roomName: Constants.signaling,
        deviceId: voipBloc.selectedDevice!.deviceId,
        request: Constants.offer,
        obj: offer,
      ),
    );
    voipBloc.callingEndTimer?.cancel();
    voipBloc.callingEndTimer =
        Timer.periodic(const Duration(seconds: 15), (timer) {
      if (callType != Constants.doorbellStreamAudio) {
        // EasyLoading.dismiss();
        Constants.dismissLoader();

        voipBloc.callingEndTimer?.cancel();
        ToastUtils.errorToast(
          "Unable to connect to doorbell. Please try again",
          title: "Call Failed!",
        );
        voipBloc.endStreamingCall(context);
        if (singletonBloc.socket?.connected != true) {
          singletonBloc.socket?.connect();
        }
        if (voipBloc.state.isOnCallingScreen) {
          Navigator.pop(context);
        } else {
          voipBloc.emit(
            voipBloc.state.rebuild(
              (final b) => b
                ..isMicrophoneOnStreamEnabled = false
                ..isCameraOnStreamEnabled = false,
            ),
          );
        }
      }
    });
  }

  void setRemoteDescriptionWithCheck(
    RTCSessionDescription sessionDescription,
    json,
  ) {
    // unawaited(EasyLoading.dismiss());
    Constants.dismissLoader();

    if (voipBloc.callingPeerConnection?.signalingState ==
        RTCSignalingState.RTCSignalingStateHaveLocalOffer) {
      voipBloc.callingPeerConnection
          ?.setRemoteDescription(sessionDescription)
          .then((x) {
        for (int i = 0; i < voipBloc.pendingCandidates.length; i++) {
          _logger
              .severe('New ice candidate : ${voipBloc.pendingCandidates[i]}');
          voipBloc.callingPeerConnection!
              .addCandidate(voipBloc.pendingCandidates[i]);
        }
        voipBloc.pendingCandidates.clear();
      });
      // unawaited(EasyLoading.dismiss());
      Constants.dismissLoader();

      if (voipBloc.remoteRenderer != null) {
        voipBloc.updateIsCallConnected(true);
      }
    } else {
      _logger.fine(
        "Cannot set remote description in current state: ${voipBloc.callingPeerConnection?.signalingState}",
      );
    }
  }

  Future<void> handleEndCall(json, BuildContext context) async {
    _logger.fine("socket is end_call");
    // unawaited(EasyLoading.dismiss());
    Constants.dismissLoader();

    if (voipBloc.state.isCallConnected && !voipBloc.state.isOnCallingScreen) {
      ToastUtils.infoToast(
        "Disconnected",
        "Call has been disconnected",
      );
      if (voipBloc.localRenderer?.srcObject != null) {
        voipBloc.localRenderer?.muted = true;
      }

      voipBloc.emit(
        voipBloc.state.rebuild(
          (final b) => b
            ..isMicrophoneOnStreamEnabled = false
            ..muted = true
            ..isCameraOnStreamEnabled = false
            ..isSilentAudioCall = false,
        ),
      );
      // unawaited(voipBloc.toggleSpeaker());
      await voipBloc.endStreamingCall(
        context.mounted ? context : context,
      );
    }
  }

  Future<void> handleCandidate(
    json,
  ) async {
    final candidate = RTCIceCandidate(
      json["candidate"].toString(),
      json["sdpMid"].toString(),
      json["sdpMLineIndex"],
    );
    final isRemote =
        await voipBloc.callingPeerConnection?.getRemoteDescription() != null;
    _logger.severe("Candidate : $candidate");
    if (!isRemote) {
      voipBloc.pendingCandidates.add(candidate);
    } else {
      unawaited(voipBloc.callingPeerConnection?.addCandidate(candidate));
    }
  }
}
