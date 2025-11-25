import 'dart:io';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_details_buttom.dart';
import 'package:admin/pages/themes/componenets/theme_name_widget.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// ========================
/// ThemeVideoPlayer
/// ========================
class ThemeVideoPlayer extends StatefulWidget {
  const ThemeVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.themesList,
    this.isVideoPlaying = false,
    this.isDetail = false,
    this.isName = true,
    this.showForPreviewOnly = false,
  });

  final String videoUrl;
  final bool isVideoPlaying;
  final bool isDetail;
  final bool isName;
  final bool showForPreviewOnly;
  final BuiltList<ThemeDataModel> themesList;

  @override
  State<ThemeVideoPlayer> createState() => _ThemeVideoPlayerState();
}

class _ThemeVideoPlayerState extends State<ThemeVideoPlayer> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    isPlaying = widget.isVideoPlaying;
    _initializeController(widget.videoUrl, autoPlay: isPlaying);
  }

  Future<void> _initializeController(
    String url, {
    bool autoPlay = false,
  }) async {
    setState(() {
      _initialized = false; // show loader
    });

    final newController = url.contains("http")
        ? VideoPlayerController.networkUrl(Uri.parse(url))
        : VideoPlayerController.file(File(url));

    await newController.initialize();
    if (!mounted) {
      await newController.dispose();
      return;
    }

    _controller = newController;
    setState(() {
      _initialized = true;
      isPlaying = autoPlay || widget.isDetail;
      if (isPlaying) {
        _controller?.play();
      }
    });
  }

  Future<void> switchVideo(String url) async {
    final oldController = _controller;
    await _initializeController(url, autoPlay: widget.isDetail);
    await oldController?.dispose();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBlocBuilder(
      builder: (context, state) {
        final bloc = ThemeBloc.of(context);

        if (!_initialized || _controller == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!widget.isName) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: videoWidget(),
          );
        }

        if (widget.isDetail) {
          return ThemeBlocSelector.index(
            builder: (index) {
              return Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                    ),
                  ),
                ),
                body: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragEnd: (dragDetail) async {
                    if (dragDetail.velocity.pixelsPerSecond.dy < 40) {
                      bloc.changeVideoTheme(widget.themesList.length, true);
                      if ((index + 1) <= widget.themesList.length - 1) {
                        await switchVideo(widget.themesList[index + 1].cover);
                      }
                    } else {
                      bloc.changeVideoTheme(widget.themesList.length, false);
                      if ((index - 1) >= 0) {
                        await switchVideo(widget.themesList[index - 1].cover);
                      }
                    }
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        Center(child: videoWidget()),
                        Positioned(
                          bottom: 30,
                          left: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ThemeNameWidget(
                                    theme: widget.themesList[index],
                                  ),
                                ),
                                if (!widget.showForPreviewOnly &&
                                    singletonBloc.profileBloc.state!
                                            .selectedDoorBell !=
                                        null)
                                  ThemeBlocSelector.index(
                                    builder: (index) {
                                      final apiData = bloc
                                          .getThemeApiType(
                                            bloc.state.activeType,
                                          )
                                          .data;
                                      if (apiData == null) {
                                        return const SizedBox.shrink();
                                      }
                                      final themeId = apiData.data[index].id;
                                      final isApplied = apiData.data
                                              .singleWhereOrNull(
                                                (e) => e.id == themeId,
                                              )
                                              ?.isApplied ??
                                          false;
                                      return ThemeDetailsButtons(
                                        themeId: themeId,
                                        isAppliedTheme: isApplied,
                                        data: apiData.data.singleWhere(
                                          (e) => e.id == themeId,
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }

        return videoWidget();
      },
    );
  }

  Widget videoWidget() {
    if (!_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: Stack(
        children: [
          VideoPlayer(_controller!),
          Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: togglePlay,
              child: Opacity(
                opacity: isPlaying ? 0.0 : 1.0,
                child: CircleAvatar(
                  backgroundColor: isPlaying
                      ? Theme.of(context)
                          .primaryColorDark
                          .withValues(alpha: 0.35)
                      : Theme.of(context).primaryColorDark,
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void togglePlay() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _controller?.play();
      } else {
        _controller?.pause();
      }
    });
  }
}

/// ========================
/// ThemeAssetVideoPlayer
/// ========================
class ThemeAssetVideoPlayer extends StatefulWidget {
  const ThemeAssetVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.isNetwork,
    this.uploadPreview = false,
  });

  final String videoUrl;
  final bool isNetwork;
  final bool uploadPreview;

  @override
  State<ThemeAssetVideoPlayer> createState() => _ThemeAssetVideoPlayerState();
}

class _ThemeAssetVideoPlayerState extends State<ThemeAssetVideoPlayer> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeController(widget.videoUrl);
  }

  Future<void> _initializeController(String url, {bool autoPlay = true}) async {
    setState(() {
      _initialized = false;
    });

    final newController = widget.isNetwork
        ? VideoPlayerController.networkUrl(Uri.parse(url))
        : VideoPlayerController.file(File(url));

    await newController.initialize();
    if (!mounted) {
      await newController.dispose();
      return;
    }

    _controller = newController;
    setState(() {
      _initialized = true;
      isPlaying = autoPlay;
      if (isPlaying) {
        _controller?.play();
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.uploadPreview) {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Center(child: videoWidget()),
          ],
        ),
      ),
    );
  }

  Widget videoWidget() {
    if (!_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: Stack(
        children: [
          VideoPlayer(_controller!),
          Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: togglePlay,
              child: Opacity(
                opacity: isPlaying ? 0.0 : 1.0,
                child: CircleAvatar(
                  backgroundColor: isPlaying
                      ? Theme.of(context)
                          .primaryColorDark
                          .withValues(alpha: 0.35)
                      : Theme.of(context).primaryColorDark,
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void togglePlay() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _controller?.play();
      } else {
        _controller?.pause();
      }
    });
  }
}
