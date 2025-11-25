import 'package:admin/models/data/ai_alert_preferences_model.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/widgets/bottom_navigation_bar/motion_tab_bar_controller.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'startup_state.g.dart';

abstract class StartupState
    implements Built<StartupState, StartupStateBuilder> {
  factory StartupState([
    final void Function(StartupStateBuilder) updates,
  ]) = _$StartupState;

  StartupState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final StartupStateBuilder b) => b
    ..index = 0
    ..bottomNavIndexValues = <int>[0].toBuiltList().toBuilder()
    ..aiAlertPreferencesList.replace([])
    ..isDoorbellConnected = false
    ..isInternetConnected = true
    ..indexedStackValue = 0
    ..monitorCameraPinnedList = <String>[].toBuiltList().toBuilder()
    ..noDoorbellCarouselIndex = 0
    ..monitorCamerasCarouselIndex = 0
    ..needDashboardCall = true
    ..splashEnd = false
    ..refreshSnapshots = false
    ..doorbellNameEdit = false
    ..doorbellImageVersion = 0
    ..appIsUpdated = false
    ..canUpdateDoorbellName = false
    ..newDoorbellName = ''
    ..dashboardApiCalling = false
    ..moreCustomFeatureTileExpanded = false
    ..moreCustomSettingsTileExpanded = false
    ..moreCustomPaymentsTileExpanded = false;

  ApiState<void> get everythingApi;

  ApiState<void> get editCameraDevice;

  ApiState<BuiltList<UserDeviceModel>> get doorbellApi;

  @BlocUpdateField()
  bool get doorbellNameEdit;

  @BlocUpdateField()
  bool get dashboardApiCalling;

  @BlocUpdateField()
  int get doorbellImageVersion;

  @BlocUpdateField()
  int get noDoorbellCarouselIndex;

  @BlocUpdateField()
  int get monitorCamerasCarouselIndex;

  @BlocUpdateField()
  bool get refreshSnapshots;

  @BlocUpdateField()
  bool get isInternetConnected;

  @BlocUpdateField()
  BuiltList<String> get monitorCameraPinnedList;

  @BlocUpdateField()
  String? get searchCamera;

  @BlocUpdateField()
  bool get canUpdateDoorbellName;

  @BlocUpdateField()
  String get newDoorbellName;

  @BlocUpdateField()
  int? get index;

  @BlocUpdateField()
  bool get isDoorbellConnected;

  @BlocUpdateField()
  bool get splashEnd;

  @BlocUpdateField()
  BuiltList<int> get bottomNavIndexValues;

  @BlocUpdateField()
  bool get needDashboardCall;

  @BlocUpdateField()
  int get indexedStackValue;

  @BlocUpdateField()
  BuiltList<UserDeviceModel>? get userDeviceModel;

  @BlocUpdateField()
  BuiltList<AiAlertPreferencesModel> get aiAlertPreferencesList;

  @BlocUpdateField()
  MotionTabBarController? get motionTabBarController;

  @BlocUpdateField()
  bool get moreCustomFeatureTileExpanded;

  @BlocUpdateField()
  bool get moreCustomSettingsTileExpanded;

  @BlocUpdateField()
  bool get moreCustomPaymentsTileExpanded;

  ApiState<void> get releaseDoorbellApi;

  ApiState<void> get editDoorbellNameApi;

  ApiState<void> get setGuideApi;

  ApiState<void> get versionApi;

  ApiState<void> get aiAlertPreferencesApi;

  ApiState<void> get updateApiAlertPreferencesApi;

  ApiState<void> get planFeaturesApi;

  SocketState<Map<String, dynamic>> get doorbellOperation;

  @BlocUpdateField()
  bool? get appIsUpdated;
}
