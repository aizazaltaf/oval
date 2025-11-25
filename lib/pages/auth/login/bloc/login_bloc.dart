import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/api_meta_data.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/auth/login/bloc/login_state.dart';
import 'package:admin/pages/main/chat/bloc/chat_bloc.dart';
import 'package:admin/pages/main/device_onboarding/bloc/device_onboarding_bloc.dart';
import 'package:admin/pages/main/doorbell_management/bloc/doorbell_management_bloc.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/locations/bloc/location_bloc.dart';
import 'package:admin/pages/main/logout/bloc/logout_bloc.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/statistics/bloc/statistics_bloc.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_bloc.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/change_password_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/utils/dio.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'login_bloc.bloc.g.dart';

final logger = Logger("login");

@BlocGen()
class LoginBloc extends BVCubit<LoginState, LoginStateBuilder>
    with _LoginBlocMixin {
  LoginBloc({
    required final ProfileBloc profileBloc,
  })  : _profileBloc = profileBloc,
        super(LoginState());

  factory LoginBloc.of(final BuildContext context) =>
      BlocProvider.of<LoginBloc>(context);
  final ProfileBloc _profileBloc;

  final TextEditingController otpController = TextEditingController();

  final hasUpperCase = RegExp(r'[A-Z]');
  final hasLowerCase = RegExp(r'[a-z]');
  final hasNumber = RegExp(r'[0-9]');
  final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  final isAtLeast8Chars = 8;

  List<SingleChildWidget> providers = [
    BlocProvider(
      create: (final _) => UserProfileBloc(),
    ),
    BlocProvider(
      create: (final _) => VisitorManagementBloc(),
    ),
    BlocProvider(
      create: (final _) => StatisticsBloc(),
    ),
    BlocProvider(
      create: (final _) => VoipBloc(),
    ),
    BlocProvider(
      create: (final _) => ChangePasswordBloc(),
    ),
    BlocProvider(
      create: (final _) => DoorbellManagementBloc(),
    ),
    BlocProvider(
      create: (final _) => NotificationBloc(),
    ),
    BlocProvider(
      create: (final _) => UserManagementBloc(),
    ),
    BlocProvider(
      create: (final _) => ThemeBloc(),
    ),
    BlocProvider(
      create: (final _) => LogoutBloc(),
    ),
    BlocProvider(
      create: (final _) => LocationBloc(),
    ),
    // BlocProvider(
    //   create: (final _) => IotBloc(),
    // ),
    BlocProvider(
      create: (final _) => VoiceControlBloc(),
    ),
    BlocProvider(
      create: (final _) => SubscriptionBloc(),
    ),
    BlocProvider(
      create: (final _) => ChatBloc(),
    ),
    BlocProvider(
      create: (final _) => DeviceOnboardingBloc(),
    ),
  ];

  @override
  void $onUpdateEmail() {
    if (state.email.isEmpty || state.password.isEmpty) {
      updateIsLoginEnabled(false);
    } else if (passwordValidator() &&
        Constants.emailRegex.hasMatch(state.email) &&
        state.password.isNotEmpty) {
      updateIsLoginEnabled(true);
    } else {
      updateIsLoginEnabled(false);
    }

    if (passwordValidator() &&
        Constants.emailRegex.hasMatch(state.email) &&
        state.name!.isNotEmpty &&
        state.phoneNumber!.isNotEmpty &&
        state.password == state.confirmPassword &&
        state.checkBox) {
      updateIsSignupEnabled(true);
    } else {
      updateIsSignupEnabled(false);
    }
    emit(state.rebuild((final b) => b.loginApi.error = null));
  }

  @override
  void $onUpdateForgotEmail() {
    if (Constants.emailRegex.hasMatch(state.forgotEmail)) {
      updateIsForgotEnabled(true);
    } else {
      updateIsForgotEnabled(false);
    }
    emit(state.rebuild((final b) => b.loginApi.error = null));
  }

  @override
  void $onUpdatePassword() {
    // Regular expressions for validation

    int score = 0;

    if (state.password.length >= isAtLeast8Chars) {
      score++;
    }
    if (hasUpperCase.hasMatch(state.password)) {
      score++;
    }
    if (hasLowerCase.hasMatch(state.password)) {
      score++;
    }
    if (hasNumber.hasMatch(state.password)) {
      score++;
    }
    if (hasSpecialChar.hasMatch(state.password)) {
      score++;
    }
    double? strength;
    String? strengthLabel;
    Color? strengthColor;
    // Update strength based on score
    // setState(() {
    if (score == 0) {
      strength = 0.0;
      strengthLabel = 'Too short';
      strengthColor = Colors.grey;
    } else if (score <= 2) {
      strength = 0.25;
      strengthLabel = 'Weak';
      strengthColor = Colors.red;
    } else if (score == 3) {
      strength = 0.5;
      strengthLabel = 'Medium';
      strengthColor = Colors.orange;
    } else if (score == 4) {
      strength = 0.75;
      strengthLabel = 'Strong';
      strengthColor = Colors.lightGreen;
    } else if (score == 5) {
      strength = 1.0;
      strengthLabel = 'Very Strong';
      strengthColor = Colors.green;
    }
    if (state.email.isEmpty || state.password.isEmpty) {
      updateIsLoginEnabled(false);
    }
    if (strength != null &&
        strength >= 1.0 &&
        Constants.emailRegex.hasMatch(state.email) &&
        state.password.isNotEmpty) {
      updateIsLoginEnabled(true);
    } else if (Constants.emailRegex.hasMatch(state.email)) {
      updateIsLoginEnabled(false);
    } else if (Constants.passwordRegex.hasMatch(state.password)) {
      updateIsLoginEnabled(false);
    }
    if (strength != null &&
        passwordValidator() &&
        Constants.emailRegex.hasMatch(state.email) &&
        state.name!.isNotEmpty &&
        state.phoneNumber!.isNotEmpty &&
        state.password == state.confirmPassword &&
        state.checkBox) {
      updateIsSignupEnabled(true);
    } else {
      updateIsSignupEnabled(false);
    }
    // });
    emit(
      state.rebuild(
        (final b) => b
          ..loginApi.error = null
          ..strengthLabel = strengthLabel
          ..strength = strength
          ..strengthColor = strengthColor,
      ),
    );
  }

  @override
  void $onUpdateConfirmPassword() {
    // implement $onUpdateConfirmPassword
    if (passwordValidator() &&
        Constants.emailRegex.hasMatch(state.email) &&
        state.name!.isNotEmpty &&
        state.phoneNumber!.isNotEmpty &&
        state.password == state.confirmPassword &&
        state.checkBox) {
      updateIsSignupEnabled(true);
    } else {
      updateIsSignupEnabled(false);
    }
  }

  bool passwordValidator() {
    return state.password.length >= isAtLeast8Chars &&
        hasUpperCase.hasMatch(state.password) &&
        hasLowerCase.hasMatch(state.password) &&
        hasNumber.hasMatch(state.password) &&
        hasSpecialChar.hasMatch(state.password);
  }

  void onUpdateCountryCode(String countryCode) {
    // implement $onUpdateCountryCode
    super.$onUpdateCountryCode();
    emit(state.rebuild((final b) => b.countryCode = countryCode));
  }

  @override
  void $onUpdateName() {
    // implement $onUpdateName
    if (passwordValidator() &&
        Constants.emailRegex.hasMatch(state.email) &&
        state.name!.isNotEmpty &&
        state.phoneNumber!.isNotEmpty &&
        state.password == state.confirmPassword &&
        state.checkBox) {
      updateIsSignupEnabled(true);
    } else {
      updateIsSignupEnabled(false);
    }
  }

  @override
  void $onUpdatePhoneNumber() {
    // implement $onUpdatePhoneNumber
    if (passwordValidator() &&
        Constants.emailRegex.hasMatch(state.email) &&
        state.name!.isNotEmpty &&
        state.phoneNumber!.isNotEmpty &&
        state.password == state.confirmPassword &&
        state.checkBox) {
      updateIsSignupEnabled(true);
    } else {
      updateIsSignupEnabled(false);
    }
  }

  @override
  void $onUpdateCheckBox() {
    // implement $onUpdateCheckBox
    if (passwordValidator() &&
        Constants.emailRegex.hasMatch(state.email) &&
        state.name!.isNotEmpty &&
        state.phoneNumber!.isNotEmpty &&
        state.password == state.confirmPassword &&
        state.checkBox) {
      updateIsSignupEnabled(true);
    } else {
      updateIsSignupEnabled(false);
    }
  }

  void reInitializeState() {
    emit(state.rebuild((final b) => b.loginApi.error = null));
    emit(
      state.rebuild(
        (final b) => b
          ..name = ''
          ..forgotEmail = ''
          ..passwordField!.clear()
          ..emailField!.clear()
          ..forgetPasswordApi.replace(ApiState())
          ..signUpApi.replace(ApiState())
          ..email = ""
          ..password = ''
          ..confirmPassword = ''
          ..phoneNumber = ''
          ..checkBox = false
          ..resendOtp = false
          ..isLoginEnabled = false
          ..isForgotEnabled = false
          ..isSignupEnabled = false
          ..obscureText = true
          ..obscureTextSignupPassword = true
          ..obscureTextSignupConfirmPassword = true
          ..strength = 0.0
          ..remainingSeconds = 60
          ..loginApi.error = null
          ..loginApi.replace(ApiState())
          ..strengthLabel = 'Too short'
          ..strengthColor = Colors.grey
          ..countryCode = "+1",
      ),
    );
  }

  Future<void> callLogout({required VoidCallback successFunction}) async {
    return CubitUtils.makeApiCall<LoginState, LoginStateBuilder, void>(
      cubit: this,
      apiState: state.logoutApi,
      updateApiState: (final b, final apiState) =>
          b.logoutApi.replace(apiState),
      callApi: () async {
        final String? deviceToken = await CommonFunctions.getDeviceToken();
        await apiService.logoutOfSpecificDevice(
          deviceToken: deviceToken ?? '',
          sendPushNotification: false,
        );
        successFunction();
      },
    );
  }

  Future<void> callLogin(BuildContext context) {
    return CubitUtils.makeApiCall<LoginState, LoginStateBuilder, void>(
      cubit: this,
      apiState: state.loginApi,
      onError: (error) {
        if (error is DioExceptionType &&
            error == DioExceptionType.connectionError) {
          ToastUtils.errorToast(
            "No internet connection. Please check your network and try again.",
          );
          return;
        } else if (error is DioException && error.response != null) {
          if (error.response == null) {
            return;
          }
          if (error.response!.data["code"] == 8011) {
            showDialog(
              context: context,
              builder: (context) {
                emit(
                  state.rebuild((e) => e.loginApi.error.replace(ApiMetaData())),
                );

                return AppDialogPopup(
                  headerWidget: Image.asset(
                    DefaultImages.EMAIL_VERIFICATION_IMAGE,
                    height: 120,
                    width: 160,
                  ),
                  title: context.appLocalizations.email_not_verified,
                  description: context.appLocalizations.resend_dialog_text,
                  confirmButtonLabel:
                      context.appLocalizations.resend_email_verification,
                  confirmButtonOnTap: () {
                    Navigator.pop(context);
                    callResendEmail();
                  },
                );
              },
            );
          }
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
      },
      updateApiState: (final b, final apiState) => b.loginApi.replace(apiState),
      callApi: () async {
        // final bloc = IotBloc.of(context);
        final UserData data = await apiService.login(
          email: state.email,
          password: state.password,
        );
        logger.fine("Login response: $providers");

        providers
          ..add(
            BlocProvider(
              lazy: false,
              create: (final _) => StartupBloc(),
            ),
          )
          ..add(
            BlocProvider(
              lazy: false,
              create: (final _) => IotBloc(),
            ),
          );
        _profileBloc.updateProfile(data);

        final UserData userDetail = await apiService.getUserDetail();
        // Future.delayed(const Duration(seconds: 6), bloc.iotInitializer);

        _profileBloc.updateProfile(
          userDetail.rebuild(
            (b) => b
              ..apiToken = _profileBloc.state!.apiToken
              ..refreshToken = _profileBloc.state!.refreshToken,
          ),
        );
        reInitializeState();
        await singletonBloc.getBox.erase();
      },
    );
  }

  Future<void> callResendEmail() {
    return CubitUtils.makeApiCall<LoginState, LoginStateBuilder, void>(
      cubit: this,
      apiState: state.resendApi,
      updateApiState: (final b, final apiState) =>
          b.resendApi.replace(apiState),
      callApi: () async {
        await apiService.resendEmail(email: state.email);
      },
    );
  }

  Future<void> callValidateEmail({required VoidCallback successFunction}) {
    return CubitUtils.makeApiCall<LoginState, LoginStateBuilder, void>(
      cubit: this,
      apiState: state.validateEmailApi,
      updateApiState: (final b, final apiState) =>
          b.validateEmailApi.replace(apiState),
      onError: (e) {
        ToastUtils.errorToast("Account already registered");
        updateSignUpLoading(false);
      },
      callApi: () async {
        await apiService.validateEmail(state.email);
        successFunction();
      },
    );
  }

  Timer? _timer;

  Future<void> callSignup() {
    return CubitUtils.makeApiCall<LoginState, LoginStateBuilder, void>(
      cubit: this,
      apiState: state.signUpApi,
      updateApiState: (final b, final apiState) =>
          b.signUpApi.replace(apiState),
      callApi: () async {
        final String phone =
            "${state.countryCode}${state.phoneNumber}".replaceAll("-", "");
        // bool data = await apiService.validateUserDetails(
        //     email: state.email, phoneNumber: phone);
        // if (data) {
        await apiService.sendOTPOnPhoneNumber(
          email: state.email,
          phoneNumber: phone,
        );
        updateRemainingSeconds(60);
        updateResendOtp(false);

        _timer?.cancel(); // Cancel any existing timer
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (state.remainingSeconds > 0) {
            updateRemainingSeconds(state.remainingSeconds - 1);
            updateResendOtp(false);
          } else {
            timer.cancel();

            updateResendOtp(true);
          }
        });
        // }
      },
    );
  }

  Future<void> callOtp(BuildContext context) {
    return CubitUtils.makeApiCall<LoginState, LoginStateBuilder, void>(
      cubit: this,
      apiState: state.otpApi,
      updateApiState: (final b, final apiState) => b.otpApi.replace(apiState),
      onError: (error) {
        if (error is DioException && error.response != null) {
          otpController.clear();
          updateOtpError(error.response!.data["message"]);
          updateClearOtp(true);
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
      },
      callApi: () async {
        final String phone =
            "${state.countryCode}${state.phoneNumber}".replaceAll("-", "");
        final data = await apiService.verifyOtp(
          otp: state.otp!,
          phoneNumber: phone,
          email: state.email,
        );
        otpController.clear();
        updateOtpError("");
        updateClearOtp(true);
        ToastUtils.successToast(data.data['message']);

        if (data.statusCode == 200) {
          await apiService.signup(
            name: state.name,
            email: state.email,
            password: state.password,
            phone: phone,
            // address: ""
          );
        }
      },
    );
  }

  Future<void> callForgotPassword({required VoidCallback successFunction}) {
    return CubitUtils.makeApiCall<LoginState, LoginStateBuilder, void>(
      cubit: this,
      apiState: state.forgetPasswordApi,
      updateApiState: (final b, final apiState) =>
          b.forgetPasswordApi.replace(apiState),
      onError: (error) {
        if (error is DioException && error.response != null) {
          successFunction();
          // ToastUtils.errorToast(error.response!.data["message"]);
        } else if (error is DioException &&
            error.type != DioExceptionType.connectionError) {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
      },
      callApi: () async {
        await apiService.callForgotPassword(state.forgotEmail);
        successFunction();
      },
    );
  }
}
