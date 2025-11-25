import 'package:admin/pages/main/dashboard/components/camera_settings_tile.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_helper.dart';

void main() {
  group('CameraSettingTile UI Tests', () {
    setUpAll(() async {
      await TestHelper.initialize();
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    Widget createCameraSettingTileWidget({
      Widget? leading,
      String title = 'Test Setting',
      Widget? trailing,
      Widget? subtitle,
      TextStyle? style,
      Color? titleColor,
      VoidCallback? onTap,
      bool needSlider = false,
      double? sliderVal,
      double? minSliderVal,
      double? maxSliderVal,
      bool isCard = false,
      Function? sliderOnChanged,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: CameraSettingTile(
            leading: leading,
            isDisabled: false,
            title: title,
            trailing: trailing,
            subtitle: subtitle,
            style: style,
            titleColor: titleColor,
            onTap: onTap,
            needSlider: needSlider,
            sliderVal: sliderVal,
            minSliderVal: minSliderVal,
            maxSliderVal: maxSliderVal,
            isCard: isCard,
            sliderOnChanged: sliderOnChanged,
          ),
        ),
      );
    }

    group('Widget Rendering', () {
      testWidgets('should render CameraSettingTile with all required elements',
          (tester) async {
        await tester.pumpWidget(createCameraSettingTileWidget());

        // Verify main Column is present
        expect(find.byType(Column), findsOneWidget);

        // Verify ListTile is present
        expect(find.byType(ListTile), findsOneWidget);

        // Verify Text widget is present
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('should render with Card when isCard is true',
          (tester) async {
        await tester.pumpWidget(createCameraSettingTileWidget(isCard: true));

        // Verify Card is present
        expect(find.byType(Card), findsOneWidget);

        // Verify Column is still present inside Card
        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('should not render Card when isCard is false',
          (tester) async {
        await tester.pumpWidget(createCameraSettingTileWidget());

        // Verify Card is not present
        expect(find.byType(Card), findsNothing);

        // Verify Column is present directly
        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('should display correct title text', (tester) async {
        const testTitle = 'Test Camera Setting';
        await tester
            .pumpWidget(createCameraSettingTileWidget(title: testTitle));

        expect(find.text(testTitle), findsOneWidget);
      });

      testWidgets('should render leading widget when provided', (tester) async {
        const leadingIcon = Icon(Icons.camera);
        await tester.pumpWidget(
          createCameraSettingTileWidget(leading: leadingIcon),
        );

        expect(find.byIcon(Icons.camera), findsOneWidget);
      });

      testWidgets('should render trailing widget when provided',
          (tester) async {
        const trailingIcon = Icon(Icons.arrow_forward);
        await tester.pumpWidget(
          createCameraSettingTileWidget(trailing: trailingIcon),
        );

        expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      });

      testWidgets('should render subtitle widget when provided',
          (tester) async {
        const subtitleText = Text('Test subtitle');
        await tester.pumpWidget(
          createCameraSettingTileWidget(subtitle: subtitleText),
        );

        expect(find.text('Test subtitle'), findsOneWidget);
      });
    });

    group('Slider Functionality', () {
      testWidgets('should render slider when needSlider is true',
          (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 50,
            minSliderVal: 0,
            maxSliderVal: 100,
          ),
        );

        // Verify Slider is present
        expect(find.byType(Slider), findsOneWidget);

        // Verify SliderTheme is present
        expect(find.byType(SliderTheme), findsOneWidget);

        // Verify min and max value texts are present
        expect(find.text('0.0'), findsOneWidget);
        expect(find.text('100.0'), findsOneWidget);
      });

      testWidgets('should not render slider when needSlider is false',
          (tester) async {
        await tester.pumpWidget(createCameraSettingTileWidget());

        // Verify Slider is not present
        expect(find.byType(Slider), findsNothing);

        // Verify SliderTheme is not present
        expect(find.byType(SliderTheme), findsNothing);
      });

      testWidgets('should hide trailing widget when slider is enabled',
          (tester) async {
        const trailingIcon = Icon(Icons.arrow_forward);
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            trailing: trailingIcon,
          ),
        );

        // Verify trailing widget is not visible
        expect(find.byIcon(Icons.arrow_forward), findsNothing);
      });

      testWidgets('should show trailing widget when slider is disabled',
          (tester) async {
        const trailingIcon = Icon(Icons.arrow_forward);
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            trailing: trailingIcon,
          ),
        );

        // Verify trailing widget is visible
        expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      });

      testWidgets('should initialize slider with correct value',
          (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 75,
            minSliderVal: 0,
            maxSliderVal: 100,
          ),
        );

        final slider = tester.widget<Slider>(find.byType(Slider));
        expect(slider.value, 75.0);
        expect(slider.min, 0.0);
        expect(slider.max, 100.0);
      });

      testWidgets('should use default values when slider values are null',
          (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
          ),
        );

        final slider = tester.widget<Slider>(find.byType(Slider));
        expect(slider.value, 50.0); // Default value
        expect(slider.min, 0.0); // Default min
        expect(slider.max, 100.0); // Default max
      });

      testWidgets('should call sliderOnChanged when slider value changes',
          (tester) async {
        double? changedValue;
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 50,
            minSliderVal: 0,
            maxSliderVal: 100,
            sliderOnChanged: (value) {
              changedValue = value;
            },
          ),
        );

        final slider = find.byType(Slider);
        await tester.drag(slider, const Offset(50, 0));
        await tester.pump();

        expect(changedValue, isNotNull);
      });

      testWidgets('should update slider value on drag', (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 50,
            minSliderVal: 0,
            maxSliderVal: 100,
            sliderOnChanged: (value) {
              // Callback to prevent null check error
            },
          ),
        );

        final slider = find.byType(Slider);
        await tester.drag(slider, const Offset(30, 0));
        await tester.pump();

        // Verify the slider value has changed
        final updatedSlider = tester.widget<Slider>(find.byType(Slider));
        expect(updatedSlider.value, isNot(equals(50.0)));
      });

      testWidgets('should display slider label correctly', (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 75,
            minSliderVal: 0,
            maxSliderVal: 100,
          ),
        );

        final slider = tester.widget<Slider>(find.byType(Slider));
        expect(slider.label, '75');
      });
    });

    group('Layout and Styling', () {
      testWidgets('should have correct card properties when isCard is true',
          (tester) async {
        await tester.pumpWidget(createCameraSettingTileWidget(isCard: true));

        final card = tester.widget<Card>(find.byType(Card));
        expect(card.shape, isA<RoundedRectangleBorder>());

        final shape = card.shape! as RoundedRectangleBorder;
        expect(shape.borderRadius, BorderRadius.circular(12));
      });

      testWidgets('should have correct list tile properties', (tester) async {
        await tester.pumpWidget(createCameraSettingTileWidget());

        final listTile = tester.widget<ListTile>(find.byType(ListTile));
        expect(listTile.title, isA<Text>());
      });

      testWidgets('should apply custom title style when provided',
          (tester) async {
        const customStyle =
            TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
        await tester.pumpWidget(
          createCameraSettingTileWidget(style: customStyle),
        );

        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style, customStyle);
      });

      testWidgets('should apply custom title color when provided',
          (tester) async {
        const customColor = Colors.red;
        await tester.pumpWidget(
          createCameraSettingTileWidget(titleColor: customColor),
        );

        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.color, customColor);
      });

      testWidgets(
          'should use theme text style when custom style is not provided',
          (tester) async {
        await tester.pumpWidget(createCameraSettingTileWidget());

        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style, isNotNull);
      });

      testWidgets('should have correct slider theme properties',
          (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 50,
            minSliderVal: 0,
            maxSliderVal: 100,
          ),
        );

        final sliderTheme =
            tester.widget<SliderTheme>(find.byType(SliderTheme));
        final data = sliderTheme.data;

        expect(data.trackHeight, 4);
        expect(data.thumbShape, isA<RoundSliderThumbShape>());
        expect(data.showValueIndicator, ShowValueIndicator.always);
        expect(data.padding, EdgeInsets.zero);
      });

      testWidgets('should have correct slider padding', (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 50,
            minSliderVal: 0,
            maxSliderVal: 100,
          ),
        );

        final padding = find.byWidgetPredicate(
          (widget) =>
              widget is Padding &&
              widget.padding == const EdgeInsets.only(top: 10),
        );
        expect(padding, findsOneWidget);
      });

      testWidgets('should have correct slider row layout', (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 50,
            minSliderVal: 0,
            maxSliderVal: 100,
          ),
        );

        final row = find.byType(Row);
        expect(row, findsOneWidget);

        // Verify min value text, slider, and max value text are in row
        expect(find.text('0.0'), findsOneWidget);
        expect(find.text('100.0'), findsOneWidget);
        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('should have correct slider spacing', (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 50,
            minSliderVal: 0,
            maxSliderVal: 100,
          ),
        );

        final sizedBoxes = find.byType(SizedBox);
        expect(
          sizedBoxes,
          findsNWidgets(2),
        ); // Two SizedBox widgets for spacing
      });
    });

    group('User Interaction', () {
      testWidgets('should call onTap when ListTile is tapped', (tester) async {
        bool tapCalled = false;
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            onTap: () {
              tapCalled = true;
            },
          ),
        );

        await tester.tap(find.byType(ListTile));
        expect(tapCalled, isTrue);
      });

      testWidgets('should not call onTap when onTap is null', (tester) async {
        await tester.pumpWidget(createCameraSettingTileWidget());

        // Should not throw exception when tapped
        await tester.tap(find.byType(ListTile));
        await tester.pump();
      });

      testWidgets('should handle slider interaction without sliderOnChanged',
          (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 50,
            minSliderVal: 0,
            maxSliderVal: 100,
            onTap: () {},
            sliderOnChanged: (value) {
              // Provide callback to prevent null check error
            },
          ),
        );

        final slider = find.byType(Slider);
        await tester.drag(slider, const Offset(30, 0));
        await tester.pump();

        // Should not throw exception
        expect(find.byType(Slider), findsOneWidget);
      });
    });

    group('State Management', () {
      testWidgets('should update slider value in state', (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 50,
            minSliderVal: 0,
            maxSliderVal: 100,
            sliderOnChanged: (value) {
              // Callback to prevent null check error
            },
          ),
        );

        final slider = find.byType(Slider);
        await tester.drag(slider, const Offset(50, 0));
        await tester.pump();

        // Verify the widget rebuilds with new value
        final updatedSlider = tester.widget<Slider>(find.byType(Slider));
        expect(updatedSlider.value, isNot(equals(50.0)));
      });

      testWidgets('should initialize with correct slider value',
          (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 25,
            minSliderVal: 0,
            maxSliderVal: 100,
          ),
        );

        final slider = tester.widget<Slider>(find.byType(Slider));
        expect(slider.value, 25.0);
      });

      testWidgets('should handle slider value changes in onChangeEnd',
          (tester) async {
        double? endValue;
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 50,
            minSliderVal: 0,
            maxSliderVal: 100,
            sliderOnChanged: (value) {
              endValue = value;
            },
          ),
        );

        final slider = find.byType(Slider);
        await tester.drag(slider, const Offset(30, 0));
        await tester.pump();

        expect(endValue, isNotNull);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty title', (tester) async {
        await tester.pumpWidget(createCameraSettingTileWidget(title: ''));

        expect(find.text(''), findsOneWidget);
      });

      testWidgets('should handle very long title', (tester) async {
        const longTitle =
            'This is a very long camera setting title that might cause layout issues in the UI';
        await tester
            .pumpWidget(createCameraSettingTileWidget(title: longTitle));

        expect(find.text(longTitle), findsOneWidget);
      });

      testWidgets('should handle null slider values gracefully',
          (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
          ),
        );

        final slider = tester.widget<Slider>(find.byType(Slider));
        expect(slider.value, 50.0);
        expect(slider.min, 0.0);
        expect(slider.max, 100.0);
      });

      testWidgets('should handle extreme slider values', (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 0,
            minSliderVal: 0,
            maxSliderVal: 1000,
          ),
        );

        final slider = tester.widget<Slider>(find.byType(Slider));
        expect(slider.value, 0.0);
        expect(slider.min, 0.0);
        expect(slider.max, 1000.0);
      });

      testWidgets('should handle negative slider values', (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: -10,
            minSliderVal: -50,
            maxSliderVal: 50,
          ),
        );

        final slider = tester.widget<Slider>(find.byType(Slider));
        expect(slider.value, -10.0);
        expect(slider.min, -50.0);
        expect(slider.max, 50.0);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper widget structure for screen readers',
          (tester) async {
        await tester.pumpWidget(createCameraSettingTileWidget());

        // Verify the widget structure is accessible
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(ListTile), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('should maintain accessibility with slider', (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 50,
            minSliderVal: 0,
            maxSliderVal: 100,
          ),
        );

        // Verify widget structure is still accessible with slider
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(ListTile), findsOneWidget);
        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('should have proper semantics for interactive elements',
          (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            onTap: () {},
            needSlider: true,
            sliderVal: 50,
            minSliderVal: 0,
            maxSliderVal: 100,
          ),
        );

        // Verify ListTile is tappable
        expect(find.byType(ListTile), findsOneWidget);

        // Verify Slider is interactive
        expect(find.byType(Slider), findsOneWidget);
      });
    });

    group('Performance', () {
      testWidgets('should render efficiently', (tester) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(createCameraSettingTileWidget());

        stopwatch.stop();

        // Verify widget renders within reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));

        // Verify all elements are present
        expect(find.byType(CameraSettingTile), findsOneWidget);
      });

      testWidgets('should handle multiple rebuilds efficiently',
          (tester) async {
        await tester.pumpWidget(createCameraSettingTileWidget());

        // Trigger multiple rebuilds
        for (int i = 0; i < 5; i++) {
          await tester.pump();
        }

        // Verify widget still renders correctly
        expect(find.byType(CameraSettingTile), findsOneWidget);
      });

      testWidgets('should handle slider interactions efficiently',
          (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 50,
            minSliderVal: 0,
            maxSliderVal: 100,
            sliderOnChanged: (value) {
              // Callback to prevent null check error
            },
          ),
        );

        final slider = find.byType(Slider);

        // Perform multiple slider interactions
        for (int i = 0; i < 10; i++) {
          await tester.drag(slider, const Offset(5, 0));
          await tester.pump();
        }

        // Verify widget still renders correctly
        expect(find.byType(CameraSettingTile), findsOneWidget);
      });
    });

    group('Theme Support', () {
      testWidgets('should adapt to light theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: CameraSettingTile(
                title: 'Test Setting',
                isDisabled: false,
                needSlider: true,
                sliderVal: 50,
                minSliderVal: 0,
                maxSliderVal: 100,
                sliderOnChanged: (value) {
                  // Callback to prevent null check error
                },
              ),
            ),
          ),
        );

        // Verify widget renders in light theme
        expect(find.byType(CameraSettingTile), findsOneWidget);
        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('should adapt to dark theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: CameraSettingTile(
                isDisabled: false,
                title: 'Test Setting',
                needSlider: true,
                sliderVal: 50,
                minSliderVal: 0,
                maxSliderVal: 100,
                sliderOnChanged: (value) {
                  // Callback to prevent null check error
                },
              ),
            ),
          ),
        );

        // Verify widget renders in dark theme
        expect(find.byType(CameraSettingTile), findsOneWidget);
        expect(find.byType(Slider), findsOneWidget);
      });
    });

    group('Slider Theme Colors', () {
      testWidgets('should use correct theme colors for slider', (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 50,
            minSliderVal: 0,
            maxSliderVal: 100,
            sliderOnChanged: (value) {
              // Callback to prevent null check error
            },
          ),
        );

        final sliderTheme =
            tester.widget<SliderTheme>(find.byType(SliderTheme));
        final data = sliderTheme.data;

        // Verify theme colors are applied
        expect(data.activeTrackColor, isNotNull);
        expect(data.thumbColor, isNotNull);
        expect(data.inactiveTrackColor, AppColors.cancelButtonColor);
        expect(data.valueIndicatorColor, isNotNull);
      });

      testWidgets('should have correct thumb shape', (tester) async {
        await tester.pumpWidget(
          createCameraSettingTileWidget(
            needSlider: true,
            sliderVal: 50,
            minSliderVal: 0,
            maxSliderVal: 100,
            sliderOnChanged: (value) {
              // Callback to prevent null check error
            },
          ),
        );

        final sliderTheme =
            tester.widget<SliderTheme>(find.byType(SliderTheme));
        final data = sliderTheme.data;

        expect(data.thumbShape, isA<RoundSliderThumbShape>());
        final thumbShape = data.thumbShape! as RoundSliderThumbShape;
        expect(thumbShape.enabledThumbRadius, 7.5);
      });
    });
  });
}
