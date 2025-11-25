// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoginState extends LoginState {
  @override
  final String email;
  @override
  final colors.TextEditingController emailField;
  @override
  final String forgotEmail;
  @override
  final bool clearOtp;
  @override
  final String otpError;
  @override
  final bool isLoginEnabled;
  @override
  final bool isForgotEnabled;
  @override
  final bool isSignupEnabled;
  @override
  final String password;
  @override
  final colors.TextEditingController passwordField;
  @override
  final bool checkBox;
  @override
  final String confirmPassword;
  @override
  final String countryCode;
  @override
  final String? phoneNumber;
  @override
  final String? otp;
  @override
  final String? name;
  @override
  final String strengthLabel;
  @override
  final double strength;
  @override
  final colors.Color strengthColor;
  @override
  final bool resendOtp;
  @override
  final bool obscureText;
  @override
  final bool obscureTextSignupPassword;
  @override
  final bool signUpLoading;
  @override
  final bool obscureTextSignupConfirmPassword;
  @override
  final int remainingSeconds;
  @override
  final ApiState<void> loginApi;
  @override
  final ApiState<void> resendApi;
  @override
  final ApiState<void> signUpApi;
  @override
  final ApiState<void> otpApi;
  @override
  final ApiState<void> forgetPasswordApi;
  @override
  final ApiState<void> logoutApi;
  @override
  final ApiState<void> validateEmailApi;

  factory _$LoginState([void Function(LoginStateBuilder)? updates]) =>
      (LoginStateBuilder()..update(updates))._build();

  _$LoginState._(
      {required this.email,
      required this.emailField,
      required this.forgotEmail,
      required this.clearOtp,
      required this.otpError,
      required this.isLoginEnabled,
      required this.isForgotEnabled,
      required this.isSignupEnabled,
      required this.password,
      required this.passwordField,
      required this.checkBox,
      required this.confirmPassword,
      required this.countryCode,
      this.phoneNumber,
      this.otp,
      this.name,
      required this.strengthLabel,
      required this.strength,
      required this.strengthColor,
      required this.resendOtp,
      required this.obscureText,
      required this.obscureTextSignupPassword,
      required this.signUpLoading,
      required this.obscureTextSignupConfirmPassword,
      required this.remainingSeconds,
      required this.loginApi,
      required this.resendApi,
      required this.signUpApi,
      required this.otpApi,
      required this.forgetPasswordApi,
      required this.logoutApi,
      required this.validateEmailApi})
      : super._();
  @override
  LoginState rebuild(void Function(LoginStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginStateBuilder toBuilder() => LoginStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginState &&
        email == other.email &&
        emailField == other.emailField &&
        forgotEmail == other.forgotEmail &&
        clearOtp == other.clearOtp &&
        otpError == other.otpError &&
        isLoginEnabled == other.isLoginEnabled &&
        isForgotEnabled == other.isForgotEnabled &&
        isSignupEnabled == other.isSignupEnabled &&
        password == other.password &&
        passwordField == other.passwordField &&
        checkBox == other.checkBox &&
        confirmPassword == other.confirmPassword &&
        countryCode == other.countryCode &&
        phoneNumber == other.phoneNumber &&
        otp == other.otp &&
        name == other.name &&
        strengthLabel == other.strengthLabel &&
        strength == other.strength &&
        strengthColor == other.strengthColor &&
        resendOtp == other.resendOtp &&
        obscureText == other.obscureText &&
        obscureTextSignupPassword == other.obscureTextSignupPassword &&
        signUpLoading == other.signUpLoading &&
        obscureTextSignupConfirmPassword ==
            other.obscureTextSignupConfirmPassword &&
        remainingSeconds == other.remainingSeconds &&
        loginApi == other.loginApi &&
        resendApi == other.resendApi &&
        signUpApi == other.signUpApi &&
        otpApi == other.otpApi &&
        forgetPasswordApi == other.forgetPasswordApi &&
        logoutApi == other.logoutApi &&
        validateEmailApi == other.validateEmailApi;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, emailField.hashCode);
    _$hash = $jc(_$hash, forgotEmail.hashCode);
    _$hash = $jc(_$hash, clearOtp.hashCode);
    _$hash = $jc(_$hash, otpError.hashCode);
    _$hash = $jc(_$hash, isLoginEnabled.hashCode);
    _$hash = $jc(_$hash, isForgotEnabled.hashCode);
    _$hash = $jc(_$hash, isSignupEnabled.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, passwordField.hashCode);
    _$hash = $jc(_$hash, checkBox.hashCode);
    _$hash = $jc(_$hash, confirmPassword.hashCode);
    _$hash = $jc(_$hash, countryCode.hashCode);
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, otp.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, strengthLabel.hashCode);
    _$hash = $jc(_$hash, strength.hashCode);
    _$hash = $jc(_$hash, strengthColor.hashCode);
    _$hash = $jc(_$hash, resendOtp.hashCode);
    _$hash = $jc(_$hash, obscureText.hashCode);
    _$hash = $jc(_$hash, obscureTextSignupPassword.hashCode);
    _$hash = $jc(_$hash, signUpLoading.hashCode);
    _$hash = $jc(_$hash, obscureTextSignupConfirmPassword.hashCode);
    _$hash = $jc(_$hash, remainingSeconds.hashCode);
    _$hash = $jc(_$hash, loginApi.hashCode);
    _$hash = $jc(_$hash, resendApi.hashCode);
    _$hash = $jc(_$hash, signUpApi.hashCode);
    _$hash = $jc(_$hash, otpApi.hashCode);
    _$hash = $jc(_$hash, forgetPasswordApi.hashCode);
    _$hash = $jc(_$hash, logoutApi.hashCode);
    _$hash = $jc(_$hash, validateEmailApi.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoginState')
          ..add('email', email)
          ..add('emailField', emailField)
          ..add('forgotEmail', forgotEmail)
          ..add('clearOtp', clearOtp)
          ..add('otpError', otpError)
          ..add('isLoginEnabled', isLoginEnabled)
          ..add('isForgotEnabled', isForgotEnabled)
          ..add('isSignupEnabled', isSignupEnabled)
          ..add('password', password)
          ..add('passwordField', passwordField)
          ..add('checkBox', checkBox)
          ..add('confirmPassword', confirmPassword)
          ..add('countryCode', countryCode)
          ..add('phoneNumber', phoneNumber)
          ..add('otp', otp)
          ..add('name', name)
          ..add('strengthLabel', strengthLabel)
          ..add('strength', strength)
          ..add('strengthColor', strengthColor)
          ..add('resendOtp', resendOtp)
          ..add('obscureText', obscureText)
          ..add('obscureTextSignupPassword', obscureTextSignupPassword)
          ..add('signUpLoading', signUpLoading)
          ..add('obscureTextSignupConfirmPassword',
              obscureTextSignupConfirmPassword)
          ..add('remainingSeconds', remainingSeconds)
          ..add('loginApi', loginApi)
          ..add('resendApi', resendApi)
          ..add('signUpApi', signUpApi)
          ..add('otpApi', otpApi)
          ..add('forgetPasswordApi', forgetPasswordApi)
          ..add('logoutApi', logoutApi)
          ..add('validateEmailApi', validateEmailApi))
        .toString();
  }
}

