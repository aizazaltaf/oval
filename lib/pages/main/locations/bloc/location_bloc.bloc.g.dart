// ignore_for_file: type=lint, unused_element

part of 'location_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class LocationBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<LocationState>? buildWhen;
  final BlocWidgetBuilder<LocationState> builder;

  const LocationBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class LocationBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<LocationState, T> selector;
  final Widget Function(T state) builder;
  final LocationBloc? bloc;

  const LocationBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static LocationBlocSelector<String?> search({
    final Key? key,
    required Widget Function(String? search) builder,
    final LocationBloc? bloc,
  }) {
    return LocationBlocSelector(
      key: key,
      selector: (state) => state.search,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LocationBlocSelector<SubUserModel?> selectedOwnershipUser({
    final Key? key,
    required Widget Function(SubUserModel? selectedOwnershipUser) builder,
    final LocationBloc? bloc,
  }) {
    return LocationBlocSelector(
      key: key,
      selector: (state) => state.selectedOwnershipUser,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LocationBlocSelector<BuiltList<SubUserModel>?> locationSubUsersList({
    final Key? key,
    required Widget Function(BuiltList<SubUserModel>? locationSubUsersList)
        builder,
    final LocationBloc? bloc,
  }) {
    return LocationBlocSelector(
      key: key,
      selector: (state) => state.locationSubUsersList,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LocationBlocSelector<String> selectedReleaseLocationId({
    final Key? key,
    required Widget Function(String selectedReleaseLocationId) builder,
    final LocationBloc? bloc,
  }) {
    return LocationBlocSelector(
      key: key,
      selector: (state) => state.selectedReleaseLocationId,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LocationBlocSelector<ApiState<void>> locationSubUsersApi({
    final Key? key,
    required Widget Function(ApiState<void> locationSubUsersApi) builder,
    final LocationBloc? bloc,
  }) {
    return LocationBlocSelector(
      key: key,
      selector: (state) => state.locationSubUsersApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LocationBlocSelector<ApiState<void>> transferOwnershipApi({
    final Key? key,
    required Widget Function(ApiState<void> transferOwnershipApi) builder,
    final LocationBloc? bloc,
  }) {
    return LocationBlocSelector(
      key: key,
      selector: (state) => state.transferOwnershipApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LocationBlocSelector<ApiState<void>> releaseLocationApi({
    final Key? key,
    required Widget Function(ApiState<void> releaseLocationApi) builder,
    final LocationBloc? bloc,
  }) {
    return LocationBlocSelector(
      key: key,
      selector: (state) => state.releaseLocationApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<LocationBloc, LocationState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _LocationBlocMixin on Cubit<LocationState> {
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
  void updateSelectedOwnershipUser(final SubUserModel? selectedOwnershipUser) {
    if (this.state.selectedOwnershipUser == selectedOwnershipUser) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (selectedOwnershipUser == null)
        b.selectedOwnershipUser = null;
      else
        b.selectedOwnershipUser.replace(selectedOwnershipUser);
    }));

    $onUpdateSelectedOwnershipUser();
  }

  @protected
  void $onUpdateSelectedOwnershipUser() {}

  @mustCallSuper
  void updateLocationSubUsersList(
      final BuiltList<SubUserModel>? locationSubUsersList) {
    if (this.state.locationSubUsersList == locationSubUsersList) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (locationSubUsersList == null)
        b.locationSubUsersList = null;
      else
        b.locationSubUsersList.replace(locationSubUsersList);
    }));

    $onUpdateLocationSubUsersList();
  }

  @protected
  void $onUpdateLocationSubUsersList() {}

  @mustCallSuper
  void updateSelectedReleaseLocationId(final String selectedReleaseLocationId) {
    if (this.state.selectedReleaseLocationId == selectedReleaseLocationId) {
      return;
    }

    emit(this.state.rebuild(
        (final b) => b.selectedReleaseLocationId = selectedReleaseLocationId));

    $onUpdateSelectedReleaseLocationId();
  }

  @protected
  void $onUpdateSelectedReleaseLocationId() {}
}
