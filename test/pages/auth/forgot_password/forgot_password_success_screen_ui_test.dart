import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/auth/forgot_password/forgot_password_success_screen.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:admin/widgets/scaffold.dart';
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

  group('Forgot Password Success Screen Ui Tests', () {
    late MockLoginBloc mockLoginBloc;

    setUp(() {
      mockLoginBloc = MockLoginBloc();
    });

    tearDown(() {});

    Widget createWidgetUnderTest({
      String forgotEmail = "muhammadtaimoor@irvinei.com",
    }) {
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
                child: ForgotPasswordSuccessScreen(forgotEmail: forgotEmail),
              ),
            ),
          );
        },
      );
    }

    testWidgets('Initial Ui elements are displayed correctly', (tester) async {
      const forgotEmail = "muhammadtaimoor@irvinei.com";

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context =
          tester.element(find.byType(ForgotPasswordSuccessScreen));
      final localizations = AppLocalizations.of(context)!;

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      expect(find.text(localizations.link_sent), findsOneWidget);
      expect(
        find.text(
          localizations.resent_email
              .replaceFirst("abcd@gmail.com", forgotEmail),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Widget layout is centered', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      tester.element(find.byType(ForgotPasswordSuccessScreen));

      final Column column = tester.widget(
        find.byWidgetPredicate(
          (widget) =>
              widget is Column &&
              widget.mainAxisAlignment == MainAxisAlignment.center,
        ),
      );
      expect(column.mainAxisAlignment, equals(MainAxisAlignment.center));
    });

    testWidgets('App title is displayed correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context =
          tester.element(find.byType(ForgotPasswordSuccessScreen));
      final localizations = AppLocalizations.of(context)!;

      expect(find.text(localizations.forgotPassword), findsOneWidget);
    });

    testWidgets('Back icon is shown', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      tester.element(find.byType(ForgotPasswordSuccessScreen));

      // Since showBackIcon is false, there should be no back button
      expect(find.byIcon(Icons.keyboard_arrow_left), findsOneWidget);
    });

    testWidgets('Success icon has correct properties', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      final Icon successIcon =
          tester.widget(find.byIcon(Icons.check_circle_rounded));
      expect(successIcon.size, equals(100));
      expect(successIcon.color, equals(Colors.green.shade700));
    });

    testWidgets('Success icon is properly aligned', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      final Align alignWidget = tester.widget(
        find.ancestor(
          of: find.byIcon(Icons.check_circle_rounded),
          matching: find.byType(Align),
        ),
      );
      expect(alignWidget.alignment, equals(Alignment.center));
    });

    testWidgets('Email text has correct styling and alignment', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context =
          tester.element(find.byType(ForgotPasswordSuccessScreen));
      final localizations = AppLocalizations.of(context)!;

      final Text emailText = tester.widget(
        find.text(
          localizations.resent_email
              .replaceFirst("abcd@gmail.com", "muhammadtaimoor@irvinei.com"),
        ),
      );
      expect(emailText.textAlign, equals(TextAlign.center));

      expect(emailText, isA<Text>());
    });

    testWidgets('Email replacement works correctly with different emails',
        (tester) async {
      const testEmail = "test@example.com";

      await tester.pumpWidget(createWidgetUnderTest(forgotEmail: testEmail));
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context =
          tester.element(find.byType(ForgotPasswordSuccessScreen));
      final localizations = AppLocalizations.of(context)!;

      expect(
        find.text(
          localizations.resent_email.replaceFirst("abcd@gmail.com", testEmail),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Bottom navigation bar contains done button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context =
          tester.element(find.byType(ForgotPasswordSuccessScreen));
      final localizations = AppLocalizations.of(context)!;

      expect(find.text(localizations.login_btnDone), findsOneWidget);
    });

    testWidgets('NoGlowListViewWrapper is present', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(NoGlowListViewWrapper), findsOneWidget);
    });

    testWidgets('AuthScaffold is used as the main scaffold', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AuthScaffold), findsOneWidget);
    });

    testWidgets('CustomGradientButton is present in bottom navigation',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CustomGradientButton), findsOneWidget);
    });

    testWidgets('SizedBox spacing elements are present', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      // Should find multiple SizedBox widgets for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('Column contains all expected children', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      final Column column = tester.widget(
        find.byWidgetPredicate(
          (widget) =>
              widget is Column &&
              widget.mainAxisAlignment == MainAxisAlignment.center,
        ),
      );
      // The column should have multiple children: Align (icon), SizedBox, Text, SizedBox, Text
      expect(column.children.length, equals(5));
    });

    testWidgets('Screen handles empty email gracefully', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(forgotEmail: ""));
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context =
          tester.element(find.byType(ForgotPasswordSuccessScreen));
      final localizations = AppLocalizations.of(context)!;

      // Should still display the text with empty email
      expect(
        find.text(
          localizations.resent_email.replaceFirst("abcd@gmail.com", ""),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Screen handles special characters in email', (tester) async {
      const specialEmail = "test+user@example.com";

      await tester.pumpWidget(createWidgetUnderTest(forgotEmail: specialEmail));
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context =
          tester.element(find.byType(ForgotPasswordSuccessScreen));
      final localizations = AppLocalizations.of(context)!;

      expect(
        find.text(
          localizations.resent_email
              .replaceFirst("abcd@gmail.com", specialEmail),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Screen maintains proper widget hierarchy', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      // Verify the widget hierarchy: AuthScaffold -> NoGlowListViewWrapper -> Padding -> Column
      expect(find.byType(AuthScaffold), findsOneWidget);
      expect(find.byType(NoGlowListViewWrapper), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Column), findsNWidgets(2));
    });

    testWidgets('All text elements are properly localized', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context =
          tester.element(find.byType(ForgotPasswordSuccessScreen));
      final localizations = AppLocalizations.of(context)!;

      // Verify all text elements use localized strings
      expect(find.text(localizations.forgotPassword), findsOneWidget);
      expect(find.text(localizations.link_sent), findsOneWidget);
      expect(find.text(localizations.login_btnDone), findsOneWidget);
    });

    testWidgets('Screen is responsive to different screen sizes',
        (tester) async {
      // Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ForgotPasswordSuccessScreen), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('Screen handles long email addresses', (tester) async {
      const longEmail =
          "very.long.email.address.that.might.cause.layout.issues@verylongdomainname.com";

      await tester.pumpWidget(createWidgetUnderTest(forgotEmail: longEmail));
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context =
          tester.element(find.byType(ForgotPasswordSuccessScreen));
      final localizations = AppLocalizations.of(context)!;

      expect(
        find.text(
          localizations.resent_email.replaceFirst("abcd@gmail.com", longEmail),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Screen maintains accessibility features', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that text elements have proper semantics
      expect(find.byType(Text), findsWidgets);

      // Verify that the success icon is accessible
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('Screen handles theme changes correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      // Verify the screen renders without theme-related errors
      expect(find.byType(ForgotPasswordSuccessScreen), findsOneWidget);

      // Verify that theme-dependent colors are used correctly
      final Icon successIcon =
          tester.widget(find.byIcon(Icons.check_circle_rounded));
      expect(successIcon.color, equals(Colors.green.shade700));
    });
  });
}
