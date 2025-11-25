import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/components/no_stream_view.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VlcPlayerWidget extends StatelessWidget {
  const VlcPlayerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = VoipBloc.of(context);
    if (bloc.videoController == null) {
      return const NoStreamView(
        title: "Initializing Video..",
      );
    }
    return VoipBlocSelector.isBuffering(
      builder: (isBuffering) {
        return Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: bloc.videoController!.value.aspectRatio,
              child: VideoPlayer(
                bloc.videoController!,
              ),
            ),
            if (isBuffering)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }
}
