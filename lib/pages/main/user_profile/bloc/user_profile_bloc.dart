import 'dart:convert';
import 'dart:io';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_state.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/utils/dio.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:admin/widgets/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'user_profile_bloc.bloc.g.dart';

final _logger = Logger('user_profile_bloc.dart');

@BlocGen()
class UserProfileBloc extends BVCubit<UserProfileState, UserProfileStateBuilder>
    with _UserProfileBlocMixin {
  UserProfileBloc() : super(UserProfileState());

  factory UserProfileBloc.of(final BuildContext context) =>
      BlocProvider.of<UserProfileBloc>(context);

  final picker = ImagePicker();
  final TextEditingController otpController = TextEditingController();

  void checkHasDetailsChanged() {
    final bloc = singletonBloc.profileBloc;
    final String countryCode = CommonFunctions.getDialCode(bloc.state!.phone!);
    final String phoneNumberWithoutDialCode =
        bloc.state!.phone!.replaceFirst(countryCode, '');
    if (state.updateProfileButtonEnabled) {
      if (state.editImage != null ||
          bloc.state!.name != state.editName.trim() ||
          bloc.state!.email != state.editEmail.trim() ||
          phoneNumberWithoutDialCode != state.editPhoneNumber.trim()) {
        updateUpdateProfileButtonEnabled(true);
      } else {
        updateUpdateProfileButtonEnabled(false);
      }
    }
  }

  void validatePasswordEnableValidations() {
    if (state.validatePassword.length < 8) {
      updateConfirmButtonEnabled(false);
    } else {
      updateConfirmButtonEnabled(true);
    }
  }

  @override
  void $onUpdateEditName() {
    //  implement $onUpdateEditName
    if (state.editName.trim().isEmpty) {
      emit(state.rebuild((b) => b..nameErrorMessage = "Name is required"));
      updateUpdateProfileButtonEnabled(false);
    } else {
      emit(state.rebuild((b) => b..nameErrorMessage = ""));
      updateUpdateProfileButtonEnabled(true);
    }
    checkHasDetailsChanged();
  }

  @override
  void $onUpdateEditEmail() {
    //  implement $onUpdateEditEmail
    if (state.editEmail.trim().isEmpty) {
      emit(state.rebuild((b) => b..emailErrorMessage = "Email is required"));
      updateUpdateProfileButtonEnabled(false);
    } else if (!Constants.emailRegex.hasMatch(state.editEmail)) {
      emit(
        state.rebuild(
          (b) => b..emailErrorMessage = "Please enter a valid email address",
        ),
      );
      updateUpdateProfileButtonEnabled(false);
    } else {
      emit(state.rebuild((b) => b..emailErrorMessage = ""));
      updateUpdateProfileButtonEnabled(true);
    }
    checkHasDetailsChanged();
  }

  @override
  void $onUpdateEditPhoneNumber() {
    //  implement $onUpdateEditPhoneNumber
    if (state.editPhoneNumber.trim().isEmpty) {
      emit(
        state.rebuild((b) => b..phoneErrorMessage = "Phone Number is required"),
      );
      updateUpdateProfileButtonEnabled(false);
    } else if (state.editPhoneNumber.trim().length < 9) {
      emit(
        state
            .rebuild((b) => b..phoneErrorMessage = "Phone Number is incorrect"),
      );
      updateUpdateProfileButtonEnabled(false);
    } else {
      emit(state.rebuild((b) => b..phoneErrorMessage = ""));
      updateUpdateProfileButtonEnabled(true);
    }
    checkHasDetailsChanged();
  }

  Future<File?> getProfileImage() async {
    if (state.editImage != null) {
      // add the compress XFile version to request
      if (state.fromGallery == false) {
        final File compressedFile = await CommonFunctions.compressFile(
          File(state.editImage!.path),
        );
        return File(compressedFile.path);
      } else {
        return File(state.editImage!.path);
      }
    }
    return null;
  }

  Future<void> callOtp({
    required BuildContext context,
    required VoidCallback emailChangedFunction,
    VoidCallback? successReleaseTransferFunction,
    String? otpFor,
    required VoidCallback phoneChangedFunction,
  }) {
    return CubitUtils.makeApiCall<UserProfileState, UserProfileStateBuilder,
        void>(
      cubit: this,
      apiState: state.callOtpApi,
      updateApiState: (final b, final apiState) =>
          b.callOtpApi.replace(apiState),
      onError: (error) async {
        if (error is DioException && error.response != null) {
          // ToastUtils.errorToast(error.response!.data["message"]);
          otpController.clear();
          updateOtpError(error.response!.data["message"]);
          updateOtp("");
          updateClearOtp(true);
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
      },
      callApi: () async {
        final String phone = otpFor != null
            ? "${singletonBloc.profileBloc.state!.phone}"
            : "${state.countryCode}${state.editPhoneNumber}";
        final data = await apiService.verifyOtp(
          otp: state.otp!,
          phoneNumber: phone,
          email: singletonBloc.profileBloc.state!.email!,
        );
        // ToastUtils.successToast(data.data['message']);

        otpController.clear();
        updateOtpError("");
        updateOtp("");
        updateClearOtp(true);

        if (data.statusCode == 200) {
          if (context.mounted) {
            if (otpFor != null) {
              unawaited(
                OtpVerificationScreen.push(
                  context: context,
                  function: successReleaseTransferFunction!,
                  number: "${singletonBloc.profileBloc.state!.phone}",
                ),
              );
              // successReleaseTransferFunction!();
            } else {
              unawaited(
                OtpVerificationScreen.push(
                  context: context,
                  number: "${state.countryCode}${state.editPhoneNumber}",
                  function: () async {
                    await callUpdateProfile(
                      phoneChanged: true,
                      emailChangedFunction: emailChangedFunction,
                      phoneChangedFunction: phoneChangedFunction,
                    );
                  },
                ),
              );
            }
          }
        }
      },
    );
  }

  Timer? _timer;

  Future<void> sendOtp(bool? otpForDifferent) async {
    await apiService.sendOTPOnPhoneNumber(
      email: singletonBloc.profileBloc.state!.email!,
      phoneNumber: otpForDifferent == true
          ? "${singletonBloc.profileBloc.state!.phone}"
          : "${state.countryCode}${state.editPhoneNumber.trim()}",
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
  }

  int? getWrongPasswordCounts() {
    return singletonBloc.getBox.read(Constants.wrongPasswordCounts);
  }

  String? getWrongPasswordTime() {
    return singletonBloc.getBox.read(Constants.wrongPasswordTime);
  }

  bool canHitValidatePassword() {
    final DateTime currentTime = DateTime.now().toLocal();
    if (singletonBloc.getBox.hasData(Constants.wrongPasswordCounts)) {
      final DateTime lastWrongTime =
          DateTime.parse(singletonBloc.getBox.read(Constants.wrongPasswordTime))
              .toLocal();
      if (singletonBloc.getBox.read(Constants.wrongPasswordCounts) == 5) {
        if (currentTime.difference(lastWrongTime).inMinutes > 15) {
          singletonBloc.getBox
            ..remove(Constants.wrongPasswordCounts)
            ..remove(Constants.wrongPasswordTime);
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  Future<void> callValidatePassword({
    required VoidCallback successFunction,
    required VoidCallback popFunction,
  }) {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.validatePasswordApi,
      updateApiState: (final b, final apiState) =>
          b.validatePasswordApi.replace(apiState),
      onError: (exception) {
        if (exception is DioException && exception.response != null) {
          if (exception.type == DioExceptionType.connectionError) {
            updatePasswordErrorMessage(
              "Please check your network connection and try again.",
            );
          } else {
            updatePasswordErrorMessage("Incorrect password. Please try again.");
            final int? readWrongCount =
                singletonBloc.getBox.read(Constants.wrongPasswordCounts);
            singletonBloc.getBox
              ..write(
                Constants.wrongPasswordCounts,
                readWrongCount == null ? 1 : readWrongCount + 1,
              )
              ..write(
                Constants.wrongPasswordTime,
                DateTime.now().toUtc().toString(),
              );
          }
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }

        updateConfirmButtonEnabled(false);
      },
      callApi: () async {
        if (canHitValidatePassword()) {
          await apiService.validatePassword(state.validatePassword);
          popFunction();
          successFunction();
          unawaited(singletonBloc.getBox.remove(Constants.wrongPasswordCounts));
          unawaited(singletonBloc.getBox.remove(Constants.wrongPasswordTime));
        } else {
          updatePasswordErrorMessage(
            "Too many incorrect attempts. Please try again later after 15 minutes.",
          );
        }
      },
    );
  }

  Future<void> getUserProfile() async {
    final UserData userDetail = await apiService.getUserDetail();
    if (singletonBloc.profileBloc.state?.selectedDoorBell == null) {
      userDetail.rebuild(
        (b) => b..selectedDoorBell = null,
      );
    } else {
      userDetail.rebuild(
        (b) => b
          ..selectedDoorBell
              .replace(singletonBloc.profileBloc.state!.selectedDoorBell!),
      );
    }
    if (singletonBloc.profileBloc.state?.locations == null) {
      userDetail.rebuild(
        (b) => b..locations = null,
      );
    } else {
      userDetail.rebuild(
        (b) =>
            b..locations.replace(singletonBloc.profileBloc.state!.locations!),
      );
    }
    singletonBloc.profileBloc.updateProfile(
      userDetail.rebuild(
        (b) => b
          ..apiToken = singletonBloc.profileBloc.state!.apiToken
          ..refreshToken = singletonBloc.profileBloc.state!.refreshToken,
      ),
    );
  }

  Future<void> callUpdateProfile({
    VoidCallback? emailChangedFunction,
    VoidCallback? phoneChangedFunction,
    bool pendingEmail = false,
    bool? phoneChanged,
  }) {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.updateProfileApi,
      updateApiState: (final b, final apiState) =>
          b.updateProfileApi.replace(apiState),
      onError: (exception) {
        if (exception is DioException && exception.response != null) {
          ToastUtils.errorToast(exception.response!.data["message"]);
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
      },
      callApi: () async {
        final bloc = singletonBloc.profileBloc;
        dynamic response;
        bool emailChanged = false;
        if (pendingEmail) {
          response = await apiService.updateProfile(pendingEmail: pendingEmail);
        } else {
          final File? profilePhoto = await getProfileImage();
          final bool nameChanged = state.editName.trim() != bloc.state!.name!;
          emailChanged = state.editEmail.trim() != bloc.state!.email!;
          response = await apiService.updateProfile(
            profilePhoto: profilePhoto,
            newName: nameChanged ? state.editName.trim() : null,
            newEmail: emailChanged ? state.editEmail.trim() : null,
            newPhone: (phoneChanged!)
                ? "${state.countryCode}${state.editPhoneNumber.trim()}"
                : null,
          );
        }
        if (response['success'] == true) {
          ToastUtils.successToast(
            "Your profile has been successfully updated.",
          );
          if (emailChanged) {
            emailChangedFunction!();
          } else {
            updateIsProfileEditing(false);
            if (phoneChanged == true) {
              phoneChangedFunction!();
            }
          }
          updateEditImageStr(null);

          await StartupBloc().callUserDetails();
        } else {
          ToastUtils.successToast("Profile could not be updated.");
        }
      },
    );
  }

  String? attachmentBase64Image;
  String? attachmentFileName;

  /// For checking image is corrupted or not
  Future<bool> isValidImageOrGif(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final decodedImage = img.decodeImage(bytes);
      return decodedImage != null;
    } catch (e) {
      _logger.fine("Error decoding image: $e");
      return false;
    }
  }

  Future<void> getImage() async {
    final XFile? xFile;
    try {
      xFile = await picker.pickImage(
        source: state.fromGallery == true
            ? ImageSource.gallery
            : ImageSource.camera,
        imageQuality: 50,
        maxHeight: 400,
        maxWidth: 400,
      );
      if (xFile != null) {
        final bool result = await isValidImageOrGif(File(xFile.path));
        if (result) {
          updateEditImage(xFile);
          attachmentBase64Image = base64Encode(await xFile.readAsBytes());
          updateEditImageStr(attachmentBase64Image);
          updateUpdateProfileButtonEnabled(true);
        } else {
          ToastUtils.errorToast("Please upload the correct image");
        }
      } else {
        updateEditImageStr(null);
        updateUpdateProfileButtonEnabled(false);
      }
      checkHasDetailsChanged();
    } catch (e) {
      _logger.fine(e);
    }
  }
}
