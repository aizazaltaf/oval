import 'package:admin/models/data/ai_alert_preferences_model.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/bloc/bloc_mocks.dart';
import '../../mocks/bloc/state_mocks.dart';
import '../fake_build_context.dart';

class StartupBlocTestHelper {
  late MockStartupBloc mockStartupBloc;
  late MockStartupState _currentStartupState;

  void setup() {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(
      UserDeviceModel(
        (b) => b
          ..id = 0
          ..deviceId = ""
          ..callUserId = ""
          ..name = ""
          ..locationId = 0
          ..isDefault = 0
          ..isStreaming = 0,
      ),
    );
    registerFallbackValue(BuiltList<AiAlertPreferencesModel>());
    mockStartupBloc = MockStartupBloc();
    _currentStartupState = MockStartupState();

    // Setup default state properties first
    setupDefaultState();

    // The stream is already implemented in MockStartupBloc, no need to mock it
    // Set the state using the setter instead of trying to mock the getter
    mockStartupBloc.state = _currentStartupState;

    // Stub async methods to return proper Future values
    when(
      () => mockStartupBloc.socketMethod(
        fromConnectivity: any(named: 'fromConnectivity'),
      ),
    ).thenAnswer((_) async {});
    when(() => mockStartupBloc.updateMonitorCamerasCarouselIndex(any()))
        .thenAnswer((_) async {});
    when(() => mockStartupBloc.updateMonitorCamerasSnapshots())
        .thenAnswer((_) async {});
    when(
      () => mockStartupBloc.enableAiAlertPreferences(
        any(),
        any(),
        any(),
      ),
    ).thenAnswer((_) async {});
    when(() => mockStartupBloc.updateAiAlertPreferencesList(any()))
        .thenAnswer((invocation) {
      final newList = invocation.positionalArguments[0]
          as BuiltList<AiAlertPreferencesModel>;
      mockStartupBloc.temporaryAiAlertPreferencesList = newList;
    });
  }

  void setupDefaultState() {
    // Stub the userDeviceModel to return empty list (triggers NoDoorBell)
    when(() => _currentStartupState.userDeviceModel).thenReturn(BuiltList([]));
    when(() => _currentStartupState.isInternetConnected).thenReturn(true);
    when(() => _currentStartupState.isDoorbellConnected).thenReturn(false);
    when(() => _currentStartupState.splashEnd).thenReturn(true);
    when(() => _currentStartupState.needDashboardCall).thenReturn(false);
    when(() => _currentStartupState.dashboardApiCalling).thenReturn(false);
    when(() => _currentStartupState.doorbellNameEdit).thenReturn(false);
    when(() => _currentStartupState.canUpdateDoorbellName).thenReturn(false);
    when(() => _currentStartupState.newDoorbellName).thenReturn('');
    when(() => _currentStartupState.index).thenReturn(0);
    when(() => _currentStartupState.noDoorbellCarouselIndex).thenReturn(0);
    when(() => _currentStartupState.monitorCamerasCarouselIndex).thenReturn(0);
    when(() => _currentStartupState.refreshSnapshots).thenReturn(false);
    when(() => _currentStartupState.doorbellImageVersion).thenReturn(0);
    when(() => _currentStartupState.appIsUpdated).thenReturn(false);
    when(() => _currentStartupState.moreCustomFeatureTileExpanded)
        .thenReturn(false);
    when(() => _currentStartupState.moreCustomSettingsTileExpanded)
        .thenReturn(false);
    when(() => _currentStartupState.moreCustomPaymentsTileExpanded)
        .thenReturn(false);
    when(() => _currentStartupState.indexedStackValue).thenReturn(0);
    when(() => _currentStartupState.bottomNavIndexValues)
        .thenReturn(BuiltList([0]));
    when(() => _currentStartupState.aiAlertPreferencesList)
        .thenReturn(BuiltList<AiAlertPreferencesModel>([]));

    // Additional properties for comprehensive coverage
    when(() => _currentStartupState.motionTabBarController).thenReturn(null);
    when(() => _currentStartupState.monitorCameraPinnedList)
        .thenReturn(BuiltList([]));
    when(() => _currentStartupState.searchCamera).thenReturn(null);
    when(() => _currentStartupState.everythingApi).thenReturn(ApiState<void>());
    when(() => _currentStartupState.doorbellApi)
        .thenReturn(ApiState<BuiltList<UserDeviceModel>>());
    when(() => _currentStartupState.releaseDoorbellApi)
        .thenReturn(ApiState<void>());
    when(() => _currentStartupState.editDoorbellNameApi)
        .thenReturn(ApiState<void>());
    when(() => _currentStartupState.setGuideApi).thenReturn(ApiState<void>());
    when(() => _currentStartupState.versionApi).thenReturn(ApiState<void>());
  }

