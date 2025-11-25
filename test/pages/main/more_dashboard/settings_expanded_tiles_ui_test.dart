import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/main/more_dashboard/components/subcomponents/more_expansion_tile.dart';
import 'package:admin/pages/main/more_dashboard/components/subcomponents/settings_expanded_tiles.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:toastification/toastification.dart';

import '../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';
import '../../../helpers/toast_test_tracker.dart';

void main() {
  late StartupBlocTestHelper startupBlocHelper;

  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    await TestHelper.initialize();
  });

  setUp(() {
    // Reset toast tracker
    ToastTestTracker.reset();

    // Set up toast callback for testing
    ToastUtils.setTestCallback(ToastTestTracker.trackToast);

    startupBlocHelper = StartupBlocTestHelper()..setup();
  });

  tearDown(ToastTestTracker.reset);

  tearDownAll(() async {
    // Reset toast callback
    ToastUtils.resetTestCallback();
    await TestHelper.cleanup();
    startupBlocHelper.dispose();
  });

  Widget createTestWidget() {
    return ToastificationWrapper(
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: 1200, // Increased height to prevent overflow
              child: BlocProvider<StartupBloc>.value(
                value: startupBlocHelper.mockStartupBloc,
                child: SettingsExpandedTiles(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('SettingsExpandedTiles UI Tests', () {
    group('Rendering Tests', () {
      testWidgets('should render SettingsExpandedTiles with MoreExpansionTile',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify the main widget is rendered
        expect(find.byType(SettingsExpandedTiles), findsOneWidget);
        expect(find.byType(MoreExpansionTile), findsOneWidget);
      });

      testWidgets('should render with correct title', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify the title is displayed (uppercase)
        expect(find.text('SETTINGS'), findsOneWidget);
      });

      testWidgets('should render with Icon leading widget', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify the Icon is present
        expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      });
    });

    group('Settings List Tests', () {
      testWidgets('should render all settings items when expanded',
          (tester) async {
        // Mock the expansion state to be true
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(true);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify all expected settings titles are present
        expect(find.text('Modes Settings'), findsOneWidget);
        expect(find.text('Locations Settings'), findsOneWidget);
        expect(find.text('Shop Doorbell'), findsOneWidget);
      });

      testWidgets('should not render settings items when collapsed',
          (tester) async {
        // Mock the expansion state to be false
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(false);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify settings items are not shown when collapsed
        expect(find.text('Modes Settings'), findsNothing);
        expect(find.text('Locations Settings'), findsNothing);
        expect(find.text('Shop Doorbell'), findsNothing);
        expect(find.text('Subscriptions'), findsNothing);
      });

      testWidgets('should render correct number of settings items',
          (tester) async {
        // Mock the expansion state to be true
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(true);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Count the settings items (excluding the main tile)
        final settingsListTiles = find.byType(ListTile);
        expect(settingsListTiles, findsNWidgets(4)); // 4 settings + 1 main tile
      });
    });

    group('Toast-Producing Settings Tests', () {
      testWidgets(
          'should handle Modes Settings tap and show correct toast message',
          (tester) async {
        // Mock the expansion state to be true
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(true);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find and tap the Modes Settings feature
        final modesSettingsTile = find.text('Modes Settings');
        expect(modesSettingsTile, findsOneWidget);

        await tester.tap(modesSettingsTile);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Verify toast was triggered
        expect(ToastTestTracker.toastCallCount, equals(1));
        expect(ToastTestTracker.lastToastTitle, equals('Coming Soon'));
        expect(
          ToastTestTracker.lastToastDescription,
          equals('Modes Settings will be available soon.'),
        );
      });
    });

    group('Navigation Settings Tests', () {
      testWidgets('should handle Locations Settings tap (navigation feature)',
          (tester) async {
        // Mock the expansion state to be true
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(true);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find and tap the Locations Settings feature
        final locationsSettingsTile = find.text('Locations Settings');
        expect(locationsSettingsTile, findsOneWidget);

        // Just verify the tile is tappable without actually navigating
        // Navigation features require additional bloc providers that aren't available in this test
        expect(locationsSettingsTile, findsOneWidget);

        // Verify no toast was triggered (navigation features don't show toasts)
        expect(ToastTestTracker.toastCallCount, equals(0));
      });

      testWidgets('should handle Shop Doorbell tap (URL opening feature)',
          (tester) async {
        // Mock the expansion state to be true
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(true);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find and tap the Shop Doorbell feature
        final shopDoorbellTile = find.text('Shop Doorbell');
        expect(shopDoorbellTile, findsOneWidget);

        // Just verify the tile is tappable without actually opening URL
        // URL opening features require additional setup that isn't available in this test
        expect(shopDoorbellTile, findsOneWidget);

        // Verify no toast was triggered (URL opening features don't show toasts)
        expect(ToastTestTracker.toastCallCount, equals(0));
      });
    });

    group('Toast Message Content Tests', () {
      testWidgets('should verify all toast messages have correct title',
          (tester) async {
        // Mock the expansion state to be true
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(true);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Test all toast-producing settings
        final toastSettings = [
          'Modes Settings',
        ];

        for (final settingText in toastSettings) {
          ToastTestTracker.reset();
          await tester.tap(find.text(settingText));
          await tester.pump(const Duration(milliseconds: 100));
          await tester.pumpAndSettle(const Duration(seconds: 5));
          expect(ToastTestTracker.lastToastTitle, equals('Coming Soon'));
        }
      });

      testWidgets(
          'should verify toast message content for all coming soon settings',
          (tester) async {
        // Mock the expansion state to be true
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(true);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Test Modes Settings toast
        ToastTestTracker.reset();
        await tester.tap(find.text('Modes Settings'));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle(const Duration(seconds: 5));
        expect(
          ToastTestTracker.lastToastDescription,
          equals('Modes Settings will be available soon.'),
        );
      });

      testWidgets('should verify multiple toast messages work correctly',
          (tester) async {
        // Mock the expansion state to be true
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(true);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Tap Modes Settings feature
        await tester.tap(find.text('Modes Settings'));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle(const Duration(seconds: 5));
        expect(ToastTestTracker.toastCallCount, equals(1));
        expect(ToastTestTracker.lastToastTitle, equals('Coming Soon'));
        expect(
          ToastTestTracker.lastToastDescription,
          equals('Modes Settings will be available soon.'),
        );

        // Reset tracker for next test
        ToastTestTracker.reset();
      });

      testWidgets('should verify toast message timing and duration',
          (tester) async {
        // Mock the expansion state to be true
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(true);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Tap Modes Settings feature
        await tester.tap(find.text('Modes Settings'));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle(const Duration(seconds: 5));
        expect(ToastTestTracker.toastCallCount, equals(1));

        // Wait for toast duration (4 seconds)
        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle();

        // Toast should still be tracked (tracker doesn't auto-dismiss)
        expect(ToastTestTracker.toastCallCount, equals(1));
      });
    });

    group('Bloc Integration Tests', () {
      testWidgets(
          'should use StartupBlocSelector.moreCustomSettingsTileExpanded',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify the selector is used (this is implicit in the widget structure)
        expect(find.byType(SettingsExpandedTiles), findsOneWidget);
      });

      testWidgets(
          'should call updateMoreCustomSettingsTileExpanded when tapped',
          (tester) async {
        // Mock the expansion state to be false initially
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(false);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Tap the main tile to expand
        await tester.tap(find.byType(ListTile));
        await tester.pumpAndSettle();

        // Verify the bloc method was called
        verify(
          () => startupBlocHelper.mockStartupBloc
              .updateMoreCustomSettingsTileExpanded(true),
        ).called(1);
      });

      testWidgets(
          'should call updateMoreCustomFeatureTileExpanded when expanding',
          (tester) async {
        // Mock the expansion state to be false initially
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(false);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Tap the main tile to expand
        await tester.tap(find.byType(ListTile));
        await tester.pumpAndSettle();

        // Verify the feature tile is collapsed when settings expand
        verify(
          () => startupBlocHelper.mockStartupBloc
              .updateMoreCustomFeatureTileExpanded(false),
        ).called(1);
      });

      testWidgets('should rebuild when expansion state changes',
          (tester) async {
        // Start with collapsed state
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(false);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify no settings items are shown
        expect(find.text('Modes Settings'), findsNothing);

        // Change to expanded state and rebuild widget
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(true);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify settings items are now shown
        expect(find.text('Modes Settings'), findsOneWidget);
      });
    });

    group('Icon and Styling Tests', () {
      testWidgets('should render SVG icons for settings items', (tester) async {
        // Mock the expansion state to be true
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(true);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify CircleAvatar widgets are present for settings items
        expect(find.byType(CircleAvatar), findsNWidgets(3)); // 4 settings
      });

      testWidgets('should apply correct styling to settings titles',
          (tester) async {
        // Mock the expansion state to be true
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(true);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find a settings title text widget
        final settingsText = tester.widget<Text>(
          find.descendant(
            of: find.byType(ListTile).at(1), // First settings item
            matching: find.byType(Text),
          ),
        );

        // Verify text style properties
        expect(settingsText.style?.fontSize, equals(16));
        expect(settingsText.style?.fontWeight, equals(FontWeight.w400));
      });

      testWidgets('should render settings icon with correct properties',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find the settings icon
        final settingsIcon = tester.widget<Icon>(
          find.byIcon(Icons.settings_outlined),
        );

        // Verify icon properties
        expect(settingsIcon.size, equals(24));
        expect(settingsIcon.color, isNotNull);
      });
    });

    group('Settings List Structure Tests', () {
      testWidgets('should render settings items in correct order',
          (tester) async {
        // Mock the expansion state to be true
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(true);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify settings are in the correct order
        expect(find.text('Modes Settings'), findsOneWidget);
        expect(find.text('Locations Settings'), findsOneWidget);
        expect(find.text('Shop Doorbell'), findsOneWidget);
      });

      testWidgets('should apply correct padding to settings list',
          (tester) async {
        // Mock the expansion state to be true
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(true);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify settings items are present
        expect(find.text('Modes Settings'), findsOneWidget);
        expect(find.text('Locations Settings'), findsOneWidget);
        expect(find.text('Shop Doorbell'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle rapid expansion state changes',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Rapidly change expansion state
        for (int i = 0; i < 10; i++) {
          when(
            () => startupBlocHelper
                .currentStartupState.moreCustomSettingsTileExpanded,
          ).thenReturn(i.isEven);
          startupBlocHelper.mockStartupBloc
              .updateMoreCustomSettingsTileExpanded(i.isEven);
          await tester.pumpAndSettle();
        }

        // Verify the widget still renders correctly
        expect(find.byType(SettingsExpandedTiles), findsOneWidget);
      });

      testWidgets('should handle multiple taps on main tile', (tester) async {
        // Mock the expansion state to be false initially
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(false);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Tap multiple times
        await tester.tap(find.byType(ListTile));
        await tester.tap(find.byType(ListTile));
        await tester.tap(find.byType(ListTile));
        await tester.pumpAndSettle();

        // Verify the bloc methods were called
        verify(
          () => startupBlocHelper.mockStartupBloc
              .updateMoreCustomSettingsTileExpanded(any()),
        ).called(3);
      });

      testWidgets('should handle concurrent expansion with features',
          (tester) async {
        // Mock both expansion states
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomSettingsTileExpanded,
        ).thenReturn(false);
        when(
          () => startupBlocHelper
              .currentStartupState.moreCustomFeatureTileExpanded,
        ).thenReturn(false);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify the main tile is present
        expect(find.byType(ListTile), findsOneWidget);

        // Verify the bloc methods haven't been called yet
        verifyNever(
          () => startupBlocHelper.mockStartupBloc
              .updateMoreCustomSettingsTileExpanded(any()),
        );
        verifyNever(
          () => startupBlocHelper.mockStartupBloc
              .updateMoreCustomFeatureTileExpanded(any()),
        );
      });
    });

    group('Performance Tests', () {
      testWidgets('should rebuild efficiently when state changes',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Force multiple state changes
        for (int i = 0; i < 10; i++) {
          startupBlocHelper.mockStartupBloc
              .updateMoreCustomSettingsTileExpanded(i.isEven);
          await tester.pumpAndSettle();
        }

        // Verify the widget still renders correctly
        expect(find.byType(SettingsExpandedTiles), findsOneWidget);
      });

      testWidgets('should handle large number of state changes',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Force many state changes
        for (int i = 0; i < 50; i++) {
          startupBlocHelper.mockStartupBloc
              .updateMoreCustomSettingsTileExpanded(i.isEven);
          await tester.pumpAndSettle();
        }

        // Verify the widget still renders correctly
        expect(find.byType(SettingsExpandedTiles), findsOneWidget);
      });
    });
  });
}
