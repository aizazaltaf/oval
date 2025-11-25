import 'dart:io';

import 'package:admin/pages/themes/componenets/theme_video_player.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ThemeAssetPreview extends StatelessWidget {
  const ThemeAssetPreview({
    super.key,
    required this.path,
    this.width,
    required this.isNetwork,
    this.uploadPreview = false,
  });
  final String path;
  final double? width;
  final bool isNetwork;
  final bool uploadPreview;

  @override
  Widget build(BuildContext context) {
    if (CommonFunctions.isVideoTheme(path)) {
      return ThemeAssetVideoPlayer(
        videoUrl: path,
        isNetwork: isNetwork,
        uploadPreview: uploadPreview,
      );
    }
    if (isNetwork) {
      return CachedNetworkImage(
        imageUrl: path,
        useOldImageOnUrlChange: true,
        fit: BoxFit.fill,
        width: width,
      );
    }
    return Image.file(
      File(path),
      width: width,
      fit: BoxFit.fill,
    );
  }
}
