import 'dart:async';

import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/main/user_profile/components/profile_shimmer_widget.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/category_detail_grid.dart';
import 'package:admin/pages/themes/model/theme_category_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({
    super.key,
    required this.themeCategory,
    this.viewCategoriesScreen = false,
  });

  final ThemeCategoryModel themeCategory;
  final bool viewCategoriesScreen;

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    _preloadImage(widget.themeCategory.image);
  }

  void _preloadImage(String imageUrl) {
    final image = CachedNetworkImageProvider(imageUrl);
    image.resolve(ImageConfiguration.empty).addListener(
          ImageStreamListener(
            (info, _) {
              if (mounted) {
                setState(() {
                  _isImageLoaded = true;
                });
              }
            },
            onError: (error, stackTrace) {
              // You can handle load failure here, if needed
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final startupBloc = StartupBloc.of(context);
        bloc
          ..updateCategoryApiId(
            widget.themeCategory.id,
          )
          ..updateActiveType("Category")
          ..clearSearchFromCategories();

        unawaited(
          CategoryDetailGrid.push(
            context,
            widget.themeCategory.name,
            widget.themeCategory.id,
            viewCategoriesScreen: widget.viewCategoriesScreen,
          ).then((c) {
            bloc.changeActiveType(
              startupBloc,
              "Feed",
              refresh: true,
            );
          }),
        );

        unawaited(
          bloc.callThemesApi(
            type: "Category",
            categoryId: widget.themeCategory.id,
            refresh: true,
            isPageChangeRefreshTheme: true,
          ),
        );

        // Future.delayed(Duration.zero, () {
        //   unawaited(
        //     bloc.callThemesApi(
        //       type: "Category",
        //       categoryId: widget.themeCategory.id,
        //       refresh: true,
        //       isPageChangeRefreshTheme: true,
        //     ),
        //   );
        // });
      },
      child: _isImageLoaded
          ? Container(
              alignment: widget.viewCategoriesScreen
                  ? Alignment.center
                  : Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.themeCategory.image),
                  colorFilter: const ColorFilter.mode(
                    Colors.black38,
                    BlendMode.colorBurn,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: _buildTextOverlay(context, widget.themeCategory.name),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: PrimaryShimmer(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ), // <- your shimmer widget
            ),
    );
  }

  Widget _buildTextOverlay(BuildContext context, String title) {
    return Container(
      decoration: BoxDecoration(
        color: widget.viewCategoriesScreen ? null : Colors.black38,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.white, fontSize: 22),
      ),
    );
  }
}
