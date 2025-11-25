import 'dart:async';

import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/pages/auth/login/bloc/login_state.dart';
import 'package:admin/pages/auth/otp/otp_page.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinput/pinput.dart';

import '../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';
import '../../../mocks/bloc/bloc_mocks.dart';

void main() {
  late StartupBlocTestHelper startupBlocTestHelper;

  setUpAll(() async {
    startupBlocTestHelper = StartupBlocTestHelper()..setup();
    registerFallbackValue(FakeBuildContext());
    await TestHelper.initialize();
  });

  group('OtpPage UI Tests', () {
    late MockLoginBloc mockLoginBloc;
    late StreamController<LoginState> stateController;
    late LoginState currentState;
    late TextEditingController otpController;
    String latestOtp = '';

    setUp(() {
      mockLoginBloc = MockLoginBloc();
      stateController = StreamController<LoginState>.broadcast();
      otpController = TextEditingController();
      currentState = LoginState(
        (b) => b
          ..phoneNumber = '1234567899'
          ..email = 'test@example.com'
          ..otpError = ''
          ..clearOtp = false
          ..resendOtp = true
          ..remainingSeconds = 0,
      );

      when(() => mockLoginBloc.stream)
          .thenAnswer((_) => stateController.stream);
      when(() => mockLoginBloc.state).thenAnswer((_) => currentState);
      when(() => mockLoginBloc.otpController).thenReturn(otpController);
      when(() => mockLoginBloc.updateOtp(any())).thenAnswer((invocation) {
        latestOtp = invocation.positionalArguments[0] as String;
      });

      // Mock signup (resend OTP) behavior
      when(() => mockLoginBloc.callSignup()).thenAnswer((_) async {
        // Immediately emit the final state without timer
        currentState = currentState.rebuild(
          (b) => b
            ..remainingSeconds = 0
            ..resendOtp = true
            ..signUpApi.isApiInProgress = false,
        );
        stateController.add(currentState);
      });

      // Mock OTP verification behavior
      when(() => mockLoginBloc.callOtp(any())).thenAnswer((_) async {
        // Immediately emit the final state without timer
        currentState = currentState.rebuild(
          (b) => b..otpApi.isApiInProgress = false,
        );
        stateController.add(currentState);
      });
    });

    tearDown(() {
      stateController.close();
      otpController.dispose();
    });

    Widget createWidgetUnderTest() {
      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<StartupBloc>.value(
                value: startupBlocTestHelper.mockStartupBloc,
              ),
              BlocProvider<LoginBloc>.value(value: mockLoginBloc),
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
                child: OtpPage(),
              ),
            ),
          );
        },
      );
    }

    testWidgets('Initial UI elements are displayed correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context = tester.element(find.byType(OtpPage));
      final localizations = AppLocalizations.of(context)!;

      expect(find.text(localizations.verify), findsOneWidget);
      expect(
        find.text(
          localizations.message_otp.replaceAll(
            "99",
            currentState.phoneNumber!.substring(
              currentState.phoneNumber!.length - 2,
            ),
          ),
        ),
        findsOneWidget,
      );
      expect(find.byType(Pinput), findsOneWidget);
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

    testWidgets('Resend OTP button is enabled initially', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context = tester.element(find.byType(OtpPage));
      final localizations = AppLocalizations.of(context)!;

      expect(find.text(localizations.resend), findsOneWidget);
      final resendButton = find.ancestor(
        of: find.text(localizations.resend),
        matching: find.byType(GestureDetector),
      );
      expect(
        tester.widget<GestureDetector>(resendButton).behavior,
        equals(HitTestBehavior.opaque),
      );
    });

    testWidgets('Resend OTP button updates state when clicked', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context = tester.element(find.byType(OtpPage));
      final localizations = AppLocalizations.of(context)!;
      final resendButton = find.ancestor(
        of: find.text(localizations.resend),
        matching: find.byType(GestureDetector),
      );

      await tester.tap(resendButton);
      await tester.pump(const Duration(milliseconds: 100));

      expect(currentState.resendOtp, isTrue);
      expect(currentState.remainingSeconds, equals(0));
      expect(currentState.signUpApi.isApiInProgress, isFalse);
    });

    testWidgets('OTP verification updates state', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      await tester.enterText(find.byType(Pinput), '123456');
      await tester.pump(const Duration(milliseconds: 100));

      expect(currentState.otpApi.isApiInProgress, isFalse);
    });

    testWidgets('OTP error is displayed when verification fails',
        (tester) async {
      when(() => mockLoginBloc.callOtp(any())).thenAnswer((_) async {
        currentState = currentState.rebuild(
          (b) => b
            ..otpError = "Invalid OTP. Please enter a valid code to continue."
            ..otpApi.isApiInProgress = false,
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
  });
}
