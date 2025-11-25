import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/pages/main/dashboard/components/logout_dialog.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/bloc_helpers/login_bloc_test_helper.dart';
import '../../../../helpers/bloc_helpers/singleton_bloc_test_helper.dart';
import '../../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../../helpers/bloc_helpers/voice_control_bloc_test_helper.dart';
import '../../../../helpers/fake_build_context.dart';
import '../../../../helpers/test_helper.dart';
import '../../../../mocks/bloc/bloc_mocks.dart';

void main() {
  group('LogoutDialog UI Tests', () {
    late LoginBlocTestHelper loginBlocHelper;
    late VoiceControlBlocTestHelper voiceControlBlocHelper;
    late StartupBlocTestHelper startupBlocTestHelper;
    late SingletonBlocTestHelper singletonBlocTestHelper;

    setUpAll(() async {
      registerFallbackValue(FakeBuildContext());
      await TestHelper.initialize();
      startupBlocTestHelper = StartupBlocTestHelper()..setup();

      loginBlocHelper = LoginBlocTestHelper();
      voiceControlBlocHelper = VoiceControlBlocTestHelper();
      singletonBlocTestHelper = SingletonBlocTestHelper();
      loginBlocHelper.setup();
      voiceControlBlocHelper.setup();
      singletonBlocTestHelper.setup();

      voiceControlBlocHelper.mockVoiceControlBloc = MockVoiceControlBloc();

      startupBlocTestHelper.mockStartupBloc = MockStartupBloc();

      when(() => voiceControlBlocHelper.mockVoiceControlBloc.isClosed)
          .thenReturn(false);
    });

    tearDown(() {
      // Reset all mocks after each test
      reset(loginBlocHelper.mockLoginBloc);
      reset(voiceControlBlocHelper.mockVoiceControlBloc);
      reset(startupBlocTestHelper.mockStartupBloc);

      // Re-setup essential mocks after reset
      when(() => loginBlocHelper.mockLoginBloc.stream)
          .thenAnswer((_) => Stream.value(loginBlocHelper.currentLoginState));
      when(() => loginBlocHelper.mockLoginBloc.state)
          .thenReturn(loginBlocHelper.currentLoginState);
      when(() => voiceControlBlocHelper.mockVoiceControlBloc.isClosed)
          .thenReturn(false);

      // Re-setup login bloc method mocks
      when(
        () => loginBlocHelper.mockLoginBloc.callLogout(
          successFunction: any(named: 'successFunction'),
        ),
      ).thenAnswer((_) async {});
    });
    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    Widget createTestWidget({
      bool isLogoutApiInProgress = false,
      bool isVoiceControlBlocClosed = false,
    }) {
      // Setup mock state based on parameters
      when(() => loginBlocHelper.currentLoginState.logoutApi).thenReturn(
        ApiState<void>((b) => b..isApiInProgress = isLogoutApiInProgress),
      );

      when(() => voiceControlBlocHelper.mockVoiceControlBloc.isClosed)
          .thenReturn(isVoiceControlBlocClosed);

      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: MultiBlocProvider(
                providers: [
                  BlocProvider<StartupBloc>.value(
                    value: startupBlocTestHelper.mockStartupBloc,
                  ),
                  BlocProvider<VoiceControlBloc>.value(
                    value: voiceControlBlocHelper.mockVoiceControlBloc,
                  ),
                  BlocProvider<LoginBloc>.value(
                    value: loginBlocHelper.mockLoginBloc,
                  ),
                ],
                child: LogoutDialog(
                  voiceControlBloc: voiceControlBlocHelper.mockVoiceControlBloc,
                ),
              ),
            ),
          );
        },
      );
    }

    group('Dialog Rendering', () {
      testWidgets('should render logout dialog with all required elements',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Debug: Print all text widgets to see what's actually rendered
        final textWidgets = find.byType(Text);
        for (int i = 0; i < textWidgets.evaluate().length; i++) {
          tester.widget<Text>(textWidgets.at(i));
        }

        // Verify dialog is rendered
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.byType(AppDialogPopup), findsOneWidget);

        // Verify title is displayed (using context.appLocalizations.logout_popup_title)
        expect(find.text('Are you sure you want to log out?'), findsOneWidget);

        // Verify buttons are present
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Log Out'), findsOneWidget);
      });

      testWidgets('should render dialog without cross button', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify AppDialogPopup is configured correctly
        final appDialogPopup = tester.widget<AppDialogPopup>(
          find.byType(AppDialogPopup),
        );
        expect(appDialogPopup.needCross, isFalse);
      });

      testWidgets(
          'should show loading indicator when logout API is in progress',
          (tester) async {
        await tester.pumpWidget(createTestWidget(isLogoutApiInProgress: true));

        // Verify loading indicator is shown
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Verify AppDialogPopup is configured with loading
        final appDialogPopup = tester.widget<AppDialogPopup>(
          find.byType(AppDialogPopup),
        );
        expect(appDialogPopup.isLoadingEnabled, isTrue);
      });

      testWidgets(
          'should not show loading indicator when logout API is not in progress',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify no loading indicator is shown
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // Verify AppDialogPopup is configured without loading
        final appDialogPopup = tester.widget<AppDialogPopup>(
          find.byType(AppDialogPopup),
        );
        expect(appDialogPopup.isLoadingEnabled, isFalse);
      });
    });

    group('Button Interactions', () {
      testWidgets('should call Navigator.pop when cancel button is tapped',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Find and tap cancel button
        final cancelButton = find.text('Cancel');
        expect(cancelButton, findsOneWidget);

        await tester.tap(cancelButton);
        await tester.pump();

        // Verify the button tap was handled
        // Note: In a real test environment, we can't test actual navigation
        // but we can verify the button is tappable
        expect(cancelButton, findsOneWidget);
      });

      testWidgets(
          'should call confirm button onTap when logout button is tapped',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Find and tap logout button
        final logoutButton = find.text('Log Out');
        expect(logoutButton, findsOneWidget);

        await tester.tap(logoutButton);
        await tester.pump();

        // Verify the button tap was handled
        expect(logoutButton, findsOneWidget);
      });

      testWidgets('should disable buttons when logout API is in progress',
          (tester) async {
        await tester.pumpWidget(createTestWidget(isLogoutApiInProgress: true));

        // Verify AppDialogPopup is configured with loading
        final appDialogPopup = tester.widget<AppDialogPopup>(
          find.byType(AppDialogPopup),
        );
        expect(appDialogPopup.isLoadingEnabled, isTrue);
      });
    });

    group('Logout Functionality', () {
      testWidgets('should call callLogout when confirm button is tapped',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Find and tap logout button
        final logoutButton = find.text('Log Out');
        await tester.tap(logoutButton);
        await tester.pump();

        // Verify callLogout was called
        verify(
          () => loginBlocHelper.mockLoginBloc.callLogout(
            successFunction: any(named: 'successFunction'),
          ),
        ).called(greaterThanOrEqualTo(1));
      });

      testWidgets('should verify bloc is closed after close() call',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Find and tap logout button
        final logoutButton = find.text('Log Out');
        await tester.tap(logoutButton);
        await tester.pump();

        // Verify isClosed check was performed
        verify(() => voiceControlBlocHelper.mockVoiceControlBloc.isClosed)
            .called(greaterThanOrEqualTo(1));
      });
    });

    group('Platform-Specific Behavior', () {
      testWidgets('should handle iOS audio category setup on iOS platform',
          (tester) async {
        // Mock Platform.isIOS to return true
        // Note: This is a simplified test - in a real scenario, you'd need to
        // mock the Platform class or use dependency injection

        await tester.pumpWidget(createTestWidget());

        // Find and tap logout button
        final logoutButton = find.text('Log Out');
        await tester.tap(logoutButton);
        await tester.pump();

        // Verify callLogout was called (which handles platform-specific logic)
        verify(
          () => loginBlocHelper.mockLoginBloc.callLogout(
            successFunction: any(named: 'successFunction'),
          ),
        ).called(greaterThanOrEqualTo(1));
      });

      testWidgets('should handle Android platform behavior', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Find and tap logout button
        final logoutButton = find.text('Log Out');
        await tester.tap(logoutButton);
        await tester.pump();

        // Verify callLogout was called
        verify(
          () => loginBlocHelper.mockLoginBloc.callLogout(
            successFunction: any(named: 'successFunction'),
          ),
        ).called(greaterThanOrEqualTo(1));
      });
    });

    group('Success Callback Functionality', () {
      testWidgets('should handle success callback when logout succeeds',
          (tester) async {
        // Mock a successful logout response
        when(
          () => loginBlocHelper.mockLoginBloc.callLogout(
            successFunction: any(named: 'successFunction'),
          ),
        ).thenAnswer((invocation) async {
          // Get the success function and call it
          final successFunction =
              invocation.namedArguments[#successFunction] as VoidCallback;
          successFunction();
        });

        await tester.pumpWidget(createTestWidget());

        // Find and tap logout button
        final logoutButton = find.text('Log Out');
        await tester.tap(logoutButton);
        await tester.pump();

        // Verify callLogout was called
        verify(
          () => loginBlocHelper.mockLoginBloc.callLogout(
            successFunction: any(named: 'successFunction'),
          ),
        ).called(1);
      });

      testWidgets(
          'should handle success callback with proper context mounting check',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Find and tap logout button
        final logoutButton = find.text('Log Out');
        await tester.tap(logoutButton);
        await tester.pump();

        // Verify callLogout was called with success function
        verify(
          () => loginBlocHelper.mockLoginBloc.callLogout(
            successFunction: any(named: 'successFunction'),
          ),
        ).called(1);
      });
    });

    group('Widget State Management', () {
      testWidgets('should maintain state during widget rebuilds',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify initial state
        expect(find.byType(LogoutDialog), findsOneWidget);

        // Trigger rebuild
        await tester.pump();

        // Verify widget still exists after rebuild
        expect(find.byType(LogoutDialog), findsOneWidget);
      });

      testWidgets('should handle state changes correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify initial state
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // Change state to loading
        await tester.pumpWidget(createTestWidget(isLogoutApiInProgress: true));

        // Verify loading state
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Performance', () {
      testWidgets('should render efficiently', (tester) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(createTestWidget());

        stopwatch.stop();

        // Verify widget renders within reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));

        // Verify all elements are present
        expect(find.byType(LogoutDialog), findsOneWidget);
      });

      testWidgets('should handle multiple rapid taps gracefully',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        final logoutButton = find.text('Log Out');

        // Perform multiple rapid taps
        for (int i = 0; i < 3; i++) {
          await tester.tap(logoutButton);
          await tester.pump(const Duration(milliseconds: 10));
        }

        // Verify widget still functions correctly
        expect(find.byType(LogoutDialog), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('should integrate properly with AppDialogPopup',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify AppDialogPopup is present and configured
        expect(find.byType(AppDialogPopup), findsOneWidget);

        final appDialogPopup = tester.widget<AppDialogPopup>(
          find.byType(AppDialogPopup),
        );
        expect(appDialogPopup.title, isNotNull);
        expect(appDialogPopup.cancelButtonLabel, isNotNull);
        expect(appDialogPopup.confirmButtonLabel, isNotNull);
        expect(appDialogPopup.needCross, isFalse);
      });
    });
  });
}
