import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/logout/bloc/logout_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/components/email_verification_popup.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class ProfileOtpPage extends StatelessWidget {
  ProfileOtpPage({
    super.key,
    this.successReleaseTransferFunction,
    this.otpFor,
    this.updatedPhoneNumber,
  });
  final VoidCallback? successReleaseTransferFunction;
  final String? otpFor;
  final String? updatedPhoneNumber;

  static const routeName = 'Profile_Otp';

  final FocusNode focusNode = FocusNode();

  static Future<void> push(
    final BuildContext context, {
    final VoidCallback? successReleaseTransferFunction,
    final String? otpFor,
    final String? updatedPhoneNumber,
  }) {
    UserProfileBloc.of(context)
      ..sendOtp(otpFor == null ? null : true)
      ..updateClearOtp(false)
      ..otpController.clear()
      ..updateOtpError("");

    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => ProfileOtpPage(
        otpFor: otpFor,
        successReleaseTransferFunction: successReleaseTransferFunction,
        updatedPhoneNumber: updatedPhoneNumber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = UserProfileBloc.of(context);
    final themeTextColor = CommonFunctions.getThemeBasedWidgetColor(context);
    String number = "";
    if (updatedPhoneNumber != null) {
      if (updatedPhoneNumber!.isNotEmpty) {
        number = updatedPhoneNumber!;
      } else {
        number = singletonBloc.profileBloc.state!.phone!;
      }
    } else {
      number = singletonBloc.profileBloc.state!.phone!;
    }
    return AppScaffold(
      appTitle: context.appLocalizations.otp.toUpperCase(),
      body: NoGlowListViewWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        context.appLocalizations.verify,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 22,
                                  color: themeTextColor,
                                ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.appLocalizations.message_otp.replaceAll(
                          "99",
                          number.isEmpty
                              ? ''
                              : number.substring(
                                  singletonBloc
                                          .profileBloc.state!.phone!.length -
                                      2,
                                ),
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: themeTextColor,
                            ),
                      ),
                      const SizedBox(height: 35),
                      UserProfileBlocSelector(
                        selector: (state) => state.otpError,
                        builder: (error) {
                          return Text(
                            error.isEmpty
                                ? context.appLocalizations.enter_otp_code
                                : error,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: error.isEmpty
                                      ? Theme.of(context).disabledColor
                                      : Colors.red,
                                ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      UserProfileBlocSelector(
                        selector: (state) => state.otpError,
                        builder: (error) {
                          return UserProfileBlocSelector(
                            selector: (state) => state.clearOtp,
                            builder: (clear) {
                              return Pinput(
                                controller: bloc.otpController,
                                length: 6,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                autofocus: true,
                                focusNode: focusNode,
                                onTap: () {
                                  if (!focusNode.hasFocus) {
                                    focusNode.requestFocus();
                                  }
                                },
                                forceErrorState: error.isNotEmpty,
                                onChanged: (val) {
                                  bloc.updateOtp(val);
                                  if (!bloc.state.clearOtp) {
                                    bloc.updateClearOtp(true);
                                  }
                                  if (val.isNotEmpty &&
                                      bloc.state.otpError.isNotEmpty) {
                                    bloc.updateOtpError("");
                                  }
                                },
                                errorPinTheme: PinTheme(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                submittedPinTheme: const PinTheme(
                                  height: 60,
                                  width: 60,
                                  textStyle: TextStyle(
                                    fontSize: 17,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.darkBluePrimaryColor,
                                  ),
                                ),
                                defaultPinTheme: PinTheme(
                                  height: 60,
                                  width: 60,
                                  textStyle: const TextStyle(
                                    fontSize: 17,
                                    color: AppColors.darkBluePrimaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: AppColors.darkBluePrimaryColor,
                                    ),
                                  ),
                                ),
                                onCompleted: (verificationCode) async {
                                  bloc.updateOtp(verificationCode);
                                  final LogoutBloc logoutBloc =
                                      LogoutBloc.of(context);
                                  await bloc.callOtp(
                                    context: context,
                                    emailChangedFunction: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (emailVerificationContext) {
                                          return EmailVerificationPopup(
                                            logoutBloc: logoutBloc,
                                          );
                                        },
                                      );
                                    },
                                    phoneChangedFunction: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    otpFor: otpFor,
                                    successReleaseTransferFunction:
                                        successReleaseTransferFunction,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 35),
                      UserProfileBlocSelector.remainingSeconds(
                        builder: (remainingSeconds) {
                          return UserProfileBlocSelector.resendOtp(
                            builder: (resendOtp) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  if (resendOtp) {
                                    await bloc.sendOtp(
                                      otpFor == null ? null : true,
                                    );
                                    bloc.otpController.clear();
                                    bloc
                                      ..updateClearOtp(true)
                                      ..updateOtp("")
                                      ..updateOtpError("");
                                  }
                                },
                                child: Column(
                                  children: [
                                    if (!resendOtp)
                                      Text(
                                        "00:${remainingSeconds.toString().length == 1 ? "0$remainingSeconds" : remainingSeconds}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                      )
                                    else
                                      const SizedBox.shrink(),
                                    Text(
                                      context.appLocalizations.did_not_get,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color:
                                                Theme.of(context).disabledColor,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      context.appLocalizations.resend,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                            color: resendOtp
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                    .disabledColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: resendOtp
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey,
                                            decorationThickness: 2,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
