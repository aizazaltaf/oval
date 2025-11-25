import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:admin/widgets/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';

void main() {
  late StartupBlocTestHelper startupBlocTestHelper;

  setUpAll(() async {
    startupBlocTestHelper = StartupBlocTestHelper()..setup();
    registerFallbackValue(FakeBuildContext());
    await TestHelper.initialize();
  });

  group('Otp Verification Screen Ui Tests', () {
    setUp(() {});

    tearDown(() {});

    Widget createWidgetUnderTest({
      String number = "+923082680437",
      VoidCallback? function,
    }) {
      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<StartupBloc>.value(
                value: startupBlocTestHelper.mockStartupBloc,
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
                child: OtpVerificationScreen(
                  function: function ?? () {},
                  number: number,
                ),
              ),
            ),
          );
        },
      );
    }

    testWidgets('Initial Ui elements are displayed correctly', (tester) async {
      const String number = "+923082680437";

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context =
          tester.element(find.byType(OtpVerificationScreen));
      final localizations = AppLocalizations.of(context)!;

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      expect(find.text(localizations.verified), findsOneWidget);
      expect(
        find.text(
          localizations.otp_verification_text
              .replaceAll("99", number.substring(number.length - 2)),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Timer function is called after 1 second', (tester) async {
      bool functionCalled = false;
      void testFunction() {
        functionCalled = true;
      }

      await tester.pumpWidget(createWidgetUnderTest(function: testFunction));

      // Initially function should not be called
      expect(functionCalled, isFalse);

      // Wait for 1 second (timer duration)
      await tester.pump(const Duration(seconds: 1));

      // Function should be called after timer
      expect(functionCalled, isTrue);
    });

    testWidgets('Timer is properly disposed when widget is disposed',
        (tester) async {
      bool functionCalled = false;
      void testFunction() {
        functionCalled = true;
      }

      await tester.pumpWidget(createWidgetUnderTest(function: testFunction));

      // Dispose the widget before timer completes
      await tester.pumpWidget(const SizedBox.shrink());

      // Wait for timer duration
      await tester.pump(const Duration(seconds: 1));

      // Function should not be called after disposal
      expect(functionCalled, isFalse);
    });

    testWidgets('Phone number with different formats displays correctly',
        (tester) async {
      const testCases = [
        "+1234567890", // 10 digits
        "+44123456789", // 11 digits
        "+923001234567", // 12 digits
        "+1234567890123", // 13 digits
      ];

      for (final number in testCases) {
        await tester.pumpWidget(createWidgetUnderTest(number: number));
        await tester.pump(const Duration(milliseconds: 100));

        final BuildContext context =
            tester.element(find.byType(OtpVerificationScreen));
        final localizations = AppLocalizations.of(context)!;

        final expectedText = localizations.otp_verification_text
            .replaceAll("99", number.substring(number.length - 2));

        expect(find.text(expectedText), findsOneWidget);
      }
    });

    testWidgets('Empty phone number handles gracefully', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(number: ""));
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context =
          tester.element(find.byType(OtpVerificationScreen));
      final localizations = AppLocalizations.of(context)!;

      // Should display with empty last two digits
      final expectedText =
          localizations.otp_verification_text.replaceAll("99", "");

      expect(find.text(expectedText), findsOneWidget);
    });

    testWidgets('Widget layout is centered', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

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
          tester.element(find.byType(OtpVerificationScreen));
      final localizations = AppLocalizations.of(context)!;

      // The app title should be "OTP" in uppercase
      expect(find.text(localizations.otp.toUpperCase()), findsOneWidget);
    });

    testWidgets('Back icon is not shown', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      // Since showBackIcon is false, there should be no back button
      expect(find.byIcon(Icons.keyboard_arrow_left), findsNothing);
    });

    testWidgets('Multiple function calls are handled correctly',
        (tester) async {
      int callCount = 0;
      void testFunction() {
        callCount++;
      }

      await tester.pumpWidget(createWidgetUnderTest(function: testFunction));

      // Wait for timer to complete
      await tester.pump(const Duration(seconds: 1));

      // Function should be called exactly once
      expect(callCount, equals(1));

      // Wait longer to ensure no additional calls
      await tester.pump(const Duration(seconds: 2));
      expect(callCount, equals(1));
    });

    testWidgets('Widget rebuilds correctly with different parameters',
        (tester) async {
      const String firstNumber = "+1234567890";
      const String secondNumber = "+9876543210";

      // First render with first number
      await tester.pumpWidget(createWidgetUnderTest(number: firstNumber));
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context1 =
          tester.element(find.byType(OtpVerificationScreen));
      final localizations1 = AppLocalizations.of(context1)!;

      final expectedText1 = localizations1.otp_verification_text
          .replaceAll("99", firstNumber.substring(firstNumber.length - 2));
      expect(find.text(expectedText1), findsOneWidget);

      // Rebuild with second number
      await tester.pumpWidget(createWidgetUnderTest(number: secondNumber));
      await tester.pump(const Duration(milliseconds: 100));

      final BuildContext context2 =
          tester.element(find.byType(OtpVerificationScreen));
      final localizations2 = AppLocalizations.of(context2)!;

      final expectedText2 = localizations2.otp_verification_text
          .replaceAll("99", secondNumber.substring(secondNumber.length - 2));
      expect(find.text(expectedText2), findsOneWidget);
    });

    testWidgets('Function parameter is properly passed and executed',
        (tester) async {
      String executedValue = "";
      void testFunction() {
        executedValue = "function_executed";
      }

      await tester.pumpWidget(createWidgetUnderTest(function: testFunction));

      // Initially value should be empty
      expect(executedValue, equals(""));

      // Wait for timer to complete
      await tester.pump(const Duration(seconds: 1));

      // Value should be updated after function execution
      expect(executedValue, equals("function_executed"));
    });
  });
}
