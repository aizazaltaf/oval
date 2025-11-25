// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UserData> _$userDataSerializer = _$UserDataSerializer();

class _$UserDataSerializer implements StructuredSerializer<UserData> {
  @override
  final Iterable<Type> types = const [UserData, _$UserData];
  @override
  final String wireName = 'UserData';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'ai_theme_counter',
      serializers.serialize(object.aiThemeCounter,
          specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.email;
    if (value != null) {
      result
        ..add('email')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.phone;
    if (value != null) {
      result
        ..add('phone')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.pushNotificationToken;
    if (value != null) {
      result
        ..add('push_notification_token')
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
    value = object.streamingId;
    if (value != null) {
      result
        ..add('streamingId')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.selectedDoorBell;
    if (value != null) {
      result
        ..add('selectedDoorBell')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(UserDeviceModel)));
    }
    value = object.sectionList;
    if (value != null) {
      result
        ..add('sectionList')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.planFeaturesList;
    if (value != null) {
      result
        ..add('planFeaturesList')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                BuiltList, const [const FullType(PlanFeaturesModel)])));
    }
    value = object.canPinned;
    if (value != null) {
      result
        ..add('canPinned')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.image;
    if (value != null) {
      result
        ..add('image')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.apiToken;
    if (value != null) {
      result
        ..add('session_token')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.refreshToken;
    if (value != null) {
      result
        ..add('refresh_token')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.pendingEmail;
    if (value != null) {
      result
        ..add('pending_email')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.phoneVerified;
    if (value != null) {
      result
        ..add('phone_verified')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.emailVerified;
    if (value != null) {
      result
        ..add('email_verified')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.guides;
    if (value != null) {
      result
        ..add('guides')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(GuideModel)));
    }
    value = object.userRole;
    if (value != null) {
      result
        ..add('userRole')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.locations;
    if (value != null) {
      result
        ..add('locations')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                BuiltList, const [const FullType(DoorbellLocations)])));
    }
    return result;
  }

  @override
  UserData deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UserDataBuilder();

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
              specifiedType: const FullType(String)) as String?;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'phone':
          result.phone = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'push_notification_token':
          result.pushNotificationToken = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'ai_theme_counter':
          result.aiThemeCounter = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'uuid':
          result.callUserId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'streamingId':
          result.streamingId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'selectedDoorBell':
          result.selectedDoorBell.replace(serializers.deserialize(value,
                  specifiedType: const FullType(UserDeviceModel))!
              as UserDeviceModel);
          break;
        case 'sectionList':
          result.sectionList.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'planFeaturesList':
          result.planFeaturesList.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(PlanFeaturesModel)]))!
              as BuiltList<Object?>);
          break;
        case 'canPinned':
          result.canPinned = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'session_token':
          result.apiToken = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'refresh_token':
          result.refreshToken = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'pending_email':
          result.pendingEmail = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'phone_verified':
          result.phoneVerified = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'email_verified':
          result.emailVerified = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'guides':
          result.guides.replace(serializers.deserialize(value,
              specifiedType: const FullType(GuideModel))! as GuideModel);
          break;
        case 'userRole':
          result.userRole = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'locations':
          result.locations.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(DoorbellLocations)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$UserData extends UserData {
  @override
  final int id;
  @override
  final String? name;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? pushNotificationToken;
  @override
  final int aiThemeCounter;
  @override
  final String? callUserId;
  @override
  final String? streamingId;
  @override
  final UserDeviceModel? selectedDoorBell;
  @override
  final BuiltList<String>? sectionList;
  @override
  final BuiltList<PlanFeaturesModel>? planFeaturesList;
  @override
  final bool? canPinned;
  @override
  final String? image;
  @override
  final String? apiToken;
  @override
  final String? refreshToken;
  @override
  final String? pendingEmail;
  @override
  final bool? phoneVerified;
  @override
  final bool? emailVerified;
  @override
  final GuideModel? guides;
  @override
  final String? userRole;
  @override
  final BuiltList<DoorbellLocations>? locations;

  factory _$UserData([void Function(UserDataBuilder)? updates]) =>
      (UserDataBuilder()..update(updates))._build();

  _$UserData._(
      {required this.id,
      this.name,
      this.email,
      this.phone,
      this.pushNotificationToken,
      required this.aiThemeCounter,
      this.callUserId,
      this.streamingId,
      this.selectedDoorBell,
      this.sectionList,
      this.planFeaturesList,
      this.canPinned,
      this.image,
      this.apiToken,
      this.refreshToken,
      this.pendingEmail,
      this.phoneVerified,
      this.emailVerified,
      this.guides,
      this.userRole,
      this.locations})
      : super._();
  @override
  UserData rebuild(void Function(UserDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserDataBuilder toBuilder() => UserDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserData &&
        id == other.id &&
        name == other.name &&
        email == other.email &&
        phone == other.phone &&
        pushNotificationToken == other.pushNotificationToken &&
        aiThemeCounter == other.aiThemeCounter &&
        callUserId == other.callUserId &&
        streamingId == other.streamingId &&
        selectedDoorBell == other.selectedDoorBell &&
        sectionList == other.sectionList &&
        planFeaturesList == other.planFeaturesList &&
        canPinned == other.canPinned &&
        image == other.image &&
        apiToken == other.apiToken &&
        refreshToken == other.refreshToken &&
        pendingEmail == other.pendingEmail &&
        phoneVerified == other.phoneVerified &&
        emailVerified == other.emailVerified &&
        guides == other.guides &&
        userRole == other.userRole &&
        locations == other.locations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, pushNotificationToken.hashCode);
    _$hash = $jc(_$hash, aiThemeCounter.hashCode);
    _$hash = $jc(_$hash, callUserId.hashCode);
    _$hash = $jc(_$hash, streamingId.hashCode);
    _$hash = $jc(_$hash, selectedDoorBell.hashCode);
    _$hash = $jc(_$hash, sectionList.hashCode);
    _$hash = $jc(_$hash, planFeaturesList.hashCode);
    _$hash = $jc(_$hash, canPinned.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, apiToken.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, pendingEmail.hashCode);
    _$hash = $jc(_$hash, phoneVerified.hashCode);
    _$hash = $jc(_$hash, emailVerified.hashCode);
    _$hash = $jc(_$hash, guides.hashCode);
    _$hash = $jc(_$hash, userRole.hashCode);
    _$hash = $jc(_$hash, locations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserData')
          ..add('id', id)
          ..add('name', name)
          ..add('email', email)
          ..add('phone', phone)
          ..add('pushNotificationToken', pushNotificationToken)
          ..add('aiThemeCounter', aiThemeCounter)
          ..add('callUserId', callUserId)
          ..add('streamingId', streamingId)
          ..add('selectedDoorBell', selectedDoorBell)
          ..add('sectionList', sectionList)
          ..add('planFeaturesList', planFeaturesList)
          ..add('canPinned', canPinned)
          ..add('image', image)
          ..add('apiToken', apiToken)
          ..add('refreshToken', refreshToken)
          ..add('pendingEmail', pendingEmail)
          ..add('phoneVerified', phoneVerified)
          ..add('emailVerified', emailVerified)
          ..add('guides', guides)
          ..add('userRole', userRole)
          ..add('locations', locations))
        .toString();
  }
}

