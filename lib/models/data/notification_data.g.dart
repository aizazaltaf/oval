// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NotificationData> _$notificationDataSerializer =
    _$NotificationDataSerializer();

class _$NotificationDataSerializer
    implements StructuredSerializer<NotificationData> {
  @override
  final Iterable<Type> types = const [NotificationData, _$NotificationData];
  @override
  final String wireName = 'NotificationData';

  @override
  Iterable<Object?> serialize(Serializers serializers, NotificationData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'user_id',
      serializers.serialize(object.userId, specifiedType: const FullType(int)),
      'location_id',
      serializers.serialize(object.locationId,
          specifiedType: const FullType(int)),
      'text',
      serializers.serialize(object.text, specifiedType: const FullType(String)),
      'is_read',
      serializers.serialize(object.isRead, specifiedType: const FullType(int)),
      'created_at',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(String)),
      'updated_at',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(String)),
      'expanded',
      serializers.serialize(object.expanded,
          specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.imageUrl;
    if (value != null) {
      result
        ..add('image')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.voiceMessage;
    if (value != null) {
      result
        ..add('voice_message')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.deviceId;
    if (value != null) {
      result
        ..add('device_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.visitorId;
    if (value != null) {
      result
        ..add('visitor_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.entityId;
    if (value != null) {
      result
        ..add('entity_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.receiveType;
    if (value != null) {
      result
        ..add('receive_type')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.deletedAt;
    if (value != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.visitor;
    if (value != null) {
      result
        ..add('visitors')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(VisitorsModel)));
    }
    value = object.doorbell;
    if (value != null) {
      result
        ..add('doorbell')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(UserDeviceModel)));
    }
    value = object.iotDevice;
    if (value != null) {
      result
        ..add('iot_device')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(IotDeviceModel)));
    }
    return result;
  }

  @override
  NotificationData deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = NotificationDataBuilder();

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
        case 'image':
          result.imageUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'voice_message':
          result.voiceMessage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'user_id':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'location_id':
          result.locationId = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'text':
          result.text = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'device_id':
          result.deviceId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'visitor_id':
          result.visitorId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'is_read':
          result.isRead = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'entity_id':
          result.entityId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'receive_type':
          result.receiveType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'deleted_at':
          result.deletedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'visitors':
          result.visitor.replace(serializers.deserialize(value,
              specifiedType: const FullType(VisitorsModel))! as VisitorsModel);
          break;
        case 'doorbell':
          result.doorbell.replace(serializers.deserialize(value,
                  specifiedType: const FullType(UserDeviceModel))!
              as UserDeviceModel);
          break;
        case 'iot_device':
          result.iotDevice.replace(serializers.deserialize(value,
                  specifiedType: const FullType(IotDeviceModel))!
              as IotDeviceModel);
          break;
        case 'expanded':
          result.expanded = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$NotificationData extends NotificationData {
  @override
  final int id;
  @override
  final String title;
  @override
  final String? imageUrl;
  @override
  final String? voiceMessage;
  @override
  final int userId;
  @override
  final int locationId;
  @override
  final String text;
  @override
  final String? deviceId;
  @override
  final int? visitorId;
  @override
  final int isRead;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final String? entityId;
  @override
  final String? receiveType;
  @override
  final String? deletedAt;
  @override
  final VisitorsModel? visitor;
  @override
  final UserDeviceModel? doorbell;
  @override
  final IotDeviceModel? iotDevice;
  @override
  final bool expanded;

  factory _$NotificationData(
          [void Function(NotificationDataBuilder)? updates]) =>
      (NotificationDataBuilder()..update(updates))._build();

  _$NotificationData._(
      {required this.id,
      required this.title,
      this.imageUrl,
      this.voiceMessage,
      required this.userId,
      required this.locationId,
      required this.text,
      this.deviceId,
      this.visitorId,
      required this.isRead,
      required this.createdAt,
      required this.updatedAt,
      this.entityId,
      this.receiveType,
      this.deletedAt,
      this.visitor,
      this.doorbell,
      this.iotDevice,
      required this.expanded})
      : super._();
  @override
  NotificationData rebuild(void Function(NotificationDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationDataBuilder toBuilder() =>
      NotificationDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationData &&
        id == other.id &&
        title == other.title &&
        imageUrl == other.imageUrl &&
        voiceMessage == other.voiceMessage &&
        userId == other.userId &&
        locationId == other.locationId &&
        text == other.text &&
        deviceId == other.deviceId &&
        visitorId == other.visitorId &&
        isRead == other.isRead &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        entityId == other.entityId &&
        receiveType == other.receiveType &&
        deletedAt == other.deletedAt &&
        visitor == other.visitor &&
        doorbell == other.doorbell &&
        iotDevice == other.iotDevice &&
        expanded == other.expanded;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, voiceMessage.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, visitorId.hashCode);
    _$hash = $jc(_$hash, isRead.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, entityId.hashCode);
    _$hash = $jc(_$hash, receiveType.hashCode);
    _$hash = $jc(_$hash, deletedAt.hashCode);
    _$hash = $jc(_$hash, visitor.hashCode);
    _$hash = $jc(_$hash, doorbell.hashCode);
    _$hash = $jc(_$hash, iotDevice.hashCode);
    _$hash = $jc(_$hash, expanded.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationData')
          ..add('id', id)
          ..add('title', title)
          ..add('imageUrl', imageUrl)
          ..add('voiceMessage', voiceMessage)
          ..add('userId', userId)
          ..add('locationId', locationId)
          ..add('text', text)
          ..add('deviceId', deviceId)
          ..add('visitorId', visitorId)
          ..add('isRead', isRead)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('entityId', entityId)
          ..add('receiveType', receiveType)
          ..add('deletedAt', deletedAt)
          ..add('visitor', visitor)
          ..add('doorbell', doorbell)
          ..add('iotDevice', iotDevice)
          ..add('expanded', expanded))
        .toString();
  }
}

class NotificationDataBuilder
    implements Builder<NotificationData, NotificationDataBuilder> {
  _$NotificationData? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  String? _voiceMessage;
  String? get voiceMessage => _$this._voiceMessage;
  set voiceMessage(String? voiceMessage) => _$this._voiceMessage = voiceMessage;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  int? _locationId;
  int? get locationId => _$this._locationId;
  set locationId(int? locationId) => _$this._locationId = locationId;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  int? _visitorId;
  int? get visitorId => _$this._visitorId;
  set visitorId(int? visitorId) => _$this._visitorId = visitorId;

  int? _isRead;
  int? get isRead => _$this._isRead;
  set isRead(int? isRead) => _$this._isRead = isRead;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  String? _entityId;
  String? get entityId => _$this._entityId;
  set entityId(String? entityId) => _$this._entityId = entityId;

  String? _receiveType;
  String? get receiveType => _$this._receiveType;
  set receiveType(String? receiveType) => _$this._receiveType = receiveType;

  String? _deletedAt;
  String? get deletedAt => _$this._deletedAt;
  set deletedAt(String? deletedAt) => _$this._deletedAt = deletedAt;

  VisitorsModelBuilder? _visitor;
  VisitorsModelBuilder get visitor =>
      _$this._visitor ??= VisitorsModelBuilder();
  set visitor(VisitorsModelBuilder? visitor) => _$this._visitor = visitor;

  UserDeviceModelBuilder? _doorbell;
  UserDeviceModelBuilder get doorbell =>
      _$this._doorbell ??= UserDeviceModelBuilder();
  set doorbell(UserDeviceModelBuilder? doorbell) => _$this._doorbell = doorbell;

  IotDeviceModelBuilder? _iotDevice;
  IotDeviceModelBuilder get iotDevice =>
      _$this._iotDevice ??= IotDeviceModelBuilder();
  set iotDevice(IotDeviceModelBuilder? iotDevice) =>
      _$this._iotDevice = iotDevice;

  bool? _expanded;
  bool? get expanded => _$this._expanded;
  set expanded(bool? expanded) => _$this._expanded = expanded;

  NotificationDataBuilder() {
    NotificationData._initializeBuilder(this);
  }

  NotificationDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _imageUrl = $v.imageUrl;
      _voiceMessage = $v.voiceMessage;
      _userId = $v.userId;
      _locationId = $v.locationId;
      _text = $v.text;
      _deviceId = $v.deviceId;
      _visitorId = $v.visitorId;
      _isRead = $v.isRead;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _entityId = $v.entityId;
      _receiveType = $v.receiveType;
      _deletedAt = $v.deletedAt;
      _visitor = $v.visitor?.toBuilder();
      _doorbell = $v.doorbell?.toBuilder();
      _iotDevice = $v.iotDevice?.toBuilder();
      _expanded = $v.expanded;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationData other) {
    _$v = other as _$NotificationData;
  }

  @override
  void update(void Function(NotificationDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationData build() => _build();

  _$NotificationData _build() {
    _$NotificationData _$result;
    try {
      _$result = _$v ??
          _$NotificationData._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'NotificationData', 'id'),
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'NotificationData', 'title'),
            imageUrl: imageUrl,
            voiceMessage: voiceMessage,
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'NotificationData', 'userId'),
            locationId: BuiltValueNullFieldError.checkNotNull(
                locationId, r'NotificationData', 'locationId'),
            text: BuiltValueNullFieldError.checkNotNull(
                text, r'NotificationData', 'text'),
            deviceId: deviceId,
            visitorId: visitorId,
            isRead: BuiltValueNullFieldError.checkNotNull(
                isRead, r'NotificationData', 'isRead'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'NotificationData', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'NotificationData', 'updatedAt'),
            entityId: entityId,
            receiveType: receiveType,
            deletedAt: deletedAt,
            visitor: _visitor?.build(),
            doorbell: _doorbell?.build(),
            iotDevice: _iotDevice?.build(),
            expanded: BuiltValueNullFieldError.checkNotNull(
                expanded, r'NotificationData', 'expanded'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'visitor';
        _visitor?.build();
        _$failedField = 'doorbell';
        _doorbell?.build();
        _$failedField = 'iotDevice';
        _iotDevice?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'NotificationData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
