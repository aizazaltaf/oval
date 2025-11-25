import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/pages/main/subscription/components/transaction_history_filter_panel.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../../helpers/bloc_helpers/subscription_bloc_test_helper.dart';
import '../../../../helpers/fake_build_context.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  group('TransactionHistoryFilterPanel UI Tests', () {
    late SubscriptionBlocTestHelper subscriptionBlocTestHelper;

    setUpAll(() async {
      registerFallbackValue(FakeBuildContext());
      await TestHelper.initialize();

      // Initialize helper classes
      subscriptionBlocTestHelper = SubscriptionBlocTestHelper()..setup();
    });

    setUp(() {
      // Reset to default state before each test
      subscriptionBlocTestHelper.setupDefaultState();
      // Reset mock call counts
      reset(subscriptionBlocTestHelper.mockSubscriptionBloc);

      // Re-setup the mock methods after reset
      when(
        () => subscriptionBlocTestHelper.mockSubscriptionBloc
            .callPaymentMethods(),
      ).thenAnswer((_) async {});
      when(
        () => subscriptionBlocTestHelper.mockSubscriptionBloc
            .callOnRefreshPaymentMethods(),
      ).thenAnswer((_) async {});
      when(
        () => subscriptionBlocTestHelper.mockSubscriptionBloc
            .callMakeDefaultPaymentMethod(any()),
      ).thenAnswer((_) async {});
      when(
        () => subscriptionBlocTestHelper.mockSubscriptionBloc
            .callDeletePaymentMethod(any()),
      ).thenAnswer((_) async {});
      when(
        () => subscriptionBlocTestHelper.mockSubscriptionBloc
            .callTransactionHistory(),
      ).thenAnswer((_) async {});
      when(
        () => subscriptionBlocTestHelper.mockSubscriptionBloc
            .downloadInvoice(any()),
      ).thenAnswer((_) async {});
      when(
        () => subscriptionBlocTestHelper.mockSubscriptionBloc
            .checkStoragePermission(),
      ).thenAnswer((_) async => true);
    });

    tearDown(() {
      // Clean up after each test
    });

    tearDownAll(() async {
      await TestHelper.cleanup();
    });

    Widget createTestWidget() {
      return FlutterSizer(
        builder: (context, orientation, screen) {
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
            ],
            locale: const Locale('en', ''),
            home: BlocProvider<SubscriptionBloc>.value(
              value: subscriptionBlocTestHelper.mockSubscriptionBloc,
              child: Scaffold(
                body: TransactionHistoryFilterPanel(),
              ),
            ),
          );
        },
      );
    }

    group('Widget Structure Tests', () {
      testWidgets('should display filter icon', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byIcon(MdiIcons.tuneVerticalVariant), findsOneWidget);
      });

      testWidgets('should have correct icon size', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        final iconFinder = find.byIcon(MdiIcons.tuneVerticalVariant);
        expect(iconFinder, findsOneWidget);

        final iconWidget = tester.widget<Icon>(iconFinder);
        expect(iconWidget.size, equals(24));
      });

      testWidgets('should be wrapped in GestureDetector', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(GestureDetector), findsNWidgets(2));
        expect(find.byType(SuperTooltip), findsOneWidget);
      });

      testWidgets('should have correct padding', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        final paddingFinder = find.byType(Padding);
        expect(paddingFinder, findsOneWidget);

        final paddingWidget = tester.widget<Padding>(paddingFinder);
        expect(
          paddingWidget.padding,
          equals(const EdgeInsets.only(right: 20)),
        );
      });

      testWidgets('should have SuperTooltip with correct properties',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        final tooltipFinder = find.byType(SuperTooltip);
        expect(tooltipFinder, findsOneWidget);

        final tooltipWidget = tester.widget<SuperTooltip>(tooltipFinder);
        expect(tooltipWidget.arrowTipDistance, equals(20));
        expect(tooltipWidget.arrowLength, equals(8));
        expect(tooltipWidget.arrowTipRadius, equals(6));
        expect(tooltipWidget.shadowBlurRadius, equals(7));
        expect(tooltipWidget.shadowSpreadRadius, equals(0));
        expect(tooltipWidget.showBarrier, isTrue);
        expect(tooltipWidget.barrierColor, equals(Colors.transparent));
      });
    });

    group('Tooltip Content Tests', () {
      testWidgets('should show tooltip when tapped', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap the filter icon to show tooltip
        await tester.tap(find.byIcon(MdiIcons.tuneVerticalVariant));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Monthly'), findsOneWidget);
        expect(find.text('Annually'), findsOneWidget);
        expect(find.byType(PopupMenuDivider), findsOneWidget);
      });

      testWidgets('should have correct tooltip content structure',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap the filter icon to show tooltip
        await tester.tap(find.byIcon(MdiIcons.tuneVerticalVariant));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(IntrinsicWidth), findsOneWidget);
        expect(find.byType(IntrinsicHeight), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
      });

      testWidgets('should have tappable filter options', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap the filter icon to show tooltip
        await tester.tap(find.byIcon(MdiIcons.tuneVerticalVariant));
        await tester.pumpAndSettle();

        // Assert
        final monthlyFinder = find.text('Monthly');
        final annuallyFinder = find.text('Annually');

        expect(monthlyFinder, findsOneWidget);
        expect(annuallyFinder, findsOneWidget);

        // Check that both options are wrapped in GestureDetector
        expect(
          find.ancestor(
            of: monthlyFinder,
            matching: find.byType(GestureDetector),
          ),
          findsNWidgets(2),
        );
        expect(
          find.ancestor(
            of: annuallyFinder,
            matching: find.byType(GestureDetector),
          ),
          findsNWidgets(2),
        );
      });
    });

    group('Filter Option Interaction Tests', () {
      testWidgets('should call updateTransactionFilter when Monthly is tapped',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap the filter icon to show tooltip
        await tester.tap(find.byIcon(MdiIcons.tuneVerticalVariant));
        await tester.pumpAndSettle();

        // Tap Monthly option
        await tester.tap(find.text('Monthly'));
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => subscriptionBlocTestHelper.mockSubscriptionBloc
              .updateTransactionFilter('monthly'),
        ).called(1);
      });

      testWidgets('should call updateTransactionFilter when Annually is tapped',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap the filter icon to show tooltip
        await tester.tap(find.byIcon(MdiIcons.tuneVerticalVariant));
        await tester.pumpAndSettle();

        // Tap Annually option
        await tester.tap(find.text('Annually'));
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => subscriptionBlocTestHelper.mockSubscriptionBloc
              .updateTransactionFilter('annually'),
        ).called(1);
      });

      testWidgets(
          'should call callTransactionHistory when filter option is tapped',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap the filter icon to show tooltip
        await tester.tap(find.byIcon(MdiIcons.tuneVerticalVariant));
        await tester.pumpAndSettle();

        // Tap Monthly option
        await tester.tap(find.text('Monthly'));
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => subscriptionBlocTestHelper.mockSubscriptionBloc
              .callTransactionHistory(),
        ).called(1);
      });

      testWidgets('should hide tooltip after filter option is tapped',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap the filter icon to show tooltip
        await tester.tap(find.byIcon(MdiIcons.tuneVerticalVariant));
        await tester.pumpAndSettle();

        // Verify tooltip is visible
        expect(find.text('Monthly'), findsOneWidget);
        expect(find.text('Annually'), findsOneWidget);

        // Tap Monthly option
        await tester.tap(find.text('Monthly'));
        await tester.pumpAndSettle();

        // Assert - tooltip should be hidden
        expect(find.text('Monthly'), findsNothing);
        expect(find.text('Annually'), findsNothing);
      });
    });

    group('Styling and Theme Tests', () {
      testWidgets('should use theme-based icon color', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        final iconFinder = find.byIcon(MdiIcons.tuneVerticalVariant);
        expect(iconFinder, findsOneWidget);

        final iconWidget = tester.widget<Icon>(iconFinder);
        expect(iconWidget.color, isNotNull);
      });

      testWidgets('should have correct text style for filter options',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap the filter icon to show tooltip
        await tester.tap(find.byIcon(MdiIcons.tuneVerticalVariant));
        await tester.pumpAndSettle();

        // Assert
        final monthlyTextFinder = find.text('Monthly');
        expect(monthlyTextFinder, findsOneWidget);

        final monthlyTextWidget = tester.widget<Text>(monthlyTextFinder);
        expect(monthlyTextWidget.style?.fontSize, equals(12));
        expect(monthlyTextWidget.style?.fontWeight, equals(FontWeight.w400));
      });

      testWidgets('should have correct width for filter options',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap the filter icon to show tooltip
        await tester.tap(find.byIcon(MdiIcons.tuneVerticalVariant));
        await tester.pumpAndSettle();

        // Assert
        final monthlySizedBoxFinder = find.ancestor(
          of: find.text('Monthly'),
          matching: find.byType(SizedBox),
        );
        expect(monthlySizedBoxFinder, findsOneWidget);

        final monthlySizedBoxWidget =
            tester.widget<SizedBox>(monthlySizedBoxFinder);
        expect(monthlySizedBoxWidget.width, isNotNull);
      });

      testWidgets('should use correct background color for tooltip',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap the filter icon to show tooltip
        await tester.tap(find.byIcon(MdiIcons.tuneVerticalVariant));
        await tester.pumpAndSettle();

        // Assert
        final tooltipFinder = find.byType(SuperTooltip);
        expect(tooltipFinder, findsOneWidget);

        final tooltipWidget = tester.widget<SuperTooltip>(tooltipFinder);
        expect(tooltipWidget.backgroundColor, isNotNull);
        expect(tooltipWidget.borderColor, equals(Colors.white));
      });
    });

    group('Bloc Integration Tests', () {
      testWidgets('should access SubscriptionBloc from context',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(TransactionHistoryFilterPanel), findsOneWidget);
        // The widget should be able to access the bloc without errors
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle bloc method calls correctly', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap the filter icon to show tooltip
        await tester.tap(find.byIcon(MdiIcons.tuneVerticalVariant));
        await tester.pumpAndSettle();

        // Tap Monthly option
        await tester.tap(find.text('Monthly'));
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => subscriptionBlocTestHelper.mockSubscriptionBloc
              .updateTransactionFilter(any()),
        ).called(1);
        verify(
          () => subscriptionBlocTestHelper.mockSubscriptionBloc
              .callTransactionHistory(),
        ).called(1);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should be accessible for screen readers', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byIcon(MdiIcons.tuneVerticalVariant), findsOneWidget);
        // The icon should be tappable and accessible
        expect(find.byType(GestureDetector), findsNWidgets(2));
      });

      testWidgets('should have proper hit test behavior', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        final gestureDetectorFinder = find.byType(GestureDetector);
        expect(gestureDetectorFinder, findsNWidgets(2));

        final gestureDetectorWidget =
            tester.widget<GestureDetector>(gestureDetectorFinder.first);
        expect(gestureDetectorWidget.behavior, equals(HitTestBehavior.opaque));
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should handle tooltip controller operations',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Tap the filter icon multiple times
        await tester.tap(
          find.byIcon(MdiIcons.tuneVerticalVariant),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.byIcon(MdiIcons.tuneVerticalVariant),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        // Assert - Should not throw any exceptions
        expect(tester.takeException(), isNull);
      });
    });

    group('Widget Lifecycle Tests', () {
      testWidgets('should dispose tooltip controller properly', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Remove widget
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();

        // Assert - Should not throw any exceptions during disposal
        expect(tester.takeException(), isNull);
      });

      testWidgets('should rebuild correctly when bloc state changes',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Change bloc state
        subscriptionBlocTestHelper.setupWithTransactionHistory();
        await tester.pump();

        // Assert - Widget should still be present and functional
        expect(find.byType(TransactionHistoryFilterPanel), findsOneWidget);
        expect(find.byIcon(MdiIcons.tuneVerticalVariant), findsOneWidget);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle rapid tapping of filter options',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Rapidly tap the filter icon multiple times
        for (int i = 0; i < 3; i++) {
          await tester.tap(
            find.byIcon(MdiIcons.tuneVerticalVariant),
            warnIfMissed: false,
          );
          await tester.pump();
        }
        await tester.pumpAndSettle();

        // Assert - Should handle rapid tapping gracefully
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle tooltip show/hide cycles', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Show and hide tooltip multiple times
        for (int i = 0; i < 3; i++) {
          await tester.tap(
            find.byIcon(MdiIcons.tuneVerticalVariant),
            warnIfMissed: false,
          );
          await tester.pumpAndSettle();

          await tester.tap(
            find.byIcon(MdiIcons.tuneVerticalVariant),
            warnIfMissed: false,
          );
          await tester.pumpAndSettle();
        }

        // Assert - Should handle show/hide cycles gracefully
        expect(tester.takeException(), isNull);
      });
    });
  });
}
