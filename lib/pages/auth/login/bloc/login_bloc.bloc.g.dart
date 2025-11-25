// ignore_for_file: type=lint, unused_element

part of 'login_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class LoginBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<LoginState>? buildWhen;
  final BlocWidgetBuilder<LoginState> builder;

  const LoginBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class LoginBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<LoginState, T> selector;
  final Widget Function(T state) builder;
  final LoginBloc? bloc;

  const LoginBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static LoginBlocSelector<String> email({
    final Key? key,
    required Widget Function(String email) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.email,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<TextEditingController> emailField({
    final Key? key,
    required Widget Function(TextEditingController emailField) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.emailField,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<String> forgotEmail({
    final Key? key,
    required Widget Function(String forgotEmail) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.forgotEmail,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<bool> clearOtp({
    final Key? key,
    required Widget Function(bool clearOtp) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.clearOtp,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<String> otpError({
    final Key? key,
    required Widget Function(String otpError) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.otpError,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<bool> isLoginEnabled({
    final Key? key,
    required Widget Function(bool isLoginEnabled) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.isLoginEnabled,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<bool> isForgotEnabled({
    final Key? key,
    required Widget Function(bool isForgotEnabled) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.isForgotEnabled,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<bool> isSignupEnabled({
    final Key? key,
    required Widget Function(bool isSignupEnabled) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.isSignupEnabled,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<String> password({
    final Key? key,
    required Widget Function(String password) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.password,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<TextEditingController> passwordField({
    final Key? key,
    required Widget Function(TextEditingController passwordField) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.passwordField,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<bool> checkBox({
    final Key? key,
    required Widget Function(bool checkBox) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.checkBox,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<String> confirmPassword({
    final Key? key,
    required Widget Function(String confirmPassword) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.confirmPassword,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<String> countryCode({
    final Key? key,
    required Widget Function(String countryCode) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.countryCode,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<String?> phoneNumber({
    final Key? key,
    required Widget Function(String? phoneNumber) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.phoneNumber,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<String?> otp({
    final Key? key,
    required Widget Function(String? otp) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.otp,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<String?> name({
    final Key? key,
    required Widget Function(String? name) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.name,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<String> strengthLabel({
    final Key? key,
    required Widget Function(String strengthLabel) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.strengthLabel,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<double> strength({
    final Key? key,
    required Widget Function(double strength) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.strength,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<Color> strengthColor({
    final Key? key,
    required Widget Function(Color strengthColor) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.strengthColor,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<bool> resendOtp({
    final Key? key,
    required Widget Function(bool resendOtp) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.resendOtp,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<bool> obscureText({
    final Key? key,
    required Widget Function(bool obscureText) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.obscureText,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<bool> obscureTextSignupPassword({
    final Key? key,
    required Widget Function(bool obscureTextSignupPassword) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.obscureTextSignupPassword,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<bool> signUpLoading({
    final Key? key,
    required Widget Function(bool signUpLoading) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.signUpLoading,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<bool> obscureTextSignupConfirmPassword({
    final Key? key,
    required Widget Function(bool obscureTextSignupConfirmPassword) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.obscureTextSignupConfirmPassword,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<int> remainingSeconds({
    final Key? key,
    required Widget Function(int remainingSeconds) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.remainingSeconds,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<ApiState<void>> loginApi({
    final Key? key,
    required Widget Function(ApiState<void> loginApi) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.loginApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<ApiState<void>> resendApi({
    final Key? key,
    required Widget Function(ApiState<void> resendApi) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.resendApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<ApiState<void>> signUpApi({
    final Key? key,
    required Widget Function(ApiState<void> signUpApi) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.signUpApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<ApiState<void>> otpApi({
    final Key? key,
    required Widget Function(ApiState<void> otpApi) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.otpApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<ApiState<void>> forgetPasswordApi({
    final Key? key,
    required Widget Function(ApiState<void> forgetPasswordApi) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.forgetPasswordApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<ApiState<void>> logoutApi({
    final Key? key,
    required Widget Function(ApiState<void> logoutApi) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.logoutApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static LoginBlocSelector<ApiState<void>> validateEmailApi({
    final Key? key,
    required Widget Function(ApiState<void> validateEmailApi) builder,
    final LoginBloc? bloc,
  }) {
    return LoginBlocSelector(
      key: key,
      selector: (state) => state.validateEmailApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<LoginBloc, LoginState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _LoginBlocMixin on Cubit<LoginState> {
  @mustCallSuper
  void updateEmail(final String email) {
    if (this.state.email == email) {
      return;
    }

    emit(this.state.rebuild((final b) => b.email = email));

    $onUpdateEmail();
  }

  @protected
  void $onUpdateEmail() {}

  @mustCallSuper
  void updateForgotEmail(final String forgotEmail) {
    if (this.state.forgotEmail == forgotEmail) {
      return;
    }

    emit(this.state.rebuild((final b) => b.forgotEmail = forgotEmail));

    $onUpdateForgotEmail();
  }

  @protected
  void $onUpdateForgotEmail() {}

  @mustCallSuper
  void updateClearOtp(final bool clearOtp) {
    if (this.state.clearOtp == clearOtp) {
      return;
    }

    emit(this.state.rebuild((final b) => b.clearOtp = clearOtp));

    $onUpdateClearOtp();
  }

  @protected
  void $onUpdateClearOtp() {}

  @mustCallSuper
  void updateOtpError(final String otpError) {
    if (this.state.otpError == otpError) {
      return;
    }

    emit(this.state.rebuild((final b) => b.otpError = otpError));

    $onUpdateOtpError();
  }

  @protected
  void $onUpdateOtpError() {}

  @mustCallSuper
  void updateIsLoginEnabled(final bool isLoginEnabled) {
    if (this.state.isLoginEnabled == isLoginEnabled) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isLoginEnabled = isLoginEnabled));

    $onUpdateIsLoginEnabled();
  }

  @protected
  void $onUpdateIsLoginEnabled() {}

  @mustCallSuper
  void updateIsForgotEnabled(final bool isForgotEnabled) {
    if (this.state.isForgotEnabled == isForgotEnabled) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isForgotEnabled = isForgotEnabled));

    $onUpdateIsForgotEnabled();
  }

  @protected
  void $onUpdateIsForgotEnabled() {}

  @mustCallSuper
  void updateIsSignupEnabled(final bool isSignupEnabled) {
    if (this.state.isSignupEnabled == isSignupEnabled) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isSignupEnabled = isSignupEnabled));

    $onUpdateIsSignupEnabled();
  }

  @protected
  void $onUpdateIsSignupEnabled() {}

  @mustCallSuper
  void updatePassword(final String password) {
    if (this.state.password == password) {
      return;
    }

    emit(this.state.rebuild((final b) => b.password = password));

    $onUpdatePassword();
  }

  @protected
  void $onUpdatePassword() {}

  @mustCallSuper
  void updateCheckBox(final bool checkBox) {
    if (this.state.checkBox == checkBox) {
      return;
    }

    emit(this.state.rebuild((final b) => b.checkBox = checkBox));

    $onUpdateCheckBox();
  }

  @protected
  void $onUpdateCheckBox() {}

  @mustCallSuper
  void updateConfirmPassword(final String confirmPassword) {
    if (this.state.confirmPassword == confirmPassword) {
      return;
    }

    emit(this.state.rebuild((final b) => b.confirmPassword = confirmPassword));

    $onUpdateConfirmPassword();
  }

  @protected
  void $onUpdateConfirmPassword() {}

  @mustCallSuper
  void updateCountryCode(final String countryCode) {
    if (this.state.countryCode == countryCode) {
      return;
    }

    emit(this.state.rebuild((final b) => b.countryCode = countryCode));

    $onUpdateCountryCode();
  }

  @protected
  void $onUpdateCountryCode() {}

  @mustCallSuper
  void updatePhoneNumber(final String? phoneNumber) {
    if (this.state.phoneNumber == phoneNumber) {
      return;
    }

    emit(this.state.rebuild((final b) => b.phoneNumber = phoneNumber));

    $onUpdatePhoneNumber();
  }

  @protected
  void $onUpdatePhoneNumber() {}

  @mustCallSuper
  void updateOtp(final String? otp) {
    if (this.state.otp == otp) {
      return;
    }

    emit(this.state.rebuild((final b) => b.otp = otp));

    $onUpdateOtp();
  }

  @protected
  void $onUpdateOtp() {}

  @mustCallSuper
  void updateName(final String? name) {
    if (this.state.name == name) {
      return;
    }

    emit(this.state.rebuild((final b) => b.name = name));

    $onUpdateName();
  }

  @protected
  void $onUpdateName() {}

  @mustCallSuper
  void updateStrengthLabel(final String strengthLabel) {
    if (this.state.strengthLabel == strengthLabel) {
      return;
    }

    emit(this.state.rebuild((final b) => b.strengthLabel = strengthLabel));

    $onUpdateStrengthLabel();
  }

  @protected
  void $onUpdateStrengthLabel() {}

  @mustCallSuper
  void updateStrength(final double strength) {
    if (this.state.strength == strength) {
      return;
    }

    emit(this.state.rebuild((final b) => b.strength = strength));

    $onUpdateStrength();
  }

  @protected
  void $onUpdateStrength() {}

  @mustCallSuper
  void updateStrengthColor(final Color strengthColor) {
    if (this.state.strengthColor == strengthColor) {
      return;
    }

    emit(this.state.rebuild((final b) => b.strengthColor = strengthColor));

    $onUpdateStrengthColor();
  }

  @protected
  void $onUpdateStrengthColor() {}

  @mustCallSuper
  void updateResendOtp(final bool resendOtp) {
    if (this.state.resendOtp == resendOtp) {
      return;
    }

    emit(this.state.rebuild((final b) => b.resendOtp = resendOtp));

    $onUpdateResendOtp();
  }

  @protected
  void $onUpdateResendOtp() {}

  @mustCallSuper
  void updateObscureText(final bool obscureText) {
    if (this.state.obscureText == obscureText) {
      return;
    }

    emit(this.state.rebuild((final b) => b.obscureText = obscureText));

    $onUpdateObscureText();
  }

  @protected
  void $onUpdateObscureText() {}

  @mustCallSuper
  void updateObscureTextSignupPassword(final bool obscureTextSignupPassword) {
    if (this.state.obscureTextSignupPassword == obscureTextSignupPassword) {
      return;
    }

    emit(this.state.rebuild(
        (final b) => b.obscureTextSignupPassword = obscureTextSignupPassword));

    $onUpdateObscureTextSignupPassword();
  }

  @protected
  void $onUpdateObscureTextSignupPassword() {}

  @mustCallSuper
  void updateSignUpLoading(final bool signUpLoading) {
    if (this.state.signUpLoading == signUpLoading) {
      return;
    }

    emit(this.state.rebuild((final b) => b.signUpLoading = signUpLoading));

    $onUpdateSignUpLoading();
  }

  @protected
  void $onUpdateSignUpLoading() {}

  @mustCallSuper
  void updateObscureTextSignupConfirmPassword(
      final bool obscureTextSignupConfirmPassword) {
    if (this.state.obscureTextSignupConfirmPassword ==
        obscureTextSignupConfirmPassword) {
      return;
    }

    emit(this.state.rebuild((final b) =>
        b.obscureTextSignupConfirmPassword = obscureTextSignupConfirmPassword));

    $onUpdateObscureTextSignupConfirmPassword();
  }

  @protected
  void $onUpdateObscureTextSignupConfirmPassword() {}

  @mustCallSuper
  void updateRemainingSeconds(final int remainingSeconds) {
    if (this.state.remainingSeconds == remainingSeconds) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.remainingSeconds = remainingSeconds));

    $onUpdateRemainingSeconds();
  }

  @protected
  void $onUpdateRemainingSeconds() {}
}
