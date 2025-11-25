import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/bottom_navigation/visitor_history_bottom_nav_bar.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/visitor_history_listview.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/visitor_history_tab_filters.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/visitor_info_card.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class VisitorHistoryPage extends StatefulWidget {
  const VisitorHistoryPage({super.key});

  static const routeName = "VisitorHistory";

  static Future<void> push(final BuildContext context) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const VisitorHistoryPage(),
    );
  }

  @override
  State<VisitorHistoryPage> createState() => _VisitorHistoryPageState();
}

class _VisitorHistoryPageState extends State<VisitorHistoryPage> {
  @override
  void initState() {
    super.initState();
    final bloc = VisitorManagementBloc.of(context);
    if (!bloc.state.historyGuideShow) {
      if (singletonBloc.profileBloc.state?.guides == null ||
          singletonBloc.profileBloc.state?.guides?.visitorHistoryGuide ==
              null ||
          singletonBloc.profileBloc.state?.guides?.visitorHistoryGuide == 0) {
        bloc
          ..updateHistoryGuideShow(false)
          ..updateCurrentGuideKey("chart");
      } else {
        bloc.updateHistoryGuideShow(true);
      }
    }
  }

  void onScroll(VisitorManagementBloc bloc) {
    bloc.visitorHistoryScrollController.addListener(() {
      if (bloc.state.selectedVisitor != null) {
        bloc.onVisitorHistoryScroll(bloc.state.selectedVisitor!.id.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = VisitorManagementBloc.of(context);
    onScroll(bloc);
    return VisitorManagementBlocSelector(
      selector: (state) => state.historyGuideShow,
      builder: (guideShow) {
        return VisitorManagementBlocSelector(
          selector: (state) => state.visitorHistoryApi.isApiInProgress,
          builder: (isLoading) {
            return ShowCaseWidget(
              builder: (_) => Builder(
                builder: (innerContext) {
                  if (!(isLoading ||
                      bloc.state.visitorHistoryApi.data == null ||
                      bloc.state.visitorHistoryApi.data!.data.isEmpty)) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      if (!guideShow) {
                        ShowCaseWidget.of(innerContext).startShowCase(
                          [bloc.getCurrentGuide()],
                        );
                      }
                    });
                  }
                  return AppScaffold(
                    appBarAction: const [
                      // Showcase.withWidget(
                      //   key: bloc.chartGuideKey,
                      //   height: 400,
                      //   width: MediaQuery.of(context).size.width,
                      //   container: ChartGuide(
                      //     innerContext: innerContext,
                      //     bloc: bloc,
                      //   ),
                      //   child: GestureDetector(behavior: HitTestBehavior.opaque,
                      //     onTap: () => StatisticsPage.push(
                      //       context: context,
                      //       isFromVisitorHistory: true,
                      //       visitorName: bloc.state.selectedVisitor!.name,
                      //       visitorId:
                      //           bloc.state.selectedVisitor!.id.toString(),
                      //     ),
                      //     child: SvgPicture.asset(
                      //       DefaultImages.CHART_LINE,
                      //       colorFilter: ColorFilter.mode(
                      //         CommonFunctions.getThemeBasedWidgetColor(
                      //           context,
                      //         ),
                      //         BlendMode.srcIn,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // VisitorFilterPanel(
                      //   bloc: bloc,
                      //   forVisitorHistoryPage: true,
                      //   visitorId: bloc.state.selectedVisitor!.id.toString(),
                      // ),
                    ],
                    bottomNavigationBar:
                        VisitorManagementBlocSelector.selectedVisitor(
                      builder: (visitor) {
                        return VisitorHistoryBottomNavBar(
                          parentContext: context,
                          innerContext: innerContext,
                          visitor: visitor,
                          bloc: bloc,
                        );
                      },
                    ),
                    appTitle: context.appLocalizations.visitor_history,
                    body: NoGlowListViewWrapper(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // VisitorManagementBlocSelector.historyFilterValue(
                            //   builder: (filter) {
                            //     return filter == null
                            //         ? const SizedBox.shrink()
                            //         : VisitorManagementClearFilters(
                            //             bloc: bloc,
                            //             onTap: () {
                            //               bloc.callFilters(
                            //                 forVisitorHistoryPage: true,
                            //                 visitorId: bloc
                            //                     .state.selectedVisitor!.id
                            //                     .toString(),
                            //               );
                            //             },
                            //           );
                            //   },
                            // ),
                            const SizedBox(
                              height: 30,
                            ),
                            VisitorManagementBlocSelector.selectedVisitor(
                              builder: (visitor) {
                                return VisitorInfoCard(
                                  bloc: bloc,
                                  visitor: visitor,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            VisitorHistoryTabFilters(bloc: bloc),
                            const SizedBox(
                              height: 20,
                            ),
                            VisitorManagementBlocSelector.selectedVisitor(
                              builder: (visitor) {
                                return VisitorHistoryListView(
                                  bloc: bloc,
                                  innerContext: innerContext,
                                  visitor: visitor,
                                );
                              },
                            ),
                            VisitorManagementBlocSelector(
                              selector: (state) =>
                                  state.visitorHistoryApi.isApiInProgress,
                              builder: (isLoading) {
                                if (isLoading &&
                                    bloc.state.visitorHistoryApi.data != null) {
                                  return const ButtonProgressIndicator();
                                } else {
                                  Constants.dismissLoader();

                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
