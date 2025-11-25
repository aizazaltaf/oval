import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoPlayerButtons extends StatelessWidget {
  const VideoPlayerButtons({
    super.key,
    required this.backPress,
    required this.forwardPressPress,
  });
  final VoidCallback backPress;
  final VoidCallback forwardPressPress;
  @override
  Widget build(BuildContext context) {
    final VoipBloc bloc = VoipBloc.of(context);
    final width = MediaQuery.of(context).size.width;
    return VoipBlocSelector.isLiveModeActivated(
      builder: (isLiveModelActivated) {
        if (!isLiveModelActivated) {
          return Center(
            // padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomWidgetButton(
                  width: 50,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey
                      : Theme.of(context).primaryColor.withValues(alpha: 0.4),
                  isButtonEnabled:
                      !isLiveModelActivated && bloc.videoController != null,
                  shape: BoxShape.circle,
                  onSubmit: backPress,
                  child: Icon(
                    CupertinoIcons.backward_end_fill,
                    color: Theme.of(context).tabBarTheme.indicatorColor,
                  ),
                ),
                SizedBox(width: width * 0.05),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 50),
                  reverseDuration: const Duration(milliseconds: 50),
                  child: VoipBlocSelector.isPlaying(
                    builder: (isPlaying) {
                      return CustomWidgetButton(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey
                            : Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.4),
                        width: 70,
                        isButtonEnabled: !isLiveModelActivated &&
                            bloc.videoController != null,
                        shape: BoxShape.circle,
                        child: Center(
                          child: Icon(
                            isPlaying
                                ? CupertinoIcons.pause_fill
                                : CupertinoIcons.play_arrow_solid,
                            color: Theme.of(context).tabBarTheme.indicatorColor,
                            size: 26,
                          ),
                        ),
                        onSubmit: () async {
                          bloc.recordedVideoToggle(isPlaying);
                        },
                      );
                    },
                  ),
                ),
                SizedBox(width: width * 0.05),
                CustomWidgetButton(
                  width: 50,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey
                      : Theme.of(context).primaryColor.withValues(alpha: 0.4),
                  isButtonEnabled:
                      !isLiveModelActivated && bloc.videoController != null,
                  shape: BoxShape.circle,
                  onSubmit: forwardPressPress,
                  child: Icon(
                    CupertinoIcons.forward_end_fill,
                    color: Theme.of(context).tabBarTheme.indicatorColor,
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