class LoginStateBuilder implements Builder<LoginState, LoginStateBuilder> {
  _$LoginState? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  colors.TextEditingController? _emailField;
  colors.TextEditingController? get emailField => _$this._emailField;
  set emailField(colors.TextEditingController? emailField) =>
      _$this._emailField = emailField;

  String? _forgotEmail;
  String? get forgotEmail => _$this._forgotEmail;
  set forgotEmail(String? forgotEmail) => _$this._forgotEmail = forgotEmail;

  bool? _clearOtp;
  bool? get clearOtp => _$this._clearOtp;
  set clearOtp(bool? clearOtp) => _$this._clearOtp = clearOtp;

  String? _otpError;
  String? get otpError => _$this._otpError;
  set otpError(String? otpError) => _$this._otpError = otpError;

  bool? _isLoginEnabled;
  bool? get isLoginEnabled => _$this._isLoginEnabled;
  set isLoginEnabled(bool? isLoginEnabled) =>
      _$this._isLoginEnabled = isLoginEnabled;

  bool? _isForgotEnabled;
  bool? get isForgotEnabled => _$this._isForgotEnabled;
  set isForgotEnabled(bool? isForgotEnabled) =>
      _$this._isForgotEnabled = isForgotEnabled;

  bool? _isSignupEnabled;
  bool? get isSignupEnabled => _$this._isSignupEnabled;
  set isSignupEnabled(bool? isSignupEnabled) =>
      _$this._isSignupEnabled = isSignupEnabled;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  colors.TextEditingController? _passwordField;
  colors.TextEditingController? get passwordField => _$this._passwordField;
  set passwordField(colors.TextEditingController? passwordField) =>
      _$this._passwordField = passwordField;

  bool? _checkBox;
  bool? get checkBox => _$this._checkBox;
  set checkBox(bool? checkBox) => _$this._checkBox = checkBox;

  String? _confirmPassword;
  String? get confirmPassword => _$this._confirmPassword;
  set confirmPassword(String? confirmPassword) =>
      _$this._confirmPassword = confirmPassword;

