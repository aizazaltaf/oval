import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/statistics/bloc/statistics_bloc.dart';
import 'package:admin/pages/main/statistics/components/statistics_chart.dart';
import 'package:admin/pages/main/statistics/components/statistics_filters_widget.dart';
import 'package:admin/pages/main/statistics/components/statistics_top_widget.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:showcaseview/showcaseview.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({
    super.key,
    // this.isFromVisitorHistory = false,
    this.noInitState = false,
    this.visitorId = '',
    // this.visitorName = '',
  });
  final bool noInitState;
  // final bool isFromVisitorHistory;
  final String visitorId;
  // final String visitorName;

  static const routeName = "Statistics";

  static Future<void> push({
    required BuildContext context,
    // bool isFromVisitorHistory = false,
    bool noInitState = false,
    String visitorId = '',
    // String visitorName = '',
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => StatisticsPage(
        // isFromVisitorHistory: isFromVisitorHistory,
        noInitState: noInitState,
        visitorId: visitorId,
        // visitorName: visitorName,
      ),
    );
  }

  static final GlobalKey statisticsGuideOneKey = GlobalKey();
  static final GlobalKey statisticsGuideTwoKey = GlobalKey();
  static final GlobalKey statisticsGuideThreeKey = GlobalKey();

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    super.initState();
    final bloc = StatisticsBloc.of(context);
    if (!bloc.state.statisticsGuideShow) {
      if (singletonBloc.profileBloc.state?.guides == null ||
          singletonBloc.profileBloc.state?.guides?.statisticsGuide == null ||
          singletonBloc.profileBloc.state?.guides?.statisticsGuide == 0) {
        bloc
          ..updateStatisticsGuideShow(false)
          ..updateCurrentGuideKey("dropDown");
      } else {
        bloc.updateStatisticsGuideShow(true);
      }
    }
    if (!widget.noInitState) {
      // if (widget.isFromVisitorHistory) {
      //   bloc
      //     ..updateSelectedDropDownValue(Constants.frequencyOfVisitsKey)
      //     ..updateSelectedTimeInterval(
      //       FiltersModel(
      //         title: "This Week",
      //         value: "this_week",
      //         isSelected: true,
      //       ),
      //     );
      //   StatisticsFiltersWidget.clearTimeIntervals();
      //   StatisticsFiltersWidget.timeIntervalFilters[0].isSelected = true;
      //   bloc.callIndividualVisitorStats(visitorId: widget.visitorId);
      // } else {
      bloc
        ..scrollToIndex(0, context)
        ..callStatistics();
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = StatisticsBloc.of(context);
    return StatisticsBlocSelector(
      selector: (state) => state.statisticsGuideShow,
      builder: (guideShow) {
        return ShowCaseWidget(
          builder: (_) => Builder(
            builder: (innerContext) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                if (!guideShow) {
                  ShowCaseWidget.of(innerContext).startShowCase(
                    [bloc.getCurrentGuide()],
                  );
                }
              });
              return AppScaffold(
                appTitle: context.appLocalizations.statistics,
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: StatisticsBlocSelector.selectedDropDownValue(
                    builder: (selectedDropDownValue) => Column(
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        StatisticsTopWidget(
                          // isFromVisitorHistory: widget.isFromVisitorHistory,
                          selectedDropDownValue: selectedDropDownValue,
                          bloc: bloc,
                          innerContext: innerContext,
                        ),
                        SizedBox(height: 3.h),
                        StatisticsFiltersWidget(
                          visitorId: widget.visitorId,
                          // isFromVisitorHistory: widget.isFromVisitorHistory,
                          selectedDropDownValue: selectedDropDownValue,
                          innerContext: innerContext,
                          bloc: bloc,
                        ),
                        // SizedBox(
                        //   height: 2.h,
                        // ),
                        // if (widget.visitorName.isEmpty)
                        //   const SizedBox.shrink()
                        // else
                        //   Text(
                        //     widget.visitorName.contains("A new")
                        //         ? "Unknown"
                        //         : widget.visitorName,
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .bodyMedium!
                        //         .copyWith(
                        //           color:
                        //               CommonFunctions.getThemeBasedWidgetColor(
                        //             context,
                        //           ),
                        //           fontSize: 16,
                        //         ),
                        //   ),
                        SizedBox(
                          height: 3.h,
                        ),
                        StatisticsBlocSelector(
                          selector: (state) =>
                              state.statisticsVisitorApi.isApiInProgress,
                          builder: (isLoading) => isLoading
                              ? Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(top: 30.h),
                                  child: ButtonProgressIndicator(
                                    height: 36,
                                    width: 36,
                                    strokeWidth: 4,
                                    fgColor: Theme.of(context).primaryColor,
                                    bgColor: Colors.transparent,
                                  ),
                                )
                              : StatisticsBlocSelector(
                                  selector: (state) => state.statisticsList,
                                  builder: (statisticsTitle) => Row(
                                    children: [
                                      if (bloc.state.statisticsList.isEmpty ||
                                          bloc.state.statisticsList.every(
                                            (element) =>
                                                element.visitCount == 0,
                                          ))
                                        const SizedBox.shrink()
                                      else
                                        RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            bloc.state.selectedDropDownValue ==
                                                    Constants.daysOfWeekKey
                                                ? context.appLocalizations
                                                    .no_of_visitors
                                                : context.appLocalizations
                                                    .no_of_visits,
                                            style: TextStyle(
                                              color: CommonFunctions
                                                  .getThemeBasedWidgetColor(
                                                context,
                                              ),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.60,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        child: StatisticsChart(
                                          statisticsList:
                                              bloc.state.statisticsList,
                                          timeInterval:
                                              bloc.state.selectedTimeInterval,
                                          selectedDropDownValue:
                                              bloc.state.selectedDropDownValue,
                                          // visitorName: widget.visitorName,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
  }
}
