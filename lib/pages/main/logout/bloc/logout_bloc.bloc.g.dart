// ignore_for_file: type=lint, unused_element

part of 'logout_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class LogoutBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<LogoutState>? buildWhen;
  final BlocWidgetBuilder<LogoutState> builder;

  const LogoutBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<LogoutBloc, LogoutState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class LogoutBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<LogoutState, T> selector;
  final Widget Function(T state) builder;
  final LogoutBloc? bloc;

  const LogoutBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static LogoutBlocSelector<String> currentDeviceToken({
    final Key? key,
    required Widget Function(String currentDeviceToken) builder,
    final LogoutBloc? bloc,
  }) {
    return LogoutBlocSelector(
      key: key,
      selector: (state) => state.currentDeviceToken,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LogoutBlocSelector<BuiltList<LoginSessionModel>?> loginActivities({
    final Key? key,
    required Widget Function(BuiltList<LoginSessionModel>? loginActivities)
        builder,
    final LogoutBloc? bloc,
  }) {
    return LogoutBlocSelector(
      key: key,
      selector: (state) => state.loginActivities,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LogoutBlocSelector<ApiState<void>> loginActivityApi({
    final Key? key,
    required Widget Function(ApiState<void> loginActivityApi) builder,
    final LogoutBloc? bloc,
  }) {
    return LogoutBlocSelector(
      key: key,
      selector: (state) => state.loginActivityApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LogoutBlocSelector<ApiState<void>> logoutOfSpecificDeviceApi({
    final Key? key,
    required Widget Function(ApiState<void> logoutOfSpecificDeviceApi) builder,
    final LogoutBloc? bloc,
  }) {
    return LogoutBlocSelector(
      key: key,
      selector: (state) => state.logoutOfSpecificDeviceApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LogoutBlocSelector<ApiState<void>> logoutAllSessionsApi({
    final Key? key,
    required Widget Function(ApiState<void> logoutAllSessionsApi) builder,
    final LogoutBloc? bloc,
  }) {
    return LogoutBlocSelector(
      key: key,
      selector: (state) => state.logoutAllSessionsApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<LogoutBloc, LogoutState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _LogoutBlocMixin on Cubit<LogoutState> {
  @mustCallSuper
  void updateCurrentDeviceToken(final String currentDeviceToken) {
    if (this.state.currentDeviceToken == currentDeviceToken) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.currentDeviceToken = currentDeviceToken));

    $onUpdateCurrentDeviceToken();
  }

  @protected
  void $onUpdateCurrentDeviceToken() {}

  @mustCallSuper
  void updateLoginActivities(
      final BuiltList<LoginSessionModel>? loginActivities) {
    if (this.state.loginActivities == loginActivities) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (loginActivities == null)
        b.loginActivities = null;
      else
        b.loginActivities.replace(loginActivities);
    }));

    $onUpdateLoginActivities();
  }

  @protected
  void $onUpdateLoginActivities() {}
}
