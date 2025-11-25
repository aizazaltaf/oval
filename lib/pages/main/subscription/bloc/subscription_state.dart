import 'package:admin/models/data/payment_methods_model.dart';
import 'package:admin/models/data/transaction_history_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'subscription_state.g.dart';

abstract class SubscriptionState
    implements Built<SubscriptionState, SubscriptionStateBuilder> {
  factory SubscriptionState([
    final void Function(SubscriptionStateBuilder) updates,
  ]) = _$SubscriptionState;

  SubscriptionState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final SubscriptionStateBuilder b) => b
    ..downloadingPDF = false
    ..paymentMethodsList.replace([])
    ..transactionHistoryList.replace([]);

  @BlocUpdateField()
  BuiltList<PaymentMethodsModel> get paymentMethodsList;

  @BlocUpdateField()
  BuiltList<TransactionHistoryModel> get transactionHistoryList;

  @BlocUpdateField()
  bool get downloadingPDF;

  @BlocUpdateField()
  String? get transactionFilter;

  ApiState<void> get paymentMethodsApi;

  ApiState<void> get defaultPaymentMethodApi;

  ApiState<void> get deletePaymentMethodApi;

  ApiState<void> get transactionHistoryApi;

  ApiState<void> get downloadInvoiceApi;
}
