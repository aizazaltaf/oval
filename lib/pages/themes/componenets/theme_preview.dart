import 'dart:io';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/user_profile/components/profile_shimmer_widget.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_details_buttom.dart';
import 'package:admin/pages/themes/componenets/theme_name_widget.dart';
import 'package:admin/pages/themes/componenets/theme_video_player.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemePreview extends StatelessWidget {
  const ThemePreview({
    super.key,
    required this.themesList,
    this.fit,
    this.height,
    this.isName = true,
    this.width,
    this.showForPreviewOnly = false,
  });
  final BoxFit? fit;
  final double? height;
  final double? width;
  final bool isName;
  final BuiltList<ThemeDataModel> themesList;
  final bool showForPreviewOnly;
  static const routeName = "themePreview";

  static Future<void> push(
    final BuildContext context,
    final BoxFit? fit,
    final BuiltList<ThemeDataModel> themesList,
  ) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => ThemePreview(fit: fit, themesList: themesList),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    if (themesList.isEmpty) {
      return const SizedBox.shrink();
    }

    return ThemeBlocBuilder(
      builder: (context, state) {
        return AppScaffold(
          body: PopScope(
            onPopInvokedWithResult: (_, r) {
              // if (bloc.state.activeType == "My Themes") {
              //   bloc.updateActiveType("Feed");
              // }
              bloc.updateIsDetailThemePage(false);
            },
            child: SafeArea(
              child: Stack(
                children: [
                  ThemeBlocSelector.index(
                    builder: (index) {
                      final bool isVideo = themesList[index].mediaType == 3 &&
                          CommonFunctions.isVideoTheme(themesList[index].cover);
                      final bool isLocalFile =
                          !(themesList[index].cover.contains("http") ||
                              themesList[index].cover.contains("Caches"));
                      if (isVideo) {
                        return ThemeVideoPlayer(
                          isName: isName,
                          videoUrl: themesList[index].cover,
                          isDetail: true,
                          showForPreviewOnly: showForPreviewOnly,
                          themesList: themesList,
                        );
                      } else if (isLocalFile) {
                        return Image.file(
                          File(themesList[index].cover),
                          width: width,
                          fit: fit ?? BoxFit.fill,
                        );
                      }
                      if (!showForPreviewOnly) {
                        return PreviewWidget(
                          fit: fit,
                          showForPreviewOnly: showForPreviewOnly,
                          themesList: themesList,
                          index: index,
                        );
                      }
                      return ImageWidget(
                        fit: fit,
                        themesList: themesList,
                        index: index,
                      );
                    },
                  ),
                  // if (!showForPreviewOnly &&
                  //     singletonBloc.profileBloc.state!.selectedDoorBell != null)
                  //   ThemeBlocSelector.index(
                  //     builder: (index) {
                  //       if (bloc.getThemeApiType(bloc.state.activeType).data == null) {
                  //         return const SizedBox.shrink();
                  //       }
                  //       final int themeId = bloc
                  //           .getThemeApiType(bloc.state.activeType)
                  //           .data!
                  //           .data[index]
                  //           .id;
                  //       final bool isApplied = bloc
                  //               .getThemeApiType(bloc.state.activeType)
                  //               .data!
                  //               .data
                  //               .singleWhereOrNull((e) => e.id == themeId)
                  //               ?.isApplied ??
                  //           false;
                  //
                  //       return Positioned(
                  //         bottom: 30,
                  //         right: 15,
                  //         child: ThemeDetailsButtons(
                  //           themeId: themeId,
                  //           isAppliedTheme: isApplied,
                  //           data: bloc
                  //               .getThemeApiType(bloc.state.activeType)
                  //               .data!
                  //               .data
                  //               .singleWhere((e) => e.id == themeId),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  if (isName)
                    Positioned(
                      top: 16,
                      right: 15,
                      child: ThemeBlocSelector.index(
                        builder: (index) {
                          return bloc.state.activeType != "My Themes"
                              ? const SizedBox.shrink()
                              : themesList[index].isApplied
                                  ? const SizedBox.shrink()
                                  : deleteTheme(context, bloc, index);
                        },
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

  Widget deleteTheme(BuildContext context, ThemeBloc bloc, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => StatefulBuilder(
            builder: (dialogContext, snapshot) {
              return AppDialogPopup(
                title: context.appLocalizations.delete_theme_dialog_title,
                confirmButtonLabel: context.appLocalizations.general_delete,
                cancelButtonLabel: context.appLocalizations.general_cancel,
                cancelButtonOnTap: () {
                  Navigator.pop(dialogContext);
                },
                confirmButtonOnTap: () async {
                  Navigator.pop(dialogContext);
                  await bloc.deleteTheme(
                    context,
                    themesList[index].id,
                  );
                },
              );
            },
          ),
        );
      },
      child: const Icon(
        CupertinoIcons.delete,
        color: Colors.white,
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.fit,
    required this.themesList,
    required this.index,
  });
  final BoxFit? fit;
  final BuiltList<ThemeDataModel> themesList;
  final int index;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (themesList[index].cover.contains("Caches")) {
      return Image.file(
        File(themesList[index].cover),
        fit: fit ?? BoxFit.fill,
        width: MediaQuery.of(context).size.width,
        height: height,
        color: Colors.black38,
        colorBlendMode: BlendMode.colorBurn,
      );
    }
    return CachedNetworkImage(
      imageUrl: themesList[index].cover,
      fit: fit ?? BoxFit.fill,
      width: MediaQuery.of(context).size.width,
      height: height,
      color: Colors.black38,
      colorBlendMode: BlendMode.colorBurn,
      placeholder: (c_, _) => PrimaryShimmer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class PreviewWidget extends StatelessWidget {
  const PreviewWidget({
    super.key,
    required this.fit,
    required this.themesList,
    required this.index,
    this.inGestureDisable = false,
    this.showForPreviewOnly = false,
  });

  final BoxFit? fit;
  final BuiltList<ThemeDataModel> themesList;
  final int index;
  final bool inGestureDisable;
  final bool showForPreviewOnly;

  static const routeName = "previewWidget";
  static Future<void> push(
    final BuildContext context,
    final BoxFit? fit,
    final BuiltList<ThemeDataModel> themesList,
    final int index,
    final bool inGestureDisable, {
    final bool showForPreviewOnly = false,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => PreviewWidget(
        fit: fit,
        themesList: themesList,
        showForPreviewOnly: showForPreviewOnly,
        index: index,
        inGestureDisable: inGestureDisable,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            // bloc.updateActiveType("Feed");
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            // BLOCK horizontal drag gestures
            onHorizontalDragStart: (_) {},
            onHorizontalDragUpdate: (_) {},
            onHorizontalDragEnd: (_) {},

            onVerticalDragEnd: (dragDetail) {
              if (!inGestureDisable) {
                if (dragDetail.velocity.pixelsPerSecond.dy < 40) {
                  bloc.changeVideoTheme(themesList.length, true);
                } else {
                  bloc.changeVideoTheme(themesList.length, false);
                }
              }
            },
            child: ImageWidget(
              fit: fit,
              themesList: themesList,
              index: index,
            ),
          ),
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
                      theme: themesList[index],
                    ),
                  ),
                  if (!showForPreviewOnly &&
                      singletonBloc.profileBloc.state!.selectedDoorBell != null)
                    ThemeBlocSelector.index(
                      builder: (index) {
                        if (bloc.getThemeApiType(bloc.state.activeType).data ==
                            null) {
                          return const SizedBox.shrink();
                        }
                        final int themeId = bloc
                            .getThemeApiType(bloc.state.activeType)
                            .data!
                            .data[index]
                            .id;
                        final bool isApplied = bloc
                                .getThemeApiType(bloc.state.activeType)
                                .data!
                                .data
                                .singleWhereOrNull((e) => e.id == themeId)
                                ?.isApplied ??
                            false;

                        return ThemeDetailsButtons(
                          themeId: themeId,
                          isAppliedTheme: isApplied,
                          data: bloc
                              .getThemeApiType(bloc.state.activeType)
                              .data!
                              .data
                              .singleWhere((e) => e.id == themeId),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
