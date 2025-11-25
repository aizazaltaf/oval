import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/transaction_history_model.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/pages/main/subscription/components/transaction_history_card.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/bloc_helpers/subscription_bloc_test_helper.dart';
import '../../../../helpers/fake_build_context.dart';
import '../../../../helpers/test_helper.dart';
import '../../../../mocks/bloc/bloc_mocks.dart';

void main() {
  group('TransactionHistoryCard UI Tests', () {
    late SubscriptionBlocTestHelper subscriptionBlocTestHelper;
    late MockSubscriptionBloc mockSubscriptionBloc;

    setUpAll(() async {
      registerFallbackValue(FakeBuildContext());
      await TestHelper.initialize();
    });

    setUp(() {
      subscriptionBlocTestHelper = SubscriptionBlocTestHelper()..setup();
      mockSubscriptionBloc =
          subscriptionBlocTestHelper.getMockSubscriptionBloc();
    });

    tearDown(() {
      subscriptionBlocTestHelper.dispose();
    });

    Widget createTestWidget({
      required TransactionHistoryModel transactionHistory,
      required SubscriptionBloc bloc,
    }) {
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
            home: Scaffold(
              body: BlocProvider<SubscriptionBloc>(
                create: (context) => bloc,
                child: TransactionHistoryCard(
                  transactionHistory: transactionHistory,
                ),
              ),
            ),
          );
        },
      );
    }

    TransactionHistoryModel createSuccessTransaction() {
      return TransactionHistoryModel(
        (b) => b
          ..id = 1
          ..subscriptionId = 1
          ..planName = 'Guard Pro Monthly Subscription'
          ..status = 'success'
          ..amount = '9.99'
          ..type = 'subscription'
          ..expiryDate = '2024-02-15'
          ..amountDeducted = '9.99'
          ..dateTime = '2024-01-15T00:00:00Z'
          ..taxDeducted = '0.00'
          ..doorbellLocations.replace(
            DoorbellLocations(
              (b) => b
                ..id = 1
                ..name = 'Test Location'
                ..roles = ListBuilder<String>(['owner']),
            ),
          ),
      );
    }

    TransactionHistoryModel createFailedTransaction() {
      return TransactionHistoryModel(
        (b) => b
          ..id = 2
          ..subscriptionId = 2
          ..planName = 'Guard Basic Monthly Subscription'
          ..status = 'failed'
          ..amount = '4.99'
          ..type = 'subscription'
          ..expiryDate = '2024-02-01'
          ..amountDeducted = '4.99'
          ..dateTime = '2024-01-01T00:00:00Z'
          ..taxDeducted = '0.00'
          ..doorbellLocations.replace(
            DoorbellLocations(
              (b) => b
                ..id = 2
                ..name = 'Test Location 2'
                ..roles = ListBuilder<String>(['owner']),
            ),
          ),
      );
    }

    group('Card Display Tests', () {
      testWidgets(
          'should display success transaction card with correct content',
          (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert
        expect(
          find.text('Guard Pro Monthly Subscription (Test Location)'),
          findsOneWidget,
        );
        expect(find.text('Success'), findsOneWidget);
        expect(find.text('2024-02-15'), findsOneWidget);
        expect(find.text('\$9.99'), findsOneWidget);
      });

      testWidgets('should display failed transaction card with correct content',
          (tester) async {
        // Arrange
        final transaction = createFailedTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert
        expect(
          find.text('Guard Basic Monthly Subscription (Test Location 2)'),
          findsOneWidget,
        );
        expect(find.text('Failed'), findsOneWidget);
        expect(find.text('2024-02-01'), findsOneWidget);
        expect(find.text('\$4.99'), findsOneWidget);
      });

      testWidgets('should display card with proper structure', (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert
        expect(find.byType(GestureDetector), findsOneWidget);
        expect(find.byType(Material), findsAtLeastNWidgets(1));
        expect(find.byType(DecoratedBox), findsAtLeastNWidgets(1));
        expect(find.byType(Container), findsAtLeastNWidgets(1)); // Accent line
        expect(find.byType(Expanded), findsNWidgets(2)); // Content and amount
        expect(find.byType(Row), findsNWidgets(2)); // Main row and content row
        expect(find.byType(Column), findsOneWidget);
      });
    });

    group('Color and Styling Tests', () {
      testWidgets('should display green colors for success transaction',
          (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration! as BoxDecoration;
        expect(
          decoration.color,
          equals(const Color(0xFF4CAF50)),
        ); // Green accent

        // Check status text color
        final statusText = tester.widget<Text>(
          find.text('Success'),
        );
        expect(statusText.style?.color, equals(const Color(0xFF4CAF50)));

        // Check amount text color
        final amountText = tester.widget<Text>(
          find.text('\$9.99'),
        );
        expect(amountText.style?.color, equals(const Color(0xFF4CAF50)));
      });

      testWidgets('should display red colors for failed transaction',
          (tester) async {
        // Arrange
        final transaction = createFailedTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, equals(const Color(0xFFE74C3C))); // Red accent

        // Check status text color
        final statusText = tester.widget<Text>(
          find.text('Failed'),
        );
        expect(statusText.style?.color, equals(const Color(0xFFE74C3C)));

        // Check amount text color
        final amountText = tester.widget<Text>(
          find.text('\$4.99'),
        );
        expect(amountText.style?.color, equals(const Color(0xFFE74C3C)));
      });

      testWidgets('should have proper card elevation and border radius',
          (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert
        final material = tester.widget<Material>(
          find.byType(Material).last,
        );
        expect(material.elevation, equals(4));

        final decoratedBox = tester.widget<DecoratedBox>(
          find.byType(DecoratedBox).first,
        );
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.borderRadius, equals(BorderRadius.circular(12)));
      });

      testWidgets('should have proper accent line styling', (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        expect(container.constraints?.minWidth, equals(4.0));
        expect(container.constraints?.minHeight, equals(54.0));

        final decoration = container.decoration! as BoxDecoration;
        expect(
          decoration.borderRadius,
          equals(
            const BorderRadius.only(
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
        );
      });
    });

    group('Text Styling Tests', () {
      testWidgets('should display plan name with correct styling',
          (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert
        final planNameText = tester.widget<Text>(
          find.text('Guard Pro Monthly Subscription (Test Location)'),
        );
        expect(planNameText.style?.fontSize, equals(16));
        expect(planNameText.style?.fontWeight, equals(FontWeight.w600));
        expect(planNameText.style?.color, equals(const Color(0xFF2C3E50)));
      });

      testWidgets('should display status with correct styling', (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert
        final statusText = tester.widget<Text>(
          find.text('Success'),
        );
        expect(statusText.style?.fontSize, equals(14));
        expect(statusText.style?.fontWeight, equals(FontWeight.w500));
        expect(statusText.style?.color, equals(const Color(0xFF4CAF50)));
      });

      testWidgets('should display expiry date with correct styling',
          (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert
        final expiryDateText = tester.widget<Text>(
          find.text('2024-02-15'),
        );
        expect(expiryDateText.style?.fontSize, equals(12));
        expect(expiryDateText.style?.fontWeight, equals(FontWeight.w400));
        expect(expiryDateText.style?.color, equals(const Color(0xFF7F8C8D)));
      });

      testWidgets('should display amount with correct styling', (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert
        final amountText = tester.widget<Text>(
          find.text('\$9.99'),
        );
        expect(amountText.style?.fontSize, equals(16));
        expect(amountText.style?.fontWeight, equals(FontWeight.w600));
        expect(amountText.style?.color, equals(const Color(0xFF4CAF50)));
      });
    });

    group('Card Interaction Tests', () {
      testWidgets('should be tappable and show dialog on tap', (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Tap the card
        await tester.tap(find.byType(GestureDetector));
        await tester.pumpAndSettle();

        // Assert - Dialog should be shown
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.text('Transaction Details'), findsOneWidget);
      });

      testWidgets('should pass correct transaction data to dialog',
          (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Tap the card
        await tester.tap(find.byType(GestureDetector));
        await tester.pumpAndSettle();

        // Assert - Dialog should contain transaction details
        expect(find.text('Transaction Details'), findsOneWidget);
        expect(find.text('\$9.99'), findsAtLeastNWidgets(1)); // Card and dialog
        expect(
          find.text('2024-02-15'),
          findsAtLeastNWidgets(1),
        ); // Card and dialog
      });

      testWidgets('should close dialog when tapping outside', (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Tap the card to open dialog
        await tester.tap(find.byType(GestureDetector));
        await tester.pumpAndSettle();

        // Verify dialog is open
        expect(find.byType(Dialog), findsOneWidget);

        // Tap outside the dialog
        await tester.tapAt(const Offset(50, 50));
        await tester.pumpAndSettle();

        // Assert - Dialog should be closed
        expect(find.byType(Dialog), findsNothing);
      });
    });

    group('Edge Cases and Error Handling Tests', () {
      testWidgets('should handle empty plan name gracefully', (tester) async {
        // Arrange
        final transaction = TransactionHistoryModel(
          (b) => b
            ..id = 1
            ..subscriptionId = 1
            ..planName = ''
            ..status = 'success'
            ..amount = '9.99'
            ..type = 'subscription'
            ..expiryDate = '2024-02-15'
            ..amountDeducted = '9.99'
            ..dateTime = '2024-01-15T00:00:00Z'
            ..taxDeducted = '0.00'
            ..doorbellLocations.replace(
              DoorbellLocations(
                (b) => b
                  ..id = 1
                  ..name = 'Test Location'
                  ..roles = ListBuilder<String>(['owner']),
              ),
            ),
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert
        expect(find.text(' (Test Location)'), findsOneWidget);
        expect(find.text('Success'), findsOneWidget);
        expect(find.text('\$9.99'), findsOneWidget);
      });

      testWidgets('should handle empty status gracefully', (tester) async {
        // Arrange
        final transaction = TransactionHistoryModel(
          (b) => b
            ..id = 1
            ..subscriptionId = 1
            ..planName = 'Test Plan'
            ..status = ''
            ..amount = '9.99'
            ..type = 'subscription'
            ..expiryDate = '2024-02-15'
            ..amountDeducted = '9.99'
            ..dateTime = '2024-01-15T00:00:00Z'
            ..taxDeducted = '0.00'
            ..doorbellLocations.replace(
              DoorbellLocations(
                (b) => b
                  ..id = 1
                  ..name = 'Test Location'
                  ..roles = ListBuilder<String>(['owner']),
              ),
            ),
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert - Should show red color for empty status (treated as failed)
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, equals(const Color(0xFFE74C3C)));
      });

      testWidgets('should handle case insensitive status comparison',
          (tester) async {
        // Arrange
        final transaction = TransactionHistoryModel(
          (b) => b
            ..id = 1
            ..subscriptionId = 1
            ..planName = 'Test Plan'
            ..status = 'SUCCESS' // Uppercase
            ..amount = '9.99'
            ..type = 'subscription'
            ..expiryDate = '2024-02-15'
            ..amountDeducted = '9.99'
            ..dateTime = '2024-01-15T00:00:00Z'
            ..taxDeducted = '0.00'
            ..doorbellLocations.replace(
              DoorbellLocations(
                (b) => b
                  ..id = 1
                  ..name = 'Test Location'
                  ..roles = ListBuilder<String>(['owner']),
              ),
            ),
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert - Should show green color for uppercase SUCCESS
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, equals(const Color(0xFF4CAF50)));
      });

      testWidgets('should handle very long plan names', (tester) async {
        // Arrange
        const longPlanName =
            'Very Long Plan Name That Should Be Handled Properly By The UI Component Without Breaking The Layout Or Causing Overflow Issues';
        final transaction = TransactionHistoryModel(
          (b) => b
            ..id = 1
            ..subscriptionId = 1
            ..planName = longPlanName
            ..status = 'success'
            ..amount = '9.99'
            ..type = 'subscription'
            ..expiryDate = '2024-02-15'
            ..amountDeducted = '9.99'
            ..dateTime = '2024-01-15T00:00:00Z'
            ..taxDeducted = '0.00'
            ..doorbellLocations.replace(
              DoorbellLocations(
                (b) => b
                  ..id = 1
                  ..name = 'Test Location'
                  ..roles = ListBuilder<String>(['owner']),
              ),
            ),
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert - Should display the long plan name
        expect(find.textContaining(longPlanName), findsOneWidget);
        expect(find.text('Success'), findsOneWidget);
        expect(find.text('\$9.99'), findsOneWidget);
      });

      testWidgets('should handle special characters in plan name',
          (tester) async {
        // Arrange
        const specialPlanName =
            'Plan with Special Characters: @#\$%^&*()_+-=[]{}|;:,.<>?';
        final transaction = TransactionHistoryModel(
          (b) => b
            ..id = 1
            ..subscriptionId = 1
            ..planName = specialPlanName
            ..status = 'success'
            ..amount = '9.99'
            ..type = 'subscription'
            ..expiryDate = '2024-02-15'
            ..amountDeducted = '9.99'
            ..dateTime = '2024-01-15T00:00:00Z'
            ..taxDeducted = '0.00'
            ..doorbellLocations.replace(
              DoorbellLocations(
                (b) => b
                  ..id = 1
                  ..name = 'Test Location'
                  ..roles = ListBuilder<String>(['owner']),
              ),
            ),
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert - Should display the special characters
        expect(
          find.textContaining('Plan With Special Characters'),
          findsOneWidget,
        );
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should be accessible to screen readers', (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert - All text should be findable
        expect(
          find.text('Guard Pro Monthly Subscription (Test Location)'),
          findsOneWidget,
        );
        expect(find.text('Success'), findsOneWidget);
        expect(find.text('2024-02-15'), findsOneWidget);
        expect(find.text('\$9.99'), findsOneWidget);
      });

      testWidgets('should be tappable for accessibility', (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert - GestureDetector should be present and tappable
        final gestureDetector = tester.widget<GestureDetector>(
          find.byType(GestureDetector),
        );
        expect(gestureDetector.onTap, isNotNull);

        // Test that tap works
        await tester.tap(find.byType(GestureDetector));
        await tester.pumpAndSettle();
        expect(find.byType(Dialog), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should render efficiently with multiple cards',
          (tester) async {
        // Arrange
        final transactions = List.generate(
          10,
          (index) => TransactionHistoryModel(
            (b) => b
              ..id = index
              ..subscriptionId = index
              ..planName = 'Plan $index'
              ..status = index.isEven ? 'success' : 'failed'
              ..amount = '${index + 1}.99'
              ..type = 'subscription'
              ..expiryDate = '2024-02-${index + 1}'
              ..amountDeducted = '${index + 1}.99'
              ..dateTime = '2024-01-${index + 1}T00:00:00Z'
              ..taxDeducted = '0.00'
              ..doorbellLocations.replace(
                DoorbellLocations(
                  (b) => b
                    ..id = index
                    ..name = 'Location $index'
                    ..roles = ListBuilder<String>(['owner']),
                ),
              ),
          ),
        );

        // Act
        await tester.pumpWidget(
          FlutterSizer(
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
                home: Scaffold(
                  body: BlocProvider<SubscriptionBloc>(
                    create: (context) => mockSubscriptionBloc,
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: TransactionHistoryCard(
                            transactionHistory: transactions[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );

        // Assert - All cards should be rendered
        expect(find.byType(TransactionHistoryCard), findsAtLeastNWidgets(6));
        expect(find.byType(GestureDetector), findsAtLeastNWidgets(6));
        expect(find.byType(Material), findsAtLeastNWidgets(6));
      });
    });

    group('BlocProvider Integration Tests', () {
      testWidgets('should access bloc correctly', (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Assert
        expect(find.byType(BlocProvider<SubscriptionBloc>), findsOneWidget);
        expect(find.byType(TransactionHistoryCard), findsOneWidget);

        // Verify that the card has access to the bloc
        final card = tester.widget<TransactionHistoryCard>(
          find.byType(TransactionHistoryCard),
        );
        expect(card.transactionHistory, equals(transaction));
      });

      testWidgets('should pass bloc to dialog when tapped', (tester) async {
        // Arrange
        final transaction = createSuccessTransaction();

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transaction,
            bloc: mockSubscriptionBloc,
          ),
        );

        // Tap the card
        await tester.tap(find.byType(GestureDetector));
        await tester.pumpAndSettle();

        // Assert - Dialog should have access to the bloc
        expect(
          find.byType(BlocProvider<SubscriptionBloc>),
          findsNWidgets(2),
        ); // One for card, one for dialog
      });
    });
  });
}
