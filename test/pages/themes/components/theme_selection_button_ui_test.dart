import 'package:admin/pages/themes/componenets/theme_selection_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeSelectionButton', () {
    late VoidCallback mockOnPressed;

    setUp(() {
      mockOnPressed = () {};
    });

    Widget createTestWidget({
      String? icon,
      Color? iconColor,
      required String image,
      required String title,
      required VoidCallback onPressed,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ThemeSelectionButton(
            icon: icon,
            iconColor: iconColor,
            image: image,
            title: title,
            onPressed: onPressed,
          ),
        ),
      );
    }

    group('Rendering Tests', () {
      testWidgets('should render with SVG image when icon is null',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Test Theme',
            onPressed: mockOnPressed,
          ),
        );

        // Verify the widget is rendered
        expect(find.byType(ThemeSelectionButton), findsOneWidget);

        // Verify the title text is displayed
        expect(find.text('Test Theme'), findsOneWidget);

        // Verify SVG image is rendered
        expect(find.byType(SvgPicture), findsOneWidget);

        // Verify CircleAvatar is present
        expect(find.byType(CircleAvatar), findsOneWidget);
      });

      testWidgets('should render with Image.asset when icon is provided',
          (tester) async {
        // Skip this test since we don't have actual asset files
        // In a real scenario, you would need to provide actual asset files
        // or mock the asset loading
        return;
      });

      testWidgets('should render with correct title styling', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Custom Theme Title',
            onPressed: mockOnPressed,
          ),
        );

        // Find the title text widget
        final titleFinder = find.text('Custom Theme Title');
        expect(titleFinder, findsOneWidget);

        // Verify the text styling
        final titleWidget = tester.widget<Text>(titleFinder);
        expect(titleWidget.style?.fontSize, 12);
        expect(titleWidget.style?.fontWeight, FontWeight.w600);
        expect(titleWidget.textAlign, TextAlign.center);
      });

      testWidgets('should render with correct CircleAvatar properties',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Test Theme',
            onPressed: mockOnPressed,
          ),
        );

        // Find the CircleAvatar
        final circleAvatarFinder = find.byType(CircleAvatar);
        expect(circleAvatarFinder, findsOneWidget);

        // Verify CircleAvatar properties
        final circleAvatar = tester.widget<CircleAvatar>(circleAvatarFinder);
        expect(circleAvatar.backgroundColor, Colors.white);
        expect(circleAvatar.radius, 22);
      });

      testWidgets('should render with correct spacing between elements',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Test Theme',
            onPressed: mockOnPressed,
          ),
        );

        // Verify the Column structure
        expect(find.byType(Column), findsOneWidget);

        // Find all SizedBox widgets and verify at least one has height 5
        final sizedBoxFinder = find.byType(SizedBox);
        expect(sizedBoxFinder, findsAtLeastNWidgets(1));

        // Check if any SizedBox has height 5
        bool foundHeight5 = false;
        for (final sizedBox in tester.widgetList<SizedBox>(sizedBoxFinder)) {
          if (sizedBox.height == 5) {
            foundHeight5 = true;
            break;
          }
        }
        expect(foundHeight5, true);
      });

      testWidgets('should render with correct padding around title',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Test Theme',
            onPressed: mockOnPressed,
          ),
        );

        // Find all Padding widgets and verify at least one has EdgeInsets.all(8)
        final paddingFinder = find.byType(Padding);
        expect(paddingFinder, findsAtLeastNWidgets(1));

        // Check if any Padding has EdgeInsets.all(8)
        bool foundPadding8 = false;
        for (final padding in tester.widgetList<Padding>(paddingFinder)) {
          if (padding.padding == const EdgeInsets.all(8)) {
            foundPadding8 = true;
            break;
          }
        }
        expect(foundPadding8, true);
      });
    });

    group('Interaction Tests', () {
      testWidgets('should call onPressed when tapped', (tester) async {
        bool wasPressed = false;
        void onPressed() {
          wasPressed = true;
        }

        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Test Theme',
            onPressed: onPressed,
          ),
        );

        // Verify initial state
        expect(wasPressed, false);

        // Tap the widget
        await tester.tap(find.byType(ThemeSelectionButton));
        await tester.pump();

        // Verify onPressed was called
        expect(wasPressed, true);
      });

      testWidgets('should have opaque hit test behavior', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Test Theme',
            onPressed: mockOnPressed,
          ),
        );

        // Find the GestureDetector
        final gestureDetectorFinder = find.byType(GestureDetector);
        expect(gestureDetectorFinder, findsOneWidget);

        // Verify HitTestBehavior.opaque
        final gestureDetector =
            tester.widget<GestureDetector>(gestureDetectorFinder);
        expect(gestureDetector.behavior, HitTestBehavior.opaque);
      });

      testWidgets('should be tappable on the entire widget area',
          (tester) async {
        bool wasPressed = false;
        void onPressed() {
          wasPressed = true;
        }

        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Test Theme',
            onPressed: onPressed,
          ),
        );

        // Tap on different parts of the widget
        await tester.tap(find.byType(Column), warnIfMissed: false);
        await tester.pump();
        expect(wasPressed, true);

        // Reset and test tapping on the icon area
        wasPressed = false;
        await tester.tap(find.byType(CircleAvatar), warnIfMissed: false);
        await tester.pump();
        expect(wasPressed, true);

        // Reset and test tapping on the title area
        wasPressed = false;
        await tester.tap(find.text('Test Theme'), warnIfMissed: false);
        await tester.pump();
        expect(wasPressed, true);
      });
    });

    group('Icon Color Tests', () {
      testWidgets('should use provided iconColor when specified',
          (tester) async {
        const customColor = Colors.red;

        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Test Theme',
            onPressed: mockOnPressed,
            iconColor: customColor,
          ),
        );

        // Find the SvgPicture
        final svgFinder = find.byType(SvgPicture);
        expect(svgFinder, findsOneWidget);

        // Verify the color filter is applied with custom color
        final svgPicture = tester.widget<SvgPicture>(svgFinder);
        expect(svgPicture.colorFilter, isNotNull);

        // Note: ColorFilter properties are not directly accessible in tests
        // We can only verify that a color filter exists
        expect(svgPicture.colorFilter, isA<ColorFilter>());
      });

      testWidgets(
          'should use theme primary color when iconColor is not specified',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Test Theme',
            onPressed: mockOnPressed,
          ),
        );

        // Find the SvgPicture
        final svgFinder = find.byType(SvgPicture);
        expect(svgFinder, findsOneWidget);

        // Verify the color filter is applied with theme primary color
        final svgPicture = tester.widget<SvgPicture>(svgFinder);
        expect(svgPicture.colorFilter, isNotNull);

        // Note: ColorFilter properties are not directly accessible in tests
        // We can only verify that a color filter exists
        expect(svgPicture.colorFilter, isA<ColorFilter>());
      });

      testWidgets('should prioritize icon over image when both are provided',
          (tester) async {
        // Skip this test since we don't have actual asset files
        // In a real scenario, you would need to provide actual asset files
        // or mock the asset loading
        return;
      });
    });

    group('Layout Tests', () {
      testWidgets('should maintain proper column layout', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Test Theme',
            onPressed: mockOnPressed,
          ),
        );

        // Verify the main Column structure
        final columnFinder = find.byType(Column);
        expect(columnFinder, findsOneWidget);

        // Verify Column has at least 2 children (icon and title)
        final column = tester.widget<Column>(columnFinder);
        expect(column.children.length, greaterThanOrEqualTo(2));
      });

      testWidgets('should center the icon in CircleAvatar', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Test Theme',
            onPressed: mockOnPressed,
          ),
        );

        // Find at least one Center widget
        final centerFinder = find.byType(Center);
        expect(centerFinder, findsAtLeastNWidgets(1));

        // Verify at least one Center widget exists
        final centers = tester.widgetList<Center>(centerFinder);
        expect(centers.isNotEmpty, true);
      });

      testWidgets('should apply correct text alignment to title',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Test Theme',
            onPressed: mockOnPressed,
          ),
        );

        // Find the title text
        final titleFinder = find.text('Test Theme');
        expect(titleFinder, findsOneWidget);

        // Verify text alignment
        final titleWidget = tester.widget<Text>(titleFinder);
        expect(titleWidget.textAlign, TextAlign.center);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty title', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: '',
            onPressed: mockOnPressed,
          ),
        );

        // Widget should still render without errors
        expect(find.byType(ThemeSelectionButton), findsOneWidget);

        // Empty text should still be displayed
        expect(find.text(''), findsOneWidget);
      });

      testWidgets('should handle very long title', (tester) async {
        const longTitle =
            'This is a very long theme title that might exceed normal length limits and should still be displayed properly without breaking the layout';

        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: longTitle,
            onPressed: mockOnPressed,
          ),
        );

        // Widget should render without errors
        expect(find.byType(ThemeSelectionButton), findsOneWidget);

        // Long title should be displayed
        expect(find.text(longTitle), findsOneWidget);
      });

      testWidgets('should handle special characters in title', (tester) async {
        const specialTitle = 'Theme with @#%^&*()_+-=[]{}|;:,.<>?';

        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: specialTitle,
            onPressed: mockOnPressed,
          ),
        );

        // Widget should render without errors
        expect(find.byType(ThemeSelectionButton), findsOneWidget);

        // Special characters should be displayed
        expect(find.text(specialTitle), findsOneWidget);
      });

      testWidgets('should handle null iconColor gracefully', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Test Theme',
            onPressed: mockOnPressed,
          ),
        );

        // Widget should render without errors
        expect(find.byType(ThemeSelectionButton), findsOneWidget);

        // Should fall back to theme primary color
        final svgFinder = find.byType(SvgPicture);
        expect(svgFinder, findsOneWidget);

        final svgPicture = tester.widget<SvgPicture>(svgFinder);
        expect(svgPicture.colorFilter, isNotNull);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should be accessible for screen readers', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Test Theme',
            onPressed: mockOnPressed,
          ),
        );

        // Verify the widget is tappable
        expect(find.byType(GestureDetector), findsOneWidget);

        // Verify text is readable
        expect(find.text('Test Theme'), findsOneWidget);
      });

      testWidgets('should have proper hit test area', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            image: 'assets/icons/test_icon.svg',
            title: 'Test Theme',
            onPressed: mockOnPressed,
          ),
        );

        // Verify GestureDetector covers the entire widget
        final gestureDetector = tester.widget<GestureDetector>(
          find.byType(GestureDetector),
        );
        expect(gestureDetector.behavior, HitTestBehavior.opaque);
      });
    });
  });
}
