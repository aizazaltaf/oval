import 'package:admin/pages/main/dashboard/view_model/filters_model.dart';
import 'package:admin/pages/main/statistics/bloc/statistics_bloc.dart';
import 'package:admin/pages/main/statistics/components/guides/statistics_chips_guide.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class StatisticsFiltersWidget extends StatelessWidget {
  const StatisticsFiltersWidget({
    super.key,
    required this.selectedDropDownValue,
    required this.bloc,
    // required this.isFromVisitorHistory,
    required this.innerContext,
    this.visitorId = '',
  });
  final String selectedDropDownValue;
  final BuildContext innerContext;
  final StatisticsBloc bloc;
  final String visitorId;
  // final bool isFromVisitorHistory;

  static List<FiltersModel> timeIntervalFilters = [
    FiltersModel(title: "This Week", value: "this_week", isSelected: true),
    FiltersModel(title: "Last Week", value: "last_week", isSelected: false),
    FiltersModel(title: "30 days", value: "this_month", isSelected: false),
    FiltersModel(
      title: "90 days",
      value: "last_3_months",
      isSelected: false,
    ),
  ];

  static void clearTimeIntervals() {
    for (int i = 0; i < timeIntervalFilters.length; i++) {
      timeIntervalFilters[i].isSelected = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color tabLineColor = CommonFunctions.getTabLineColor(context);
    final Color tabSelectedColor = CommonFunctions.getTabSelectedColor(context);
    return StatisticsBlocSelector(
      selector: (state) => state.statisticsVisitorApi.isApiInProgress,
      builder: (inProgress) {
        return (selectedDropDownValue == bloc.state.dropDownItems[1] ||
                selectedDropDownValue == bloc.state.dropDownItems[3])
            ? const SizedBox.shrink()
            : SizedBox(
                height: 38,
                child: StatisticsBlocSelector.selectedTimeInterval(
                  builder: (timeIntervalVal) {
                    return Showcase.withWidget(
                      key: bloc.statisticsChipsGuideKey,
                      targetPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      targetBorderRadius: BorderRadius.circular(20),
                      container: StatisticsChipsGuide(
                        innerContext: innerContext,
                        bloc: bloc,
                      ),
                      child: ListView.builder(
                        controller: bloc.statisticsFilterScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: timeIntervalFilters.toBuiltList().length,
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (!inProgress) {
                                if (!timeIntervalFilters[index].isSelected!) {
                                  clearTimeIntervals();
                                  bloc.scrollToIndex(index, context);
                                  timeIntervalFilters[index].isSelected = true;
                                  bloc
                                    ..updateSelectedTimeInterval(
                                      timeIntervalFilters[index],
                                    )
                                    // isFromVisitorHistory
                                    //     ? bloc.callIndividualVisitorStats(
                                    //         visitorId: visitorId,
                                    //       )
                                    //     :
                                    ..callStatistics();
                                }
                              }
                            },
                            child: IntrinsicWidth(
                              stepWidth: MediaQuery.of(context).size.width > 500
                                  ? 160
                                  : 20,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 20,
                                      left: (index == 0) ? 10.0 : 0.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          timeIntervalFilters[index].title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: timeIntervalFilters[index]
                                                    .isSelected!
                                                ? tabSelectedColor
                                                : AppColors.lightGreyColor,
                                          ),
                                        ),
                                        const SizedBox(height: 6.5),
                                        if (timeIntervalFilters[index]
                                            .isSelected!)
                                          Container(
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: tabSelectedColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(3),
                                                topRight: Radius.circular(3),
                                              ),
                                            ),
                                          )
                                        else
                                          const SizedBox(height: 4),
                                      ],
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
                      ),
                    );
                  },
                ),
              );
      },
    );
  }
}
