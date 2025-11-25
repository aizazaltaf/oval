// ignore_for_file: type=lint, unused_element

part of 'user_profile_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class UserProfileBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<UserProfileState>? buildWhen;
  final BlocWidgetBuilder<UserProfileState> builder;

  const UserProfileBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class UserProfileBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<UserProfileState, T> selector;
  final Widget Function(T state) builder;
  final UserProfileBloc? bloc;

  const UserProfileBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static UserProfileBlocSelector<bool> isProfileEditing({
    final Key? key,
    required Widget Function(bool isProfileEditing) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.isProfileEditing,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<bool?> fromGallery({
    final Key? key,
    required Widget Function(bool? fromGallery) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.fromGallery,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<bool> clearOtp({
    final Key? key,
    required Widget Function(bool clearOtp) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.clearOtp,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<String> otpError({
    final Key? key,
    required Widget Function(String otpError) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.otpError,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<String> countryCode({
    final Key? key,
    required Widget Function(String countryCode) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.countryCode,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<String> userPassword({
    final Key? key,
    required Widget Function(String userPassword) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.userPassword,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<String> validatePassword({
    final Key? key,
    required Widget Function(String validatePassword) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.validatePassword,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<bool> obscurePassword({
    final Key? key,
    required Widget Function(bool obscurePassword) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.obscurePassword,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<bool> resendOtp({
    final Key? key,
    required Widget Function(bool resendOtp) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.resendOtp,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<String?> otp({
    final Key? key,
    required Widget Function(String? otp) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.otp,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<int> remainingSeconds({
    final Key? key,
    required Widget Function(int remainingSeconds) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.remainingSeconds,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<String> editName({
    final Key? key,
    required Widget Function(String editName) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.editName,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<String> editEmail({
    final Key? key,
    required Widget Function(String editEmail) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.editEmail,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<String> editPhoneNumber({
    final Key? key,
    required Widget Function(String editPhoneNumber) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.editPhoneNumber,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<XFile?> editImage({
    final Key? key,
    required Widget Function(XFile? editImage) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.editImage,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<String?> editImageStr({
    final Key? key,
    required Widget Function(String? editImageStr) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.editImageStr,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<String> nameErrorMessage({
    final Key? key,
    required Widget Function(String nameErrorMessage) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.nameErrorMessage,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<String> emailErrorMessage({
    final Key? key,
    required Widget Function(String emailErrorMessage) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.emailErrorMessage,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<String> phoneErrorMessage({
    final Key? key,
    required Widget Function(String phoneErrorMessage) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.phoneErrorMessage,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<String> passwordErrorMessage({
    final Key? key,
    required Widget Function(String passwordErrorMessage) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.passwordErrorMessage,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<bool> updateProfileButtonEnabled({
    final Key? key,
    required Widget Function(bool updateProfileButtonEnabled) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.updateProfileButtonEnabled,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<bool> confirmButtonEnabled({
    final Key? key,
    required Widget Function(bool confirmButtonEnabled) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.confirmButtonEnabled,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<ApiState<void>> updateProfileApi({
    final Key? key,
    required Widget Function(ApiState<void> updateProfileApi) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.updateProfileApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<ApiState<void>> callOtpApi({
    final Key? key,
    required Widget Function(ApiState<void> callOtpApi) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.callOtpApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static UserProfileBlocSelector<ApiState<void>> validatePasswordApi({
    final Key? key,
    required Widget Function(ApiState<void> validatePasswordApi) builder,
    final UserProfileBloc? bloc,
  }) {
    return UserProfileBlocSelector(
      key: key,
      selector: (state) => state.validatePasswordApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<UserProfileBloc, UserProfileState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _UserProfileBlocMixin on Cubit<UserProfileState> {
  @mustCallSuper
  void updateIsProfileEditing(final bool isProfileEditing) {
    if (this.state.isProfileEditing == isProfileEditing) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.isProfileEditing = isProfileEditing));

    $onUpdateIsProfileEditing();
  }

  @protected
  void $onUpdateIsProfileEditing() {}

  @mustCallSuper
  void updateFromGallery(final bool? fromGallery) {
    if (this.state.fromGallery == fromGallery) {
      return;
    }

    emit(this.state.rebuild((final b) => b.fromGallery = fromGallery));

    $onUpdateFromGallery();
  }

  @protected
  void $onUpdateFromGallery() {}

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
  void updateUserPassword(final String userPassword) {
    if (this.state.userPassword == userPassword) {
      return;
    }

    emit(this.state.rebuild((final b) => b.userPassword = userPassword));

    $onUpdateUserPassword();
  }

  @protected
  void $onUpdateUserPassword() {}

  @mustCallSuper
  void updateValidatePassword(final String validatePassword) {
    if (this.state.validatePassword == validatePassword) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.validatePassword = validatePassword));

    $onUpdateValidatePassword();
  }

  @protected
  void $onUpdateValidatePassword() {}

  @mustCallSuper
  void updateObscurePassword(final bool obscurePassword) {
    if (this.state.obscurePassword == obscurePassword) {
      return;
    }

    emit(this.state.rebuild((final b) => b.obscurePassword = obscurePassword));

    $onUpdateObscurePassword();
  }

  @protected
  void $onUpdateObscurePassword() {}

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

  @mustCallSuper
  void updateEditName(final String editName) {
    if (this.state.editName == editName) {
      return;
    }

    emit(this.state.rebuild((final b) => b.editName = editName));

    $onUpdateEditName();
  }

  @protected
  void $onUpdateEditName() {}

  @mustCallSuper
  void updateEditEmail(final String editEmail) {
    if (this.state.editEmail == editEmail) {
      return;
    }

    emit(this.state.rebuild((final b) => b.editEmail = editEmail));

    $onUpdateEditEmail();
  }

  @protected
  void $onUpdateEditEmail() {}

  @mustCallSuper
  void updateEditPhoneNumber(final String editPhoneNumber) {
    if (this.state.editPhoneNumber == editPhoneNumber) {
      return;
    }

    emit(this.state.rebuild((final b) => b.editPhoneNumber = editPhoneNumber));

    $onUpdateEditPhoneNumber();
  }

  @protected
  void $onUpdateEditPhoneNumber() {}

  @mustCallSuper
  void updateEditImage(final XFile? editImage) {
    if (this.state.editImage == editImage) {
      return;
    }

    emit(this.state.rebuild((final b) => b.editImage = editImage));

    $onUpdateEditImage();
  }

  @protected
  void $onUpdateEditImage() {}

  @mustCallSuper
  void updateEditImageStr(final String? editImageStr) {
    if (this.state.editImageStr == editImageStr) {
      return;
    }

    emit(this.state.rebuild((final b) => b.editImageStr = editImageStr));

    $onUpdateEditImageStr();
  }

  @protected
  void $onUpdateEditImageStr() {}

  @mustCallSuper
  void updateNameErrorMessage(final String nameErrorMessage) {
    if (this.state.nameErrorMessage == nameErrorMessage) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.nameErrorMessage = nameErrorMessage));

    $onUpdateNameErrorMessage();
  }

  @protected
  void $onUpdateNameErrorMessage() {}

  @mustCallSuper
  void updateEmailErrorMessage(final String emailErrorMessage) {
    if (this.state.emailErrorMessage == emailErrorMessage) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.emailErrorMessage = emailErrorMessage));

    $onUpdateEmailErrorMessage();
  }

  @protected
  void $onUpdateEmailErrorMessage() {}

  @mustCallSuper
  void updatePhoneErrorMessage(final String phoneErrorMessage) {
    if (this.state.phoneErrorMessage == phoneErrorMessage) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.phoneErrorMessage = phoneErrorMessage));

    $onUpdatePhoneErrorMessage();
  }

  @protected
  void $onUpdatePhoneErrorMessage() {}

  @mustCallSuper
  void updatePasswordErrorMessage(final String passwordErrorMessage) {
    if (this.state.passwordErrorMessage == passwordErrorMessage) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.passwordErrorMessage = passwordErrorMessage));

    $onUpdatePasswordErrorMessage();
  }

  @protected
  void $onUpdatePasswordErrorMessage() {}

  @mustCallSuper
  void updateUpdateProfileButtonEnabled(final bool updateProfileButtonEnabled) {
    if (this.state.updateProfileButtonEnabled == updateProfileButtonEnabled) {
      return;
    }

    emit(this.state.rebuild((final b) =>
        b.updateProfileButtonEnabled = updateProfileButtonEnabled));

    $onUpdateUpdateProfileButtonEnabled();
  }

  @protected
  void $onUpdateUpdateProfileButtonEnabled() {}

  @mustCallSuper
  void updateConfirmButtonEnabled(final bool confirmButtonEnabled) {
    if (this.state.confirmButtonEnabled == confirmButtonEnabled) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.confirmButtonEnabled = confirmButtonEnabled));

    $onUpdateConfirmButtonEnabled();
  }

  @protected
  void $onUpdateConfirmButtonEnabled() {}
}
