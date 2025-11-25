import 'dart:async';

import 'package:admin/extensions/context.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/pages/auth/otp/verify_email_page.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/otp_verification_screen.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatelessWidget {
  OtpPage({super.key});

  static const routeName = 'Otp';

  final FocusNode focusNode = FocusNode();

  static Future<void> push(final BuildContext context) {
    LoginBloc.of(context)
      ..otpController.clear()
      ..updateClearOtp(false)
      ..updateOtpError("");
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => OtpPage(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final bloc = LoginBloc.of(context);
    final themeTextColor = CommonFunctions.getThemeBasedWidgetColor(context);
    return LoginBlocSelector(
      selector: (final state) => state.otpApi.isApiInProgress,
      builder: (final disableForm) => AppForm(
        disable: disableForm,
        child: AuthScaffold(
          appTitle: context.appLocalizations.otp.toUpperCase(),
          body: NoGlowListViewWrapper(
            child: Builder(
              builder: (final context) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          bloc.state.phoneNumber!.isEmpty
                              ? ''
                              : bloc.state.phoneNumber!.substring(
                                  bloc.state.phoneNumber!.length - 2,
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
                      LoginBlocSelector(
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
                      LoginBlocSelector(
                        selector: (state) => state.otpError,
                        builder: (error) {
                          return LoginBlocSelector(
                            selector: (state) => state.clearOtp,
                            builder: (clear) {
                              return LoginBlocSelector(
                                selector: (final state) =>
                                    state.otpApi.isApiInProgress,
                                builder: (final isSignupApiInProgress) =>
                                    Pinput(
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
                                    if (val.isNotEmpty) {
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
                                  onCompleted: (verificationCode) {
                                    bloc.updateOtp(verificationCode);
                                    _onSubmit(context);
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 35),
                      LoginBlocSelector.remainingSeconds(
                        builder: (remainingSeconds) {
                          return LoginBlocSelector.resendOtp(
                            builder: (resendOtp) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  if (resendOtp) {
                                    await bloc.callSignup();
                                    bloc.otpController.clear();
                                    bloc
                                      ..updateClearOtp(true)
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
                                                : Colors.grey,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: resendOtp
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey,
                                            decorationThickness: 2,
                                            fontWeight: FontWeight.bold,
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit(final BuildContext context) async {
    final bloc = LoginBloc.of(context);
    await bloc.callOtp(context);
    if (context.mounted && bloc.state.otpApi.error == null) {
      // ToastUtils.successToast("OTP Verified Successfully");
      // Navigator.pop(context);
      final String email = bloc.state.email;
      unawaited(
        OtpVerificationScreen.push(
          context: context,
          function: () {
            unawaited(VerifyEmailPage.push(context: context, email: email));
          },
          number: "${bloc.state.phoneNumber}",
        ),
      );
      bloc.reInitializeState();
    }
  }
}
