// ignore_for_file: type=lint, unused_element

part of 'doorbell_management_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class DoorbellManagementBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<DoorbellManagementState>? buildWhen;
  final BlocWidgetBuilder<DoorbellManagementState> builder;

  const DoorbellManagementBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<DoorbellManagementBloc, DoorbellManagementState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class DoorbellManagementBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<DoorbellManagementState, T> selector;
  final Widget Function(T state) builder;
  final DoorbellManagementBloc? bloc;

  const DoorbellManagementBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static DoorbellManagementBlocSelector<LatLng?> center({
    final Key? key,
    required Widget Function(LatLng? center) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.center,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<bool> mapGuideShow({
    final Key? key,
    required Widget Function(bool mapGuideShow) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.mapGuideShow,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<String> currentGuideKey({
    final Key? key,
    required Widget Function(String currentGuideKey) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.currentGuideKey,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<bool> doorbellNameSaveLoading({
    final Key? key,
    required Widget Function(bool doorbellNameSaveLoading) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.doorbellNameSaveLoading,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<LatLng?> markerPosition({
    final Key? key,
    required Widget Function(LatLng? markerPosition) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.markerPosition,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<double> radiusInMeters({
    final Key? key,
    required Widget Function(double radiusInMeters) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.radiusInMeters,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<bool> backPress({
    final Key? key,
    required Widget Function(bool backPress) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.backPress,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<bool> proceedButtonEnabled({
    final Key? key,
    required Widget Function(bool proceedButtonEnabled) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.proceedButtonEnabled,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<String> locationName({
    final Key? key,
    required Widget Function(String locationName) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.locationName,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<String?> deviceId({
    final Key? key,
    required Widget Function(String? deviceId) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.deviceId,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<String?> doorbellName({
    final Key? key,
    required Widget Function(String? doorbellName) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.doorbellName,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<String> customDoorbellName({
    final Key? key,
    required Widget Function(String customDoorbellName) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.customDoorbellName,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<DoorbellLocations?> selectedLocation({
    final Key? key,
    required Widget Function(DoorbellLocations? selectedLocation) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.selectedLocation,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<String> companyAddress({
    final Key? key,
    required Widget Function(String companyAddress) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.companyAddress,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<String> streetBlockName({
    final Key? key,
    required Widget Function(String streetBlockName) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.streetBlockName,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<Placemark?> placeMark({
    final Key? key,
    required Widget Function(Placemark? placeMark) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.placeMark,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<SuperTooltipController>
      superToolTipController({
    final Key? key,
    required Widget Function(SuperTooltipController superToolTipController)
        builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.superToolTipController,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<ApiState<void>> createLocationApi({
    final Key? key,
    required Widget Function(ApiState<void> createLocationApi) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.createLocationApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<ApiState<void>> assignDoorbellApi({
    final Key? key,
    required Widget Function(ApiState<void> assignDoorbellApi) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.assignDoorbellApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<ApiState<void>> scanDoorBellApi({
    final Key? key,
    required Widget Function(ApiState<void> scanDoorBellApi) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.scanDoorBellApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static DoorbellManagementBlocSelector<ApiState<void>> updateLocationApi({
    final Key? key,
    required Widget Function(ApiState<void> updateLocationApi) builder,
    final DoorbellManagementBloc? bloc,
  }) {
    return DoorbellManagementBlocSelector(
      key: key,
      selector: (state) => state.updateLocationApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<DoorbellManagementBloc, DoorbellManagementState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _DoorbellManagementBlocMixin on Cubit<DoorbellManagementState> {
  @mustCallSuper
  void updateCenter(final LatLng? center) {
    if (this.state.center == center) {
      return;
    }

    emit(this.state.rebuild((final b) => b.center = center));

    $onUpdateCenter();
  }

  @protected
  void $onUpdateCenter() {}

  @mustCallSuper
  void updateMapGuideShow(final bool mapGuideShow) {
    if (this.state.mapGuideShow == mapGuideShow) {
      return;
    }

    emit(this.state.rebuild((final b) => b.mapGuideShow = mapGuideShow));

    $onUpdateMapGuideShow();
  }

  @protected
  void $onUpdateMapGuideShow() {}

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
  void updateDoorbellNameSaveLoading(final bool doorbellNameSaveLoading) {
    if (this.state.doorbellNameSaveLoading == doorbellNameSaveLoading) {
      return;
    }

    emit(this.state.rebuild(
        (final b) => b.doorbellNameSaveLoading = doorbellNameSaveLoading));

    $onUpdateDoorbellNameSaveLoading();
  }

  @protected
  void $onUpdateDoorbellNameSaveLoading() {}

  @mustCallSuper
  void updateMarkerPosition(final LatLng? markerPosition) {
    if (this.state.markerPosition == markerPosition) {
      return;
    }

    emit(this.state.rebuild((final b) => b.markerPosition = markerPosition));

    $onUpdateMarkerPosition();
  }

  @protected
  void $onUpdateMarkerPosition() {}

  @mustCallSuper
  void updateBackPress(final bool backPress) {
    if (this.state.backPress == backPress) {
      return;
    }

    emit(this.state.rebuild((final b) => b.backPress = backPress));

    $onUpdateBackPress();
  }

  @protected
  void $onUpdateBackPress() {}

  @mustCallSuper
  void updateProceedButtonEnabled(final bool proceedButtonEnabled) {
    if (this.state.proceedButtonEnabled == proceedButtonEnabled) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.proceedButtonEnabled = proceedButtonEnabled));

    $onUpdateProceedButtonEnabled();
  }

  @protected
  void $onUpdateProceedButtonEnabled() {}

  @mustCallSuper
  void updateLocationName(final String locationName) {
    if (this.state.locationName == locationName) {
      return;
    }

    emit(this.state.rebuild((final b) => b.locationName = locationName));

    $onUpdateLocationName();
  }

  @protected
  void $onUpdateLocationName() {}

  @mustCallSuper
  void updateDeviceId(final String? deviceId) {
    if (this.state.deviceId == deviceId) {
      return;
    }

    emit(this.state.rebuild((final b) => b.deviceId = deviceId));

    $onUpdateDeviceId();
  }

  @protected
  void $onUpdateDeviceId() {}

  @mustCallSuper
  void updateDoorbellName(final String? doorbellName) {
    if (this.state.doorbellName == doorbellName) {
      return;
    }

    emit(this.state.rebuild((final b) => b.doorbellName = doorbellName));

    $onUpdateDoorbellName();
  }

  @protected
  void $onUpdateDoorbellName() {}

  @mustCallSuper
  void updateCustomDoorbellName(final String customDoorbellName) {
    if (this.state.customDoorbellName == customDoorbellName) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.customDoorbellName = customDoorbellName));

    $onUpdateCustomDoorbellName();
  }

  @protected
  void $onUpdateCustomDoorbellName() {}

  @mustCallSuper
  void updateSelectedLocation(final DoorbellLocations? selectedLocation) {
    if (this.state.selectedLocation == selectedLocation) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (selectedLocation == null)
        b.selectedLocation = null;
      else
        b.selectedLocation.replace(selectedLocation);
    }));

    $onUpdateSelectedLocation();
  }

  @protected
  void $onUpdateSelectedLocation() {}

  @mustCallSuper
  void updateCompanyAddress(final String companyAddress) {
    if (this.state.companyAddress == companyAddress) {
      return;
    }

    emit(this.state.rebuild((final b) => b.companyAddress = companyAddress));

    $onUpdateCompanyAddress();
  }

  @protected
  void $onUpdateCompanyAddress() {}

  @mustCallSuper
  void updateStreetBlockName(final String streetBlockName) {
    if (this.state.streetBlockName == streetBlockName) {
      return;
    }

    emit(this.state.rebuild((final b) => b.streetBlockName = streetBlockName));

    $onUpdateStreetBlockName();
  }

  @protected
  void $onUpdateStreetBlockName() {}

  @mustCallSuper
  void updatePlaceMark(final Placemark? placeMark) {
    if (this.state.placeMark == placeMark) {
      return;
    }

    emit(this.state.rebuild((final b) => b.placeMark = placeMark));

    $onUpdatePlaceMark();
  }

  @protected
  void $onUpdatePlaceMark() {}

  @mustCallSuper
  void updateScanDoorBellApi(final ApiState<void> scanDoorBellApi) {
    if (this.state.scanDoorBellApi == scanDoorBellApi) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.scanDoorBellApi.replace(scanDoorBellApi);
    }));

    $onUpdateScanDoorBellApi();
  }

  @protected
  void $onUpdateScanDoorBellApi() {}
}
