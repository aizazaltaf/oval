import 'package:admin/pages/main/dashboard/components/no_doorbell_appbar.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_build_context.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  group('NoDoorbellAppbar UI Tests', () {
    setUpAll(() async {
      registerFallbackValue(FakeBuildContext());
      await TestHelper.initialize();
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    Widget createTestWidget() {
      return FlutterSizer(
        builder: (context, orientation, deviceType) {
          return const MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: NoDoorbellAppbar(),
            ),
          );
        },
      );
    }

    group('Widget Rendering', () {
      testWidgets('should render NoDoorbellAppbar with all required elements',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify main Row widget is present
        expect(find.byType(Row), findsNWidgets(2));

        // Verify CircleAvatar is present
        expect(find.byType(CircleAvatar), findsOneWidget);

        // Verify Column widget is present
        expect(find.byType(Column), findsOneWidget);

        // Verify SizedBox widgets are present
        expect(find.byType(SizedBox), findsAtLeastNWidgets(2));

        // Verify Text widgets are present
        expect(find.byType(Text), findsAtLeastNWidgets(2));

        // Verify Icon widgets are present
        expect(find.byType(Icon), findsAtLeastNWidgets(2));

        // Verify GestureDetector is present
        expect(find.byType(GestureDetector), findsOneWidget);
      });

      testWidgets('should display welcome text correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify welcome text is displayed
        expect(find.text('Welcome'), findsOneWidget);

        // Verify the welcome text has correct styling
        final welcomeTextFinder = find.text('Welcome');
        expect(welcomeTextFinder, findsOneWidget);

        final welcomeText = tester.widget<Text>(welcomeTextFinder);
        expect(welcomeText.style?.fontSize, 24);
      });

      testWidgets('should display add doorbell text correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify add doorbell text is displayed
        expect(find.text('Add doorbell to view location'), findsOneWidget);
      });

      testWidgets('should display avatar with correct letter', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify CircleAvatar contains 'G' text
        final avatarFinder = find.byType(CircleAvatar);
        expect(avatarFinder, findsOneWidget);

        final avatar = tester.widget<CircleAvatar>(avatarFinder);
        expect(avatar.radius, 26);

        // Verify the text inside CircleAvatar
        final avatarTextFinder = find.descendant(
          of: avatarFinder,
          matching: find.byType(Text),
        );
        expect(avatarTextFinder, findsOneWidget);

        final avatarText = tester.widget<Text>(avatarTextFinder);
        expect(avatarText.data, 'G');
        expect(avatarText.style?.color, Colors.white);
        expect(avatarText.style?.fontSize, 24);
      });

      testWidgets('should display location icon correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify map marker icon is present
        final iconFinder = find.byIcon(MdiIcons.mapMarkerOutline);
        expect(iconFinder, findsOneWidget);

        final icon = tester.widget<Icon>(iconFinder);
        expect(icon.size, 20);
      });

      testWidgets('should display arrow icon correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify arrow forward icon is present
        final arrowIconFinder = find.byIcon(Icons.arrow_forward_ios);
        expect(arrowIconFinder, findsOneWidget);

        final arrowIcon = tester.widget<Icon>(arrowIconFinder);
        expect(arrowIcon.size, 14);
      });
    });

    group('Layout and Styling', () {
      testWidgets('should have correct main axis alignment', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Find the main Row widget (the outer one)
        final mainRowFinder = find.byWidgetPredicate(
          (widget) => widget is Row && 
                     widget.mainAxisAlignment == MainAxisAlignment.center &&
                     widget.mainAxisSize == MainAxisSize.min,
        );
        expect(mainRowFinder, findsOneWidget);

        final row = tester.widget<Row>(mainRowFinder.first);
        expect(row.mainAxisAlignment, MainAxisAlignment.center);
        expect(row.mainAxisSize, MainAxisSize.min);
      });

      testWidgets('should have correct column alignment', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final columnFinder = find.byType(Column);
        expect(columnFinder, findsOneWidget);

        final column = tester.widget<Column>(columnFinder);
        expect(column.mainAxisSize, MainAxisSize.min);
        expect(column.crossAxisAlignment, CrossAxisAlignment.start);
      });

      testWidgets('should have correct spacing between elements',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify SizedBox widgets have correct widths
        final sizedBoxes = find.byType(SizedBox);
        expect(sizedBoxes, findsAtLeastNWidgets(2));

        // Check first SizedBox (between avatar and column)
        final firstSizedBox = tester.widget<SizedBox>(sizedBoxes.at(0));
        expect(firstSizedBox.width, 16);

        // Check second SizedBox (between welcome text and location row)
        final secondSizedBox = tester.widget<SizedBox>(sizedBoxes.at(1));
        expect(secondSizedBox.height, 5);
      });

      testWidgets('should apply theme colors correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify CircleAvatar has primary color background
        final avatarFinder = find.byType(CircleAvatar);
        final avatar = tester.widget<CircleAvatar>(avatarFinder);
        expect(avatar.backgroundColor, isA<Color>());

        // Verify icons have theme-based colors
        final locationIconFinder = find.byIcon(MdiIcons.mapMarkerOutline);
        final locationIcon = tester.widget<Icon>(locationIconFinder);
        expect(locationIcon.color, isA<Color>());

        final arrowIconFinder = find.byIcon(Icons.arrow_forward_ios);
        final arrowIcon = tester.widget<Icon>(arrowIconFinder);
        expect(arrowIcon.color, isA<Color>());
      });
    });

    group('User Interactions', () {
      testWidgets('should be tappable on add doorbell text', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Find the GestureDetector
        final gestureDetectorFinder = find.byType(GestureDetector);
        expect(gestureDetectorFinder, findsOneWidget);

        // Verify GestureDetector is enabled
        final gestureDetector =
            tester.widget<GestureDetector>(gestureDetectorFinder);
        expect(gestureDetector.onTap, isNotNull);

        // Find the tappable text
        final tappableTextFinder = find.text('Add doorbell to view location');
        expect(tappableTextFinder, findsOneWidget);

        // Verify the text is inside the GestureDetector
        expect(
          find.descendant(
            of: gestureDetectorFinder,
            matching: tappableTextFinder,
          ),
          findsOneWidget,
        );
      });

      testWidgets('should have tappable gesture detector', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Find the GestureDetector
        final gestureDetectorFinder = find.byType(GestureDetector);
        expect(gestureDetectorFinder, findsOneWidget);
        
        // Verify GestureDetector is enabled and has onTap callback
        final gestureDetector = tester.widget<GestureDetector>(gestureDetectorFinder);
        expect(gestureDetector.onTap, isNotNull);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper text hierarchy', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify welcome text has headlineLarge style
        final welcomeTextFinder = find.text('Welcome');
        final welcomeText = tester.widget<Text>(welcomeTextFinder);
        expect(welcomeText.style?.fontSize, 24);

        // Verify add doorbell text has displayMedium style
        final addDoorbellTextFinder =
            find.text('Add doorbell to view location');
        final addDoorbellText = tester.widget<Text>(addDoorbellTextFinder);
        expect(addDoorbellText.style?.fontSize, 15);
      });

      testWidgets('should have proper icon semantics', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify location icon
        final locationIconFinder = find.byIcon(MdiIcons.mapMarkerOutline);
        expect(locationIconFinder, findsOneWidget);

        // Verify arrow icon
        final arrowIconFinder = find.byIcon(Icons.arrow_forward_ios);
        expect(arrowIconFinder, findsOneWidget);
      });

      testWidgets('should have proper widget structure for screen readers',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify the widget structure is accessible
        expect(find.byType(Row), findsNWidgets(2));
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(CircleAvatar), findsOneWidget);
        expect(find.byType(GestureDetector), findsOneWidget);
      });
    });

    group('Theme Integration', () {
      testWidgets('should use theme colors from context', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify CircleAvatar uses theme primary color
        final avatarFinder = find.byType(CircleAvatar);
        final avatar = tester.widget<CircleAvatar>(avatarFinder);
        expect(avatar.backgroundColor, isA<Color>());

        // Verify icons use theme-based colors
        final locationIconFinder = find.byIcon(MdiIcons.mapMarkerOutline);
        final locationIcon = tester.widget<Icon>(locationIconFinder);
        expect(locationIcon.color, isA<Color>());
        expect(locationIcon.color, isNot(Colors.transparent));
      });

      testWidgets('should apply text theme styles correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify welcome text style
        final welcomeTextFinder = find.text('Welcome');
        final welcomeText = tester.widget<Text>(welcomeTextFinder);
        expect(welcomeText.style?.fontSize, 24);

        // Verify add doorbell text style
        final addDoorbellTextFinder =
            find.text('Add doorbell to view location');
        final addDoorbellText = tester.widget<Text>(addDoorbellTextFinder);
        expect(addDoorbellText.style?.fontSize, 15);
      });
    });

    group('Localization', () {
      testWidgets('should display localized welcome text', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify localized welcome text
        expect(find.text('Welcome'), findsOneWidget);
      });

      testWidgets('should display localized add doorbell text', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify localized add doorbell text
        expect(find.text('Add doorbell to view location'), findsOneWidget);
      });

      testWidgets('should use AppLocalizations for text', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify that the widget uses context.appLocalizations
        // This is tested indirectly by checking the displayed text
        expect(find.text('Welcome'), findsOneWidget);
        expect(find.text('Add doorbell to view location'), findsOneWidget);
      });
    });

    group('Widget Structure', () {
      testWidgets('should have correct widget hierarchy', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify the main structure
        expect(find.byType(Row), findsNWidgets(2));

        // Verify Row contains CircleAvatar and Column
        final rowFinder = find.byType(Row);
        expect(
          find.descendant(
            of: rowFinder,
            matching: find.byType(CircleAvatar),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: rowFinder,
            matching: find.byType(Column),
          ),
          findsOneWidget,
        );

        // Verify Column contains welcome text and location row
        final columnFinder = find.byType(Column);
        expect(
          find.descendant(
            of: columnFinder,
            matching: find.text('Welcome'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: columnFinder,
            matching: find.byType(Row),
          ),
          findsOneWidget,
        );
      });

      testWidgets('should have correct icon and text arrangement',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify location row contains icon, text, and arrow
        final locationRowFinder = find.descendant(
          of: find.byType(Column),
          matching: find.byType(Row),
        );

        expect(
          find.descendant(
            of: locationRowFinder,
            matching: find.byIcon(MdiIcons.mapMarkerOutline),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: locationRowFinder,
            matching: find.text('Add doorbell to view location'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: locationRowFinder,
            matching: find.byIcon(Icons.arrow_forward_ios),
          ),
          findsOneWidget,
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle widget rebuild without errors',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify initial render
        expect(find.byType(NoDoorbellAppbar), findsOneWidget);

        // Trigger rebuild
        await tester.pump();

        // Verify widget still exists after rebuild
        expect(find.byType(NoDoorbellAppbar), findsOneWidget);
        expect(find.text('Welcome'), findsOneWidget);
        expect(find.text('Add doorbell to view location'), findsOneWidget);
      });

      testWidgets('should maintain state during widget rebuilds', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify initial state
        expect(find.byType(NoDoorbellAppbar), findsOneWidget);
        expect(find.text('Welcome'), findsOneWidget);
        expect(find.text('Add doorbell to view location'), findsOneWidget);

        // Trigger multiple rebuilds
        for (int i = 0; i < 3; i++) {
          await tester.pump();
        }

        // Verify widget still renders correctly after rebuilds
        expect(find.byType(NoDoorbellAppbar), findsOneWidget);
        expect(find.text('Welcome'), findsOneWidget);
        expect(find.text('Add doorbell to view location'), findsOneWidget);
      });
    });

    group('Performance', () {
      testWidgets('should render efficiently', (tester) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(createTestWidget());

        stopwatch.stop();

        // Verify widget renders within reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));

        // Verify all elements are present
        expect(find.byType(NoDoorbellAppbar), findsOneWidget);
        expect(find.text('Welcome'), findsOneWidget);
        expect(find.text('Add doorbell to view location'), findsOneWidget);
      });
    });
  });
}
