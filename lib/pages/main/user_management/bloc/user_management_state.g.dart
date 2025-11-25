// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_management_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserManagementState extends UserManagementState {
  @override
  final String? search;
  @override
  final int loggedInUserRoleId;
  @override
  final String addEmail;
  @override
  final String addEmailError;
  @override
  final String addName;
  @override
  final String addNameError;
  @override
  final String addPhoneNumber;
  @override
  final String addPhoneNumberError;
  @override
  final String addRelation;
  @override
  final String addRelationError;
  @override
  final RoleModel? addRole;
  @override
  final String countryCode;
  @override
  final bool addUserButtonEnabled;
  @override
  final BuiltList<SubUserModel>? subUsersList;
  @override
  final BuiltList<String> relationshipList;
  @override
  final BuiltList<RoleModel> roles;
  @override
  final ApiState<void> getRolesApi;
  @override
  final ApiState<void> createUserInviteApi;
  @override
  final ApiState<void> getSubUsersApi;
  @override
  final ApiState<void> getDeleteInviteApi;
  @override
  final ApiState<void> getDeleteUserApi;

  factory _$UserManagementState(
          [void Function(UserManagementStateBuilder)? updates]) =>
      (UserManagementStateBuilder()..update(updates))._build();

  _$UserManagementState._(
      {this.search,
      required this.loggedInUserRoleId,
      required this.addEmail,
      required this.addEmailError,
      required this.addName,
      required this.addNameError,
      required this.addPhoneNumber,
      required this.addPhoneNumberError,
      required this.addRelation,
      required this.addRelationError,
      this.addRole,
      required this.countryCode,
      required this.addUserButtonEnabled,
      this.subUsersList,
      required this.relationshipList,
      required this.roles,
      required this.getRolesApi,
      required this.createUserInviteApi,
      required this.getSubUsersApi,
      required this.getDeleteInviteApi,
      required this.getDeleteUserApi})
      : super._();
  @override
  UserManagementState rebuild(
          void Function(UserManagementStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserManagementStateBuilder toBuilder() =>
      UserManagementStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserManagementState &&
        search == other.search &&
        loggedInUserRoleId == other.loggedInUserRoleId &&
        addEmail == other.addEmail &&
        addEmailError == other.addEmailError &&
        addName == other.addName &&
        addNameError == other.addNameError &&
        addPhoneNumber == other.addPhoneNumber &&
        addPhoneNumberError == other.addPhoneNumberError &&
        addRelation == other.addRelation &&
        addRelationError == other.addRelationError &&
        addRole == other.addRole &&
        countryCode == other.countryCode &&
        addUserButtonEnabled == other.addUserButtonEnabled &&
        subUsersList == other.subUsersList &&
        relationshipList == other.relationshipList &&
        roles == other.roles &&
        getRolesApi == other.getRolesApi &&
        createUserInviteApi == other.createUserInviteApi &&
        getSubUsersApi == other.getSubUsersApi &&
        getDeleteInviteApi == other.getDeleteInviteApi &&
        getDeleteUserApi == other.getDeleteUserApi;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, search.hashCode);
    _$hash = $jc(_$hash, loggedInUserRoleId.hashCode);
    _$hash = $jc(_$hash, addEmail.hashCode);
    _$hash = $jc(_$hash, addEmailError.hashCode);
    _$hash = $jc(_$hash, addName.hashCode);
    _$hash = $jc(_$hash, addNameError.hashCode);
    _$hash = $jc(_$hash, addPhoneNumber.hashCode);
    _$hash = $jc(_$hash, addPhoneNumberError.hashCode);
    _$hash = $jc(_$hash, addRelation.hashCode);
    _$hash = $jc(_$hash, addRelationError.hashCode);
    _$hash = $jc(_$hash, addRole.hashCode);
    _$hash = $jc(_$hash, countryCode.hashCode);
    _$hash = $jc(_$hash, addUserButtonEnabled.hashCode);
    _$hash = $jc(_$hash, subUsersList.hashCode);
    _$hash = $jc(_$hash, relationshipList.hashCode);
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jc(_$hash, getRolesApi.hashCode);
    _$hash = $jc(_$hash, createUserInviteApi.hashCode);
    _$hash = $jc(_$hash, getSubUsersApi.hashCode);
    _$hash = $jc(_$hash, getDeleteInviteApi.hashCode);
    _$hash = $jc(_$hash, getDeleteUserApi.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserManagementState')
          ..add('search', search)
          ..add('loggedInUserRoleId', loggedInUserRoleId)
          ..add('addEmail', addEmail)
          ..add('addEmailError', addEmailError)
          ..add('addName', addName)
          ..add('addNameError', addNameError)
          ..add('addPhoneNumber', addPhoneNumber)
          ..add('addPhoneNumberError', addPhoneNumberError)
          ..add('addRelation', addRelation)
          ..add('addRelationError', addRelationError)
          ..add('addRole', addRole)
          ..add('countryCode', countryCode)
          ..add('addUserButtonEnabled', addUserButtonEnabled)
          ..add('subUsersList', subUsersList)
          ..add('relationshipList', relationshipList)
          ..add('roles', roles)
          ..add('getRolesApi', getRolesApi)
          ..add('createUserInviteApi', createUserInviteApi)
          ..add('getSubUsersApi', getSubUsersApi)
          ..add('getDeleteInviteApi', getDeleteInviteApi)
          ..add('getDeleteUserApi', getDeleteUserApi))
        .toString();
  }
}

