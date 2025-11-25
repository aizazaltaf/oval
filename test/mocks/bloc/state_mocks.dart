import 'package:admin/bloc/states/startup_state.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/auth/login/bloc/login_state.dart';
import 'package:admin/pages/main/doorbell_management/bloc/doorbell_management_state.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_state.dart';
import 'package:admin/pages/main/logout/bloc/logout_state.dart';
import 'package:admin/pages/main/notifications/bloc/notification_state.dart';
import 'package:admin/pages/main/statistics/bloc/statistics_state.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_state.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_state.dart';
import 'package:admin/pages/main/user_profile/bloc/change_password_state.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_state.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_state.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_state.dart';
import 'package:admin/pages/main/voip/bloc/voip_state.dart';
import 'package:admin/pages/themes/bloc/theme_state.dart';
import 'package:mocktail/mocktail.dart';

class MockApiState extends Mock implements ApiState<void> {}

class MockLoginState extends Mock implements LoginState {}

class MockIotState extends Mock implements IotState {}

class MockUserProfileState extends Mock implements UserProfileState {}

class MockChangePasswordState extends Mock implements ChangePasswordState {}

class MockVoiceControlState extends Mock implements VoiceControlState {}

class MockLogoutState extends Mock implements LogoutState {}

class MockStartupState extends Mock implements StartupState {}

class MockVisitorManagementState extends Mock
    implements VisitorManagementState {}

class MockNotificationState extends Mock implements NotificationState {}

class MockDoorbellManagementState extends Mock
    implements DoorbellManagementState {
  // Create mock API states that can be properly stubbed
  final MockApiState scanDoorBellApiMock = MockApiState();
  final MockApiState createLocationApiMock = MockApiState();
  final MockApiState assignDoorbellApiMock = MockApiState();
  final MockApiState updateLocationApiMock = MockApiState();

  @override
  ApiState<void> get scanDoorBellApi => scanDoorBellApiMock;

  @override
  ApiState<void> get createLocationApi => createLocationApiMock;

  @override
  ApiState<void> get assignDoorbellApi => assignDoorbellApiMock;

  @override
  ApiState<void> get updateLocationApi => updateLocationApiMock;
}

class MockVoipState extends Mock implements VoipState {}

class MockStatisticsState extends Mock implements StatisticsState {}

class MockUserManagementState extends Mock implements UserManagementState {}

class MockThemeState extends Mock implements ThemeState {}

class MockSubscriptionState extends Mock implements SubscriptionState {}
