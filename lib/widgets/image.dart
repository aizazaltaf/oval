import 'dart:io';

import 'package:admin/inheritance/asset_bundle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

final _assetBundle = ByteDataAssetBundle();

class WCImage extends StatelessWidget {
  const WCImage(
    this.image, {
    super.key,
    this.width,
    this.height,
    this.size,
    this.color,
    this.isIcon = false,
    this.placeholder,
    this.fit,
  });
  final String image;
  final double? width;
  final double? height;
  final double? size;
  final Color? color;
  final bool isIcon;
  final Widget? placeholder;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final mColor = color ?? (isIcon ? iconTheme.color : null);
    final mWidth = size ?? width ?? (isIcon ? iconTheme.size : null);
    final mHeight = size ?? height ?? (isIcon ? iconTheme.size : null);

    Widget child = _buildImage(mColor, mWidth, mHeight);

    if (_isInsideTextFormField(context)) {
      child = Center(child: child);
    }

    return SizedBox(
      width: mWidth,
      height: mHeight,
      child: child,
    );
  }

  Widget _buildImage(Color? mColor, double? mWidth, double? mHeight) {
    if (image.startsWith('https://') || image.startsWith('http://')) {
      return _buildNetworkImage();
    } else if (image.startsWith('/')) {
      return _buildFileImage();
    } else if (image.endsWith('.svg')) {
      return _buildSvgImage(mColor, mWidth, mHeight);
    } else {
      return _buildAssetImage(mColor);
    }
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: image,
      fit: fit,
      placeholder: placeholder == null ? null : (context, _) => placeholder!,
    );
  }

  Widget _buildFileImage() {
    return Image.file(
      File(image),
      fit: fit,
    );
  }

  Widget _buildSvgImage(Color? mColor, double? mWidth, double? mHeight) {
    return SvgPicture(
      AssetBytesLoader(
        '$image.vec',
        assetBundle: _assetBundle,
      ),
      colorFilter: mColor == null
          ? null
          : ColorFilter.mode(
              mColor,
              BlendMode.srcIn,
            ),
      fit: fit ?? BoxFit.contain,
      width: mWidth,
      height: mHeight,
    );
  }

  Widget _buildAssetImage(Color? mColor) {
    return Image.asset(
      image,
      color: mColor,
      fit: fit,
    );
  }

  bool _isInsideTextFormField(BuildContext context) {
    return context.findAncestorWidgetOfExactType<TextFormField>() != null;
  }
}
