// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doorbell_locations.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DoorbellLocations> _$doorbellLocationsSerializer =
    _$DoorbellLocationsSerializer();

class _$DoorbellLocationsSerializer
    implements StructuredSerializer<DoorbellLocations> {
  @override
  final Iterable<Type> types = const [DoorbellLocations, _$DoorbellLocations];
  @override
  final String wireName = 'DoorbellLocations';

  @override
  Iterable<Object?> serialize(Serializers serializers, DoorbellLocations object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'roles',
      serializers.serialize(object.roles,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.ownerId;
    if (value != null) {
      result
        ..add('owner_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.latitude;
    if (value != null) {
      result
        ..add('latitude')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.longitude;
    if (value != null) {
      result
        ..add('longitude')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.houseNo;
    if (value != null) {
      result
        ..add('house_no')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.street;
    if (value != null) {
      result
        ..add('street')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.state;
    if (value != null) {
      result
        ..add('state')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.city;
    if (value != null) {
      result
        ..add('city')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.country;
    if (value != null) {
      result
        ..add('country')
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
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.subscription;
    if (value != null) {
      result
        ..add('subscription')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(SubscriptionLocationModel)));
    }
    return result;
  }

  @override
  DoorbellLocations deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = DoorbellLocationsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'owner_id':
          result.ownerId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'latitude':
          result.latitude = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'longitude':
          result.longitude = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'house_no':
          result.houseNo = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'street':
          result.street = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'state':
          result.state = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'city':
          result.city = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'country':
          result.country = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'device_id':
          result.deviceId = serializers.deserialize(value,
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
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'roles':
          result.roles.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'subscription':
          result.subscription.replace(serializers.deserialize(value,
                  specifiedType: const FullType(SubscriptionLocationModel))!
              as SubscriptionLocationModel);
          break;
      }
    }

    return result.build();
  }
}

class _$DoorbellLocations extends DoorbellLocations {
  @override
  final int? id;
  @override
  final int? ownerId;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? houseNo;
  @override
  final String? street;
  @override
  final String? state;
  @override
  final String? city;
  @override
  final String? country;
  @override
  final String? deviceId;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  final String? name;
  @override
  final BuiltList<String> roles;
  @override
  final SubscriptionLocationModel? subscription;

  factory _$DoorbellLocations(
          [void Function(DoorbellLocationsBuilder)? updates]) =>
      (DoorbellLocationsBuilder()..update(updates))._build();

  _$DoorbellLocations._(
      {this.id,
      this.ownerId,
      this.latitude,
      this.longitude,
      this.houseNo,
      this.street,
      this.state,
      this.city,
      this.country,
      this.deviceId,
      this.createdAt,
      this.updatedAt,
      this.name,
      required this.roles,
      this.subscription})
      : super._();
  @override
  DoorbellLocations rebuild(void Function(DoorbellLocationsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DoorbellLocationsBuilder toBuilder() =>
      DoorbellLocationsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DoorbellLocations &&
        id == other.id &&
        ownerId == other.ownerId &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        houseNo == other.houseNo &&
        street == other.street &&
        state == other.state &&
        city == other.city &&
        country == other.country &&
        deviceId == other.deviceId &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        name == other.name &&
        roles == other.roles &&
        subscription == other.subscription;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, ownerId.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, houseNo.hashCode);
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, country.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jc(_$hash, subscription.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DoorbellLocations')
          ..add('id', id)
          ..add('ownerId', ownerId)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('houseNo', houseNo)
          ..add('street', street)
          ..add('state', state)
          ..add('city', city)
          ..add('country', country)
          ..add('deviceId', deviceId)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('name', name)
          ..add('roles', roles)
          ..add('subscription', subscription))
        .toString();
  }
}

class DoorbellLocationsBuilder
    implements Builder<DoorbellLocations, DoorbellLocationsBuilder> {
  _$DoorbellLocations? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _ownerId;
  int? get ownerId => _$this._ownerId;
  set ownerId(int? ownerId) => _$this._ownerId = ownerId;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  String? _houseNo;
  String? get houseNo => _$this._houseNo;
  set houseNo(String? houseNo) => _$this._houseNo = houseNo;

  String? _street;
  String? get street => _$this._street;
  set street(String? street) => _$this._street = street;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _country;
  String? get country => _$this._country;
  set country(String? country) => _$this._country = country;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ListBuilder<String>? _roles;
  ListBuilder<String> get roles => _$this._roles ??= ListBuilder<String>();
  set roles(ListBuilder<String>? roles) => _$this._roles = roles;

  SubscriptionLocationModelBuilder? _subscription;
  SubscriptionLocationModelBuilder get subscription =>
      _$this._subscription ??= SubscriptionLocationModelBuilder();
  set subscription(SubscriptionLocationModelBuilder? subscription) =>
      _$this._subscription = subscription;

  DoorbellLocationsBuilder();

  DoorbellLocationsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _ownerId = $v.ownerId;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _houseNo = $v.houseNo;
      _street = $v.street;
      _state = $v.state;
      _city = $v.city;
      _country = $v.country;
      _deviceId = $v.deviceId;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _name = $v.name;
      _roles = $v.roles.toBuilder();
      _subscription = $v.subscription?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DoorbellLocations other) {
    _$v = other as _$DoorbellLocations;
  }

  @override
  void update(void Function(DoorbellLocationsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DoorbellLocations build() => _build();

  _$DoorbellLocations _build() {
    _$DoorbellLocations _$result;
    try {
      _$result = _$v ??
          _$DoorbellLocations._(
            id: id,
            ownerId: ownerId,
            latitude: latitude,
            longitude: longitude,
            houseNo: houseNo,
            street: street,
            state: state,
            city: city,
            country: country,
            deviceId: deviceId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            name: name,
            roles: roles.build(),
            subscription: _subscription?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'roles';
        roles.build();
        _$failedField = 'subscription';
        _subscription?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DoorbellLocations', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
