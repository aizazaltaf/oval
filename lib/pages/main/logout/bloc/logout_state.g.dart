// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logout_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LogoutState extends LogoutState {
  @override
  final String currentDeviceToken;
  @override
  final BuiltList<LoginSessionModel>? loginActivities;
  @override
  final ApiState<void> loginActivityApi;
  @override
  final ApiState<void> logoutOfSpecificDeviceApi;
  @override
  final ApiState<void> logoutAllSessionsApi;

  factory _$LogoutState([void Function(LogoutStateBuilder)? updates]) =>
      (LogoutStateBuilder()..update(updates))._build();

  _$LogoutState._(
      {required this.currentDeviceToken,
      this.loginActivities,
      required this.loginActivityApi,
      required this.logoutOfSpecificDeviceApi,
      required this.logoutAllSessionsApi})
      : super._();
  @override
  LogoutState rebuild(void Function(LogoutStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LogoutStateBuilder toBuilder() => LogoutStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LogoutState &&
        currentDeviceToken == other.currentDeviceToken &&
        loginActivities == other.loginActivities &&
        loginActivityApi == other.loginActivityApi &&
        logoutOfSpecificDeviceApi == other.logoutOfSpecificDeviceApi &&
        logoutAllSessionsApi == other.logoutAllSessionsApi;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentDeviceToken.hashCode);
    _$hash = $jc(_$hash, loginActivities.hashCode);
    _$hash = $jc(_$hash, loginActivityApi.hashCode);
    _$hash = $jc(_$hash, logoutOfSpecificDeviceApi.hashCode);
    _$hash = $jc(_$hash, logoutAllSessionsApi.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LogoutState')
          ..add('currentDeviceToken', currentDeviceToken)
          ..add('loginActivities', loginActivities)
          ..add('loginActivityApi', loginActivityApi)
          ..add('logoutOfSpecificDeviceApi', logoutOfSpecificDeviceApi)
          ..add('logoutAllSessionsApi', logoutAllSessionsApi))
        .toString();
  }
}

class LogoutStateBuilder implements Builder<LogoutState, LogoutStateBuilder> {
  _$LogoutState? _$v;

  String? _currentDeviceToken;
  String? get currentDeviceToken => _$this._currentDeviceToken;
  set currentDeviceToken(String? currentDeviceToken) =>
      _$this._currentDeviceToken = currentDeviceToken;

  ListBuilder<LoginSessionModel>? _loginActivities;
  ListBuilder<LoginSessionModel> get loginActivities =>
      _$this._loginActivities ??= ListBuilder<LoginSessionModel>();
  set loginActivities(ListBuilder<LoginSessionModel>? loginActivities) =>
      _$this._loginActivities = loginActivities;

  ApiStateBuilder<void>? _loginActivityApi;
  ApiStateBuilder<void> get loginActivityApi =>
      _$this._loginActivityApi ??= ApiStateBuilder<void>();
  set loginActivityApi(ApiStateBuilder<void>? loginActivityApi) =>
      _$this._loginActivityApi = loginActivityApi;

  ApiStateBuilder<void>? _logoutOfSpecificDeviceApi;
  ApiStateBuilder<void> get logoutOfSpecificDeviceApi =>
      _$this._logoutOfSpecificDeviceApi ??= ApiStateBuilder<void>();
  set logoutOfSpecificDeviceApi(
          ApiStateBuilder<void>? logoutOfSpecificDeviceApi) =>
      _$this._logoutOfSpecificDeviceApi = logoutOfSpecificDeviceApi;

  ApiStateBuilder<void>? _logoutAllSessionsApi;
  ApiStateBuilder<void> get logoutAllSessionsApi =>
      _$this._logoutAllSessionsApi ??= ApiStateBuilder<void>();
  set logoutAllSessionsApi(ApiStateBuilder<void>? logoutAllSessionsApi) =>
      _$this._logoutAllSessionsApi = logoutAllSessionsApi;

  LogoutStateBuilder() {
    LogoutState._initialize(this);
  }

  LogoutStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentDeviceToken = $v.currentDeviceToken;
      _loginActivities = $v.loginActivities?.toBuilder();
      _loginActivityApi = $v.loginActivityApi.toBuilder();
      _logoutOfSpecificDeviceApi = $v.logoutOfSpecificDeviceApi.toBuilder();
      _logoutAllSessionsApi = $v.logoutAllSessionsApi.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LogoutState other) {
    _$v = other as _$LogoutState;
  }

  @override
  void update(void Function(LogoutStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LogoutState build() => _build();

  _$LogoutState _build() {
    _$LogoutState _$result;
    try {
      _$result = _$v ??
          _$LogoutState._(
            currentDeviceToken: BuiltValueNullFieldError.checkNotNull(
                currentDeviceToken, r'LogoutState', 'currentDeviceToken'),
            loginActivities: _loginActivities?.build(),
            loginActivityApi: loginActivityApi.build(),
            logoutOfSpecificDeviceApi: logoutOfSpecificDeviceApi.build(),
            logoutAllSessionsApi: logoutAllSessionsApi.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'loginActivities';
        _loginActivities?.build();
        _$failedField = 'loginActivityApi';
        loginActivityApi.build();
        _$failedField = 'logoutOfSpecificDeviceApi';
        logoutOfSpecificDeviceApi.build();
        _$failedField = 'logoutAllSessionsApi';
        logoutAllSessionsApi.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LogoutState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
