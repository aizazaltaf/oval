import 'dart:async';

import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/pages/auth/login/bloc/login_state.dart';
import 'package:admin/pages/auth/signup/signup_page.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/custom_checkbox_list_tile.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/email_text_form_field.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:admin/widgets/text_fields/password_text_form_field.dart';
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

Future<void> fillSignupForm(WidgetTester tester) async {
  await tester.enterText(find.byType(NameTextFormField).first, 'John Doe');
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byType(EmailTextFormField),
    'john.doe@example.com',
  );
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(NameTextFormField).at(1), '1234567890');
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byType(PasswordTextFormField).first,
    'Test@123456',
  );
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byType(PasswordTextFormField).last,
    'Test@123456',
  );
  await tester.pumpAndSettle();
  final checkbox = find.byType(CustomCheckboxListTile);
  final checkboxWidget = tester.widget<CustomCheckboxListTile>(checkbox);
  checkboxWidget.onChanged.call(true);
  await tester.pumpAndSettle();
}

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

  group('Signup Page UI Tests', () {
    late MockLoginBloc mockLoginBloc;
    late StreamController<LoginState> stateController;
    late LoginState currentState;
    String latestName = '';
    String latestEmail = '';
    String latestPhone = '';
    String latestPassword = '';
    String latestConfirmPassword = '';
    bool latestCheckBox = false;
    String latestCountryCode = '+1';
    bool apiInProgress = false;

    bool isValidEmail(String email) {
      return RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}").hasMatch(email);
    }

    bool isValidPassword(String password) {
      return password.length >= 8 &&
          RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]+')
              .hasMatch(password);
    }

    bool isValidPhone(String phone) {
      return phone.length >= 9;
    }

    bool isSignupEnabled() {
      return latestName.isNotEmpty &&
          isValidEmail(latestEmail) &&
          isValidPhone(latestPhone) &&
          isValidPassword(latestPassword) &&
          latestPassword == latestConfirmPassword &&
          latestCheckBox;
    }

    setUp(() {
      mockLoginBloc = MockLoginBloc();
      stateController = StreamController<LoginState>.broadcast();
      currentState = LoginState();
      latestName = '';
      latestEmail = '';
      latestPhone = '';
      latestPassword = '';
      latestConfirmPassword = '';
      latestCheckBox = false;
      latestCountryCode = '+1';
      apiInProgress = false;

      when(() => mockLoginBloc.state).thenAnswer((_) => currentState);
      when(() => mockLoginBloc.stream)
          .thenAnswer((_) => stateController.stream);
      when(() => mockLoginBloc.otpController)
          .thenReturn(TextEditingController());

      when(() => mockLoginBloc.updateName(any())).thenAnswer((name) {
        latestName = name.positionalArguments[0];
        currentState = LoginState().rebuild(
          (b) => b
            ..name = latestName
            ..email = latestEmail
            ..phoneNumber = latestPhone
            ..password = latestPassword
            ..confirmPassword = latestConfirmPassword
            ..checkBox = latestCheckBox
            ..countryCode = latestCountryCode
            ..signUpApi.isApiInProgress = apiInProgress
            ..isSignupEnabled = isSignupEnabled(),
        );
        stateController.add(currentState);
      });
      when(() => mockLoginBloc.updateEmail(any())).thenAnswer((email) {
        latestEmail = email.positionalArguments[0];
        currentState = LoginState().rebuild(
          (b) => b
            ..name = latestName
            ..email = latestEmail
            ..phoneNumber = latestPhone
            ..password = latestPassword
            ..confirmPassword = latestConfirmPassword
            ..checkBox = latestCheckBox
            ..countryCode = latestCountryCode
            ..signUpApi.isApiInProgress = apiInProgress
            ..isSignupEnabled = isSignupEnabled(),
        );
        stateController.add(currentState);
      });
      when(() => mockLoginBloc.updatePhoneNumber(any())).thenAnswer((phone) {
        latestPhone = phone.positionalArguments[0];
        currentState = LoginState().rebuild(
          (b) => b
            ..name = latestName
            ..email = latestEmail
            ..phoneNumber = latestPhone
            ..password = latestPassword
            ..confirmPassword = latestConfirmPassword
            ..checkBox = latestCheckBox
            ..countryCode = latestCountryCode
            ..signUpApi.isApiInProgress = apiInProgress
            ..isSignupEnabled = isSignupEnabled(),
        );
        stateController.add(currentState);
      });
      when(() => mockLoginBloc.updatePassword(any())).thenAnswer((password) {
        latestPassword = password.positionalArguments[0];
        currentState = LoginState().rebuild(
          (b) => b
            ..name = latestName
            ..email = latestEmail
            ..phoneNumber = latestPhone
            ..password = latestPassword
            ..confirmPassword = latestConfirmPassword
            ..checkBox = latestCheckBox
            ..countryCode = latestCountryCode
            ..signUpApi.isApiInProgress = apiInProgress
            ..isSignupEnabled = isSignupEnabled(),
        );
        stateController.add(currentState);
      });
      when(() => mockLoginBloc.updateConfirmPassword(any()))
          .thenAnswer((confirmPassword) {
        latestConfirmPassword = confirmPassword.positionalArguments[0];
        currentState = LoginState().rebuild(
          (b) => b
            ..name = latestName
            ..email = latestEmail
            ..phoneNumber = latestPhone
            ..password = latestPassword
            ..confirmPassword = latestConfirmPassword
            ..checkBox = latestCheckBox
            ..countryCode = latestCountryCode
            ..signUpApi.isApiInProgress = apiInProgress
            ..isSignupEnabled = isSignupEnabled(),
        );
        stateController.add(currentState);
      });
      when(() => mockLoginBloc.updateCheckBox(any())).thenAnswer((checked) {
        latestCheckBox = checked.positionalArguments[0];
        currentState = LoginState().rebuild(
          (b) => b
            ..name = latestName
            ..email = latestEmail
            ..phoneNumber = latestPhone
            ..password = latestPassword
            ..confirmPassword = latestConfirmPassword
            ..checkBox = latestCheckBox
            ..countryCode = latestCountryCode
            ..signUpApi.isApiInProgress = apiInProgress
            ..isSignupEnabled = isSignupEnabled(),
        );
        stateController.add(currentState);
      });
      when(() => mockLoginBloc.updateCountryCode(any())).thenAnswer((code) {
        latestCountryCode = code.positionalArguments[0];
        currentState = LoginState().rebuild(
          (b) => b
            ..name = latestName
            ..email = latestEmail
            ..phoneNumber = latestPhone
            ..password = latestPassword
            ..confirmPassword = latestConfirmPassword
            ..checkBox = latestCheckBox
            ..countryCode = latestCountryCode
            ..signUpApi.isApiInProgress = apiInProgress
            ..isSignupEnabled = isSignupEnabled(),
        );
        stateController.add(currentState);
      });
      when(() => mockLoginBloc.callSignup()).thenAnswer((_) async {
        apiInProgress = true;
        currentState = currentState.rebuild(
          (b) => b
            ..signUpLoading = true
            ..signUpApi.isApiInProgress = true,
        );
        stateController.add(currentState);
        await Future.delayed(const Duration(milliseconds: 100));
        apiInProgress = false;
        currentState = currentState.rebuild(
          (b) => b
            ..signUpLoading = false
            ..signUpApi.isApiInProgress = false,
        );
        stateController.add(currentState);
      });
      // Mock callValidateEmail
      when(
        () => mockLoginBloc.callValidateEmail(
          successFunction: any(named: 'successFunction'),
        ),
      ).thenAnswer((invocation) async {
        final successFunction = invocation
            .namedArguments[const Symbol('successFunction')] as Function;
        await successFunction();
      });
      // Mock updateSignUpLoading
      when(() => mockLoginBloc.updateSignUpLoading(any()))
          .thenAnswer((loading) {
        currentState = currentState
            .rebuild((b) => b..signUpLoading = loading.positionalArguments[0]);
        stateController.add(currentState);
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
            child: const MaterialApp(
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: MediaQuery(
                  data: MediaQueryData(size: Size(1080, 1920)),
                  child: SignupPage(),
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
      final BuildContext context = tester.element(find.byType(SignupPage));
      final localizations = AppLocalizations.of(context)!;

      expect(find.text(localizations.registration), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(5));
      expect(find.text(localizations.sign_up), findsOneWidget);

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text
                  .toPlainText()
                  .contains(localizations.already_have_an_account),
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

      final BuildContext context = tester.element(find.byType(SignupPage));
      final localizations = AppLocalizations.of(context)!;

      expect(find.text(localizations.registration), findsOneWidget);
    });

    testWidgets('Listview layout is present', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      tester
        ..element(find.byType(SignupPage))
        ..widget(find.byType(ListView));
    });

    testWidgets('Back icon is shown', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      tester.element(find.byType(SignupPage));

      // Since showBackIcon is false, there should be no back button
      expect(find.byIcon(Icons.keyboard_arrow_left), findsOneWidget);
    });

    testWidgets('NoGlowListViewWrapper is present', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      tester.element(find.byType(SignupPage));
      expect(find.byType(NoGlowListViewWrapper), findsOneWidget);
    });

    testWidgets('AuthScaffold is used as the main scaffold', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      tester.element(find.byType(SignupPage));
      expect(find.byType(AuthScaffold), findsOneWidget);
    });

    testWidgets('CustomGradientButton is present in bottom navigation',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CustomGradientButton), findsOneWidget);
    });

    testWidgets('SizedBox spacing elements are present', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Should find multiple SizedBox widgets for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('Signup button is disabled initially', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      final signupButton = find.byType(CustomGradientButton);
      expect(signupButton, findsOneWidget);
      final button = tester.widget<CustomGradientButton>(signupButton);
      expect(button.isButtonEnabled, isFalse);
    });

    testWidgets(
        'Signup button enables when valid data is entered and checkbox is checked',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      await fillSignupForm(tester);
      final signupButton = find.byType(CustomGradientButton);
      expect(signupButton, findsOneWidget);
      final button = tester.widget<CustomGradientButton>(signupButton);
      expect(button.isButtonEnabled, isTrue);
    });

    testWidgets('Signup button shows loading indicator when API is in progress',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      await fillSignupForm(tester);
      final signupButton = find.byType(CustomGradientButton);
      expect(signupButton, findsOneWidget);
      await tester.tap(signupButton);
      await tester.pump(); // Allow the tap to trigger the bloc call

      // Verify the login API was called
      verify(() => mockLoginBloc.callSignup()).called(1);

      // Wait for the bloc to emit the in-progress state
      await tester.pump(const Duration(milliseconds: 10));
      expect(currentState.signUpApi.isApiInProgress, isTrue);

      await tester.pump(const Duration(milliseconds: 10));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the bloc to emit the in-progress state
      await tester.pump(const Duration(milliseconds: 200));
      expect(currentState.signUpApi.isApiInProgress, isFalse);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