  String? _countryCode;
  String? get countryCode => _$this._countryCode;
  set countryCode(String? countryCode) => _$this._countryCode = countryCode;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  String? _otp;
  String? get otp => _$this._otp;
  set otp(String? otp) => _$this._otp = otp;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

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

  bool? _resendOtp;
  bool? get resendOtp => _$this._resendOtp;
  set resendOtp(bool? resendOtp) => _$this._resendOtp = resendOtp;

  bool? _obscureText;
  bool? get obscureText => _$this._obscureText;
  set obscureText(bool? obscureText) => _$this._obscureText = obscureText;

  bool? _obscureTextSignupPassword;
  bool? get obscureTextSignupPassword => _$this._obscureTextSignupPassword;
  set obscureTextSignupPassword(bool? obscureTextSignupPassword) =>
      _$this._obscureTextSignupPassword = obscureTextSignupPassword;

  bool? _signUpLoading;
  bool? get signUpLoading => _$this._signUpLoading;
  set signUpLoading(bool? signUpLoading) =>
      _$this._signUpLoading = signUpLoading;

  bool? _obscureTextSignupConfirmPassword;
  bool? get obscureTextSignupConfirmPassword =>
      _$this._obscureTextSignupConfirmPassword;
  set obscureTextSignupConfirmPassword(
          bool? obscureTextSignupConfirmPassword) =>
      _$this._obscureTextSignupConfirmPassword =
          obscureTextSignupConfirmPassword;

  int? _remainingSeconds;
  int? get remainingSeconds => _$this._remainingSeconds;
  set remainingSeconds(int? remainingSeconds) =>
      _$this._remainingSeconds = remainingSeconds;

  ApiStateBuilder<void>? _loginApi;
  ApiStateBuilder<void> get loginApi =>
      _$this._loginApi ??= ApiStateBuilder<void>();
  set loginApi(ApiStateBuilder<void>? loginApi) => _$this._loginApi = loginApi;

  ApiStateBuilder<void>? _resendApi;
  ApiStateBuilder<void> get resendApi =>
      _$this._resendApi ??= ApiStateBuilder<void>();
  set resendApi(ApiStateBuilder<void>? resendApi) =>
      _$this._resendApi = resendApi;

  ApiStateBuilder<void>? _signUpApi;
  ApiStateBuilder<void> get signUpApi =>
      _$this._signUpApi ??= ApiStateBuilder<void>();
  set signUpApi(ApiStateBuilder<void>? signUpApi) =>
      _$this._signUpApi = signUpApi;

  ApiStateBuilder<void>? _otpApi;
  ApiStateBuilder<void> get otpApi =>
      _$this._otpApi ??= ApiStateBuilder<void>();
  set otpApi(ApiStateBuilder<void>? otpApi) => _$this._otpApi = otpApi;

  ApiStateBuilder<void>? _forgetPasswordApi;
  ApiStateBuilder<void> get forgetPasswordApi =>
      _$this._forgetPasswordApi ??= ApiStateBuilder<void>();
  set forgetPasswordApi(ApiStateBuilder<void>? forgetPasswordApi) =>
      _$this._forgetPasswordApi = forgetPasswordApi;

  ApiStateBuilder<void>? _logoutApi;
  ApiStateBuilder<void> get logoutApi =>
      _$this._logoutApi ??= ApiStateBuilder<void>();
  set logoutApi(ApiStateBuilder<void>? logoutApi) =>
      _$this._logoutApi = logoutApi;

  ApiStateBuilder<void>? _validateEmailApi;
  ApiStateBuilder<void> get validateEmailApi =>
      _$this._validateEmailApi ??= ApiStateBuilder<void>();
  set validateEmailApi(ApiStateBuilder<void>? validateEmailApi) =>
      _$this._validateEmailApi = validateEmailApi;

  LoginStateBuilder() {
    LoginState._initialize(this);
  }

  LoginStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _emailField = $v.emailField;
      _forgotEmail = $v.forgotEmail;
      _clearOtp = $v.clearOtp;
      _otpError = $v.otpError;
      _isLoginEnabled = $v.isLoginEnabled;
      _isForgotEnabled = $v.isForgotEnabled;
      _isSignupEnabled = $v.isSignupEnabled;
      _password = $v.password;
      _passwordField = $v.passwordField;
      _checkBox = $v.checkBox;
      _confirmPassword = $v.confirmPassword;
      _countryCode = $v.countryCode;
      _phoneNumber = $v.phoneNumber;
      _otp = $v.otp;
      _name = $v.name;
      _strengthLabel = $v.strengthLabel;
      _strength = $v.strength;
      _strengthColor = $v.strengthColor;
      _resendOtp = $v.resendOtp;
      _obscureText = $v.obscureText;
      _obscureTextSignupPassword = $v.obscureTextSignupPassword;
      _signUpLoading = $v.signUpLoading;
      _obscureTextSignupConfirmPassword = $v.obscureTextSignupConfirmPassword;
      _remainingSeconds = $v.remainingSeconds;
      _loginApi = $v.loginApi.toBuilder();
      _resendApi = $v.resendApi.toBuilder();
      _signUpApi = $v.signUpApi.toBuilder();
      _otpApi = $v.otpApi.toBuilder();
      _forgetPasswordApi = $v.forgetPasswordApi.toBuilder();
      _logoutApi = $v.logoutApi.toBuilder();
      _validateEmailApi = $v.validateEmailApi.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginState other) {
    _$v = other as _$LoginState;
  }

  @override
  void update(void Function(LoginStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginState build() => _build();

  _$LoginState _build() {
    _$LoginState _$result;
    try {
      _$result = _$v ??
          _$LoginState._(
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'LoginState', 'email'),
            emailField: BuiltValueNullFieldError.checkNotNull(
                emailField, r'LoginState', 'emailField'),
            forgotEmail: BuiltValueNullFieldError.checkNotNull(
                forgotEmail, r'LoginState', 'forgotEmail'),
            clearOtp: BuiltValueNullFieldError.checkNotNull(
                clearOtp, r'LoginState', 'clearOtp'),
            otpError: BuiltValueNullFieldError.checkNotNull(
                otpError, r'LoginState', 'otpError'),
            isLoginEnabled: BuiltValueNullFieldError.checkNotNull(
                isLoginEnabled, r'LoginState', 'isLoginEnabled'),
            isForgotEnabled: BuiltValueNullFieldError.checkNotNull(
                isForgotEnabled, r'LoginState', 'isForgotEnabled'),
            isSignupEnabled: BuiltValueNullFieldError.checkNotNull(
                isSignupEnabled, r'LoginState', 'isSignupEnabled'),
            password: BuiltValueNullFieldError.checkNotNull(
                password, r'LoginState', 'password'),
            passwordField: BuiltValueNullFieldError.checkNotNull(
                passwordField, r'LoginState', 'passwordField'),
            checkBox: BuiltValueNullFieldError.checkNotNull(
                checkBox, r'LoginState', 'checkBox'),
            confirmPassword: BuiltValueNullFieldError.checkNotNull(
                confirmPassword, r'LoginState', 'confirmPassword'),
            countryCode: BuiltValueNullFieldError.checkNotNull(
                countryCode, r'LoginState', 'countryCode'),
            phoneNumber: phoneNumber,
            otp: otp,
            name: name,
            strengthLabel: BuiltValueNullFieldError.checkNotNull(
                strengthLabel, r'LoginState', 'strengthLabel'),
            strength: BuiltValueNullFieldError.checkNotNull(
                strength, r'LoginState', 'strength'),
            strengthColor: BuiltValueNullFieldError.checkNotNull(
                strengthColor, r'LoginState', 'strengthColor'),
            resendOtp: BuiltValueNullFieldError.checkNotNull(
                resendOtp, r'LoginState', 'resendOtp'),
            obscureText: BuiltValueNullFieldError.checkNotNull(
                obscureText, r'LoginState', 'obscureText'),
            obscureTextSignupPassword: BuiltValueNullFieldError.checkNotNull(
                obscureTextSignupPassword,
                r'LoginState',
                'obscureTextSignupPassword'),
            signUpLoading: BuiltValueNullFieldError.checkNotNull(
                signUpLoading, r'LoginState', 'signUpLoading'),
            obscureTextSignupConfirmPassword:
                BuiltValueNullFieldError.checkNotNull(
                    obscureTextSignupConfirmPassword,
                    r'LoginState',
                    'obscureTextSignupConfirmPassword'),
            remainingSeconds: BuiltValueNullFieldError.checkNotNull(
                remainingSeconds, r'LoginState', 'remainingSeconds'),
            loginApi: loginApi.build(),
            resendApi: resendApi.build(),
            signUpApi: signUpApi.build(),
            otpApi: otpApi.build(),
            forgetPasswordApi: forgetPasswordApi.build(),
            logoutApi: logoutApi.build(),
            validateEmailApi: validateEmailApi.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'loginApi';
        loginApi.build();
        _$failedField = 'resendApi';
        resendApi.build();
        _$failedField = 'signUpApi';
        signUpApi.build();
        _$failedField = 'otpApi';
        otpApi.build();
        _$failedField = 'forgetPasswordApi';
        forgetPasswordApi.build();
        _$failedField = 'logoutApi';
        logoutApi.build();
        _$failedField = 'validateEmailApi';
        validateEmailApi.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LoginState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
