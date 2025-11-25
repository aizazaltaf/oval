// ignore_for_file: type=lint, unused_element

part of 'statistics_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class StatisticsBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<StatisticsState>? buildWhen;
  final BlocWidgetBuilder<StatisticsState> builder;

  const StatisticsBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<StatisticsBloc, StatisticsState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class StatisticsBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<StatisticsState, T> selector;
  final Widget Function(T state) builder;
  final StatisticsBloc? bloc;

  const StatisticsBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static StatisticsBlocSelector<String> selectedDropDownValue({
    final Key? key,
    required Widget Function(String selectedDropDownValue) builder,
    final StatisticsBloc? bloc,
  }) {
    return StatisticsBlocSelector(
      key: key,
      selector: (state) => state.selectedDropDownValue,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StatisticsBlocSelector<FiltersModel> selectedTimeInterval({
    final Key? key,
    required Widget Function(FiltersModel selectedTimeInterval) builder,
    final StatisticsBloc? bloc,
  }) {
    return StatisticsBlocSelector(
      key: key,
      selector: (state) => state.selectedTimeInterval,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StatisticsBlocSelector<bool> statisticsGuideShow({
    final Key? key,
    required Widget Function(bool statisticsGuideShow) builder,
    final StatisticsBloc? bloc,
  }) {
    return StatisticsBlocSelector(
      key: key,
      selector: (state) => state.statisticsGuideShow,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StatisticsBlocSelector<String> currentGuideKey({
    final Key? key,
    required Widget Function(String currentGuideKey) builder,
    final StatisticsBloc? bloc,
  }) {
    return StatisticsBlocSelector(
      key: key,
      selector: (state) => state.currentGuideKey,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StatisticsBlocSelector<BuiltList<StatisticsModel>> statisticsList({
    final Key? key,
    required Widget Function(BuiltList<StatisticsModel> statisticsList) builder,
    final StatisticsBloc? bloc,
  }) {
    return StatisticsBlocSelector(
      key: key,
      selector: (state) => state.statisticsList,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StatisticsBlocSelector<BuiltList<String>> dropDownItems({
    final Key? key,
    required Widget Function(BuiltList<String> dropDownItems) builder,
    final StatisticsBloc? bloc,
  }) {
    return StatisticsBlocSelector(
      key: key,
      selector: (state) => state.dropDownItems,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StatisticsBlocSelector<ApiState<void>> statisticsVisitorApi({
    final Key? key,
    required Widget Function(ApiState<void> statisticsVisitorApi) builder,
    final StatisticsBloc? bloc,
  }) {
    return StatisticsBlocSelector(
      key: key,
      selector: (state) => state.statisticsVisitorApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<StatisticsBloc, StatisticsState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _StatisticsBlocMixin on Cubit<StatisticsState> {
  @mustCallSuper
  void updateSelectedDropDownValue(final String selectedDropDownValue) {
    if (this.state.selectedDropDownValue == selectedDropDownValue) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.selectedDropDownValue = selectedDropDownValue));

    $onUpdateSelectedDropDownValue();
  }

  @protected
  void $onUpdateSelectedDropDownValue() {}

  @mustCallSuper
  void updateSelectedTimeInterval(final FiltersModel selectedTimeInterval) {
    if (this.state.selectedTimeInterval == selectedTimeInterval) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.selectedTimeInterval = selectedTimeInterval));

    $onUpdateSelectedTimeInterval();
  }

  @protected
  void $onUpdateSelectedTimeInterval() {}

  @mustCallSuper
  void updateStatisticsGuideShow(final bool statisticsGuideShow) {
    if (this.state.statisticsGuideShow == statisticsGuideShow) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.statisticsGuideShow = statisticsGuideShow));

    $onUpdateStatisticsGuideShow();
  }

  @protected
  void $onUpdateStatisticsGuideShow() {}

  @mustCallSuper
  void updateCurrentGuideKey(final String currentGuideKey) {
    if (this.state.currentGuideKey == currentGuideKey) {
      return;
    }

    emit(this.state.rebuild((final b) => b.currentGuideKey = currentGuideKey));

    $onUpdateCurrentGuideKey();
  }

  @protected
  void $onUpdateCurrentGuideKey() {}

  @mustCallSuper
  void updateStatisticsList(final BuiltList<StatisticsModel> statisticsList) {
    if (this.state.statisticsList == statisticsList) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.statisticsList.replace(statisticsList);
    }));

    $onUpdateStatisticsList();
  }

  @protected
  void $onUpdateStatisticsList() {}

  @mustCallSuper
  void updateDropDownItems(final BuiltList<String> dropDownItems) {
    if (this.state.dropDownItems == dropDownItems) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.dropDownItems.replace(dropDownItems);
    }));

    $onUpdateDropDownItems();
  }

  @protected
  void $onUpdateDropDownItems() {}
}
