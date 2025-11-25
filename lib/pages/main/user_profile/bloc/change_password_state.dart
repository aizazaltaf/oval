import 'package:admin/models/states/api_state.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' as colors;
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'change_password_state.g.dart';

abstract class ChangePasswordState
    implements Built<ChangePasswordState, ChangePasswordStateBuilder> {
  factory ChangePasswordState([
    final void Function(ChangePasswordStateBuilder) updates,
  ]) = _$ChangePasswordState;

  ChangePasswordState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final ChangePasswordStateBuilder b) => b
    ..oldPassword = ""
    ..oldPasswordError = ""
    ..oldPasswordObscure = true
    ..newPassword = ""
    ..newPasswordError = ""
    ..newPasswordObscure = true
    ..confirmPassword = ""
    ..confirmPasswordError = ""
    ..confirmPasswordObscure = true
    ..strength = 0.0
    ..strengthLabel = 'Too short'
    ..strengthColor = colors.Colors.grey[300]
    ..confirmButtonEnabled = false;

  @BlocUpdateField()
  String get oldPassword;

  @BlocUpdateField()
  bool get oldPasswordObscure;

  @BlocUpdateField()
  String get oldPasswordError;

  @BlocUpdateField()
  String get newPassword;

  @BlocUpdateField()
  bool get newPasswordObscure;

  @BlocUpdateField()
  String get newPasswordError;

  @BlocUpdateField()
  String get confirmPassword;

  @BlocUpdateField()
  bool get confirmPasswordObscure;

  @BlocUpdateField()
  String get confirmPasswordError;

  @BlocUpdateField()
  String get strengthLabel;

  @BlocUpdateField()
  double get strength;

  @BlocUpdateField()
  colors.Color get strengthColor;

  @BlocUpdateField()
  bool get confirmButtonEnabled;

  @BlocUpdateField()
  ApiState<void> get changePasswordApi;
}
