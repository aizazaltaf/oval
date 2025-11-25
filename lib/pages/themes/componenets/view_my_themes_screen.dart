import 'package:admin/extensions/context.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_list_card.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';

class ViewMyThemesScreen extends StatefulWidget {
  const ViewMyThemesScreen({super.key});

  static const routeName = "ViewMyThemesScreen";

  static Future<void> push(final BuildContext context) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const ViewMyThemesScreen(),
    );
  }

  @override
  State<ViewMyThemesScreen> createState() => _ViewMyThemesScreenState();
}

class _ViewMyThemesScreenState extends State<ViewMyThemesScreen> {
  @override
  void initState() {
    //  implement initState
    super.initState();
    ThemeBloc.of(context).callThemesApi(
      type: "My Themes",
      refresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    return AppScaffold(
      appTitle: context.appLocalizations.my_themes,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ThemeBlocSelector(
          selector: (state) => state.myThemes.isApiInProgress,
          builder: (isLoading) {
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (bloc.state.myThemes.data == null ||
                  bloc.state.myThemes.data!.data.isEmpty) {
                return CommonFunctions.noSamples(context);
              } else {
                return GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  itemCount: bloc.state.myThemes.data!.data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 3,
                    childAspectRatio: 0.55,
                  ),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ThemeListCard(
                      data: bloc.state.myThemes.data!.data[index],
                      themes: bloc.state.myThemes.data!.data,
                      index: index,
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