class UserManagementStateBuilder
    implements Builder<UserManagementState, UserManagementStateBuilder> {
  _$UserManagementState? _$v;

  String? _search;
  String? get search => _$this._search;
  set search(String? search) => _$this._search = search;

  int? _loggedInUserRoleId;
  int? get loggedInUserRoleId => _$this._loggedInUserRoleId;
  set loggedInUserRoleId(int? loggedInUserRoleId) =>
      _$this._loggedInUserRoleId = loggedInUserRoleId;

  String? _addEmail;
  String? get addEmail => _$this._addEmail;
  set addEmail(String? addEmail) => _$this._addEmail = addEmail;

  String? _addEmailError;
  String? get addEmailError => _$this._addEmailError;
  set addEmailError(String? addEmailError) =>
      _$this._addEmailError = addEmailError;

  String? _addName;
  String? get addName => _$this._addName;
  set addName(String? addName) => _$this._addName = addName;

  String? _addNameError;
  String? get addNameError => _$this._addNameError;
  set addNameError(String? addNameError) => _$this._addNameError = addNameError;

  String? _addPhoneNumber;
  String? get addPhoneNumber => _$this._addPhoneNumber;
  set addPhoneNumber(String? addPhoneNumber) =>
      _$this._addPhoneNumber = addPhoneNumber;

  String? _addPhoneNumberError;
  String? get addPhoneNumberError => _$this._addPhoneNumberError;
  set addPhoneNumberError(String? addPhoneNumberError) =>
      _$this._addPhoneNumberError = addPhoneNumberError;

  String? _addRelation;
  String? get addRelation => _$this._addRelation;
  set addRelation(String? addRelation) => _$this._addRelation = addRelation;

  String? _addRelationError;
  String? get addRelationError => _$this._addRelationError;
  set addRelationError(String? addRelationError) =>
      _$this._addRelationError = addRelationError;

  RoleModelBuilder? _addRole;
  RoleModelBuilder get addRole => _$this._addRole ??= RoleModelBuilder();
  set addRole(RoleModelBuilder? addRole) => _$this._addRole = addRole;

  String? _countryCode;
  String? get countryCode => _$this._countryCode;
  set countryCode(String? countryCode) => _$this._countryCode = countryCode;

  bool? _addUserButtonEnabled;
  bool? get addUserButtonEnabled => _$this._addUserButtonEnabled;
  set addUserButtonEnabled(bool? addUserButtonEnabled) =>
      _$this._addUserButtonEnabled = addUserButtonEnabled;

  ListBuilder<SubUserModel>? _subUsersList;
  ListBuilder<SubUserModel> get subUsersList =>
      _$this._subUsersList ??= ListBuilder<SubUserModel>();
  set subUsersList(ListBuilder<SubUserModel>? subUsersList) =>
      _$this._subUsersList = subUsersList;

  ListBuilder<String>? _relationshipList;
  ListBuilder<String> get relationshipList =>
      _$this._relationshipList ??= ListBuilder<String>();
  set relationshipList(ListBuilder<String>? relationshipList) =>
      _$this._relationshipList = relationshipList;

  ListBuilder<RoleModel>? _roles;
  ListBuilder<RoleModel> get roles =>
      _$this._roles ??= ListBuilder<RoleModel>();
  set roles(ListBuilder<RoleModel>? roles) => _$this._roles = roles;

  ApiStateBuilder<void>? _getRolesApi;
  ApiStateBuilder<void> get getRolesApi =>
      _$this._getRolesApi ??= ApiStateBuilder<void>();
  set getRolesApi(ApiStateBuilder<void>? getRolesApi) =>
      _$this._getRolesApi = getRolesApi;

  ApiStateBuilder<void>? _createUserInviteApi;
  ApiStateBuilder<void> get createUserInviteApi =>
      _$this._createUserInviteApi ??= ApiStateBuilder<void>();
  set createUserInviteApi(ApiStateBuilder<void>? createUserInviteApi) =>
      _$this._createUserInviteApi = createUserInviteApi;

  ApiStateBuilder<void>? _getSubUsersApi;
  ApiStateBuilder<void> get getSubUsersApi =>
      _$this._getSubUsersApi ??= ApiStateBuilder<void>();
  set getSubUsersApi(ApiStateBuilder<void>? getSubUsersApi) =>
      _$this._getSubUsersApi = getSubUsersApi;

  ApiStateBuilder<void>? _getDeleteInviteApi;
  ApiStateBuilder<void> get getDeleteInviteApi =>
      _$this._getDeleteInviteApi ??= ApiStateBuilder<void>();
  set getDeleteInviteApi(ApiStateBuilder<void>? getDeleteInviteApi) =>
      _$this._getDeleteInviteApi = getDeleteInviteApi;

  ApiStateBuilder<void>? _getDeleteUserApi;
  ApiStateBuilder<void> get getDeleteUserApi =>
      _$this._getDeleteUserApi ??= ApiStateBuilder<void>();
  set getDeleteUserApi(ApiStateBuilder<void>? getDeleteUserApi) =>
      _$this._getDeleteUserApi = getDeleteUserApi;

  UserManagementStateBuilder() {
    UserManagementState._initialize(this);
  }

  UserManagementStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _search = $v.search;
      _loggedInUserRoleId = $v.loggedInUserRoleId;
      _addEmail = $v.addEmail;
      _addEmailError = $v.addEmailError;
      _addName = $v.addName;
      _addNameError = $v.addNameError;
      _addPhoneNumber = $v.addPhoneNumber;
      _addPhoneNumberError = $v.addPhoneNumberError;
      _addRelation = $v.addRelation;
      _addRelationError = $v.addRelationError;
      _addRole = $v.addRole?.toBuilder();
      _countryCode = $v.countryCode;
      _addUserButtonEnabled = $v.addUserButtonEnabled;
      _subUsersList = $v.subUsersList?.toBuilder();
      _relationshipList = $v.relationshipList.toBuilder();
      _roles = $v.roles.toBuilder();
      _getRolesApi = $v.getRolesApi.toBuilder();
      _createUserInviteApi = $v.createUserInviteApi.toBuilder();
      _getSubUsersApi = $v.getSubUsersApi.toBuilder();
      _getDeleteInviteApi = $v.getDeleteInviteApi.toBuilder();
      _getDeleteUserApi = $v.getDeleteUserApi.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserManagementState other) {
    _$v = other as _$UserManagementState;
  }

  @override
  void update(void Function(UserManagementStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserManagementState build() => _build();

  _$UserManagementState _build() {
    _$UserManagementState _$result;
    try {
      _$result = _$v ??
          _$UserManagementState._(
            search: search,
            loggedInUserRoleId: BuiltValueNullFieldError.checkNotNull(
                loggedInUserRoleId,
                r'UserManagementState',
                'loggedInUserRoleId'),
            addEmail: BuiltValueNullFieldError.checkNotNull(
                addEmail, r'UserManagementState', 'addEmail'),
            addEmailError: BuiltValueNullFieldError.checkNotNull(
                addEmailError, r'UserManagementState', 'addEmailError'),
            addName: BuiltValueNullFieldError.checkNotNull(
                addName, r'UserManagementState', 'addName'),
            addNameError: BuiltValueNullFieldError.checkNotNull(
                addNameError, r'UserManagementState', 'addNameError'),
            addPhoneNumber: BuiltValueNullFieldError.checkNotNull(
                addPhoneNumber, r'UserManagementState', 'addPhoneNumber'),
            addPhoneNumberError: BuiltValueNullFieldError.checkNotNull(
                addPhoneNumberError,
                r'UserManagementState',
                'addPhoneNumberError'),
            addRelation: BuiltValueNullFieldError.checkNotNull(
                addRelation, r'UserManagementState', 'addRelation'),
            addRelationError: BuiltValueNullFieldError.checkNotNull(
                addRelationError, r'UserManagementState', 'addRelationError'),
            addRole: _addRole?.build(),
            countryCode: BuiltValueNullFieldError.checkNotNull(
                countryCode, r'UserManagementState', 'countryCode'),
            addUserButtonEnabled: BuiltValueNullFieldError.checkNotNull(
                addUserButtonEnabled,
                r'UserManagementState',
                'addUserButtonEnabled'),
            subUsersList: _subUsersList?.build(),
            relationshipList: relationshipList.build(),
            roles: roles.build(),
            getRolesApi: getRolesApi.build(),
            createUserInviteApi: createUserInviteApi.build(),
            getSubUsersApi: getSubUsersApi.build(),
            getDeleteInviteApi: getDeleteInviteApi.build(),
            getDeleteUserApi: getDeleteUserApi.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'addRole';
        _addRole?.build();

        _$failedField = 'subUsersList';
        _subUsersList?.build();
        _$failedField = 'relationshipList';
        relationshipList.build();
        _$failedField = 'roles';
        roles.build();
        _$failedField = 'getRolesApi';
        getRolesApi.build();
        _$failedField = 'createUserInviteApi';
        createUserInviteApi.build();
        _$failedField = 'getSubUsersApi';
        getSubUsersApi.build();
        _$failedField = 'getDeleteInviteApi';
        getDeleteInviteApi.build();
        _$failedField = 'getDeleteUserApi';
        getDeleteUserApi.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserManagementState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
