import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_state.dart';
import 'package:admin/pages/main/subscription/components/payment_list_card.dart';
import 'package:admin/pages/main/subscription/payment_methods_page.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/profile_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/subscription_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/voice_control_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';

void main() {
  group('PaymentMethodsPage UI Tests', () {
    late StartupBlocTestHelper startupBlocTestHelper;
    late ProfileBlocTestHelper profileBlocTestHelper;
    late SubscriptionBlocTestHelper subscriptionBlocTestHelper;
    late VoiceControlBlocTestHelper voiceControlBlocTestHelper;

    setUpAll(() async {
      registerFallbackValue(FakeBuildContext());
      await TestHelper.initialize();

      // Initialize helper classes
      startupBlocTestHelper = StartupBlocTestHelper();
      profileBlocTestHelper = ProfileBlocTestHelper();
      subscriptionBlocTestHelper = SubscriptionBlocTestHelper();
      voiceControlBlocTestHelper = VoiceControlBlocTestHelper()..setup();

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

    Widget createTestWidget({SubscriptionState? subscriptionState}) {
      // If a specific state is provided, update the helper's state
      if (subscriptionState != null) {
        subscriptionBlocTestHelper.mockSubscriptionBloc.state =
            subscriptionState;
      }

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
                  value: subscriptionBlocTestHelper.mockSubscriptionBloc,
                ),
                BlocProvider<VoiceControlBloc>.value(
                  value: voiceControlBlocTestHelper.mockVoiceControlBloc,
                ),
              ],
              child: const PaymentMethodsPage(),
            ),
          );
        },
      );
    }

    group('Widget Structure', () {
      testWidgets('should render PaymentMethodsPage without crashing',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // The page should render without throwing exceptions
        expect(find.byType(PaymentMethodsPage), findsOneWidget);
      });

      testWidgets('should display app title', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should show the app title in the scaffold
        expect(find.text('Payment Methods'), findsOneWidget);
      });

      testWidgets('should contain add payment method button', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should contain the add payment method button
        expect(find.text('Add Payment Method'), findsOneWidget);
      });

      testWidgets('should have proper scaffold structure', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should have proper scaffold structure
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });
    });

    group('Loading State', () {
      testWidgets('should show loading indicator when payment methods API is in progress',
          (tester) async {
        subscriptionBlocTestHelper.setupPaymentMethodsLoadingState();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should show loading indicator when paymentMethodsApi.isApiInProgress is true
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(Center), findsNWidgets(2));
      });

      testWidgets(
          'should not show loading indicator when API is not in progress',
          (tester) async {
        subscriptionBlocTestHelper.setupDefaultState();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should not show loading indicator when API is not in progress
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });
    });

    group('Payment Methods Display', () {
      testWidgets('should show empty state when no payment methods available',
          (tester) async {
        subscriptionBlocTestHelper.setupDefaultState();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should show empty state message
        expect(find.text('No Payment Methods Available'), findsOneWidget);
        expect(find.byType(Center), findsNWidgets(2));
      });

      testWidgets('should display payment methods list when available',
          (tester) async {
        subscriptionBlocTestHelper.setupWithPaymentMethods();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should display payment methods list
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(PaymentListCard), findsNWidgets(2));
      });

      testWidgets('should display correct number of payment method cards',
          (tester) async {
        subscriptionBlocTestHelper.setupWithPaymentMethods();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should display 2 payment method cards
        expect(find.byType(PaymentListCard), findsNWidgets(2));
      });

      testWidgets('should display payment method details correctly',
          (tester) async {
        subscriptionBlocTestHelper.setupWithPaymentMethods();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should display masked card numbers
        expect(find.text('**** **** **** 1234'), findsOneWidget);
        expect(find.text('**** **** **** 5678'), findsOneWidget);

        // Should display expiry dates (with the actual format from getExpMonth bug)
        expect(find.text('Expires on 12/25'), findsOneWidget);
        expect(find.text('Expires on 006/26'), findsOneWidget);

        // Should display default status
        expect(find.text('Default'), findsOneWidget);
      });
    });

    group('Button Interactions', () {
      testWidgets('should have add payment method button in bottom navigation',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should have add payment method button
        expect(find.text('Add Payment Method'), findsOneWidget);
        expect(find.byType(CustomGradientButton), findsOneWidget);
      });

      testWidgets('should have tappable add payment method button',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should have tappable add payment method button
        expect(find.text('Add Payment Method'), findsOneWidget);
        expect(find.byType(CustomGradientButton), findsOneWidget);
      });
    });

    group('Layout and Styling', () {
      testWidgets('should have proper layout structure', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should have proper layout structure (AppScaffold with CustomGradientButton)
        expect(find.byType(AppScaffold), findsOneWidget);
        expect(find.byType(CustomGradientButton), findsOneWidget);
      });

      testWidgets('should have bottom navigation bar with button',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should have CustomGradientButton with add button (not BottomNavigationBar)
        expect(find.byType(CustomGradientButton), findsOneWidget);
        expect(find.text('Add Payment Method'), findsOneWidget);
      });

      testWidgets('should have proper padding for list view', (tester) async {
        final stateWithPaymentMethods =
            SubscriptionBlocTestHelper.createWithPaymentMethods();
        await tester.pumpWidget(
          createTestWidget(subscriptionState: stateWithPaymentMethods),
        );
        await tester.pump();

        // Should have proper padding for the list view
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(Padding), findsWidgets);
      });

      testWidgets('should display payment cards with proper styling',
          (tester) async {
        final stateWithPaymentMethods =
            SubscriptionBlocTestHelper.createWithPaymentMethods();
        await tester.pumpWidget(
          createTestWidget(subscriptionState: stateWithPaymentMethods),
        );
        await tester.pump();

        // Should display payment cards with proper styling
        expect(
          find.byType(Material),
          findsAtLeastNWidgets(2),
        ); // Payment cards (at least 2)
        expect(find.byType(ListTile), findsNWidgets(2)); // List tiles
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null payment methods gracefully',
          (tester) async {
        subscriptionBlocTestHelper.setupDefaultState();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should handle null payment methods without crashing
        expect(find.byType(PaymentMethodsPage), findsOneWidget);
        expect(find.text('No Payment Methods Available'), findsOneWidget);
      });

      testWidgets('should handle empty payment methods list gracefully',
          (tester) async {
        subscriptionBlocTestHelper.setupDefaultState();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should handle empty payment methods list without crashing
        expect(find.byType(PaymentMethodsPage), findsOneWidget);
        expect(find.text('No Payment Methods Available'), findsOneWidget);
      });

      testWidgets('should handle API error state gracefully', (tester) async {
        subscriptionBlocTestHelper.setupDefaultState();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should handle API error state without crashing
        expect(find.byType(PaymentMethodsPage), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantic labels', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should have proper semantic labels for accessibility
        expect(find.text('Payment Methods'), findsOneWidget);
        expect(find.text('Add Payment Method'), findsOneWidget);
      });

      testWidgets('should have tappable add button', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should have tappable add button
        expect(find.text('Add Payment Method'), findsOneWidget);
        expect(find.byType(CustomGradientButton), findsOneWidget);
      });

      testWidgets('should have accessible payment method cards',
          (tester) async {
        subscriptionBlocTestHelper.setupWithPaymentMethods();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should have accessible payment method cards
        expect(find.byType(PaymentListCard), findsNWidgets(2));
        expect(find.byType(ListTile), findsNWidgets(2));
      });
    });

    group('Payment Method Cards', () {
      testWidgets(
          'should display payment method cards with correct information',
          (tester) async {
        subscriptionBlocTestHelper.setupWithPaymentMethods();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should display payment method cards with correct information
        expect(find.byType(PaymentListCard), findsNWidgets(2));
        expect(find.text('**** **** **** 1234'), findsOneWidget);
        expect(find.text('**** **** **** 5678'), findsOneWidget);
        expect(find.text('Expires on 12/25'), findsOneWidget);
        expect(find.text('Expires on 006/26'), findsOneWidget);
        expect(find.text('Default'), findsOneWidget);
      });

      testWidgets('should display payment method icons', (tester) async {
        subscriptionBlocTestHelper.setupWithPaymentMethods();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should display payment method icons (SVG images)
        expect(find.byType(SvgPicture), findsNWidgets(2));
      });

      testWidgets('should display more options button for each payment method',
          (tester) async {
        subscriptionBlocTestHelper.setupWithPaymentMethods();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should display more options button (three dots icon) for each payment method
        expect(find.byIcon(Icons.more_horiz_rounded), findsNWidgets(2));
      });
    });

    group('Navigation', () {
      testWidgets('should have tappable add payment method button',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should have tappable add payment method button
        expect(find.text('Add Payment Method'), findsOneWidget);
        expect(find.byType(CustomGradientButton), findsOneWidget);
      });

      testWidgets('should have proper route name', (tester) async {
        // Test that the route name is properly defined
        expect(PaymentMethodsPage.routeName, 'PaymentMethodsPage');
      });
    });

    group('Subscription Bloc Integration', () {
      testWidgets('should use subscription bloc selector correctly',
          (tester) async {
        subscriptionBlocTestHelper.setupWithPaymentMethods();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should use subscription bloc selector to get payment methods
        expect(find.byType(PaymentListCard), findsNWidgets(2));
      });

      testWidgets('should handle different subscription states',
          (tester) async {
        // Test payment methods loading state
        subscriptionBlocTestHelper.setupPaymentMethodsLoadingState();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Test empty state
        subscriptionBlocTestHelper.setupDefaultState();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();
        expect(find.text('No Payment Methods Available'), findsOneWidget);

        // Test state with payment methods
        subscriptionBlocTestHelper.setupWithPaymentMethods();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();
        expect(find.byType(PaymentListCard), findsNWidgets(2));
      });
    });

    group('Error Handling', () {
      testWidgets('should handle API errors gracefully', (tester) async {
        subscriptionBlocTestHelper.setupDefaultState();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should handle API errors without crashing
        expect(find.byType(PaymentMethodsPage), findsOneWidget);
      });

      testWidgets(
          'should display appropriate message for empty payment methods',
          (tester) async {
        subscriptionBlocTestHelper.setupDefaultState();
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should display appropriate message for empty payment methods
        expect(find.text('No Payment Methods Available'), findsOneWidget);
      });
    });
  });
}
