import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/category_widget.dart';
import 'package:admin/pages/themes/componenets/theme_list_card.dart';
import 'package:admin/pages/themes/componenets/view_category_screen.dart';
import 'package:admin/pages/themes/componenets/view_my_themes_screen.dart';
import 'package:admin/pages/themes/model/theme_category_model.dart';
import 'package:admin/pages/themes/model/theme_data_model.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart' as pull;

class ThemeGridView extends StatelessWidget {
  const ThemeGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    return ThemeBlocBuilder(
      builder: (context, state) {
        return ThemeDetailGrid(forHome: bloc.state.activeType == "Feed");
      },
    );
  }
}

class ThemeDetailGrid extends StatelessWidget {
  const ThemeDetailGrid({
    super.key,
    this.fromCategory = false,
    this.forHome = false,
    this.categoryId,
    this.viewCategoriesScreen = false,
  });

  final bool fromCategory;
  final bool forHome;
  final int? categoryId;
  final bool viewCategoriesScreen;
  bool get isViewer =>
      singletonBloc.profileBloc.state!.locations
          ?.singleWhereOrNull(
            (a) =>
                a.id ==
                singletonBloc.profileBloc.state!.selectedDoorBell?.locationId,
          )
          ?.roles[0]
          .toLowerCase() ==
      "viewer";

