// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_user_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SubUserModel> _$subUserModelSerializer = _$SubUserModelSerializer();

class _$SubUserModelSerializer implements StructuredSerializer<SubUserModel> {
  @override
  final Iterable<Type> types = const [SubUserModel, _$SubUserModel];
  @override
  final String wireName = 'SubUserModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, SubUserModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'user_id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'user_exist',
      serializers.serialize(object.userExist,
          specifiedType: const FullType(bool)),
      'source',
      serializers.serialize(object.source,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.phoneNumber;
    if (value != null) {
      result
        ..add('phone_number')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.role;
    if (value != null) {
      result
        ..add('role')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(RoleModel)));
    }
    value = object.isAccepted;
    if (value != null) {
      result
        ..add('is_accepted')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.inviteId;
    if (value != null) {
      result
        ..add('invite_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.profileImage;
    if (value != null) {
      result
        ..add('profile_image')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  SubUserModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = SubUserModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'user_id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'phone_number':
          result.phoneNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'role':
          result.role.replace(serializers.deserialize(value,
              specifiedType: const FullType(RoleModel))! as RoleModel);
          break;
        case 'is_accepted':
          result.isAccepted = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'invite_id':
          result.inviteId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'user_exist':
          result.userExist = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'source':
          result.source = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'profile_image':
          result.profileImage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$SubUserModel extends SubUserModel {
  @override
  final int id;
  @override
  final String? name;
  @override
  final String email;
  @override
  final String? phoneNumber;
  @override
  final RoleModel? role;
  @override
  final String? isAccepted;
  @override
  final int? inviteId;
  @override
  final bool userExist;
  @override
  final String source;
  @override
  final String? profileImage;

  factory _$SubUserModel([void Function(SubUserModelBuilder)? updates]) =>
      (SubUserModelBuilder()..update(updates))._build();

  _$SubUserModel._(
      {required this.id,
      this.name,
      required this.email,
      this.phoneNumber,
      this.role,
      this.isAccepted,
      this.inviteId,
      required this.userExist,
      required this.source,
      this.profileImage})
      : super._();
  @override
  SubUserModel rebuild(void Function(SubUserModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubUserModelBuilder toBuilder() => SubUserModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubUserModel &&
        id == other.id &&
        name == other.name &&
        email == other.email &&
        phoneNumber == other.phoneNumber &&
        role == other.role &&
        isAccepted == other.isAccepted &&
        inviteId == other.inviteId &&
        userExist == other.userExist &&
        source == other.source &&
        profileImage == other.profileImage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, isAccepted.hashCode);
    _$hash = $jc(_$hash, inviteId.hashCode);
    _$hash = $jc(_$hash, userExist.hashCode);
    _$hash = $jc(_$hash, source.hashCode);
    _$hash = $jc(_$hash, profileImage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubUserModel')
          ..add('id', id)
          ..add('name', name)
          ..add('email', email)
          ..add('phoneNumber', phoneNumber)
          ..add('role', role)
          ..add('isAccepted', isAccepted)
          ..add('inviteId', inviteId)
          ..add('userExist', userExist)
          ..add('source', source)
          ..add('profileImage', profileImage))
        .toString();
  }
}

class SubUserModelBuilder
    implements Builder<SubUserModel, SubUserModelBuilder> {
  _$SubUserModel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  RoleModelBuilder? _role;
  RoleModelBuilder get role => _$this._role ??= RoleModelBuilder();
  set role(RoleModelBuilder? role) => _$this._role = role;

  String? _isAccepted;
  String? get isAccepted => _$this._isAccepted;
  set isAccepted(String? isAccepted) => _$this._isAccepted = isAccepted;

  int? _inviteId;
  int? get inviteId => _$this._inviteId;
  set inviteId(int? inviteId) => _$this._inviteId = inviteId;

  bool? _userExist;
  bool? get userExist => _$this._userExist;
  set userExist(bool? userExist) => _$this._userExist = userExist;

  String? _source;
  String? get source => _$this._source;
  set source(String? source) => _$this._source = source;

  String? _profileImage;
  String? get profileImage => _$this._profileImage;
  set profileImage(String? profileImage) => _$this._profileImage = profileImage;

  SubUserModelBuilder();

  SubUserModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _email = $v.email;
      _phoneNumber = $v.phoneNumber;
      _role = $v.role?.toBuilder();
      _isAccepted = $v.isAccepted;
      _inviteId = $v.inviteId;
      _userExist = $v.userExist;
      _source = $v.source;
      _profileImage = $v.profileImage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubUserModel other) {
    _$v = other as _$SubUserModel;
  }

  @override
  void update(void Function(SubUserModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubUserModel build() => _build();

  _$SubUserModel _build() {
    _$SubUserModel _$result;
    try {
      _$result = _$v ??
          _$SubUserModel._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'SubUserModel', 'id'),
            name: name,
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'SubUserModel', 'email'),
            phoneNumber: phoneNumber,
            role: _role?.build(),
            isAccepted: isAccepted,
            inviteId: inviteId,
            userExist: BuiltValueNullFieldError.checkNotNull(
                userExist, r'SubUserModel', 'userExist'),
            source: BuiltValueNullFieldError.checkNotNull(
                source, r'SubUserModel', 'source'),
            profileImage: profileImage,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'role';
        _role?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SubUserModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
