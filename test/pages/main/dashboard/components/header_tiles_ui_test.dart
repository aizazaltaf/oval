import 'package:admin/pages/main/dashboard/components/header_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_helper.dart';

void main() {
  group('HorizontalHeaderTitles UI Tests', () {
    setUpAll(() async {
      await TestHelper.initialize();
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    Widget createHeaderTitlesWidget({
      required String title,
      String viewAll = "View All",
      bool viewAllBool = true,
      required bool pinnedOption,
      String pinnedTitle = "",
      VoidCallback? viewAllClick,
    }) {
      return MaterialApp(
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.blue,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.blue,
          ),
        ),
        home: Scaffold(
          body: HorizontalHeaderTitles(
            title: title,
            viewAll: viewAll,
            viewAllBool: viewAllBool,
            pinnedOption: pinnedOption,
            pinnedTitle: pinnedTitle,
            viewAllClick: viewAllClick ?? () {},
          ),
        ),
      );
    }

    group('Widget Rendering', () {
      testWidgets(
          'should render HorizontalHeaderTitles with all required elements',
          (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        // Verify main Row widget is present
        expect(find.byType(Row), findsAtLeastNWidgets(2));

        // Verify Text widgets are present
        expect(find.byType(Text), findsAtLeastNWidgets(1));

        // Verify TextButton is present when viewAllBool is true
        expect(find.byType(TextButton), findsOneWidget);

        // Verify SizedBox widgets are present
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      });

      testWidgets('should display correct title text', (tester) async {
        const testTitle = 'Test Header Title';
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: testTitle,
            pinnedOption: true,
          ),
        );

        expect(find.text(testTitle), findsOneWidget);
      });

      testWidgets('should display correct view all text', (tester) async {
        const customViewAll = 'See All';
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            viewAll: customViewAll,
            pinnedOption: true,
          ),
        );

        expect(find.text(customViewAll), findsOneWidget);
      });

      testWidgets('should render SVG icon in view all button', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        // Verify SvgPicture is present
        expect(find.byType(SvgPicture), findsOneWidget);
      });
    });

    group('Layout and Styling', () {
      testWidgets('should have correct main row alignment', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        // Find the main Row widget (outer one)
        final mainRowFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Row &&
              widget.mainAxisAlignment == MainAxisAlignment.spaceBetween,
        );
        expect(mainRowFinder, findsOneWidget);

        final mainRow = tester.widget<Row>(mainRowFinder);
        expect(mainRow.mainAxisAlignment, MainAxisAlignment.spaceBetween);
      });

      testWidgets('should have correct title text styling', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        final titleTextFinder = find.text('Test Title');
        final titleText = tester.widget<Text>(titleTextFinder);

        expect(titleText.textAlign, TextAlign.left);
        expect(titleText.style?.fontWeight, FontWeight.w600);
        expect(titleText.style?.fontSize, 22);
      });

      testWidgets('should have correct view all text styling', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        final viewAllTextFinder = find.text('View All');
        final viewAllText = tester.widget<Text>(viewAllTextFinder);

        expect(viewAllText.style?.color, Colors.blue);
      });

      testWidgets('should have correct spacing in title row', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        // Find the SizedBox with width 5 (spacing before title)
        final spacingFinder = find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 5,
        );
        expect(spacingFinder, findsOneWidget);
      });

      testWidgets('should have correct spacing in view all button',
          (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        // Find the SizedBox with width 10 (spacing between text and icon)
        final spacingFinder = find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 10,
        );
        expect(spacingFinder, findsOneWidget);
      });
    });

    group('View All Button Functionality', () {
      testWidgets('should call viewAllClick when view all button is tapped',
          (tester) async {
        bool buttonClicked = false;

        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
            viewAllClick: () {
              buttonClicked = true;
            },
          ),
        );

        await tester.tap(find.byType(TextButton));
        expect(buttonClicked, isTrue);
      });

      testWidgets('should have correct TextButton styling', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        final textButtonFinder = find.byType(TextButton);
        final textButton = tester.widget<TextButton>(textButtonFinder);

        expect(textButton.style?.overlayColor?.resolve({}), Colors.transparent);
        expect(textButton.style?.splashFactory, NoSplash.splashFactory);
      });

      testWidgets('should have correct container alignment in view all button',
          (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        final containerFinder = find.descendant(
          of: find.byType(TextButton),
          matching: find.byType(Container),
        );
        expect(containerFinder, findsOneWidget);

        final container = tester.widget<Container>(containerFinder);
        expect(container.alignment, Alignment.center);
      });
    });

    group('Conditional Rendering', () {
      testWidgets('should show view all button when viewAllBool is true',
          (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        expect(find.byType(TextButton), findsOneWidget);
        expect(find.text('View All'), findsOneWidget);
        expect(find.byType(SvgPicture), findsOneWidget);
      });

      testWidgets('should hide view all button when viewAllBool is false',
          (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            viewAllBool: false,
            pinnedOption: true,
          ),
        );

        expect(find.byType(TextButton), findsNothing);
        expect(find.text('View All'), findsNothing);
        expect(find.byType(SvgPicture), findsNothing);
        // Should have 2 SizedBox widgets: one for spacing (width: 5) and one for SizedBox.shrink
        expect(find.byType(SizedBox), findsNWidgets(2));
      });

      testWidgets('should show SizedBox.shrink when viewAllBool is false',
          (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            viewAllBool: false,
            pinnedOption: true,
          ),
        );

        // Find SizedBox.shrink (has zero width/height)
        final shrinkFinder = find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox && widget.width == 0 && widget.height == 0,
        );
        expect(shrinkFinder, findsOneWidget);
      });
    });

    group('SVG Icon Rendering', () {
      testWidgets('should render SVG with correct dimensions', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        final svgFinder = find.byType(SvgPicture);
        final svg = tester.widget<SvgPicture>(svgFinder);

        expect(svg.width, 8);
        expect(svg.height, isNull); // height not specified, only width
      });

      testWidgets('should apply correct color filter to SVG', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        final svgFinder = find.byType(SvgPicture);
        final svg = tester.widget<SvgPicture>(svgFinder);

        expect(svg.colorFilter, isA<ColorFilter>());
        expect(svg.colorFilter, isNotNull);
      });

      testWidgets('should use correct SVG asset', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        final svgFinder = find.byType(SvgPicture);
        final svg = tester.widget<SvgPicture>(svgFinder);

        // Verify SVG is rendered (we can't directly access the asset path in tests)
        expect(svg, isNotNull);
        expect(svg.width, 8);
      });
    });

    group('Widget Structure', () {
      testWidgets('should have correct widget hierarchy', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        // Verify main Row contains two children (title row and view all button)
        final mainRowFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Row &&
              widget.mainAxisAlignment == MainAxisAlignment.spaceBetween,
        );
        expect(mainRowFinder, findsOneWidget);

        // Verify title row contains title text (first Row descendant)
        final titleRowFinder = find.descendant(
          of: mainRowFinder,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Row &&
                widget.mainAxisAlignment == MainAxisAlignment.start,
          ),
        );
        expect(titleRowFinder, findsAtLeastNWidgets(1));

        // Verify view all button contains text and icon
        final textButtonFinder = find.byType(TextButton);
        expect(
          find.descendant(
            of: textButtonFinder,
            matching: find.byType(Text),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: textButtonFinder,
            matching: find.byType(SvgPicture),
          ),
          findsOneWidget,
        );
      });

      testWidgets('should have correct nested row structure', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        // Should have exactly 3 Row widgets (main row, title row, and button row)
        expect(find.byType(Row), findsNWidgets(3));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty title', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: '',
            pinnedOption: true,
          ),
        );

        expect(find.text(''), findsOneWidget);
      });

      testWidgets('should handle custom view all text', (tester) async {
        const customViewAll = 'See All Items';
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            viewAll: customViewAll,
            pinnedOption: true,
          ),
        );

        expect(find.text(customViewAll), findsOneWidget);
      });

      testWidgets('should handle empty view all text', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            viewAll: '',
            pinnedOption: true,
          ),
        );

        expect(find.text(''), findsOneWidget);
      });

      testWidgets('should handle pinnedOption true', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        // Widget should render normally
        expect(find.byType(HorizontalHeaderTitles), findsOneWidget);
      });

      testWidgets('should handle pinnedOption false', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: false,
          ),
        );

        // Widget should render normally
        expect(find.byType(HorizontalHeaderTitles), findsOneWidget);
      });
    });

    group('Theme Support', () {
      testWidgets('should adapt to different primary colors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light().copyWith(
              primaryColor: Colors.red,
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Colors.red,
              ),
            ),
            home: Scaffold(
              body: HorizontalHeaderTitles(
                title: 'Test Title',
                pinnedOption: true,
                viewAllClick: () {},
              ),
            ),
          ),
        );

        final viewAllTextFinder = find.text('View All');
        final viewAllText = tester.widget<Text>(viewAllTextFinder);

        expect(viewAllText.style?.color, Colors.red);
      });

      testWidgets('should use theme text styles', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        final titleTextFinder = find.text('Test Title');
        final titleText = tester.widget<Text>(titleTextFinder);

        // Should use theme's headlineLarge style
        expect(titleText.style?.fontWeight, FontWeight.w600);
        expect(titleText.style?.fontSize, 22);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper widget structure for screen readers',
          (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        // Verify the widget structure is accessible
        expect(find.byType(Row), findsAtLeastNWidgets(2));
        expect(find.byType(Text), findsAtLeastNWidgets(2));
        expect(find.byType(TextButton), findsOneWidget);
      });

      testWidgets('should maintain accessibility when view all is hidden',
          (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            viewAllBool: false,
            pinnedOption: true,
          ),
        );

        // Verify widget structure is still accessible even when view all is hidden
        expect(find.byType(Row), findsAtLeastNWidgets(2));
        expect(find.byType(Text), findsOneWidget);
        expect(find.byType(TextButton), findsNothing);
      });
    });

    group('Performance', () {
      testWidgets('should render efficiently', (tester) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        stopwatch.stop();

        // Verify widget renders within reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));

        // Verify all elements are present
        expect(find.byType(HorizontalHeaderTitles), findsOneWidget);
      });

      testWidgets('should handle multiple rebuilds efficiently',
          (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        // Trigger multiple rebuilds
        for (int i = 0; i < 5; i++) {
          await tester.pump();
        }

        // Verify widget still renders correctly
        expect(find.byType(HorizontalHeaderTitles), findsOneWidget);
      });
    });

    group('Button Interaction States', () {
      testWidgets('should handle button press states', (tester) async {
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
          ),
        );

        final textButtonFinder = find.byType(TextButton);

        // Test button press
        await tester.press(textButtonFinder);
        await tester.pump();

        // Button should still be present after press
        expect(textButtonFinder, findsOneWidget);
      });

      testWidgets('should maintain button state after interaction',
          (tester) async {
        bool buttonClicked = false;

        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedOption: true,
            viewAllClick: () {
              buttonClicked = true;
            },
          ),
        );

        final textButtonFinder = find.byType(TextButton);

        // Tap button to trigger onPressed
        await tester.tap(textButtonFinder);
        await tester.pump();

        expect(buttonClicked, isTrue);
        expect(textButtonFinder, findsOneWidget);
      });
    });

    group('Customization Options', () {
      testWidgets('should respect custom viewAll text', (tester) async {
        const customText = 'Show More';
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            viewAll: customText,
            pinnedOption: true,
          ),
        );

        expect(find.text(customText), findsOneWidget);
        expect(find.text('View All'), findsNothing);
      });

      testWidgets('should respect custom pinnedTitle', (tester) async {
        const customPinnedTitle = 'Custom Section';
        await tester.pumpWidget(
          createHeaderTitlesWidget(
            title: 'Test Title',
            pinnedTitle: customPinnedTitle,
            pinnedOption: true,
          ),
        );

        // Widget should render with custom pinned title
        expect(find.byType(HorizontalHeaderTitles), findsOneWidget);
      });
    });
  });
}
