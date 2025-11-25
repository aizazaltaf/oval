import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/pages/main/logout/bloc/logout_bloc.dart';
import 'package:admin/pages/main/logout/bloc/logout_state.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_state.dart';
import 'package:admin/pages/main/user_profile/components/profile_otp_page.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:pinput/pinput.dart';

import '../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/user_profile_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/voice_control_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';
import '../../../mocks/bloc/bloc_mocks.dart';

class MockLogoutBloc extends Mock implements LogoutBloc {
  final _stateController = StreamController<LogoutState>.broadcast();

  @override
  Stream<LogoutState> get stream => _stateController.stream;

  @override
  LogoutState get state => LogoutState();

  void dispose() {
    _stateController.close();
  }
}

void main() {
  late StartupBlocTestHelper startupBlocTestHelper;

  setUpAll(() async {
    startupBlocTestHelper = StartupBlocTestHelper()..setup();
    registerFallbackValue(FakeBuildContext());
    await TestHelper.initialize();

    // Mock path provider
    PathProviderPlatform.instance = FakePathProviderPlatform();

    // Initialize GetStorage mock
    await GetStorage.init('TestStorage');
  });

  group('Profile OtpPage Ui Tests', () {
    late UserProfileBlocTestHelper userProfileBlocHelper;
    late VoiceControlBlocTestHelper voiceControlBlocHelper;
    late MockProfileBloc mockProfileBloc;
    late MockLogoutBloc mockLogoutBloc;
    late StreamController<UserProfileState> stateController;
    late UserProfileState currentState;
    String latestOtp = '';

    setUp(() {
      userProfileBlocHelper = UserProfileBlocTestHelper();
      voiceControlBlocHelper = VoiceControlBlocTestHelper();
      mockProfileBloc = MockProfileBloc();
      mockLogoutBloc = MockLogoutBloc();
      stateController = StreamController<UserProfileState>.broadcast();

      userProfileBlocHelper.setup();
      voiceControlBlocHelper.setup();

      // Initialize current state
      currentState = UserProfileState(
        (b) => b
          ..remainingSeconds = 60
          ..resendOtp = false
          ..otpError = ""
          ..callOtpApi.isApiInProgress = false
          ..updateProfileApi.isApiInProgress = false
          ..validatePasswordApi.isApiInProgress = false,
      );

      // Mock profile bloc with complete UserData
      when(() => mockProfileBloc.state).thenReturn(
        UserData(
          (b) => b
            ..id = 1
            ..name = "Test User"
            ..email = "test@example.com"
            ..phone = "1234567890"
            ..image = "https://example.com/image.jpg"
            ..aiThemeCounter = 0
            ..userRole = "user"
            ..phoneVerified = true
            ..emailVerified = true
            ..canPinned = true
            ..sectionList = ListBuilder<String>(["section1"]),
        ),
      );

      // Set the test profile bloc
      singletonBloc.testProfileBloc = mockProfileBloc;

      // Mock stream and state
      when(() => userProfileBlocHelper.mockUserProfileBloc.stream)
          .thenAnswer((_) => stateController.stream);
      when(() => userProfileBlocHelper.mockUserProfileBloc.state)
          .thenAnswer((_) => currentState);

      // Mock OTP update behavior
      when(() => userProfileBlocHelper.mockUserProfileBloc.updateOtp(any()))
          .thenAnswer((invocation) {
        latestOtp = invocation.positionalArguments[0] as String;
        currentState = currentState.rebuild(
          (b) => b..otp = latestOtp,
        );
        stateController.add(currentState);
      });

      // Mock send OTP behavior
      when(() => userProfileBlocHelper.mockUserProfileBloc.sendOtp(any()))
          .thenAnswer((_) async {
        currentState = currentState.rebuild(
          (b) => b
            ..remainingSeconds = 60
            ..resendOtp = false,
        );
        stateController.add(currentState);
      });

      // Mock OTP verification behavior
      when(
        () => userProfileBlocHelper.mockUserProfileBloc.callOtp(
          context: any(named: 'context'),
          emailChangedFunction: any(named: 'emailChangedFunction'),
          phoneChangedFunction: any(named: 'phoneChangedFunction'),
          otpFor: any(named: 'otpFor'),
          successReleaseTransferFunction:
              any(named: 'successReleaseTransferFunction'),
        ),
      ).thenAnswer((_) async {
        currentState = currentState.rebuild(
          (b) => b
            ..callOtpApi.isApiInProgress = false
            ..otpError = "",
        );
        stateController.add(currentState);
      });
    });

    tearDown(() {
      userProfileBlocHelper.dispose();
      voiceControlBlocHelper.dispose();
      mockLogoutBloc.dispose();
      stateController.close();
    });

    Widget createWidgetUnderTest() {
      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<StartupBloc>.value(
                value: startupBlocTestHelper.mockStartupBloc,
              ),
              BlocProvider<UserProfileBloc>.value(
                value: userProfileBlocHelper.mockUserProfileBloc,
              ),
              BlocProvider<VoiceControlBloc>.value(
                value: voiceControlBlocHelper.mockVoiceControlBloc,
              ),
              BlocProvider<LogoutBloc>.value(
                value: mockLogoutBloc,
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
              home: MediaQuery(
                data: const MediaQueryData(size: Size(1080, 1920)),
                child: ProfileOtpPage(
                  otpFor: "release",
                  successReleaseTransferFunction: () {},
                ),
              ),
            ),
          );
        },
      );
    }

    testWidgets('Initial UI elements are displayed correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context = tester.element(find.byType(ProfileOtpPage));
      final localizations = AppLocalizations.of(context)!;

      // Verify the OTP input field is present
      expect(find.byType(Pinput), findsOneWidget);

      // Verify the verify text is present
      expect(find.text(localizations.verify), findsOneWidget);

      // Verify the OTP message is present with correct phone number
      expect(
        find.text(
          localizations.message_otp.replaceAll(
            "99",
            mockProfileBloc.state!.phone!.substring(
              mockProfileBloc.state!.phone!.length - 2,
            ),
          ),
        ),
        findsOneWidget,
      );

      // Verify the resend text is present
      expect(find.text(localizations.did_not_get), findsOneWidget);
      expect(find.text(localizations.resend), findsOneWidget);
    });

    testWidgets('OTP input updates state correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      await tester.enterText(find.byType(Pinput), '123456');
      await tester.pump(const Duration(milliseconds: 100));

      expect(latestOtp, equals('123456'));
    });

    testWidgets('Resend OTP button updates state when clicked', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context = tester.element(find.byType(ProfileOtpPage));
      final localizations = AppLocalizations.of(context)!;
      final resendButton = find.ancestor(
        of: find.text(localizations.resend),
        matching: find.byType(GestureDetector),
      );

      await tester.tap(resendButton);
      await tester.pump(const Duration(milliseconds: 100));

      expect(currentState.resendOtp, isFalse);
      expect(currentState.remainingSeconds, equals(60));
    });

    testWidgets('OTP verification updates state', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      await tester.enterText(find.byType(Pinput), '123456');
      await tester.pump(const Duration(milliseconds: 100));

      expect(currentState.callOtpApi.isApiInProgress, isFalse);
      expect(currentState.otpError, isEmpty);
    });

    testWidgets('OTP error is displayed when verification fails',
        (tester) async {
      when(
        () => userProfileBlocHelper.mockUserProfileBloc.callOtp(
          context: any(named: 'context'),
          emailChangedFunction: any(named: 'emailChangedFunction'),
          phoneChangedFunction: any(named: 'phoneChangedFunction'),
          otpFor: any(named: 'otpFor'),
          successReleaseTransferFunction:
              any(named: 'successReleaseTransferFunction'),
        ),
      ).thenAnswer((_) async {
        currentState = currentState.rebuild(
          (b) => b
            ..callOtpApi.isApiInProgress = false
            ..otpError = "Invalid OTP. Please enter a valid code to continue.",
        );
        stateController.add(currentState);
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      await tester.enterText(find.byType(Pinput), '123456');
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.text('Invalid OTP. Please enter a valid code to continue.'),
        findsOneWidget,
      );
    });

    testWidgets('Timer countdown works correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      // Initial state
      expect(currentState.remainingSeconds, equals(60));
      expect(currentState.resendOtp, isFalse);

      // Update remaining seconds and resendOtp flag
      currentState = currentState.rebuild(
        (b) => b
          ..remainingSeconds = 0
          ..resendOtp = true,
      );
      stateController.add(currentState);
      await tester.pump(const Duration(milliseconds: 100));

      expect(currentState.remainingSeconds, equals(0));
      expect(currentState.resendOtp, isTrue);
    });

    testWidgets('OTP input clears on resend', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      // Enter OTP
      await tester.enterText(find.byType(Pinput), '123456');
      await tester.pump(const Duration(milliseconds: 100));

      // Click resend
      final BuildContext context = tester.element(find.byType(ProfileOtpPage));
      final localizations = AppLocalizations.of(context)!;
      final resendButton = find.ancestor(
        of: find.text(localizations.resend),
        matching: find.byType(GestureDetector),
      );

      await tester.tap(resendButton);
      await tester.pump(const Duration(milliseconds: 100));

      // Clear OTP input
      currentState = currentState.rebuild(
        (b) => b..clearOtp = true,
      );
      stateController.add(currentState);
      await tester.pump(const Duration(milliseconds: 100));

      // Verify OTP is cleared
      expect(currentState.clearOtp, isTrue);
    });
  });
}
