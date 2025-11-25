// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_methods_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PaymentMethodsModel> _$paymentMethodsModelSerializer =
    _$PaymentMethodsModelSerializer();

class _$PaymentMethodsModelSerializer
    implements StructuredSerializer<PaymentMethodsModel> {
  @override
  final Iterable<Type> types = const [
    PaymentMethodsModel,
    _$PaymentMethodsModel
  ];
  @override
  final String wireName = 'PaymentMethodsModel';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, PaymentMethodsModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'user_id',
      serializers.serialize(object.userId, specifiedType: const FullType(int)),
      'payment_method_id',
      serializers.serialize(object.paymentMethodId,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.type;
    if (value != null) {
      result
        ..add('type')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.brand;
    if (value != null) {
      result
        ..add('brand')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.last4;
    if (value != null) {
      result
        ..add('last4')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.expMonth;
    if (value != null) {
      result
        ..add('exp_month')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.expYear;
    if (value != null) {
      result
        ..add('exp_year')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.isDefault;
    if (value != null) {
      result
        ..add('is_default')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.isActive;
    if (value != null) {
      result
        ..add('is_active')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.walletEmailAddress;
    if (value != null) {
      result
        ..add('wallet_email_address')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.createdAt;
    if (value != null) {
      result
        ..add('created_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.updatedAt;
    if (value != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  PaymentMethodsModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PaymentMethodsModelBuilder();

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
        case 'user_id':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'payment_method_id':
          result.paymentMethodId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'brand':
          result.brand = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'last4':
          result.last4 = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'exp_month':
          result.expMonth = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'exp_year':
          result.expYear = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'is_default':
          result.isDefault = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'is_active':
          result.isActive = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'wallet_email_address':
          result.walletEmailAddress = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$PaymentMethodsModel extends PaymentMethodsModel {
  @override
  final int id;
  @override
  final int userId;
  @override
  final String paymentMethodId;
  @override
  final String? type;
  @override
  final String? brand;
  @override
  final String? last4;
  @override
  final String? expMonth;
  @override
  final String? expYear;
  @override
  final bool? isDefault;
  @override
  final bool? isActive;
  @override
  final String? walletEmailAddress;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  factory _$PaymentMethodsModel(
          [void Function(PaymentMethodsModelBuilder)? updates]) =>
      (PaymentMethodsModelBuilder()..update(updates))._build();

  _$PaymentMethodsModel._(
      {required this.id,
      required this.userId,
      required this.paymentMethodId,
      this.type,
      this.brand,
      this.last4,
      this.expMonth,
      this.expYear,
      this.isDefault,
      this.isActive,
      this.walletEmailAddress,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  PaymentMethodsModel rebuild(
          void Function(PaymentMethodsModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentMethodsModelBuilder toBuilder() =>
      PaymentMethodsModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentMethodsModel &&
        id == other.id &&
        userId == other.userId &&
        paymentMethodId == other.paymentMethodId &&
        type == other.type &&
        brand == other.brand &&
        last4 == other.last4 &&
        expMonth == other.expMonth &&
        expYear == other.expYear &&
        isDefault == other.isDefault &&
        isActive == other.isActive &&
        walletEmailAddress == other.walletEmailAddress &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, paymentMethodId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, last4.hashCode);
    _$hash = $jc(_$hash, expMonth.hashCode);
    _$hash = $jc(_$hash, expYear.hashCode);
    _$hash = $jc(_$hash, isDefault.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, walletEmailAddress.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentMethodsModel')
          ..add('id', id)
          ..add('userId', userId)
          ..add('paymentMethodId', paymentMethodId)
          ..add('type', type)
          ..add('brand', brand)
          ..add('last4', last4)
          ..add('expMonth', expMonth)
          ..add('expYear', expYear)
          ..add('isDefault', isDefault)
          ..add('isActive', isActive)
          ..add('walletEmailAddress', walletEmailAddress)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class PaymentMethodsModelBuilder
    implements Builder<PaymentMethodsModel, PaymentMethodsModelBuilder> {
  _$PaymentMethodsModel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  String? _paymentMethodId;
  String? get paymentMethodId => _$this._paymentMethodId;
  set paymentMethodId(String? paymentMethodId) =>
      _$this._paymentMethodId = paymentMethodId;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _last4;
  String? get last4 => _$this._last4;
  set last4(String? last4) => _$this._last4 = last4;

  String? _expMonth;
  String? get expMonth => _$this._expMonth;
  set expMonth(String? expMonth) => _$this._expMonth = expMonth;

  String? _expYear;
  String? get expYear => _$this._expYear;
  set expYear(String? expYear) => _$this._expYear = expYear;

  bool? _isDefault;
  bool? get isDefault => _$this._isDefault;
  set isDefault(bool? isDefault) => _$this._isDefault = isDefault;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  String? _walletEmailAddress;
  String? get walletEmailAddress => _$this._walletEmailAddress;
  set walletEmailAddress(String? walletEmailAddress) =>
      _$this._walletEmailAddress = walletEmailAddress;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  PaymentMethodsModelBuilder();

  PaymentMethodsModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _paymentMethodId = $v.paymentMethodId;
      _type = $v.type;
      _brand = $v.brand;
      _last4 = $v.last4;
      _expMonth = $v.expMonth;
      _expYear = $v.expYear;
      _isDefault = $v.isDefault;
      _isActive = $v.isActive;
      _walletEmailAddress = $v.walletEmailAddress;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentMethodsModel other) {
    _$v = other as _$PaymentMethodsModel;
  }

  @override
  void update(void Function(PaymentMethodsModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentMethodsModel build() => _build();

  _$PaymentMethodsModel _build() {
    final _$result = _$v ??
        _$PaymentMethodsModel._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'PaymentMethodsModel', 'id'),
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'PaymentMethodsModel', 'userId'),
          paymentMethodId: BuiltValueNullFieldError.checkNotNull(
              paymentMethodId, r'PaymentMethodsModel', 'paymentMethodId'),
          type: type,
          brand: brand,
          last4: last4,
          expMonth: expMonth,
          expYear: expYear,
          isDefault: isDefault,
          isActive: isActive,
          walletEmailAddress: walletEmailAddress,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
