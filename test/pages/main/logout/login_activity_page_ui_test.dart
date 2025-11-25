import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/theme.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/logout/bloc/logout_bloc.dart';
import 'package:admin/pages/main/logout/bloc/logout_state.dart';
import 'package:admin/pages/main/logout/login_activity_page.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/logout_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/user_profile_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/voice_control_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';

void main() {
  late LogoutBlocTestHelper logoutBlocHelper;
  late UserProfileBlocTestHelper userProfileBlocHelper;
  late VoiceControlBlocTestHelper voiceControlBlocHelper;
  late StartupBlocTestHelper startupBlocHelper;

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    await TestHelper.initialize();

    logoutBlocHelper = LogoutBlocTestHelper();
    userProfileBlocHelper = UserProfileBlocTestHelper();
    voiceControlBlocHelper = VoiceControlBlocTestHelper();
    startupBlocHelper = StartupBlocTestHelper();

    logoutBlocHelper.setup();
    userProfileBlocHelper.setup();
    voiceControlBlocHelper.setup();
    startupBlocHelper.setup();

    // Mock the updatePasswordErrorMessage method
    when(
      () => userProfileBlocHelper.mockUserProfileBloc
          .updatePasswordErrorMessage(any()),
    ).thenReturn(null);

    // Register fallback values
    registerFallbackValue(LogoutState());
    registerFallbackValue(ApiState<void>());
  });

  tearDownAll(() async {
    userProfileBlocHelper.dispose();
    voiceControlBlocHelper.dispose();
    await TestHelper.cleanup();
  });

  Widget createTestWidget({bool isNavigated = false}) {
    return FlutterSizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<LogoutBloc>.value(
              value: logoutBlocHelper.mockLogoutBloc,
            ),
            BlocProvider<UserProfileBloc>.value(
              value: userProfileBlocHelper.mockUserProfileBloc,
            ),
            BlocProvider<VoiceControlBloc>.value(
              value: voiceControlBlocHelper.mockVoiceControlBloc,
            ),
            BlocProvider<StartupBloc>.value(
              value: startupBlocHelper.getMockStartupBloc(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            theme: getTheme(),
            darkTheme: darkTheme(),
            home: const LoginActivityPage(),
          ),
        );
      },
    );
  }

  group('LoginActivityPage UI Tests', () {
    testWidgets('should display app bar with correct title', (tester) async {
      // Arrange
      logoutBlocHelper.setupDefaultState();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Login Activity'), findsOneWidget);
    });

    testWidgets('should display "Logins" section header', (tester) async {
      // Arrange
      logoutBlocHelper.setupDefaultState();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Logins'), findsOneWidget);
    });

    testWidgets('should show loading indicator when API is in progress',
        (tester) async {
      // Arrange
      logoutBlocHelper.setupWithLoadingState();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester
          .pump(); // Use pump instead of pumpAndSettle for loading state

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'should show "No records available" when login activities is null',
        (tester) async {
      // Arrange
      logoutBlocHelper.setupWithEmptySessions();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No records available.'), findsOneWidget);
    });

    testWidgets(
        'should show "No records available" when login activities is empty',
        (tester) async {
      // Arrange
      logoutBlocHelper.setupWithEmptySessions();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No records available.'), findsOneWidget);
    });

    testWidgets('should display login activity cards when data is available',
        (tester) async {
      // Arrange
      logoutBlocHelper.setupWithMultipleSessions();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Android'),
        findsNWidgets(2),
      ); // Current device and default session
      expect(find.text('iOS'), findsOneWidget); // Logged out session
      expect(
        find.text('Current Session'),
        findsNWidgets(2),
      ); // Both Android sessions are current
      expect(
        find.text('Active Session'),
        findsNothing,
      ); // No active sessions (different device tokens)
    });

    testWidgets(
        'should show logout all sessions button when activities are available',
        (tester) async {
      // Arrange
      logoutBlocHelper.setupDefaultState();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Logout of all Sessions'), findsOneWidget);
    });

    testWidgets('should not show logout all sessions button when no activities',
        (tester) async {
      // Arrange
      logoutBlocHelper.setupWithEmptySessions();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Logout All Sessions'), findsNothing);
    });

    testWidgets(
        'should not show logout all sessions button when API is in progress',
        (tester) async {
      // Arrange
      logoutBlocHelper.setupWithLoadingState();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester
          .pump(); // Use pump instead of pumpAndSettle for loading state

      // Assert
      expect(find.text('Logout All Sessions'), findsNothing);
    });

    testWidgets('should support pull to refresh', (tester) async {
      // Arrange
      logoutBlocHelper.setupWithEmptySessions();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Perform pull to refresh
      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
      await tester.pumpAndSettle();

      // Assert
      verify(
        () => logoutBlocHelper.mockLogoutBloc.callOnRefreshLoginActivities(),
      ).called(1);
    });

    testWidgets('should display device icons in activity cards',
        (tester) async {
      // Arrange
      logoutBlocHelper.setupDefaultState();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(CupertinoIcons.device_phone_portrait), findsOneWidget);
    });

    testWidgets('should display more options icon in activity cards',
        (tester) async {
      // Arrange
      logoutBlocHelper.setupDefaultState();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('should handle expired session status correctly',
        (tester) async {
      // Arrange
      logoutBlocHelper.setupWithMultipleSessions();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('logged_out'), findsOneWidget);
    });

    testWidgets('should handle current device session correctly',
        (tester) async {
      // Arrange
      logoutBlocHelper.setupWithMultipleSessions();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Current Session'),
        findsNWidgets(2),
      ); // Both Android sessions are current
    });

    testWidgets('should handle active session correctly', (tester) async {
      // Arrange
      logoutBlocHelper.setupWithActiveSession();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Active Session'),
        findsOneWidget,
      ); // One active session in this setup
    });
  });
}
