import 'dart:async';

import 'package:admin/models/data/login_session_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/bloc/bloc_mocks.dart';
import '../../mocks/bloc/state_mocks.dart';

class LogoutBlocTestHelper {
  late MockLogoutBloc mockLogoutBloc;
  late MockLogoutState currentState;

  void setup() {
    mockLogoutBloc = MockLogoutBloc();
    currentState = MockLogoutState();

    when(() => mockLogoutBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockLogoutBloc.state).thenReturn(currentState);

    // Setup default state properties
    setupDefaultState();
    setupMethodMocks();
  }

  void setupDefaultState() {
    when(() => currentState.currentDeviceToken)
        .thenReturn('test_device_token_123');
    when(() => currentState.loginActivities).thenReturn(
      BuiltList<LoginSessionModel>([createDefaultLoginSession()]),
    );
    when(() => currentState.loginActivityApi).thenReturn(ApiState<void>());
    when(() => currentState.logoutOfSpecificDeviceApi)
        .thenReturn(ApiState<void>());
    when(() => currentState.logoutAllSessionsApi).thenReturn(ApiState<void>());
  }

  LoginSessionModel createDefaultLoginSession() {
    return LoginSessionModel(
      (b) => b
        ..id = 1
        ..userId = 1
        ..deviceType = 'Android'
        ..ipAddress = '192.168.1.1'
        ..status = null
        ..logoutDevice = null
        ..deviceToken = 'test_device_token_123'
        ..isTrusted = 1
        ..loginTime = '2024-01-01T10:00:00Z'
        ..logoutTime = null
        ..createdAt = '2024-01-01T10:00:00Z'
        ..updatedAt = '2024-01-01T10:00:00Z',
    );
  }

  LoginSessionModel createLoggedOutSession() {
    return LoginSessionModel(
      (b) => b
        ..id = 2
        ..userId = 1
        ..deviceType = 'iOS'
        ..ipAddress = '192.168.1.2'
        ..status = 'logged_out'
        ..logoutDevice = 'manual'
        ..deviceToken = 'test_device_token_456'
        ..isTrusted = 0
        ..loginTime = '2024-01-01T09:00:00Z'
        ..logoutTime = '2024-01-01T11:00:00Z'
        ..createdAt = '2024-01-01T09:00:00Z'
        ..updatedAt = '2024-01-01T11:00:00Z',
    );
  }

  LoginSessionModel createCurrentDeviceSession() {
    return LoginSessionModel(
      (b) => b
        ..id = 3
        ..userId = 1
        ..deviceType = 'Android'
        ..ipAddress = '192.168.1.3'
        ..status = null
        ..logoutDevice = null
        ..deviceToken = 'test_device_token_123' // Same as current device token
        ..isTrusted = 1
        ..loginTime = '2024-01-01T12:00:00Z'
        ..logoutTime = null
        ..createdAt = '2024-01-01T12:00:00Z'
        ..updatedAt = '2024-01-01T12:00:00Z',
    );
  }

  LoginSessionModel createActiveSession() {
    return LoginSessionModel(
      (b) => b
        ..id = 4
        ..userId = 1
        ..deviceType = 'iPhone'
        ..ipAddress = '192.168.1.4'
        ..status = null
        ..logoutDevice = null
        ..deviceToken =
            'test_device_token_789' // Different from current device token
        ..isTrusted = 1
        ..loginTime = '2024-01-01T13:00:00Z'
        ..logoutTime = null
        ..createdAt = '2024-01-01T13:00:00Z'
        ..updatedAt = '2024-01-01T13:00:00Z',
    );
  }

  void setupWithMultipleSessions() {
    when(() => currentState.currentDeviceToken)
        .thenReturn('test_device_token_123');
    when(() => currentState.loginActivities).thenReturn(
      BuiltList<LoginSessionModel>([
        createCurrentDeviceSession(), // Should be first (current device)
        createDefaultLoginSession(), // Should be second (current device - same token)
        createLoggedOutSession(), // Should be last (logged out)
      ]),
    );
    when(() => currentState.loginActivityApi).thenReturn(ApiState<void>());
    when(() => currentState.logoutOfSpecificDeviceApi)
        .thenReturn(ApiState<void>());
    when(() => currentState.logoutAllSessionsApi).thenReturn(ApiState<void>());
  }

  void setupWithActiveSession() {
    when(() => currentState.currentDeviceToken)
        .thenReturn('test_device_token_123');
    when(() => currentState.loginActivities).thenReturn(
      BuiltList<LoginSessionModel>([
        createCurrentDeviceSession(), // Current device
        createActiveSession(), // Active session (different device token, no status)
        createLoggedOutSession(), // Logged out session
      ]),
    );
    when(() => currentState.loginActivityApi).thenReturn(ApiState<void>());
    when(() => currentState.logoutOfSpecificDeviceApi)
        .thenReturn(ApiState<void>());
    when(() => currentState.logoutAllSessionsApi).thenReturn(ApiState<void>());
  }

  void setupWithLoadingState() {
    when(() => currentState.currentDeviceToken)
        .thenReturn('test_device_token_123');
    when(() => currentState.loginActivities).thenReturn(
      BuiltList<LoginSessionModel>([]),
    );
    when(() => currentState.loginActivityApi).thenReturn(
      ApiState<void>((b) => b..isApiInProgress = true),
    );
    when(() => currentState.logoutOfSpecificDeviceApi)
        .thenReturn(ApiState<void>());
    when(() => currentState.logoutAllSessionsApi).thenReturn(ApiState<void>());
  }

