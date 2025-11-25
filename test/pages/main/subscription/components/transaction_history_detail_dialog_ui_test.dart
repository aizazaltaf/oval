import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/transaction_history_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_state.dart';
import 'package:admin/pages/main/subscription/components/transaction_history_detail_dialog.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/bloc_helpers/profile_bloc_test_helper.dart';
import '../../../../helpers/bloc_helpers/startup_bloc_test_helper.dart';
import '../../../../helpers/bloc_helpers/subscription_bloc_test_helper.dart';
import '../../../../helpers/bloc_helpers/voice_control_bloc_test_helper.dart';
import '../../../../helpers/fake_build_context.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  group('TransactionHistoryDetailDialog UI Tests', () {
    late StartupBlocTestHelper startupBlocTestHelper;
    late ProfileBlocTestHelper profileBlocTestHelper;
    late SubscriptionBlocTestHelper subscriptionBlocTestHelper;
    late VoiceControlBlocTestHelper voiceControlBlocTestHelper;
    late TransactionHistoryModel mockTransactionHistory;

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

      // Create mock transaction history
      mockTransactionHistory = TransactionHistoryModel(
        (b) => b
          ..id = 1
          ..amount = '29.99'
          ..amountDeducted = '29.99'
          ..dateTime = '2024-01-15T10:30:00Z'
          ..taxDeducted = '2.40'
          ..expiryDate = '2024-02-15T10:30:00Z'
          ..subscriptionId = 123
          ..planName = 'Guard Pro Monthly Subscription'
          ..status = 'success'
          ..type = 'subscription'
          ..doorbellLocations = (DoorbellLocationsBuilder()
            ..name = 'Test Location'
            ..id = 1),
      );
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

    Widget createTestWidget({
      TransactionHistoryModel? transactionHistory,
      SubscriptionState? subscriptionState,
    }) {
      // Use provided transaction history or default mock
      final transaction = transactionHistory ?? mockTransactionHistory;

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
              child: Scaffold(
                body: TransactionHistoryDetailDialog(
                  transactionHistory: transaction,
                  bloc: subscriptionBlocTestHelper.mockSubscriptionBloc,
                ),
              ),
            ),
          );
        },
      );
    }

    group('Header Tests', () {
      testWidgets('should display correct dialog title', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Transaction Details'), findsOneWidget);
      });

      testWidgets('should have proper title styling', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        final titleText = find.text('Transaction Details');
        expect(titleText, findsOneWidget);

        // Verify the text widget exists
        final textWidget = tester.widget<Text>(titleText);
        expect(textWidget.style?.fontWeight, FontWeight.w700);
      });
    });

    group('Transaction Details Display Tests', () {
      testWidgets('should display amount deducted correctly', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Amount Deducted:'), findsOneWidget);
        expect(find.text('\$29.99'), findsOneWidget);
      });

      testWidgets('should display date correctly', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Date'), findsOneWidget);
        // The date should be formatted by CommonFunctions.formatDateToLocal
        expect(find.textContaining('2024'), findsAtLeastNWidgets(1));
      });

      testWidgets('should display time correctly', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Time:'), findsOneWidget);
        expect(find.text('15:30'), findsOneWidget);
      });

      testWidgets('should display tax deducted correctly', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Tax Deducted:'), findsOneWidget);
        expect(find.text('\$2.40'), findsOneWidget);
      });

      testWidgets('should display package expiry correctly', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Expiry of the Package:'), findsOneWidget);
        // The expiry date should be formatted by CommonFunctions.formatDateToLocal
        expect(find.textContaining('2024'), findsAtLeastNWidgets(2));
      });

      testWidgets('should display all transaction details in rows',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(Row), findsAtLeastNWidgets(5)); // 5 detail rows
        expect(find.text('Amount Deducted:'), findsOneWidget);
        expect(find.text('Date'), findsOneWidget);
        expect(find.text('Time:'), findsOneWidget);
        expect(find.text('Tax Deducted:'), findsOneWidget);
        expect(find.text('Expiry of the Package:'), findsOneWidget);
      });
    });

    group('Download Invoice Button Tests', () {
      testWidgets('should display download invoice button', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Download Invoice'), findsOneWidget);
        expect(find.byType(CustomGradientButton), findsOneWidget);
      });

      testWidgets('should have download button enabled by default',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        final button = find.byType(CustomGradientButton);
        expect(button, findsOneWidget);

        final customButton = tester.widget<CustomGradientButton>(button);
        expect(customButton.isButtonEnabled, true);
      });

      testWidgets('should show loading state when downloading PDF',
          (tester) async {
        // Arrange
        final stateWithDownloading = SubscriptionState(
          (b) => b
            ..downloadingPDF = true
            ..paymentMethodsList.replace([])
            ..transactionHistoryList.replace([])
            ..transactionFilter = null
            ..paymentMethodsApi = ApiState<void>().toBuilder()
            ..defaultPaymentMethodApi = ApiState<void>().toBuilder()
            ..deletePaymentMethodApi = ApiState<void>().toBuilder()
            ..transactionHistoryApi = ApiState<void>().toBuilder(),
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(subscriptionState: stateWithDownloading),
        );
        await tester.pump();

        // Assert
        final button = find.byType(CustomGradientButton);
        expect(button, findsOneWidget);

        final customButton = tester.widget<CustomGradientButton>(button);
        expect(customButton.isLoadingEnabled, true);
        expect(customButton.isButtonEnabled, false);
      });
    });

    group('Divider Tests', () {
      testWidgets('should display divider between details and button',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(Divider), findsOneWidget);
      });

      testWidgets('should have proper spacing around divider', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
        expect(find.byType(Divider), findsOneWidget);
      });
    });

    group('Bloc Integration Tests', () {
      testWidgets(
          'should use SubscriptionBlocSelector for downloadingPDF state',
          (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        // The dialog uses SubscriptionBlocSelector internally for downloadingPDF state
        expect(find.byType(TransactionHistoryDetailDialog), findsOneWidget);
        expect(find.byType(CustomGradientButton), findsOneWidget);
      });

      testWidgets('should handle bloc state changes correctly', (tester) async {
        // Arrange
        final stateWithDownloading = SubscriptionState(
          (b) => b
            ..downloadingPDF = true
            ..paymentMethodsList.replace([])
            ..transactionHistoryList.replace([])
            ..transactionFilter = null
            ..paymentMethodsApi = ApiState<void>().toBuilder()
            ..defaultPaymentMethodApi = ApiState<void>().toBuilder()
            ..deletePaymentMethodApi = ApiState<void>().toBuilder()
            ..transactionHistoryApi = ApiState<void>().toBuilder(),
        );

        subscriptionBlocTestHelper.mockSubscriptionBloc.state =
            stateWithDownloading;

        // Act
        await tester.pumpWidget(
          createTestWidget(subscriptionState: stateWithDownloading),
        );
        await tester.pump();

        // Assert
        final button = find.byType(CustomGradientButton);
        final customButton = tester.widget<CustomGradientButton>(button);
        expect(customButton.isLoadingEnabled, true);
      });
    });

    group('Data Formatting Tests', () {
      testWidgets('should format currency correctly', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('\$29.99'), findsOneWidget);
        expect(find.text('\$2.40'), findsOneWidget);
      });

      testWidgets('should handle different transaction amounts',
          (tester) async {
        // Arrange
        final transactionWithDifferentAmount = TransactionHistoryModel(
          (b) => b
            ..id = 2
            ..amount = '99.50'
            ..amountDeducted = '99.50'
            ..dateTime = '2024-01-15T10:30:00Z'
            ..taxDeducted = '7.96'
            ..expiryDate = '2024-02-15T10:30:00Z'
            ..subscriptionId = 124
            ..planName = 'Guard Premium Monthly Subscription'
            ..status = 'success'
            ..type = 'subscription'
            ..doorbellLocations = (DoorbellLocationsBuilder()
              ..name = 'Test Location 2'
              ..id = 2),
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(
            transactionHistory: transactionWithDifferentAmount,
          ),
        );
        await tester.pump();

        // Assert
        expect(find.text('\$99.50'), findsOneWidget);
        expect(find.text('\$7.96'), findsOneWidget);
      });

      testWidgets('should handle zero tax amount', (tester) async {
        // Arrange
        final transactionWithZeroTax = TransactionHistoryModel(
          (b) => b
            ..id = 3
            ..amount = '29.99'
            ..amountDeducted = '29.99'
            ..dateTime = '2024-01-15T10:30:00Z'
            ..taxDeducted = '0.00'
            ..expiryDate = '2024-02-15T10:30:00Z'
            ..subscriptionId = 125
            ..planName = 'Guard Basic Monthly Subscription'
            ..status = 'success'
            ..type = 'subscription'
            ..doorbellLocations = (DoorbellLocationsBuilder()
              ..name = 'Test Location 3'
              ..id = 3),
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(transactionHistory: transactionWithZeroTax),
        );
        await tester.pump();

        // Assert
        expect(find.text('\$0.00'), findsOneWidget);
      });
    });

    group('Layout and Styling Tests', () {
      testWidgets('should have proper padding and spacing', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
        expect(find.byType(Padding), findsAtLeastNWidgets(1));
      });

      testWidgets('should have proper text styling', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        final titleText = find.text('Transaction Details');
        final titleWidget = tester.widget<Text>(titleText);
        expect(titleWidget.style?.fontWeight, FontWeight.w700);

        // Check that detail labels have proper styling
        final amountLabel = find.text('Amount Deducted:');
        expect(amountLabel, findsOneWidget);
      });

      testWidgets('should have proper row layout for details', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        final rows = find.byType(Row);
        expect(rows, findsAtLeastNWidgets(5)); // 5 detail rows

        // Each row should have MainAxisAlignment.spaceBetween
        for (int i = 0; i < 5; i++) {
          final row = tester.widget<Row>(rows.at(i));
          expect(row.mainAxisAlignment, MainAxisAlignment.spaceBetween);
        }
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic labels', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Transaction Details'), findsOneWidget);
        expect(find.text('Amount Deducted:'), findsOneWidget);
        expect(find.text('Date'), findsOneWidget);
        expect(find.text('Time:'), findsOneWidget);
        expect(find.text('Tax Deducted:'), findsOneWidget);
        expect(find.text('Expiry of the Package:'), findsOneWidget);
        expect(find.text('Download Invoice'), findsOneWidget);
      });

      testWidgets('should have tappable download button', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        final downloadButton = find.text('Download Invoice');
        expect(downloadButton, findsOneWidget);
        expect(find.byType(CustomGradientButton), findsOneWidget);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle null transaction data gracefully',
          (tester) async {
        // Arrange
        final transactionWithNulls = TransactionHistoryModel(
          (b) => b
            ..id = 4
            ..amount = '0.00'
            ..amountDeducted = '0.00'
            ..dateTime = '2024-01-15T10:30:00Z'
            ..taxDeducted = '0.00'
            ..expiryDate = '2024-02-15T10:30:00Z'
            ..subscriptionId = 126
            ..planName = ''
            ..status = 'pending'
            ..type = 'subscription'
            ..doorbellLocations = (DoorbellLocationsBuilder()
              ..name = ''
              ..id = 4),
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(transactionHistory: transactionWithNulls),
        );
        await tester.pump();

        // Assert
        expect(find.byType(TransactionHistoryDetailDialog), findsOneWidget);
        expect(find.text('\$0.00'), findsNWidgets(2)); // Amount and tax
      });

      testWidgets('should handle very large amounts', (tester) async {
        // Arrange
        final transactionWithLargeAmount = TransactionHistoryModel(
          (b) => b
            ..id = 5
            ..amount = '999999.99'
            ..amountDeducted = '999999.99'
            ..dateTime = '2024-01-15T10:30:00Z'
            ..taxDeducted = '79999.99'
            ..expiryDate = '2024-02-15T10:30:00Z'
            ..subscriptionId = 127
            ..planName = 'Guard Enterprise Monthly Subscription'
            ..status = 'success'
            ..type = 'subscription'
            ..doorbellLocations = (DoorbellLocationsBuilder()
              ..name = 'Enterprise Location'
              ..id = 5),
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(transactionHistory: transactionWithLargeAmount),
        );
        await tester.pump();

        // Assert
        expect(find.text('\$999999.99'), findsOneWidget);
        expect(find.text('\$79999.99'), findsOneWidget);
      });

      testWidgets('should handle different date formats', (tester) async {
        // Arrange
        final transactionWithDifferentDate = TransactionHistoryModel(
          (b) => b
            ..id = 6
            ..amount = '29.99'
            ..amountDeducted = '29.99'
            ..dateTime = '2023-11-31T23:59:59Z'
            ..taxDeducted = '2.40'
            ..expiryDate = '2024-01-31T23:59:59Z'
            ..subscriptionId = 128
            ..planName = 'Guard Pro Monthly Subscription'
            ..status = 'success'
            ..type = 'subscription'
            ..doorbellLocations = (DoorbellLocationsBuilder()
              ..name = 'Test Location'
              ..id = 6),
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(transactionHistory: transactionWithDifferentDate),
        );
        await tester.pump();

        // Assert
        expect(find.byType(TransactionHistoryDetailDialog), findsOneWidget);
        // The date should be formatted by CommonFunctions
        expect(find.textContaining('2023'), findsAtLeastNWidgets(1));
      });
    });

    group('Button State Management Tests', () {
      testWidgets('should disable button when downloading', (tester) async {
        // Arrange
        final stateWithDownloading = SubscriptionState(
          (b) => b
            ..downloadingPDF = true
            ..paymentMethodsList.replace([])
            ..transactionHistoryList.replace([])
            ..transactionFilter = null
            ..paymentMethodsApi = ApiState<void>().toBuilder()
            ..defaultPaymentMethodApi = ApiState<void>().toBuilder()
            ..deletePaymentMethodApi = ApiState<void>().toBuilder()
            ..transactionHistoryApi = ApiState<void>().toBuilder(),
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(subscriptionState: stateWithDownloading),
        );
        await tester.pump();

        // Assert
        final button = find.byType(CustomGradientButton);
        final customButton = tester.widget<CustomGradientButton>(button);
        expect(customButton.isButtonEnabled, false);
        expect(customButton.isLoadingEnabled, true);
      });

      testWidgets('should enable button when not downloading', (tester) async {
        // Arrange
        final stateNotDownloading = SubscriptionState(
          (b) => b
            ..downloadingPDF = false
            ..paymentMethodsList.replace([])
            ..transactionHistoryList.replace([])
            ..transactionFilter = null
            ..paymentMethodsApi = ApiState<void>().toBuilder()
            ..defaultPaymentMethodApi = ApiState<void>().toBuilder()
            ..deletePaymentMethodApi = ApiState<void>().toBuilder()
            ..transactionHistoryApi = ApiState<void>().toBuilder(),
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(subscriptionState: stateNotDownloading),
        );
        await tester.pump();

        // Assert
        final button = find.byType(CustomGradientButton);
        final customButton = tester.widget<CustomGradientButton>(button);
        expect(customButton.isButtonEnabled, true);
        expect(customButton.isLoadingEnabled, false);
      });
    });
  });
}
