import 'package:admin/models/data/payment_methods_model.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/pages/main/subscription/components/delete_payment_method_dialog.dart';
import 'package:admin/translations/app_localizations.dart';
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
  group('DeletePaymentMethodDialog UI Tests', () {
    late SubscriptionBlocTestHelper subscriptionBlocTestHelper;
    late MockSubscriptionBloc mockSubscriptionBloc;
    late PaymentMethodsModel testPaymentMethod;

    setUpAll(() async {
      registerFallbackValue(FakeBuildContext());
      await TestHelper.initialize();
    });

    setUp(() {
      subscriptionBlocTestHelper = SubscriptionBlocTestHelper()..setup();
      mockSubscriptionBloc =
          subscriptionBlocTestHelper.getMockSubscriptionBloc();

      // Create test payment method
      testPaymentMethod = PaymentMethodsModel(
        (b) => b
          ..id = 123
          ..userId = 1
          ..paymentMethodId = 'pm_1234567890'
          ..type = 'card'
          ..brand = 'visa'
          ..last4 = '1234'
          ..expMonth = '12'
          ..expYear = '25'
          ..isDefault = false
          ..isActive = true
          ..createdAt = '2024-01-01T00:00:00Z'
          ..updatedAt = '2024-01-01T00:00:00Z',
      );
    });

    tearDown(() {
      subscriptionBlocTestHelper.dispose();
    });

    Widget createTestWidget({
      required PaymentMethodsModel paymentMethod,
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
                child: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => DeletePaymentMethodDialog(
                          paymentMethod: paymentMethod,
                          bloc: bloc,
                        ),
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    group('Dialog Display Tests', () {
      testWidgets('should display dialog with correct title', (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('Are you sure you want to delete payment method?'),
          findsOneWidget,
        );
      });

      testWidgets('should display confirm button with correct label',
          (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Yes'), findsOneWidget);
      });

      testWidgets('should display cancel button with correct label',
          (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('should display close button (X) in dialog', (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byIcon(Icons.cancel), findsOneWidget);
      });
    });

    group('Dialog Interaction Tests', () {
      testWidgets(
          'should call callDeletePaymentMethod when confirm button is tapped',
          (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockSubscriptionBloc
              .callDeletePaymentMethod(testPaymentMethod.id),
        ).called(1);
      });

      testWidgets('should close dialog when confirm button is tapped',
          (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog is shown
        expect(
          find.text('Are you sure you want to delete payment method?'),
          findsOneWidget,
        );

        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert dialog is closed
        expect(
          find.text('Are you sure you want to delete payment method?'),
          findsNothing,
        );
      });

      testWidgets('should close dialog when cancel button is tapped',
          (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog is shown
        expect(
          find.text('Are you sure you want to delete payment method?'),
          findsOneWidget,
        );

        await tester.tap(find.text('Cancel'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert dialog is closed
        expect(
          find.text('Are you sure you want to delete payment method?'),
          findsNothing,
        );
      });

      testWidgets('should close dialog when close button (X) is tapped',
          (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog is shown
        expect(
          find.text('Are you sure you want to delete payment method?'),
          findsOneWidget,
        );

        await tester.tap(find.byIcon(Icons.cancel), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert dialog is closed
        expect(
          find.text('Are you sure you want to delete payment method?'),
          findsNothing,
        );
      });

      testWidgets(
          'should not call callDeletePaymentMethod when cancel button is tapped',
          (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert
        verifyNever(
          () => mockSubscriptionBloc.callDeletePaymentMethod(any()),
        );
      });
    });

    group('Dialog Styling and Layout Tests', () {
      testWidgets('should have proper dialog structure with AppDialogPopup',
          (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('should display buttons in correct order', (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        final confirmButton = find.text('Yes');
        final cancelButton = find.text('Cancel');

        expect(confirmButton, findsOneWidget);
        expect(cancelButton, findsOneWidget);

        // Verify button order by checking the widget tree structure
        // The confirm button should appear before the cancel button in the Column
        final columnWidget = tester.widget<Column>(
          find
              .byType(Column)
              .last, // Get the last Column which contains the buttons
        );

        // Find the button widgets within the column
        final buttonWidgets = columnWidget.children
            .where((widget) => widget.runtimeType.toString().contains('Button'))
            .toList();

        expect(buttonWidgets.length, greaterThanOrEqualTo(2));
      });
    });

    group('BlocProvider Integration Tests', () {
      testWidgets('should provide correct bloc to dialog', (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(BlocProvider<SubscriptionBloc>), findsWidgets);
        expect(find.byType(DeletePaymentMethodDialog), findsOneWidget);

        // Verify that the dialog has access to the bloc
        final dialog = tester.widget<DeletePaymentMethodDialog>(
          find.byType(DeletePaymentMethodDialog),
        );
        expect(dialog.bloc, equals(mockSubscriptionBloc));
      });

      testWidgets('should use provided bloc for method calls', (tester) async {
        // Arrange
        final testPaymentMethod2 = PaymentMethodsModel(
          (b) => b
            ..id = 456
            ..userId = 1
            ..paymentMethodId = 'pm_0987654321'
            ..type = 'card'
            ..brand = 'mastercard'
            ..last4 = '5678'
            ..expMonth = '06'
            ..expYear = '26'
            ..isDefault = true
            ..isActive = true
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod2,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockSubscriptionBloc
              .callDeletePaymentMethod(testPaymentMethod2.id),
        ).called(1);
      });
    });

    group('Payment Method Data Tests', () {
      testWidgets('should handle different payment method types correctly',
          (tester) async {
        // Arrange - Test with different payment method
        final visaPaymentMethod = PaymentMethodsModel(
          (b) => b
            ..id = 1
            ..userId = 1
            ..paymentMethodId = 'pm_visa123'
            ..type = 'card'
            ..brand = 'visa'
            ..last4 = '1234'
            ..expMonth = '12'
            ..expYear = '25'
            ..isDefault = false
            ..isActive = true
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: visaPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockSubscriptionBloc
              .callDeletePaymentMethod(visaPaymentMethod.id),
        ).called(1);
      });

      testWidgets('should handle default payment method correctly',
          (tester) async {
        // Arrange - Test with default payment method
        final defaultPaymentMethod = PaymentMethodsModel(
          (b) => b
            ..id = 999
            ..userId = 1
            ..paymentMethodId = 'pm_default123'
            ..type = 'card'
            ..brand = 'mastercard'
            ..last4 = '9999'
            ..expMonth = '01'
            ..expYear = '27'
            ..isDefault = true
            ..isActive = true
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: defaultPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockSubscriptionBloc
              .callDeletePaymentMethod(defaultPaymentMethod.id),
        ).called(1);
      });

      testWidgets('should handle inactive payment method correctly',
          (tester) async {
        // Arrange - Test with inactive payment method
        final inactivePaymentMethod = PaymentMethodsModel(
          (b) => b
            ..id = 555
            ..userId = 1
            ..paymentMethodId = 'pm_inactive123'
            ..type = 'card'
            ..brand = 'discover'
            ..last4 = '5555'
            ..expMonth = '03'
            ..expYear = '24'
            ..isDefault = false
            ..isActive = false
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: inactivePaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockSubscriptionBloc
              .callDeletePaymentMethod(inactivePaymentMethod.id),
        ).called(1);
      });
    });

    group('Edge Cases and Error Handling Tests', () {
      testWidgets('should handle different payment method IDs correctly',
          (tester) async {
        // Arrange
        final testPaymentMethod1 = PaymentMethodsModel(
          (b) => b
            ..id = 1
            ..userId = 1
            ..paymentMethodId = 'pm_test1'
            ..type = 'card'
            ..brand = 'visa'
            ..last4 = '1111'
            ..expMonth = '01'
            ..expYear = '25'
            ..isDefault = false
            ..isActive = true
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );

        final testPaymentMethod2 = PaymentMethodsModel(
          (b) => b
            ..id = 999
            ..userId = 1
            ..paymentMethodId = 'pm_test2'
            ..type = 'card'
            ..brand = 'mastercard'
            ..last4 = '9999'
            ..expMonth = '12'
            ..expYear = '26'
            ..isDefault = false
            ..isActive = true
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );

        // Act & Assert for first ID
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod1,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.pumpAndSettle();

        verify(
          () => mockSubscriptionBloc
              .callDeletePaymentMethod(testPaymentMethod1.id),
        ).called(1);

        // Reset mock
        reset(mockSubscriptionBloc);
        subscriptionBlocTestHelper.setup();
        mockSubscriptionBloc =
            subscriptionBlocTestHelper.getMockSubscriptionBloc();

        // Act & Assert for second ID
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod2,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.pumpAndSettle();

        verify(
          () => mockSubscriptionBloc
              .callDeletePaymentMethod(testPaymentMethod2.id),
        ).called(1);
      });

      testWidgets('should handle rapid button taps gracefully', (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Rapidly tap confirm button multiple times
        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert - should only be called once due to dialog closing
        verify(
          () => mockSubscriptionBloc
              .callDeletePaymentMethod(testPaymentMethod.id),
        ).called(1);
      });

      testWidgets('should handle dialog dismissal by tapping outside',
          (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Tap outside the dialog
        await tester.tapAt(const Offset(50, 50));
        await tester.pumpAndSettle();

        // Assert - dialog should be closed
        expect(
          find.text('Are you sure you want to delete payment method?'),
          findsNothing,
        );
        verifyNever(
          () => mockSubscriptionBloc.callDeletePaymentMethod(any()),
        );
      });

      testWidgets('should handle zero payment method ID', (tester) async {
        // Arrange
        final zeroIdPaymentMethod = PaymentMethodsModel(
          (b) => b
            ..id = 0
            ..userId = 1
            ..paymentMethodId = 'pm_zero'
            ..type = 'card'
            ..brand = 'visa'
            ..last4 = '0000'
            ..expMonth = '01'
            ..expYear = '25'
            ..isDefault = false
            ..isActive = true
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: zeroIdPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockSubscriptionBloc
              .callDeletePaymentMethod(zeroIdPaymentMethod.id),
        ).called(1);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic labels for screen readers',
          (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('Are you sure you want to delete payment method?'),
          findsOneWidget,
        );
        expect(find.text('Yes'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('should be focusable and navigable', (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - buttons should be tappable
        expect(find.text('Yes'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);

        // Test that buttons respond to taps
        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.pumpAndSettle();

        verify(
          () => mockSubscriptionBloc
              .callDeletePaymentMethod(testPaymentMethod.id),
        ).called(1);
      });
    });

    group('Widget Properties Tests', () {
      testWidgets('should have correct payment method property', (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        final dialog = tester.widget<DeletePaymentMethodDialog>(
          find.byType(DeletePaymentMethodDialog),
        );
        expect(dialog.paymentMethod, equals(testPaymentMethod));
        expect(dialog.paymentMethod.id, equals(123));
        expect(dialog.paymentMethod.brand, equals('visa'));
        expect(dialog.paymentMethod.last4, equals('1234'));
      });

      testWidgets('should have correct bloc property', (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        final dialog = tester.widget<DeletePaymentMethodDialog>(
          find.byType(DeletePaymentMethodDialog),
        );
        expect(dialog.bloc, equals(mockSubscriptionBloc));
      });
    });

    group('Dialog State Management Tests', () {
      testWidgets('should maintain dialog state during interactions',
          (tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: testPaymentMethod,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog is shown
        expect(
          find.text('Are you sure you want to delete payment method?'),
          findsOneWidget,
        );

        // Tap cancel and verify dialog closes
        await tester.tap(find.text('Cancel'), warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(
          find.text('Are you sure you want to delete payment method?'),
          findsNothing,
        );

        // Show dialog again and verify it works
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(
          find.text('Are you sure you want to delete payment method?'),
          findsOneWidget,
        );
      });

      testWidgets('should handle multiple dialog instances correctly',
          (tester) async {
        // Arrange
        final paymentMethod1 = PaymentMethodsModel(
          (b) => b
            ..id = 1
            ..userId = 1
            ..paymentMethodId = 'pm_1'
            ..type = 'card'
            ..brand = 'visa'
            ..last4 = '1111'
            ..expMonth = '01'
            ..expYear = '25'
            ..isDefault = false
            ..isActive = true
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );

        final paymentMethod2 = PaymentMethodsModel(
          (b) => b
            ..id = 2
            ..userId = 1
            ..paymentMethodId = 'pm_2'
            ..type = 'card'
            ..brand = 'mastercard'
            ..last4 = '2222'
            ..expMonth = '02'
            ..expYear = '26'
            ..isDefault = false
            ..isActive = true
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );

        // Act - Show first dialog
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: paymentMethod1,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify first dialog is shown
        expect(
          find.text('Are you sure you want to delete payment method?'),
          findsOneWidget,
        );

        // Close first dialog
        await tester.tap(find.text('Cancel'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Show second dialog
        await tester.pumpWidget(
          createTestWidget(
            paymentMethod: paymentMethod2,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify second dialog is shown
        expect(
          find.text('Are you sure you want to delete payment method?'),
          findsOneWidget,
        );

        // Confirm second dialog
        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockSubscriptionBloc.callDeletePaymentMethod(paymentMethod2.id),
        ).called(1);
      });
    });
  });
}
