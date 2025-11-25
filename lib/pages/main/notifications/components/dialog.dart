import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/custom_checkbox_list_tile.dart';
import 'package:admin/widgets/custom_date_picker.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog(this.filterType, this.bloc, {super.key});

  final String filterType;
  final NotificationBloc bloc;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: CommonFunctions.getThemeBasedWidgetColor(context),
        );
    return Dialog(
      child: BlocProvider.value(
        value: bloc,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 10, right: 20),
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.cancel,
                    color: AppColors.darkBluePrimaryColor,
                    size: 26,
                  ),
                ),
              ),
              Text(
                filterType,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                color: AppColors.descriptionGreyColor,
                thickness: 2,
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    NotificationBlocSelector(
                      selector: (state) {
                        if (filterType == context.appLocalizations.by_date) {
                          return state.dateFilters;
                        } else if (filterType ==
                            context.appLocalizations.by_alert) {
                          return state.aiAlertsFilters;
                        }
                        return state.deviceFilters;
                      },
                      builder: (list) {
                        return GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: list.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                filterType == context.appLocalizations.by_alert
                                    ? 1
                                    : 2,
                            childAspectRatio: filterType ==
                                    context.appLocalizations.by_alert
                                ? MediaQuery.of(context).size.shortestSide < 600
                                    ? 8
                                    : 10
                                : MediaQuery.of(context).size.shortestSide < 600
                                    ? filterType ==
                                            context.appLocalizations.by_device
                                        ? 1.6
                                        : 3.5
                                    : 5,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CustomCheckboxListTile(
                              value: list[index].isSelected,
                              radio: filterType !=
                                  context.appLocalizations.by_alert,
                              onChanged: (isChecked) {
                                if (filterType ==
                                    context.appLocalizations.by_date) {
                                  bloc.updateDateFilter(
                                    index,
                                    isChecked ?? false,
                                  );
                                } else if (filterType ==
                                    context.appLocalizations.by_alert) {
                                  bloc.updateAiFilter(
                                    index,
                                    isChecked ?? false,
                                  );
                                } else {
                                  bloc.updateDevicesFilter(
                                    index,
                                    isChecked ?? false,
                                  );
                                }
                              },
                              style: textStyle,
                              title: filterType ==
                                      context.appLocalizations.by_device
                                  ? list[index].title
                                  : list[index].title.capitalizeFirstOfEach(),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    NotificationBlocSelector.dateFilters(
                      builder: (list) {
                        if (filterType == context.appLocalizations.by_date &&
                            bloc.state.dateFilters.last.isSelected) {
                          if (bloc.state.customDate == null) {
                            bloc.updateCustomDate(DateTime.now());
                          }

                          return IntrinsicHeight(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                textTheme: Theme.of(context).textTheme.copyWith(
                                      displayMedium:
                                          Theme.of(context).textTheme.bodyLarge,
                                      bodyLarge:
                                          Theme.of(context).textTheme.bodyLarge,
                                      bodyMedium:
                                          Theme.of(context).textTheme.bodyLarge,
                                      bodySmall:
                                          Theme.of(context).textTheme.bodyLarge,
                                      displaySmall:
                                          Theme.of(context).textTheme.bodyLarge,
                                      headlineLarge:
                                          Theme.of(context).textTheme.bodyLarge,
                                      headlineMedium:
                                          Theme.of(context).textTheme.bodyLarge,
                                      headlineSmall:
                                          Theme.of(context).textTheme.bodyLarge,
                                      titleMedium:
                                          Theme.of(context).textTheme.bodyLarge,
                                      titleSmall:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                              ),
                              child: CalendarDatePicker2(
                                config: calendarConfigurations(context),
                                onValueChanged: (val) {
                                  bloc.updateCustomDate(val.first);
                                },
                                value: [
                                  bloc.state.customDate ?? DateTime.now(),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    NotificationBlocSelector.aiAlertsFilters(
                      builder: (list) {
                        if (filterType == context.appLocalizations.by_alert &&
                            (bloc.state.aiAlertsFilters.last.isSelected ||
                                bloc.state.aiAlertsSubFilters
                                    .any((t) => t.isSelected))) {
                          return NotificationBlocSelector(
                            selector: (state) {
                              return state.aiAlertsSubFilters;
                            },
                            builder: (list) {
                              return Flexible(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: list.length,
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: MediaQuery.of(context)
                                                .size
                                                .shortestSide <
                                            600
                                        ? 3
                                        : 5,
                                  ),
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return CustomCheckboxListTile(
                                      value: list[index].isSelected,
                                      onChanged: (isChecked) {
                                        bloc.updateAiSubFilter(
                                          index,
                                          isChecked ?? false,
                                        );
                                      },
                                      style: textStyle,
                                      title: list[index]
                                          .title
                                          .capitalizeFirstOfEach(),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    SizedBox(height: 3.h),
                    Column(
                      children: [
                        NotificationBlocSelector(
                          selector: (state) {
                            if (filterType ==
                                context.appLocalizations.by_date) {
                              return state.dateFilters;
                            } else if (filterType ==
                                context.appLocalizations.by_alert) {
                              final combinedList =
                                  (state.aiAlertsFilters.toBuilder()
                                        ..addAll(state.aiAlertsSubFilters))
                                      .build();
                              return combinedList;
                            }
                            return state.deviceFilters;
                          },
                          builder: (list) {
                            final bool isEnabled = list.any(
                              (item) => item.isSelected,
                            ); // Check if any item is true

                            return NotificationBlocSelector(
                              selector: (final state) =>
                                  state.notificationApi.isApiInProgress,
                              builder: (final isNotificationApiInProgress) =>
                                  CustomGradientButton(
                                isButtonEnabled: isEnabled,
                                onSubmit: () {
                                  bloc
                                    ..updateFilter(true)
                                    ..updateNoDeviceAvailable("")
                                    ..callNotificationApi();
                                  Navigator.pop(context);
                                },
                                label: context.appLocalizations.apply,
                                isLoadingEnabled: isNotificationApiInProgress,
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomCancelButton(
                          onSubmit: bloc.resetFiltersWithoutFilterParam,
                          customWidth: 100.w,
                          label: context.appLocalizations.clear,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CalendarDatePicker2Config calendarConfigurations(BuildContext context) {
    logger.fine(bloc.state.customDate);
    return CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.single,
      calendarViewMode: CalendarDatePicker2Mode.day,
      daySplashColor: Colors.transparent,
      allowSameValueSelection: false,
      selectedRangeHighlightColor: AppColors.appBlue.withValues(alpha: 0.2),
      centerAlignModePicker: true,
      firstDate: DateTime(DateTime.now().year, DateTime.now().month),
      currentDate: bloc.state.customDate ?? DateTime.now(),
      disableModePicker: true,
      lastMonthIcon: calendarArrowIcon(
        context,
        icon: Icons.keyboard_arrow_left,
      ),
      nextMonthIcon: calendarArrowIcon(
        context,
        icon: Icons.keyboard_arrow_right,
      ),
      dynamicCalendarRows: true,
      selectedDayHighlightColor: AppColors.darkPrimaryColor,
      lastDate: DateTime.now(),
    );
  }
}
