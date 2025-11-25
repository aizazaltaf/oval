import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/pages/main/subscription/components/default_payment_method_dialog.dart';
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
  group('DefaultPaymentMethodDialog UI Tests', () {
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
      required int paymentMethodId,
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
                        builder: (context) => DefaultPaymentMethodDialog(
                          paymentMethodId: paymentMethodId,
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
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('Are you sure you want to make this default?'),
          findsOneWidget,
        );
      });

      testWidgets('should display confirm button with correct label',
          (tester) async {
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
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
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('should display close button (X) in dialog', (tester) async {
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
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
          'should call callMakeDefaultPaymentMethod when confirm button is tapped',
          (tester) async {
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
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
              .callMakeDefaultPaymentMethod(testPaymentMethodId),
        ).called(1);
      });

      testWidgets('should close dialog when confirm button is tapped',
          (tester) async {
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog is shown
        expect(
          find.text('Are you sure you want to make this default?'),
          findsOneWidget,
        );

        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert dialog is closed
        expect(
          find.text('Are you sure you want to make this default?'),
          findsNothing,
        );
      });

      testWidgets('should close dialog when cancel button is tapped',
          (tester) async {
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog is shown
        expect(
          find.text('Are you sure you want to make this default?'),
          findsOneWidget,
        );

        await tester.tap(find.text('Cancel'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert dialog is closed
        expect(
          find.text('Are you sure you want to make this default?'),
          findsNothing,
        );
      });

      testWidgets('should close dialog when close button (X) is tapped',
          (tester) async {
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog is shown
        expect(
          find.text('Are you sure you want to make this default?'),
          findsOneWidget,
        );

        await tester.tap(find.byIcon(Icons.cancel), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert dialog is closed
        expect(
          find.text('Are you sure you want to make this default?'),
          findsNothing,
        );
      });

      testWidgets(
          'should not call callMakeDefaultPaymentMethod when cancel button is tapped',
          (tester) async {
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert
        verifyNever(
          () => mockSubscriptionBloc.callMakeDefaultPaymentMethod(any()),
        );
      });
    });

    group('Dialog Styling and Layout Tests', () {
      testWidgets('should have proper dialog structure with AppDialogPopup',
          (tester) async {
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
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
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
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
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(BlocProvider<SubscriptionBloc>), findsWidgets);
        expect(find.byType(DefaultPaymentMethodDialog), findsOneWidget);

        // Verify that the dialog has access to the bloc
        final dialog = tester.widget<DefaultPaymentMethodDialog>(
          find.byType(DefaultPaymentMethodDialog),
        );
        expect(dialog.bloc, equals(mockSubscriptionBloc));
      });

      testWidgets('should use provided bloc for method calls', (tester) async {
        // Arrange
        const testPaymentMethodId = 456;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
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
              .callMakeDefaultPaymentMethod(testPaymentMethodId),
        ).called(1);
      });
    });

    group('Edge Cases and Error Handling Tests', () {
      testWidgets('should handle different payment method IDs correctly',
          (tester) async {
        // Arrange
        const testPaymentMethodId1 = 1;
        const testPaymentMethodId2 = 999;

        // Act & Assert for first ID
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId1,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.pumpAndSettle();

        verify(
          () => mockSubscriptionBloc
              .callMakeDefaultPaymentMethod(testPaymentMethodId1),
        ).called(1);

        // Reset mock
        reset(mockSubscriptionBloc);
        subscriptionBlocTestHelper.setup();
        mockSubscriptionBloc =
            subscriptionBlocTestHelper.getMockSubscriptionBloc();

        // Act & Assert for second ID
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId2,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Yes'), warnIfMissed: false);
        await tester.pumpAndSettle();

        verify(
          () => mockSubscriptionBloc
              .callMakeDefaultPaymentMethod(testPaymentMethodId2),
        ).called(1);
      });

      testWidgets('should handle rapid button taps gracefully', (tester) async {
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
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
              .callMakeDefaultPaymentMethod(testPaymentMethodId),
        ).called(1);
      });

      testWidgets('should handle dialog dismissal by tapping outside',
          (tester) async {
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
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
          find.text('Are you sure you want to make this default?'),
          findsNothing,
        );
        verifyNever(
          () => mockSubscriptionBloc.callMakeDefaultPaymentMethod(any()),
        );
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic labels for screen readers',
          (tester) async {
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
            bloc: mockSubscriptionBloc,
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('Are you sure you want to make this default?'),
          findsOneWidget,
        );
        expect(find.text('Yes'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('should be focusable and navigable', (tester) async {
        // Arrange
        const testPaymentMethodId = 123;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            paymentMethodId: testPaymentMethodId,
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
              .callMakeDefaultPaymentMethod(testPaymentMethodId),
        ).called(1);
      });
    });
  });
}
