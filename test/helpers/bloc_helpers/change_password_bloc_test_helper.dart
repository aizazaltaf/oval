import 'dart:async';

import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/user_profile/bloc/change_password_state.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/bloc/bloc_mocks.dart';

class ChangePasswordBlocTestHelper {
  late MockChangePasswordBloc mockChangePasswordBloc;
  late StreamController<ChangePasswordState> changePasswordStateController;
  late ChangePasswordState currentChangePasswordState;

  void setup() {
    mockChangePasswordBloc = MockChangePasswordBloc();
    changePasswordStateController =
        StreamController<ChangePasswordState>.broadcast();
    currentChangePasswordState = ChangePasswordState();

    when(() => mockChangePasswordBloc.stream)
        .thenAnswer((_) => changePasswordStateController.stream);
    when(() => mockChangePasswordBloc.state)
        .thenAnswer((_) => currentChangePasswordState);

    // Mock bloc methods to actually update state
    when(() => mockChangePasswordBloc.reInitializeFields()).thenAnswer((_) {
      updateState(ChangePasswordState());
    });
    when(() => mockChangePasswordBloc.updateOldPassword(any()))
        .thenAnswer((invocation) {
      final password = invocation.positionalArguments[0] as String;
      updateOldPassword(password);
    });
    when(() => mockChangePasswordBloc.updateOldPasswordError(any()))
        .thenAnswer((invocation) {
      final error = invocation.positionalArguments[0] as String;
      updateOldPasswordError(error);
    });
    when(() => mockChangePasswordBloc.updateOldPasswordObscure(any()))
        .thenAnswer((invocation) {
      final obscure = invocation.positionalArguments[0] as bool;
      updateOldPasswordObscure(obscure);
    });
    when(() => mockChangePasswordBloc.updateNewPassword(any()))
        .thenAnswer((invocation) {
      final password = invocation.positionalArguments[0] as String;
      updateNewPassword(password);
    });
    when(() => mockChangePasswordBloc.updateNewPasswordError(any()))
        .thenAnswer((invocation) {
      final error = invocation.positionalArguments[0] as String;
      updateNewPasswordError(error);
    });
    when(() => mockChangePasswordBloc.updateNewPasswordObscure(any()))
        .thenAnswer((invocation) {
      final obscure = invocation.positionalArguments[0] as bool;
      updateNewPasswordObscure(obscure);
    });
    when(() => mockChangePasswordBloc.updateConfirmPassword(any()))
        .thenAnswer((invocation) {
      final password = invocation.positionalArguments[0] as String;
      updateConfirmPassword(password);
    });
    when(() => mockChangePasswordBloc.updateConfirmPasswordError(any()))
        .thenAnswer((invocation) {
      final error = invocation.positionalArguments[0] as String;
      updateConfirmPasswordError(error);
    });
    when(() => mockChangePasswordBloc.updateConfirmPasswordObscure(any()))
        .thenAnswer((invocation) {
      final obscure = invocation.positionalArguments[0] as bool;
      updateConfirmPasswordObscure(obscure);
    });
    when(() => mockChangePasswordBloc.getPasswordStrength()).thenAnswer((_) {
      getPasswordStrength();
    });
    when(() => mockChangePasswordBloc.getConfirmButtonEnabled())
        .thenAnswer((_) {
      getConfirmButtonEnabled();
    });
    when(() => mockChangePasswordBloc.updateConfirmButtonEnabled(any()))
        .thenAnswer((invocation) {
      final enabled = invocation.positionalArguments[0] as bool;
      updateConfirmButtonEnabled(enabled);
    });
    when(
      () => mockChangePasswordBloc.callChangePassword(
        logoutBloc: any(named: 'logoutBloc'),
      ),
    ).thenAnswer((_) async {});
  }

  void updateState(ChangePasswordState newState) {
    currentChangePasswordState = newState;
    changePasswordStateController.add(newState);
  }

  void updateOldPassword(String password) {
    final newState =
        currentChangePasswordState.rebuild((b) => b..oldPassword = password);
    updateState(newState);
  }

