import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/main/dashboard/components/doorbell_appbar.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/bloc_helpers/profile_bloc_test_helper.dart';
import '../../../../helpers/bloc_helpers/singleton_bloc_test_helper.dart';
import '../../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../../helpers/fake_build_context.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  group('DoorbellAppbar UI Tests', () {
    late ProfileBlocTestHelper profileBlocHelper;
    late StartupBlocTestHelper startupBlocHelper;
    late SingletonBlocTestHelper singletonBlocHelper;

    setUpAll(() async {
      registerFallbackValue(FakeBuildContext());
      await TestHelper.initialize();

      profileBlocHelper = ProfileBlocTestHelper();
      startupBlocHelper = StartupBlocTestHelper();
      singletonBlocHelper = SingletonBlocTestHelper();
      profileBlocHelper.setup();
      startupBlocHelper.setup();
      singletonBlocHelper.setup();
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
      singletonBlocHelper.dispose();
    });

    Widget createTestWidget() {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(
              size: Size(1400, 600), // Provide adequate width for the widget
            ),
            child: SizedBox(
              width: 1400, // Ensure container has enough width
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<ProfileBloc>(
                    create: (context) => profileBlocHelper.mockProfileBloc,
                  ),
                  BlocProvider<StartupBloc>(
                    create: (context) => startupBlocHelper.mockStartupBloc,
                  ),
                ],
                child: const DoorbellAppbar(),
              ),
            ),
          ),
        ),
      );
    }

    group('Widget Rendering', () {
      testWidgets('should render DoorbellAppbar with all required elements',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify main Row widget is present
        expect(find.byType(Row), findsAtLeastNWidgets(2));

        // Verify Column widget is present
        expect(find.byType(Column), findsOneWidget);

        // Verify SizedBox widgets are present
        expect(find.byType(SizedBox), findsAtLeastNWidgets(2));

        // Verify Text widgets are present
        expect(find.byType(Text), findsAtLeastNWidgets(1));

        // Verify Icon widgets are present
        expect(find.byType(Icon), findsAtLeastNWidgets(2));

        // Verify GestureDetector is present
        expect(find.byType(GestureDetector), findsNWidgets(2));

        // Verify IconButton is present
        expect(find.byType(IconButton), findsOneWidget);
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

        // Verify arrow right icon is present
        final arrowIconFinder =
            find.byIcon(Icons.keyboard_arrow_right_outlined);
        expect(arrowIconFinder, findsOneWidget);

        final arrowIcon = tester.widget<Icon>(arrowIconFinder);
        expect(arrowIcon.size, 20);
      });
    });

    group('Layout and Styling', () {
      testWidgets('should have correct main axis alignment', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Find the main Row widget (the outer one)
        final mainRowFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Row &&
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
    });

    group('Accessibility', () {
      testWidgets('should have proper icon semantics', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify location icon
        final locationIconFinder = find.byIcon(MdiIcons.mapMarkerOutline);
        expect(locationIconFinder, findsOneWidget);

        // Verify arrow icon
        final arrowIconFinder =
            find.byIcon(Icons.keyboard_arrow_right_outlined);
        expect(arrowIconFinder, findsOneWidget);
      });

      testWidgets('should have proper widget structure for screen readers',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify the widget structure is accessible
        expect(find.byType(Row), findsAtLeastNWidgets(2));
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(GestureDetector), findsNWidgets(2));
      });
    });

    group('Widget Structure', () {
      testWidgets('should have correct widget hierarchy', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify the main structure
        expect(find.byType(Row), findsAtLeastNWidgets(2));

        // Verify Row contains Column
        final mainRowFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Row &&
              widget.mainAxisAlignment == MainAxisAlignment.center,
        );
        expect(
          find.descendant(
            of: mainRowFinder,
            matching: find.byType(Column),
          ),
          findsOneWidget,
        );

        // Verify Column contains location row
        final columnFinder = find.byType(Column);
        expect(
          find.descendant(
            of: columnFinder,
            matching: find.byType(Row),
          ),
          findsNWidgets(2),
        );
      });

      testWidgets('should have correct icon and text arrangement',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify location row contains icon and arrow
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
            matching: find.byIcon(Icons.keyboard_arrow_right_outlined),
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
        expect(find.byType(DoorbellAppbar), findsOneWidget);

        // Trigger rebuild
        await tester.pump();

        // Verify widget still exists after rebuild
        expect(find.byType(DoorbellAppbar), findsOneWidget);
      });

      testWidgets('should maintain state during widget rebuilds',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify initial state
        expect(find.byType(DoorbellAppbar), findsOneWidget);

        // Trigger multiple rebuilds
        for (int i = 0; i < 3; i++) {
          await tester.pump();
        }

        // Verify widget still renders correctly after rebuilds
        expect(find.byType(DoorbellAppbar), findsOneWidget);
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
        expect(find.byType(DoorbellAppbar), findsOneWidget);
      });
    });

    group('IconButton Styling', () {
      testWidgets('should have correct IconButton styling', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Find the IconButton
        final iconButtonFinder = find.byType(IconButton);
        expect(iconButtonFinder, findsOneWidget);

        final iconButton = tester.widget<IconButton>(iconButtonFinder);
        expect(iconButton.onPressed, isNull);
        expect(iconButton.splashColor, Colors.transparent);
        expect(iconButton.highlightColor, Colors.transparent);
        expect(iconButton.style?.padding?.resolve({}), EdgeInsets.zero);
        expect(iconButton.style?.minimumSize?.resolve({}), Size.zero);
        expect(
          iconButton.style?.tapTargetSize,
          MaterialTapTargetSize.shrinkWrap,
        );
      });
    });

    group('Text Overflow Handling', () {
      testWidgets('should handle text overflow correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify text widgets have proper overflow handling
        final textWidgets = find.byType(Text);
        expect(textWidgets, findsAtLeastNWidgets(1));

        // Check if any text widgets have overflow handling
        for (int i = 0; i < textWidgets.evaluate().length; i++) {
          final textWidget = tester.widget<Text>(textWidgets.at(i));
          if (textWidget.overflow != null) {
            expect(textWidget.overflow, TextOverflow.ellipsis);
            expect(textWidget.maxLines, 1);
          }
        }
      });
    });
  });
}
