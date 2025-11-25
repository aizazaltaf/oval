import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/more_dashboard/components/subcomponents/more_expansion_tile.dart';
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
    Widget? tileLeading,
    String? title,
    bool? isExpanded,
    List<FeatureModel>? list,
    VoidCallback? onTapTile,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: MoreExpansionTile(
            tileLeading: tileLeading ?? const Icon(Icons.home),
            title: title ?? 'Test Title',
            isExpanded: isExpanded ?? false,
            list: list ?? [],
            onTapTile: onTapTile ?? () {},
          ),
        ),
      ),
    );
  }

  List<FeatureModel> createTestFeatureList() {
    return [
      FeatureModel(
        title: 'Test Feature 1',
        image: 'test_icon_1.svg',
        route: (context) {},
      ),
      FeatureModel(
        title: 'Test Feature 2',
        image: 'test_icon_2.svg',
        route: (context) {},
      ),
      FeatureModel(
        title: 'Test Feature 3',
        image: 'test_icon_3.svg',
        route: (context) {},
      ),
    ];
  }

  group('MoreExpansionTile UI Tests', () {
    group('Rendering Tests', () {
      testWidgets(
          'should render MoreExpansionTile with all required properties',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            tileLeading: const Icon(Icons.settings),
            title: 'Test Expansion Tile',
            isExpanded: false,
            list: createTestFeatureList(),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the main widget is rendered
        expect(find.byType(MoreExpansionTile), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(ListTile), findsOneWidget);

        // Verify title is displayed
        expect(find.text('Test Expansion Tile'), findsOneWidget);

        // Verify leading widget is present
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('should render with different leading widgets',
          (tester) async {
        // Test with Icon
        await tester.pumpWidget(
          createTestWidget(
            tileLeading: const Icon(Icons.favorite),
            title: 'Icon Test',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.favorite), findsOneWidget);

        // Test with Text widget
        await tester.pumpWidget(
          createTestWidget(
            tileLeading: const Text('Leading Text'),
            title: 'Text Test',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Leading Text'), findsOneWidget);

        // Test with Container
        await tester.pumpWidget(
          createTestWidget(
            tileLeading: Container(
              width: 24,
              height: 24,
              color: Colors.red,
            ),
            title: 'Container Test',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Container), findsAtLeast(1));
      });
    });

    group('Expansion State Tests', () {
      testWidgets('should show down arrow when not expanded', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Collapsed Test',
            isExpanded: false,
            list: createTestFeatureList(),
          ),
        );
        await tester.pumpAndSettle();

        // Verify down arrow is shown
        expect(find.byIcon(Icons.keyboard_arrow_down_sharp), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_up_sharp), findsNothing);

        // Verify ListView is not shown
        expect(find.byType(ListView), findsNothing);
      });

      testWidgets('should show up arrow when expanded', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Expanded Test',
            isExpanded: true,
            list: createTestFeatureList(),
          ),
        );
        await tester.pumpAndSettle();

        // Verify up arrow is shown
        expect(find.byIcon(Icons.keyboard_arrow_up_sharp), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_down_sharp), findsNothing);

        // Verify ListView is shown
        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets(
          'should render ListView with correct item count when expanded',
          (tester) async {
        final testList = createTestFeatureList();
        await tester.pumpWidget(
          createTestWidget(
            title: 'List Count Test',
            isExpanded: true,
            list: testList,
          ),
        );
        await tester.pumpAndSettle();

        // Verify ListView is rendered
        expect(find.byType(ListView), findsOneWidget);

        // Verify all feature titles are displayed
        for (final feature in testList) {
          expect(find.text(feature.title), findsOneWidget);
        }
      });
    });

    group('ListTile Styling Tests', () {
      testWidgets('should apply correct text styling to title', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Styled Title',
            tileLeading: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Find the Text widget in the ListTile
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

      testWidgets('should apply correct shape to ListTile', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Shape Test',
            tileLeading: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Find the ListTile widget
        final listTile = tester.widget<ListTile>(
          find.byType(ListTile),
        );

        // Verify the shape is set to Border
        expect(listTile.shape, equals(const Border()));
      });
    });

    group('Feature List Items Tests', () {
      testWidgets(
          'should render feature items with correct structure when expanded',
          (tester) async {
        final testList = createTestFeatureList();
        await tester.pumpWidget(
          createTestWidget(
            title: 'Feature Items Test',
            isExpanded: true,
            list: testList,
          ),
        );
        await tester.pumpAndSettle();

        // Verify each feature item has the correct structure
        for (int i = 0; i < testList.length; i++) {
          // Find the ListTile for each feature
          final featureListTiles = find.byType(ListTile);
          expect(
            featureListTiles,
            findsNWidgets(testList.length + 1),
          ); // +1 for main tile

          // Verify CircleAvatar is present for each feature
          expect(find.byType(CircleAvatar), findsNWidgets(testList.length));
        }
      });

      testWidgets('should apply correct padding to feature list',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Padding Test',
            isExpanded: true,
            list: createTestFeatureList(),
          ),
        );
        await tester.pumpAndSettle();

        // Find all Padding widgets and check if any has the expected padding
        final paddings = tester.widgetList<Padding>(
          find.descendant(
            of: find.byType(Column),
            matching: find.byType(Padding),
          ),
        );
        expect(
          paddings.any((p) => p.padding == const EdgeInsets.only(left: 12)),
          isTrue,
          reason: 'No Padding widget with EdgeInsets.only(left: 12) found',
        );
      });

      testWidgets('should render CircleAvatar with correct properties',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Avatar Test',
            isExpanded: true,
            list: createTestFeatureList(),
          ),
        );
        await tester.pumpAndSettle();

        // Find the CircleAvatar
        final avatars = tester.widgetList<CircleAvatar>(
          find.byType(CircleAvatar),
        );
        expect(avatars.length, greaterThan(0));
        final circleAvatar = avatars.first;

        // Verify the radius is correct
        expect(circleAvatar.radius, equals(22));
      });
    });

    group('Interaction Tests', () {
      testWidgets('should call onTapTile when main tile is tapped',
          (tester) async {
        bool onTapCalled = false;

        await tester.pumpWidget(
          createTestWidget(
            title: 'Tap Test',
            tileLeading: const Icon(Icons.home),
            onTapTile: () {
              onTapCalled = true;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Tap the main ListTile
        await tester.tap(find.byType(ListTile));
        await tester.pumpAndSettle();

        // Verify the callback was called
        expect(onTapCalled, isTrue);
      });

      testWidgets('should call feature route when feature item is tapped',
          (tester) async {
        bool featureRouteCalled = false;
        final testList = [
          FeatureModel(
            title: 'Test Feature',
            image: 'test_icon.svg',
            route: (context) {
              featureRouteCalled = true;
            },
          ),
        ];

        await tester.pumpWidget(
          createTestWidget(
            title: 'Feature Tap Test',
            isExpanded: true,
            list: testList,
          ),
        );
        await tester.pumpAndSettle();

        // Tap the feature item (second ListTile)
        final listTiles = find.byType(ListTile);
        await tester.tap(listTiles.at(1)); // Index 1 is the first feature item
        await tester.pumpAndSettle();

        // Verify the feature route was called
        expect(featureRouteCalled, isTrue);
      });

      testWidgets('should handle multiple taps on main tile', (tester) async {
        int tapCount = 0;

        await tester.pumpWidget(
          createTestWidget(
            title: 'Multiple Tap Test',
            tileLeading: const Icon(Icons.home),
            onTapTile: () {
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
    });

    group('Theme Integration Tests', () {
      testWidgets('should use theme colors for trailing icon', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Theme Test',
            tileLeading: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Find the trailing Icon
        final trailingIcon = tester.widget<Icon>(
          find.descendant(
            of: find.byType(ListTile),
            matching: find.byIcon(Icons.keyboard_arrow_down_sharp),
          ),
        );

        // Verify the icon has a color (theme-based)
        expect(trailingIcon.color, isNotNull);
      });

      testWidgets('should work with dark theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: MoreExpansionTile(
                tileLeading: const Icon(Icons.home),
                title: 'Dark Theme Test',
                isExpanded: false,
                list: const [],
                onTapTile: () {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget renders without errors in dark theme
        expect(find.byType(MoreExpansionTile), findsOneWidget);
        expect(find.text('Dark Theme Test'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle very long title', (tester) async {
        const longTitle =
            'This is a very long title that should be handled properly by the widget without causing any layout issues or overflow problems';

        await tester.pumpWidget(
          createTestWidget(
            title: longTitle,
            tileLeading: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget renders without errors
        expect(find.byType(MoreExpansionTile), findsOneWidget);
        expect(find.text(longTitle), findsOneWidget);
      });

      testWidgets('should handle empty title', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: '',
            tileLeading: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget renders without errors
        expect(find.byType(MoreExpansionTile), findsOneWidget);
        expect(find.text(''), findsOneWidget);
      });

      testWidgets('should handle null title', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            tileLeading: const Icon(Icons.home),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget renders without errors
        expect(find.byType(MoreExpansionTile), findsOneWidget);
      });

      testWidgets('should handle large feature list', (tester) async {
        final largeList = List.generate(
          10,
          (index) => FeatureModel(
            title: 'Feature $index',
            image: 'icon_$index.svg',
            route: (context) {},
          ),
        );

        await tester.pumpWidget(
          createTestWidget(
            tileLeading: const Icon(Icons.home),
            title: 'Large List Test',
            isExpanded: true,
            list: largeList,
            onTapTile: () {},
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget renders without errors
        expect(find.byType(MoreExpansionTile), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('should handle feature with null route', (tester) async {
        final testList = [
          FeatureModel(
            title: 'Null Route Feature',
            image: 'test_icon.svg',
          ),
        ];

        await tester.pumpWidget(
          createTestWidget(
            title: 'Null Route Test',
            isExpanded: true,
            list: testList,
          ),
        );
        await tester.pumpAndSettle();

        // Verify the widget renders without errors
        expect(find.byType(MoreExpansionTile), findsOneWidget);
        expect(find.text('Null Route Feature'), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should rebuild efficiently when expansion state changes',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Performance Test',
            tileLeading: const Icon(Icons.home),
            list: createTestFeatureList(),
          ),
        );
        await tester.pumpAndSettle();

        // Toggle expansion state multiple times
        for (int i = 0; i < 10; i++) {
          await tester.pumpWidget(
            createTestWidget(
              title: 'Performance Test',
              tileLeading: const Icon(Icons.home),
              list: createTestFeatureList(),
              isExpanded: i.isEven,
            ),
          );
          await tester.pumpAndSettle();
        }

        // Verify the widget still renders correctly
        expect(find.byType(MoreExpansionTile), findsOneWidget);
      });
    });
  });
}
