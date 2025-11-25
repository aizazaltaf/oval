import 'package:admin/models/states/api_state.dart';
import 'package:built_value/built_value.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'user_profile_state.g.dart';

abstract class UserProfileState
    implements Built<UserProfileState, UserProfileStateBuilder> {
  factory UserProfileState([
    final void Function(UserProfileStateBuilder) updates,
  ]) = _$UserProfileState;

  UserProfileState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final UserProfileStateBuilder b) => b
    ..isProfileEditing = false
    ..updateProfileButtonEnabled = false
    ..confirmButtonEnabled = false
    ..obscurePassword = true
    ..remainingSeconds = 60
    ..clearOtp = false
    ..otpError = ""
    ..resendOtp = false
    ..fromGallery
    ..editName = ""
    ..editEmail = ""
    ..countryCode = ""
    ..editPhoneNumber = ""
    ..nameErrorMessage = ""
    ..userPassword = ""
    ..validatePassword = ""
    ..emailErrorMessage = ""
    ..phoneErrorMessage = ""
    ..passwordErrorMessage = "";

  @BlocUpdateField()
  bool get isProfileEditing;

  @BlocUpdateField()
  bool? get fromGallery;

  @BlocUpdateField()
  bool get clearOtp;

  @BlocUpdateField()
  String get otpError;

  @BlocUpdateField()
  String get countryCode;

  @BlocUpdateField()
  String get userPassword;

  @BlocUpdateField()
  String get validatePassword;

  @BlocUpdateField()
  bool get obscurePassword;

  @BlocUpdateField()
  bool get resendOtp;

  @BlocUpdateField()
  String? get otp;

  @BlocUpdateField()
  int get remainingSeconds;

  @BlocUpdateField()
  String get editName;

  @BlocUpdateField()
  String get editEmail;

  @BlocUpdateField()
  String get editPhoneNumber;

  @BlocUpdateField()
  XFile? get editImage;

  @BlocUpdateField()
  String? get editImageStr;

  @BlocUpdateField()
  String get nameErrorMessage;

  @BlocUpdateField()
  String get emailErrorMessage;

  @BlocUpdateField()
  String get phoneErrorMessage;

  @BlocUpdateField()
  String get passwordErrorMessage;

  @BlocUpdateField()
  bool get updateProfileButtonEnabled;

  @BlocUpdateField()
  bool get confirmButtonEnabled;

  ApiState<void> get updateProfileApi;

  ApiState<void> get callOtpApi;

  ApiState<void> get validatePasswordApi;
}
