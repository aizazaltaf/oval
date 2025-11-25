import 'dart:convert';

import 'package:admin/core/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircularProfileImage extends StatelessWidget {
  const CircularProfileImage({
    super.key,
    this.profileImageUrl,
    this.border = true,
    this.size = 80,
    this.galleryImageUrl,
    this.needSeparateWidth,
    this.needSeparateHeight,
  });
  final String? profileImageUrl;
  final String? galleryImageUrl;
  final bool border;
  final double size;
  final double? needSeparateWidth;
  final double? needSeparateHeight;

  @override
  Widget build(BuildContext context) {
    return
        // border ?
        Container(
      height: needSeparateHeight ?? size,
      width: needSeparateWidth ?? size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border
            ? Border.all(
                color: Theme.of(context).primaryColor,
                width: 4,
              )
            : null,
      ),
      child: ClipOval(
        // galleryImageUrl => this parameter is used for uploading image from gallery or camera
        child: galleryImageUrl != null
            ? Image.memory(
                fit: BoxFit.cover,
                base64Decode(
                  galleryImageUrl!,
                ),
                errorBuilder: (context, exception, stackTrace) {
                  return Image.asset(
                    fit: BoxFit.cover,
                    DefaultImages.USER_IMG_PLACEHOLDER,
                  );
                },
              )
            : profileImageUrl == null
                ? Image.asset(
                    fit: BoxFit.cover,
                    DefaultImages.USER_IMG_PLACEHOLDER,
                  )
                : CachedNetworkImage(
                    imageUrl: profileImageUrl!,
                    useOldImageOnUrlChange: true,
                    fit: BoxFit.cover,
                    errorWidget: (context, exception, stackTrace) {
                      return Image.asset(
                        fit: BoxFit.cover,
                        DefaultImages.USER_IMG_PLACEHOLDER,
                      );
                    },
                  ),
      ),
    );
    // : ClipOval(
    //     child: profileImageUrl == null
    //         ? Image.asset(
    //             fit: BoxFit.cover,
    //             DefaultImages.USER_IMG_PLACEHOLDER,
    //           )
    //         : CachedNetworkImage(
    //             imageUrl: profileImageUrl!,
    //             useOldImageOnUrlChange: true,
    //             fit: BoxFit.cover,
    //           ),
    //   );
  }
}
