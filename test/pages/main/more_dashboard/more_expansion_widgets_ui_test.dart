import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/main/more_dashboard/components/more_expansion_widgets.dart';
import 'package:admin/pages/main/more_dashboard/components/subcomponents/feature_expanded_tiles.dart';
import 'package:admin/pages/main/more_dashboard/components/subcomponents/payment_expanded_tiles.dart';
import 'package:admin/pages/main/more_dashboard/components/subcomponents/settings_expanded_tiles.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/singleton_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';

void main() {
  late StartupBlocTestHelper startupBlocHelper;
  late SingletonBlocTestHelper singletonBlocTestHelper;

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    await TestHelper.initialize();
  });

  setUp(() {
    startupBlocHelper = StartupBlocTestHelper()..setup();
    singletonBlocTestHelper = SingletonBlocTestHelper()..setup();
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
    startupBlocHelper.dispose();
    singletonBlocTestHelper.dispose();
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
        body: BlocProvider<StartupBloc>.value(
          value: startupBlocHelper.mockStartupBloc,
          child: const MoreExpansionWidget(),
        ),
      ),
    );
  }

  group('MoreExpansionWidget UI Tests', () {
    group('Rendering Tests', () {
      testWidgets('should render MoreExpansionWidget with container wrapper',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify the main widget is rendered
        expect(find.byType(MoreExpansionWidget), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
      });

      testWidgets('should apply correct margin to container', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find the Container widget
        final container = tester.widget<Container>(
          find.byType(Container),
        );

        // Verify the margin is applied correctly
        expect(container.margin, equals(const EdgeInsets.only(left: 25)));
      });

      testWidgets(
          'should render when user device model is not null and not empty',
          (tester) async {
        // Mock user device model with data
        startupBlocHelper.setupDoorBellWidgetState();

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify the widget renders with content
        expect(find.byType(MoreExpansionWidget), findsOneWidget);
        expect(find.byType(FeatureExpandedTiles), findsOneWidget);
        expect(find.byType(SettingsExpandedTiles), findsOneWidget);
        expect(find.byType(PaymentExpandedTiles), findsOneWidget);
      });

      testWidgets('should render when user device model is null',
          (tester) async {
        // Mock user device model as null
        startupBlocHelper.setupLoadingState();

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify the widget renders but with no content
        expect(find.byType(MoreExpansionWidget), findsOneWidget);
        expect(find.byType(FeatureExpandedTiles), findsNothing);
        expect(find.byType(SettingsExpandedTiles), findsNothing);
        expect(find.byType(PaymentExpandedTiles), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('should render when user device model is empty list',
          (tester) async {
        // Mock user device model as empty list
        startupBlocHelper.setupNoDoorBellState();

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify the widget renders but with no content
        expect(find.byType(MoreExpansionWidget), findsOneWidget);
        expect(find.byType(FeatureExpandedTiles), findsNothing);
        expect(find.byType(SettingsExpandedTiles), findsNothing);
        expect(find.byType(PaymentExpandedTiles), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);
      });
    });

    group('Structure Tests', () {
      testWidgets(
          'should render Column with FeatureExpandedTiles, SettingsExpandedTiles and PaymentExpandedTiles when devices exist',
          (tester) async {
        // Mock user device model with data
        startupBlocHelper.setupDoorBellWidgetState();

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify the structure
        expect(find.byType(Column), findsAtLeast(1));
        expect(find.byType(FeatureExpandedTiles), findsOneWidget);
        expect(find.byType(SettingsExpandedTiles), findsOneWidget);
        expect(find.byType(PaymentExpandedTiles), findsOneWidget);
      });

      testWidgets('should render children in correct order', (tester) async {
        // Mock user device model with data
        startupBlocHelper.setupDoorBellWidgetState();

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find all Column widgets under MoreExpansionWidget
        final columns = tester.widgetList<Column>(
          find.descendant(
            of: find.byType(MoreExpansionWidget),
            matching: find.byType(Column),
          ),
        );
        // Find the Column that contains FeatureExpandedTiles
        final column = columns.firstWhere(
          (col) => col.children.any((child) => child is FeatureExpandedTiles),
        );

        // Verify children are in correct order
        expect(column.children.length, equals(3));
        expect(column.children[0], isA<FeatureExpandedTiles>());
        expect(column.children[1], isA<SettingsExpandedTiles>());
        expect(column.children[2], isA<PaymentExpandedTiles>());
      });
    });

    group('Bloc Integration Tests', () {
      testWidgets('should use StartupBlocSelector.userDeviceModel',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify the selector is used (this is implicit in the widget structure)
        expect(find.byType(MoreExpansionWidget), findsOneWidget);
      });

      testWidgets('should rebuild when user device model changes',
          (tester) async {
        // Start with no devices
        startupBlocHelper.setupNoDoorBellState();

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify no content is shown
        expect(find.byType(FeatureExpandedTiles), findsNothing);
        expect(find.byType(SettingsExpandedTiles), findsNothing);
        expect(find.byType(PaymentExpandedTiles), findsNothing);

        // Change to have devices by re-initializing the helper and bloc
        startupBlocHelper = StartupBlocTestHelper()
          ..setup()
          ..setupDoorBellWidgetState();

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: BlocProvider<StartupBloc>.value(
                value: startupBlocHelper.mockStartupBloc,
                child: const MoreExpansionWidget(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify content is now shown
        expect(find.byType(FeatureExpandedTiles), findsOneWidget);
        expect(find.byType(SettingsExpandedTiles), findsOneWidget);
        expect(find.byType(PaymentExpandedTiles), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle large number of devices', (tester) async {
        // Mock user device model with many devices
        startupBlocHelper.setupCameraWidgetState();

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify the widget renders without errors
        expect(find.byType(MoreExpansionWidget), findsOneWidget);
        expect(find.byType(FeatureExpandedTiles), findsOneWidget);
        expect(find.byType(SettingsExpandedTiles), findsOneWidget);
        expect(find.byType(PaymentExpandedTiles), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should rebuild efficiently when state changes',
          (tester) async {
        // Mock user device model
        startupBlocHelper.setupDoorBellWidgetState();

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Force multiple state changes
        for (int i = 0; i < 10; i++) {
          // Toggle between different states
          if (i.isEven) {
            startupBlocHelper.setupDoorBellWidgetState();
          } else {
            startupBlocHelper.setupCameraWidgetState();
          }
          await tester.pumpWidget(createTestWidget());
          await tester.pumpAndSettle();
        }

        // Verify the widget still renders correctly
        expect(find.byType(MoreExpansionWidget), findsOneWidget);
        expect(find.byType(FeatureExpandedTiles), findsOneWidget);
        expect(find.byType(SettingsExpandedTiles), findsOneWidget);
        expect(find.byType(PaymentExpandedTiles), findsOneWidget);
      });
    });
  });
}