  void setupWithErrorState() {
    when(() => currentState.currentDeviceToken)
        .thenReturn('test_device_token_123');
    when(() => currentState.loginActivities).thenReturn(
      BuiltList<LoginSessionModel>([]),
    );
    when(() => currentState.loginActivityApi).thenReturn(
      ApiState<void>(
        (b) => b
          ..isApiInProgress = false
          ..message = 'Failed to load login activities',
      ),
    );
    when(() => currentState.logoutOfSpecificDeviceApi)
        .thenReturn(ApiState<void>());
    when(() => currentState.logoutAllSessionsApi).thenReturn(ApiState<void>());
  }

  void setupWithLogoutLoadingState() {
    when(() => currentState.currentDeviceToken)
        .thenReturn('test_device_token_123');
    when(() => currentState.loginActivities).thenReturn(
      BuiltList<LoginSessionModel>([createDefaultLoginSession()]),
    );
    when(() => currentState.loginActivityApi).thenReturn(ApiState<void>());
    when(() => currentState.logoutOfSpecificDeviceApi).thenReturn(
      ApiState<void>((b) => b..isApiInProgress = true),
    );
    when(() => currentState.logoutAllSessionsApi).thenReturn(
      ApiState<void>((b) => b..isApiInProgress = true),
    );
  }

  void setupWithEmptySessions() {
    when(() => currentState.currentDeviceToken)
        .thenReturn('test_device_token_123');
    when(() => currentState.loginActivities).thenReturn(
      BuiltList<LoginSessionModel>([]),
    );
    when(() => currentState.loginActivityApi).thenReturn(ApiState<void>());
    when(() => currentState.logoutOfSpecificDeviceApi)
        .thenReturn(ApiState<void>());
    when(() => currentState.logoutAllSessionsApi).thenReturn(ApiState<void>());
  }

  void setupWithNoCurrentDeviceToken() {
    when(() => currentState.currentDeviceToken).thenReturn('');
    when(() => currentState.loginActivities).thenReturn(
      BuiltList<LoginSessionModel>([createDefaultLoginSession()]),
    );
    when(() => currentState.loginActivityApi).thenReturn(ApiState<void>());
    when(() => currentState.logoutOfSpecificDeviceApi)
        .thenReturn(ApiState<void>());
    when(() => currentState.logoutAllSessionsApi).thenReturn(ApiState<void>());
  }

  void setupMethodMocks() {
    when(() => mockLogoutBloc.callDeviceToken()).thenAnswer((_) async {});
    when(
      () => mockLogoutBloc.callLogoutOfSpecificDevice(
        deviceToken: any(named: 'deviceToken'),
      ),
    ).thenAnswer((_) async {});
    when(() => mockLogoutBloc.callLogoutAllSessions()).thenAnswer((_) async {});
    when(() => mockLogoutBloc.callLoginActivities()).thenAnswer((_) async {});
    when(() => mockLogoutBloc.callOnRefreshLoginActivities())
        .thenAnswer((_) async {});
  }

  void setupMethodMocksWithDelays() {
    when(() => mockLogoutBloc.callDeviceToken()).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
    });
    when(
      () => mockLogoutBloc.callLogoutOfSpecificDevice(
        deviceToken: any(named: 'deviceToken'),
      ),
    ).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
    });
    when(() => mockLogoutBloc.callLogoutAllSessions()).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
    });
    when(() => mockLogoutBloc.callLoginActivities()).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 150));
    });
    when(() => mockLogoutBloc.callOnRefreshLoginActivities())
        .thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
    });
  }

  void setupMethodMocksWithErrors() {
    when(() => mockLogoutBloc.callDeviceToken())
        .thenThrow(Exception('Device token error'));
    when(
      () => mockLogoutBloc.callLogoutOfSpecificDevice(
        deviceToken: any(named: 'deviceToken'),
      ),
    ).thenThrow(Exception('Logout specific device error'));
    when(() => mockLogoutBloc.callLogoutAllSessions())
        .thenThrow(Exception('Logout all sessions error'));
    when(() => mockLogoutBloc.callLoginActivities())
        .thenThrow(Exception('Login activities error'));
    when(() => mockLogoutBloc.callOnRefreshLoginActivities())
        .thenThrow(Exception('Refresh error'));
  }

  BuiltList<LoginSessionModel> createSortedSessions() {
    final sessions = [
      createCurrentDeviceSession(), // Should be first (current device, no status)
      createDefaultLoginSession(), // Should be second (no status, different device)
      createLoggedOutSession(), // Should be last (has status)
    ];

    return BuiltList<LoginSessionModel>(sessions);
  }

  void verifyMethodCalls() {
    verify(() => mockLogoutBloc.callDeviceToken()).called(1);
    verify(() => mockLogoutBloc.callLoginActivities()).called(1);
  }

  void verifyNoMethodCalls() {
    verifyNever(() => mockLogoutBloc.callDeviceToken());
    verifyNever(
      () => mockLogoutBloc.callLogoutOfSpecificDevice(
        deviceToken: any(named: 'deviceToken'),
      ),
    );
    verifyNever(() => mockLogoutBloc.callLogoutAllSessions());
    verifyNever(() => mockLogoutBloc.callLoginActivities());
    verifyNever(() => mockLogoutBloc.callOnRefreshLoginActivities());
  }
}
