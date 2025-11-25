import 'dart:async';

import 'package:admin/extensions/context.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/category_widget.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';

class ViewCategoryScreen extends StatelessWidget {
  const ViewCategoryScreen({super.key});

  static const routeName = "ViewCategoryScreen";

  static Future<void> push(final BuildContext context) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const ViewCategoryScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    return AppScaffold(
      appTitle: context.appLocalizations.categories,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ThemeBlocSelector(
          selector: (state) => state.categoryThemesApi.isApiInProgress,
          builder: (isLoading) {
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (bloc.state.categoryThemesApi.data == null ||
                  bloc.state.categoryThemesApi.data!.data.isEmpty) {
                return CommonFunctions.noSamples(context);
              }

              return GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 15),
                itemCount: bloc.state.categoryThemesApi.data!.data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                  childAspectRatio: 1.6,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CategoryWidget(
                    themeCategory:
                        bloc.state.categoryThemesApi.data!.data[index],
                    viewCategoriesScreen: true,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
