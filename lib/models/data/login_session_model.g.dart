// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_session_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LoginSessionModel> _$loginSessionModelSerializer =
    _$LoginSessionModelSerializer();

class _$LoginSessionModelSerializer
    implements StructuredSerializer<LoginSessionModel> {
  @override
  final Iterable<Type> types = const [LoginSessionModel, _$LoginSessionModel];
  @override
  final String wireName = 'LoginSessionModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, LoginSessionModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'user_id',
      serializers.serialize(object.userId, specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.deviceType;
    if (value != null) {
      result
        ..add('device_type')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.ipAddress;
    if (value != null) {
      result
        ..add('ip_address')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.status;
    if (value != null) {
      result
        ..add('status')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.logoutDevice;
    if (value != null) {
      result
        ..add('logout_device')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.deviceToken;
    if (value != null) {
      result
        ..add('device_token')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.isTrusted;
    if (value != null) {
      result
        ..add('is_trusted')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.loginTime;
    if (value != null) {
      result
        ..add('login_time')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.logoutTime;
    if (value != null) {
      result
        ..add('logout_time')
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
    value = object.deviceName;
    if (value != null) {
      result
        ..add('device_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.location;
    if (value != null) {
      result
        ..add('location')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  LoginSessionModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = LoginSessionModelBuilder();

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
        case 'user_id':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'device_type':
          result.deviceType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'ip_address':
          result.ipAddress = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'logout_device':
          result.logoutDevice = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'device_token':
          result.deviceToken = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'is_trusted':
          result.isTrusted = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'login_time':
          result.loginTime = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'logout_time':
          result.logoutTime = serializers.deserialize(value,
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
        case 'device_name':
          result.deviceName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'location':
          result.location = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$LoginSessionModel extends LoginSessionModel {
  @override
  final int id;
  @override
  final int userId;
  @override
  final String? deviceType;
  @override
  final String? ipAddress;
  @override
  final String? status;
  @override
  final String? logoutDevice;
  @override
  final String? deviceToken;
  @override
  final int? isTrusted;
  @override
  final String? loginTime;
  @override
  final String? logoutTime;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  final String? deviceName;
  @override
  final String? location;

  factory _$LoginSessionModel(
          [void Function(LoginSessionModelBuilder)? updates]) =>
      (LoginSessionModelBuilder()..update(updates))._build();

  _$LoginSessionModel._(
      {required this.id,
      required this.userId,
      this.deviceType,
      this.ipAddress,
      this.status,
      this.logoutDevice,
      this.deviceToken,
      this.isTrusted,
      this.loginTime,
      this.logoutTime,
      this.createdAt,
      this.updatedAt,
      this.deviceName,
      this.location})
      : super._();
  @override
  LoginSessionModel rebuild(void Function(LoginSessionModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginSessionModelBuilder toBuilder() =>
      LoginSessionModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginSessionModel &&
        id == other.id &&
        userId == other.userId &&
        deviceType == other.deviceType &&
        ipAddress == other.ipAddress &&
        status == other.status &&
        logoutDevice == other.logoutDevice &&
        deviceToken == other.deviceToken &&
        isTrusted == other.isTrusted &&
        loginTime == other.loginTime &&
        logoutTime == other.logoutTime &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        deviceName == other.deviceName &&
        location == other.location;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, deviceType.hashCode);
    _$hash = $jc(_$hash, ipAddress.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, logoutDevice.hashCode);
    _$hash = $jc(_$hash, deviceToken.hashCode);
    _$hash = $jc(_$hash, isTrusted.hashCode);
    _$hash = $jc(_$hash, loginTime.hashCode);
    _$hash = $jc(_$hash, logoutTime.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, deviceName.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoginSessionModel')
          ..add('id', id)
          ..add('userId', userId)
          ..add('deviceType', deviceType)
          ..add('ipAddress', ipAddress)
          ..add('status', status)
          ..add('logoutDevice', logoutDevice)
          ..add('deviceToken', deviceToken)
          ..add('isTrusted', isTrusted)
          ..add('loginTime', loginTime)
          ..add('logoutTime', logoutTime)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('deviceName', deviceName)
          ..add('location', location))
        .toString();
  }
}

class LoginSessionModelBuilder
    implements Builder<LoginSessionModel, LoginSessionModelBuilder> {
  _$LoginSessionModel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  String? _deviceType;
  String? get deviceType => _$this._deviceType;
  set deviceType(String? deviceType) => _$this._deviceType = deviceType;

  String? _ipAddress;
  String? get ipAddress => _$this._ipAddress;
  set ipAddress(String? ipAddress) => _$this._ipAddress = ipAddress;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _logoutDevice;
  String? get logoutDevice => _$this._logoutDevice;
  set logoutDevice(String? logoutDevice) => _$this._logoutDevice = logoutDevice;

  String? _deviceToken;
  String? get deviceToken => _$this._deviceToken;
  set deviceToken(String? deviceToken) => _$this._deviceToken = deviceToken;

  int? _isTrusted;
  int? get isTrusted => _$this._isTrusted;
  set isTrusted(int? isTrusted) => _$this._isTrusted = isTrusted;

  String? _loginTime;
  String? get loginTime => _$this._loginTime;
  set loginTime(String? loginTime) => _$this._loginTime = loginTime;

  String? _logoutTime;
  String? get logoutTime => _$this._logoutTime;
  set logoutTime(String? logoutTime) => _$this._logoutTime = logoutTime;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  String? _deviceName;
  String? get deviceName => _$this._deviceName;
  set deviceName(String? deviceName) => _$this._deviceName = deviceName;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  LoginSessionModelBuilder();

  LoginSessionModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _deviceType = $v.deviceType;
      _ipAddress = $v.ipAddress;
      _status = $v.status;
      _logoutDevice = $v.logoutDevice;
      _deviceToken = $v.deviceToken;
      _isTrusted = $v.isTrusted;
      _loginTime = $v.loginTime;
      _logoutTime = $v.logoutTime;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _deviceName = $v.deviceName;
      _location = $v.location;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginSessionModel other) {
    _$v = other as _$LoginSessionModel;
  }

  @override
  void update(void Function(LoginSessionModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginSessionModel build() => _build();

  _$LoginSessionModel _build() {
    final _$result = _$v ??
        _$LoginSessionModel._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'LoginSessionModel', 'id'),
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'LoginSessionModel', 'userId'),
          deviceType: deviceType,
          ipAddress: ipAddress,
          status: status,
          logoutDevice: logoutDevice,
          deviceToken: deviceToken,
          isTrusted: isTrusted,
          loginTime: loginTime,
          logoutTime: logoutTime,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deviceName: deviceName,
          location: location,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
