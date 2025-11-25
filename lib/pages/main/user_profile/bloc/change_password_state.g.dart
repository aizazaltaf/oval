// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChangePasswordState extends ChangePasswordState {
  @override
  final String oldPassword;
  @override
  final bool oldPasswordObscure;
  @override
  final String oldPasswordError;
  @override
  final String newPassword;
  @override
  final bool newPasswordObscure;
  @override
  final String newPasswordError;
  @override
  final String confirmPassword;
  @override
  final bool confirmPasswordObscure;
  @override
  final String confirmPasswordError;
  @override
  final String strengthLabel;
  @override
  final double strength;
  @override
  final colors.Color strengthColor;
  @override
  final bool confirmButtonEnabled;
  @override
  final ApiState<void> changePasswordApi;

  factory _$ChangePasswordState(
          [void Function(ChangePasswordStateBuilder)? updates]) =>
      (ChangePasswordStateBuilder()..update(updates))._build();

  _$ChangePasswordState._(
      {required this.oldPassword,
      required this.oldPasswordObscure,
      required this.oldPasswordError,
      required this.newPassword,
      required this.newPasswordObscure,
      required this.newPasswordError,
      required this.confirmPassword,
      required this.confirmPasswordObscure,
      required this.confirmPasswordError,
      required this.strengthLabel,
      required this.strength,
      required this.strengthColor,
      required this.confirmButtonEnabled,
      required this.changePasswordApi})
      : super._();
  @override
  ChangePasswordState rebuild(
          void Function(ChangePasswordStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChangePasswordStateBuilder toBuilder() =>
      ChangePasswordStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChangePasswordState &&
        oldPassword == other.oldPassword &&
        oldPasswordObscure == other.oldPasswordObscure &&
        oldPasswordError == other.oldPasswordError &&
        newPassword == other.newPassword &&
        newPasswordObscure == other.newPasswordObscure &&
        newPasswordError == other.newPasswordError &&
        confirmPassword == other.confirmPassword &&
        confirmPasswordObscure == other.confirmPasswordObscure &&
        confirmPasswordError == other.confirmPasswordError &&
        strengthLabel == other.strengthLabel &&
        strength == other.strength &&
        strengthColor == other.strengthColor &&
        confirmButtonEnabled == other.confirmButtonEnabled &&
        changePasswordApi == other.changePasswordApi;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, oldPassword.hashCode);
    _$hash = $jc(_$hash, oldPasswordObscure.hashCode);
    _$hash = $jc(_$hash, oldPasswordError.hashCode);
    _$hash = $jc(_$hash, newPassword.hashCode);
    _$hash = $jc(_$hash, newPasswordObscure.hashCode);
    _$hash = $jc(_$hash, newPasswordError.hashCode);
    _$hash = $jc(_$hash, confirmPassword.hashCode);
    _$hash = $jc(_$hash, confirmPasswordObscure.hashCode);
    _$hash = $jc(_$hash, confirmPasswordError.hashCode);
    _$hash = $jc(_$hash, strengthLabel.hashCode);
    _$hash = $jc(_$hash, strength.hashCode);
    _$hash = $jc(_$hash, strengthColor.hashCode);
    _$hash = $jc(_$hash, confirmButtonEnabled.hashCode);
    _$hash = $jc(_$hash, changePasswordApi.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChangePasswordState')
          ..add('oldPassword', oldPassword)
          ..add('oldPasswordObscure', oldPasswordObscure)
          ..add('oldPasswordError', oldPasswordError)
          ..add('newPassword', newPassword)
          ..add('newPasswordObscure', newPasswordObscure)
          ..add('newPasswordError', newPasswordError)
          ..add('confirmPassword', confirmPassword)
          ..add('confirmPasswordObscure', confirmPasswordObscure)
          ..add('confirmPasswordError', confirmPasswordError)
          ..add('strengthLabel', strengthLabel)
          ..add('strength', strength)
          ..add('strengthColor', strengthColor)
          ..add('confirmButtonEnabled', confirmButtonEnabled)
          ..add('changePasswordApi', changePasswordApi))
        .toString();
  }
}

