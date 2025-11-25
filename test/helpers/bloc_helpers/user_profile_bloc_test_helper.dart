import 'dart:async';

import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/bloc/bloc_mocks.dart';
import '../../mocks/bloc/state_mocks.dart';

class UserProfileBlocTestHelper {
  late MockUserProfileBloc mockUserProfileBloc;
  late StreamController<UserProfileState> userProfileStateController;
  late UserProfileState currentUserProfileState;
  late TextEditingController otpController;

  void setup() {
    otpController = TextEditingController();
    mockUserProfileBloc = MockUserProfileBloc();
    userProfileStateController = StreamController<UserProfileState>.broadcast();
    currentUserProfileState = MockUserProfileState();

    when(() => mockUserProfileBloc.stream)
        .thenAnswer((_) => userProfileStateController.stream);
    when(() => mockUserProfileBloc.state)
        .thenAnswer((_) => currentUserProfileState);

    // Mock UserProfileState properties
    when(() => currentUserProfileState.isProfileEditing).thenReturn(false);
    when(() => currentUserProfileState.fromGallery).thenReturn(null);
    when(() => currentUserProfileState.clearOtp).thenReturn(false);
    when(() => currentUserProfileState.otpError).thenReturn("");
    when(() => currentUserProfileState.countryCode).thenReturn("");
    when(() => currentUserProfileState.userPassword).thenReturn("");
    when(() => currentUserProfileState.validatePassword).thenReturn("");
    when(() => currentUserProfileState.obscurePassword).thenReturn(true);
    when(() => currentUserProfileState.resendOtp).thenReturn(false);
    when(() => currentUserProfileState.otp).thenReturn(null);
    when(() => currentUserProfileState.remainingSeconds).thenReturn(60);
    when(() => currentUserProfileState.editName).thenReturn("");
    when(() => currentUserProfileState.editEmail).thenReturn("");
    when(() => currentUserProfileState.editPhoneNumber).thenReturn("");
    when(() => currentUserProfileState.editImage).thenReturn(null);
    when(() => currentUserProfileState.editImageStr).thenReturn(null);
    when(() => currentUserProfileState.nameErrorMessage).thenReturn("");
    when(() => currentUserProfileState.emailErrorMessage).thenReturn("");
    when(() => currentUserProfileState.phoneErrorMessage).thenReturn("");
    when(() => currentUserProfileState.passwordErrorMessage).thenReturn("");
    when(() => currentUserProfileState.updateProfileButtonEnabled)
        .thenReturn(false);
    when(() => currentUserProfileState.confirmButtonEnabled).thenReturn(false);
    when(() => currentUserProfileState.updateProfileApi)
        .thenReturn(ApiState<void>());
    when(() => currentUserProfileState.callOtpApi).thenReturn(ApiState<void>());
    when(() => currentUserProfileState.validatePasswordApi)
        .thenReturn(ApiState<void>());

    when(() => mockUserProfileBloc.otpController).thenReturn(otpController);
  }

  void dispose() {
    userProfileStateController.close();
  }
}
