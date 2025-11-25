// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitors_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<VisitorsModel> _$visitorsModelSerializer =
    _$VisitorsModelSerializer();

class _$VisitorsModelSerializer implements StructuredSerializer<VisitorsModel> {
  @override
  final Iterable<Type> types = const [VisitorsModel, _$VisitorsModel];
  @override
  final String wireName = 'VisitorsModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, VisitorsModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'is_wanted',
      serializers.serialize(object.isWanted,
          specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.uniqueId;
    if (value != null) {
      result
        ..add('unique_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.imageUrl;
    if (value != null) {
      result
        ..add('image')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.locationId;
    if (value != null) {
      result
        ..add('location_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.lastVisit;
    if (value != null) {
      result
        ..add('last_visit')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.faceCoordinate;
    if (value != null) {
      result
        ..add('face_coordinate')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  VisitorsModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = VisitorsModelBuilder();

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
        case 'unique_id':
          result.uniqueId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'image':
          result.imageUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'is_wanted':
          result.isWanted = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'location_id':
          result.locationId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'last_visit':
          result.lastVisit = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'face_coordinate':
          result.faceCoordinate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$VisitorsModel extends VisitorsModel {
  @override
  final int id;
  @override
  final String? uniqueId;
  @override
  final String name;
  @override
  final String? imageUrl;
  @override
  final int isWanted;
  @override
  final int? locationId;
  @override
  final String? lastVisit;
  @override
  final String? faceCoordinate;

  factory _$VisitorsModel([void Function(VisitorsModelBuilder)? updates]) =>
      (VisitorsModelBuilder()..update(updates))._build();

  _$VisitorsModel._(
      {required this.id,
      this.uniqueId,
      required this.name,
      this.imageUrl,
      required this.isWanted,
      this.locationId,
      this.lastVisit,
      this.faceCoordinate})
      : super._();
  @override
  VisitorsModel rebuild(void Function(VisitorsModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VisitorsModelBuilder toBuilder() => VisitorsModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VisitorsModel &&
        id == other.id &&
        uniqueId == other.uniqueId &&
        name == other.name &&
        imageUrl == other.imageUrl &&
        isWanted == other.isWanted &&
        locationId == other.locationId &&
        lastVisit == other.lastVisit &&
        faceCoordinate == other.faceCoordinate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, uniqueId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, isWanted.hashCode);
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, lastVisit.hashCode);
    _$hash = $jc(_$hash, faceCoordinate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VisitorsModel')
          ..add('id', id)
          ..add('uniqueId', uniqueId)
          ..add('name', name)
          ..add('imageUrl', imageUrl)
          ..add('isWanted', isWanted)
          ..add('locationId', locationId)
          ..add('lastVisit', lastVisit)
          ..add('faceCoordinate', faceCoordinate))
        .toString();
  }
}

class VisitorsModelBuilder
    implements Builder<VisitorsModel, VisitorsModelBuilder> {
  _$VisitorsModel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _uniqueId;
  String? get uniqueId => _$this._uniqueId;
  set uniqueId(String? uniqueId) => _$this._uniqueId = uniqueId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  int? _isWanted;
  int? get isWanted => _$this._isWanted;
  set isWanted(int? isWanted) => _$this._isWanted = isWanted;

  int? _locationId;
  int? get locationId => _$this._locationId;
  set locationId(int? locationId) => _$this._locationId = locationId;

  String? _lastVisit;
  String? get lastVisit => _$this._lastVisit;
  set lastVisit(String? lastVisit) => _$this._lastVisit = lastVisit;

  String? _faceCoordinate;
  String? get faceCoordinate => _$this._faceCoordinate;
  set faceCoordinate(String? faceCoordinate) =>
      _$this._faceCoordinate = faceCoordinate;

  VisitorsModelBuilder();

  VisitorsModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _uniqueId = $v.uniqueId;
      _name = $v.name;
      _imageUrl = $v.imageUrl;
      _isWanted = $v.isWanted;
      _locationId = $v.locationId;
      _lastVisit = $v.lastVisit;
      _faceCoordinate = $v.faceCoordinate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VisitorsModel other) {
    _$v = other as _$VisitorsModel;
  }

  @override
  void update(void Function(VisitorsModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VisitorsModel build() => _build();

  _$VisitorsModel _build() {
    final _$result = _$v ??
        _$VisitorsModel._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'VisitorsModel', 'id'),
          uniqueId: uniqueId,
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'VisitorsModel', 'name'),
          imageUrl: imageUrl,
          isWanted: BuiltValueNullFieldError.checkNotNull(
              isWanted, r'VisitorsModel', 'isWanted'),
          locationId: locationId,
          lastVisit: lastVisit,
          faceCoordinate: faceCoordinate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
