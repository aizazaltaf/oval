import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/models/data/payment_methods_model.dart';
import 'package:admin/models/data/transaction_history_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/bloc/bloc_mocks.dart';
import '../fake_build_context.dart';

class SubscriptionBlocTestHelper {
  late MockSubscriptionBloc mockSubscriptionBloc;

  void setup() {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(
      PaymentMethodsModel(
        (b) => b
          ..id = 0
          ..userId = 0
          ..paymentMethodId = ""
          ..type = ""
          ..brand = ""
          ..last4 = ""
          ..expMonth = ""
          ..expYear = ""
          ..isDefault = false
          ..isActive = false
          ..createdAt = ""
          ..updatedAt = "",
      ),
    );
    registerFallbackValue(BuiltList<PaymentMethodsModel>());
    registerFallbackValue(BuiltList<TransactionHistoryModel>());
    mockSubscriptionBloc = MockSubscriptionBloc();

    // Setup default state properties first
    setupDefaultState();

    // Stub async methods to return proper Future values
    when(() => mockSubscriptionBloc.callPaymentMethods())
        .thenAnswer((_) async {});
    when(() => mockSubscriptionBloc.callOnRefreshPaymentMethods())
        .thenAnswer((_) async {});
    when(() => mockSubscriptionBloc.callMakeDefaultPaymentMethod(any()))
        .thenAnswer((_) async {});
    when(() => mockSubscriptionBloc.callDeletePaymentMethod(any()))
        .thenAnswer((_) async {});
    when(() => mockSubscriptionBloc.callTransactionHistory())
        .thenAnswer((_) async {});
    when(() => mockSubscriptionBloc.downloadInvoice(any()))
        .thenAnswer((_) async {});
    when(() => mockSubscriptionBloc.checkStoragePermission())
        .thenAnswer((_) async => true);
  }

  void setupDefaultState() {
    // Create a real state instead of mocking individual properties
    final defaultState = createDefaultState();
    mockSubscriptionBloc.state = defaultState;
  }

  void setupLoadingState() {
    // Create a real state with loading API
    final loadingState = createLoadingState();
    mockSubscriptionBloc.state = loadingState;
  }

  void setupPaymentMethodsLoadingState() {
    // Create a real state with payment methods API loading
    final loadingState = createPaymentMethodsLoadingState();
    mockSubscriptionBloc.state = loadingState;
  }

  void setupTransactionHistoryLoadingState() {
    // Create a real state with transaction history API loading
    final loadingState = createTransactionHistoryLoadingState();
    mockSubscriptionBloc.state = loadingState;
  }

  void setupDefaultPaymentMethodLoadingState() {
    // Create a real state with default payment method API loading
    final loadingState = createDefaultPaymentMethodLoadingState();
    mockSubscriptionBloc.state = loadingState;
  }

  void setupDeletePaymentMethodLoadingState() {
    // Create a real state with delete payment method API loading
    final loadingState = createDeletePaymentMethodLoadingState();
    mockSubscriptionBloc.state = loadingState;
  }

  void setupWithPaymentMethods() {
    // Create a real state with payment methods
    final stateWithPaymentMethods = createWithPaymentMethods();
    mockSubscriptionBloc.state = stateWithPaymentMethods;
  }

  void setupWithTransactionHistory() {
    // Create a real state with transaction history
    final stateWithTransactionHistory = createWithTransactionHistory();
    mockSubscriptionBloc.state = stateWithTransactionHistory;
  }

  MockSubscriptionBloc getMockSubscriptionBloc() {
    return mockSubscriptionBloc;
  }

  void dispose() {
    // No stream controller to dispose
  }

