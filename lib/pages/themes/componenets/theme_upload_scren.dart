import 'dart:io';

import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/preview_theme_widget.dart';
import 'package:admin/pages/themes/componenets/theme_asset_preview.dart';
import 'package:admin/pages/themes/componenets/theme_color_edit.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThemeUploadScreen extends StatelessWidget {
  const ThemeUploadScreen({
    super.key,
    this.selectedAsset,
    this.aiImageFile,
    this.thumbnail,
    this.selectedDoorBell,
  });
  final File? selectedAsset;
  final File? thumbnail;
  final String? aiImageFile;
  final UserDeviceModel? selectedDoorBell;

  static const routeName = "themeAddInfoScreen";

  static Future<void> push(
    final BuildContext context,
    final File? selectedAsset,
    final File? thumbnail,
    final String? aiImageFile, {
    UserDeviceModel? selectedDoorBell,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => ThemeUploadScreen(
        selectedAsset: selectedAsset,
        thumbnail: thumbnail,
        aiImageFile: aiImageFile,
        selectedDoorBell: selectedDoorBell,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    return PopScope(
      child: AppScaffold(
        appTitle: context.appLocalizations.theme_preview,
        appBarAction: [
          if (selectedDoorBell != null)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async => ThemeColorEdit.push(
                context,
                file: selectedAsset,
                thumbnail: thumbnail,
                aiImage: aiImageFile,
                doorbell: selectedDoorBell,
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SvgPicture.asset(
                  DefaultIcons.EDIT,
                  // height: 20.0,
                ),
              ),
            ),
        ],
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 60),
                      height: 400,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ThemeAssetPreview(
                          path: aiImageFile != null
                              ? aiImageFile!
                              : selectedAsset!.path,
                          uploadPreview: true,
                          isNetwork: aiImageFile != null,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      child: PreviewThemeWidget(
                        selectedDoorBell: selectedDoorBell,
                      ),
                    ),
                    ThemeBlocSelector(
                      selector: (state) => state.uploadThemeApi.isApiInProgress,
                      builder: (isApiInProgress) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomGradientButton(
                            isLoadingEnabled: isApiInProgress,
                            onSubmit: () {
                              if (!isApiInProgress) {
                                bloc.uploadThemeApi(
                                  context,
                                  aiImage: aiImageFile,
                                  file: selectedAsset,
                                  deviceId: selectedDoorBell?.deviceId,
                                  thumbnail: thumbnail,
                                );
                              }
                            },
                            label: selectedDoorBell == null
                                ? context.appLocalizations.add_to_my_themes
                                : context
                                    .appLocalizations.apply_theme_on_doorbell,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
