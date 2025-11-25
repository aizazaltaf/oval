// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionState extends SubscriptionState {
  @override
  final BuiltList<PaymentMethodsModel> paymentMethodsList;
  @override
  final BuiltList<TransactionHistoryModel> transactionHistoryList;
  @override
  final bool downloadingPDF;
  @override
  final String? transactionFilter;
  @override
  final ApiState<void> paymentMethodsApi;
  @override
  final ApiState<void> defaultPaymentMethodApi;
  @override
  final ApiState<void> deletePaymentMethodApi;
  @override
  final ApiState<void> transactionHistoryApi;
  @override
  final ApiState<void> downloadInvoiceApi;

  factory _$SubscriptionState(
          [void Function(SubscriptionStateBuilder)? updates]) =>
      (SubscriptionStateBuilder()..update(updates))._build();

  _$SubscriptionState._(
      {required this.paymentMethodsList,
      required this.transactionHistoryList,
      required this.downloadingPDF,
      this.transactionFilter,
      required this.paymentMethodsApi,
      required this.defaultPaymentMethodApi,
      required this.deletePaymentMethodApi,
      required this.transactionHistoryApi,
      required this.downloadInvoiceApi})
      : super._();
  @override
  SubscriptionState rebuild(void Function(SubscriptionStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionStateBuilder toBuilder() =>
      SubscriptionStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionState &&
        paymentMethodsList == other.paymentMethodsList &&
        transactionHistoryList == other.transactionHistoryList &&
        downloadingPDF == other.downloadingPDF &&
        transactionFilter == other.transactionFilter &&
        paymentMethodsApi == other.paymentMethodsApi &&
        defaultPaymentMethodApi == other.defaultPaymentMethodApi &&
        deletePaymentMethodApi == other.deletePaymentMethodApi &&
        transactionHistoryApi == other.transactionHistoryApi &&
        downloadInvoiceApi == other.downloadInvoiceApi;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentMethodsList.hashCode);
    _$hash = $jc(_$hash, transactionHistoryList.hashCode);
    _$hash = $jc(_$hash, downloadingPDF.hashCode);
    _$hash = $jc(_$hash, transactionFilter.hashCode);
    _$hash = $jc(_$hash, paymentMethodsApi.hashCode);
    _$hash = $jc(_$hash, defaultPaymentMethodApi.hashCode);
    _$hash = $jc(_$hash, deletePaymentMethodApi.hashCode);
    _$hash = $jc(_$hash, transactionHistoryApi.hashCode);
    _$hash = $jc(_$hash, downloadInvoiceApi.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubscriptionState')
          ..add('paymentMethodsList', paymentMethodsList)
          ..add('transactionHistoryList', transactionHistoryList)
          ..add('downloadingPDF', downloadingPDF)
          ..add('transactionFilter', transactionFilter)
          ..add('paymentMethodsApi', paymentMethodsApi)
          ..add('defaultPaymentMethodApi', defaultPaymentMethodApi)
          ..add('deletePaymentMethodApi', deletePaymentMethodApi)
          ..add('transactionHistoryApi', transactionHistoryApi)
          ..add('downloadInvoiceApi', downloadInvoiceApi))
        .toString();
  }
}

