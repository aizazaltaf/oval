// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_code_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NotificationCodeModel> _$notificationCodeModelSerializer =
    _$NotificationCodeModelSerializer();

class _$NotificationCodeModelSerializer
    implements StructuredSerializer<NotificationCodeModel> {
  @override
  final Iterable<Type> types = const [
    NotificationCodeModel,
    _$NotificationCodeModel
  ];
  @override
  final String wireName = 'NotificationCodeModel';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, NotificationCodeModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'slug',
      serializers.serialize(object.slug, specifiedType: const FullType(String)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
      'created_at',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(String)),
      'updated_at',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(String)),
      'has_preferences',
      serializers.serialize(object.hasPreferences,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  NotificationCodeModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = NotificationCodeModelBuilder();

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
        case 'slug':
          result.slug = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
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
        case 'has_preferences':
          result.hasPreferences = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$NotificationCodeModel extends NotificationCodeModel {
  @override
  final int id;
  @override
  final String slug;
  @override
  final String title;
  @override
  final String message;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final bool hasPreferences;

  factory _$NotificationCodeModel(
          [void Function(NotificationCodeModelBuilder)? updates]) =>
      (NotificationCodeModelBuilder()..update(updates))._build();

  _$NotificationCodeModel._(
      {required this.id,
      required this.slug,
      required this.title,
      required this.message,
      required this.createdAt,
      required this.updatedAt,
      required this.hasPreferences})
      : super._();
  @override
  NotificationCodeModel rebuild(
          void Function(NotificationCodeModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationCodeModelBuilder toBuilder() =>
      NotificationCodeModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationCodeModel &&
        id == other.id &&
        slug == other.slug &&
        title == other.title &&
        message == other.message &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        hasPreferences == other.hasPreferences;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, hasPreferences.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationCodeModel')
          ..add('id', id)
          ..add('slug', slug)
          ..add('title', title)
          ..add('message', message)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('hasPreferences', hasPreferences))
        .toString();
  }
}

class NotificationCodeModelBuilder
    implements Builder<NotificationCodeModel, NotificationCodeModelBuilder> {
  _$NotificationCodeModel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  bool? _hasPreferences;
  bool? get hasPreferences => _$this._hasPreferences;
  set hasPreferences(bool? hasPreferences) =>
      _$this._hasPreferences = hasPreferences;

  NotificationCodeModelBuilder();

  NotificationCodeModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _slug = $v.slug;
      _title = $v.title;
      _message = $v.message;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _hasPreferences = $v.hasPreferences;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationCodeModel other) {
    _$v = other as _$NotificationCodeModel;
  }

  @override
  void update(void Function(NotificationCodeModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationCodeModel build() => _build();

  _$NotificationCodeModel _build() {
    final _$result = _$v ??
        _$NotificationCodeModel._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'NotificationCodeModel', 'id'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'NotificationCodeModel', 'slug'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'NotificationCodeModel', 'title'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'NotificationCodeModel', 'message'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'NotificationCodeModel', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'NotificationCodeModel', 'updatedAt'),
          hasPreferences: BuiltValueNullFieldError.checkNotNull(
              hasPreferences, r'NotificationCodeModel', 'hasPreferences'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
