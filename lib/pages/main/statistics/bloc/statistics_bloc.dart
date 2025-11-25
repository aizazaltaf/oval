import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/statistics_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/dashboard/view_model/filters_model.dart';
import 'package:admin/pages/main/statistics/bloc/statistics_state.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'statistics_bloc.bloc.g.dart';

final _logger = Logger("statistics_bloc.dart");

@BlocGen()
class StatisticsBloc extends BVCubit<StatisticsState, StatisticsStateBuilder>
    with _StatisticsBlocMixin {
  StatisticsBloc() : super(StatisticsState());

  factory StatisticsBloc.of(final BuildContext context) =>
      BlocProvider.of<StatisticsBloc>(context);

  //Guides Global keys
  final statisticsDropdownGuideKey = GlobalKey();
  final statisticsChipsGuideKey = GlobalKey();
  final statisticsCalendarGuideKey = GlobalKey();
  final ScrollController statisticsFilterScrollController = ScrollController();

  double animate(index, context, targetOffset) {
    const int length = 4;
    if (index == 0 || index == 1) {
      return statisticsFilterScrollController.position.minScrollExtent;
    } else if (index == length - 1 || index == length - 2) {
      return statisticsFilterScrollController.position.maxScrollExtent;
    }
    return targetOffset;
  }

  void scrollToIndex(int index, context) {
    if (!statisticsFilterScrollController.hasClients) {
      return;
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double centerOffset = (screenWidth - 90) / 2; // Center position
    final double targetOffset = (index * 90) - centerOffset;

    statisticsFilterScrollController.animateTo(
      animate(index, context, targetOffset),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  // void voiceControlEmit(VoiceControlModel model) {
  //   emit(
  //     state.rebuild(
  //       (b) => b
  //         ..filter = true
  //         ..dateFilters.replace([
  //           FiltersModel(
  //             isSelected: model.notifications!.today ?? false,
  //             title: Constants.today,
  //             value: "today",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.yesterday ?? false,
  //             title: Constants.yesterday,
  //             value: "yesterday",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.thisWeek ?? false,
  //             title: Constants.thisWeek,
  //             value: "this_week",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.thisMonth ?? false,
  //             title: Constants.thisMonth,
  //             value: "this_month",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.lastWeek ?? false,
  //             title: Constants.lastWeek,
  //             value: "last_week",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.lastMonth ?? false,
  //             title: Constants.lastMonth,
  //             value: "last_month",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.customDate ?? false,
  //             title: Constants.custom,
  //             value: "custom",
  //           ),
  //         ])
  //         ..aiAlertsFilters.replace([
  //           FiltersModel(
  //             isSelected: model.notifications!.subscriptionAlerts ?? false,
  //             title: Constants.subscriptionAlerts,
  //             value: "payment,subscription,credit,reminder,subscribe",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.spamAlerts ?? false,
  //             title: Constants.spamAlerts,
  //             value: "spam",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.neighbourhoodAlerts ?? false,
  //             title: Constants.neighbourhoodAlerts,
  //             value: "request,watch",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.doorbellAlerts ?? false,
  //             title: Constants.doorbellAlerts,
  //             value:
  //                 "wifi,doorbell,location,power,shutdown,voicemail,battery,subscription,interruption",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.iotAlerts ?? false,
  //             title: Constants.ioTAlerts,
  //             value: "fire,gas,movement,motion,monitoring,door lock,flashlight",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.aiAlerts ?? false,
  //             title: Constants.aIAlerts,
  //             value: "",
  //           ),
  //         ])
  //         ..aiAlertsSubFilters.replace([
  //           FiltersModel(
  //             isSelected: model.notifications!.visitorAlert ?? false,
  //             title: Constants.visitorAlert,
  //             value: "visitor,unwanted,a new",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.babyRunningAway ?? false,
  //             title: Constants.babyRunningAway,
  //             value: "baby",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.petRunningAway ?? false,
  //             title: Constants.petRunningAway,
  //             value: "pet",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.fireAlert ?? false,
  //             title: Constants.fireAlert,
  //             value: "fire",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.intruderAlert ?? false,
  //             title: Constants.intruderAlert,
  //             value: "intruder",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.weapon ?? false,
  //             title: Constants.weapon,
  //             value: "weapon",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.parcelAlert ?? false,
  //             title: Constants.parcelAlert,
  //             value: "parcel",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.eavesdropper ?? false,
  //             title: Constants.eavesdropper,
  //             value: "eavesdropper",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.dogPoop ?? false,
  //             title: Constants.dogPoop,
  //             value: "poop",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.humanFall ?? false,
  //             title: Constants.humanFall,
  //             value: "human",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.boundaryBreach ?? false,
  //             title: Constants.boundaryBreach,
  //             value: "boundary",
  //           ),
  //           FiltersModel(
  //             isSelected: model.notifications!.drowningAlert ?? false,
  //             title: Constants.drowningAlert,
  //             value: "drowning",
  //           ),
  //         ]),
  //     ),
  //   );
  // }

  GlobalKey getCurrentGuide() {
    switch (state.currentGuideKey) {
      case "chips":
        return statisticsChipsGuideKey;

      case "calendar":
        return statisticsCalendarGuideKey;

      default:
        return statisticsDropdownGuideKey;
    }
  }

  String getSelectedDropDownTitle(BuildContext context, String dropDownValue) {
    switch (dropDownValue) {
      case Constants.peakVisitorsHourKey:
        return context.appLocalizations.peak_visiting_hours;

      case Constants.daysOfWeekKey:
        return context.appLocalizations.days_of_the_week;

      case Constants.frequencyOfVisitsKey:
        return context.appLocalizations.frequency_of_visits;

      default:
        return context.appLocalizations.unknown_visitors;
    }
  }

  Future<void> callIndividualVisitorStats({required String visitorId}) {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.statisticsVisitorApi,
      updateApiState: (final b, final apiState) =>
          b.statisticsVisitorApi.replace(apiState),
      callApi: () async {
        final BuiltList<StatisticsModel> individualStatsResponse =
            await apiService.getIndividualVisitorStats(
          visitorId: visitorId,
          timeInterval: state.selectedTimeInterval.value,
        );
        updateStatisticsList(individualStatsResponse);
      },
    );
  }

  Future<void> callStatistics() {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.statisticsVisitorApi,
      updateApiState: (final b, final apiState) =>
          b.statisticsVisitorApi.replace(apiState),
      onError: (e) {
        _logger.fine(e.toString());
      },
      callApi: () async {
        final BuiltList<StatisticsModel> statisticsResponse =
            await apiService.getStatistics(
          dropDownValue: state.selectedDropDownValue,
          timeInterval:
              (state.selectedDropDownValue == state.dropDownItems[1] ||
                      state.selectedDropDownValue == state.dropDownItems[3])
                  ? "custom"
                  : state.selectedTimeInterval.value!,
          startDate: (state.selectedDropDownValue == state.dropDownItems[1] ||
                  state.selectedDropDownValue == state.dropDownItems[3])
              ? state.selectedTimeInterval.value
              : null,
          endDate: (state.selectedDropDownValue == state.dropDownItems[1] ||
                  state.selectedDropDownValue == state.dropDownItems[3])
              ? state.selectedTimeInterval.value2
              : null,
        );
        updateStatisticsList(statisticsResponse);
      },
    );
  }
}
