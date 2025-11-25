// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_location_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SubscriptionLocationModel> _$subscriptionLocationModelSerializer =
    _$SubscriptionLocationModelSerializer();

class _$SubscriptionLocationModelSerializer
    implements StructuredSerializer<SubscriptionLocationModel> {
  @override
  final Iterable<Type> types = const [
    SubscriptionLocationModel,
    _$SubscriptionLocationModel
  ];
  @override
  final String wireName = 'SubscriptionLocationModel';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, SubscriptionLocationModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.paymentStatus;
    if (value != null) {
      result
        ..add('payment_status')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.subscriptionStatus;
    if (value != null) {
      result
        ..add('subscription_status')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.expiresAt;
    if (value != null) {
      result
        ..add('expires_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.trialEnds;
    if (value != null) {
      result
        ..add('trial_ends_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.amount;
    if (value != null) {
      result
        ..add('amount')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  SubscriptionLocationModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = SubscriptionLocationModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'payment_status':
          result.paymentStatus = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'subscription_status':
          result.subscriptionStatus = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'expires_at':
          result.expiresAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'trial_ends_at':
          result.trialEnds = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'amount':
          result.amount = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$SubscriptionLocationModel extends SubscriptionLocationModel {
  @override
  final String? name;
  @override
  final String? paymentStatus;
  @override
  final String? subscriptionStatus;
  @override
  final String? expiresAt;
  @override
  final String? trialEnds;
  @override
  final String? amount;

  factory _$SubscriptionLocationModel(
          [void Function(SubscriptionLocationModelBuilder)? updates]) =>
      (SubscriptionLocationModelBuilder()..update(updates))._build();

  _$SubscriptionLocationModel._(
      {this.name,
      this.paymentStatus,
      this.subscriptionStatus,
      this.expiresAt,
      this.trialEnds,
      this.amount})
      : super._();
  @override
  SubscriptionLocationModel rebuild(
          void Function(SubscriptionLocationModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionLocationModelBuilder toBuilder() =>
      SubscriptionLocationModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionLocationModel &&
        name == other.name &&
        paymentStatus == other.paymentStatus &&
        subscriptionStatus == other.subscriptionStatus &&
        expiresAt == other.expiresAt &&
        trialEnds == other.trialEnds &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, paymentStatus.hashCode);
    _$hash = $jc(_$hash, subscriptionStatus.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, trialEnds.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubscriptionLocationModel')
          ..add('name', name)
          ..add('paymentStatus', paymentStatus)
          ..add('subscriptionStatus', subscriptionStatus)
          ..add('expiresAt', expiresAt)
          ..add('trialEnds', trialEnds)
          ..add('amount', amount))
        .toString();
  }
}

class SubscriptionLocationModelBuilder
    implements
        Builder<SubscriptionLocationModel, SubscriptionLocationModelBuilder> {
  _$SubscriptionLocationModel? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _paymentStatus;
  String? get paymentStatus => _$this._paymentStatus;
  set paymentStatus(String? paymentStatus) =>
      _$this._paymentStatus = paymentStatus;

  String? _subscriptionStatus;
  String? get subscriptionStatus => _$this._subscriptionStatus;
  set subscriptionStatus(String? subscriptionStatus) =>
      _$this._subscriptionStatus = subscriptionStatus;

  String? _expiresAt;
  String? get expiresAt => _$this._expiresAt;
  set expiresAt(String? expiresAt) => _$this._expiresAt = expiresAt;

  String? _trialEnds;
  String? get trialEnds => _$this._trialEnds;
  set trialEnds(String? trialEnds) => _$this._trialEnds = trialEnds;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  SubscriptionLocationModelBuilder();

  SubscriptionLocationModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _paymentStatus = $v.paymentStatus;
      _subscriptionStatus = $v.subscriptionStatus;
      _expiresAt = $v.expiresAt;
      _trialEnds = $v.trialEnds;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriptionLocationModel other) {
    _$v = other as _$SubscriptionLocationModel;
  }

  @override
  void update(void Function(SubscriptionLocationModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionLocationModel build() => _build();

  _$SubscriptionLocationModel _build() {
    final _$result = _$v ??
        _$SubscriptionLocationModel._(
          name: name,
          paymentStatus: paymentStatus,
          subscriptionStatus: subscriptionStatus,
          expiresAt: expiresAt,
          trialEnds: trialEnds,
          amount: amount,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
