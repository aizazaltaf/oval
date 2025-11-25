import 'package:admin/core/theme.dart';
import 'package:admin/pages/main/more_dashboard/components/more_list_tile_card.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helper.dart';

void main() {
  setUpAll(() async {
    await TestHelper.initialize();
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
  });

  Widget createTestWidget({
    String? title,
    Widget? leadingWidget,
    EdgeInsets? leadingPadding,
    VoidCallback? onSubmit,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: getTheme(),
      darkTheme: darkTheme(),
      home: Scaffold(
        body: MoreListTileCard(
          title: title,
          leadingWidget: leadingWidget ?? const Icon(Icons.home),
          leadingPadding: leadingPadding,
          onSubmit: onSubmit ?? () {},
        ),
      ),
    );
  }

  group('MoreListTileCard UI Tests', () {
    group('Rendering Tests', () {
      testWidgets('should render MoreListTileCard with all required properties',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Test Title',
            leadingWidget: const Icon(Icons.settings),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget is rendered
        expect(find.byType(MoreListTileCard), findsOneWidget);
        expect(find.byType(ListTile), findsOneWidget);

        // Verify title is displayed
        expect(find.text('TEST TITLE'), findsOneWidget);

        // Verify leading widget is present
        expect(find.byType(Icon), findsOneWidget);
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('should render with null title', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            leadingWidget: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget is rendered
        expect(find.byType(MoreListTileCard), findsOneWidget);
        expect(find.byType(ListTile), findsOneWidget);

        // Verify empty string is displayed for null title
        expect(find.text(''), findsOneWidget);
      });

      testWidgets('should render with empty string title', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: '',
            leadingWidget: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget is rendered
        expect(find.byType(MoreListTileCard), findsOneWidget);
        expect(find.byType(ListTile), findsOneWidget);

        // Verify empty string is displayed
        expect(find.text(''), findsOneWidget);
      });

      testWidgets('should render with different leading widgets',
          (tester) async {
        // Test with Icon
        await tester.pumpWidget(
          createTestWidget(
            title: 'Icon Test',
            leadingWidget: const Icon(Icons.favorite),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.favorite), findsOneWidget);

        // Test with Text widget
        await tester.pumpWidget(
          createTestWidget(
            title: 'Text Test',
            leadingWidget: const Text('Leading Text'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Leading Text'), findsOneWidget);

        // Test with Container
        await tester.pumpWidget(
          createTestWidget(
            title: 'Container Test',
            leadingWidget: Container(
              width: 24,
              height: 24,
              color: Colors.red,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Container), findsAtLeast(1));
      });

      testWidgets('should apply leading padding when provided', (tester) async {
        const customPadding = EdgeInsets.all(8);

        await tester.pumpWidget(
          createTestWidget(
            title: 'Padding Test',
            leadingWidget: const Icon(Icons.home),
            leadingPadding: customPadding,
          ),
        );
        await tester.pumpAndSettle();

        // Find the Container that wraps the leading widget
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(ListTile),
            matching: find.byType(Container),
          ),
        );

        expect(container.padding, equals(customPadding));
      });

      testWidgets('should not apply padding when leadingPadding is null',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'No Padding Test',
            leadingWidget: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Find the Container that wraps the leading widget
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(ListTile),
            matching: find.byType(Container),
          ),
        );

        expect(container.padding, isNull);
      });
    });

    group('Text Styling Tests', () {
      testWidgets('should apply correct text styling', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Styled Text',
            leadingWidget: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Find the Text widget
        final textWidget = tester.widget<Text>(
          find.descendant(
            of: find.byType(ListTile),
            matching: find.byType(Text),
          ),
        );

        // Verify text style properties
        expect(textWidget.style?.fontSize, equals(16));
        expect(textWidget.style?.fontWeight, equals(FontWeight.w400));
      });

      testWidgets('should convert title to uppercase', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'lowercase title',
            leadingWidget: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the text is displayed in uppercase
        expect(find.text('LOWERCASE TITLE'), findsOneWidget);
        expect(find.text('lowercase title'), findsNothing);
      });

      testWidgets('should handle numbers in title', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Title with 123 numbers',
            leadingWidget: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Verify numbers are preserved and converted to uppercase
        expect(find.text('TITLE WITH 123 NUMBERS'), findsOneWidget);
      });
    });

    group('Interaction Tests', () {
      testWidgets('should call onSubmit when tapped', (tester) async {
        bool onTapCalled = false;

        await tester.pumpWidget(
          createTestWidget(
            title: 'Tap Test',
            leadingWidget: const Icon(Icons.home),
            onSubmit: () {
              onTapCalled = true;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Verify the ListTile is tappable
        expect(find.byType(ListTile), findsOneWidget);

        // Tap the ListTile
        await tester.tap(find.byType(ListTile));
        await tester.pumpAndSettle();

        // Verify the callback was called
        expect(onTapCalled, isTrue);
      });

      testWidgets('should handle multiple taps', (tester) async {
        int tapCount = 0;

        await tester.pumpWidget(
          createTestWidget(
            title: 'Multiple Tap Test',
            leadingWidget: const Icon(Icons.home),
            onSubmit: () {
              tapCount++;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Tap multiple times
        await tester.tap(find.byType(ListTile));
        await tester.tap(find.byType(ListTile));
        await tester.tap(find.byType(ListTile));
        await tester.pumpAndSettle();

        // Verify the callback was called for each tap
        expect(tapCount, equals(3));
      });

      testWidgets('should handle tap on leading widget area', (tester) async {
        bool onTapCalled = false;

        await tester.pumpWidget(
          createTestWidget(
            title: 'Leading Tap Test',
            leadingWidget: const Icon(Icons.home),
            onSubmit: () {
              onTapCalled = true;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Tap on the leading widget area
        await tester.tap(find.byIcon(Icons.home));
        await tester.pumpAndSettle();

        // Verify the callback was called
        expect(onTapCalled, isTrue);
      });

      testWidgets('should handle tap on title area', (tester) async {
        bool onTapCalled = false;

        await tester.pumpWidget(
          createTestWidget(
            title: 'Title Tap Test',
            leadingWidget: const Icon(Icons.home),
            onSubmit: () {
              onTapCalled = true;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Tap on the title text
        await tester.tap(find.text('TITLE TAP TEST'));
        await tester.pumpAndSettle();

        // Verify the callback was called
        expect(onTapCalled, isTrue);
      });
    });

    group('Theme Tests', () {
      testWidgets('should use theme text styling', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Theme Test',
            leadingWidget: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Find the Text widget
        final textWidget = tester.widget<Text>(
          find.descendant(
            of: find.byType(ListTile),
            matching: find.byType(Text),
          ),
        );

        // Verify it uses theme text styling
        expect(textWidget.style, isNotNull);
        expect(textWidget.style?.fontSize, equals(16));
        expect(textWidget.style?.fontWeight, equals(FontWeight.w400));
      });

      testWidgets('should work with dark theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: darkTheme(),
            home: Scaffold(
              body: MoreListTileCard(
                title: 'Dark Theme Test',
                leadingWidget: const Icon(Icons.home),
                onSubmit: () {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget renders without errors in dark theme
        expect(find.byType(MoreListTileCard), findsOneWidget);
        expect(find.text('DARK THEME TEST'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle very long title', (tester) async {
        const longTitle =
            'This is a very long title that should be handled properly by the widget without causing any layout issues or overflow problems';

        await tester.pumpWidget(
          createTestWidget(
            title: longTitle,
            leadingWidget: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget renders without errors
        expect(find.byType(MoreListTileCard), findsOneWidget);
        expect(find.text(longTitle.toUpperCase()), findsOneWidget);
      });

      testWidgets('should handle title with only whitespace', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: '   ',
            leadingWidget: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget renders without errors
        expect(find.byType(MoreListTileCard), findsOneWidget);
        expect(find.text('   '), findsOneWidget);
      });

      testWidgets('should handle complex leading widget', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Complex Leading Test',
            leadingWidget: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star),
                SizedBox(width: 8),
                Text('Badge'),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget renders without errors
        expect(find.byType(MoreListTileCard), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.text('Badge'), findsOneWidget);
      });

      testWidgets('should handle empty leading widget', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Empty Leading Test',
            leadingWidget: const SizedBox.shrink(),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget renders without errors
        expect(find.byType(MoreListTileCard), findsOneWidget);
        expect(find.byType(SizedBox), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should rebuild efficiently', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Performance Test',
            leadingWidget: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Force multiple rebuilds
        for (int i = 0; i < 10; i++) {
          await tester.pumpWidget(
            createTestWidget(
              title: 'Performance Test $i',
              leadingWidget: const Icon(Icons.home),
            ),
          );
          await tester.pumpAndSettle();
        }

        // Verify the widget still renders correctly
        expect(find.byType(MoreListTileCard), findsOneWidget);
        expect(find.text('PERFORMANCE TEST 9'), findsOneWidget);
      });
    });
  });
}
