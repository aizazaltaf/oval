import 'dart:io';

import 'package:admin/pages/main/user_profile/components/profile_shimmer_widget.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_preview.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ThemeThumbnailPreview extends StatelessWidget {
  const ThemeThumbnailPreview({
    super.key,
    required this.themesList,
    required this.data,
    this.fit,
    this.isMyTheme = false,
    required this.index,
  });
  final ThemeDataModel data;
  final int index;
  final BuiltList<ThemeDataModel> themesList;
  final bool isMyTheme;

  final BoxFit? fit;

  bool get isLocalFile => !data.cover.contains("http");
  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        bloc
          ..updateIndex(index)
          ..updateIsDetailThemePage(true)
          ..updateThemeId(data.id);
        if (isMyTheme) {
          Future.delayed(const Duration(milliseconds: 300), () {
            bloc.updateActiveType("My Themes");
          });
        }

        ThemePreview.push(
          context,
          fit,
          themesList,
        ).then((_) {
          bloc.updateIsDetailThemePage(false);
          if (isMyTheme) {
            bloc.updateActiveType("Feed");
          }
        });
      },
      child: isLocalFile
          ? Image.file(
              File(data.thumbnail),
              fit: fit ?? BoxFit.fill,
            )
          : CachedNetworkImage(
              imageUrl: data.thumbnail,
              memCacheHeight: 400,
              fit: fit ?? BoxFit.fill,
              placeholder: (c_, _) => PrimaryShimmer(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
    );
  }
}
