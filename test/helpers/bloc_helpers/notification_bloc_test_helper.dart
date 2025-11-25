import 'package:admin/models/data/notification_data.dart';
import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/notifications/bloc/notification_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/bloc/bloc_mocks.dart';
import '../../mocks/bloc/state_mocks.dart';

class NotificationBlocTestHelper {
  late MockNotificationBloc mockNotificationBloc;
  late NotificationState currentNotificationState;

  void setup() {
    mockNotificationBloc = MockNotificationBloc();
    currentNotificationState = MockNotificationState();

    // The stream is already implemented in MockNotificationBloc, no need to mock it
    // Set the state using the setter instead of trying to mock the getter
    mockNotificationBloc.state = currentNotificationState;

    // Setup default state properties
    setupDefaultState();
  }

  void setupDefaultState() {
    // Stub all required NotificationState properties
    when(() => currentNotificationState.newNotification).thenReturn(false);
    when(() => currentNotificationState.notificationDeviceStatus)
        .thenReturn({});
    when(() => currentNotificationState.filter).thenReturn(false);
    when(() => currentNotificationState.filterParam).thenReturn('');
    when(() => currentNotificationState.deviceId).thenReturn('');
    when(() => currentNotificationState.noDeviceAvailable).thenReturn('');
    when(() => currentNotificationState.currentGuideKey).thenReturn('');
    when(() => currentNotificationState.notificationGuideShow)
        .thenReturn(false);
    when(() => currentNotificationState.customDate).thenReturn(null);
    when(() => currentNotificationState.dateFilters)
        .thenReturn(BuiltList<FeatureModel>([]));
    when(() => currentNotificationState.aiAlertsFilters)
        .thenReturn(BuiltList<FeatureModel>([]));
    when(() => currentNotificationState.aiAlertsSubFilters)
        .thenReturn(BuiltList<FeatureModel>([]));
    when(() => currentNotificationState.deviceFilters)
        .thenReturn(BuiltList<FeatureModel>([]));

    // Create mock API states
    final mockNotificationApi = MockApiState();
    when(() => mockNotificationApi.data).thenReturn(null);
    when(() => mockNotificationApi.isApiInProgress).thenReturn(false);
    when(() => currentNotificationState.notificationApi)
        .thenReturn(ApiState<PaginatedData<NotificationData>>());

    final mockUnReadNotificationApi = MockApiState();
    when(() => mockUnReadNotificationApi.data).thenReturn(null);
    when(() => mockUnReadNotificationApi.isApiInProgress).thenReturn(false);
    when(() => currentNotificationState.unReadNotificationApi)
        .thenReturn(ApiState<PaginatedData<NotificationData>>());

    // Additional properties for comprehensive coverage
    when(() => currentNotificationState.updateDoorbellSchedule)
        .thenReturn(ApiState<void>());
  }

  void setupWithNotifications() {
    // Setup state with some notifications
    when(() => currentNotificationState.newNotification).thenReturn(true);
    when(() => currentNotificationState.notificationDeviceStatus)
        .thenReturn({});
    when(() => currentNotificationState.unReadNotificationApi)
        .thenReturn(ApiState<PaginatedData<NotificationData>>());
  }

  void setupWithFilters() {
    // Setup state with active filters
    when(() => currentNotificationState.filter).thenReturn(true);
    when(() => currentNotificationState.filterParam).thenReturn('test_filter');
    when(() => currentNotificationState.deviceId).thenReturn('test_device');
  }

  void dispose() {
    // No stream controller to dispose
  }
}
