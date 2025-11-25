import 'package:flutter_test/flutter_test.dart';

import '../bloc_helpers/logout_bloc_test_helper.dart';

void main() {
  group('LogoutBlocTestHelper', () {
    late LogoutBlocTestHelper helper;

    setUp(() {
      helper = LogoutBlocTestHelper()..setup();
    });

    test('should setup default state correctly', () {
      expect(helper.mockLogoutBloc, isNotNull);
      expect(helper.currentState, isNotNull);
      expect(
        helper.currentState.currentDeviceToken,
        equals('test_device_token_123'),
      );
      expect(helper.currentState.loginActivities, isNotNull);
      expect(helper.currentState.loginActivityApi, isNotNull);
    });

    test('should create default login session correctly', () {
      final session = helper.createDefaultLoginSession();
      expect(session.id, equals(1));
      expect(session.userId, equals(1));
      expect(session.deviceType, equals('Android'));
      expect(session.deviceToken, equals('test_device_token_123'));
      expect(session.status, isNull);
    });

    test('should create logged out session correctly', () {
      final session = helper.createLoggedOutSession();
      expect(session.id, equals(2));
      expect(session.status, equals('logged_out'));
      expect(session.logoutDevice, equals('manual'));
      expect(session.logoutTime, isNotNull);
    });

    test('should create current device session correctly', () {
      final session = helper.createCurrentDeviceSession();
      expect(session.deviceToken, equals('test_device_token_123'));
      expect(session.status, isNull);
      expect(session.logoutTime, isNull);
    });

    test('should setup multiple sessions correctly', () {
      helper.setupWithMultipleSessions();
      final activities = helper.currentState.loginActivities;
      expect(activities, isNotNull);
      expect(activities!.length, equals(3));
    });

    test('should setup loading state correctly', () {
      helper.setupWithLoadingState();
      expect(helper.currentState.loginActivityApi.isApiInProgress, isTrue);
    });

    test('should setup error state correctly', () {
      helper.setupWithErrorState();
      expect(helper.currentState.loginActivityApi.isApiInProgress, isFalse);
      expect(
        helper.currentState.loginActivityApi.message,
        equals('Failed to load login activities'),
      );
    });

    test('should setup logout loading state correctly', () {
      helper.setupWithLogoutLoadingState();
      expect(
        helper.currentState.logoutOfSpecificDeviceApi.isApiInProgress,
        isTrue,
      );
      expect(helper.currentState.logoutAllSessionsApi.isApiInProgress, isTrue);
    });

    test('should setup empty sessions correctly', () {
      helper.setupWithEmptySessions();
      expect(helper.currentState.loginActivities!.isEmpty, isTrue);
    });

    test('should setup no current device token correctly', () {
      helper.setupWithNoCurrentDeviceToken();
      expect(helper.currentState.currentDeviceToken, equals(''));
    });

    test('should create sorted sessions correctly', () {
      final sessions = helper.createSortedSessions();
      expect(sessions.length, equals(3));
      // Current device session should be first
      expect(sessions.first.deviceToken, equals('test_device_token_123'));
      expect(sessions.first.status, isNull);
    });

    test('should setup method mocks correctly', () {
      helper.setupMethodMocks();
      // Verify that methods are mocked (no exceptions thrown)
      expect(helper.mockLogoutBloc, isNotNull);
    });
  });
}
