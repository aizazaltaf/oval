import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_grid_view.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';

class CategoryDetailGrid extends StatelessWidget {
  const CategoryDetailGrid({
    super.key,
    required this.themeName,
    required this.categoryId,
    this.viewCategoriesScreen = false,
  });
  final String themeName;
  final int categoryId;
  static const routeName = "categoryDetailGrid";
  final bool viewCategoriesScreen;

  static Future<void> push(
    final BuildContext context,
    final String themeName,
    int categoryId, {
    bool viewCategoriesScreen = false,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => CategoryDetailGrid(
        themeName: themeName,
        categoryId: categoryId,
        viewCategoriesScreen: viewCategoriesScreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    bloc.categoryNotificationScroll.addListener(bloc.onCategoryIdScroll);
    return AppScaffold(
      appTitle: themeName,
      body: ThemeDetailGrid(
        fromCategory: true,
        categoryId: categoryId,
        viewCategoriesScreen: viewCategoriesScreen,
      ),
    );
  }
}