  static SubscriptionState createDefaultState() {
    return SubscriptionState(
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
  }

  static SubscriptionState createLoadingState() {
    return SubscriptionState(
      (b) => b
        ..downloadingPDF = false
        ..paymentMethodsList.replace([])
        ..transactionHistoryList.replace([])
        ..transactionFilter = null
        ..paymentMethodsApi =
            ApiState<void>((b) => b..isApiInProgress = true).toBuilder()
        ..defaultPaymentMethodApi = ApiState<void>().toBuilder()
        ..deletePaymentMethodApi = ApiState<void>().toBuilder()
        ..transactionHistoryApi =
            ApiState<void>((b) => b..isApiInProgress = true).toBuilder(),
    );
  }

  static SubscriptionState createPaymentMethodsLoadingState() {
    return SubscriptionState(
      (b) => b
        ..downloadingPDF = false
        ..paymentMethodsList.replace([])
        ..transactionHistoryList.replace([])
        ..transactionFilter = null
        ..paymentMethodsApi =
            ApiState<void>((b) => b..isApiInProgress = true).toBuilder()
        ..defaultPaymentMethodApi = ApiState<void>().toBuilder()
        ..deletePaymentMethodApi = ApiState<void>().toBuilder()
        ..transactionHistoryApi = ApiState<void>().toBuilder(),
    );
  }

  static SubscriptionState createTransactionHistoryLoadingState() {
    return SubscriptionState(
      (b) => b
        ..downloadingPDF = false
        ..paymentMethodsList.replace([])
        ..transactionHistoryList.replace([])
        ..transactionFilter = null
        ..paymentMethodsApi = ApiState<void>().toBuilder()
        ..defaultPaymentMethodApi = ApiState<void>().toBuilder()
        ..deletePaymentMethodApi = ApiState<void>().toBuilder()
        ..transactionHistoryApi =
            ApiState<void>((b) => b..isApiInProgress = true).toBuilder(),
    );
  }

  static SubscriptionState createDefaultPaymentMethodLoadingState() {
    return SubscriptionState(
      (b) => b
        ..downloadingPDF = false
        ..paymentMethodsList.replace([])
        ..transactionHistoryList.replace([])
        ..transactionFilter = null
        ..paymentMethodsApi = ApiState<void>().toBuilder()
        ..defaultPaymentMethodApi =
            ApiState<void>((b) => b..isApiInProgress = true).toBuilder()
        ..deletePaymentMethodApi = ApiState<void>().toBuilder()
        ..transactionHistoryApi = ApiState<void>().toBuilder(),
    );
  }

  static SubscriptionState createDeletePaymentMethodLoadingState() {
    return SubscriptionState(
      (b) => b
        ..downloadingPDF = false
        ..paymentMethodsList.replace([])
        ..transactionHistoryList.replace([])
        ..transactionFilter = null
        ..paymentMethodsApi = ApiState<void>().toBuilder()
        ..defaultPaymentMethodApi = ApiState<void>().toBuilder()
        ..deletePaymentMethodApi =
            ApiState<void>((b) => b..isApiInProgress = true).toBuilder()
        ..transactionHistoryApi = ApiState<void>().toBuilder(),
    );
  }

  static SubscriptionState createWithPaymentMethods() {
    return SubscriptionState(
      (b) => b
        ..downloadingPDF = false
        ..paymentMethodsList.replace(_createDefaultPaymentMethods())
        ..transactionHistoryList.replace([])
        ..transactionFilter = null
        ..paymentMethodsApi = ApiState<void>().toBuilder()
        ..defaultPaymentMethodApi = ApiState<void>().toBuilder()
        ..deletePaymentMethodApi = ApiState<void>().toBuilder()
        ..transactionHistoryApi = ApiState<void>().toBuilder(),
    );
  }

  static SubscriptionState createWithTransactionHistory() {
    return SubscriptionState(
      (b) => b
        ..downloadingPDF = false
        ..paymentMethodsList.replace([])
        ..transactionHistoryList.replace(_createDefaultTransactionHistory())
        ..transactionFilter = null
        ..paymentMethodsApi = ApiState<void>().toBuilder()
        ..defaultPaymentMethodApi = ApiState<void>().toBuilder()
        ..deletePaymentMethodApi = ApiState<void>().toBuilder()
        ..transactionHistoryApi = ApiState<void>().toBuilder(),
    );
  }

  static BuiltList<PaymentMethodsModel> _createDefaultPaymentMethods() {
    return BuiltList<PaymentMethodsModel>([
      PaymentMethodsModel(
        (b) => b
          ..id = 1
          ..userId = 1
          ..paymentMethodId = 'pm_1234567890'
          ..type = 'card'
          ..brand = 'visa'
          ..last4 = '1234'
          ..expMonth = '12'
          ..expYear = '25'
          ..isDefault = true
          ..isActive = true
          ..createdAt = '2024-01-01T00:00:00Z'
          ..updatedAt = '2024-01-01T00:00:00Z',
      ),
      PaymentMethodsModel(
        (b) => b
          ..id = 2
          ..userId = 1
          ..paymentMethodId = 'pm_0987654321'
          ..type = 'card'
          ..brand = 'mastercard'
          ..last4 = '5678'
          ..expMonth = '06'
          ..expYear = '26'
          ..isDefault = false
          ..isActive = true
          ..createdAt = '2024-01-01T00:00:00Z'
          ..updatedAt = '2024-01-01T00:00:00Z',
      ),
    ]);
  }

  static BuiltList<TransactionHistoryModel> _createDefaultTransactionHistory() {
    return BuiltList<TransactionHistoryModel>([
      TransactionHistoryModel(
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
      ),
      TransactionHistoryModel(
        (b) => b
          ..id = 2
          ..subscriptionId = 2
          ..planName = 'Guard Basic Monthly Subscription'
          ..status = 'success'
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
      ),
    ]);
  }
}