  void setupLoadingState() {
    when(() => _currentStartupState.userDeviceModel).thenReturn(null);
    when(() => _currentStartupState.dashboardApiCalling).thenReturn(true);
    when(() => _currentStartupState.isInternetConnected).thenReturn(true);
    when(() => _currentStartupState.everythingApi).thenReturn(
      ApiState<void>((b) => b..isApiInProgress = true),
    );

    // Update the mock bloc state
    mockStartupBloc.state = _currentStartupState;
  }

  void setupNoInternetLoadingState() {
    when(() => _currentStartupState.userDeviceModel).thenReturn(null);
    when(() => _currentStartupState.dashboardApiCalling).thenReturn(true);
    when(() => _currentStartupState.isInternetConnected).thenReturn(false);

    // Update the mock bloc state
    mockStartupBloc.state = _currentStartupState;
  }

  void setupNoDoorBellState() {
    when(() => _currentStartupState.dashboardApiCalling).thenReturn(false);
    when(() => _currentStartupState.userDeviceModel).thenReturn(BuiltList([]));
    when(() => _currentStartupState.isInternetConnected).thenReturn(true);

    // Update the mock bloc state
    mockStartupBloc.state = _currentStartupState;
  }

  void setupDoorBellWidgetState() {
    when(() => _currentStartupState.userDeviceModel).thenReturn(
      BuiltList([
        UserDeviceModel(
          (b) => b
            ..id = 1
            ..deviceId = "test_device_1"
            ..callUserId = "test_uuid_1"
            ..name = "Test Doorbell"
            ..locationId = 1
            ..isDefault = 1
            ..isStreaming = 0,
        ),
      ]),
    );
    when(() => _currentStartupState.isDoorbellConnected).thenReturn(true);
    when(() => _currentStartupState.isInternetConnected).thenReturn(true);
    when(() => _currentStartupState.dashboardApiCalling).thenReturn(false);

    // Update the mock bloc state
    mockStartupBloc.state = _currentStartupState;
  }

  void setupCameraWidgetState() {
    when(() => _currentStartupState.userDeviceModel).thenReturn(
      BuiltList([
        UserDeviceModel(
          (b) => b
            ..id = 1
            ..deviceId = "camera_1"
            ..callUserId = "uuid_1"
            ..name = "Front Camera"
            ..locationId = 1
            ..isDefault = 1
            ..isStreaming = 1,
        ),
        UserDeviceModel(
          (b) => b
            ..id = 2
            ..deviceId = "camera_2"
            ..callUserId = "uuid_2"
            ..name = "Back Camera"
            ..locationId = 1
            ..isDefault = 0
            ..isStreaming = 0,
        ),
        UserDeviceModel(
          (b) => b
            ..id = 3
            ..deviceId = "test_device_1"
            ..callUserId = "test_uuid_1"
            ..name = "Test Camera"
            ..locationId = 1
            ..isDefault = 0
            ..isStreaming = 1,
        ),
      ]),
    );
    when(() => _currentStartupState.isDoorbellConnected).thenReturn(true);
    when(() => _currentStartupState.isInternetConnected).thenReturn(true);
    when(() => _currentStartupState.dashboardApiCalling).thenReturn(false);

    // Update the mock bloc state
    mockStartupBloc.state = _currentStartupState;
  }

  void setupWithDoorbells(List<UserDeviceModel> doorbells) {
    when(() => _currentStartupState.userDeviceModel).thenReturn(
      BuiltList<UserDeviceModel>(doorbells),
    );
    when(() => _currentStartupState.isInternetConnected).thenReturn(true);
    when(() => _currentStartupState.dashboardApiCalling).thenReturn(false);

    // Update the mock bloc state
    mockStartupBloc.state = _currentStartupState;
  }

  MockStartupBloc getMockStartupBloc() {
    return mockStartupBloc;
  }

  MockStartupState getMockStartupState() {
    return _currentStartupState;
  }

  MockStartupState get currentStartupState => _currentStartupState;

  void dispose() {
    // No stream controller to dispose
  }
}
