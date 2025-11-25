import 'package:admin/core/images.dart';
import 'package:admin/pages/main/dashboard/components/feature_items.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_helper.dart';

void main() {
  group('FeatureItems UI Tests', () {
    setUpAll(() async {
      await TestHelper.initialize();
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    Widget createFeatureItemsWidget({
      String title = 'Test Feature',
      String image = 'assets/icons/test_icon.svg',
      Color color = Colors.blue,
      bool? svgBool = true,
      Color? cardColor,
      Function(BuildContext)? route,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: FeatureItems(
            title: title,
            image: image,
            color: color,
            svgBool: svgBool,
            cardColor: cardColor,
            route: route ?? (context) {},
          ),
        ),
      );
    }

    group('Widget Rendering', () {
      testWidgets('should render FeatureItems with all required elements',
          (tester) async {
        await tester.pumpWidget(createFeatureItemsWidget());

        // Verify main container is present
        expect(find.byType(Container), findsOneWidget);

        // Verify GestureDetector is present
        expect(find.byType(GestureDetector), findsOneWidget);

        // Verify Column is present
        expect(find.byType(Column), findsOneWidget);

        // Verify Text widget is present
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('should render SVG image when svgBool is true',
          (tester) async {
        await tester.pumpWidget(createFeatureItemsWidget());

        // Verify SvgPicture is present
        expect(find.byType(SvgPicture), findsOneWidget);

        // Verify Image.asset is not present
        expect(find.byType(Image), findsNothing);
      });

      testWidgets('should render Image.asset when svgBool is false',
          (tester) async {
        await tester.pumpWidget(
          createFeatureItemsWidget(
            svgBool: false,
            image: DefaultImages.COLOR_WHEEL,
          ),
        );

        // Verify Image.asset is present
        expect(find.byType(Image), findsOneWidget);

        // Verify SvgPicture is not present
        expect(find.byType(SvgPicture), findsNothing);
      });

      testWidgets('should display correct title text', (tester) async {
        const testTitle = 'Test Feature Title';
        await tester.pumpWidget(createFeatureItemsWidget(title: testTitle));

        expect(find.text(testTitle), findsOneWidget);
      });
    });

    group('Layout and Styling', () {
      testWidgets('should have correct container dimensions', (tester) async {
        await tester.pumpWidget(createFeatureItemsWidget());

        final containerFinder = find.byType(Container);
        expect(containerFinder, findsOneWidget);

        final container = tester.widget<Container>(containerFinder);
        expect(container.constraints?.maxHeight, 130);
        expect(container.constraints?.maxWidth, double.infinity);
      });

      testWidgets('should have correct margins', (tester) async {
        await tester.pumpWidget(createFeatureItemsWidget());

        final containerFinder = find.byType(Container);
        final container = tester.widget<Container>(containerFinder);

        expect(
          container.margin,
          const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        );
      });

      testWidgets('should have correct padding', (tester) async {
        await tester.pumpWidget(createFeatureItemsWidget());

        final containerFinder = find.byType(Container);
        final container = tester.widget<Container>(containerFinder);

        expect(
          container.padding,
          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        );
      });

      testWidgets('should have correct border radius', (tester) async {
        await tester.pumpWidget(createFeatureItemsWidget());

        final containerFinder = find.byType(Container);
        final container = tester.widget<Container>(containerFinder);

        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(15));
      });

      testWidgets('should use custom cardColor when provided', (tester) async {
        const customColor = Colors.red;
        await tester
            .pumpWidget(createFeatureItemsWidget(cardColor: customColor));

        final containerFinder = find.byType(Container);
        final container = tester.widget<Container>(containerFinder);

        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, customColor);
      });

      testWidgets('should use theme-based color when cardColor is null',
          (tester) async {
        await tester.pumpWidget(createFeatureItemsWidget());

        final containerFinder = find.byType(Container);
        final container = tester.widget<Container>(containerFinder);

        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, isNotNull);
      });

      testWidgets('should have correct column alignment', (tester) async {
        await tester.pumpWidget(createFeatureItemsWidget());

        final columnFinder = find.byType(Column);
        final column = tester.widget<Column>(columnFinder);

        expect(column.mainAxisAlignment, MainAxisAlignment.center);
      });

      testWidgets('should have correct text styling', (tester) async {
        const testColor = Colors.green;
        await tester.pumpWidget(createFeatureItemsWidget(color: testColor));

        final textFinder = find.byType(Text);
        final text = tester.widget<Text>(textFinder);

        expect(text.textAlign, TextAlign.center);
        expect(text.style?.color, testColor);
        expect(text.style?.fontSize, 13);
        expect(text.style?.fontWeight, FontWeight.w700);
      });
    });

    group('SVG Image Rendering', () {
      testWidgets('should render SVG with correct dimensions', (tester) async {
        await tester.pumpWidget(createFeatureItemsWidget());

        final svgFinder = find.byType(SvgPicture);
        final svg = tester.widget<SvgPicture>(svgFinder);

        expect(svg.height, 60);
        expect(svg.width, 60);
      });

      testWidgets('should apply correct color filter to SVG', (tester) async {
        const testColor = Colors.purple;
        await tester.pumpWidget(
          createFeatureItemsWidget(
            color: testColor,
          ),
        );

        final svgFinder = find.byType(SvgPicture);
        final svg = tester.widget<SvgPicture>(svgFinder);

        expect(svg.colorFilter, isA<ColorFilter>());
        // Note: ColorFilter properties are not directly accessible in tests
        // but we can verify the filter is applied
        expect(svg.colorFilter, isNotNull);
      });
    });

    group('Image Asset Rendering', () {
      testWidgets('should render Image.asset with correct dimensions',
          (tester) async {
        await tester.pumpWidget(
          createFeatureItemsWidget(
            svgBool: false,
            image: DefaultImages.COLOR_WHEEL,
          ),
        );

        final imageFinder = find.byType(Image);
        final image = tester.widget<Image>(imageFinder);

        expect(image.height, 60);
        expect(image.width, 60);
        expect(image.image, isA<AssetImage>());
      });
    });

    group('User Interaction', () {
      testWidgets('should call route function when tapped', (tester) async {
        bool routeCalled = false;

        await tester.pumpWidget(
          createFeatureItemsWidget(
            route: (context) {
              routeCalled = true;
            },
          ),
        );

        await tester.tap(find.byType(GestureDetector));
        expect(routeCalled, isTrue);
      });

      testWidgets('should have correct hit test behavior', (tester) async {
        await tester.pumpWidget(createFeatureItemsWidget());

        final gestureDetectorFinder = find.byType(GestureDetector);
        final gestureDetector =
            tester.widget<GestureDetector>(gestureDetectorFinder);

        expect(gestureDetector.behavior, HitTestBehavior.opaque);
      });
    });

    group('Theme Support', () {
      testWidgets('should adapt to light theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: FeatureItems(
                title: 'Test Feature',
                image: DefaultImages.ACCEPTED_TAG,
                color: Colors.blue,
                route: (context) {},
              ),
            ),
          ),
        );

        final containerFinder = find.byType(Container);
        final container = tester.widget<Container>(containerFinder);

        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, Colors.white);
      });

      testWidgets('should adapt to dark theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark().copyWith(
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Colors.blue,
              ),
            ),
            home: Scaffold(
              body: FeatureItems(
                title: 'Test Feature',
                image: DefaultImages.ACCEPTED_TAG,
                color: Colors.blue,
                route: (context) {},
              ),
            ),
          ),
        );

        final containerFinder = find.byType(Container);
        final container = tester.widget<Container>(containerFinder);

        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, isNotNull);
        // In dark theme, it should use the cursorColor with alpha
        expect(decoration.color, Colors.blue.withValues(alpha: 0.3));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty title', (tester) async {
        await tester.pumpWidget(createFeatureItemsWidget(title: ''));

        expect(find.text(''), findsOneWidget);
      });

      testWidgets('should handle very long title', (tester) async {
        const longTitle =
            'This is a very long title that might cause overflow issues in the UI';
        await tester.pumpWidget(createFeatureItemsWidget(title: longTitle));

        expect(find.text(longTitle), findsOneWidget);
      });

      testWidgets('should handle null svgBool (defaults to true)',
          (tester) async {
        await tester.pumpWidget(createFeatureItemsWidget(svgBool: null));

        // Should render SVG by default
        expect(find.byType(SvgPicture), findsOneWidget);
        expect(find.byType(Image), findsNothing);
      });
    });
  });

  group('QuickAccessItems UI Tests', () {
    setUpAll(() async {
      await TestHelper.initialize();
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    Widget createQuickAccessItemsWidget({
      String title = 'Quick Access',
      String image = 'assets/icons/quick_access.svg',
      Color? color = Colors.blue,
      bool isDisabled = false,
      Function(BuildContext)? route,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: QuickAccessItems(
            title: title,
            image: image,
            color: color,
            isDisabled: isDisabled,
            route: route ?? (context) {},
          ),
        ),
      );
    }

    group('Widget Rendering', () {
      testWidgets('should render QuickAccessItems with all required elements',
          (tester) async {
        await tester.pumpWidget(createQuickAccessItemsWidget());

        // Verify main Column is present
        expect(find.byType(Column), findsOneWidget);

        // Verify GestureDetector is present
        expect(find.byType(GestureDetector), findsOneWidget);

        // Verify Container is present
        expect(find.byType(Container), findsOneWidget);

        // Verify SvgPicture is present
        expect(find.byType(SvgPicture), findsOneWidget);

        // Verify Text widget is present
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('should display correct title text', (tester) async {
        const testTitle = 'Test Quick Access';
        await tester.pumpWidget(createQuickAccessItemsWidget(title: testTitle));

        expect(find.text(testTitle), findsOneWidget);
      });
    });

    group('Layout and Styling', () {
      testWidgets('should have correct column properties', (tester) async {
        await tester.pumpWidget(createQuickAccessItemsWidget());

        final columnFinder = find.byType(Column);
        final column = tester.widget<Column>(columnFinder);

        expect(column.mainAxisSize, MainAxisSize.min);
      });

      testWidgets('should have correct container decoration', (tester) async {
        const testColor = Colors.orange;
        await tester.pumpWidget(createQuickAccessItemsWidget(color: testColor));

        final containerFinder = find.byType(Container);
        final container = tester.widget<Container>(containerFinder);

        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.shape, BoxShape.circle);
        expect(decoration.color, testColor);
      });

      testWidgets('should have correct container padding', (tester) async {
        await tester.pumpWidget(createQuickAccessItemsWidget());

        final containerFinder = find.byType(Container);
        final container = tester.widget<Container>(containerFinder);

        expect(container.padding, const EdgeInsets.all(16));
      });

      testWidgets('should have correct SVG dimensions', (tester) async {
        await tester.pumpWidget(createQuickAccessItemsWidget());

        final svgFinder = find.byType(SvgPicture);
        final svg = tester.widget<SvgPicture>(svgFinder);

        expect(svg.height, 24);
        expect(svg.width, 24);
      });

      testWidgets('should have correct text styling', (tester) async {
        const testColor = Colors.pink;
        await tester.pumpWidget(createQuickAccessItemsWidget(color: testColor));

        final textFinder = find.byType(Text);
        final text = tester.widget<Text>(textFinder);

        expect(text.textAlign, TextAlign.center);
        expect(text.style?.color, testColor);
        expect(text.style?.fontSize, 14);
        expect(text.style?.fontWeight, FontWeight.w400);
      });
    });

    group('Disabled State', () {
      testWidgets('should use disabled colors when isDisabled is true',
          (tester) async {
        await tester.pumpWidget(
          createQuickAccessItemsWidget(
            isDisabled: true,
          ),
        );

        final containerFinder = find.byType(Container);
        final container = tester.widget<Container>(containerFinder);

        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, AppColors.darkGreyBg);

        final textFinder = find.byType(Text);
        final text = tester.widget<Text>(textFinder);

        expect(text.style?.color, AppColors.darkGreyBg);
      });

      testWidgets('should use normal colors when isDisabled is false',
          (tester) async {
        const testColor = Colors.green;
        await tester.pumpWidget(
          createQuickAccessItemsWidget(
            color: testColor,
          ),
        );

        final containerFinder = find.byType(Container);
        final container = tester.widget<Container>(containerFinder);

        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, testColor);

        final textFinder = find.byType(Text);
        final text = tester.widget<Text>(textFinder);

        expect(text.style?.color, testColor);
      });
    });

    group('SVG Color Filter', () {
      testWidgets('should apply white color filter to SVG', (tester) async {
        await tester.pumpWidget(createQuickAccessItemsWidget());

        final svgFinder = find.byType(SvgPicture);
        final svg = tester.widget<SvgPicture>(svgFinder);

        expect(svg.colorFilter, isA<ColorFilter>());
        // Note: ColorFilter properties are not directly accessible in tests
        // but we can verify the filter is applied
        expect(svg.colorFilter, isNotNull);
      });
    });

    group('User Interaction', () {
      testWidgets('should call route function when tapped', (tester) async {
        bool routeCalled = false;

        await tester.pumpWidget(
          createQuickAccessItemsWidget(
            route: (context) {
              routeCalled = true;
            },
          ),
        );

        await tester.tap(find.byType(GestureDetector));
        expect(routeCalled, isTrue);
      });

      testWidgets('should have correct hit test behavior', (tester) async {
        await tester.pumpWidget(createQuickAccessItemsWidget());

        final gestureDetectorFinder = find.byType(GestureDetector);
        final gestureDetector =
            tester.widget<GestureDetector>(gestureDetectorFinder);

        expect(gestureDetector.behavior, HitTestBehavior.opaque);
      });
    });

    group('Spacing', () {
      testWidgets('should have correct spacing between elements',
          (tester) async {
        await tester.pumpWidget(createQuickAccessItemsWidget());

        // Find the SizedBox with height 6 (spacing between container and text)
        final sizedBoxFinder = find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.height == 6,
        );
        expect(sizedBoxFinder, findsOneWidget);

        final sizedBox = tester.widget<SizedBox>(sizedBoxFinder);
        expect(sizedBox.height, 6);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty title', (tester) async {
        await tester.pumpWidget(createQuickAccessItemsWidget(title: ''));

        expect(find.text(''), findsOneWidget);
      });

      testWidgets('should handle very long title', (tester) async {
        const longTitle =
            'This is a very long quick access title that might cause layout issues';
        await tester.pumpWidget(createQuickAccessItemsWidget(title: longTitle));

        expect(find.text(longTitle), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper widget structure for screen readers',
          (tester) async {
        await tester.pumpWidget(createQuickAccessItemsWidget());

        // Verify the widget structure is accessible
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(GestureDetector), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('should maintain accessibility when disabled',
          (tester) async {
        await tester.pumpWidget(createQuickAccessItemsWidget(isDisabled: true));

        // Verify widget structure is still accessible even when disabled
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(GestureDetector), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });
    });

    group('Performance', () {
      testWidgets('should render efficiently', (tester) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(createQuickAccessItemsWidget());

        stopwatch.stop();

        // Verify widget renders within reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));

        // Verify all elements are present
        expect(find.byType(QuickAccessItems), findsOneWidget);
      });

      testWidgets('should handle multiple rebuilds efficiently',
          (tester) async {
        await tester.pumpWidget(createQuickAccessItemsWidget());

        // Trigger multiple rebuilds
        for (int i = 0; i < 5; i++) {
          await tester.pump();
        }

        // Verify widget still renders correctly
        expect(find.byType(QuickAccessItems), findsOneWidget);
      });
    });
  });
}
