import 'package:admin/pages/main/voip/components/call_control_button.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AudioCallControls extends StatelessWidget {
  const AudioCallControls({
    super.key,
    required this.onSpeakerToggle,
    required this.onAudioToggle,
    required this.onShiftToVideo,
    required this.onCallEnd,
    required this.isSpeakerEnabledInCall,
    required this.isMicrophoneEnabledInCall,
    required this.isShiftingToVideoCall,
    required this.isCallConnected,
  });
  final VoidCallback onSpeakerToggle;
  final VoidCallback onAudioToggle;
  final VoidCallback onShiftToVideo;
  final VoidCallback onCallEnd;
  final bool isSpeakerEnabledInCall;
  final bool isMicrophoneEnabledInCall;
  final bool isShiftingToVideoCall;
  final bool isCallConnected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CallControlButton(
            isActive: true,
            isCallConnected: isCallConnected,
            icon: isMicrophoneEnabledInCall ? Icons.mic_off_rounded : Icons.mic,
            onPressed: !isCallConnected ? () {} : onAudioToggle,
            // iconSize: 28,
          ),
          const SizedBox(width: 15),
          CallControlButton(
            isActive: true,
            isCallConnected: isCallConnected,
            icon: MdiIcons.video,
            onPressed: !isCallConnected ? () {} : onShiftToVideo,
          ),
          const SizedBox(width: 15),
          CallControlButton(
            isActive: true,
            isCallConnected: isCallConnected,
            icon: isSpeakerEnabledInCall ? Icons.volume_up : Icons.volume_off,
            onPressed: !isCallConnected ? () {} : onSpeakerToggle,
            // iconSize: isSpeakerEnabledInCall ? 20.0 : 28.0,
          ),
          const SizedBox(width: 15),
          CallControlButton(
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
