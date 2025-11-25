// ignore_for_file: type=lint, unused_element

part of 'change_password_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class ChangePasswordBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<ChangePasswordState>? buildWhen;
  final BlocWidgetBuilder<ChangePasswordState> builder;

  const ChangePasswordBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class ChangePasswordBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<ChangePasswordState, T> selector;
  final Widget Function(T state) builder;
  final ChangePasswordBloc? bloc;

  const ChangePasswordBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static ChangePasswordBlocSelector<String> oldPassword({
    final Key? key,
    required Widget Function(String oldPassword) builder,
    final ChangePasswordBloc? bloc,
  }) {
    return ChangePasswordBlocSelector(
      key: key,
      selector: (state) => state.oldPassword,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChangePasswordBlocSelector<bool> oldPasswordObscure({
    final Key? key,
    required Widget Function(bool oldPasswordObscure) builder,
    final ChangePasswordBloc? bloc,
  }) {
    return ChangePasswordBlocSelector(
      key: key,
      selector: (state) => state.oldPasswordObscure,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChangePasswordBlocSelector<String> oldPasswordError({
    final Key? key,
    required Widget Function(String oldPasswordError) builder,
    final ChangePasswordBloc? bloc,
  }) {
    return ChangePasswordBlocSelector(
      key: key,
      selector: (state) => state.oldPasswordError,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChangePasswordBlocSelector<String> newPassword({
    final Key? key,
    required Widget Function(String newPassword) builder,
    final ChangePasswordBloc? bloc,
  }) {
    return ChangePasswordBlocSelector(
      key: key,
      selector: (state) => state.newPassword,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChangePasswordBlocSelector<bool> newPasswordObscure({
    final Key? key,
    required Widget Function(bool newPasswordObscure) builder,
    final ChangePasswordBloc? bloc,
  }) {
    return ChangePasswordBlocSelector(
      key: key,
      selector: (state) => state.newPasswordObscure,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChangePasswordBlocSelector<String> newPasswordError({
    final Key? key,
    required Widget Function(String newPasswordError) builder,
    final ChangePasswordBloc? bloc,
  }) {
    return ChangePasswordBlocSelector(
      key: key,
      selector: (state) => state.newPasswordError,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChangePasswordBlocSelector<String> confirmPassword({
    final Key? key,
    required Widget Function(String confirmPassword) builder,
    final ChangePasswordBloc? bloc,
  }) {
    return ChangePasswordBlocSelector(
      key: key,
      selector: (state) => state.confirmPassword,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChangePasswordBlocSelector<bool> confirmPasswordObscure({
    final Key? key,
    required Widget Function(bool confirmPasswordObscure) builder,
    final ChangePasswordBloc? bloc,
  }) {
    return ChangePasswordBlocSelector(
      key: key,
      selector: (state) => state.confirmPasswordObscure,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChangePasswordBlocSelector<String> confirmPasswordError({
    final Key? key,
    required Widget Function(String confirmPasswordError) builder,
    final ChangePasswordBloc? bloc,
  }) {
    return ChangePasswordBlocSelector(
      key: key,
      selector: (state) => state.confirmPasswordError,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChangePasswordBlocSelector<String> strengthLabel({
    final Key? key,
    required Widget Function(String strengthLabel) builder,
    final ChangePasswordBloc? bloc,
  }) {
    return ChangePasswordBlocSelector(
      key: key,
      selector: (state) => state.strengthLabel,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChangePasswordBlocSelector<double> strength({
    final Key? key,
    required Widget Function(double strength) builder,
    final ChangePasswordBloc? bloc,
  }) {
    return ChangePasswordBlocSelector(
      key: key,
      selector: (state) => state.strength,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChangePasswordBlocSelector<Color> strengthColor({
    final Key? key,
    required Widget Function(Color strengthColor) builder,
    final ChangePasswordBloc? bloc,
  }) {
    return ChangePasswordBlocSelector(
      key: key,
      selector: (state) => state.strengthColor,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChangePasswordBlocSelector<bool> confirmButtonEnabled({
    final Key? key,
    required Widget Function(bool confirmButtonEnabled) builder,
    final ChangePasswordBloc? bloc,
  }) {
    return ChangePasswordBlocSelector(
      key: key,
      selector: (state) => state.confirmButtonEnabled,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static ChangePasswordBlocSelector<ApiState<void>> changePasswordApi({
    final Key? key,
    required Widget Function(ApiState<void> changePasswordApi) builder,
    final ChangePasswordBloc? bloc,
  }) {
    return ChangePasswordBlocSelector(
      key: key,
      selector: (state) => state.changePasswordApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<ChangePasswordBloc, ChangePasswordState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _ChangePasswordBlocMixin on Cubit<ChangePasswordState> {
  @mustCallSuper
  void updateOldPassword(final String oldPassword) {
    if (this.state.oldPassword == oldPassword) {
      return;
    }

    emit(this.state.rebuild((final b) => b.oldPassword = oldPassword));

    $onUpdateOldPassword();
  }

  @protected
  void $onUpdateOldPassword() {}

  @mustCallSuper
  void updateOldPasswordObscure(final bool oldPasswordObscure) {
    if (this.state.oldPasswordObscure == oldPasswordObscure) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.oldPasswordObscure = oldPasswordObscure));

    $onUpdateOldPasswordObscure();
  }

  @protected
  void $onUpdateOldPasswordObscure() {}

  @mustCallSuper
  void updateOldPasswordError(final String oldPasswordError) {
    if (this.state.oldPasswordError == oldPasswordError) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.oldPasswordError = oldPasswordError));

    $onUpdateOldPasswordError();
  }

  @protected
  void $onUpdateOldPasswordError() {}

  @mustCallSuper
  void updateNewPassword(final String newPassword) {
    if (this.state.newPassword == newPassword) {
      return;
    }

    emit(this.state.rebuild((final b) => b.newPassword = newPassword));

    $onUpdateNewPassword();
  }

  @protected
  void $onUpdateNewPassword() {}

  @mustCallSuper
  void updateNewPasswordObscure(final bool newPasswordObscure) {
    if (this.state.newPasswordObscure == newPasswordObscure) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.newPasswordObscure = newPasswordObscure));

    $onUpdateNewPasswordObscure();
  }

  @protected
  void $onUpdateNewPasswordObscure() {}

  @mustCallSuper
  void updateNewPasswordError(final String newPasswordError) {
    if (this.state.newPasswordError == newPasswordError) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.newPasswordError = newPasswordError));

    $onUpdateNewPasswordError();
  }

  @protected
  void $onUpdateNewPasswordError() {}

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
  void updateConfirmPasswordObscure(final bool confirmPasswordObscure) {
    if (this.state.confirmPasswordObscure == confirmPasswordObscure) {
      return;
    }

    emit(this.state.rebuild(
        (final b) => b.confirmPasswordObscure = confirmPasswordObscure));

    $onUpdateConfirmPasswordObscure();
  }

  @protected
  void $onUpdateConfirmPasswordObscure() {}

  @mustCallSuper
  void updateConfirmPasswordError(final String confirmPasswordError) {
    if (this.state.confirmPasswordError == confirmPasswordError) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.confirmPasswordError = confirmPasswordError));

    $onUpdateConfirmPasswordError();
  }

  @protected
  void $onUpdateConfirmPasswordError() {}

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

  @mustCallSuper
  void updateChangePasswordApi(final ApiState<void> changePasswordApi) {
    if (this.state.changePasswordApi == changePasswordApi) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.changePasswordApi.replace(changePasswordApi);
    }));

    $onUpdateChangePasswordApi();
  }

  @protected
  void $onUpdateChangePasswordApi() {}
}