  @override
  Widget build(BuildContext context) {
    final bloc = ThemeBloc.of(context);
    return ThemeBlocBuilder(
      builder: (context, state) {
        return ThemeBlocSelector.simpleThemesError(
          builder: (error) {
            final ApiState<PaginatedData<ThemeDataModel>> apiState =
                bloc.getThemeApiType(
              fromCategory ? "Category" : bloc.state.activeType,
            );

            // if Feed Tab is selected
            final ApiState<PaginatedData<ThemeDataModel>> myThemesApiState =
                bloc.state.myThemes;

            final BuiltList<ThemeDataModel> theme =
                apiState.data?.data ?? <ThemeDataModel>[].toBuiltList();
            final BuiltList<ThemeCategoryModel> categoryThemes =
                bloc.state.categoryThemesApi.data?.data ??
                    <ThemeCategoryModel>[].toBuiltList();
            final BuiltList<ThemeDataModel> myThemes =
                bloc.state.myThemes.data?.data ??
                    <ThemeDataModel>[].toBuiltList();

            if (forHome &&
                ((apiState.isApiInProgress && apiState.data == null) ||
                    myThemesApiState.isApiInProgress &&
                        myThemesApiState.data != null)) {
              return const Center(child: CircularProgressIndicator());
            } else if (error ==
                    context.appLocalizations.no_internet_connection &&
                theme.isEmpty) {
              return CommonFunctions.noSamples(
                context,
                text: context.appLocalizations.no_internet_connection,
              );
            } else if (apiState.isApiInProgress && theme.isEmpty) {
              return const Center(child: CircularProgressIndicator());
              // if (viewCategoriesScreen) {
              //   return const Center(child: CircularProgressIndicator());
              // } else if (fromCategory) {
              //   return FutureBuilder(
              //     future: Future.delayed(const Duration(seconds: 1)),
              //     builder: (context, snapshot) {
              // final bool showProgress =
              //     snapshot.connectionState == ConnectionState.done;
              // if (showProgress) {
              // return const Center(child: CircularProgressIndicator());
              // }
              // return const SizedBox.shrink();
              //     },
              //   );
              // } else {
              //   return const Center(child: CircularProgressIndicator());
              // }
            } else if (forHome) {
              if (theme.isEmpty && categoryThemes.isEmpty && myThemes.isEmpty) {
                return CommonFunctions.noSamples(context);
              }
            } else if (!forHome) {
              if (theme.isEmpty) {
                return CommonFunctions.noSamples(context);
              }
            }

            if (fromCategory) {
              return RefreshIndicator(
                onRefresh: () async {
                  await bloc.callThemesApi(
                    type: state.activeType,
                    categoryId: categoryId,
                    refresh: true,
                  );
                },
                color: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context)
                    .cupertinoOverrideTheme
                    ?.barBackgroundColor,
                child: pull.SmartRefresher(
                  enablePullDown: false,
                  enablePullUp: apiState.data?.nextPageUrl?.isNotEmpty ?? false,
                  header: const pull.WaterDropHeader(),
                  controller: pull.RefreshController(),
                  child: ListView(
                    shrinkWrap: true,
                    controller: bloc.categoryNotificationScroll,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      GridView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          15,
                          15,
                          15,
                          20,
                        ),
                        shrinkWrap: true,
                        itemCount: theme.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ThemeListCard(
                            data: theme[index],
                            themes: theme,
                            index: index,
                          );
                        },
                      ),
                      if (!apiState.isApiInProgress &&
                          apiState.currentPage == apiState.totalCount)
                        noMoreThemesAvailable(context),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await bloc.callThemesApi(
                  type: state.activeType,
                  refresh: true,
                );
              },
              color: Theme.of(context).primaryColor,
              backgroundColor:
                  Theme.of(context).cupertinoOverrideTheme!.barBackgroundColor,
              child: pull.SmartRefresher(
                enablePullDown: false,
                enablePullUp: apiState.data?.nextPageUrl?.isNotEmpty ?? false,
                header: const pull.WaterDropHeader(),
                controller: pull.RefreshController(),
                child: forHome
                    ? homeThemes(context: context, bloc: bloc)
                    : ListView(
                        shrinkWrap: true,
                        controller: bloc.notificationScroll,
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          GridView.builder(
                            // controller: bloc.notificationScroll,
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(
                              15,
                              15,
                              15,
                              20,
                            ),
                            itemCount: theme.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ThemeListCard(
                                data: theme[index],
                                themes: theme,
                                index: index,
                              );
                            },
                          ),
                          if (!apiState.isApiInProgress &&
                              apiState.currentPage == apiState.totalCount)
                            noMoreThemesAvailable(context),
                        ],
                      ),
              ),
            );

            // return SmartRefresher(
            //   enablePullDown: true,
            //   enablePullUp: apiState.data?.nextPageUrl?.isNotEmpty ?? false,
            //   header: const WaterDropHeader(),
            //   controller: bloc.getFilters(isViewer)[i].controller!,
            //   onRefresh: () async {
            //     await Future.delayed(const Duration(milliseconds: 1000));
            //     Future.delayed(const Duration(seconds: 2), () {
            //       bloc.getFilters(isViewer)[i].controller!.refreshCompleted();
            //     });
            //     bloc.callThemesApi(
            //       type: state.activeType,
            //       refresh: true,
            //     );
            //     bloc.getFilters(isViewer)[i].controller!.refreshCompleted();
            //   },
            //   child: GridView.builder(
            //     controller: bloc.notificationScroll,
            //     padding: const EdgeInsets.fromLTRB(
            //       15.0,
            //       15.0,
            //       15.0,
            //       20.0,
            //     ),
            //     itemCount: theme.length,
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       mainAxisSpacing: 10,
            //       crossAxisSpacing: 10,
            //       crossAxisCount: 2,
            //       childAspectRatio: 0.65,
            //     ),
            //     physics: const BouncingScrollPhysics(),
            //     itemBuilder: (BuildContext context, int index) {
            //       return ThemeListCard(
            //         data: theme[index],
            //         themes: theme,
            //         index: index,
            //       );
            //     },
            //   ),
            // );
          },
        );
      },
    );
  }

  Widget homeThemes({required BuildContext context, required ThemeBloc bloc}) {
    final startupBloc = StartupBloc.of(context);
    final BuiltList<ThemeCategoryModel>? categoryThemes =
        bloc.state.categoryThemesApi.data?.data;
    final BuiltList<ThemeDataModel>? myThemes = bloc.state.myThemes.data?.data;
    final BuiltList<ThemeDataModel>? feedThemes =
        bloc.state.feedThemes.data?.data;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        controller: bloc.notificationScroll,
        children: [
          const SizedBox(
            height: 15,
          ),
          if (categoryThemes == null || categoryThemes.isEmpty)
            const SizedBox.shrink()
          else
            Row(
              children: [
                getHomeItemsTitle(context, "Category"),
                const Spacer(),
                if (categoryThemes.length > 6)
                  getViewAll(
                    context,
                    onTap: () {
                      bloc
                        ..updateActiveType("Category")
                        ..clearSearchFromCategories();
                      ViewCategoryScreen.push(context).then((c) {
                        bloc.changeActiveType(
                          startupBloc,
                          "Feed",
                          refresh: true,
                        );
                      });
                    },
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          if (categoryThemes == null || categoryThemes.isEmpty)
            const SizedBox.shrink()
          else
            SizedBox(
              height: 200,
              child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 15),
                itemCount:
                    categoryThemes.length > 6 ? 6 : categoryThemes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 1,
                  childAspectRatio: 1.2,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CategoryWidget(
                    themeCategory: categoryThemes[index],
                  );
                },
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          if (myThemes == null || myThemes.isEmpty)
            const SizedBox.shrink()
          else
            Row(
              children: [
                getHomeItemsTitle(context, "My Themes"),
                const Spacer(),
                if (myThemes.length > 6)
                  getViewAll(
                    context,
                    onTap: () {
                      bloc
                        ..clearSearchFromCategories()
                        ..updateActiveType("My Themes");
                      ViewMyThemesScreen.push(context).then((c) {
                        bloc.changeActiveType(
                          startupBloc,
                          "Feed",
                          refresh: true,
                        );
                      });
                    },
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          if (myThemes == null || myThemes.isEmpty)
            const SizedBox.shrink()
          else
            SizedBox(
              height: 200,
              child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 15),
                itemCount: myThemes.length > 6 ? 6 : myThemes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 1,
                  childAspectRatio: 1.5,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ThemeListCard(
                    data: myThemes[index],
                    isMyTheme: true,
                    themes: myThemes,
                    index: index,
                  );
                },
              ),
            ),
          if (feedThemes == null || feedThemes.isEmpty)
            const SizedBox.shrink()
          else
            getHomeItemsTitle(context, "Feed"),
          if (feedThemes == null || feedThemes.isEmpty)
            const SizedBox.shrink()
          else
            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
              itemCount: feedThemes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 3,
                childAspectRatio: 0.7,
              ),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ThemeListCard(
                  data: feedThemes[index],
                  themes: feedThemes,
                  index: index,
                );
              },
            ),
          ThemeBlocSelector(
            selector: (state) => state.feedThemes.isApiInProgress,
            builder: (inProgress) {
              if (inProgress &&
                  bloc.state.feedThemes.data != null &&
                  bloc.state.feedThemes.data!.data.isNotEmpty) {
                return const Column(
                  children: [
                    Center(
                      child: ButtonProgressIndicator(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              }
              Constants.dismissLoader();

              if (!bloc.state.feedThemes.isApiInProgress &&
                  bloc.state.feedThemes.currentPage ==
                      bloc.state.feedThemes.totalCount) {
                return noMoreThemesAvailable(context);
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget getHomeItemsTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
    );
  }

  Widget getViewAll(BuildContext context, {required VoidCallback onTap}) {
    return TextButton(
      style: const ButtonStyle(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      onPressed: onTap,
      child: Row(
        children: [
          Text(
            context.appLocalizations.view_all_theme,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(
            width: 5,
          ),
          Icon(
            Icons.keyboard_arrow_right,
            size: 22,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget noMoreThemesAvailable(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          "No More Themes Available",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
