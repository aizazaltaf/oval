import 'package:admin/constants.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/logout/bloc/logout_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/change_password_state.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/utils/dio.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'change_password_bloc.bloc.g.dart';

@BlocGen()
class ChangePasswordBloc
    extends BVCubit<ChangePasswordState, ChangePasswordStateBuilder>
    with _ChangePasswordBlocMixin {
  ChangePasswordBloc() : super(ChangePasswordState());

  factory ChangePasswordBloc.of(final BuildContext context) =>
      BlocProvider.of<ChangePasswordBloc>(context);

  void reInitializeFields() {
    emit(
      state.rebuild(
        (b) => b
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
          ..strengthColor = Colors.grey
          ..confirmButtonEnabled = false,
      ),
    );
  }

  void getPasswordStrength() {
    int score = 0;

    if (state.newPassword.length >= Constants.isAtLeast8Chars) {
      score++;
    }
    if (Constants.hasUpperCase.hasMatch(state.newPassword)) {
      score++;
    }
    if (Constants.hasLowerCase.hasMatch(state.newPassword)) {
      score++;
    }
    if (Constants.hasNumber.hasMatch(state.newPassword)) {
      score++;
    }
    if (Constants.hasSpecialChar.hasMatch(state.newPassword)) {
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
    emit(
      state.rebuild(
        (final b) => b
          ..strengthLabel = strengthLabel
          ..strength = strength
          ..strengthColor = strengthColor,
      ),
    );
  }

  void getConfirmButtonEnabled() {
    if (state.oldPassword.trim().isNotEmpty &&
        state.newPassword.trim().isNotEmpty &&
        state.confirmPassword.trim().isNotEmpty &&
        state.oldPasswordError.trim().isEmpty &&
        state.newPasswordError.trim().isEmpty &&
        state.confirmPasswordError.trim().isEmpty) {
      updateConfirmButtonEnabled(true);
    } else {
      updateConfirmButtonEnabled(false);
    }
  }

  Future<void> callChangePassword({required LogoutBloc logoutBloc}) {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.changePasswordApi,
      updateApiState: (final b, final apiState) =>
          b.changePasswordApi.replace(apiState),
      onError: (exception) {
        if (exception is DioException && exception.response != null) {
          updateOldPasswordError(exception.response!.data["message"]);
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
      },
      callApi: () async {
        final response = await apiService.changePassword(
          newPassword: state.newPassword,
          currentPassword: state.oldPassword,
        );
        ToastUtils.successToast(response['message']);
        await logoutBloc.callLogoutAllSessions();
      },
    );
  }
}
