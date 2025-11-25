import 'dart:typed_data';

import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/components/no_stream_view.dart';
import 'package:admin/pages/main/voip/full_screen.dart';
import 'package:admin/pages/main/voip/streaming_components/vlc_player_widget.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordedStreamPlayer extends StatelessWidget {
  const RecordedStreamPlayer({
    super.key,
    required this.callUserId,
    required this.device,
    required this.imageValue,
  });
  final String callUserId;
  final UserDeviceModel device;
  final Uint8List? imageValue;
  @override
  Widget build(BuildContext context) {
    final bloc = VoipBloc.of(context);
    return VoipBlocSelector.thumbnailImage(
      builder: (image) {
        return VoipBlocBuilder(
          builder: (context, state) {
            if (bloc.state.isRecordedStreamLoading) {
              return CommonFunctions.loadingStreamVideo(
                context,
                image: image,
                title: "Connecting to recorded streams",
              );
            }
            return Stack(
              children: [
                VoipBlocSelector.videoController(
                  builder: (videoController) {
                    if (videoController == null) {
                      return NoStreamView(
                        image: image,
                        title: "No recording found",
                      );
                    } else if (bloc.state.isRecordedStreamLoading) {
                      return VoipBlocSelector.thumbnailImage(
                        builder: (image) {
                          return CommonFunctions.loadingStreamVideo(
                            context,
                            image: image,
                            title: "Connecting to recorded streams",
                          );
                        },
                      );
                    }
                    return Stack(
                      children: [
                        const VlcPlayerWidget(),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                FullScreenVideo.push(
                                  context,
                                  "vlc",
                                  device,
                                  true,
                                  callUserId,
                                );
                              },
                              icon: const Icon(
                                Icons.fullscreen,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                ///TODO
                if (bloc.areRecordedVideosLoading)
                  const Positioned(
                    top: 10,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              "REC",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 5),
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                VoipBlocSelector.isRecordedStreamLoading(
                  builder: (isLoading) {
                    if (!isLoading) {
                      return Positioned(
                        bottom: 10,
                        left: 20,
                        // right: 20.0,
                        child: VoipBlocSelector.videoTimer(
                          builder: (timer) {
                            if (timer.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return DecoratedBox(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: Text(
                                  timer.contains(" ")
                                      ? timer.split(" ")[1]
                                      : DateFormat("HH:mm:ss")
                                          .format(DateTime.parse(timer)),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // if (bloc.areRecordedVideosLoading)
                //   Positioned(
                //     bottom: 10,
                //     top: 40,
                //     right: 10,
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Column(
                //           children: [
                //             const SizedBox(height: 20),
                //             LiveStreamActionButton(
                //               icon: DefaultVectors.HEART_EMPTY,
                //               // icon: false
                //               //     ? DefaultVectors.HEART_FILLED
                //               //     : DefaultVectors.HEART_EMPTY,
                //               onPressed: () async {
                //                 // AlertLSCAM? currentPlayingAlert =
                //                 //     bloc.getCurrentAlert;
                //                 //
                //                 // if (currentPlayingAlert != null) {
                //                 //   Api.addAlertToFavourite(
                //                 //     context: context,
                //                 //     doorbellName: deviceName,
                //                 //     userId: "${await Api.getUserID()}",
                //                 //     alertNotificationId:
                //                 //         currentPlayingAlert.notificationId.toString(),
                //                 //     fileName: controller
                //                 //         .getCurrentPlayingStreamChunk.fileName,
                //                 //   );
                //                 // }
                //               },
                //             ),
                //             // const SizedBox(height: 10),
                //             // LiveStreamActionButton(
                //             //   icon: DefaultIcons.SHARE_ARROW,
                //             //   onPressed: () {},
                //             //   padding: 10,
                //             // ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
              ],
            );
          },
        );
      },
    );
  }
}
