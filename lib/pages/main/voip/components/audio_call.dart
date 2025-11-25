import 'dart:async';
import 'dart:io';

import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/components/custom_voip_audio_call_visualizer.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

class AudioCall extends StatelessWidget {
  const AudioCall({
    super.key,
    required this.visitorName,
    required this.visitorImage,
    required this.isAudioEnabled,
    this.isAudioOnly = false,
    this.notificationImage,
    this.isAudioCall = true,
  });
  final String visitorName;
  final String? visitorImage;
  final String? notificationImage;
  final bool isAudioEnabled;
  final bool isAudioOnly;
  final bool isAudioCall;

  @override
  Widget build(BuildContext context) {
    final statusTextStyle = Theme.of(context).textTheme.displayMedium;

    return SafeArea(
      child: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ✅ Background Layer (handles image, shimmer, and error)
            if (!isAudioCall)
              CachedNetworkImage(
                imageUrl: visitorImage ?? notificationImage ?? "",
                fit: BoxFit.cover,

                // ✅ Show shimmer while loading
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(color: Colors.white),
                ),

                // ✅ Error fallback image
                errorWidget: (context, url, error) => CachedNetworkImage(
                  imageUrl: notificationImage ?? "",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    DefaultImages.USER_IMG_PLACEHOLDER,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              // If it's an audio call, just a plain background
              const SizedBox.shrink(),

            // ✅ Foreground UI Layer (your existing content)
            Column(
              children: [
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      visitorName.toLowerCase().contains("someone")
                          ? "Unknown Visitor"
                          : visitorName,
                      style: TextStyle(
                        color:
                            CommonFunctions.getThemeBasedWidgetColor(context),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    VoipBlocSelector.callValue(
                      builder: (callValue) {
                        if (callValue != null) {
                          return Text(
                            "Doorbell is busy",
                            style: statusTextStyle,
                            textAlign: TextAlign.start,
                          );
                        }
                        return VoipBlocSelector.remoteRenderer(
                          builder: (remoteRenderer) {
                            if (remoteRenderer == null) {
                              return Text(
                                "Connecting..",
                                style: statusTextStyle,
                                textAlign: TextAlign.start,
                              );
                            }
                            return VoipBlocSelector.seconds(
                              builder: (seconds) {
                                return VoipBlocSelector.isCallConnected(
                                  builder: (isCallConnected) {
                                    return VoipBlocSelector.isReconnecting(
                                      builder: (isReconnecting) {
                                        if (isReconnecting) {
                                          return Text(
                                            "Reconnecting...",
                                            style: statusTextStyle,
                                            textAlign: TextAlign.start,
                                          );
                                        } else if (seconds == 0) {
                                          return Text(
                                            isCallConnected
                                                ? "Connected"
                                                : "Connecting..",
                                            style: statusTextStyle,
                                            textAlign: TextAlign.start,
                                          );
                                        } else if (!isAudioOnly &&
                                            !remoteRenderer.value.renderVideo) {
                                          return Text(
                                            "Connecting..",
                                            style: statusTextStyle,
                                            textAlign: TextAlign.start,
                                          );
                                        }
                                        return Text(
                                          CommonFunctions
                                              .formatAudioVisualiserTime(
                                            seconds,
                                          ),
                                          style: statusTextStyle,
                                          textAlign: TextAlign.start,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                if (isAudioCall)
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                if (isAudioCall)
                  VoipBlocBuilder(
                    builder: (context, state) {
                      final bloc = VoipBloc.of(context);
                      return VoipBlocSelector.isCallConnected(
                        builder: (isCallConnected) {
                          return CustomVoipAudioCallVisualizer(
                            visitorImage: visitorImage,
                            notificationImage: notificationImage,
                            radius: 100,
                            isActive: isCallConnected && bloc.isAudioEnabled(),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AudioVisualiser extends StatefulWidget {
  const AudioVisualiser({
    super.key,
  });

  @override
  State<AudioVisualiser> createState() => _AudioVisualiserState();
}

class _AudioVisualiserState extends State<AudioVisualiser> {
  late final RecorderController recorderController;

  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;

  late Directory appDirectory;

  @override
  void initState() {
    super.initState();
    _getDir();
  }

  Future<void> _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/${Constants.callVisualiserRecording}.m4a";

    _initialiseControllers();
    await _startRecording();
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (isLoading) {
      return const Center(
        child: ButtonProgressIndicator(),
      );
    } else {
      Constants.dismissLoader();

      return AudioWaveforms(
        size: Size(width, 50),
        recorderController: recorderController,
        waveStyle: WaveStyle(
          waveColor: Theme.of(context).primaryColorDark,
          extendWaveform: true,
          showMiddleLine: false,
          spacing: 10,
          waveThickness: 2,
          scaleFactor: height * 0.15,
        ),
        padding: const EdgeInsets.only(left: 18),
      );
    }
  }

  Future<void> _startRecording() async {
    try {
      await recorderController.record(path: path);
    } catch (e) {
      // print("***** _startRecording(): ERROR: $e *****");
    }
  }
}
