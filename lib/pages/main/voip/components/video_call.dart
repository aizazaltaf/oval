import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCall extends StatelessWidget {
  const VideoCall({
    super.key,
    required this.visitorName,
    required this.isVideoEnabled,
    required this.areCallControlsExpanded,
    this.heights,
    this.widths,
  });
  final bool isVideoEnabled;
  final String visitorName;
  final bool areCallControlsExpanded;
  final double? heights;
  final double? widths;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    if (heights != null) {
      return _setLocalVideoRender(context);
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CommonFunctions.videoCallTopWidget(context, visitorName),
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(
          //       vertical: 20,
          //       horizontal: 30,
          //     ),
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.only(top: 30),
          //           child: Image.asset(
          //             DefaultImages.APPLICATION_ICON_PNG,
          //             width: 120,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(
              right: 15,
              // left: width * 0.05,
              bottom: 100,
            ),
            child: isVideoEnabled
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Container(
                        key: const Key('remote'),
                        width: width * 0.3,
                        height: height * 0.22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(color: Colors.white, spreadRadius: 1),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _setLocalVideoRender(context),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _setLocalVideoRender(context) {
    final bloc = VoipBloc.of(context);
    return VoipBlocSelector.localRenderer(
      builder: (localRenderer) {
        return SizedBox(
          width: widths ?? bloc.heightLocalView,
          height: heights ?? bloc.widthLocalView,
          child: localRenderer == null
              ? const SizedBox.shrink()
              : localRenderer.srcObject == null
                  ? const SizedBox.shrink()
                  : RTCVideoView(
                      localRenderer,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      mirror: true,
                    ),
        );
      },
    );
  }
}
