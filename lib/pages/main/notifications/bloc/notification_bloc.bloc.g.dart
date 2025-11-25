// ignore_for_file: type=lint, unused_element

part of 'notification_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class NotificationBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<NotificationState>? buildWhen;
  final BlocWidgetBuilder<NotificationState> builder;

  const NotificationBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class NotificationBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<NotificationState, T> selector;
  final Widget Function(T state) builder;
  final NotificationBloc? bloc;

  const NotificationBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static NotificationBlocSelector<BuiltList<FeatureModel>> dateFilters({
    final Key? key,
    required Widget Function(BuiltList<FeatureModel> dateFilters) builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.dateFilters,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static NotificationBlocSelector<BuiltList<FeatureModel>> aiAlertsFilters({
    final Key? key,
    required Widget Function(BuiltList<FeatureModel> aiAlertsFilters) builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.aiAlertsFilters,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static NotificationBlocSelector<BuiltList<FeatureModel>> aiAlertsSubFilters({
    final Key? key,
    required Widget Function(BuiltList<FeatureModel> aiAlertsSubFilters)
        builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.aiAlertsSubFilters,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static NotificationBlocSelector<BuiltList<FeatureModel>> deviceFilters({
    final Key? key,
    required Widget Function(BuiltList<FeatureModel> deviceFilters) builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.deviceFilters,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static NotificationBlocSelector<bool> notificationGuideShow({
    final Key? key,
    required Widget Function(bool notificationGuideShow) builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.notificationGuideShow,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static NotificationBlocSelector<String> currentGuideKey({
    final Key? key,
    required Widget Function(String currentGuideKey) builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.currentGuideKey,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static NotificationBlocSelector<String> noDeviceAvailable({
    final Key? key,
    required Widget Function(String noDeviceAvailable) builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.noDeviceAvailable,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static NotificationBlocSelector<DateTime?> customDate({
    final Key? key,
    required Widget Function(DateTime? customDate) builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.customDate,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static NotificationBlocSelector<bool> filter({
    final Key? key,
    required Widget Function(bool filter) builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.filter,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static NotificationBlocSelector<bool> newNotification({
    final Key? key,
    required Widget Function(bool newNotification) builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.newNotification,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static NotificationBlocSelector<String> filterParam({
    final Key? key,
    required Widget Function(String filterParam) builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.filterParam,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static NotificationBlocSelector<String> deviceId({
    final Key? key,
    required Widget Function(String deviceId) builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.deviceId,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static NotificationBlocSelector<ApiState<PaginatedData<NotificationData>>>
      notificationApi({
    final Key? key,
    required Widget Function(
            ApiState<PaginatedData<NotificationData>> notificationApi)
        builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.notificationApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static NotificationBlocSelector<ApiState<void>> updateDoorbellSchedule({
    final Key? key,
    required Widget Function(ApiState<void> updateDoorbellSchedule) builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.updateDoorbellSchedule,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static NotificationBlocSelector<ApiState<PaginatedData<NotificationData>>>
      unReadNotificationApi({
    final Key? key,
    required Widget Function(
            ApiState<PaginatedData<NotificationData>> unReadNotificationApi)
        builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.unReadNotificationApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static NotificationBlocSelector<Map<String, bool>?> notificationDeviceStatus({
    final Key? key,
    required Widget Function(Map<String, bool>? notificationDeviceStatus)
        builder,
    final NotificationBloc? bloc,
  }) {
    return NotificationBlocSelector(
      key: key,
      selector: (state) => state.notificationDeviceStatus,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<NotificationBloc, NotificationState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _NotificationBlocMixin on Cubit<NotificationState> {
  @mustCallSuper
  void updateNotificationGuideShow(final bool notificationGuideShow) {
    if (this.state.notificationGuideShow == notificationGuideShow) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.notificationGuideShow = notificationGuideShow));

    $onUpdateNotificationGuideShow();
  }

  @protected
  void $onUpdateNotificationGuideShow() {}

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
  void updateNoDeviceAvailable(final String noDeviceAvailable) {
    if (this.state.noDeviceAvailable == noDeviceAvailable) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.noDeviceAvailable = noDeviceAvailable));

    $onUpdateNoDeviceAvailable();
  }

  @protected
  void $onUpdateNoDeviceAvailable() {}

  @mustCallSuper
  void updateCustomDate(final DateTime? customDate) {
    if (this.state.customDate == customDate) {
      return;
    }

    emit(this.state.rebuild((final b) => b.customDate = customDate));

    $onUpdateCustomDate();
  }

  @protected
  void $onUpdateCustomDate() {}

  @mustCallSuper
  void updateFilter(final bool filter) {
    if (this.state.filter == filter) {
      return;
    }

    emit(this.state.rebuild((final b) => b.filter = filter));

    $onUpdateFilter();
  }

  @protected
  void $onUpdateFilter() {}

  @mustCallSuper
  void updateNewNotification(final bool newNotification) {
    if (this.state.newNotification == newNotification) {
      return;
    }

    emit(this.state.rebuild((final b) => b.newNotification = newNotification));

    $onUpdateNewNotification();
  }

  @protected
  void $onUpdateNewNotification() {}

  @mustCallSuper
  void updateFilterParam(final String filterParam) {
    if (this.state.filterParam == filterParam) {
      return;
    }

    emit(this.state.rebuild((final b) => b.filterParam = filterParam));

    $onUpdateFilterParam();
  }

  @protected
  void $onUpdateFilterParam() {}

  @mustCallSuper
  void updateDeviceId(final String deviceId) {
    if (this.state.deviceId == deviceId) {
      return;
    }

    emit(this.state.rebuild((final b) => b.deviceId = deviceId));

    $onUpdateDeviceId();
  }

  @protected
  void $onUpdateDeviceId() {}
}
