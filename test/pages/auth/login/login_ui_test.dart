import 'dart:async';

import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/pages/auth/login/bloc/login_state.dart';
import 'package:admin/pages/auth/login/login_page.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/email_text_form_field.dart';
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

  group('Login Page UI Tests', () {
    late MockLoginBloc mockLoginBloc;
    late StreamController<LoginState> stateController;
    // Track latest email and password
    String latestEmail = '';
    String latestPassword = '';
    // Track the latest state
    late LoginState currentState;

    bool isValidEmail(String email) {
      return Constants.emailRegex.hasMatch(email);
    }

    bool isValidPassword(String password) {
      return password.length >= 8 && Constants.passwordRegex.hasMatch(password);
    }

    setUp(() {
      mockLoginBloc = MockLoginBloc();
      stateController = StreamController<LoginState>.broadcast();
      currentState = LoginState();
      latestEmail = '';
      latestPassword = '';
      currentState = LoginState();
      when(() => mockLoginBloc.state).thenAnswer((_) => currentState);
      when(() => mockLoginBloc.stream)
          .thenAnswer((_) => stateController.stream);
      when(() => mockLoginBloc.updateEmail(any())).thenAnswer((email) {
        latestEmail = email.positionalArguments[0];
        final enable =
            isValidEmail(latestEmail) && isValidPassword(latestPassword);
        currentState = LoginState().rebuild(
          (b) => b
            ..email = latestEmail
            ..password = latestPassword
            ..isLoginEnabled = enable,
        );
        stateController.add(currentState);
      });
      when(() => mockLoginBloc.updatePassword(any())).thenAnswer((password) {
        latestPassword = password.positionalArguments[0];
        final enable =
            isValidEmail(latestEmail) && isValidPassword(latestPassword);
        currentState = LoginState().rebuild(
          (b) => b
            ..email = latestEmail
            ..password = latestPassword
            ..isLoginEnabled = enable,
        );
        stateController.add(currentState);
      });
      when(() => mockLoginBloc.callLogin(any())).thenAnswer((_) async {
        currentState =
            currentState.rebuild((b) => b..loginApi.isApiInProgress = true);
        stateController.add(currentState);
        await Future.delayed(const Duration(milliseconds: 100));
        currentState =
            currentState.rebuild((b) => b..loginApi.isApiInProgress = false);
        stateController.add(currentState);
      });
    });

    tearDown(() {
      stateController.close();
    });

    Widget createTestWidget({ThemeMode themeMode = ThemeMode.light}) {
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
              home: const MediaQuery(
                data: MediaQueryData(size: Size(1080, 1920)),
                child: LoginPage(),
              ),
            ),
          );
        },
      );
    }

    testWidgets('Initial UI elements are displayed correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(LoginPage));
      final localizations = AppLocalizations.of(context)!;

      expect(find.text(localizations.welcome_back), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text(localizations.forget_password), findsOneWidget);
      expect(find.text(localizations.login_btnDone), findsOneWidget);

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text
                  .toPlainText()
                  .contains(localizations.do_you_have_account),
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains(localizations.sign_up),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Listview layout is present', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      tester
        ..element(find.byType(LoginPage))
        ..widget(find.byType(ListView));
    });

    testWidgets('Back icon is not shown', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      tester.element(find.byType(LoginPage));

      // Since showBackIcon is false, there should be no back button
      expect(find.byIcon(Icons.keyboard_arrow_left), findsNothing);
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

    testWidgets('SizedBox spacing elements are present', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Should find multiple SizedBox widgets for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('Login button is disabled initially', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final loginButton = find.byType(CustomGradientButton);
      expect(loginButton, findsOneWidget);

      final button = tester.widget<CustomGradientButton>(loginButton);
      expect(button.isButtonEnabled, isFalse);
    });

    testWidgets('Login button enables when valid credentials are entered',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter email
      await tester.enterText(
        find.byType(EmailTextFormField),
        'syedusamafaridi@irvinei.com',
      );
      await tester.pumpAndSettle();

      // Trigger the onChanged callback
      final emailField =
          tester.widget<EmailTextFormField>(find.byType(EmailTextFormField));
      emailField.onChanged?.call('syedusamafaridi@irvinei.com');
      await tester.pumpAndSettle();

      // Enter password
      await tester.enterText(
        find.byType(PasswordTextFormField),
        'Test@123456',
      );
      await tester.pumpAndSettle();

      // Trigger the onChanged callback
      final passwordField = tester
          .widget<PasswordTextFormField>(find.byType(PasswordTextFormField));
      passwordField.onChanged?.call('Test@123456');
      await tester.pumpAndSettle();

      final loginButton = find.byType(CustomGradientButton);
      expect(loginButton, findsOneWidget);

      final button = tester.widget<CustomGradientButton>(loginButton);
      expect(button.isButtonEnabled, isTrue);

      // Tap the login button
      await tester.tap(loginButton);
      await tester.pump(); // Allow the tap to trigger the bloc call

      // Verify the login API was called
      verify(() => mockLoginBloc.callLogin(any())).called(1);

      // Wait for the bloc to emit the in-progress state
      await tester.pump(const Duration(milliseconds: 10));
      expect(currentState.loginApi.isApiInProgress, isTrue);

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for API to complete
      await tester.pump(const Duration(milliseconds: 200));
      expect(currentState.loginApi.isApiInProgress, isFalse);
    });

    testWidgets('Logo is present with correct light theme image',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the Image widget
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final image = tester.widget<Image>(imageFinder);
      expect(image.image, isA<AssetImage>());

      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals(DefaultImages.APPLICATION_ICON_PNG));

      // Verify the image has the correct height
      expect(image.height, equals(90.0));
    });

    testWidgets('Logo is present with correct dark theme image',
        (tester) async {
      await tester.pumpWidget(createTestWidget(themeMode: ThemeMode.dark));
      await tester.pumpAndSettle();

      // Find the Image widget
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final image = tester.widget<Image>(imageFinder);
      expect(image.image, isA<AssetImage>());

      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals(DefaultImages.DARK_LOGO));

      // Verify the image has the correct height
      expect(image.height, equals(90.0));
    });

    testWidgets('Logo switches correctly between light and dark themes',
        (tester) async {
      // Test light theme
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      var image = tester.widget<Image>(find.byType(Image));
      var assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals(DefaultImages.APPLICATION_ICON_PNG));

      // Switch to dark theme
      await tester.pumpWidget(createTestWidget(themeMode: ThemeMode.dark));
      await tester.pumpAndSettle();

      image = tester.widget<Image>(find.byType(Image));
      assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals(DefaultImages.DARK_LOGO));
    });

    testWidgets('Logo is centered in the layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the Center widget containing the Image
      final centerFinder = find.byWidgetPredicate(
        (widget) => widget is Center && widget.child is Image,
      );
      expect(centerFinder, findsOneWidget);
    });

    testWidgets('Logo has correct spacing below it', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the SizedBox that provides spacing after the logo
      final sizedBoxFinder = find.byWidgetPredicate(
        (widget) => widget is SizedBox && widget.height == 40.0,
      );
      expect(sizedBoxFinder, findsOneWidget);
    });
  });
}