  void updateNewPassword(String password) {
    final newState =
        currentChangePasswordState.rebuild((b) => b..newPassword = password);
    updateState(newState);
  }

  void updateConfirmPassword(String password) {
    final newState = currentChangePasswordState
        .rebuild((b) => b..confirmPassword = password);
    updateState(newState);
  }

  void updateOldPasswordError(String error) {
    final newState =
        currentChangePasswordState.rebuild((b) => b..oldPasswordError = error);
    updateState(newState);
  }

  void updateNewPasswordError(String error) {
    final newState =
        currentChangePasswordState.rebuild((b) => b..newPasswordError = error);
    updateState(newState);
  }

  void updateConfirmPasswordError(String error) {
    final newState = currentChangePasswordState
        .rebuild((b) => b..confirmPasswordError = error);
    updateState(newState);
  }

  void updateOldPasswordObscure(bool obscure) {
    final newState = currentChangePasswordState
        .rebuild((b) => b..oldPasswordObscure = obscure);
    updateState(newState);
  }

  void updateNewPasswordObscure(bool obscure) {
    final newState = currentChangePasswordState
        .rebuild((b) => b..newPasswordObscure = obscure);
    updateState(newState);
  }

  void updateConfirmPasswordObscure(bool obscure) {
    final newState = currentChangePasswordState
        .rebuild((b) => b..confirmPasswordObscure = obscure);
    updateState(newState);
  }

  void getPasswordStrength() {
    // Simplified strength calculation for testing
    int score = 0;
    if (currentChangePasswordState.newPassword.length >= 8) {
      score++;
    }
    if (currentChangePasswordState.newPassword.contains(RegExp(r'[A-Z]'))) {
      score++;
    }
    if (currentChangePasswordState.newPassword.contains(RegExp(r'[a-z]'))) {
      score++;
    }
    if (currentChangePasswordState.newPassword.contains(RegExp(r'[0-9]'))) {
      score++;
    }
    if (currentChangePasswordState.newPassword
        .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      score++;
    }

    double strength;
    String label;
    Color color;

    if (score == 0) {
      strength = 0.0;
      label = 'Too short';
      color = Colors.grey;
    } else if (score <= 2) {
      strength = 0.25;
      label = 'Weak';
      color = Colors.red;
    } else if (score == 3) {
      strength = 0.5;
      label = 'Medium';
      color = Colors.orange;
    } else if (score == 4) {
      strength = 0.75;
      label = 'Strong';
      color = Colors.lightGreen;
    } else {
      strength = 1.0;
      label = 'Very Strong';
      color = Colors.green;
    }

    updatePasswordStrength(strength, label, color);
  }

  void getConfirmButtonEnabled() {
    final enabled = currentChangePasswordState.oldPassword.trim().isNotEmpty &&
        currentChangePasswordState.newPassword.trim().isNotEmpty &&
        currentChangePasswordState.confirmPassword.trim().isNotEmpty &&
        currentChangePasswordState.oldPasswordError.trim().isEmpty &&
        currentChangePasswordState.newPasswordError.trim().isEmpty &&
        currentChangePasswordState.confirmPasswordError.trim().isEmpty;

    updateConfirmButtonEnabled(enabled);
  }

  void updateConfirmButtonEnabled(bool enabled) {
    final newState = currentChangePasswordState
        .rebuild((b) => b..confirmButtonEnabled = enabled);
    updateState(newState);
  }

  void updatePasswordStrength(double strength, String label, Color color) {
    final newState = currentChangePasswordState.rebuild(
      (b) => b
        ..strength = strength
        ..strengthLabel = label
        ..strengthColor = color,
    );
    updateState(newState);
  }

  void updateApiState(ApiState<void> apiState) {
    final newState = currentChangePasswordState
        .rebuild((b) => b..changePasswordApi.replace(apiState));
    updateState(newState);
  }

  void dispose() {
    changePasswordStateController.close();
  }
}
