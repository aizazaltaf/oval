// ignore_for_file: type=lint, unused_element

part of 'startup_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class StartupBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<StartupState>? buildWhen;
  final BlocWidgetBuilder<StartupState> builder;

  const StartupBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<StartupBloc, StartupState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class StartupBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<StartupState, T> selector;
  final Widget Function(T state) builder;
  final StartupBloc? bloc;

  const StartupBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static StartupBlocSelector<ApiState<void>> everythingApi({
    final Key? key,
    required Widget Function(ApiState<void> everythingApi) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.everythingApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<ApiState<void>> editCameraDevice({
    final Key? key,
    required Widget Function(ApiState<void> editCameraDevice) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.editCameraDevice,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<ApiState<BuiltList<UserDeviceModel>>> doorbellApi({
    final Key? key,
    required Widget Function(ApiState<BuiltList<UserDeviceModel>> doorbellApi)
        builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.doorbellApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<bool> doorbellNameEdit({
    final Key? key,
    required Widget Function(bool doorbellNameEdit) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.doorbellNameEdit,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<bool> dashboardApiCalling({
    final Key? key,
    required Widget Function(bool dashboardApiCalling) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.dashboardApiCalling,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<int> doorbellImageVersion({
    final Key? key,
    required Widget Function(int doorbellImageVersion) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.doorbellImageVersion,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<int> noDoorbellCarouselIndex({
    final Key? key,
    required Widget Function(int noDoorbellCarouselIndex) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.noDoorbellCarouselIndex,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<int> monitorCamerasCarouselIndex({
    final Key? key,
    required Widget Function(int monitorCamerasCarouselIndex) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.monitorCamerasCarouselIndex,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<bool> refreshSnapshots({
    final Key? key,
    required Widget Function(bool refreshSnapshots) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.refreshSnapshots,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<bool> isInternetConnected({
    final Key? key,
    required Widget Function(bool isInternetConnected) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.isInternetConnected,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<BuiltList<String>> monitorCameraPinnedList({
    final Key? key,
    required Widget Function(BuiltList<String> monitorCameraPinnedList) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.monitorCameraPinnedList,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<String?> searchCamera({
    final Key? key,
    required Widget Function(String? searchCamera) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.searchCamera,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<bool> canUpdateDoorbellName({
    final Key? key,
    required Widget Function(bool canUpdateDoorbellName) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.canUpdateDoorbellName,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<String> newDoorbellName({
    final Key? key,
    required Widget Function(String newDoorbellName) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.newDoorbellName,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<int?> index({
    final Key? key,
    required Widget Function(int? index) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.index,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<bool> isDoorbellConnected({
    final Key? key,
    required Widget Function(bool isDoorbellConnected) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.isDoorbellConnected,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<bool> splashEnd({
    final Key? key,
    required Widget Function(bool splashEnd) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.splashEnd,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<BuiltList<int>> bottomNavIndexValues({
    final Key? key,
    required Widget Function(BuiltList<int> bottomNavIndexValues) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.bottomNavIndexValues,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<bool> needDashboardCall({
    final Key? key,
    required Widget Function(bool needDashboardCall) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.needDashboardCall,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<int> indexedStackValue({
    final Key? key,
    required Widget Function(int indexedStackValue) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.indexedStackValue,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<BuiltList<UserDeviceModel>?> userDeviceModel({
    final Key? key,
    required Widget Function(BuiltList<UserDeviceModel>? userDeviceModel)
        builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.userDeviceModel,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<BuiltList<AiAlertPreferencesModel>>
      aiAlertPreferencesList({
    final Key? key,
    required Widget Function(
            BuiltList<AiAlertPreferencesModel> aiAlertPreferencesList)
        builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.aiAlertPreferencesList,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<MotionTabBarController?> motionTabBarController({
    final Key? key,
    required Widget Function(MotionTabBarController? motionTabBarController)
        builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.motionTabBarController,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<bool> moreCustomFeatureTileExpanded({
    final Key? key,
    required Widget Function(bool moreCustomFeatureTileExpanded) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.moreCustomFeatureTileExpanded,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<bool> moreCustomSettingsTileExpanded({
    final Key? key,
    required Widget Function(bool moreCustomSettingsTileExpanded) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.moreCustomSettingsTileExpanded,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<bool> moreCustomPaymentsTileExpanded({
    final Key? key,
    required Widget Function(bool moreCustomPaymentsTileExpanded) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.moreCustomPaymentsTileExpanded,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<ApiState<void>> releaseDoorbellApi({
    final Key? key,
    required Widget Function(ApiState<void> releaseDoorbellApi) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.releaseDoorbellApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<ApiState<void>> editDoorbellNameApi({
    final Key? key,
    required Widget Function(ApiState<void> editDoorbellNameApi) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.editDoorbellNameApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<ApiState<void>> setGuideApi({
    final Key? key,
    required Widget Function(ApiState<void> setGuideApi) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.setGuideApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<ApiState<void>> versionApi({
    final Key? key,
    required Widget Function(ApiState<void> versionApi) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.versionApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<ApiState<void>> aiAlertPreferencesApi({
    final Key? key,
    required Widget Function(ApiState<void> aiAlertPreferencesApi) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.aiAlertPreferencesApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<ApiState<void>> updateApiAlertPreferencesApi({
    final Key? key,
    required Widget Function(ApiState<void> updateApiAlertPreferencesApi)
        builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.updateApiAlertPreferencesApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<ApiState<void>> planFeaturesApi({
    final Key? key,
    required Widget Function(ApiState<void> planFeaturesApi) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.planFeaturesApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<SocketState<Map<String, dynamic>>>
      doorbellOperation({
    final Key? key,
    required Widget Function(
            SocketState<Map<String, dynamic>> doorbellOperation)
        builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.doorbellOperation,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static StartupBlocSelector<bool?> appIsUpdated({
    final Key? key,
    required Widget Function(bool? appIsUpdated) builder,
    final StartupBloc? bloc,
  }) {
    return StartupBlocSelector(
      key: key,
      selector: (state) => state.appIsUpdated,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<StartupBloc, StartupState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _StartupBlocMixin on Cubit<StartupState> {
  @mustCallSuper
  void updateDoorbellNameEdit(final bool doorbellNameEdit) {
    if (this.state.doorbellNameEdit == doorbellNameEdit) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.doorbellNameEdit = doorbellNameEdit));

    $onUpdateDoorbellNameEdit();
  }

  @protected
  void $onUpdateDoorbellNameEdit() {}

  @mustCallSuper
  void updateDashboardApiCalling(final bool dashboardApiCalling) {
    if (this.state.dashboardApiCalling == dashboardApiCalling) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.dashboardApiCalling = dashboardApiCalling));

    $onUpdateDashboardApiCalling();
  }

  @protected
  void $onUpdateDashboardApiCalling() {}

  @mustCallSuper
  void updateDoorbellImageVersion(final int doorbellImageVersion) {
    if (this.state.doorbellImageVersion == doorbellImageVersion) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.doorbellImageVersion = doorbellImageVersion));

    $onUpdateDoorbellImageVersion();
  }

  @protected
  void $onUpdateDoorbellImageVersion() {}

  @mustCallSuper
  void updateNoDoorbellCarouselIndex(final int noDoorbellCarouselIndex) {
    if (this.state.noDoorbellCarouselIndex == noDoorbellCarouselIndex) {
      return;
    }

    emit(this.state.rebuild(
        (final b) => b.noDoorbellCarouselIndex = noDoorbellCarouselIndex));

    $onUpdateNoDoorbellCarouselIndex();
  }

  @protected
  void $onUpdateNoDoorbellCarouselIndex() {}

  @mustCallSuper
  void updateMonitorCamerasCarouselIndex(
      final int monitorCamerasCarouselIndex) {
    if (this.state.monitorCamerasCarouselIndex == monitorCamerasCarouselIndex) {
      return;
    }

    emit(this.state.rebuild((final b) =>
        b.monitorCamerasCarouselIndex = monitorCamerasCarouselIndex));

    $onUpdateMonitorCamerasCarouselIndex();
  }

  @protected
  void $onUpdateMonitorCamerasCarouselIndex() {}

  @mustCallSuper
  void updateRefreshSnapshots(final bool refreshSnapshots) {
    if (this.state.refreshSnapshots == refreshSnapshots) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.refreshSnapshots = refreshSnapshots));

    $onUpdateRefreshSnapshots();
  }

  @protected
  void $onUpdateRefreshSnapshots() {}

  @mustCallSuper
  void updateIsInternetConnected(final bool isInternetConnected) {
    if (this.state.isInternetConnected == isInternetConnected) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isInternetConnected = isInternetConnected));

    $onUpdateIsInternetConnected();
  }

  @protected
  void $onUpdateIsInternetConnected() {}

  @mustCallSuper
  void updateMonitorCameraPinnedList(
      final BuiltList<String> monitorCameraPinnedList) {
    if (this.state.monitorCameraPinnedList == monitorCameraPinnedList) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.monitorCameraPinnedList.replace(monitorCameraPinnedList);
    }));

    $onUpdateMonitorCameraPinnedList();
  }

  @protected
  void $onUpdateMonitorCameraPinnedList() {}

  @mustCallSuper
  void updateSearchCamera(final String? searchCamera) {
    if (this.state.searchCamera == searchCamera) {
      return;
    }

    emit(this.state.rebuild((final b) => b.searchCamera = searchCamera));

    $onUpdateSearchCamera();
  }

  @protected
  void $onUpdateSearchCamera() {}

  @mustCallSuper
  void updateCanUpdateDoorbellName(final bool canUpdateDoorbellName) {
    if (this.state.canUpdateDoorbellName == canUpdateDoorbellName) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.canUpdateDoorbellName = canUpdateDoorbellName));

    $onUpdateCanUpdateDoorbellName();
  }

  @protected
  void $onUpdateCanUpdateDoorbellName() {}

  @mustCallSuper
  void updateNewDoorbellName(final String newDoorbellName) {
    if (this.state.newDoorbellName == newDoorbellName) {
      return;
    }

    emit(this.state.rebuild((final b) => b.newDoorbellName = newDoorbellName));

    $onUpdateNewDoorbellName();
  }

  @protected
  void $onUpdateNewDoorbellName() {}

  @mustCallSuper
  void updateIndex(final int? index) {
    if (this.state.index == index) {
      return;
    }

    emit(this.state.rebuild((final b) => b.index = index));

    $onUpdateIndex();
  }

  @protected
  void $onUpdateIndex() {}

  @mustCallSuper
  void updateIsDoorbellConnected(final bool isDoorbellConnected) {
    if (this.state.isDoorbellConnected == isDoorbellConnected) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isDoorbellConnected = isDoorbellConnected));

    $onUpdateIsDoorbellConnected();
  }

  @protected
  void $onUpdateIsDoorbellConnected() {}

  @mustCallSuper
  void updateSplashEnd(final bool splashEnd) {
    if (this.state.splashEnd == splashEnd) {
      return;
    }

    emit(this.state.rebuild((final b) => b.splashEnd = splashEnd));

    $onUpdateSplashEnd();
  }

  @protected
  void $onUpdateSplashEnd() {}

  @mustCallSuper
  void updateBottomNavIndexValues(final BuiltList<int> bottomNavIndexValues) {
    if (this.state.bottomNavIndexValues == bottomNavIndexValues) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.bottomNavIndexValues.replace(bottomNavIndexValues);
    }));

    $onUpdateBottomNavIndexValues();
  }

  @protected
  void $onUpdateBottomNavIndexValues() {}

  @mustCallSuper
  void updateNeedDashboardCall(final bool needDashboardCall) {
    if (this.state.needDashboardCall == needDashboardCall) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.needDashboardCall = needDashboardCall));

    $onUpdateNeedDashboardCall();
  }

  @protected
  void $onUpdateNeedDashboardCall() {}

  @mustCallSuper
  void updateIndexedStackValue(final int indexedStackValue) {
    if (this.state.indexedStackValue == indexedStackValue) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.indexedStackValue = indexedStackValue));

    $onUpdateIndexedStackValue();
  }

  @protected
  void $onUpdateIndexedStackValue() {}

  @mustCallSuper
  void updateUserDeviceModel(
      final BuiltList<UserDeviceModel>? userDeviceModel) {
    if (this.state.userDeviceModel == userDeviceModel) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (userDeviceModel == null)
        b.userDeviceModel = null;
      else
        b.userDeviceModel.replace(userDeviceModel);
    }));

    $onUpdateUserDeviceModel();
  }

  @protected
  void $onUpdateUserDeviceModel() {}

  @mustCallSuper
  void updateAiAlertPreferencesList(
      final BuiltList<AiAlertPreferencesModel> aiAlertPreferencesList) {
    if (this.state.aiAlertPreferencesList == aiAlertPreferencesList) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.aiAlertPreferencesList.replace(aiAlertPreferencesList);
    }));

    $onUpdateAiAlertPreferencesList();
  }

  @protected
  void $onUpdateAiAlertPreferencesList() {}

  @mustCallSuper
  void updateMotionTabBarController(
      final MotionTabBarController? motionTabBarController) {
    if (this.state.motionTabBarController == motionTabBarController) {
      return;
    }

    emit(this.state.rebuild(
        (final b) => b.motionTabBarController = motionTabBarController));

    $onUpdateMotionTabBarController();
  }

  @protected
  void $onUpdateMotionTabBarController() {}

  @mustCallSuper
  void updateMoreCustomFeatureTileExpanded(
      final bool moreCustomFeatureTileExpanded) {
    if (this.state.moreCustomFeatureTileExpanded ==
        moreCustomFeatureTileExpanded) {
      return;
    }

    emit(this.state.rebuild((final b) =>
        b.moreCustomFeatureTileExpanded = moreCustomFeatureTileExpanded));

    $onUpdateMoreCustomFeatureTileExpanded();
  }

  @protected
  void $onUpdateMoreCustomFeatureTileExpanded() {}

  @mustCallSuper
  void updateMoreCustomSettingsTileExpanded(
      final bool moreCustomSettingsTileExpanded) {
    if (this.state.moreCustomSettingsTileExpanded ==
        moreCustomSettingsTileExpanded) {
      return;
    }

    emit(this.state.rebuild((final b) =>
        b.moreCustomSettingsTileExpanded = moreCustomSettingsTileExpanded));

    $onUpdateMoreCustomSettingsTileExpanded();
  }

  @protected
  void $onUpdateMoreCustomSettingsTileExpanded() {}

  @mustCallSuper
  void updateMoreCustomPaymentsTileExpanded(
      final bool moreCustomPaymentsTileExpanded) {
    if (this.state.moreCustomPaymentsTileExpanded ==
        moreCustomPaymentsTileExpanded) {
      return;
    }

    emit(this.state.rebuild((final b) =>
        b.moreCustomPaymentsTileExpanded = moreCustomPaymentsTileExpanded));

    $onUpdateMoreCustomPaymentsTileExpanded();
  }

  @protected
  void $onUpdateMoreCustomPaymentsTileExpanded() {}

  @mustCallSuper
  void updateAppIsUpdated(final bool? appIsUpdated) {
    if (this.state.appIsUpdated == appIsUpdated) {
      return;
    }

    emit(this.state.rebuild((final b) => b.appIsUpdated = appIsUpdated));

    $onUpdateAppIsUpdated();
  }

  @protected
  void $onUpdateAppIsUpdated() {}
}
