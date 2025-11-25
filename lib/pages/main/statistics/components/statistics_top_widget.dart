import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/dashboard/view_model/filters_model.dart';
import 'package:admin/pages/main/statistics/bloc/statistics_bloc.dart';
import 'package:admin/pages/main/statistics/components/guides/statistics_calendar_guide.dart';
import 'package:admin/pages/main/statistics/components/guides/statistics_dropdown_guide.dart';
import 'package:admin/pages/main/statistics/components/statistics_filters_widget.dart';
import 'package:admin/widgets/app_drop_down_button.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/custom_date_picker.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcaseview/showcaseview.dart';

class StatisticsTopWidget extends StatelessWidget {
  const StatisticsTopWidget({
    super.key,
    required this.selectedDropDownValue,
    required this.bloc,
    // required this.isFromVisitorHistory,
    required this.innerContext,
  });
  final String selectedDropDownValue;
  final StatisticsBloc bloc;
  final BuildContext innerContext;
  // final bool isFromVisitorHistory;

  @override
  Widget build(BuildContext context) {
    return StatisticsBlocSelector(
      selector: (state) => state.statisticsVisitorApi.isApiInProgress,
      builder: (inProgress) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // if (isFromVisitorHistory)
            //   Container(
            //     width: 52.w,
            //     height: 6.h,
            //     padding: const EdgeInsets.only(left: 25),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(40),
            //       color: CommonFunctions.getReverseThemeBasedWidgetColor(
            //         context,
            //       ),
            //     ),
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       bloc.getSelectedDropDownTitle(
            //         context,
            //         selectedDropDownValue,
            //       ),
            //       style: Theme.of(context).textTheme.titleLarge?.copyWith(
            //             fontSize: 14,
            //             fontWeight: FontWeight.bold,
            //             color: CommonFunctions.getThemeBasedWidgetColor(
            //               context,
            //             ),
            //           ),
            //     ),
            //   )
            // else
            Showcase.withWidget(
              key: bloc.statisticsDropdownGuideKey,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              tooltipPosition: TooltipPosition.bottom,
              container: StatisticsDropdownGuide(
                innerContext: innerContext,
                bloc: bloc,
              ),
              targetBorderRadius: BorderRadius.circular(40),
              child: AbsorbPointer(
                absorbing: inProgress,
                child: AppDropDownButton(
                  items: bloc.state.dropDownItems,
                  selectedValue: selectedDropDownValue,
                  onChanged: (value) {
                    if (!inProgress) {
                      if (value != selectedDropDownValue) {
                        bloc.updateSelectedDropDownValue(
                          value ?? Constants.peakVisitorsHourKey,
                        );
                        if (value == Constants.peakVisitorsHourKey ||
                            value == Constants.frequencyOfVisitsKey) {
                          bloc.updateSelectedTimeInterval(
                            FiltersModel(
                              title: "This Week",
                              value: "this_week",
                              isSelected: true,
                            ),
                          );
                          StatisticsFiltersWidget.clearTimeIntervals();
                          StatisticsFiltersWidget
                              .timeIntervalFilters[0].isSelected = true;
                          bloc.scrollToIndex(0, context);
                        } else {
                          bloc.updateSelectedTimeInterval(
                            FiltersModel(
                              title: "custom",
                              value: DateFormat('dd-MM-yyyy')
                                  .format(DateTime.now().toLocal()),
                              value2: DateFormat('dd-MM-yyyy')
                                  .format(DateTime.now().toLocal()),
                              isSelected: true,
                            ),
                          );
                        }
                        bloc.callStatistics();
                      }
                    }
                  },
                  displayDropDownItems: (item) =>
                      bloc.getSelectedDropDownTitle(context, item),
                  buttonHeight: 4.h,
                  dropdownRadius: 5,
                  expandedDropdownRadius: 5,
                  dropDownWidth: 55.w,
                  dropDownHeight: 22.h,
                ),
              ),
            ),
            Showcase.withWidget(
              key: bloc.statisticsCalendarGuideKey,
              targetPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              // targetBorderRadius: BorderRadius.circular(25),
              container: StatisticsCalendarGuide(
                innerContext: innerContext,
                bloc: bloc,
              ),
              child: CustomGradientButton(
                forDialog: true,
                customHeight: 4.h,
                suffix: Icon(
                  MdiIcons.calendarOutline,
                  size: 18,
                  color: Colors.white,
                ),
                customCircularRadius: 5,
                onSubmit: () async {
                  if (!inProgress) {
                    if (selectedDropDownValue == bloc.state.dropDownItems[1] ||
                        selectedDropDownValue == bloc.state.dropDownItems[3]) {
                      final result = await showCustomDatePicker(
                        context: context,
                        calenderType: CalendarDatePicker2Type.range,
                        value: [
                          CommonFunctions.getDateTime(
                            dateString: bloc.state.selectedTimeInterval.value ??
                                DateFormat('dd-MM-yyyy')
                                    .format(DateTime.now().toLocal()),
                          ),
                          CommonFunctions.getDateTime(
                            dateString:
                                bloc.state.selectedTimeInterval.value2 ??
                                    DateFormat('dd-MM-yyyy')
                                        .format(DateTime.now().toLocal()),
                          ),
                        ],
                      );
                      if (result != null) {
                        // final List<DateTime> lastSelectedDates =
                        //     CommonFunctions.getWeekStartAndEndDatesList(
                        //   bloc.state.selectedTimeInterval.value!,
                        // );
                        // final List<DateTime> newDates =
                        //     CommonFunctions.getWeekStartAndEndDatesList(
                        //   DateFormat('dd-MM-yyyy')
                        //       .format(result[0] as DateTime),
                        // );
                        // if (lastSelectedDates[0] != newDates[0] &&
                        //     lastSelectedDates[1] != newDates[1]) {
                        bloc.updateSelectedTimeInterval(
                          FiltersModel(
                            title: "custom",
                            value: DateFormat('dd-MM-yyyy')
                                .format(result[0] as DateTime),
                            value2: DateFormat('dd-MM-yyyy').format(
                              (result.length > 1 ? result[1] : result[0])
                                  as DateTime,
                            ),
                            isSelected: true,
                          ),
                        );
                        await bloc.callStatistics();
                        // }
                      }
                    }
                  }
                },
                isButtonEnabled:
                    selectedDropDownValue == bloc.state.dropDownItems[1] ||
                        selectedDropDownValue == bloc.state.dropDownItems[3],
                label: context.appLocalizations.calendar,
                customButtonFontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }
}
