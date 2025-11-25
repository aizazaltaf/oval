import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/app_restrictions.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/componenets/theme_grid_view.dart';
import 'package:admin/pages/themes/create_ai_theme.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainThemeScreen extends StatefulWidget {
  const MainThemeScreen({super.key, this.type});
  final String? type;

  static const routeName = "themeScreen";

  static Future<void> push(
    final BuildContext context,
    final bool isMyTheme, {
    final String? type,
    final Key? key,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => MainThemeScreen(
        type: type,
        key: key,
      ),
    );
  }

  static Future<void> pushAndRemoveUntil(
    final BuildContext context,
    final bool isMyTheme, {
    final String? type,
  }) {
    return navigateToFirstAppScreen(
      context,
      builder: (final _) => MainThemeScreen(
        type: type,
      ),
    );
  }

  @override
  State<MainThemeScreen> createState() => _MainThemeScreenState();
}

class _MainThemeScreenState extends State<MainThemeScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    final startupBloc = StartupBloc.of(context);
    final bloc = ThemeBloc.of(context);
    if (startupBloc.state.userDeviceModel != null &&
        startupBloc.state.userDeviceModel!.isNotEmpty) {
      bloc.callThemesApi(
        type: "My Themes",
        refresh: true,
      );
    }
    // Category themes not set -> then only api will be called
    if (bloc.state.categoryThemesApi.data == null ||
        bloc.state.categoryThemesApi.data!.data.isEmpty) {
      bloc.callCategoryThemesApi();
    }
    bloc
      ..weatherApi()
      ..callThemesApi(
        type: widget.type ?? "Feed",
        refresh: true,
      )
      ..updateDoorBell();

    super.initState();
    if (widget.type == "Popular" ||
        widget.type == "Videos" ||
        widget.type == "Gif") {
      Future.delayed(const Duration(seconds: 1), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  double animate(index, context, targetOffset) {
    final int length = ThemeBloc.of(context).getFilters(isViewer).length;
    if (index == 0 || index == 1) {
      return scrollController.position.minScrollExtent;
    } else if (index == length - 1 || index == length - 2) {
      return scrollController.position.maxScrollExtent;
    }
    return targetOffset;
  }

  void scrollToIndex(int index, context) {
    if (!scrollController.hasClients) {
      return;
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double centerOffset = (screenWidth - 90) / 2; // Center position
    final double targetOffset = (index * 90) - centerOffset;

    scrollController.animateTo(
      animate(index, context, targetOffset),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  bool get isViewer =>
      singletonBloc.profileBloc.state!.locations
          ?.where(
            (a) =>
                a.id ==
                singletonBloc.profileBloc.state!.selectedDoorBell?.locationId,
          )
          .firstOrNull
          ?.roles[0]
          .toLowerCase() ==
      "viewer";

  Widget appBarActionWidget(ThemeBloc bloc) {
    final Color themeWidgetColor =
        CommonFunctions.getThemeBasedWidgetColor(context);
    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (!isViewer) {
              if (singletonBloc.profileBloc.state!.selectedDoorBell != null) {
                bloc.pickThemeAsset(context);
              } else {
                CommonFunctions.addOrShopDialog(context);
              }
            } else {
              ToastUtils.warningToast("Viewer cannot upload theme");
            }
          },
          child: Icon(
            MdiIcons.uploadOutline,
            size: 30,
            color: themeWidgetColor,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            if (!isViewer) {
              if (singletonBloc.profileBloc.state!.selectedDoorBell != null) {
                if (singletonBloc
                    .isFeatureCodePresent(AppRestrictions.aiThemeButton.code)) {
                  unawaited(CreateAIThemeScreen.push(context));
                } else {
                  CommonFunctions.showRestrictionDialog(context);
                }
              } else {
                CommonFunctions.addOrShopDialog(context);
              }
            } else {
              ToastUtils.warningToast("Viewer cannot create Ai theme");
            }
          },
          child: Icon(
            Icons.border_color_outlined,
            size: 22,
            color: singletonBloc
                    .isFeatureCodePresent(AppRestrictions.aiThemeButton.code)
                ? themeWidgetColor
                : Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final startupBloc = StartupBloc.of(context);
    final Color tabLineColor = CommonFunctions.getTabLineColor(context);
    final Color tabSelectedColor = CommonFunctions.getTabSelectedColor(context);
    final bloc = ThemeBloc.of(context);
    bloc.notificationScroll.addListener(bloc.onScroll);
    return ThemeBlocSelector.canPop(
      builder: (canPop) {
        return PopScope(
          canPop: canPop,
          onPopInvokedWithResult: (_, did) {
            if (bloc.state.search.isNotEmpty) {
              bloc.updateOnPop();
            } else {
              bloc.onPop();
              // Navigator.pop(context);
            }
          },
          child: AppScaffold(
            appTitle: context.appLocalizations.themes,
            // onBackPressed: () {
            //   if (bloc.state.search.isNotEmpty) {
            //     bloc.updateOnPop();
            //   } else {
            //     bloc.onPop();
            //     Navigator.pop(context);
            //   }
            // },
            appBarAction: [
              appBarActionWidget(bloc),
              const SizedBox(width: 16),
            ],
            body: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ThemeBlocSelector.searchField(
                    builder: (search) {
                      return NameTextFormField(
                        hintText: context.appLocalizations.search_themes,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.none,
                        onChanged: bloc.updateSearch,

                        controller: search,
                        validator: (value) {
                          return null;
                        },
                        prefix: const Icon(Icons.search),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ), // Allow alphabets and spaces
                          LengthLimitingTextInputFormatter(30),
                        ],
                        // onChanged: bloc.updateName,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: bloc.getFilters(isViewer).length,
                    // itemExtent: 0,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (singletonBloc.profileBloc.state!.selectedDoorBell ==
                              null &&
                          bloc.state.activeType == "My Themes") {
                        return const SizedBox.shrink();
                      }
                      final FeatureModel item =
                          bloc.getFilters(isViewer)[index];
                      return Builder(
                        builder: (c) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (bloc.state.activeType == "Category") {
                                if (bloc.state.categoryThemesApi.data == null ||
                                    bloc.state.categoryThemesApi.data!.data
                                        .isEmpty) {
                                  bloc.callCategoryThemesApi(refresh: true);
                                }
                              }
                              if (bloc.state.activeType != item.value) {
                                // _calculateWidths(bloc.getFilters(isViewer), index);
                                scrollToIndex(index, context);
                                bloc.clearSearch();
                                if (bloc.notificationScroll.hasClients) {
                                  bloc.notificationScroll.jumpTo(0);
                                }
                                bloc.changeActiveType(
                                  startupBloc,
                                  item.value!,
                                  isPageChangeRefreshTheme: true,
                                  onThemeTabChange: true,
                                );
                              }
                            },
                            child: IntrinsicWidth(
                              stepWidth: MediaQuery.of(context).size.width > 500
                                  ? 150
                                  : 100,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: (index == 0) ? 20.0 : 0.0,
                                    ),
                                    child: ThemeBlocSelector.activeType(
                                      builder: (type) {
                                        return Column(
                                          children: [
                                            Text(
                                              item.title,
                                              style: TextStyle(
                                                color: type == item.value
                                                    ? tabSelectedColor
                                                    : AppColors.lightGreyColor,
                                                fontWeight: type == item.value
                                                    ? FontWeight.w500
                                                    : FontWeight.normal,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 7.5),
                                            if (type == item.value)
                                              Container(
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: tabSelectedColor,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft: Radius.circular(3),
                                                    topRight:
                                                        Radius.circular(3),
                                                  ),
                                                ),
                                              )
                                            else
                                              const SizedBox(height: 4),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      right: 20,
                                      left: (index == 0) ? 20.0 : 0.0,
                                    ),
                                    color: tabLineColor,
                                    height: 1.2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const Expanded(
                  child: ThemeGridView(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
