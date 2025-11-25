// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<RoleModel> _$roleModelSerializer = _$RoleModelSerializer();

class _$RoleModelSerializer implements StructuredSerializer<RoleModel> {
  @override
  final Iterable<Type> types = const [RoleModel, _$RoleModel];
  @override
  final String wireName = 'RoleModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, RoleModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.description;
    if (value != null) {
      result
        ..add('description')
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
  RoleModel deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = RoleModelBuilder();

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
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
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

class _$RoleModel extends RoleModel {
  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  factory _$RoleModel([void Function(RoleModelBuilder)? updates]) =>
      (RoleModelBuilder()..update(updates))._build();

  _$RoleModel._(
      {required this.id,
      required this.name,
      this.description,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  RoleModel rebuild(void Function(RoleModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoleModelBuilder toBuilder() => RoleModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoleModel &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoleModel')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class RoleModelBuilder implements Builder<RoleModel, RoleModelBuilder> {
  _$RoleModel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  RoleModelBuilder();

  RoleModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _description = $v.description;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoleModel other) {
    _$v = other as _$RoleModel;
  }

  @override
  void update(void Function(RoleModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoleModel build() => _build();

  _$RoleModel _build() {
    final _$result = _$v ??
        _$RoleModel._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'RoleModel', 'id'),
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'RoleModel', 'name'),
          description: description,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