class UserDataBuilder implements Builder<UserData, UserDataBuilder> {
  _$UserData? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _pushNotificationToken;
  String? get pushNotificationToken => _$this._pushNotificationToken;
  set pushNotificationToken(String? pushNotificationToken) =>
      _$this._pushNotificationToken = pushNotificationToken;

  int? _aiThemeCounter;
  int? get aiThemeCounter => _$this._aiThemeCounter;
  set aiThemeCounter(int? aiThemeCounter) =>
      _$this._aiThemeCounter = aiThemeCounter;

  String? _callUserId;
  String? get callUserId => _$this._callUserId;
  set callUserId(String? callUserId) => _$this._callUserId = callUserId;

  String? _streamingId;
  String? get streamingId => _$this._streamingId;
  set streamingId(String? streamingId) => _$this._streamingId = streamingId;

  UserDeviceModelBuilder? _selectedDoorBell;
  UserDeviceModelBuilder get selectedDoorBell =>
      _$this._selectedDoorBell ??= UserDeviceModelBuilder();
  set selectedDoorBell(UserDeviceModelBuilder? selectedDoorBell) =>
      _$this._selectedDoorBell = selectedDoorBell;

  ListBuilder<String>? _sectionList;
  ListBuilder<String> get sectionList =>
      _$this._sectionList ??= ListBuilder<String>();
  set sectionList(ListBuilder<String>? sectionList) =>
      _$this._sectionList = sectionList;

