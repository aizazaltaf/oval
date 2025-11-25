import 'dart:async';

import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/auth/forgot_password/forgot_password.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/pages/auth/login/bloc/login_state.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/email_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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

  tearDownAll(() async {
    await TestHelper.cleanup();
  });

  group('Forgot Password Page UI Tests', () {
    late MockLoginBloc mockLoginBloc;
    late StreamController<LoginState> stateController;
    late LoginState currentState;
    String latestEmail = '';
    bool apiInProgress = false;

    bool isValidEmail(String email) {
      return RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}").hasMatch(email);
    }

    bool isForgotPasswordEnabled() {
      return isValidEmail(latestEmail);
    }

    setUp(() {
      mockLoginBloc = MockLoginBloc();
      stateController = StreamController<LoginState>.broadcast();
      currentState = LoginState();
      latestEmail = '';
      apiInProgress = false;

      when(() => mockLoginBloc.state).thenReturn(currentState);
      when(() => mockLoginBloc.stream)
          .thenAnswer((_) => stateController.stream);
      when(() => mockLoginBloc.updateEmail(any())).thenAnswer((email) {
        latestEmail = email.positionalArguments[0];
        currentState = LoginState().rebuild(
          (b) => b
            ..email = latestEmail
            ..isForgotEnabled = isForgotPasswordEnabled()
            ..forgetPasswordApi.isApiInProgress = apiInProgress,
        );
        when(() => mockLoginBloc.state).thenReturn(currentState);
        stateController.add(currentState);
      });
      when(() => mockLoginBloc.updateForgotEmail(any())).thenAnswer((email) {
        latestEmail = email.positionalArguments[0];
        currentState = LoginState().rebuild(
          (b) => b
            ..forgotEmail = latestEmail
            ..isForgotEnabled = isForgotPasswordEnabled()
            ..forgetPasswordApi.isApiInProgress = apiInProgress,
        );
        when(() => mockLoginBloc.state).thenReturn(currentState);
        stateController.add(currentState);
      });
      when(
        () => mockLoginBloc.callForgotPassword(
          successFunction: any(named: 'successFunction'),
        ),
      ).thenAnswer((_) async {
        apiInProgress = true;
        currentState = currentState.rebuild(
          (b) => b
            ..forgetPasswordApi.isApiInProgress = true
            ..isForgotEnabled = false,
        );
        when(() => mockLoginBloc.state).thenReturn(currentState);
        stateController.add(currentState);
        await Future.delayed(const Duration(milliseconds: 100));
        apiInProgress = false;
        currentState = currentState.rebuild(
          (b) => b
            ..forgetPasswordApi.isApiInProgress = false
            ..isForgotEnabled = isForgotPasswordEnabled(),
        );
        when(() => mockLoginBloc.state).thenReturn(currentState);
        stateController.add(currentState);
      });
      when(
        () => mockLoginBloc.callValidateEmail(
          successFunction: any(named: 'successFunction'),
        ),
      ).thenAnswer((invocation) async {
        final successFunction = invocation
            .namedArguments[const Symbol('successFunction')] as Function?;
        if (successFunction != null) {
          await successFunction();
        }
      });
    });

    tearDown(() {
      stateController.close();
    });

    Widget createTestWidget() {
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
              home: Scaffold(
                body: MediaQuery(
                  data: const MediaQueryData(size: Size(1080, 1920)),
                  child: ForgotPasswordPage(),
                ),
              ),
            ),
          );
        },
      );
    }

    testWidgets('Initial UI elements are displayed correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      final BuildContext context =
          tester.element(find.byType(ForgotPasswordPage));
      final localizations = AppLocalizations.of(context)!;

      expect(find.text(localizations.enter_email_verification), findsOneWidget);
      expect(find.text(localizations.login_email), findsOneWidget);
      expect(find.byType(EmailTextFormField), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text
                  .toPlainText()
                  .contains(localizations.remember_password),
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains(localizations.login_btnDone),
        ),
        findsOneWidget,
      );
    });

    testWidgets('App title is displayed correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context =
          tester.element(find.byType(ForgotPasswordPage));
      final localizations = AppLocalizations.of(context)!;

      expect(find.text(localizations.forgotPassword), findsOneWidget);
    });

    testWidgets('Back icon is shown', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      tester.element(find.byType(ForgotPasswordPage));

      // Since showBackIcon is false, there should be no back button
      expect(find.byIcon(Icons.keyboard_arrow_left), findsOneWidget);
    });

    testWidgets('NoGlowListViewWrapper is present', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(NoGlowListViewWrapper), findsOneWidget);
    });

    testWidgets('AuthScaffold is used as the main scaffold', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AuthScaffold), findsOneWidget);
    });

    testWidgets('CustomGradientButton is present in bottom navigation',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CustomGradientButton), findsOneWidget);
    });

    testWidgets('Forgot Password button is disabled initially', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      expect(currentState.isForgotEnabled, isFalse);
    });

    testWidgets('Forgot Password button enables when valid email is entered',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(EmailTextFormField),
        'test@example.com',
      );
      await tester.pump();
      expect(currentState.isForgotEnabled, isTrue);
    });

    testWidgets(
        'Forgot Password button shows loading indicator when API is in progress',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter a valid email
      await tester.enterText(
        find.byType(EmailTextFormField),
        'test@example.com',
      );
      await tester.pump();

      // Verify the button is enabled
      expect(currentState.isForgotEnabled, isTrue);

      // Tap the button
      final forgotPasswordButton = find.byType(CustomGradientButton);
      expect(forgotPasswordButton, findsOneWidget);
      await tester.tap(forgotPasswordButton);
      await tester.pump();

      // Verify API call was made
      verify(
        () => mockLoginBloc.callForgotPassword(
          successFunction: any(named: 'successFunction'),
        ),
      ).called(1);

      // Wait for state to update
      await tester.pump(const Duration(milliseconds: 50));

      // Verify loading state
      expect(currentState.forgetPasswordApi.isApiInProgress, isTrue);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for API call to complete
      await tester.pump(const Duration(milliseconds: 150));

      // Verify completion state
      expect(currentState.forgetPasswordApi.isApiInProgress, isFalse);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Email validation works correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EmailTextFormField), 'invalid-email');
      await tester.pump();
      expect(currentState.isForgotEnabled, isFalse);
      await tester.enterText(
        find.byType(EmailTextFormField),
        'test@example.com',
      );
      await tester.pump();
      expect(currentState.isForgotEnabled, isTrue);
    });
  });
}
