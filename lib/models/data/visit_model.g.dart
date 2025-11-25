// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<VisitModel> _$visitModelSerializer = _$VisitModelSerializer();

class _$VisitModelSerializer implements StructuredSerializer<VisitModel> {
  @override
  final Iterable<Type> types = const [VisitModel, _$VisitModel];
  @override
  final String wireName = 'VisitModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, VisitModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'visitor_id',
      serializers.serialize(object.visitorId,
          specifiedType: const FullType(int)),
      'device_id',
      serializers.serialize(object.deviceId,
          specifiedType: const FullType(String)),
      'created_at',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(String)),
      'updated_at',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  VisitModel deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = VisitModelBuilder();

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
        case 'visitor_id':
          result.visitorId = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'device_id':
          result.deviceId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$VisitModel extends VisitModel {
  @override
  final int id;
  @override
  final int visitorId;
  @override
  final String deviceId;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  factory _$VisitModel([void Function(VisitModelBuilder)? updates]) =>
      (VisitModelBuilder()..update(updates))._build();

  _$VisitModel._(
      {required this.id,
      required this.visitorId,
      required this.deviceId,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  VisitModel rebuild(void Function(VisitModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VisitModelBuilder toBuilder() => VisitModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VisitModel &&
        id == other.id &&
        visitorId == other.visitorId &&
        deviceId == other.deviceId &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, visitorId.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VisitModel')
          ..add('id', id)
          ..add('visitorId', visitorId)
          ..add('deviceId', deviceId)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class VisitModelBuilder implements Builder<VisitModel, VisitModelBuilder> {
  _$VisitModel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _visitorId;
  int? get visitorId => _$this._visitorId;
  set visitorId(int? visitorId) => _$this._visitorId = visitorId;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  VisitModelBuilder();

  VisitModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _visitorId = $v.visitorId;
      _deviceId = $v.deviceId;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VisitModel other) {
    _$v = other as _$VisitModel;
  }

  @override
  void update(void Function(VisitModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VisitModel build() => _build();

  _$VisitModel _build() {
    final _$result = _$v ??
        _$VisitModel._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'VisitModel', 'id'),
          visitorId: BuiltValueNullFieldError.checkNotNull(
              visitorId, r'VisitModel', 'visitorId'),
          deviceId: BuiltValueNullFieldError.checkNotNull(
              deviceId, r'VisitModel', 'deviceId'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'VisitModel', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'VisitModel', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
