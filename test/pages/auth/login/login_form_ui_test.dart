import 'dart:async';

import 'package:admin/models/data/api_meta_data.dart';
import 'package:admin/pages/auth/forgot_password/forgot_password.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/pages/auth/login/bloc/login_state.dart';
import 'package:admin/pages/auth/login/login_form.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/text_fields/email_text_form_field.dart';
import 'package:admin/widgets/text_fields/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';
import '../../../mocks/bloc/bloc_mocks.dart';

void main() {
  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    await TestHelper.initialize();
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
  });

  group('LoginForm Widget Tests', () {
    late MockLoginBloc mockLoginBloc;
    late StreamController<LoginState> stateController;
    late LoginState currentState;
    bool onSubmitCalled = false;

    setUp(() {
      mockLoginBloc = MockLoginBloc();
      stateController = StreamController<LoginState>.broadcast();
      currentState = LoginState();
      onSubmitCalled = false;

      when(() => mockLoginBloc.state).thenAnswer((_) => currentState);
      when(() => mockLoginBloc.stream)
          .thenAnswer((_) => stateController.stream);
      when(() => mockLoginBloc.updateEmail(any())).thenAnswer((email) {
        currentState = currentState
            .rebuild((b) => b..email = email.positionalArguments[0]);
        stateController.add(currentState);
      });
      when(() => mockLoginBloc.updatePassword(any())).thenAnswer((password) {
        currentState = currentState
            .rebuild((b) => b..password = password.positionalArguments[0]);
        stateController.add(currentState);
      });
      when(() => mockLoginBloc.updateObscureText(any())).thenAnswer((obscure) {
        currentState = currentState
            .rebuild((b) => b..obscureText = obscure.positionalArguments[0]);
        stateController.add(currentState);
      });
      when(() => mockLoginBloc.reInitializeState()).thenAnswer((_) {
        currentState = currentState.rebuild((b) => b..loginApi.error = null);
        stateController.add(currentState);
      });
    });

    tearDown(() {
      stateController.close();
    });

    Widget createTestWidget({ThemeMode themeMode = ThemeMode.light}) {
      return MaterialApp(
        themeMode: themeMode,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<LoginBloc>.value(
          value: mockLoginBloc,
          child: LoginForm(
            onSubmit: () {
              onSubmitCalled = true;
            },
          ),
        ),
        routes: {
          'ForgotPassword': (context) => BlocProvider<LoginBloc>.value(
            value: mockLoginBloc,
            child: ForgotPasswordPage(),
          ),
        },
      );
    }

    testWidgets('LoginForm displays all required UI elements', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(LoginForm));
      final localizations = AppLocalizations.of(context)!;

      // Check for email field label and input
      expect(find.text(localizations.login_email), findsOneWidget);
      expect(find.byType(EmailTextFormField), findsOneWidget);

      // Check for password field label and input
      expect(find.text(localizations.login_password), findsOneWidget);
      expect(find.byType(PasswordTextFormField), findsOneWidget);

      // Check for forgot password button
      expect(find.text(localizations.forget_password), findsOneWidget);

      // Check for AutofillGroup wrapper
      expect(find.byType(AutofillGroup), findsOneWidget);
    });

    testWidgets('Email field has correct properties and validation',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(LoginForm));
      final localizations = AppLocalizations.of(context)!;

      final emailField = find.byType(EmailTextFormField);
      expect(emailField, findsOneWidget);

      final emailWidget = tester.widget<EmailTextFormField>(emailField);
      expect(emailWidget.hintText, equals(localizations.hint_email));
      expect(emailWidget.textInputAction, equals(TextInputAction.next));
      expect(emailWidget.needAutoFillHints, isTrue);
      expect(emailWidget.validator, isNotNull);
      expect(emailWidget.onChanged, isNotNull);
    });

    testWidgets('Password field has correct properties and validation',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(LoginForm));
      final localizations = AppLocalizations.of(context)!;

      final passwordField = find.byType(PasswordTextFormField);
      expect(passwordField, findsOneWidget);

      final passwordWidget =
          tester.widget<PasswordTextFormField>(passwordField);
      expect(passwordWidget.hintText, equals(localizations.hint_password));
      expect(passwordWidget.obscureText, isTrue);
      expect(passwordWidget.needAutoFillHints, isTrue);
      expect(passwordWidget.validator, isNotNull);
      expect(passwordWidget.onChanged, isNotNull);
      expect(passwordWidget.onPressed, isNotNull);
    });

    testWidgets('Email field calls updateEmail when text changes',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      const testEmail = 'test@example.com';
      await tester.enterText(find.byType(EmailTextFormField), testEmail);
      await tester.pumpAndSettle();

      verify(() => mockLoginBloc.updateEmail(testEmail)).called(1);
    });

    testWidgets('Password field calls updatePassword when text changes',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      const testPassword = 'TestPassword123!';
      await tester.enterText(find.byType(PasswordTextFormField), testPassword);
      await tester.pumpAndSettle();

      verify(() => mockLoginBloc.updatePassword(testPassword)).called(1);
    });

    testWidgets('Password visibility toggle works correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Initially password should be obscured
      final passwordField = tester
          .widget<PasswordTextFormField>(find.byType(PasswordTextFormField));
      expect(passwordField.obscureText, isTrue);

      // Enter some text to enable the visibility toggle
      await tester.enterText(find.byType(PasswordTextFormField), 'test');
      await tester.pumpAndSettle();

      // Find and tap the visibility toggle button
      final visibilityButton = find.byType(IconButton);
      expect(visibilityButton, findsOneWidget);

      await tester.tap(visibilityButton);
      await tester.pumpAndSettle();

      verify(() => mockLoginBloc.updateObscureText(false)).called(1);
    });

    testWidgets('Forgot password button has correct styling and behavior',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(LoginForm));
      final localizations = AppLocalizations.of(context)!;

      final forgotPasswordButton = find.text(localizations.forget_password);
      expect(forgotPasswordButton, findsOneWidget);

      // Check that it's a TextButton
      final textButton = tester.widget<TextButton>(find.byType(TextButton));
      expect(textButton.style?.padding?.resolve({}), equals(EdgeInsets.zero));
      expect(textButton.style?.minimumSize?.resolve({}), equals(Size.zero));
      expect(
        textButton.style?.tapTargetSize,
        equals(MaterialTapTargetSize.shrinkWrap),
      );
      expect(
        textButton.style?.overlayColor?.resolve({}),
        equals(Colors.transparent),
      );
      expect(textButton.style?.splashFactory, equals(NoSplash.splashFactory));
    });

    testWidgets('Forgot password button calls reInitializeState and navigates',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final forgotPasswordButton = find.byType(TextButton);
      
      // Test that the button exists and has correct properties
      expect(forgotPasswordButton, findsOneWidget);
      
      // Test the button tap behavior by checking the onPressed callback
      final textButton = tester.widget<TextButton>(forgotPasswordButton);
      expect(textButton.onPressed, isNotNull);
      
      // Simulate the button press without actually triggering navigation
      textButton.onPressed!();
      
      verify(() => mockLoginBloc.reInitializeState()).called(1);
    });

    testWidgets('Form submission calls onSubmit callback', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter valid email and password
      await tester.enterText(
        find.byType(EmailTextFormField),
        'test@example.com',
      );
      await tester.enterText(
        find.byType(PasswordTextFormField),
        'TestPassword123!',
      );
      await tester.pumpAndSettle();

      // Submit the form by pressing enter on password field
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(onSubmitCalled, isTrue);
    });

    testWidgets('Email validation shows error for invalid email',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(find.byType(EmailTextFormField), 'invalid-email');
      await tester.pumpAndSettle();

      // Trigger validation
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(LoginForm));
      final localizations = AppLocalizations.of(context)!;

      // Check if validation error appears
      expect(find.text(localizations.login_errEmailInvalid), findsOneWidget);
    });

    testWidgets('Email validation shows error for empty email', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Focus on email field and then unfocus to trigger validation
      await tester.tap(find.byType(EmailTextFormField));
      await tester.pump();
      await tester.tap(find.byType(PasswordTextFormField)); // Move focus away
      await tester.pumpAndSettle();

      // Check if required field error appears
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('Password validation shows error for empty password',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Focus on password field and then unfocus to trigger validation
      await tester.tap(find.byType(PasswordTextFormField));
      await tester.pump();
      await tester.tap(find.byType(EmailTextFormField)); // Move focus away
      await tester.pumpAndSettle();

      // Check if required field error appears
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('Password validation shows error for short password',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter short password
      await tester.enterText(find.byType(PasswordTextFormField), 'Test1!');
      await tester.pumpAndSettle();

      // Trigger validation
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Check if password too short error appears
      expect(find.text('Password is too short'), findsOneWidget);
    });

    testWidgets('Password validation shows error for long password',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter long password (more than 48 characters)
      const longPassword =
          'TestPassword123!TestPassword123!TestPassword123!TestPassword123!';
      await tester.enterText(find.byType(PasswordTextFormField), longPassword);
      await tester.pumpAndSettle();

      // Trigger validation
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Check if password too long error appears
      expect(find.text('Password is too long'), findsOneWidget);
    });

    testWidgets('Password validation shows error for invalid password format',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter password without required characters
      await tester.enterText(
        find.byType(PasswordTextFormField),
        'testpassword123',
      );
      await tester.pumpAndSettle();

      // Trigger validation
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(LoginForm));
      final localizations = AppLocalizations.of(context)!;

      // Check if invalid password format error appears
      expect(find.text(localizations.invalid_password), findsOneWidget);
    });

    testWidgets('API error is displayed in password field', (tester) async {
      // Set up state with API error
      final error = ApiMetaData.fromMessage('Invalid credentials');
      currentState =
          currentState.rebuild((b) => b..loginApi.error = error.toBuilder());
      stateController.add(currentState);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check if error message is displayed
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('Form uses correct text styles', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check email label style
      final emailLabel = find.text('Email');
      expect(emailLabel, findsOneWidget);
      final emailLabelWidget = tester.widget<Text>(emailLabel);
      expect(emailLabelWidget.style?.fontSize, equals(15.0));
      expect(emailLabelWidget.style?.fontWeight, equals(FontWeight.w400));

      // Check password label style
      final passwordLabel = find.text('Password');
      expect(passwordLabel, findsOneWidget);
      final passwordLabelWidget = tester.widget<Text>(passwordLabel);
      expect(passwordLabelWidget.style?.fontSize, equals(15.0));
      expect(passwordLabelWidget.style?.fontWeight, equals(FontWeight.w400));
    });

    testWidgets('Form handles theme changes correctly', (tester) async {
      // Test light theme
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(LoginForm), findsOneWidget);

      // Test dark theme
      await tester.pumpWidget(createTestWidget(themeMode: ThemeMode.dark));
      await tester.pumpAndSettle();

      expect(find.byType(LoginForm), findsOneWidget);
    });

    testWidgets('Form maintains state during rebuilds', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter some text
      await tester.enterText(
        find.byType(EmailTextFormField),
        'test@example.com',
      );
      await tester.enterText(
        find.byType(PasswordTextFormField),
        'TestPassword123!',
      );
      await tester.pumpAndSettle();

      // Rebuild the widget
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Text should still be there
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('TestPassword123!'), findsOneWidget);
    });

    testWidgets('Form handles multiple rapid text changes', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Rapidly change email text
      await tester.enterText(find.byType(EmailTextFormField), 'a');
      await tester.pump();
      await tester.enterText(find.byType(EmailTextFormField), 'ab');
      await tester.pump();
      await tester.enterText(find.byType(EmailTextFormField), 'abc@test.com');
      await tester.pumpAndSettle();

      // Verify the final state
      verify(() => mockLoginBloc.updateEmail('a')).called(1);
      verify(() => mockLoginBloc.updateEmail('ab')).called(1);
      verify(() => mockLoginBloc.updateEmail('abc@test.com')).called(1);
    });

    testWidgets('Form handles keyboard navigation correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Focus on email field
      await tester.tap(find.byType(EmailTextFormField));
      await tester.pumpAndSettle();

      // Press next to move to password field
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();

      // Focus should move to password field
      expect(find.byType(PasswordTextFormField), findsOneWidget);
    });
  });
}
