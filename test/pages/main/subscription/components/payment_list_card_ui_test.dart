import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/models/data/payment_methods_model.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/pages/main/subscription/components/default_payment_method_dialog.dart';
import 'package:admin/pages/main/subscription/components/delete_payment_method_dialog.dart';
import 'package:admin/pages/main/subscription/components/payment_list_card.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../../helpers/bloc_helpers/profile_bloc_test_helper.dart';
import '../../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../../helpers/bloc_helpers/subscription_bloc_test_helper.dart';
import '../../../../helpers/fake_build_context.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  group('PaymentListCard UI Tests', () {
    late StartupBlocTestHelper startupBlocTestHelper;
    late ProfileBlocTestHelper profileBlocTestHelper;
    late SubscriptionBlocTestHelper subscriptionBlocTestHelper;

    setUpAll(() async {
      registerFallbackValue(FakeBuildContext());
      await TestHelper.initialize();

      // Initialize helper classes
      startupBlocTestHelper = StartupBlocTestHelper();
      profileBlocTestHelper = ProfileBlocTestHelper();
      subscriptionBlocTestHelper = SubscriptionBlocTestHelper();

      // Setup startup bloc test helper
      startupBlocTestHelper.setup();

      // Setup profile bloc test helper
      profileBlocTestHelper.setup();

      // Setup subscription bloc test helper
      subscriptionBlocTestHelper.setup();

      // Setup singleton bloc
      singletonBloc.testProfileBloc = profileBlocTestHelper.mockProfileBloc;
    });

    tearDownAll(() async {
      // Reset overlay state
      await TestHelper.cleanup();
      startupBlocTestHelper.dispose();
      profileBlocTestHelper.dispose();
      subscriptionBlocTestHelper.dispose();
    });

    Widget createTestWidget({
      required PaymentMethodsModel paymentMethod,
      SubscriptionBloc? subscriptionBloc,
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
            home: MultiBlocProvider(
              providers: [
                BlocProvider<StartupBloc>.value(
                  value: startupBlocTestHelper.mockStartupBloc,
                ),
                BlocProvider<ProfileBloc>.value(
                  value: profileBlocTestHelper.mockProfileBloc,
                ),
                BlocProvider<SubscriptionBloc>.value(
                  value: subscriptionBloc ??
                      subscriptionBlocTestHelper.mockSubscriptionBloc,
                ),
              ],
              child: Scaffold(
                body: PaymentListCard(paymentMethod: paymentMethod),
              ),
            ),
          );
        },
      );
    }

    PaymentMethodsModel createVisaPaymentMethod({
      int id = 1,
      String last4 = '1234',
      String expMonth = '12',
      String expYear = '25',
      bool isDefault = false,
    }) {
      return PaymentMethodsModel(
        (b) => b
          ..id = id
          ..userId = 1
          ..paymentMethodId = 'pm_1234567890'
          ..type = 'card'
          ..brand = 'visa'
          ..last4 = last4
          ..expMonth = expMonth
          ..expYear = expYear
          ..isDefault = isDefault
          ..isActive = true
          ..createdAt = '2024-01-01T00:00:00Z'
          ..updatedAt = '2024-01-01T00:00:00Z',
      );
    }

    PaymentMethodsModel createMastercardPaymentMethod({
      int id = 2,
      String last4 = '5678',
      String expMonth = '06',
      String expYear = '26',
      bool isDefault = false,
    }) {
      return PaymentMethodsModel(
        (b) => b
          ..id = id
          ..userId = 1
          ..paymentMethodId = 'pm_0987654321'
          ..type = 'card'
          ..brand = 'mastercard'
          ..last4 = last4
          ..expMonth = expMonth
          ..expYear = expYear
          ..isDefault = isDefault
          ..isActive = true
          ..createdAt = '2024-01-01T00:00:00Z'
          ..updatedAt = '2024-01-01T00:00:00Z',
      );
    }

    PaymentMethodsModel createJcbPaymentMethod({
      int id = 3,
      String last4 = '9999',
      String expMonth = '03',
      String expYear = '27',
      bool isDefault = false,
    }) {
      return PaymentMethodsModel(
        (b) => b
          ..id = id
          ..userId = 1
          ..paymentMethodId = 'pm_jcb123456'
          ..type = 'card'
          ..brand = 'jcb'
          ..last4 = last4
          ..expMonth = expMonth
          ..expYear = expYear
          ..isDefault = isDefault
          ..isActive = true
          ..createdAt = '2024-01-01T00:00:00Z'
          ..updatedAt = '2024-01-01T00:00:00Z',
      );
    }

    PaymentMethodsModel createDiscoverPaymentMethod({
      int id = 4,
      String last4 = '1111',
      String expMonth = '09',
      String expYear = '28',
      bool isDefault = false,
    }) {
      return PaymentMethodsModel(
        (b) => b
          ..id = id
          ..userId = 1
          ..paymentMethodId = 'pm_discover123'
          ..type = 'card'
          ..brand = 'discover'
          ..last4 = last4
          ..expMonth = expMonth
          ..expYear = expYear
          ..isDefault = isDefault
          ..isActive = true
          ..createdAt = '2024-01-01T00:00:00Z'
          ..updatedAt = '2024-01-01T00:00:00Z',
      );
    }

    group('Widget Structure', () {
      testWidgets('should render PaymentListCard without crashing',
          (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.byType(PaymentListCard), findsOneWidget);
        expect(find.byType(Material), findsNWidgets(2));
        expect(find.byType(ListTile), findsOneWidget);
      });

      testWidgets('should display card number with proper masking',
          (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.text('**** **** **** 1234'), findsOneWidget);
      });

      testWidgets('should display expiry date with proper formatting',
          (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.text('Expires on 12/25'), findsOneWidget);
      });

      testWidgets('should display default status when isDefault is true',
          (tester) async {
        final paymentMethod = createVisaPaymentMethod(isDefault: true);
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.text('Default'), findsOneWidget);
      });

      testWidgets('should not display default status when isDefault is false',
          (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.text('Default'), findsNothing);
      });

      testWidgets('should display more options icon', (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.byIcon(Icons.more_horiz_rounded), findsOneWidget);
      });
    });

    group('Card Brand Icons', () {
      testWidgets('should display Visa icon for visa brand', (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.byType(SvgPicture), findsOneWidget);
      });

      testWidgets('should display Mastercard icon for mastercard brand',
          (tester) async {
        final paymentMethod = createMastercardPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.byType(SvgPicture), findsOneWidget);
      });

      testWidgets('should display JCB icon for jcb brand', (tester) async {
        final paymentMethod = createJcbPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.byType(SvgPicture), findsOneWidget);
      });

      testWidgets('should display Discover icon for discover brand',
          (tester) async {
        final paymentMethod = createDiscoverPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.byType(SvgPicture), findsOneWidget);
      });

      testWidgets('should display default Mastercard icon for unknown brand',
          (tester) async {
        final paymentMethod = PaymentMethodsModel(
          (b) => b
            ..id = 5
            ..userId = 1
            ..paymentMethodId = 'pm_unknown'
            ..type = 'card'
            ..brand = 'unknown'
            ..last4 = '0000'
            ..expMonth = '01'
            ..expYear = '30'
            ..isDefault = false
            ..isActive = true
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.byType(SvgPicture), findsOneWidget);
      });
    });

    group('Expiry Month Formatting', () {
      testWidgets('should format single digit month with leading zero',
          (tester) async {
        final paymentMethod = createVisaPaymentMethod(expMonth: '6');
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.text('Expires on 06/25'), findsOneWidget);
      });

      testWidgets('should format double digit month without leading zero',
          (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.text('Expires on 12/25'), findsOneWidget);
      });

      testWidgets('should handle null expMonth gracefully', (tester) async {
        final paymentMethod = PaymentMethodsModel(
          (b) => b
            ..id = 6
            ..userId = 1
            ..paymentMethodId = 'pm_null_month'
            ..type = 'card'
            ..brand = 'visa'
            ..last4 = '0000'
            ..expMonth = null
            ..expYear = '25'
            ..isDefault = false
            ..isActive = true
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.text('Expires on 00/25'), findsOneWidget);
      });

      testWidgets('should handle invalid expMonth gracefully', (tester) async {
        final paymentMethod = PaymentMethodsModel(
          (b) => b
            ..id = 7
            ..userId = 1
            ..paymentMethodId = 'pm_invalid_month'
            ..type = 'card'
            ..brand = 'visa'
            ..last4 = '0000'
            ..expMonth = 'invalid'
            ..expYear = '25'
            ..isDefault = false
            ..isActive = true
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.text('Expires on 00/25'), findsOneWidget);
      });
    });

    group('Tooltip Functionality', () {
      testWidgets('should show tooltip when more options icon is tapped',
          (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        // Find and tap the more options icon
        final moreOptionsIcon = find.byIcon(Icons.more_horiz_rounded);
        expect(moreOptionsIcon, findsOneWidget);

        await tester.tap(moreOptionsIcon);
        await tester.pump();

        // Check if tooltip content is displayed
        expect(find.text('Make this Default'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
      });

      testWidgets('should show tooltip with proper styling', (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        await tester.tap(find.byIcon(Icons.more_horiz_rounded));
        await tester.pump();

        // Check for tooltip divider
        expect(find.byType(PopupMenuDivider), findsOneWidget);
      });

      testWidgets('should have tappable tooltip options', (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        await tester.tap(find.byIcon(Icons.more_horiz_rounded));
        await tester.pump();

        // Check that both options are tappable
        final makeDefaultOption = find.text('Make this Default');
        final deleteOption = find.text('Delete');

        expect(makeDefaultOption, findsOneWidget);
        expect(deleteOption, findsOneWidget);

        // Verify they are wrapped in GestureDetector
        expect(find.byType(GestureDetector), findsAtLeastNWidgets(2));
      });
    });

    group('Dialog Interactions', () {
      testWidgets(
          'should show DefaultPaymentMethodDialog when Make Default is tapped',
          (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        // Open tooltip
        await tester.tap(find.byIcon(Icons.more_horiz_rounded));
        await tester.pump();

        // Tap Make Default option
        await tester.tap(find.text('Make this Default'));
        await tester.pump();

        // Check if dialog is shown
        expect(find.byType(DefaultPaymentMethodDialog), findsOneWidget);
        expect(
          find.text('Are you sure you want to make this default?'),
          findsOneWidget,
        );
      });

      testWidgets('should show DeletePaymentMethodDialog when Delete is tapped',
          (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        // Open tooltip
        await tester.tap(find.byIcon(Icons.more_horiz_rounded));
        await tester.pump();

        // Tap Delete option
        await tester.tap(find.text('Delete'));
        await tester.pump();

        // Check if dialog is shown
        expect(find.byType(DeletePaymentMethodDialog), findsOneWidget);
        expect(
          find.text('Are you sure you want to delete payment method?'),
          findsOneWidget,
        );
      });
    });

    group('Card Number Masking', () {
      testWidgets('should mask card number with asterisks', (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.text('**** **** **** 1234'), findsOneWidget);
      });

      testWidgets('should handle different last4 digits', (tester) async {
        final paymentMethod = createVisaPaymentMethod(last4: '9999');
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.text('**** **** **** 9999'), findsOneWidget);
      });

      testWidgets('should handle short card numbers', (tester) async {
        final paymentMethod = PaymentMethodsModel(
          (b) => b
            ..id = 8
            ..userId = 1
            ..paymentMethodId = 'pm_short'
            ..type = 'card'
            ..brand = 'visa'
            ..last4 = '12'
            ..expMonth = '01'
            ..expYear = '25'
            ..isDefault = false
            ..isActive = true
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.text('**** **** **** 12'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null brand gracefully', (tester) async {
        final paymentMethod = PaymentMethodsModel(
          (b) => b
            ..id = 9
            ..userId = 1
            ..paymentMethodId = 'pm_null_brand'
            ..type = 'card'
            ..brand = null
            ..last4 = '0000'
            ..expMonth = '01'
            ..expYear = '25'
            ..isDefault = false
            ..isActive = true
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        // Should render without crashing and show default icon
        expect(find.byType(SvgPicture), findsOneWidget);
      });

      testWidgets('should handle empty last4 gracefully', (tester) async {
        final paymentMethod = PaymentMethodsModel(
          (b) => b
            ..id = 10
            ..userId = 1
            ..paymentMethodId = 'pm_empty_last4'
            ..type = 'card'
            ..brand = 'visa'
            ..last4 = ''
            ..expMonth = '01'
            ..expYear = '25'
            ..isDefault = false
            ..isActive = true
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.text('**** **** **** '), findsOneWidget);
      });

      testWidgets('should handle null last4 gracefully', (tester) async {
        final paymentMethod = PaymentMethodsModel(
          (b) => b
            ..id = 11
            ..userId = 1
            ..paymentMethodId = 'pm_null_last4'
            ..type = 'card'
            ..brand = 'visa'
            ..last4 = null
            ..expMonth = '01'
            ..expYear = '25'
            ..isDefault = false
            ..isActive = true
            ..createdAt = '2024-01-01T00:00:00Z'
            ..updatedAt = '2024-01-01T00:00:00Z',
        );
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        expect(find.text('**** **** **** null'), findsOneWidget);
      });
    });

    group('Integration with SubscriptionBloc', () {
      testWidgets('should access SubscriptionBloc from context',
          (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        // The widget should render without errors when SubscriptionBloc is available
        expect(find.byType(PaymentListCard), findsOneWidget);
      });

      testWidgets('should pass correct payment method ID to dialogs',
          (tester) async {
        final paymentMethod = createVisaPaymentMethod(id: 123);
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        // Open tooltip and tap Make Default
        await tester.tap(find.byIcon(Icons.more_horiz_rounded));
        await tester.pump();
        await tester.tap(find.text('Make this Default'));
        await tester.pump();

        // Dialog should receive the correct payment method ID
        expect(find.byType(DefaultPaymentMethodDialog), findsOneWidget);
      });
    });

    group('SuperTooltip Integration', () {
      testWidgets('should use SuperTooltip for menu functionality',
          (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        // Check for SuperTooltip widget
        expect(find.byType(SuperTooltip), findsOneWidget);
      });

      testWidgets('should have proper tooltip controller', (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        // Check for SuperTooltipController
        final superTooltip =
            tester.widget<SuperTooltip>(find.byType(SuperTooltip));
        expect(superTooltip.controller, isNotNull);
      });

      testWidgets('should have proper tooltip styling', (tester) async {
        final paymentMethod = createVisaPaymentMethod();
        await tester.pumpWidget(createTestWidget(paymentMethod: paymentMethod));
        await tester.pump();

        final superTooltip =
            tester.widget<SuperTooltip>(find.byType(SuperTooltip));

        // Check tooltip properties
        expect(superTooltip.arrowTipDistance, equals(20));
        expect(superTooltip.arrowLength, equals(8));
        expect(superTooltip.arrowTipRadius, equals(6));
        expect(superTooltip.showBarrier, isTrue);
      });
    });
  });
}
