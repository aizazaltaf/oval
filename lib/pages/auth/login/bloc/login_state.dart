import 'package:admin/models/states/api_state.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' as colors;
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'login_state.g.dart';

abstract class LoginState implements Built<LoginState, LoginStateBuilder> {
  factory LoginState([
    final void Function(LoginStateBuilder) updates,
  ]) = _$LoginState;

  LoginState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final LoginStateBuilder b) => b
    ..name = ''
    ..email = ''
    ..forgotEmail = ''
    ..password = ''
    ..confirmPassword = ''
    ..clearOtp = false
    ..otpError = ""
    ..phoneNumber = ''
    ..checkBox = false
    ..resendOtp = false
    ..isLoginEnabled = false
    ..isForgotEnabled = false
    ..isSignupEnabled = false
    ..obscureText = true
    ..obscureTextSignupPassword = true
    ..emailField = colors.TextEditingController()
    ..passwordField = colors.TextEditingController()
    ..obscureTextSignupConfirmPassword = true
    ..strength = 0.0
    ..remainingSeconds = 60
    ..strengthLabel = 'Too short'
    ..strengthColor = colors.Colors.grey
    ..signUpLoading = false
    ..countryCode = "+1";

  @BlocUpdateField()
  String get email;
  colors.TextEditingController get emailField;

  @BlocUpdateField()
  String get forgotEmail;

  @BlocUpdateField()
  bool get clearOtp;

  @BlocUpdateField()
  String get otpError;

  @BlocUpdateField()
  bool get isLoginEnabled;

  @BlocUpdateField()
  bool get isForgotEnabled;

  @BlocUpdateField()
  bool get isSignupEnabled;

  @BlocUpdateField()
  String get password;
  colors.TextEditingController get passwordField;

  @BlocUpdateField()
  bool get checkBox;

  @BlocUpdateField()
  String get confirmPassword;

  @BlocUpdateField()
  String get countryCode;

  @BlocUpdateField()
  String? get phoneNumber;

  @BlocUpdateField()
  String? get otp;

  @BlocUpdateField()
  String? get name;

  @BlocUpdateField()
  String get strengthLabel;

  @BlocUpdateField()
  double get strength;

  @BlocUpdateField()
  colors.Color get strengthColor;

  @BlocUpdateField()
  bool get resendOtp;

  @BlocUpdateField()
  bool get obscureText;

  @BlocUpdateField()
  bool get obscureTextSignupPassword;

  @BlocUpdateField()
  bool get signUpLoading;

  @BlocUpdateField()
  bool get obscureTextSignupConfirmPassword;

  @BlocUpdateField()
  int get remainingSeconds;

  ApiState<void> get loginApi;
  ApiState<void> get resendApi;

  ApiState<void> get signUpApi;
  ApiState<void> get otpApi;

  ApiState<void> get forgetPasswordApi;

  ApiState<void> get logoutApi;

  ApiState<void> get validateEmailApi;
}
