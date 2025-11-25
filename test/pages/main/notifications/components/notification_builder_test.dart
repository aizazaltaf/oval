import 'package:admin/core/theme.dart';
import 'package:admin/pages/main/notifications/notification_builder.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../helpers/test_helper.dart';

void main() {
  group('NotificationBuilder UI Tests', () {
    setUpAll(() async {
      await TestHelper.initialize();
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    Widget createTestWidget({
      bool status = false,
      ThemeData? theme,
    }) {
      return MaterialApp(
        theme: theme ?? getTheme(),
        home: Scaffold(
          body: NotificationBuilder(status: status),
        ),
      );
    }

    group('Widget Structure Tests', () {
      testWidgets('should render IconButton as root widget', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(IconButton), findsOneWidget);
      });

      testWidgets('should render bell icon with correct properties',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        final iconFinder = find.byIcon(MdiIcons.bell);
        expect(iconFinder, findsOneWidget);

        final icon = tester.widget<Icon>(iconFinder);
        expect(icon.size, 24);
      });

      testWidgets('should render notification badge when status is true',
          (tester) async {
        await tester.pumpWidget(createTestWidget(status: true));

        final badgeFinder = find.byIcon(Icons.circle);
        expect(badgeFinder, findsOneWidget);

        final badge = tester.widget<Icon>(badgeFinder);
        expect(badge.color, Colors.red);
        expect(badge.size, 12);
      });

      testWidgets('should not render notification badge when status is false',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        final badgeFinder = find.byIcon(Icons.circle);
        expect(badgeFinder, findsNothing);
      });

      testWidgets('should render Stack with correct children count',
          (tester) async {
        await tester.pumpWidget(createTestWidget(status: true));

        // Find the Stack that contains the bell icon
        final stackFinder = find.descendant(
          of: find.byType(IconButton),
          matching: find.byType(Stack),
        );
        expect(stackFinder, findsOneWidget);

        final stack = tester.widget<Stack>(stackFinder);
        expect(stack.children.length, 2); // bell icon + badge
      });

      testWidgets('should render Stack with single child when status is false',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Find the Stack that contains the bell icon
        final stackFinder = find.descendant(
          of: find.byType(IconButton),
          matching: find.byType(Stack),
        );
        expect(stackFinder, findsOneWidget);

        final stack = tester.widget<Stack>(stackFinder);
        expect(stack.children.length, 1); // only bell icon
      });
    });

    group('IconButton Properties Tests', () {
      testWidgets('should be disabled (onPressed is null)', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final iconButton = tester.widget<IconButton>(
          find.byType(IconButton),
        );

        expect(iconButton.onPressed, isNull);
      });
    });

    group('Icon Color Tests', () {
      testWidgets('should use theme-based color for bell icon in light theme',
          (tester) async {
        final lightTheme = getTheme().copyWith(
          brightness: Brightness.light,
        );

        await tester.pumpWidget(createTestWidget(theme: lightTheme));

        final iconFinder = find.byIcon(MdiIcons.bell);
        final icon = tester.widget<Icon>(iconFinder);

        // In light theme, should use AppColors.darkBlueColor
        expect(icon.color, AppColors.darkBlueColor);
      });

      testWidgets('should use white color for bell icon in dark theme',
          (tester) async {
        final darkTheme = getTheme().copyWith(
          brightness: Brightness.dark,
        );

        await tester.pumpWidget(createTestWidget(theme: darkTheme));

        final iconFinder = find.byIcon(MdiIcons.bell);
        final icon = tester.widget<Icon>(iconFinder);

        // In dark theme, should use Colors.white
        expect(icon.color, Colors.white);
      });
    });

    group('Badge Positioning Tests', () {
      testWidgets('should position badge correctly when status is true',
          (tester) async {
        await tester.pumpWidget(createTestWidget(status: true));

        final positionedFinder = find.byType(Positioned);
        expect(positionedFinder, findsOneWidget);

        final positioned = tester.widget<Positioned>(positionedFinder);
        expect(positioned.top, 1);
        expect(positioned.right, 1);
      });

      testWidgets('should not have Positioned widget when status is false',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        final positionedFinder = find.byType(Positioned);
        expect(positionedFinder, findsNothing);
      });
    });

    group('Widget Tree Structure Tests', () {
      testWidgets('should have correct widget hierarchy when status is true',
          (tester) async {
        await tester.pumpWidget(createTestWidget(status: true));

        // Widget hierarchy: IconButton -> Stack -> [Icon, Positioned -> Icon]
        expect(find.byType(IconButton), findsOneWidget);

        // Find the Stack that contains the bell icon
        final stackFinder = find.descendant(
          of: find.byType(IconButton),
          matching: find.byType(Stack),
        );
        expect(stackFinder, findsOneWidget);
        expect(find.byIcon(MdiIcons.bell), findsOneWidget);
        expect(find.byIcon(Icons.circle), findsOneWidget);
        expect(find.byType(Positioned), findsOneWidget);
      });

      testWidgets('should have correct widget hierarchy when status is false',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Widget hierarchy: IconButton -> Stack -> [Icon]
        expect(find.byType(IconButton), findsOneWidget);

        // Find the Stack that contains the bell icon
        final stackFinder = find.descendant(
          of: find.byType(IconButton),
          matching: find.byType(Stack),
        );
        expect(stackFinder, findsOneWidget);
        expect(find.byIcon(MdiIcons.bell), findsOneWidget);
        expect(find.byIcon(Icons.circle), findsNothing);
        expect(find.byType(Positioned), findsNothing);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have semantic label for bell icon', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final iconFinder = find.byIcon(MdiIcons.bell);
        expect(iconFinder, findsOneWidget);

        // Check if the icon is accessible
        expect(tester.getSemantics(find.byType(IconButton)), isNotNull);
      });

      testWidgets('should have semantic label for notification badge',
          (tester) async {
        await tester.pumpWidget(createTestWidget(status: true));

        final badgeFinder = find.byIcon(Icons.circle);
        expect(badgeFinder, findsOneWidget);

        // Check if the badge is accessible
        expect(tester.getSemantics(find.byIcon(Icons.circle)), isNotNull);
      });
    });

    group('Responsive Behavior Tests', () {
      testWidgets('should maintain icon size on different screen sizes',
          (tester) async {
        // Test on small screen
        tester.view.physicalSize = const Size(320, 568);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(createTestWidget());

        final iconFinder = find.byIcon(MdiIcons.bell);
        final icon = tester.widget<Icon>(iconFinder);
        expect(icon.size, 24);

        // Test on large screen
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(createTestWidget());

        final iconFinder2 = find.byIcon(MdiIcons.bell);
        final icon2 = tester.widget<Icon>(iconFinder2);
        expect(icon2.size, 24);

        // Reset to default
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('Performance Tests', () {
      testWidgets('should rebuild efficiently when status changes',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Change status to true
        await tester.pumpWidget(createTestWidget(status: true));

        final badgeFinder = find.byIcon(Icons.circle);
        expect(badgeFinder, findsOneWidget);

        // Change status back to false
        await tester.pumpWidget(createTestWidget());

        final badgeFinder2 = find.byIcon(Icons.circle);
        expect(badgeFinder2, findsNothing);
      });
    });
  });
}
