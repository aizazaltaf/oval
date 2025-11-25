import 'dart:typed_data';

import 'package:admin/core/images.dart';
import 'package:admin/pages/main/voip/components/blur_overlay_live_stream.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/smooth_memory_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoStreamView extends StatelessWidget {
  const NoStreamView({
    super.key,
    required this.title,
    this.icon,
    this.description,
    this.redirection,
    this.titleSize,
    this.image,
    this.imageValue,
  });
  final String title;
  final String? icon;
  final String? image;
  final String? description;
  final String? redirection;
  final Uint8List? imageValue;
  final double? titleSize;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 1.2,
      child: BlurOverlayLiveStream(
        background: imageValue == null
            ? image == null
                ? null
                : CachedNetworkImage(
                    imageUrl: image!,
                    useOldImageOnUrlChange: true,
                    fit: BoxFit.fill,
                    errorWidget: (context, exception, stackTrace) {
                      return Image.asset(
                        DefaultImages.FRONT_CAMERA_THUMBNAIL,
                        fit: BoxFit.cover,
                        width: 100.w,
                        height: 205,
                      );
                    },
                  )
            : SmoothMemoryImage(newImageBytes: imageValue!),
        overlay: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              SvgPicture.asset(
                icon!,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).cupertinoOverrideTheme!.barBackgroundColor!,
                  BlendMode.srcIn,
                ),
              ),
            if (icon != null) const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context)
                    .cupertinoOverrideTheme!
                    .barBackgroundColor,
                fontSize: titleSize ?? 18.0,
              ),
            ),
            const SizedBox(height: 6),
            if (description != null)
              Text(
                description!,
                style: TextStyle(
                  color: AppColors.darkPrimaryColor,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.darkPrimaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