class ChangePasswordStateBuilder
    implements Builder<ChangePasswordState, ChangePasswordStateBuilder> {
  _$ChangePasswordState? _$v;

  String? _oldPassword;
  String? get oldPassword => _$this._oldPassword;
  set oldPassword(String? oldPassword) => _$this._oldPassword = oldPassword;

  bool? _oldPasswordObscure;
  bool? get oldPasswordObscure => _$this._oldPasswordObscure;
  set oldPasswordObscure(bool? oldPasswordObscure) =>
      _$this._oldPasswordObscure = oldPasswordObscure;

  String? _oldPasswordError;
  String? get oldPasswordError => _$this._oldPasswordError;
  set oldPasswordError(String? oldPasswordError) =>
      _$this._oldPasswordError = oldPasswordError;

  String? _newPassword;
  String? get newPassword => _$this._newPassword;
  set newPassword(String? newPassword) => _$this._newPassword = newPassword;

  bool? _newPasswordObscure;
  bool? get newPasswordObscure => _$this._newPasswordObscure;
  set newPasswordObscure(bool? newPasswordObscure) =>
      _$this._newPasswordObscure = newPasswordObscure;

  String? _newPasswordError;
  String? get newPasswordError => _$this._newPasswordError;
  set newPasswordError(String? newPasswordError) =>
      _$this._newPasswordError = newPasswordError;

  String? _confirmPassword;
  String? get confirmPassword => _$this._confirmPassword;
  set confirmPassword(String? confirmPassword) =>
      _$this._confirmPassword = confirmPassword;

  bool? _confirmPasswordObscure;
  bool? get confirmPasswordObscure => _$this._confirmPasswordObscure;
  set confirmPasswordObscure(bool? confirmPasswordObscure) =>
      _$this._confirmPasswordObscure = confirmPasswordObscure;

  String? _confirmPasswordError;
  String? get confirmPasswordError => _$this._confirmPasswordError;
  set confirmPasswordError(String? confirmPasswordError) =>
      _$this._confirmPasswordError = confirmPasswordError;

  String? _strengthLabel;
  String? get strengthLabel => _$this._strengthLabel;
  set strengthLabel(String? strengthLabel) =>
      _$this._strengthLabel = strengthLabel;

  double? _strength;
  double? get strength => _$this._strength;
  set strength(double? strength) => _$this._strength = strength;

  colors.Color? _strengthColor;
  colors.Color? get strengthColor => _$this._strengthColor;
  set strengthColor(colors.Color? strengthColor) =>
      _$this._strengthColor = strengthColor;

  bool? _confirmButtonEnabled;
  bool? get confirmButtonEnabled => _$this._confirmButtonEnabled;
  set confirmButtonEnabled(bool? confirmButtonEnabled) =>
      _$this._confirmButtonEnabled = confirmButtonEnabled;

  ApiStateBuilder<void>? _changePasswordApi;
  ApiStateBuilder<void> get changePasswordApi =>
      _$this._changePasswordApi ??= ApiStateBuilder<void>();
  set changePasswordApi(ApiStateBuilder<void>? changePasswordApi) =>
      _$this._changePasswordApi = changePasswordApi;

  ChangePasswordStateBuilder() {
    ChangePasswordState._initialize(this);
  }

  ChangePasswordStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oldPassword = $v.oldPassword;
      _oldPasswordObscure = $v.oldPasswordObscure;
      _oldPasswordError = $v.oldPasswordError;
      _newPassword = $v.newPassword;
      _newPasswordObscure = $v.newPasswordObscure;
      _newPasswordError = $v.newPasswordError;
      _confirmPassword = $v.confirmPassword;
      _confirmPasswordObscure = $v.confirmPasswordObscure;
      _confirmPasswordError = $v.confirmPasswordError;
      _strengthLabel = $v.strengthLabel;
      _strength = $v.strength;
      _strengthColor = $v.strengthColor;
      _confirmButtonEnabled = $v.confirmButtonEnabled;
      _changePasswordApi = $v.changePasswordApi.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChangePasswordState other) {
    _$v = other as _$ChangePasswordState;
  }

  @override
  void update(void Function(ChangePasswordStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChangePasswordState build() => _build();

  _$ChangePasswordState _build() {
    _$ChangePasswordState _$result;
    try {
      _$result = _$v ??
          _$ChangePasswordState._(
            oldPassword: BuiltValueNullFieldError.checkNotNull(
                oldPassword, r'ChangePasswordState', 'oldPassword'),
            oldPasswordObscure: BuiltValueNullFieldError.checkNotNull(
                oldPasswordObscure,
                r'ChangePasswordState',
                'oldPasswordObscure'),
            oldPasswordError: BuiltValueNullFieldError.checkNotNull(
                oldPasswordError, r'ChangePasswordState', 'oldPasswordError'),
            newPassword: BuiltValueNullFieldError.checkNotNull(
                newPassword, r'ChangePasswordState', 'newPassword'),
            newPasswordObscure: BuiltValueNullFieldError.checkNotNull(
                newPasswordObscure,
                r'ChangePasswordState',
                'newPasswordObscure'),
            newPasswordError: BuiltValueNullFieldError.checkNotNull(
                newPasswordError, r'ChangePasswordState', 'newPasswordError'),
            confirmPassword: BuiltValueNullFieldError.checkNotNull(
                confirmPassword, r'ChangePasswordState', 'confirmPassword'),
            confirmPasswordObscure: BuiltValueNullFieldError.checkNotNull(
                confirmPasswordObscure,
                r'ChangePasswordState',
                'confirmPasswordObscure'),
            confirmPasswordError: BuiltValueNullFieldError.checkNotNull(
                confirmPasswordError,
                r'ChangePasswordState',
                'confirmPasswordError'),
            strengthLabel: BuiltValueNullFieldError.checkNotNull(
                strengthLabel, r'ChangePasswordState', 'strengthLabel'),
            strength: BuiltValueNullFieldError.checkNotNull(
                strength, r'ChangePasswordState', 'strength'),
            strengthColor: BuiltValueNullFieldError.checkNotNull(
                strengthColor, r'ChangePasswordState', 'strengthColor'),
            confirmButtonEnabled: BuiltValueNullFieldError.checkNotNull(
                confirmButtonEnabled,
                r'ChangePasswordState',
                'confirmButtonEnabled'),
            changePasswordApi: changePasswordApi.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'changePasswordApi';
        changePasswordApi.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChangePasswordState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
