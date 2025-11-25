// ignore_for_file: type=lint, unused_element

part of 'subscription_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class SubscriptionBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<SubscriptionState>? buildWhen;
  final BlocWidgetBuilder<SubscriptionState> builder;

  const SubscriptionBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class SubscriptionBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<SubscriptionState, T> selector;
  final Widget Function(T state) builder;
  final SubscriptionBloc? bloc;

  const SubscriptionBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static SubscriptionBlocSelector<BuiltList<PaymentMethodsModel>>
      paymentMethodsList({
    final Key? key,
    required Widget Function(BuiltList<PaymentMethodsModel> paymentMethodsList)
        builder,
    final SubscriptionBloc? bloc,
  }) {
    return SubscriptionBlocSelector(
      key: key,
      selector: (state) => state.paymentMethodsList,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static SubscriptionBlocSelector<BuiltList<TransactionHistoryModel>>
      transactionHistoryList({
    final Key? key,
    required Widget Function(
            BuiltList<TransactionHistoryModel> transactionHistoryList)
        builder,
    final SubscriptionBloc? bloc,
  }) {
    return SubscriptionBlocSelector(
      key: key,
      selector: (state) => state.transactionHistoryList,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static SubscriptionBlocSelector<bool> downloadingPDF({
    final Key? key,
    required Widget Function(bool downloadingPDF) builder,
    final SubscriptionBloc? bloc,
  }) {
    return SubscriptionBlocSelector(
      key: key,
      selector: (state) => state.downloadingPDF,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static SubscriptionBlocSelector<String?> transactionFilter({
    final Key? key,
    required Widget Function(String? transactionFilter) builder,
    final SubscriptionBloc? bloc,
  }) {
    return SubscriptionBlocSelector(
      key: key,
      selector: (state) => state.transactionFilter,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static SubscriptionBlocSelector<ApiState<void>> paymentMethodsApi({
    final Key? key,
    required Widget Function(ApiState<void> paymentMethodsApi) builder,
    final SubscriptionBloc? bloc,
  }) {
    return SubscriptionBlocSelector(
      key: key,
      selector: (state) => state.paymentMethodsApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static SubscriptionBlocSelector<ApiState<void>> defaultPaymentMethodApi({
    final Key? key,
    required Widget Function(ApiState<void> defaultPaymentMethodApi) builder,
    final SubscriptionBloc? bloc,
  }) {
    return SubscriptionBlocSelector(
      key: key,
      selector: (state) => state.defaultPaymentMethodApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static SubscriptionBlocSelector<ApiState<void>> deletePaymentMethodApi({
    final Key? key,
    required Widget Function(ApiState<void> deletePaymentMethodApi) builder,
    final SubscriptionBloc? bloc,
  }) {
    return SubscriptionBlocSelector(
      key: key,
      selector: (state) => state.deletePaymentMethodApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static SubscriptionBlocSelector<ApiState<void>> transactionHistoryApi({
    final Key? key,
    required Widget Function(ApiState<void> transactionHistoryApi) builder,
    final SubscriptionBloc? bloc,
  }) {
    return SubscriptionBlocSelector(
      key: key,
      selector: (state) => state.transactionHistoryApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static SubscriptionBlocSelector<ApiState<void>> downloadInvoiceApi({
    final Key? key,
    required Widget Function(ApiState<void> downloadInvoiceApi) builder,
    final SubscriptionBloc? bloc,
  }) {
    return SubscriptionBlocSelector(
      key: key,
      selector: (state) => state.downloadInvoiceApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<SubscriptionBloc, SubscriptionState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _SubscriptionBlocMixin on Cubit<SubscriptionState> {
  @mustCallSuper
  void updatePaymentMethodsList(
      final BuiltList<PaymentMethodsModel> paymentMethodsList) {
    if (this.state.paymentMethodsList == paymentMethodsList) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.paymentMethodsList.replace(paymentMethodsList);
    }));

    $onUpdatePaymentMethodsList();
  }

  @protected
  void $onUpdatePaymentMethodsList() {}

  @mustCallSuper
  void updateTransactionHistoryList(
      final BuiltList<TransactionHistoryModel> transactionHistoryList) {
    if (this.state.transactionHistoryList == transactionHistoryList) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.transactionHistoryList.replace(transactionHistoryList);
    }));

    $onUpdateTransactionHistoryList();
  }

  @protected
  void $onUpdateTransactionHistoryList() {}

  @mustCallSuper
  void updateDownloadingPdf(final bool downloadingPDF) {
    if (this.state.downloadingPDF == downloadingPDF) {
      return;
    }

    emit(this.state.rebuild((final b) => b.downloadingPDF = downloadingPDF));

    $onUpdateDownloadingPdf();
  }

  @protected
  void $onUpdateDownloadingPdf() {}

  @mustCallSuper
  void updateTransactionFilter(final String? transactionFilter) {
    if (this.state.transactionFilter == transactionFilter) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.transactionFilter = transactionFilter));

    $onUpdateTransactionFilter();
  }

  @protected
  void $onUpdateTransactionFilter() {}
}
