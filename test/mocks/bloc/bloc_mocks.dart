import 'dart:async';

import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/bloc/states/startup_state.dart';
import 'package:admin/models/data/ai_alert_preferences_model.dart';
import 'package:admin/models/data/notification_data.dart';
import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/doorbell_management/bloc/doorbell_management_bloc.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/logout/bloc/logout_bloc.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/notifications/bloc/notification_state.dart';
import 'package:admin/pages/main/statistics/bloc/statistics_bloc.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_state.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_bloc.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_state.dart';
import 'package:admin/pages/main/user_profile/bloc/change_password_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_state.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_state.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/bloc/theme_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

import '../bloc/state_mocks.dart';

class MockLoginBloc extends Mock implements LoginBloc {
  @override
  Future<void> close() async {}
}

class MockStartupBloc extends Mock implements StartupBloc {
  StartupState? _state;
  StreamController<StartupState>? _controller;
  BuiltList<AiAlertPreferencesModel>? _temporaryAiAlertPreferencesList;

  @override
  Stream<StartupState> get stream =>
      _controller?.stream ?? const Stream<StartupState>.empty();

  @override
  StartupState get state => _state ?? _createDefaultState();

  set state(StartupState state) {
    _state = state;
    if (_controller == null || _controller!.isClosed) {
      _controller = StreamController<StartupState>.broadcast();
    }
    _controller!.add(state);
  }

  // Add temporary list property
  @override
  BuiltList<AiAlertPreferencesModel> get temporaryAiAlertPreferencesList =>
      _temporaryAiAlertPreferencesList ??
      BuiltList<AiAlertPreferencesModel>([]);

  @override
  set temporaryAiAlertPreferencesList(BuiltList<AiAlertPreferencesModel> list) {
    _temporaryAiAlertPreferencesList = list;
  }

  StartupState _createDefaultState() {
    return StartupState(
      (b) => b
        ..userDeviceModel = ListBuilder<UserDeviceModel>([])
        ..isDoorbellConnected = false
        ..isInternetConnected = true
        ..splashEnd = true
        ..needDashboardCall = false
        ..dashboardApiCalling = false
        ..doorbellNameEdit = false
        ..canUpdateDoorbellName = false
        ..newDoorbellName = ''
        ..index = 0
        ..noDoorbellCarouselIndex = 0
        ..monitorCamerasCarouselIndex = 0
        ..refreshSnapshots = false
        ..doorbellImageVersion = 0
        ..appIsUpdated = false
        ..moreCustomFeatureTileExpanded = false
        ..moreCustomSettingsTileExpanded = false
        ..moreCustomPaymentsTileExpanded = false
        ..indexedStackValue = 0
        ..bottomNavIndexValues = ListBuilder<int>([0])
        ..aiAlertPreferencesList = ListBuilder<AiAlertPreferencesModel>([]),
    );
  }

