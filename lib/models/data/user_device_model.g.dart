// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_device_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UserDeviceModel> _$userDeviceModelSerializer =
    _$UserDeviceModelSerializer();

class _$UserDeviceModelSerializer
    implements StructuredSerializer<UserDeviceModel> {
  @override
  final Iterable<Type> types = const [UserDeviceModel, _$UserDeviceModel];
  @override
  final String wireName = 'UserDeviceModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserDeviceModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'uuid',
      serializers.serialize(object.callUserId,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.deviceId;
    if (value != null) {
      result
        ..add('device_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.entityId;
    if (value != null) {
      result
        ..add('entity_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.locationId;
    if (value != null) {
      result
        ..add('location_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.roomId;
    if (value != null) {
      result
        ..add('room_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.isStreaming;
    if (value != null) {
      result
        ..add('is_streaming')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.deviceToken;
    if (value != null) {
      result
        ..add('push_notification_token')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.image;
    if (value != null) {
      result
        ..add('image_preview')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.name;
    if (value != null) {
      result
        ..add('device_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.doorbellLocations;
    if (value != null) {
      result
        ..add('location')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DoorbellLocations)));
    }
    value = object.isExternalCamera;
    if (value != null) {
      result
        ..add('isExternalCamera')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.isDefault;
    if (value != null) {
      result
        ..add('is_default')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.details;
    if (value != null) {
      result
        ..add('details')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.edge;
    if (value != null) {
      result
        ..add('edgelight')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.flash;
    if (value != null) {
      result
        ..add('flashlight')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  UserDeviceModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UserDeviceModelBuilder();

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
        case 'device_id':
          result.deviceId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'entity_id':
          result.entityId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'location_id':
          result.locationId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'room_id':
          result.roomId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'is_streaming':
          result.isStreaming = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'push_notification_token':
          result.deviceToken = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'uuid':
          result.callUserId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'image_preview':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'device_name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'location':
          result.doorbellLocations.replace(serializers.deserialize(value,
                  specifiedType: const FullType(DoorbellLocations))!
              as DoorbellLocations);
          break;
        case 'isExternalCamera':
          result.isExternalCamera = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'is_default':
          result.isDefault = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'details':
          result.details = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'edgelight':
          result.edge = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'flashlight':
          result.flash = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
      }
    }

    return result.build();
  }
}

class _$UserDeviceModel extends UserDeviceModel {
  @override
  final int id;
  @override
  final String? deviceId;
  @override
  final String? entityId;
  @override
  final int? locationId;
  @override
  final int? roomId;
  @override
  final int? isStreaming;
  @override
  final String? deviceToken;
  @override
  final String callUserId;
  @override
  final String? image;
  @override
  final String? name;
  @override
  final DoorbellLocations? doorbellLocations;
  @override
  final bool? isExternalCamera;
  @override
  final int? isDefault;
  @override
  final String? details;
  @override
  final bool? edge;
  @override
  final bool? flash;

  factory _$UserDeviceModel([void Function(UserDeviceModelBuilder)? updates]) =>
      (UserDeviceModelBuilder()..update(updates))._build();

  _$UserDeviceModel._(
      {required this.id,
      this.deviceId,
      this.entityId,
      this.locationId,
      this.roomId,
      this.isStreaming,
      this.deviceToken,
      required this.callUserId,
      this.image,
      this.name,
      this.doorbellLocations,
      this.isExternalCamera,
      this.isDefault,
      this.details,
      this.edge,
      this.flash})
      : super._();
  @override
  UserDeviceModel rebuild(void Function(UserDeviceModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserDeviceModelBuilder toBuilder() => UserDeviceModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserDeviceModel &&
        id == other.id &&
        deviceId == other.deviceId &&
        entityId == other.entityId &&
        locationId == other.locationId &&
        roomId == other.roomId &&
        isStreaming == other.isStreaming &&
        deviceToken == other.deviceToken &&
        callUserId == other.callUserId &&
        image == other.image &&
        name == other.name &&
        doorbellLocations == other.doorbellLocations &&
        isExternalCamera == other.isExternalCamera &&
        isDefault == other.isDefault &&
        details == other.details &&
        edge == other.edge &&
        flash == other.flash;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, entityId.hashCode);
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, roomId.hashCode);
    _$hash = $jc(_$hash, isStreaming.hashCode);
    _$hash = $jc(_$hash, deviceToken.hashCode);
    _$hash = $jc(_$hash, callUserId.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, doorbellLocations.hashCode);
    _$hash = $jc(_$hash, isExternalCamera.hashCode);
    _$hash = $jc(_$hash, isDefault.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jc(_$hash, edge.hashCode);
    _$hash = $jc(_$hash, flash.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserDeviceModel')
          ..add('id', id)
          ..add('deviceId', deviceId)
          ..add('entityId', entityId)
          ..add('locationId', locationId)
          ..add('roomId', roomId)
          ..add('isStreaming', isStreaming)
          ..add('deviceToken', deviceToken)
          ..add('callUserId', callUserId)
          ..add('image', image)
          ..add('name', name)
          ..add('doorbellLocations', doorbellLocations)
          ..add('isExternalCamera', isExternalCamera)
          ..add('isDefault', isDefault)
          ..add('details', details)
          ..add('edge', edge)
          ..add('flash', flash))
        .toString();
  }
}

class UserDeviceModelBuilder
    implements Builder<UserDeviceModel, UserDeviceModelBuilder> {
  _$UserDeviceModel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _entityId;
  String? get entityId => _$this._entityId;
  set entityId(String? entityId) => _$this._entityId = entityId;

  int? _locationId;
  int? get locationId => _$this._locationId;
  set locationId(int? locationId) => _$this._locationId = locationId;

  int? _roomId;
  int? get roomId => _$this._roomId;
  set roomId(int? roomId) => _$this._roomId = roomId;

  int? _isStreaming;
  int? get isStreaming => _$this._isStreaming;
  set isStreaming(int? isStreaming) => _$this._isStreaming = isStreaming;

  String? _deviceToken;
  String? get deviceToken => _$this._deviceToken;
  set deviceToken(String? deviceToken) => _$this._deviceToken = deviceToken;

  String? _callUserId;
  String? get callUserId => _$this._callUserId;
  set callUserId(String? callUserId) => _$this._callUserId = callUserId;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DoorbellLocationsBuilder? _doorbellLocations;
  DoorbellLocationsBuilder get doorbellLocations =>
      _$this._doorbellLocations ??= DoorbellLocationsBuilder();
  set doorbellLocations(DoorbellLocationsBuilder? doorbellLocations) =>
      _$this._doorbellLocations = doorbellLocations;

  bool? _isExternalCamera;
  bool? get isExternalCamera => _$this._isExternalCamera;
  set isExternalCamera(bool? isExternalCamera) =>
      _$this._isExternalCamera = isExternalCamera;

  int? _isDefault;
  int? get isDefault => _$this._isDefault;
  set isDefault(int? isDefault) => _$this._isDefault = isDefault;

  String? _details;
  String? get details => _$this._details;
  set details(String? details) => _$this._details = details;

  bool? _edge;
  bool? get edge => _$this._edge;
  set edge(bool? edge) => _$this._edge = edge;

  bool? _flash;
  bool? get flash => _$this._flash;
  set flash(bool? flash) => _$this._flash = flash;

  UserDeviceModelBuilder() {
    UserDeviceModel._initialize(this);
  }

  UserDeviceModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _deviceId = $v.deviceId;
      _entityId = $v.entityId;
      _locationId = $v.locationId;
      _roomId = $v.roomId;
      _isStreaming = $v.isStreaming;
      _deviceToken = $v.deviceToken;
      _callUserId = $v.callUserId;
      _image = $v.image;
      _name = $v.name;
      _doorbellLocations = $v.doorbellLocations?.toBuilder();
      _isExternalCamera = $v.isExternalCamera;
      _isDefault = $v.isDefault;
      _details = $v.details;
      _edge = $v.edge;
      _flash = $v.flash;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserDeviceModel other) {
    _$v = other as _$UserDeviceModel;
  }

  @override
  void update(void Function(UserDeviceModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserDeviceModel build() => _build();

  _$UserDeviceModel _build() {
    _$UserDeviceModel _$result;
    try {
      _$result = _$v ??
          _$UserDeviceModel._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'UserDeviceModel', 'id'),
            deviceId: deviceId,
            entityId: entityId,
            locationId: locationId,
            roomId: roomId,
            isStreaming: isStreaming,
            deviceToken: deviceToken,
            callUserId: BuiltValueNullFieldError.checkNotNull(
                callUserId, r'UserDeviceModel', 'callUserId'),
            image: image,
            name: name,
            doorbellLocations: _doorbellLocations?.build(),
            isExternalCamera: isExternalCamera,
            isDefault: isDefault,
            details: details,
            edge: edge,
            flash: flash,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'doorbellLocations';
        _doorbellLocations?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserDeviceModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
