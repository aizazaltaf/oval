// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_history_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TransactionHistoryModel> _$transactionHistoryModelSerializer =
    _$TransactionHistoryModelSerializer();

class _$TransactionHistoryModelSerializer
    implements StructuredSerializer<TransactionHistoryModel> {
  @override
  final Iterable<Type> types = const [
    TransactionHistoryModel,
    _$TransactionHistoryModel
  ];
  @override
  final String wireName = 'TransactionHistoryModel';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, TransactionHistoryModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'subscription_id',
      serializers.serialize(object.subscriptionId,
          specifiedType: const FullType(int)),
      'plan_name',
      serializers.serialize(object.planName,
          specifiedType: const FullType(String)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(String)),
      'amount',
      serializers.serialize(object.amount,
          specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'expiry_date',
      serializers.serialize(object.expiryDate,
          specifiedType: const FullType(String)),
      'amount_deducted',
      serializers.serialize(object.amountDeducted,
          specifiedType: const FullType(String)),
      'date_time',
      serializers.serialize(object.dateTime,
          specifiedType: const FullType(String)),
      'tax_deducted',
      serializers.serialize(object.taxDeducted,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.doorbellLocations;
    if (value != null) {
      result
        ..add('location')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DoorbellLocations)));
    }
    return result;
  }

  @override
  TransactionHistoryModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = TransactionHistoryModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'subscription_id':
          result.subscriptionId = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'plan_name':
          result.planName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'amount':
          result.amount = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'expiry_date':
          result.expiryDate = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'amount_deducted':
          result.amountDeducted = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'date_time':
          result.dateTime = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'tax_deducted':
          result.taxDeducted = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'location':
          result.doorbellLocations.replace(serializers.deserialize(value,
                  specifiedType: const FullType(DoorbellLocations))!
              as DoorbellLocations);
          break;
      }
    }

    return result.build();
  }
}

class _$TransactionHistoryModel extends TransactionHistoryModel {
  @override
  final int id;
  @override
  final int subscriptionId;
  @override
  final String planName;
  @override
  final String status;
  @override
  final String amount;
  @override
  final String type;
  @override
  final String expiryDate;
  @override
  final String amountDeducted;
  @override
  final String dateTime;
  @override
  final String taxDeducted;
  @override
  final DoorbellLocations? doorbellLocations;

  factory _$TransactionHistoryModel(
          [void Function(TransactionHistoryModelBuilder)? updates]) =>
      (TransactionHistoryModelBuilder()..update(updates))._build();

  _$TransactionHistoryModel._(
      {required this.id,
      required this.subscriptionId,
      required this.planName,
      required this.status,
      required this.amount,
      required this.type,
      required this.expiryDate,
      required this.amountDeducted,
      required this.dateTime,
      required this.taxDeducted,
      this.doorbellLocations})
      : super._();
  @override
  TransactionHistoryModel rebuild(
          void Function(TransactionHistoryModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TransactionHistoryModelBuilder toBuilder() =>
      TransactionHistoryModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TransactionHistoryModel &&
        id == other.id &&
        subscriptionId == other.subscriptionId &&
        planName == other.planName &&
        status == other.status &&
        amount == other.amount &&
        type == other.type &&
        expiryDate == other.expiryDate &&
        amountDeducted == other.amountDeducted &&
        dateTime == other.dateTime &&
        taxDeducted == other.taxDeducted &&
        doorbellLocations == other.doorbellLocations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, subscriptionId.hashCode);
    _$hash = $jc(_$hash, planName.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, expiryDate.hashCode);
    _$hash = $jc(_$hash, amountDeducted.hashCode);
    _$hash = $jc(_$hash, dateTime.hashCode);
    _$hash = $jc(_$hash, taxDeducted.hashCode);
    _$hash = $jc(_$hash, doorbellLocations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TransactionHistoryModel')
          ..add('id', id)
          ..add('subscriptionId', subscriptionId)
          ..add('planName', planName)
          ..add('status', status)
          ..add('amount', amount)
          ..add('type', type)
          ..add('expiryDate', expiryDate)
          ..add('amountDeducted', amountDeducted)
          ..add('dateTime', dateTime)
          ..add('taxDeducted', taxDeducted)
          ..add('doorbellLocations', doorbellLocations))
        .toString();
  }
}

