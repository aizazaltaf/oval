// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_alert_preferences_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AiAlertPreferencesModel> _$aiAlertPreferencesModelSerializer =
    _$AiAlertPreferencesModelSerializer();

class _$AiAlertPreferencesModelSerializer
    implements StructuredSerializer<AiAlertPreferencesModel> {
  @override
  final Iterable<Type> types = const [
    AiAlertPreferencesModel,
    _$AiAlertPreferencesModel
  ];
  @override
  final String wireName = 'AiAlertPreferencesModel';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, AiAlertPreferencesModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'notification_code_id',
      serializers.serialize(object.notificationCodeId,
          specifiedType: const FullType(int)),
      'is_enabled',
      serializers.serialize(object.isEnabled,
          specifiedType: const FullType(int)),
      'notification_code',
      serializers.serialize(object.notificationCode,
          specifiedType: const FullType(NotificationCodeModel)),
    ];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.deviceId;
    if (value != null) {
      result
        ..add('device_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.doorbellId;
    if (value != null) {
      result
        ..add('doorbell_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  AiAlertPreferencesModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = AiAlertPreferencesModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'device_id':
          result.deviceId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'doorbell_id':
          result.doorbellId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'notification_code_id':
          result.notificationCodeId = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'is_enabled':
          result.isEnabled = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'notification_code':
          result.notificationCode.replace(serializers.deserialize(value,
                  specifiedType: const FullType(NotificationCodeModel))!
              as NotificationCodeModel);
          break;
      }
    }

    return result.build();
  }
}

class _$AiAlertPreferencesModel extends AiAlertPreferencesModel {
  @override
  final int? id;
  @override
  final int? deviceId;
  @override
  final int? doorbellId;
  @override
  final int notificationCodeId;
  @override
  final int isEnabled;
  @override
  final NotificationCodeModel notificationCode;

  factory _$AiAlertPreferencesModel(
          [void Function(AiAlertPreferencesModelBuilder)? updates]) =>
      (AiAlertPreferencesModelBuilder()..update(updates))._build();

  _$AiAlertPreferencesModel._(
      {this.id,
      this.deviceId,
      this.doorbellId,
      required this.notificationCodeId,
      required this.isEnabled,
      required this.notificationCode})
      : super._();
  @override
  AiAlertPreferencesModel rebuild(
          void Function(AiAlertPreferencesModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AiAlertPreferencesModelBuilder toBuilder() =>
      AiAlertPreferencesModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AiAlertPreferencesModel &&
        id == other.id &&
        deviceId == other.deviceId &&
        doorbellId == other.doorbellId &&
        notificationCodeId == other.notificationCodeId &&
        isEnabled == other.isEnabled &&
        notificationCode == other.notificationCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, doorbellId.hashCode);
    _$hash = $jc(_$hash, notificationCodeId.hashCode);
    _$hash = $jc(_$hash, isEnabled.hashCode);
    _$hash = $jc(_$hash, notificationCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AiAlertPreferencesModel')
          ..add('id', id)
          ..add('deviceId', deviceId)
          ..add('doorbellId', doorbellId)
          ..add('notificationCodeId', notificationCodeId)
          ..add('isEnabled', isEnabled)
          ..add('notificationCode', notificationCode))
        .toString();
  }
}

class AiAlertPreferencesModelBuilder
    implements
        Builder<AiAlertPreferencesModel, AiAlertPreferencesModelBuilder> {
  _$AiAlertPreferencesModel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _deviceId;
  int? get deviceId => _$this._deviceId;
  set deviceId(int? deviceId) => _$this._deviceId = deviceId;

  int? _doorbellId;
  int? get doorbellId => _$this._doorbellId;
  set doorbellId(int? doorbellId) => _$this._doorbellId = doorbellId;

  int? _notificationCodeId;
  int? get notificationCodeId => _$this._notificationCodeId;
  set notificationCodeId(int? notificationCodeId) =>
      _$this._notificationCodeId = notificationCodeId;

  int? _isEnabled;
  int? get isEnabled => _$this._isEnabled;
  set isEnabled(int? isEnabled) => _$this._isEnabled = isEnabled;

  NotificationCodeModelBuilder? _notificationCode;
  NotificationCodeModelBuilder get notificationCode =>
      _$this._notificationCode ??= NotificationCodeModelBuilder();
  set notificationCode(NotificationCodeModelBuilder? notificationCode) =>
      _$this._notificationCode = notificationCode;

  AiAlertPreferencesModelBuilder();

  AiAlertPreferencesModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _deviceId = $v.deviceId;
      _doorbellId = $v.doorbellId;
      _notificationCodeId = $v.notificationCodeId;
      _isEnabled = $v.isEnabled;
      _notificationCode = $v.notificationCode.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AiAlertPreferencesModel other) {
    _$v = other as _$AiAlertPreferencesModel;
  }

  @override
  void update(void Function(AiAlertPreferencesModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AiAlertPreferencesModel build() => _build();

  _$AiAlertPreferencesModel _build() {
    _$AiAlertPreferencesModel _$result;
    try {
      _$result = _$v ??
          _$AiAlertPreferencesModel._(
            id: id,
            deviceId: deviceId,
            doorbellId: doorbellId,
            notificationCodeId: BuiltValueNullFieldError.checkNotNull(
                notificationCodeId,
                r'AiAlertPreferencesModel',
                'notificationCodeId'),
            isEnabled: BuiltValueNullFieldError.checkNotNull(
                isEnabled, r'AiAlertPreferencesModel', 'isEnabled'),
            notificationCode: notificationCode.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'notificationCode';
        notificationCode.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AiAlertPreferencesModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
