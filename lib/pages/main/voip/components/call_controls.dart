import 'package:admin/pages/main/voip/components/audio_call_controls.dart';
import 'package:admin/pages/main/voip/components/video_call_controls.dart';
import 'package:flutter/material.dart';

class CallControls extends StatefulWidget {
  // Callback for sheet state

  const CallControls({
    super.key,
    required this.isCallConnected,
    required this.isAudioCall,
    required this.isVideoEnabled,
    required this.isAudioEnabled,
    required this.isSpeakerEnabledInCall,
    required this.onCallEnd,
    required this.onVideoToggle,
    required this.onShiftToVideo,
    required this.onShiftToAudio,
    required this.onAudioToggle,
    required this.onSpeakerToggle,
    required this.onSheetStateChanged,
    this.shiftingToVideoCallFromAudio =
        false, // will be available for audio call only
    this.shiftingToAudioCallFromVideo =
        false, // will be available for video call only
  });
  final bool isAudioCall;
  final bool isVideoEnabled;
  final bool isAudioEnabled;
  final bool isSpeakerEnabledInCall;
  final bool shiftingToVideoCallFromAudio;
  final bool shiftingToAudioCallFromVideo;
  final bool isCallConnected;
  final VoidCallback onCallEnd;
  final VoidCallback onVideoToggle;
  final VoidCallback onShiftToVideo;
  final VoidCallback onShiftToAudio;
  final VoidCallback onAudioToggle;
  final VoidCallback onSpeakerToggle;
  final Function(bool) onSheetStateChanged;

  @override
  State<CallControls> createState() => _CallControlsState();
}

class _CallControlsState extends State<CallControls> {
  bool isSheetExpanded = true; // Track the state of the sheet

  void onTapFunction() {
    if (isSheetExpanded) {
      setState(() {
        isSheetExpanded = false;
      });
      widget.onSheetStateChanged(false);
    } else {
      setState(() {
        isSheetExpanded = true;
      });
      widget.onSheetStateChanged(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // return SizedBox.shrink();
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(15),
      child: DecoratedBox(
        // height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: Theme.of(context).primaryColor),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(190, 237, 255, 1),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // GestureDetector(
            //   behavior: HitTestBehavior.opaque,
            //   onTap: onTapFunction,
            //   child: const SizedBox(
            //     height: 20,
            //     width: 100,
            //   ),
            // ),
            // SizedBox(
            //   width: 100,
            //   height: 20,
            //   child: GestureDetector(
            //     behavior: HitTestBehavior.opaque,
            //     onTap: onTapFunction,
            //     child: SvgPicture.asset(
            //       isSheetExpanded
            //           ? DefaultIcons.DOWN_ARROW
            //           : DefaultIcons.UP_ARROW,
            //     ),
            //   ),
            // ),
            Visibility(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  if (widget.isAudioCall)
                    AudioCallControls(
                      isCallConnected: widget.isCallConnected,
                      onCallEnd: widget.onCallEnd,
                      onShiftToVideo: widget.onShiftToVideo,
                      onAudioToggle: widget.onAudioToggle,
                      onSpeakerToggle: widget.onSpeakerToggle,
                      isSpeakerEnabledInCall: widget.isSpeakerEnabledInCall,
                      isMicrophoneEnabledInCall: widget.isAudioEnabled,
                      isShiftingToVideoCall:
                          widget.shiftingToVideoCallFromAudio,
                    ),
                  if (!widget.isAudioCall)
                    VideoCallControls(
                      isCallConnected: widget.isCallConnected,
                      onCallEnd: widget.onCallEnd,
                      onVideoToggle: widget.onVideoToggle,
                      onAudioToggle: widget.onAudioToggle,
                      onShiftToAudio: widget.onShiftToAudio,
                      isSpeakerEnabledInCall: widget.isSpeakerEnabledInCall,
                      onSpeakerToggle: widget.onSpeakerToggle,
                      isCameraEnabledInCall: widget.isVideoEnabled,
                      isMicrophoneEnabledInCall: widget.isAudioEnabled,
                      // isShiftingToAudioCall:
                      //     widget.shiftingToAudioCallFromVideo,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
