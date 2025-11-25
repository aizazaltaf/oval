// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iot_device_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<IotDeviceModel> _$iotDeviceModelSerializer =
    _$IotDeviceModelSerializer();

class _$IotDeviceModelSerializer
    implements StructuredSerializer<IotDeviceModel> {
  @override
  final Iterable<Type> types = const [IotDeviceModel, _$IotDeviceModel];
  @override
  final String wireName = 'IotDeviceModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, IotDeviceModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'usage_count',
      serializers.serialize(object.usageCount,
          specifiedType: const FullType(int)),
      'details',
      serializers.serialize(object.detailsJson,
          specifiedType: const FullType(String)),
      'is_streaming',
      serializers.serialize(object.isStreaming,
          specifiedType: const FullType(int)),
      'stateAvailable',
      serializers.serialize(object.stateAvailable,
          specifiedType: const FullType(int)),
      'brightness',
      serializers.serialize(object.brightness,
          specifiedType: const FullType(double)),
    ];
    Object? value;
    value = object.entityId;
    if (value != null) {
      result
        ..add('entity_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.roomId;
    if (value != null) {
      result
        ..add('room_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.deviceName;
    if (value != null) {
      result
        ..add('name')
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
    value = object.callUserId;
    if (value != null) {
      result
        ..add('uuid')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.doorbellId;
    if (value != null) {
      result
        ..add('doorbell_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.imagePreview;
    if (value != null) {
      result
        ..add('imagePreview')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.locationId;
    if (value != null) {
      result
        ..add('location_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.status;
    if (value != null) {
      result
        ..add('status')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.room;
    if (value != null) {
      result
        ..add('room')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(RoomItemsModel)));
    }
    value = object.configuration;
    if (value != null) {
      result
        ..add('configuration')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.temperature;
    if (value != null) {
      result
        ..add('temperature')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.thermostatTemperatureUnit;
    if (value != null) {
      result
        ..add('thermostatTemperatureUnit')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.mode;
    if (value != null) {
      result
        ..add('mode')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.presetMode;
    if (value != null) {
      result
        ..add('presetMode')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.fanMode;
    if (value != null) {
      result
        ..add('fanMode')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.curtainDeviceId;
    if (value != null) {
      result
        ..add('curtainDeviceId')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.curtainPosition;
    if (value != null) {
      result
        ..add('curtainPosition')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.blindDirection;
    if (value != null) {
      result
        ..add('blindDirection')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.superTooltipController;
    if (value != null) {
      result
        ..add('superTooltipController')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(SuperTooltipController)));
    }
    return result;
  }

  @override
  IotDeviceModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = IotDeviceModelBuilder();

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
        case 'entity_id':
          result.entityId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'room_id':
          result.roomId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'name':
          result.deviceName = serializers.deserialize(value,
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
        case 'uuid':
          result.callUserId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'usage_count':
          result.usageCount = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'doorbell_id':
          result.doorbellId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'details':
          result.detailsJson = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'imagePreview':
          result.imagePreview = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'location_id':
          result.locationId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'is_streaming':
          result.isStreaming = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'room':
          result.room.replace(serializers.deserialize(value,
                  specifiedType: const FullType(RoomItemsModel))!
              as RoomItemsModel);
          break;
        case 'stateAvailable':
          result.stateAvailable = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'brightness':
          result.brightness = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'configuration':
          result.configuration = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'temperature':
          result.temperature = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'thermostatTemperatureUnit':
          result.thermostatTemperatureUnit = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'mode':
          result.mode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'presetMode':
          result.presetMode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'fanMode':
          result.fanMode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'curtainDeviceId':
          result.curtainDeviceId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'curtainPosition':
          result.curtainPosition = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'blindDirection':
          result.blindDirection = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'superTooltipController':
          result.superTooltipController = serializers.deserialize(value,
                  specifiedType: const FullType(SuperTooltipController))
              as SuperTooltipController?;
          break;
      }
    }

    return result.build();
  }
}

class _$IotDeviceModel extends IotDeviceModel {
  @override
  final int id;
  @override
  final String? entityId;
  @override
  final int? roomId;
  @override
  final String? deviceName;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  final String? callUserId;
  @override
  final int usageCount;
  @override
  final int? doorbellId;
  @override
  final String detailsJson;
  @override
  final String? imagePreview;
  @override
  final int? locationId;
  @override
  final int isStreaming;
  @override
  final int? status;
  @override
  final RoomItemsModel? room;
  @override
  final int stateAvailable;
  @override
  final double brightness;
  @override
  final String? configuration;
  @override
  final String? temperature;
  @override
  final String? thermostatTemperatureUnit;
  @override
  final String? mode;
  @override
  final String? presetMode;
  @override
  final String? fanMode;
  @override
  final String? curtainDeviceId;
  @override
  final String? curtainPosition;
  @override
  final String? blindDirection;
  @override
  final SuperTooltipController? superTooltipController;

  factory _$IotDeviceModel([void Function(IotDeviceModelBuilder)? updates]) =>
      (IotDeviceModelBuilder()..update(updates))._build();

  _$IotDeviceModel._(
      {required this.id,
      this.entityId,
      this.roomId,
      this.deviceName,
      this.createdAt,
      this.updatedAt,
      this.callUserId,
      required this.usageCount,
      this.doorbellId,
      required this.detailsJson,
      this.imagePreview,
      this.locationId,
      required this.isStreaming,
      this.status,
      this.room,
      required this.stateAvailable,
      required this.brightness,
      this.configuration,
      this.temperature,
      this.thermostatTemperatureUnit,
      this.mode,
      this.presetMode,
      this.fanMode,
      this.curtainDeviceId,
      this.curtainPosition,
      this.blindDirection,
      this.superTooltipController})
      : super._();
  @override
  IotDeviceModel rebuild(void Function(IotDeviceModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IotDeviceModelBuilder toBuilder() => IotDeviceModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IotDeviceModel &&
        id == other.id &&
        entityId == other.entityId &&
        roomId == other.roomId &&
        deviceName == other.deviceName &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        callUserId == other.callUserId &&
        usageCount == other.usageCount &&
        doorbellId == other.doorbellId &&
        detailsJson == other.detailsJson &&
        imagePreview == other.imagePreview &&
        locationId == other.locationId &&
        isStreaming == other.isStreaming &&
        status == other.status &&
        room == other.room &&
        stateAvailable == other.stateAvailable &&
        brightness == other.brightness &&
        configuration == other.configuration &&
        temperature == other.temperature &&
        thermostatTemperatureUnit == other.thermostatTemperatureUnit &&
        mode == other.mode &&
        presetMode == other.presetMode &&
        fanMode == other.fanMode &&
        curtainDeviceId == other.curtainDeviceId &&
        curtainPosition == other.curtainPosition &&
        blindDirection == other.blindDirection &&
        superTooltipController == other.superTooltipController;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, entityId.hashCode);
    _$hash = $jc(_$hash, roomId.hashCode);
    _$hash = $jc(_$hash, deviceName.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, callUserId.hashCode);
    _$hash = $jc(_$hash, usageCount.hashCode);
    _$hash = $jc(_$hash, doorbellId.hashCode);
    _$hash = $jc(_$hash, detailsJson.hashCode);
    _$hash = $jc(_$hash, imagePreview.hashCode);
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, isStreaming.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, room.hashCode);
    _$hash = $jc(_$hash, stateAvailable.hashCode);
    _$hash = $jc(_$hash, brightness.hashCode);
    _$hash = $jc(_$hash, configuration.hashCode);
    _$hash = $jc(_$hash, temperature.hashCode);
    _$hash = $jc(_$hash, thermostatTemperatureUnit.hashCode);
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jc(_$hash, presetMode.hashCode);
    _$hash = $jc(_$hash, fanMode.hashCode);
    _$hash = $jc(_$hash, curtainDeviceId.hashCode);
    _$hash = $jc(_$hash, curtainPosition.hashCode);
    _$hash = $jc(_$hash, blindDirection.hashCode);
    _$hash = $jc(_$hash, superTooltipController.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IotDeviceModel')
          ..add('id', id)
          ..add('entityId', entityId)
          ..add('roomId', roomId)
          ..add('deviceName', deviceName)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('callUserId', callUserId)
          ..add('usageCount', usageCount)
          ..add('doorbellId', doorbellId)
          ..add('detailsJson', detailsJson)
          ..add('imagePreview', imagePreview)
          ..add('locationId', locationId)
          ..add('isStreaming', isStreaming)
          ..add('status', status)
          ..add('room', room)
          ..add('stateAvailable', stateAvailable)
          ..add('brightness', brightness)
          ..add('configuration', configuration)
          ..add('temperature', temperature)
          ..add('thermostatTemperatureUnit', thermostatTemperatureUnit)
          ..add('mode', mode)
          ..add('presetMode', presetMode)
          ..add('fanMode', fanMode)
          ..add('curtainDeviceId', curtainDeviceId)
          ..add('curtainPosition', curtainPosition)
          ..add('blindDirection', blindDirection)
          ..add('superTooltipController', superTooltipController))
        .toString();
  }
}

class IotDeviceModelBuilder
    implements Builder<IotDeviceModel, IotDeviceModelBuilder> {
  _$IotDeviceModel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _entityId;
  String? get entityId => _$this._entityId;
  set entityId(String? entityId) => _$this._entityId = entityId;

  int? _roomId;
  int? get roomId => _$this._roomId;
  set roomId(int? roomId) => _$this._roomId = roomId;

  String? _deviceName;
  String? get deviceName => _$this._deviceName;
  set deviceName(String? deviceName) => _$this._deviceName = deviceName;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  String? _callUserId;
  String? get callUserId => _$this._callUserId;
  set callUserId(String? callUserId) => _$this._callUserId = callUserId;

  int? _usageCount;
  int? get usageCount => _$this._usageCount;
  set usageCount(int? usageCount) => _$this._usageCount = usageCount;

  int? _doorbellId;
  int? get doorbellId => _$this._doorbellId;
  set doorbellId(int? doorbellId) => _$this._doorbellId = doorbellId;

  String? _detailsJson;
  String? get detailsJson => _$this._detailsJson;
  set detailsJson(String? detailsJson) => _$this._detailsJson = detailsJson;

  String? _imagePreview;
  String? get imagePreview => _$this._imagePreview;
  set imagePreview(String? imagePreview) => _$this._imagePreview = imagePreview;

  int? _locationId;
  int? get locationId => _$this._locationId;
  set locationId(int? locationId) => _$this._locationId = locationId;

  int? _isStreaming;
  int? get isStreaming => _$this._isStreaming;
  set isStreaming(int? isStreaming) => _$this._isStreaming = isStreaming;

  int? _status;
  int? get status => _$this._status;
  set status(int? status) => _$this._status = status;

  RoomItemsModelBuilder? _room;
  RoomItemsModelBuilder get room => _$this._room ??= RoomItemsModelBuilder();
  set room(RoomItemsModelBuilder? room) => _$this._room = room;

  int? _stateAvailable;
  int? get stateAvailable => _$this._stateAvailable;
  set stateAvailable(int? stateAvailable) =>
      _$this._stateAvailable = stateAvailable;

  double? _brightness;
  double? get brightness => _$this._brightness;
  set brightness(double? brightness) => _$this._brightness = brightness;

  String? _configuration;
  String? get configuration => _$this._configuration;
  set configuration(String? configuration) =>
      _$this._configuration = configuration;

  String? _temperature;
  String? get temperature => _$this._temperature;
  set temperature(String? temperature) => _$this._temperature = temperature;

  String? _thermostatTemperatureUnit;
  String? get thermostatTemperatureUnit => _$this._thermostatTemperatureUnit;
  set thermostatTemperatureUnit(String? thermostatTemperatureUnit) =>
      _$this._thermostatTemperatureUnit = thermostatTemperatureUnit;

  String? _mode;
  String? get mode => _$this._mode;
  set mode(String? mode) => _$this._mode = mode;

  String? _presetMode;
  String? get presetMode => _$this._presetMode;
  set presetMode(String? presetMode) => _$this._presetMode = presetMode;

  String? _fanMode;
  String? get fanMode => _$this._fanMode;
  set fanMode(String? fanMode) => _$this._fanMode = fanMode;

  String? _curtainDeviceId;
  String? get curtainDeviceId => _$this._curtainDeviceId;
  set curtainDeviceId(String? curtainDeviceId) =>
      _$this._curtainDeviceId = curtainDeviceId;

  String? _curtainPosition;
  String? get curtainPosition => _$this._curtainPosition;
  set curtainPosition(String? curtainPosition) =>
      _$this._curtainPosition = curtainPosition;

  String? _blindDirection;
  String? get blindDirection => _$this._blindDirection;
  set blindDirection(String? blindDirection) =>
      _$this._blindDirection = blindDirection;

  SuperTooltipController? _superTooltipController;
  SuperTooltipController? get superTooltipController =>
      _$this._superTooltipController;
  set superTooltipController(SuperTooltipController? superTooltipController) =>
      _$this._superTooltipController = superTooltipController;

  IotDeviceModelBuilder() {
    IotDeviceModel._initializeBuilder(this);
  }

  IotDeviceModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _entityId = $v.entityId;
      _roomId = $v.roomId;
      _deviceName = $v.deviceName;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _callUserId = $v.callUserId;
      _usageCount = $v.usageCount;
      _doorbellId = $v.doorbellId;
      _detailsJson = $v.detailsJson;
      _imagePreview = $v.imagePreview;
      _locationId = $v.locationId;
      _isStreaming = $v.isStreaming;
      _status = $v.status;
      _room = $v.room?.toBuilder();
      _stateAvailable = $v.stateAvailable;
      _brightness = $v.brightness;
      _configuration = $v.configuration;
      _temperature = $v.temperature;
      _thermostatTemperatureUnit = $v.thermostatTemperatureUnit;
      _mode = $v.mode;
      _presetMode = $v.presetMode;
      _fanMode = $v.fanMode;
      _curtainDeviceId = $v.curtainDeviceId;
      _curtainPosition = $v.curtainPosition;
      _blindDirection = $v.blindDirection;
      _superTooltipController = $v.superTooltipController;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IotDeviceModel other) {
    _$v = other as _$IotDeviceModel;
  }

  @override
  void update(void Function(IotDeviceModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IotDeviceModel build() => _build();

  _$IotDeviceModel _build() {
    IotDeviceModel._finalize(this);
    _$IotDeviceModel _$result;
    try {
      _$result = _$v ??
          _$IotDeviceModel._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'IotDeviceModel', 'id'),
            entityId: entityId,
            roomId: roomId,
            deviceName: deviceName,
            createdAt: createdAt,
            updatedAt: updatedAt,
            callUserId: callUserId,
            usageCount: BuiltValueNullFieldError.checkNotNull(
                usageCount, r'IotDeviceModel', 'usageCount'),
            doorbellId: doorbellId,
            detailsJson: BuiltValueNullFieldError.checkNotNull(
                detailsJson, r'IotDeviceModel', 'detailsJson'),
            imagePreview: imagePreview,
            locationId: locationId,
            isStreaming: BuiltValueNullFieldError.checkNotNull(
                isStreaming, r'IotDeviceModel', 'isStreaming'),
            status: status,
            room: _room?.build(),
            stateAvailable: BuiltValueNullFieldError.checkNotNull(
                stateAvailable, r'IotDeviceModel', 'stateAvailable'),
            brightness: BuiltValueNullFieldError.checkNotNull(
                brightness, r'IotDeviceModel', 'brightness'),
            configuration: configuration,
            temperature: temperature,
            thermostatTemperatureUnit: thermostatTemperatureUnit,
            mode: mode,
            presetMode: presetMode,
            fanMode: fanMode,
            curtainDeviceId: curtainDeviceId,
            curtainPosition: curtainPosition,
            blindDirection: blindDirection,
            superTooltipController: superTooltipController,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'room';
        _room?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'IotDeviceModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
