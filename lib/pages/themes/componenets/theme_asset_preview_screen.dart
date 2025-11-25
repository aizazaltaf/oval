import 'dart:io';

import 'package:admin/core/images.dart';
import 'package:admin/custom_classes/gradient_fab_btn.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_add_info_screen.dart';
import 'package:admin/pages/themes/componenets/theme_asset_preview.dart';
import 'package:admin/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ThemeAssetPreviewScreen extends StatelessWidget {
  const ThemeAssetPreviewScreen({
    super.key,
    required this.selectedAsset,
    required this.thumbnail,
    this.noBackIcon = false,
  });
  final File selectedAsset;
  final File? thumbnail;
  final bool noBackIcon;

  static const routeName = "themeScreen";

  static Future<void> push(
    final BuildContext context,
    final File selectedAsset,
    final File? thumbnail, {
    final bool noBackIcon = false,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => ThemeAssetPreviewScreen(
        selectedAsset: selectedAsset,
        thumbnail: thumbnail,
        noBackIcon: noBackIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: ThemeAssetPreview(
              path: selectedAsset.path,
              isNetwork: false,
            ),
          ),
          if (!noBackIcon)
            Positioned(
              top: 20,
              left: 20,
              child: SafeArea(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            right: 20,
            child: SafeArea(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => ThemeAddInfoScreen.push(
                  context,
                  selectedAsset: selectedAsset,
                  thumbnail: thumbnail,
                  aiImageFile: bloc.state.generatedImage,
                ),
                child: GradientFloatingButton(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(DefaultVectors.WHITE_SEND),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
