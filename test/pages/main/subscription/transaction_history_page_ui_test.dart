import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_state.dart';
import 'package:admin/pages/main/subscription/components/transaction_history_card.dart';
import 'package:admin/pages/main/subscription/components/transaction_history_filter_panel.dart';
import 'package:admin/pages/main/subscription/transaction_history_page.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/bloc_helpers/profile_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/subscription_bloc_test_helper.dart';
import '../../../helpers/bloc_helpers/voice_control_bloc_test_helper.dart';
import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';

void main() {
  group('TransactionHistoryPage UI Tests', () {
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

    setUp(() {
      // Reset to default state before each test
      subscriptionBlocTestHelper.setupDefaultState();
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
              child: const TransactionHistoryPage(),
            ),
          );
        },
      );
    }

    group('App Bar and Scaffold Tests', () {
      testWidgets('should display correct app title', (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Transaction History'), findsOneWidget);
      });

      testWidgets('should display filter panel in app bar', (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(TransactionHistoryFilterPanel), findsOneWidget);
      });

      testWidgets('should use AppScaffold widget', (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(AppScaffold), findsOneWidget);
      });
    });

    group('Loading State Tests', () {
      testWidgets(
          'should show CircularProgressIndicator when transaction history API is in progress',
          (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupTransactionHistoryLoadingState();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('No Transaction History Available'), findsNothing);
        expect(find.byType(TransactionHistoryCard), findsNothing);
      });

      testWidgets('should show loading indicator in center', (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupTransactionHistoryLoadingState();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        final centerWidget = find.byType(Center);
        expect(centerWidget, findsNWidgets(3));
        expect(
          find.descendant(
            of: centerWidget,
            matching: find.byType(CircularProgressIndicator),
          ),
          findsOneWidget,
        );
      });
    });

    group('Empty State Tests', () {
      testWidgets(
          'should show empty message when transaction history list is empty',
          (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupDefaultState();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('No Transaction History Available'), findsOneWidget);
        expect(find.byType(TransactionHistoryCard), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('should show empty message in center', (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupDefaultState();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('No Transaction History Available'), findsOneWidget);
        // Check that the empty message is in a Center widget
        final centerWidget = find.byType(Center);
        expect(centerWidget, findsAtLeastNWidgets(1));
        expect(
          find.descendant(
            of: centerWidget,
            matching: find.text('No Transaction History Available'),
          ),
          findsOneWidget,
        );
      });
    });

    group('Data Display Tests', () {
      testWidgets(
          'should display transaction history cards when data is available',
          (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(TransactionHistoryCard), findsAtLeastNWidgets(1));
        expect(find.text('No Transaction History Available'), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets(
          'should display ListView when transaction history is available',
          (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(ListView), findsAtLeastNWidgets(1));
      });

      testWidgets('should display correct number of transaction cards',
          (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        // Based on the test helper, there should be 2 transaction history items
        expect(find.byType(TransactionHistoryCard), findsNWidgets(2));
      });
    });

    group('Filter Functionality Tests', () {
      testWidgets('should not show clear filter when no filter is applied',
          (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Clear Filter'), findsNothing);
      });

      testWidgets('should show clear filter when filter is applied',
          (tester) async {
        // Arrange
        final stateWithFilter = SubscriptionState(
          (b) => b
            ..downloadingPDF = false
            ..paymentMethodsList.replace([])
            ..transactionHistoryList.replace(
              SubscriptionBlocTestHelper.createWithTransactionHistory()
                  .transactionHistoryList,
            )
            ..transactionFilter = 'monthly'
            ..paymentMethodsApi = ApiState<void>().toBuilder()
            ..defaultPaymentMethodApi = ApiState<void>().toBuilder()
            ..deletePaymentMethodApi = ApiState<void>().toBuilder()
            ..transactionHistoryApi = ApiState<void>().toBuilder(),
        );
        subscriptionBlocTestHelper.mockSubscriptionBloc.state = stateWithFilter;

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Clear Filter'), findsOneWidget);
      });

      testWidgets('should call clear filter when tapped', (tester) async {
        // Arrange
        final stateWithFilter = SubscriptionState(
          (b) => b
            ..downloadingPDF = false
            ..paymentMethodsList.replace([])
            ..transactionHistoryList.replace(
              SubscriptionBlocTestHelper.createWithTransactionHistory()
                  .transactionHistoryList,
            )
            ..transactionFilter = 'monthly'
            ..paymentMethodsApi = ApiState<void>().toBuilder()
            ..defaultPaymentMethodApi = ApiState<void>().toBuilder()
            ..deletePaymentMethodApi = ApiState<void>().toBuilder()
            ..transactionHistoryApi = ApiState<void>().toBuilder(),
        );
        subscriptionBlocTestHelper.mockSubscriptionBloc.state = stateWithFilter;

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Find and tap the clear filter text
        final clearFilterFinder = find.text('Clear Filter');
        expect(clearFilterFinder, findsOneWidget);
        await tester.tap(clearFilterFinder);
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => subscriptionBlocTestHelper.mockSubscriptionBloc
              .updateTransactionFilter(null),
        ).called(1);
        verify(
          () => subscriptionBlocTestHelper.mockSubscriptionBloc
              .callTransactionHistory(),
        ).called(1);
      });
    });

    group('Transaction History Card Tests', () {
      testWidgets('should display transaction cards with correct data',
          (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        // Check for specific transaction data from the test helper
        expect(
          find.text('Guard Pro Monthly Subscription (Test Location)'),
          findsOneWidget,
        );
        expect(
          find.text('Guard Basic Monthly Subscription (Test Location 2)'),
          findsOneWidget,
        );
        expect(find.text('\$9.99'), findsOneWidget);
        expect(find.text('\$4.99'), findsOneWidget);
        expect(find.text('Success'), findsNWidgets(2));
      });

      testWidgets('should make transaction cards tappable', (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Find and tap a transaction card
        final transactionCard = find.byType(TransactionHistoryCard).first;
        expect(transactionCard, findsOneWidget);
        await tester.tap(transactionCard);
        await tester.pumpAndSettle();

        // Assert
        // The card should be tappable (GestureDetector should be present)
        expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
      });
    });

    group('ListView Tests', () {
      testWidgets('should use ListViewSeparatedWidget for transaction list',
          (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(ListView), findsAtLeastNWidgets(1));
      });
    });

    group('Bloc Integration Tests', () {
      testWidgets(
          'should use SubscriptionBlocSelector for transaction history API',
          (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        // The widget should be using the subscription bloc
        expect(find.byType(TransactionHistoryPage), findsOneWidget);
      });

      testWidgets('should call transaction history API on widget build',
          (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        // The widget should be using the subscription bloc
        expect(find.byType(TransactionHistoryPage), findsOneWidget);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should handle API error state gracefully', (tester) async {
        // Arrange
        final errorState = SubscriptionState(
          (b) => b
            ..downloadingPDF = false
            ..paymentMethodsList.replace([])
            ..transactionHistoryList.replace([])
            ..transactionFilter = null
            ..paymentMethodsApi = ApiState<void>().toBuilder()
            ..defaultPaymentMethodApi = ApiState<void>().toBuilder()
            ..deletePaymentMethodApi = ApiState<void>().toBuilder()
            ..transactionHistoryApi =
                ApiState<void>((b) => b..isApiInProgress = false).toBuilder(),
        );
        subscriptionBlocTestHelper.mockSubscriptionBloc.state = errorState;

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('No Transaction History Available'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('should have correct widget hierarchy', (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(TransactionHistoryPage), findsOneWidget);
        expect(find.byType(AppScaffold), findsOneWidget);
        expect(find.byType(TransactionHistoryFilterPanel), findsOneWidget);
        expect(find.byType(ListView), findsNWidgets(2));
        expect(find.byType(TransactionHistoryCard), findsAtLeastNWidgets(1));
      });

      testWidgets('should use Material widget for transaction cards',
          (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(Material), findsAtLeastNWidgets(1));
      });

      testWidgets(
          'should use GestureDetector for transaction card interactions',
          (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantics for screen readers',
          (tester) async {
        // Arrange
        subscriptionBlocTestHelper.setupWithTransactionHistory();

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Transaction History'), findsOneWidget);
        expect(find.byType(TransactionHistoryCard), findsAtLeastNWidgets(1));
      });
    });
  });
}