  // Add missing methods that are being mocked in tests
  @override
  void updateAiAlertPreferencesList(BuiltList<AiAlertPreferencesModel> list) {
    // This method needs to be mockable for verification
    super
        .noSuchMethod(Invocation.method(#updateAiAlertPreferencesList, [list]));
  }

  @override
  Future<void> enableAiAlertPreferences(
    BuildContext context,
    UserDeviceModel device,
    bool isCamera,
  ) async {
    // This method needs to be mockable for verification
    super.noSuchMethod(
      Invocation.method(#enableAiAlertPreferences, [context, device, isCamera]),
    );
  }

  @override
  void setTempAiAlertPreferencesList() {
    // This method needs to be mockable for verification
    super.noSuchMethod(Invocation.method(#setTempAiAlertPreferencesList, []));
  }

  @override
  Future<BuiltList<UserDeviceModel>> getDoorbells({int? id}) {
    // This method needs to be mockable for verification
    return super.noSuchMethod(
      Invocation.method(#getDoorbells, [], {#id: id}),
    );
  }

  @override
  Future<void> close() async {
    await _controller?.close();
    _controller = null;
    await Future.value();
  }
}

class MockVisitorManagementBloc extends Mock implements VisitorManagementBloc {
  VisitorManagementState _state = VisitorManagementState(
    (b) => b..deleteVisitorHistoryIdsList = ListBuilder<String>([]),
  );
  final _controller = StreamController<VisitorManagementState>.broadcast();

  set mockState(VisitorManagementState state) => _state = state;

  @override
  VisitorManagementState get state => _state;

  @override
  Stream<VisitorManagementState> get stream => _controller.stream;

  Future<void> Function(String, {bool fromVisitorHistory})?
      _mockCallEditVisitorName;
  Future<void> setMockCallEditVisitorName(
    Future<void> Function(String, {bool fromVisitorHistory})? fn,
  ) async =>
      _mockCallEditVisitorName = fn;

  @override
  void emit(VisitorManagementState state) {
    _state = state;
    _controller.add(state);
  }

  @override
  void updateVisitorNameSaveButtonEnabled(bool enabled) {
    emit(_state.rebuild((b) => b..visitorNameSaveButtonEnabled = enabled));
  }

  @override
  void updateVisitorName(String name) {
    emit(_state.rebuild((b) => b..visitorName = name));
  }

  @override
  Future<void> callEditVisitorName(
    String visitorId, {
    bool fromVisitorHistory = false,
  }) {
    if (_mockCallEditVisitorName != null) {
      return _mockCallEditVisitorName!(
        visitorId,
        fromVisitorHistory: fromVisitorHistory,
      );
    }
    return Future.value();
  }

  void dispose() {
    _controller.close();
  }
}

class MockUserProfileBloc extends Mock implements UserProfileBloc {
  @override
  Future<void> close() async {}
}

class MockChangePasswordBloc extends Mock implements ChangePasswordBloc {
  @override
  Future<void> close() async {}
}

class MockProfileBloc extends Mock implements ProfileBloc {
  @override
  Future<void> close() async {}
}

class MockSingletonBloc extends Mock implements TestSingletonBloc {
  Future<void> close() async {}
}

class MockVoiceControlBloc extends Mock implements VoiceControlBloc {
  MockVoiceControlBloc([VoiceControlState? state])
      : _state = state ?? VoiceControlState();
  final VoiceControlState _state;
  @override
  VoiceControlState get state => _state;
  @override
  Stream<VoiceControlState> get stream =>
      const Stream<VoiceControlState>.empty();
  @override
  Future<void> close() async {}
}

class MockLogoutBloc extends Mock implements LogoutBloc {
  @override
  Future<void> close() async {}
}

class MockIotBloc extends Mock implements IotBloc {
  @override
  Future<void> close() async {}
}

class MockVoipBloc extends Mock implements VoipBloc {
  @override
  Future<void> initiateVoipWithDoorBell(
    BuildContext context,
    String callUserId, {
    bool fromStreaming = false,
    bool isStreaming = false,
    bool isExternalCamera = false,
  }) async {}

  @override
  Future<void> socketListener(BuildContext context) async {}

  @override
  Future<void> initializeRenders() async {}

  @override
  Future<void> endSilentCall({bool isChangeMode = false}) async {}
}

class MockNotificationBloc extends Mock implements NotificationBloc {
  NotificationState? _state;
  StreamController<NotificationState>? _controller;

  @override
  Stream<NotificationState> get stream =>
      _controller?.stream ?? const Stream<NotificationState>.empty();

  @override
  NotificationState get state => _state ?? _createDefaultState();

  set state(NotificationState state) {
    _state = state;
    if (_controller == null || _controller!.isClosed) {
      _controller = StreamController<NotificationState>.broadcast();
    }
    _controller!.add(state);
  }

  set mockState(NotificationState state) {
    _state = state;
    if (_controller == null || _controller!.isClosed) {
      _controller = StreamController<NotificationState>.broadcast();
    }
    _controller!.add(state);
  }

  NotificationState _createDefaultState() {
    return NotificationState(
      (b) => b
        ..dateFilters = ListBuilder<FeatureModel>([
          FeatureModel(title: 'Today', value: 'today'),
          FeatureModel(title: 'Yesterday', value: 'yesterday'),
          FeatureModel(title: 'Last 7 days', value: 'last_7_days'),
          FeatureModel(title: 'Last 30 days', value: 'last_30_days'),
          FeatureModel(title: 'Custom', value: 'custom'),
        ])
        ..aiAlertsFilters = ListBuilder<FeatureModel>([
          FeatureModel(title: 'All Alerts', value: 'all'),
          FeatureModel(title: 'Motion', value: 'motion'),
          FeatureModel(title: 'Person', value: 'person'),
          FeatureModel(title: 'Vehicle', value: 'vehicle'),
        ])
        ..aiAlertsSubFilters = ListBuilder<FeatureModel>([])
        ..deviceFilters = ListBuilder<FeatureModel>([])
        ..notificationGuideShow = false
        ..currentGuideKey = 'filter'
        ..noDeviceAvailable = ''
        ..customDate = null
        ..filter = false
        ..newNotification = false
        ..filterParam = ''
        ..deviceId = ''
        ..notificationApi =
            ApiState<PaginatedData<NotificationData>>().toBuilder()
        ..updateDoorbellSchedule = ApiState<void>().toBuilder()
        ..unReadNotificationApi =
            ApiState<PaginatedData<NotificationData>>().toBuilder()
        ..notificationDeviceStatus = null,
    );
  }

  @override
  Future<void> close() async {
    await _controller?.close();
    _controller = null;
    await Future.value();
  }

  @override
  Future<void> callNotificationApi({
    dynamic justPaginate = false,
    dynamic refresh = false,
    dynamic isRead = 1,
    dynamic isExternalCamera = false,
  }) async {
    // This method needs to be mockable for verification
    super.noSuchMethod(
      Invocation.method(#callNotificationApi, [], {
        #justPaginate: justPaginate,
        #refresh: refresh,
        #isRead: isRead,
        #isExternalCamera: isExternalCamera,
      }),
    );
  }

  @override
  Future<void> markAllAsRead({shouldNew = true}) async {
    // This method needs to be mockable for verification
    super.noSuchMethod(
      Invocation.method(#markAllAsRead, [], {#shouldNew: shouldNew}),
    );
  }

  @override
  Future<void> callDevicesApi({context}) async {
    // This method needs to be mockable for verification
    super.noSuchMethod(
      Invocation.method(#callDevicesApi, [], {#context: context}),
    );
  }

  @override
  Future<void> resetFilters() async {
    // This method needs to be mockable for verification
    super.noSuchMethod(Invocation.method(#resetFilters, []));
  }

  @override
  Future<void> attachScrollController() async {
    // This method needs to be mockable for verification
    super.noSuchMethod(Invocation.method(#attachScrollController, []));
  }

  @override
  GlobalKey notificationFilterGuideKey = GlobalKey();
  @override
  GlobalKey audioCallGuideKey = GlobalKey();
  @override
  GlobalKey videoCallGuideKey = GlobalKey();
  @override
  GlobalKey chatGuideKey = GlobalKey();

  @override
  GlobalKey getCurrentGuide() => GlobalKey();

  @override
  void updateFilter(bool filter) {
    // This method needs to be mockable for verification
    super.noSuchMethod(Invocation.method(#updateFilter, [filter]));
  }

  @override
  void updateNoDeviceAvailable(String noDeviceAvailable) {
    // This method needs to be mockable for verification
    super.noSuchMethod(
      Invocation.method(#updateNoDeviceAvailable, [noDeviceAvailable]),
    );
  }

  @override
  void updateFilterParam(String filterParam) {
    // This method needs to be mockable for verification
    super.noSuchMethod(Invocation.method(#updateFilterParam, [filterParam]));
  }

  @override
  void updateNotificationGuideShow(bool notificationGuideShow) {
    // This method needs to be mockable for verification
    super.noSuchMethod(
      Invocation.method(
        #updateNotificationGuideShow,
        [notificationGuideShow],
      ),
    );
  }

  @override
  void updateCurrentGuideKey(String currentGuideKey) {
    // This method needs to be mockable for verification
    super.noSuchMethod(
      Invocation.method(#updateCurrentGuideKey, [currentGuideKey]),
    );
  }

  @override
  void setTempList() {
    // This method needs to be mockable for verification
    super.noSuchMethod(Invocation.method(#setTempList, []));
  }

  @override
  void lastUpdated(int index) {
    // This method needs to be mockable for verification
    super.noSuchMethod(Invocation.method(#lastUpdated, [index]));
  }
}

class MockDoorbellManagementBloc extends Mock
    implements DoorbellManagementBloc {
  @override
  Future<void> close() async {}
}

class MockStatisticsBloc extends Mock implements StatisticsBloc {
  @override
  Future<void> close() async {}
}

// Mock classes
class MockUserManagementBloc extends Mock implements UserManagementBloc {
  MockUserManagementBloc([UserManagementState? state])
      : _state = state ?? UserManagementState();
  UserManagementState _state;
  set state(UserManagementState value) => _state = value;
  @override
  UserManagementState get state => _state;
  @override
  Stream<UserManagementState> get stream =>
      const Stream<UserManagementState>.empty();
  @override
  Future<void> close() async {}
}

class MockSubscriptionBloc extends Mock implements SubscriptionBloc {
  SubscriptionState? _state;
  StreamController<SubscriptionState>? _controller;

  @override
  Stream<SubscriptionState> get stream =>
      _controller?.stream ?? const Stream<SubscriptionState>.empty();

  @override
  SubscriptionState get state => _state ?? _createDefaultState();

  set state(SubscriptionState state) {
    _state = state;
    if (_controller == null || _controller!.isClosed) {
      _controller = StreamController<SubscriptionState>.broadcast();
    }
    _controller!.add(state);
  }

  SubscriptionState _createDefaultState() {
    return SubscriptionState(
      (b) => b
        ..downloadingPDF = false
        ..paymentMethodsList.replace([])
        ..transactionHistoryList.replace([])
        ..transactionFilter = null
        ..paymentMethodsApi = ApiState<void>().toBuilder()
        ..defaultPaymentMethodApi = ApiState<void>().toBuilder()
        ..deletePaymentMethodApi = ApiState<void>().toBuilder()
        ..transactionHistoryApi = ApiState<void>().toBuilder(),
    );
  }

  @override
  Future<void> close() async {
    await _controller?.close();
    _controller = null;
    await Future.value();
  }
}

class MockThemeBloc extends Mock implements ThemeBloc {
  ThemeState? _state;
  StreamController<ThemeState>? _controller;
  static MockThemeState? _defaultState;

  static MockThemeState _getDefaultState() {
    if (_defaultState == null) {
      _defaultState = MockThemeState();
      // Configure the default mock state
      when(() => _defaultState!.simpleThemesError).thenReturn('');
      when(() => _defaultState!.activeType).thenReturn('Feed');
      when(() => _defaultState!.canPop).thenReturn(true);
      when(() => _defaultState!.uploadOnDoorBell).thenReturn(false);
      when(() => _defaultState!.isDetailThemePage).thenReturn(false);
      when(() => _defaultState!.search).thenReturn('');
      when(() => _defaultState!.aiError).thenReturn('');
      when(() => _defaultState!.aiThemeText).thenReturn('');
      when(() => _defaultState!.selectedDoorBell).thenReturn(null);
      when(() => _defaultState!.generatedImage).thenReturn(null);
      when(() => _defaultState!.categorySelectedValue).thenReturn(null);
      when(() => _defaultState!.themeId).thenReturn(null);
      when(() => _defaultState!.categoryId).thenReturn(null);
      when(() => _defaultState!.apiCategoryId).thenReturn(null);
      when(() => _defaultState!.themeNameField).thenReturn('');
      when(() => _defaultState!.index).thenReturn(0);
    }
    return _defaultState!;
  }

  @override
  Future<void> close() async {
    await _controller?.close();
    _controller = null;
    await Future.value();
  }

  @override
  ThemeState get state => _state ?? _getDefaultState();

  set state(ThemeState state) {
    _state = state;
    // Create a enew controller if it was closed or doesn't exist
    if (_controller == null || _controller!.isClosed) {
      _controller = StreamController<ThemeState>.broadcast();
    }
    _controller!.add(state);
  }

  @override
  Stream<ThemeState> get stream =>
      _controller?.stream ?? const Stream<ThemeState>.empty();
}