class TransactionHistoryModelBuilder
    implements
        Builder<TransactionHistoryModel, TransactionHistoryModelBuilder> {
  _$TransactionHistoryModel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _subscriptionId;
  int? get subscriptionId => _$this._subscriptionId;
  set subscriptionId(int? subscriptionId) =>
      _$this._subscriptionId = subscriptionId;

  String? _planName;
  String? get planName => _$this._planName;
  set planName(String? planName) => _$this._planName = planName;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _expiryDate;
  String? get expiryDate => _$this._expiryDate;
  set expiryDate(String? expiryDate) => _$this._expiryDate = expiryDate;

  String? _amountDeducted;
  String? get amountDeducted => _$this._amountDeducted;
  set amountDeducted(String? amountDeducted) =>
      _$this._amountDeducted = amountDeducted;

  String? _dateTime;
  String? get dateTime => _$this._dateTime;
  set dateTime(String? dateTime) => _$this._dateTime = dateTime;

  String? _taxDeducted;
  String? get taxDeducted => _$this._taxDeducted;
  set taxDeducted(String? taxDeducted) => _$this._taxDeducted = taxDeducted;

  DoorbellLocationsBuilder? _doorbellLocations;
  DoorbellLocationsBuilder get doorbellLocations =>
      _$this._doorbellLocations ??= DoorbellLocationsBuilder();
  set doorbellLocations(DoorbellLocationsBuilder? doorbellLocations) =>
      _$this._doorbellLocations = doorbellLocations;

  TransactionHistoryModelBuilder();

  TransactionHistoryModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _subscriptionId = $v.subscriptionId;
      _planName = $v.planName;
      _status = $v.status;
      _amount = $v.amount;
      _type = $v.type;
      _expiryDate = $v.expiryDate;
      _amountDeducted = $v.amountDeducted;
      _dateTime = $v.dateTime;
      _taxDeducted = $v.taxDeducted;
      _doorbellLocations = $v.doorbellLocations?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TransactionHistoryModel other) {
    _$v = other as _$TransactionHistoryModel;
  }

  @override
  void update(void Function(TransactionHistoryModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TransactionHistoryModel build() => _build();

  _$TransactionHistoryModel _build() {
    _$TransactionHistoryModel _$result;
    try {
      _$result = _$v ??
          _$TransactionHistoryModel._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'TransactionHistoryModel', 'id'),
            subscriptionId: BuiltValueNullFieldError.checkNotNull(
                subscriptionId, r'TransactionHistoryModel', 'subscriptionId'),
            planName: BuiltValueNullFieldError.checkNotNull(
                planName, r'TransactionHistoryModel', 'planName'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'TransactionHistoryModel', 'status'),
            amount: BuiltValueNullFieldError.checkNotNull(
                amount, r'TransactionHistoryModel', 'amount'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'TransactionHistoryModel', 'type'),
            expiryDate: BuiltValueNullFieldError.checkNotNull(
                expiryDate, r'TransactionHistoryModel', 'expiryDate'),
            amountDeducted: BuiltValueNullFieldError.checkNotNull(
                amountDeducted, r'TransactionHistoryModel', 'amountDeducted'),
            dateTime: BuiltValueNullFieldError.checkNotNull(
                dateTime, r'TransactionHistoryModel', 'dateTime'),
            taxDeducted: BuiltValueNullFieldError.checkNotNull(
                taxDeducted, r'TransactionHistoryModel', 'taxDeducted'),
            doorbellLocations: _doorbellLocations?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'doorbellLocations';
        _doorbellLocations?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TransactionHistoryModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
