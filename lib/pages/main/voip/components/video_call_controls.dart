import 'package:admin/pages/main/voip/components/call_control_button.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VideoCallControls extends StatelessWidget {
  const VideoCallControls({
    super.key,
    required this.onShiftToAudio,
    required this.onSpeakerToggle,
    required this.onAudioToggle,
    required this.onVideoToggle,
    required this.onCallEnd,
    required this.isCameraEnabledInCall,
    required this.isMicrophoneEnabledInCall,
    required this.isSpeakerEnabledInCall,
    required this.isCallConnected,
  });
  final VoidCallback onShiftToAudio;
  final VoidCallback onSpeakerToggle;
  final VoidCallback onAudioToggle;
  final VoidCallback onVideoToggle;
  final VoidCallback onCallEnd;
  final bool isCameraEnabledInCall;
  final bool isMicrophoneEnabledInCall;
  final bool isSpeakerEnabledInCall;
  final bool isCallConnected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CallControlButton(
            // radius: 27,
            isActive: true,
            isCallConnected: isCallConnected,
            icon: isMicrophoneEnabledInCall ? Icons.mic_off_rounded : Icons.mic,
            onPressed: !isCallConnected ? () {} : onAudioToggle,
            // iconSize: 25,
          ),
          const SizedBox(width: 15),
          CallControlButton(
            // radius: 27,
            isActive: true,
            isCallConnected: isCallConnected,
            icon: Icons.call,
            onPressed: !isCallConnected ? () {} : onShiftToAudio,
          ),
          const SizedBox(width: 15),
          CallControlButton(
            // radius: 27,
            isActive: true,
            isCallConnected: isCallConnected,
            icon: isSpeakerEnabledInCall ? Icons.volume_up : Icons.volume_off,
            onPressed: onSpeakerToggle,
            // iconSize: isSpeakerEnabledInCall ? 20.0 : 28.0,
          ),
          const SizedBox(width: 15),
          CallControlButton(
            // radius: 27,
            isActive: true,
            isCallConnected: isCallConnected,
            icon: isCameraEnabledInCall ? Icons.camera_alt : MdiIcons.cameraOff,
            onPressed: !isCallConnected ? () {} : onVideoToggle,
          ),
          const SizedBox(width: 15),
          CallControlButton(
            // radius: 27,
            isActive: true,
            isCallConnected: true,
            icon: Icons.call_end,
            buttonBGActiveColor: Colors.red,
            buttonBGInActiveColor: Colors.red,
            iconInActiveColor: Colors.white,
            iconActiveColor: Colors.white,
            onPressed: onCallEnd,
            // iconSize: 30,
          ),
        ],
      ),
    );
  }
}
