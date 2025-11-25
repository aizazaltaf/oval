// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_data_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ThemeDataModel> _$themeDataModelSerializer =
    _$ThemeDataModelSerializer();

class _$ThemeDataModelSerializer
    implements StructuredSerializer<ThemeDataModel> {
  @override
  final Iterable<Type> types = const [ThemeDataModel, _$ThemeDataModel];
  @override
  final String wireName = 'ThemeDataModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, ThemeDataModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'cover',
      serializers.serialize(object.cover,
          specifiedType: const FullType(String)),
      'fromCache',
      serializers.serialize(object.fromCache,
          specifiedType: const FullType(bool)),
      'thumbnail',
      serializers.serialize(object.thumbnail,
          specifiedType: const FullType(String)),
      'is_active',
      serializers.serialize(object.isActive,
          specifiedType: const FullType(int)),
      'category_id',
      serializers.serialize(object.categoryId,
          specifiedType: const FullType(int)),
      'total_likes',
      serializers.serialize(object.totalLikes,
          specifiedType: const FullType(int)),
      'media_type',
      serializers.serialize(object.mediaType,
          specifiedType: const FullType(int)),
      'user_like',
      serializers.serialize(object.userLike,
          specifiedType: const FullType(int)),
      'is_applied',
      serializers.serialize(object.isApplied,
          specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.colors;
    if (value != null) {
      result
        ..add('colors')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.userUploaded;
    if (value != null) {
      result
        ..add('user_uploaded')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.createdAt;
    if (value != null) {
      result
        ..add('created_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.locationId;
    if (value != null) {
      result
        ..add('location_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.deviceId;
    if (value != null) {
      result
        ..add('device_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ThemeDataModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ThemeDataModelBuilder();

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
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'colors':
          result.colors = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'cover':
          result.cover = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'fromCache':
          result.fromCache = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'thumbnail':
          result.thumbnail = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'user_uploaded':
          result.userUploaded = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'is_active':
          result.isActive = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'category_id':
          result.categoryId = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'location_id':
          result.locationId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'total_likes':
          result.totalLikes = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'media_type':
          result.mediaType = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'user_like':
          result.userLike = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'is_applied':
          result.isApplied = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'device_id':
          result.deviceId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$ThemeDataModel extends ThemeDataModel {
  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String? colors;
  @override
  final String cover;
  @override
  final bool fromCache;
  @override
  final String thumbnail;
  @override
  final int? userUploaded;
  @override
  final int isActive;
  @override
  final String? createdAt;
  @override
  final int categoryId;
  @override
  final int? locationId;
  @override
  final int totalLikes;
  @override
  final int mediaType;
  @override
  final int userLike;
  @override
  final bool isApplied;
  @override
  final String? deviceId;

  factory _$ThemeDataModel([void Function(ThemeDataModelBuilder)? updates]) =>
      (ThemeDataModelBuilder()..update(updates))._build();

  _$ThemeDataModel._(
      {required this.id,
      required this.title,
      required this.description,
      this.colors,
      required this.cover,
      required this.fromCache,
      required this.thumbnail,
      this.userUploaded,
      required this.isActive,
      this.createdAt,
      required this.categoryId,
      this.locationId,
      required this.totalLikes,
      required this.mediaType,
      required this.userLike,
      required this.isApplied,
      this.deviceId})
      : super._();
  @override
  ThemeDataModel rebuild(void Function(ThemeDataModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ThemeDataModelBuilder toBuilder() => ThemeDataModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ThemeDataModel &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        colors == other.colors &&
        cover == other.cover &&
        fromCache == other.fromCache &&
        thumbnail == other.thumbnail &&
        userUploaded == other.userUploaded &&
        isActive == other.isActive &&
        createdAt == other.createdAt &&
        categoryId == other.categoryId &&
        locationId == other.locationId &&
        totalLikes == other.totalLikes &&
        mediaType == other.mediaType &&
        userLike == other.userLike &&
        isApplied == other.isApplied &&
        deviceId == other.deviceId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, colors.hashCode);
    _$hash = $jc(_$hash, cover.hashCode);
    _$hash = $jc(_$hash, fromCache.hashCode);
    _$hash = $jc(_$hash, thumbnail.hashCode);
    _$hash = $jc(_$hash, userUploaded.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, totalLikes.hashCode);
    _$hash = $jc(_$hash, mediaType.hashCode);
    _$hash = $jc(_$hash, userLike.hashCode);
    _$hash = $jc(_$hash, isApplied.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ThemeDataModel')
          ..add('id', id)
          ..add('title', title)
          ..add('description', description)
          ..add('colors', colors)
          ..add('cover', cover)
          ..add('fromCache', fromCache)
          ..add('thumbnail', thumbnail)
          ..add('userUploaded', userUploaded)
          ..add('isActive', isActive)
          ..add('createdAt', createdAt)
          ..add('categoryId', categoryId)
          ..add('locationId', locationId)
          ..add('totalLikes', totalLikes)
          ..add('mediaType', mediaType)
          ..add('userLike', userLike)
          ..add('isApplied', isApplied)
          ..add('deviceId', deviceId))
        .toString();
  }
}

class ThemeDataModelBuilder
    implements Builder<ThemeDataModel, ThemeDataModelBuilder> {
  _$ThemeDataModel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _colors;
  String? get colors => _$this._colors;
  set colors(String? colors) => _$this._colors = colors;

  String? _cover;
  String? get cover => _$this._cover;
  set cover(String? cover) => _$this._cover = cover;

  bool? _fromCache;
  bool? get fromCache => _$this._fromCache;
  set fromCache(bool? fromCache) => _$this._fromCache = fromCache;

  String? _thumbnail;
  String? get thumbnail => _$this._thumbnail;
  set thumbnail(String? thumbnail) => _$this._thumbnail = thumbnail;

  int? _userUploaded;
  int? get userUploaded => _$this._userUploaded;
  set userUploaded(int? userUploaded) => _$this._userUploaded = userUploaded;

  int? _isActive;
  int? get isActive => _$this._isActive;
  set isActive(int? isActive) => _$this._isActive = isActive;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  int? _categoryId;
  int? get categoryId => _$this._categoryId;
  set categoryId(int? categoryId) => _$this._categoryId = categoryId;

  int? _locationId;
  int? get locationId => _$this._locationId;
  set locationId(int? locationId) => _$this._locationId = locationId;

  int? _totalLikes;
  int? get totalLikes => _$this._totalLikes;
  set totalLikes(int? totalLikes) => _$this._totalLikes = totalLikes;

  int? _mediaType;
  int? get mediaType => _$this._mediaType;
  set mediaType(int? mediaType) => _$this._mediaType = mediaType;

  int? _userLike;
  int? get userLike => _$this._userLike;
  set userLike(int? userLike) => _$this._userLike = userLike;

  bool? _isApplied;
  bool? get isApplied => _$this._isApplied;
  set isApplied(bool? isApplied) => _$this._isApplied = isApplied;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  ThemeDataModelBuilder() {
    ThemeDataModel._initialize(this);
  }

  ThemeDataModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _description = $v.description;
      _colors = $v.colors;
      _cover = $v.cover;
      _fromCache = $v.fromCache;
      _thumbnail = $v.thumbnail;
      _userUploaded = $v.userUploaded;
      _isActive = $v.isActive;
      _createdAt = $v.createdAt;
      _categoryId = $v.categoryId;
      _locationId = $v.locationId;
      _totalLikes = $v.totalLikes;
      _mediaType = $v.mediaType;
      _userLike = $v.userLike;
      _isApplied = $v.isApplied;
      _deviceId = $v.deviceId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ThemeDataModel other) {
    _$v = other as _$ThemeDataModel;
  }

  @override
  void update(void Function(ThemeDataModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ThemeDataModel build() => _build();

  _$ThemeDataModel _build() {
    final _$result = _$v ??
        _$ThemeDataModel._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ThemeDataModel', 'id'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'ThemeDataModel', 'title'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'ThemeDataModel', 'description'),
          colors: colors,
          cover: BuiltValueNullFieldError.checkNotNull(
              cover, r'ThemeDataModel', 'cover'),
          fromCache: BuiltValueNullFieldError.checkNotNull(
              fromCache, r'ThemeDataModel', 'fromCache'),
          thumbnail: BuiltValueNullFieldError.checkNotNull(
              thumbnail, r'ThemeDataModel', 'thumbnail'),
          userUploaded: userUploaded,
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'ThemeDataModel', 'isActive'),
          createdAt: createdAt,
          categoryId: BuiltValueNullFieldError.checkNotNull(
              categoryId, r'ThemeDataModel', 'categoryId'),
          locationId: locationId,
          totalLikes: BuiltValueNullFieldError.checkNotNull(
              totalLikes, r'ThemeDataModel', 'totalLikes'),
          mediaType: BuiltValueNullFieldError.checkNotNull(
              mediaType, r'ThemeDataModel', 'mediaType'),
          userLike: BuiltValueNullFieldError.checkNotNull(
              userLike, r'ThemeDataModel', 'userLike'),
          isApplied: BuiltValueNullFieldError.checkNotNull(
              isApplied, r'ThemeDataModel', 'isApplied'),
          deviceId: deviceId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
