// ignore_for_file: type=lint, unused_element

part of 'visitor_management_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class VisitorManagementBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<VisitorManagementState>? buildWhen;
  final BlocWidgetBuilder<VisitorManagementState> builder;

  const VisitorManagementBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<VisitorManagementBloc, VisitorManagementState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class VisitorManagementBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<VisitorManagementState, T> selector;
  final Widget Function(T state) builder;
  final VisitorManagementBloc? bloc;

  const VisitorManagementBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static VisitorManagementBlocSelector<String?> search({
    final Key? key,
    required Widget Function(String? search) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.search,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<String?> filterValue({
    final Key? key,
    required Widget Function(String? filterValue) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.filterValue,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<bool> visitHistoryFirstBool({
    final Key? key,
    required Widget Function(bool visitHistoryFirstBool) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.visitHistoryFirstBool,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<String?> visitorHistorySelectedFilter({
    final Key? key,
    required Widget Function(String? visitorHistorySelectedFilter) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.visitorHistorySelectedFilter,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<bool> visitorGuideShow({
    final Key? key,
    required Widget Function(bool visitorGuideShow) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.visitorGuideShow,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<bool> historyGuideShow({
    final Key? key,
    required Widget Function(bool historyGuideShow) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.historyGuideShow,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<String> currentGuideKey({
    final Key? key,
    required Widget Function(String currentGuideKey) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.currentGuideKey,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<bool> visitorNewNotification({
    final Key? key,
    required Widget Function(bool visitorNewNotification) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.visitorNewNotification,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<bool> visitorNameSaveButtonEnabled({
    final Key? key,
    required Widget Function(bool visitorNameSaveButtonEnabled) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.visitorNameSaveButtonEnabled,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<String?> historyFilterValue({
    final Key? key,
    required Widget Function(String? historyFilterValue) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.historyFilterValue,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<String> visitorName({
    final Key? key,
    required Widget Function(String visitorName) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.visitorName,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<BuiltList<String>?>
      deleteVisitorHistoryIdsList({
    final Key? key,
    required Widget Function(BuiltList<String>? deleteVisitorHistoryIdsList)
        builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.deleteVisitorHistoryIdsList,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<VisitorsModel?> selectedVisitor({
    final Key? key,
    required Widget Function(VisitorsModel? selectedVisitor) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.selectedVisitor,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<BuiltList<StatisticsModel>>
      statisticsList({
    final Key? key,
    required Widget Function(BuiltList<StatisticsModel> statisticsList) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.statisticsList,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<SuperTooltipController>
      superToolTipController({
    final Key? key,
    required Widget Function(SuperTooltipController superToolTipController)
        builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.superToolTipController,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<ApiState<PaginatedData<VisitorsModel>>>
      visitorManagementApi({
    final Key? key,
    required Widget Function(
            ApiState<PaginatedData<VisitorsModel>> visitorManagementApi)
        builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.visitorManagementApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<ApiState<PaginatedData<VisitModel>>>
      visitorHistoryApi({
    final Key? key,
    required Widget Function(
            ApiState<PaginatedData<VisitModel>> visitorHistoryApi)
        builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.visitorHistoryApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<ApiState<void>>
      visitorManagementDeleteApi({
    final Key? key,
    required Widget Function(ApiState<void> visitorManagementDeleteApi) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.visitorManagementDeleteApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<ApiState<void>> visitorHistoryDeleteApi({
    final Key? key,
    required Widget Function(ApiState<void> visitorHistoryDeleteApi) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.visitorHistoryDeleteApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<ApiState<void>>
      markWantedOrUnwantedVisitorApi({
    final Key? key,
    required Widget Function(ApiState<void> markWantedOrUnwantedVisitorApi)
        builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.markWantedOrUnwantedVisitorApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<ApiState<void>> editVisitorNameApi({
    final Key? key,
    required Widget Function(ApiState<void> editVisitorNameApi) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.editVisitorNameApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VisitorManagementBlocSelector<ApiState<void>> statisticsVisitorApi({
    final Key? key,
    required Widget Function(ApiState<void> statisticsVisitorApi) builder,
    final VisitorManagementBloc? bloc,
  }) {
    return VisitorManagementBlocSelector(
      key: key,
      selector: (state) => state.statisticsVisitorApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<VisitorManagementBloc, VisitorManagementState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _VisitorManagementBlocMixin on Cubit<VisitorManagementState> {
  @mustCallSuper
  void updateSearch(final String? search) {
    if (this.state.search == search) {
      return;
    }

    emit(this.state.rebuild((final b) => b.search = search));

    $onUpdateSearch();
  }

  @protected
  void $onUpdateSearch() {}

  @mustCallSuper
  void updateFilterValue(final String? filterValue) {
    if (this.state.filterValue == filterValue) {
      return;
    }

    emit(this.state.rebuild((final b) => b.filterValue = filterValue));

    $onUpdateFilterValue();
  }

  @protected
  void $onUpdateFilterValue() {}

  @mustCallSuper
  void updateVisitHistoryFirstBool(final bool visitHistoryFirstBool) {
    if (this.state.visitHistoryFirstBool == visitHistoryFirstBool) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.visitHistoryFirstBool = visitHistoryFirstBool));

    $onUpdateVisitHistoryFirstBool();
  }

  @protected
  void $onUpdateVisitHistoryFirstBool() {}

  @mustCallSuper
  void updateVisitorHistorySelectedFilter(
      final String? visitorHistorySelectedFilter) {
    if (this.state.visitorHistorySelectedFilter ==
        visitorHistorySelectedFilter) {
      return;
    }

    emit(this.state.rebuild((final b) =>
        b.visitorHistorySelectedFilter = visitorHistorySelectedFilter));

    $onUpdateVisitorHistorySelectedFilter();
  }

  @protected
  void $onUpdateVisitorHistorySelectedFilter() {}

  @mustCallSuper
  void updateVisitorGuideShow(final bool visitorGuideShow) {
    if (this.state.visitorGuideShow == visitorGuideShow) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.visitorGuideShow = visitorGuideShow));

    $onUpdateVisitorGuideShow();
  }

  @protected
  void $onUpdateVisitorGuideShow() {}

  @mustCallSuper
  void updateHistoryGuideShow(final bool historyGuideShow) {
    if (this.state.historyGuideShow == historyGuideShow) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.historyGuideShow = historyGuideShow));

    $onUpdateHistoryGuideShow();
  }

  @protected
  void $onUpdateHistoryGuideShow() {}

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
  void updateVisitorNewNotification(final bool visitorNewNotification) {
    if (this.state.visitorNewNotification == visitorNewNotification) {
      return;
    }

    emit(this.state.rebuild(
        (final b) => b.visitorNewNotification = visitorNewNotification));

    $onUpdateVisitorNewNotification();
  }

  @protected
  void $onUpdateVisitorNewNotification() {}

  @mustCallSuper
  void updateVisitorNameSaveButtonEnabled(
      final bool visitorNameSaveButtonEnabled) {
    if (this.state.visitorNameSaveButtonEnabled ==
        visitorNameSaveButtonEnabled) {
      return;
    }

    emit(this.state.rebuild((final b) =>
        b.visitorNameSaveButtonEnabled = visitorNameSaveButtonEnabled));

    $onUpdateVisitorNameSaveButtonEnabled();
  }

  @protected
  void $onUpdateVisitorNameSaveButtonEnabled() {}

  @mustCallSuper
  void updateHistoryFilterValue(final String? historyFilterValue) {
    if (this.state.historyFilterValue == historyFilterValue) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.historyFilterValue = historyFilterValue));

    $onUpdateHistoryFilterValue();
  }

  @protected
  void $onUpdateHistoryFilterValue() {}

  @mustCallSuper
  void updateVisitorName(final String visitorName) {
    if (this.state.visitorName == visitorName) {
      return;
    }

    emit(this.state.rebuild((final b) => b.visitorName = visitorName));

    $onUpdateVisitorName();
  }

  @protected
  void $onUpdateVisitorName() {}

  @mustCallSuper
  void updateDeleteVisitorHistoryIdsList(
      final BuiltList<String>? deleteVisitorHistoryIdsList) {
    if (this.state.deleteVisitorHistoryIdsList == deleteVisitorHistoryIdsList) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (deleteVisitorHistoryIdsList == null)
        b.deleteVisitorHistoryIdsList = null;
      else
        b.deleteVisitorHistoryIdsList.replace(deleteVisitorHistoryIdsList);
    }));

    $onUpdateDeleteVisitorHistoryIdsList();
  }

  @protected
  void $onUpdateDeleteVisitorHistoryIdsList() {}

  @mustCallSuper
  void updateSelectedVisitor(final VisitorsModel? selectedVisitor) {
    if (this.state.selectedVisitor == selectedVisitor) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (selectedVisitor == null)
        b.selectedVisitor = null;
      else
        b.selectedVisitor.replace(selectedVisitor);
    }));

    $onUpdateSelectedVisitor();
  }

  @protected
  void $onUpdateSelectedVisitor() {}

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
}
