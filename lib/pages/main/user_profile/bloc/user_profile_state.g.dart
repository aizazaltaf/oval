// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserProfileState extends UserProfileState {
  @override
  final bool isProfileEditing;
  @override
  final bool? fromGallery;
  @override
  final bool clearOtp;
  @override
  final String otpError;
  @override
  final String countryCode;
  @override
  final String userPassword;
  @override
  final String validatePassword;
  @override
  final bool obscurePassword;
  @override
  final bool resendOtp;
  @override
  final String? otp;
  @override
  final int remainingSeconds;
  @override
  final String editName;
  @override
  final String editEmail;
  @override
  final String editPhoneNumber;
  @override
  final XFile? editImage;
  @override
  final String? editImageStr;
  @override
  final String nameErrorMessage;
  @override
  final String emailErrorMessage;
  @override
  final String phoneErrorMessage;
  @override
  final String passwordErrorMessage;
  @override
  final bool updateProfileButtonEnabled;
  @override
  final bool confirmButtonEnabled;
  @override
  final ApiState<void> updateProfileApi;
  @override
  final ApiState<void> callOtpApi;
  @override
  final ApiState<void> validatePasswordApi;

  factory _$UserProfileState(
          [void Function(UserProfileStateBuilder)? updates]) =>
      (UserProfileStateBuilder()..update(updates))._build();

  _$UserProfileState._(
      {required this.isProfileEditing,
      this.fromGallery,
      required this.clearOtp,
      required this.otpError,
      required this.countryCode,
      required this.userPassword,
      required this.validatePassword,
      required this.obscurePassword,
      required this.resendOtp,
      this.otp,
      required this.remainingSeconds,
      required this.editName,
      required this.editEmail,
      required this.editPhoneNumber,
      this.editImage,
      this.editImageStr,
      required this.nameErrorMessage,
      required this.emailErrorMessage,
      required this.phoneErrorMessage,
      required this.passwordErrorMessage,
      required this.updateProfileButtonEnabled,
      required this.confirmButtonEnabled,
      required this.updateProfileApi,
      required this.callOtpApi,
      required this.validatePasswordApi})
      : super._();
  @override
  UserProfileState rebuild(void Function(UserProfileStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserProfileStateBuilder toBuilder() =>
      UserProfileStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserProfileState &&
        isProfileEditing == other.isProfileEditing &&
        fromGallery == other.fromGallery &&
        clearOtp == other.clearOtp &&
        otpError == other.otpError &&
        countryCode == other.countryCode &&
        userPassword == other.userPassword &&
        validatePassword == other.validatePassword &&
        obscurePassword == other.obscurePassword &&
        resendOtp == other.resendOtp &&
        otp == other.otp &&
        remainingSeconds == other.remainingSeconds &&
        editName == other.editName &&
        editEmail == other.editEmail &&
        editPhoneNumber == other.editPhoneNumber &&
        editImage == other.editImage &&
        editImageStr == other.editImageStr &&
        nameErrorMessage == other.nameErrorMessage &&
        emailErrorMessage == other.emailErrorMessage &&
        phoneErrorMessage == other.phoneErrorMessage &&
        passwordErrorMessage == other.passwordErrorMessage &&
        updateProfileButtonEnabled == other.updateProfileButtonEnabled &&
        confirmButtonEnabled == other.confirmButtonEnabled &&
        updateProfileApi == other.updateProfileApi &&
        callOtpApi == other.callOtpApi &&
        validatePasswordApi == other.validatePasswordApi;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isProfileEditing.hashCode);
    _$hash = $jc(_$hash, fromGallery.hashCode);
    _$hash = $jc(_$hash, clearOtp.hashCode);
    _$hash = $jc(_$hash, otpError.hashCode);
    _$hash = $jc(_$hash, countryCode.hashCode);
    _$hash = $jc(_$hash, userPassword.hashCode);
    _$hash = $jc(_$hash, validatePassword.hashCode);
    _$hash = $jc(_$hash, obscurePassword.hashCode);
    _$hash = $jc(_$hash, resendOtp.hashCode);
    _$hash = $jc(_$hash, otp.hashCode);
    _$hash = $jc(_$hash, remainingSeconds.hashCode);
    _$hash = $jc(_$hash, editName.hashCode);
    _$hash = $jc(_$hash, editEmail.hashCode);
    _$hash = $jc(_$hash, editPhoneNumber.hashCode);
    _$hash = $jc(_$hash, editImage.hashCode);
    _$hash = $jc(_$hash, editImageStr.hashCode);
    _$hash = $jc(_$hash, nameErrorMessage.hashCode);
    _$hash = $jc(_$hash, emailErrorMessage.hashCode);
    _$hash = $jc(_$hash, phoneErrorMessage.hashCode);
    _$hash = $jc(_$hash, passwordErrorMessage.hashCode);
    _$hash = $jc(_$hash, updateProfileButtonEnabled.hashCode);
    _$hash = $jc(_$hash, confirmButtonEnabled.hashCode);
    _$hash = $jc(_$hash, updateProfileApi.hashCode);
    _$hash = $jc(_$hash, callOtpApi.hashCode);
    _$hash = $jc(_$hash, validatePasswordApi.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserProfileState')
          ..add('isProfileEditing', isProfileEditing)
          ..add('fromGallery', fromGallery)
          ..add('clearOtp', clearOtp)
          ..add('otpError', otpError)
          ..add('countryCode', countryCode)
          ..add('userPassword', userPassword)
          ..add('validatePassword', validatePassword)
          ..add('obscurePassword', obscurePassword)
          ..add('resendOtp', resendOtp)
          ..add('otp', otp)
          ..add('remainingSeconds', remainingSeconds)
          ..add('editName', editName)
          ..add('editEmail', editEmail)
          ..add('editPhoneNumber', editPhoneNumber)
          ..add('editImage', editImage)
          ..add('editImageStr', editImageStr)
          ..add('nameErrorMessage', nameErrorMessage)
          ..add('emailErrorMessage', emailErrorMessage)
          ..add('phoneErrorMessage', phoneErrorMessage)
          ..add('passwordErrorMessage', passwordErrorMessage)
          ..add('updateProfileButtonEnabled', updateProfileButtonEnabled)
          ..add('confirmButtonEnabled', confirmButtonEnabled)
          ..add('updateProfileApi', updateProfileApi)
          ..add('callOtpApi', callOtpApi)
          ..add('validatePasswordApi', validatePasswordApi))
        .toString();
  }
}