  ListBuilder<PlanFeaturesModel>? _planFeaturesList;
  ListBuilder<PlanFeaturesModel> get planFeaturesList =>
      _$this._planFeaturesList ??= ListBuilder<PlanFeaturesModel>();
  set planFeaturesList(ListBuilder<PlanFeaturesModel>? planFeaturesList) =>
      _$this._planFeaturesList = planFeaturesList;

  bool? _canPinned;
  bool? get canPinned => _$this._canPinned;
  set canPinned(bool? canPinned) => _$this._canPinned = canPinned;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  String? _apiToken;
  String? get apiToken => _$this._apiToken;
  set apiToken(String? apiToken) => _$this._apiToken = apiToken;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  String? _pendingEmail;
  String? get pendingEmail => _$this._pendingEmail;
  set pendingEmail(String? pendingEmail) => _$this._pendingEmail = pendingEmail;

  bool? _phoneVerified;
  bool? get phoneVerified => _$this._phoneVerified;
  set phoneVerified(bool? phoneVerified) =>
      _$this._phoneVerified = phoneVerified;

  bool? _emailVerified;
  bool? get emailVerified => _$this._emailVerified;
  set emailVerified(bool? emailVerified) =>
      _$this._emailVerified = emailVerified;

  GuideModelBuilder? _guides;
  GuideModelBuilder get guides => _$this._guides ??= GuideModelBuilder();
  set guides(GuideModelBuilder? guides) => _$this._guides = guides;

  String? _userRole;
  String? get userRole => _$this._userRole;
  set userRole(String? userRole) => _$this._userRole = userRole;

  ListBuilder<DoorbellLocations>? _locations;
  ListBuilder<DoorbellLocations> get locations =>
      _$this._locations ??= ListBuilder<DoorbellLocations>();
  set locations(ListBuilder<DoorbellLocations>? locations) =>
      _$this._locations = locations;

  UserDataBuilder() {
    UserData._initialize(this);
  }

  UserDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _email = $v.email;
      _phone = $v.phone;
      _pushNotificationToken = $v.pushNotificationToken;
      _aiThemeCounter = $v.aiThemeCounter;
      _callUserId = $v.callUserId;
      _streamingId = $v.streamingId;
      _selectedDoorBell = $v.selectedDoorBell?.toBuilder();
      _sectionList = $v.sectionList?.toBuilder();
      _planFeaturesList = $v.planFeaturesList?.toBuilder();
      _canPinned = $v.canPinned;
      _image = $v.image;
      _apiToken = $v.apiToken;
      _refreshToken = $v.refreshToken;
      _pendingEmail = $v.pendingEmail;
      _phoneVerified = $v.phoneVerified;
      _emailVerified = $v.emailVerified;
      _guides = $v.guides?.toBuilder();
      _userRole = $v.userRole;
      _locations = $v.locations?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserData other) {
    _$v = other as _$UserData;
  }

  @override
  void update(void Function(UserDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserData build() => _build();

  _$UserData _build() {
    _$UserData _$result;
    try {
      _$result = _$v ??
          _$UserData._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'UserData', 'id'),
            name: name,
            email: email,
            phone: phone,
            pushNotificationToken: pushNotificationToken,
            aiThemeCounter: BuiltValueNullFieldError.checkNotNull(
                aiThemeCounter, r'UserData', 'aiThemeCounter'),
            callUserId: callUserId,
            streamingId: streamingId,
            selectedDoorBell: _selectedDoorBell?.build(),
            sectionList: _sectionList?.build(),
            planFeaturesList: _planFeaturesList?.build(),
            canPinned: canPinned,
            image: image,
            apiToken: apiToken,
            refreshToken: refreshToken,
            pendingEmail: pendingEmail,
            phoneVerified: phoneVerified,
            emailVerified: emailVerified,
            guides: _guides?.build(),
            userRole: userRole,
            locations: _locations?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'selectedDoorBell';
        _selectedDoorBell?.build();
        _$failedField = 'sectionList';
        _sectionList?.build();
        _$failedField = 'planFeaturesList';
        _planFeaturesList?.build();

        _$failedField = 'guides';
        _guides?.build();

        _$failedField = 'locations';
        _locations?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
