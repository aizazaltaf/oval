// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_category_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ThemeCategoryModel> _$themeCategoryModelSerializer =
    _$ThemeCategoryModelSerializer();

class _$ThemeCategoryModelSerializer
    implements StructuredSerializer<ThemeCategoryModel> {
  @override
  final Iterable<Type> types = const [ThemeCategoryModel, _$ThemeCategoryModel];
  @override
  final String wireName = 'ThemeCategoryModel';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ThemeCategoryModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'image',
      serializers.serialize(object.image,
          specifiedType: const FullType(String)),
      'created_at',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(String)),
      'updated_at',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.isActive;
    if (value != null) {
      result
        ..add('is_active')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  ThemeCategoryModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ThemeCategoryModelBuilder();

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
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'is_active':
          result.isActive = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
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

class _$ThemeCategoryModel extends ThemeCategoryModel {
  @override
  final int id;
  @override
  final String name;
  @override
  final String image;
  @override
  final int? isActive;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  factory _$ThemeCategoryModel(
          [void Function(ThemeCategoryModelBuilder)? updates]) =>
      (ThemeCategoryModelBuilder()..update(updates))._build();

  _$ThemeCategoryModel._(
      {required this.id,
      required this.name,
      required this.image,
      this.isActive,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  ThemeCategoryModel rebuild(
          void Function(ThemeCategoryModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ThemeCategoryModelBuilder toBuilder() =>
      ThemeCategoryModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ThemeCategoryModel &&
        id == other.id &&
        name == other.name &&
        image == other.image &&
        isActive == other.isActive &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ThemeCategoryModel')
          ..add('id', id)
          ..add('name', name)
          ..add('image', image)
          ..add('isActive', isActive)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ThemeCategoryModelBuilder
    implements Builder<ThemeCategoryModel, ThemeCategoryModelBuilder> {
  _$ThemeCategoryModel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  int? _isActive;
  int? get isActive => _$this._isActive;
  set isActive(int? isActive) => _$this._isActive = isActive;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  ThemeCategoryModelBuilder();

  ThemeCategoryModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _image = $v.image;
      _isActive = $v.isActive;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ThemeCategoryModel other) {
    _$v = other as _$ThemeCategoryModel;
  }

  @override
  void update(void Function(ThemeCategoryModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ThemeCategoryModel build() => _build();

  _$ThemeCategoryModel _build() {
    final _$result = _$v ??
        _$ThemeCategoryModel._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ThemeCategoryModel', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ThemeCategoryModel', 'name'),
          image: BuiltValueNullFieldError.checkNotNull(
              image, r'ThemeCategoryModel', 'image'),
          isActive: isActive,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'ThemeCategoryModel', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'ThemeCategoryModel', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