class UserProfileStateBuilder
    implements Builder<UserProfileState, UserProfileStateBuilder> {
  _$UserProfileState? _$v;

  bool? _isProfileEditing;
  bool? get isProfileEditing => _$this._isProfileEditing;
  set isProfileEditing(bool? isProfileEditing) =>
      _$this._isProfileEditing = isProfileEditing;

  bool? _fromGallery;
  bool? get fromGallery => _$this._fromGallery;
  set fromGallery(bool? fromGallery) => _$this._fromGallery = fromGallery;

  bool? _clearOtp;
  bool? get clearOtp => _$this._clearOtp;
  set clearOtp(bool? clearOtp) => _$this._clearOtp = clearOtp;

  String? _otpError;
  String? get otpError => _$this._otpError;
  set otpError(String? otpError) => _$this._otpError = otpError;

  String? _countryCode;
  String? get countryCode => _$this._countryCode;
  set countryCode(String? countryCode) => _$this._countryCode = countryCode;

  String? _userPassword;
  String? get userPassword => _$this._userPassword;
  set userPassword(String? userPassword) => _$this._userPassword = userPassword;

  String? _validatePassword;
  String? get validatePassword => _$this._validatePassword;
  set validatePassword(String? validatePassword) =>
      _$this._validatePassword = validatePassword;

  bool? _obscurePassword;
  bool? get obscurePassword => _$this._obscurePassword;
  set obscurePassword(bool? obscurePassword) =>
      _$this._obscurePassword = obscurePassword;

  bool? _resendOtp;
  bool? get resendOtp => _$this._resendOtp;
  set resendOtp(bool? resendOtp) => _$this._resendOtp = resendOtp;

  String? _otp;
  String? get otp => _$this._otp;
  set otp(String? otp) => _$this._otp = otp;

  int? _remainingSeconds;
  int? get remainingSeconds => _$this._remainingSeconds;
  set remainingSeconds(int? remainingSeconds) =>
      _$this._remainingSeconds = remainingSeconds;

  String? _editName;
  String? get editName => _$this._editName;
  set editName(String? editName) => _$this._editName = editName;

  String? _editEmail;
  String? get editEmail => _$this._editEmail;
  set editEmail(String? editEmail) => _$this._editEmail = editEmail;

  String? _editPhoneNumber;
  String? get editPhoneNumber => _$this._editPhoneNumber;
  set editPhoneNumber(String? editPhoneNumber) =>
      _$this._editPhoneNumber = editPhoneNumber;

  XFile? _editImage;
  XFile? get editImage => _$this._editImage;
  set editImage(XFile? editImage) => _$this._editImage = editImage;

  String? _editImageStr;
  String? get editImageStr => _$this._editImageStr;
  set editImageStr(String? editImageStr) => _$this._editImageStr = editImageStr;

  String? _nameErrorMessage;
  String? get nameErrorMessage => _$this._nameErrorMessage;
  set nameErrorMessage(String? nameErrorMessage) =>
      _$this._nameErrorMessage = nameErrorMessage;

  String? _emailErrorMessage;
  String? get emailErrorMessage => _$this._emailErrorMessage;
  set emailErrorMessage(String? emailErrorMessage) =>
      _$this._emailErrorMessage = emailErrorMessage;

  String? _phoneErrorMessage;
  String? get phoneErrorMessage => _$this._phoneErrorMessage;
  set phoneErrorMessage(String? phoneErrorMessage) =>
      _$this._phoneErrorMessage = phoneErrorMessage;

  String? _passwordErrorMessage;
  String? get passwordErrorMessage => _$this._passwordErrorMessage;
  set passwordErrorMessage(String? passwordErrorMessage) =>
      _$this._passwordErrorMessage = passwordErrorMessage;

  bool? _updateProfileButtonEnabled;
  bool? get updateProfileButtonEnabled => _$this._updateProfileButtonEnabled;
  set updateProfileButtonEnabled(bool? updateProfileButtonEnabled) =>
      _$this._updateProfileButtonEnabled = updateProfileButtonEnabled;

  bool? _confirmButtonEnabled;
  bool? get confirmButtonEnabled => _$this._confirmButtonEnabled;
  set confirmButtonEnabled(bool? confirmButtonEnabled) =>
      _$this._confirmButtonEnabled = confirmButtonEnabled;

  ApiStateBuilder<void>? _updateProfileApi;
  ApiStateBuilder<void> get updateProfileApi =>
      _$this._updateProfileApi ??= ApiStateBuilder<void>();
  set updateProfileApi(ApiStateBuilder<void>? updateProfileApi) =>
      _$this._updateProfileApi = updateProfileApi;

  ApiStateBuilder<void>? _callOtpApi;
  ApiStateBuilder<void> get callOtpApi =>
      _$this._callOtpApi ??= ApiStateBuilder<void>();
  set callOtpApi(ApiStateBuilder<void>? callOtpApi) =>
      _$this._callOtpApi = callOtpApi;

  ApiStateBuilder<void>? _validatePasswordApi;
  ApiStateBuilder<void> get validatePasswordApi =>
      _$this._validatePasswordApi ??= ApiStateBuilder<void>();
  set validatePasswordApi(ApiStateBuilder<void>? validatePasswordApi) =>
      _$this._validatePasswordApi = validatePasswordApi;

  UserProfileStateBuilder() {
    UserProfileState._initialize(this);
  }

  UserProfileStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isProfileEditing = $v.isProfileEditing;
      _fromGallery = $v.fromGallery;
      _clearOtp = $v.clearOtp;
      _otpError = $v.otpError;
      _countryCode = $v.countryCode;
      _userPassword = $v.userPassword;
      _validatePassword = $v.validatePassword;
      _obscurePassword = $v.obscurePassword;
      _resendOtp = $v.resendOtp;
      _otp = $v.otp;
      _remainingSeconds = $v.remainingSeconds;
      _editName = $v.editName;
      _editEmail = $v.editEmail;
      _editPhoneNumber = $v.editPhoneNumber;
      _editImage = $v.editImage;
      _editImageStr = $v.editImageStr;
      _nameErrorMessage = $v.nameErrorMessage;
      _emailErrorMessage = $v.emailErrorMessage;
      _phoneErrorMessage = $v.phoneErrorMessage;
      _passwordErrorMessage = $v.passwordErrorMessage;
      _updateProfileButtonEnabled = $v.updateProfileButtonEnabled;
      _confirmButtonEnabled = $v.confirmButtonEnabled;
      _updateProfileApi = $v.updateProfileApi.toBuilder();
      _callOtpApi = $v.callOtpApi.toBuilder();
      _validatePasswordApi = $v.validatePasswordApi.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserProfileState other) {
    _$v = other as _$UserProfileState;
  }

  @override
  void update(void Function(UserProfileStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserProfileState build() => _build();

  _$UserProfileState _build() {
    _$UserProfileState _$result;
    try {
      _$result = _$v ??
          _$UserProfileState._(
            isProfileEditing: BuiltValueNullFieldError.checkNotNull(
                isProfileEditing, r'UserProfileState', 'isProfileEditing'),
            fromGallery: fromGallery,
            clearOtp: BuiltValueNullFieldError.checkNotNull(
                clearOtp, r'UserProfileState', 'clearOtp'),
            otpError: BuiltValueNullFieldError.checkNotNull(
                otpError, r'UserProfileState', 'otpError'),
            countryCode: BuiltValueNullFieldError.checkNotNull(
                countryCode, r'UserProfileState', 'countryCode'),
            userPassword: BuiltValueNullFieldError.checkNotNull(
                userPassword, r'UserProfileState', 'userPassword'),
            validatePassword: BuiltValueNullFieldError.checkNotNull(
                validatePassword, r'UserProfileState', 'validatePassword'),
            obscurePassword: BuiltValueNullFieldError.checkNotNull(
                obscurePassword, r'UserProfileState', 'obscurePassword'),
            resendOtp: BuiltValueNullFieldError.checkNotNull(
                resendOtp, r'UserProfileState', 'resendOtp'),
            otp: otp,
            remainingSeconds: BuiltValueNullFieldError.checkNotNull(
                remainingSeconds, r'UserProfileState', 'remainingSeconds'),
            editName: BuiltValueNullFieldError.checkNotNull(
                editName, r'UserProfileState', 'editName'),
            editEmail: BuiltValueNullFieldError.checkNotNull(
                editEmail, r'UserProfileState', 'editEmail'),
            editPhoneNumber: BuiltValueNullFieldError.checkNotNull(
                editPhoneNumber, r'UserProfileState', 'editPhoneNumber'),
            editImage: editImage,
            editImageStr: editImageStr,
            nameErrorMessage: BuiltValueNullFieldError.checkNotNull(
                nameErrorMessage, r'UserProfileState', 'nameErrorMessage'),
            emailErrorMessage: BuiltValueNullFieldError.checkNotNull(
                emailErrorMessage, r'UserProfileState', 'emailErrorMessage'),
            phoneErrorMessage: BuiltValueNullFieldError.checkNotNull(
                phoneErrorMessage, r'UserProfileState', 'phoneErrorMessage'),
            passwordErrorMessage: BuiltValueNullFieldError.checkNotNull(
                passwordErrorMessage,
                r'UserProfileState',
                'passwordErrorMessage'),
            updateProfileButtonEnabled: BuiltValueNullFieldError.checkNotNull(
                updateProfileButtonEnabled,
                r'UserProfileState',
                'updateProfileButtonEnabled'),
            confirmButtonEnabled: BuiltValueNullFieldError.checkNotNull(
                confirmButtonEnabled,
                r'UserProfileState',
                'confirmButtonEnabled'),
            updateProfileApi: updateProfileApi.build(),
            callOtpApi: callOtpApi.build(),
            validatePasswordApi: validatePasswordApi.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'updateProfileApi';
        updateProfileApi.build();
        _$failedField = 'callOtpApi';
        callOtpApi.build();
        _$failedField = 'validatePasswordApi';
        validatePasswordApi.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserProfileState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