class SubscriptionStateBuilder
    implements Builder<SubscriptionState, SubscriptionStateBuilder> {
  _$SubscriptionState? _$v;

  ListBuilder<PaymentMethodsModel>? _paymentMethodsList;
  ListBuilder<PaymentMethodsModel> get paymentMethodsList =>
      _$this._paymentMethodsList ??= ListBuilder<PaymentMethodsModel>();
  set paymentMethodsList(
          ListBuilder<PaymentMethodsModel>? paymentMethodsList) =>
      _$this._paymentMethodsList = paymentMethodsList;

  ListBuilder<TransactionHistoryModel>? _transactionHistoryList;
  ListBuilder<TransactionHistoryModel> get transactionHistoryList =>
      _$this._transactionHistoryList ??= ListBuilder<TransactionHistoryModel>();
  set transactionHistoryList(
          ListBuilder<TransactionHistoryModel>? transactionHistoryList) =>
      _$this._transactionHistoryList = transactionHistoryList;

  bool? _downloadingPDF;
  bool? get downloadingPDF => _$this._downloadingPDF;
  set downloadingPDF(bool? downloadingPDF) =>
      _$this._downloadingPDF = downloadingPDF;

  String? _transactionFilter;
  String? get transactionFilter => _$this._transactionFilter;
  set transactionFilter(String? transactionFilter) =>
      _$this._transactionFilter = transactionFilter;

  ApiStateBuilder<void>? _paymentMethodsApi;
  ApiStateBuilder<void> get paymentMethodsApi =>
      _$this._paymentMethodsApi ??= ApiStateBuilder<void>();
  set paymentMethodsApi(ApiStateBuilder<void>? paymentMethodsApi) =>
      _$this._paymentMethodsApi = paymentMethodsApi;

  ApiStateBuilder<void>? _defaultPaymentMethodApi;
  ApiStateBuilder<void> get defaultPaymentMethodApi =>
      _$this._defaultPaymentMethodApi ??= ApiStateBuilder<void>();
  set defaultPaymentMethodApi(ApiStateBuilder<void>? defaultPaymentMethodApi) =>
      _$this._defaultPaymentMethodApi = defaultPaymentMethodApi;

  ApiStateBuilder<void>? _deletePaymentMethodApi;
  ApiStateBuilder<void> get deletePaymentMethodApi =>
      _$this._deletePaymentMethodApi ??= ApiStateBuilder<void>();
  set deletePaymentMethodApi(ApiStateBuilder<void>? deletePaymentMethodApi) =>
      _$this._deletePaymentMethodApi = deletePaymentMethodApi;

  ApiStateBuilder<void>? _transactionHistoryApi;
  ApiStateBuilder<void> get transactionHistoryApi =>
      _$this._transactionHistoryApi ??= ApiStateBuilder<void>();
  set transactionHistoryApi(ApiStateBuilder<void>? transactionHistoryApi) =>
      _$this._transactionHistoryApi = transactionHistoryApi;

  ApiStateBuilder<void>? _downloadInvoiceApi;
  ApiStateBuilder<void> get downloadInvoiceApi =>
      _$this._downloadInvoiceApi ??= ApiStateBuilder<void>();
  set downloadInvoiceApi(ApiStateBuilder<void>? downloadInvoiceApi) =>
      _$this._downloadInvoiceApi = downloadInvoiceApi;

  SubscriptionStateBuilder() {
    SubscriptionState._initialize(this);
  }

  SubscriptionStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentMethodsList = $v.paymentMethodsList.toBuilder();
      _transactionHistoryList = $v.transactionHistoryList.toBuilder();
      _downloadingPDF = $v.downloadingPDF;
      _transactionFilter = $v.transactionFilter;
      _paymentMethodsApi = $v.paymentMethodsApi.toBuilder();
      _defaultPaymentMethodApi = $v.defaultPaymentMethodApi.toBuilder();
      _deletePaymentMethodApi = $v.deletePaymentMethodApi.toBuilder();
      _transactionHistoryApi = $v.transactionHistoryApi.toBuilder();
      _downloadInvoiceApi = $v.downloadInvoiceApi.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriptionState other) {
    _$v = other as _$SubscriptionState;
  }

  @override
  void update(void Function(SubscriptionStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionState build() => _build();

  _$SubscriptionState _build() {
    _$SubscriptionState _$result;
    try {
      _$result = _$v ??
          _$SubscriptionState._(
            paymentMethodsList: paymentMethodsList.build(),
            transactionHistoryList: transactionHistoryList.build(),
            downloadingPDF: BuiltValueNullFieldError.checkNotNull(
                downloadingPDF, r'SubscriptionState', 'downloadingPDF'),
            transactionFilter: transactionFilter,
            paymentMethodsApi: paymentMethodsApi.build(),
            defaultPaymentMethodApi: defaultPaymentMethodApi.build(),
            deletePaymentMethodApi: deletePaymentMethodApi.build(),
            transactionHistoryApi: transactionHistoryApi.build(),
            downloadInvoiceApi: downloadInvoiceApi.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'paymentMethodsList';
        paymentMethodsList.build();
        _$failedField = 'transactionHistoryList';
        transactionHistoryList.build();

        _$failedField = 'paymentMethodsApi';
        paymentMethodsApi.build();
        _$failedField = 'defaultPaymentMethodApi';
        defaultPaymentMethodApi.build();
        _$failedField = 'deletePaymentMethodApi';
        deletePaymentMethodApi.build();
        _$failedField = 'transactionHistoryApi';
        transactionHistoryApi.build();
        _$failedField = 'downloadInvoiceApi';
        downloadInvoiceApi.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SubscriptionState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
