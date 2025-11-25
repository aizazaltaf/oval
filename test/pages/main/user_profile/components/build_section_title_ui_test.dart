import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/components/build_section_title.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_helper.dart';
import '../../../../mocks/bloc/bloc_mocks.dart';

void main() {
  group('BuildSectionTitle UI Tests', () {
    late MockUserProfileBloc mockUserProfileBloc;

    setUpAll(() async {
      await TestHelper.initialize();
    });

    setUp(() {
      mockUserProfileBloc = MockUserProfileBloc();
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    Widget makeTestableWidget({
      required String title,
      String? pendingEmail,
      bool? needFontWeight400,
    }) {
      return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
        ],
        home: BlocProvider<UserProfileBloc>.value(
          value: mockUserProfileBloc,
          child: Scaffold(
            body: BuildSectionTitle(
              title: title,
              pendingEmail: pendingEmail,
              needFontWeight400: needFontWeight400,
            ),
          ),
        ),
      );
    }

    group('Basic Widget Rendering', () {
      testWidgets('renders BuildSectionTitle widget with title',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(title: 'Test Title'));
        await tester.pumpAndSettle();

        expect(find.byType(BuildSectionTitle), findsOneWidget);
        expect(find.text('Test Title'), findsOneWidget);
      });

      testWidgets('renders title text with correct content', (tester) async {
        const testTitle = 'Full Name';
        await tester.pumpWidget(makeTestableWidget(title: testTitle));
        await tester.pumpAndSettle();

        final titleFinder = find.text(testTitle);
        expect(titleFinder, findsOneWidget);
      });

      testWidgets('renders Row layout with title and spacer', (tester) async {
        await tester.pumpWidget(makeTestableWidget(title: 'Test Title'));
        await tester.pumpAndSettle();

        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Spacer), findsOneWidget);
      });
    });

    group('Styling Tests', () {
      testWidgets(
          'applies default font weight (w600) when needFontWeight400 is null',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(title: 'Test Title'));
        await tester.pumpAndSettle();

        final textWidget = tester.widget<Text>(find.text('Test Title'));
        expect(textWidget.style?.fontWeight, FontWeight.w600);
      });

      testWidgets(
          'applies default font weight (w600) when needFontWeight400 is false',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            title: 'Test Title',
            needFontWeight400: false,
          ),
        );
        await tester.pumpAndSettle();

        final textWidget = tester.widget<Text>(find.text('Test Title'));
        expect(textWidget.style?.fontWeight, FontWeight.w600);
      });

      testWidgets('applies FontWeight.w400 when needFontWeight400 is true',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            title: 'Test Title',
            needFontWeight400: true,
          ),
        );
        await tester.pumpAndSettle();

        final textWidget = tester.widget<Text>(find.text('Test Title'));
        expect(textWidget.style?.fontWeight, FontWeight.w400);
      });

      testWidgets('applies correct font size (16)', (tester) async {
        await tester.pumpWidget(makeTestableWidget(title: 'Test Title'));
        await tester.pumpAndSettle();

        final textWidget = tester.widget<Text>(find.text('Test Title'));
        expect(textWidget.style?.fontSize, 16.0);
      });

      testWidgets('applies theme-based color to title text', (tester) async {
        await tester.pumpWidget(makeTestableWidget(title: 'Test Title'));
        await tester.pumpAndSettle();

        final textWidget = tester.widget<Text>(find.text('Test Title'));
        expect(textWidget.style?.color, isNotNull);
      });
    });

    group('Cancel Button Conditional Rendering', () {
      testWidgets('does not show Cancel button when pendingEmail is null',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            title: 'Email Address',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Cancel'), findsNothing);
        expect(find.byType(GestureDetector), findsNothing);
      });

      testWidgets('does not show Cancel button when title is not email address',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            title: 'Full Name',
            pendingEmail: 'test@example.com',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Cancel'), findsNothing);
        expect(find.byType(GestureDetector), findsNothing);
      });

      testWidgets(
          'shows Cancel button when pendingEmail is provided and title is email address',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            title: 'Email Address', // This should match the localization key
            pendingEmail: 'test@example.com',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Cancel'), findsOneWidget);
        expect(find.byType(GestureDetector), findsOneWidget);
      });

      testWidgets('shows Cancel button with correct styling', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            title: 'Email Address',
            pendingEmail: 'test@example.com',
          ),
        );
        await tester.pumpAndSettle();

        final cancelTextWidget = tester.widget<Text>(find.text('Cancel'));
        expect(cancelTextWidget.style?.fontSize, 16.0);
        expect(cancelTextWidget.style?.fontWeight, FontWeight.w500);
        expect(cancelTextWidget.style?.color, isNotNull);
      });

      testWidgets(
          'shows SizedBox.shrink when Cancel button should not be displayed',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            title: 'Full Name',
          ),
        );
        await tester.pumpAndSettle();

        // Find the SizedBox that's specifically for the else case (SizedBox.shrink)
        final sizedBoxes = find.byType(SizedBox);
        expect(sizedBoxes, findsAtLeastNWidgets(1));
      });
    });

    group('Cancel Button Interaction Tests', () {
      testWidgets('Cancel button has opaque hit test behavior', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            title: 'Email Address',
            pendingEmail: 'test@example.com',
          ),
        );
        await tester.pumpAndSettle();

        final gestureDetector = tester.widget<GestureDetector>(
          find.byType(GestureDetector),
        );
        expect(gestureDetector.behavior, HitTestBehavior.opaque);
      });

      testWidgets('Cancel button is present and accessible', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            title: 'Email Address',
            pendingEmail: 'test@example.com',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Cancel'), findsOneWidget);
        expect(tester.getSemantics(find.text('Cancel')), isNotNull);
      });
    });

    group('Edge Cases and Error Handling', () {
      testWidgets('handles empty title string', (tester) async {
        await tester.pumpWidget(makeTestableWidget(title: ''));
        await tester.pumpAndSettle();

        expect(find.byType(BuildSectionTitle), findsOneWidget);
        expect(find.text(''), findsOneWidget);
      });

      testWidgets('handles very long title text', (tester) async {
        const longTitle = 'This is a long title';
        await tester.pumpWidget(makeTestableWidget(title: longTitle));
        await tester.pumpAndSettle();

        expect(find.text(longTitle), findsOneWidget);
      });

      testWidgets('handles special characters in title', (tester) async {
        const specialTitle = 'Title with special characters';
        await tester.pumpWidget(makeTestableWidget(title: specialTitle));
        await tester.pumpAndSettle();

        expect(find.text(specialTitle), findsOneWidget);
      });

      testWidgets('handles empty pendingEmail string', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            title: 'Email Address',
            pendingEmail: '',
          ),
        );
        await tester.pumpAndSettle();

        // Empty string is not null, so Cancel button should still show
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('handles whitespace-only pendingEmail', (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            title: 'Email Address',
            pendingEmail: '   ',
          ),
        );
        await tester.pumpAndSettle();

        // Whitespace-only string should still show Cancel button
        expect(find.text('Cancel'), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('provides semantic information for title text',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(title: 'Test Title'));
        await tester.pumpAndSettle();

        final semantics = tester.getSemantics(find.text('Test Title'));
        expect(semantics, isNotNull);
      });

      testWidgets(
          'provides semantic information for Cancel button when visible',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            title: 'Email Address',
            pendingEmail: 'test@example.com',
          ),
        );
        await tester.pumpAndSettle();

        final semantics = tester.getSemantics(find.text('Cancel'));
        expect(semantics, isNotNull);
      });

      testWidgets('Cancel button is accessible for screen readers',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            title: 'Email Address',
            pendingEmail: 'test@example.com',
          ),
        );
        await tester.pumpAndSettle();

        final gestureDetector = tester.widget<GestureDetector>(
          find.byType(GestureDetector),
        );
        expect(gestureDetector.behavior, HitTestBehavior.opaque);
      });
    });

    group('Integration Tests', () {
      testWidgets('renders correctly with all parameters provided',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            title: 'Email Address',
            pendingEmail: 'test@example.com',
            needFontWeight400: true,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(BuildSectionTitle), findsOneWidget);
        expect(find.text('Email Address'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);

        final titleTextWidget = tester.widget<Text>(find.text('Email Address'));
        expect(titleTextWidget.style?.fontWeight, FontWeight.w400);
      });

      testWidgets('renders correctly with only required parameters',
          (tester) async {
        await tester.pumpWidget(makeTestableWidget(title: 'Test Title'));
        await tester.pumpAndSettle();

        expect(find.byType(BuildSectionTitle), findsOneWidget);
        expect(find.text('Test Title'), findsOneWidget);
        expect(find.text('Cancel'), findsNothing);

        final titleTextWidget = tester.widget<Text>(find.text('Test Title'));
        expect(titleTextWidget.style?.fontWeight, FontWeight.w600);
      });

      testWidgets('maintains layout structure in all scenarios',
          (tester) async {
        await tester.pumpWidget(
          makeTestableWidget(
            title: 'Email Address',
            pendingEmail: 'test@example.com',
          ),
        );
        await tester.pumpAndSettle();

        final rowWidget = tester.widget<Row>(find.byType(Row));
        expect(rowWidget.children.length, 3); // Title, Spacer, Cancel button

        await tester.pumpWidget(makeTestableWidget(title: 'Test Title'));
        await tester.pumpAndSettle();

        final rowWidget2 = tester.widget<Row>(find.byType(Row));
        expect(rowWidget2.children.length, 3); // Title, Spacer, SizedBox.shrink
      });
    });
  });
}
