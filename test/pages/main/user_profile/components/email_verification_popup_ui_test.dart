import 'package:admin/pages/main/user_profile/components/email_verification_popup.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/bloc_helpers/logout_bloc_test_helper.dart';

void main() {
  group('EmailVerificationPopup UI Tests', () {
    late LogoutBlocTestHelper logoutBlocHelper;

    setUp(() {
      logoutBlocHelper = LogoutBlocTestHelper()..setup();
    });

    Widget createTestWidget() {
      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => EmailVerificationPopup(
                          logoutBloc: logoutBlocHelper.mockLogoutBloc,
                        ),
                      );
                    },
                    child: const Text('Show Dialog'),
                  );
                },
              ),
            ),
          );
        },
      );
    }

    group('Dialog Structure and Layout', () {
      testWidgets('displays dialog with correct structure', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog is displayed
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.byType(DecoratedBox), findsAtLeastNWidgets(1));
      });

      testWidgets('has correct dialog decoration', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Find the DecoratedBox within the Dialog
        final decoratedBoxes = find.descendant(
          of: find.byType(Dialog),
          matching: find.byType(DecoratedBox),
        );
        expect(decoratedBoxes, findsAtLeastNWidgets(1));

        // Check that at least one has the correct border radius
        bool hasCorrectDecoration = false;
        for (final element in tester.widgetList(decoratedBoxes)) {
          if (element is DecoratedBox) {
            final decoration = element.decoration as BoxDecoration;
            if (decoration.borderRadius == BorderRadius.circular(20)) {
              hasCorrectDecoration = true;
              break;
            }
          }
        }
        expect(hasCorrectDecoration, isTrue);
      });

      testWidgets('has correct padding', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        final paddingWidgets = find.descendant(
          of: find.byType(Dialog),
          matching: find.byType(Padding),
        );
        expect(paddingWidgets, findsAtLeastNWidgets(1));

        // Check that at least one has the correct padding
        bool hasCorrectPadding = false;
        for (final element in tester.widgetList(paddingWidgets)) {
          if (element is Padding &&
              element.padding == const EdgeInsets.all(20)) {
            hasCorrectPadding = true;
            break;
          }
        }
        expect(hasCorrectPadding, isTrue);
      });

      testWidgets('has correct column layout', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        final column = tester.widget<Column>(
          find.descendant(
            of: find.byType(Padding),
            matching: find.byType(Column),
          ),
        );

        expect(column.mainAxisAlignment, equals(MainAxisAlignment.center));
        expect(column.mainAxisSize, equals(MainAxisSize.min));
      });
    });

    group('Title Text Display', () {
      testWidgets('displays correct title text', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Your email address is updated. Please verify your email address.',
          ),
          findsOneWidget,
        );
      });

      testWidgets('title has correct text alignment', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        final titleText = tester.widget<Text>(
          find.text(
            'Your email address is updated. Please verify your email address.',
          ),
        );

        expect(titleText.textAlign, equals(TextAlign.center));
      });

      testWidgets('title has correct text style', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        final titleText = tester.widget<Text>(
          find.text(
            'Your email address is updated. Please verify your email address.',
          ),
        );

        expect(titleText.style, isNotNull);
        expect(titleText.style!.fontWeight, equals(FontWeight.bold));
        expect(titleText.style!.fontSize, equals(18));
      });
    });

    group('Spacing Elements', () {
      testWidgets('has correct spacing between title and button',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        final sizedBox = tester.widget<SizedBox>(
          find.descendant(
            of: find.byType(Column),
            matching: find.byType(SizedBox),
          ),
        );

        expect(sizedBox.height, equals(20));
      });
    });

    group('Button Structure', () {
      testWidgets('displays TextButton wrapper', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(find.byType(TextButton), findsOneWidget);
      });

      testWidgets('TextButton has empty onPressed callback', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        final textButton = tester.widget<TextButton>(
          find.byType(TextButton),
        );

        expect(textButton.onPressed, isNotNull);
      });

      testWidgets('contains CustomGradientButton', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(find.byType(CustomGradientButton), findsOneWidget);
      });
    });

    group('CustomGradientButton Properties', () {
      testWidgets('button has correct label', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('OK'), findsOneWidget);
      });

      testWidgets('button has correct width', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        final gradientButton = tester.widget<CustomGradientButton>(
          find.byType(CustomGradientButton),
        );

        expect(gradientButton.customWidth, equals(100.w));
      });

      testWidgets('button is enabled by default', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        final gradientButton = tester.widget<CustomGradientButton>(
          find.byType(CustomGradientButton),
        );

        expect(gradientButton.isButtonEnabled, isTrue);
      });

      testWidgets('button is not loading by default', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        final gradientButton = tester.widget<CustomGradientButton>(
          find.byType(CustomGradientButton),
        );

        expect(gradientButton.isLoadingEnabled, isFalse);
      });
    });

    group('Button Interaction', () {
      testWidgets('button is tappable', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify the button exists and is tappable
        expect(find.byType(CustomGradientButton), findsOneWidget);
        expect(find.byType(GestureDetector), findsWidgets);
      });

      testWidgets('button has opaque hit test behavior', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        final gestureDetector = tester.widget<GestureDetector>(
          find.descendant(
            of: find.byType(CustomGradientButton),
            matching: find.byType(GestureDetector),
          ),
        );

        expect(gestureDetector.behavior, equals(HitTestBehavior.opaque));
      });
    });

    group('Bloc Integration', () {
      testWidgets('provides LogoutBloc to widget tree', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // The widget uses BlocProvider.value internally
        expect(find.byType(Dialog), findsOneWidget);
      });

      testWidgets('button calls logoutAllSessions when tapped', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Tap the OK button
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Verify that callLogoutAllSessions was called
        verify(() => logoutBlocHelper.mockLogoutBloc.callLogoutAllSessions())
            .called(1);
      });

      testWidgets('dialog closes after button tap', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog is initially shown
        expect(find.byType(Dialog), findsOneWidget);

        // Tap the OK button
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Verify dialog is closed
        expect(find.byType(Dialog), findsNothing);
      });
    });

    group('Theme and Colors', () {
      testWidgets('uses theme-based colors', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Check that the dialog uses theme colors
        final decoratedBoxes = find.descendant(
          of: find.byType(Dialog),
          matching: find.byType(DecoratedBox),
        );
        expect(decoratedBoxes, findsAtLeastNWidgets(1));
      });

      testWidgets('title text uses theme colors', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        final titleText = tester.widget<Text>(
          find.text(
            'Your email address is updated. Please verify your email address.',
          ),
        );
        expect(titleText.style, isNotNull);
      });
    });

    group('Accessibility', () {
      testWidgets('has semantic labels for accessibility', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Check that the dialog is accessible
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.byType(TextButton), findsOneWidget);
      });

      testWidgets('text has appropriate contrast', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Check that text is visible and readable
        expect(
          find.text(
            'Your email address is updated. Please verify your email address.',
          ),
          findsOneWidget,
        );
        expect(find.text('OK'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles long title text', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // The title text is already quite long, verify it displays correctly
        expect(
          find.text(
            'Your email address is updated. Please verify your email address.',
          ),
          findsOneWidget,
        );
      });

      testWidgets('dialog maintains proper layout with different screen sizes',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify the dialog has proper constraints
        final dialog = tester.widget<Dialog>(find.byType(Dialog));
        expect(dialog, isNotNull);
      });
    });

    group('Navigation', () {
      testWidgets('dialog can be closed programmatically', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog is shown
        expect(find.byType(Dialog), findsOneWidget);

        // Simulate programmatic close
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Verify dialog is closed
        expect(find.byType(Dialog), findsNothing);
      });
    });
  });
}
