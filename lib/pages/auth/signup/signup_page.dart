import 'dart:async';

import 'package:admin/extensions/context.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/pages/auth/otp/otp_page.dart';
import 'package:admin/pages/auth/signup/signup_form.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/form.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  static const routeName = 'Signup';

  static Future<void> push(final BuildContext context) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const SignupPage(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final bloc = LoginBloc.of(context);
    return PopScope(
      onPopInvokedWithResult: (_, r) {
        LoginBloc.of(context).reInitializeState();
      },
      child: LoginBlocSelector(
        selector: (final state) => state.signUpApi.isApiInProgress,
        builder: (final disableForm) => AppForm(
          disable: disableForm,
          child: AuthScaffold(
            onBackPressed: () {
              Navigator.pop(context);
            },
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
                right: 20,
                left: 20,
                top: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Builder(
                    builder: (buttonContext) => _BottomButtons(
                      onSubmit: () {
                        if (bloc.state.checkBox) {
                          _onSubmit(buttonContext, bloc);
                        } else {
                          ToastUtils.warningToast(
                            buttonContext.appLocalizations.agree,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      LoginBloc.of(context)
                        ..reInitializeState()
                        ..updateSignUpLoading(false);
                      Navigator.pop(context);
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: context
                                .appLocalizations.already_have_an_account,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          const TextSpan(text: " "),
                          TextSpan(
                            text: context.appLocalizations.login_btnDone,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  // decoration: TextDecoration.underline,
                                  decorationColor:
                                      Theme.of(context).primaryColor,
                                  fontSize: 15,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            appTitle: context.appLocalizations.registration,
            body: NoGlowListViewWrapper(
              child: Builder(
                builder: (final context) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 10),
                      SignupForm(
                        onSubmit: () {
                          if (bloc.state.checkBox) {
                            _onSubmit(context, bloc);
                          } else {
                            ToastUtils.warningToast(
                              context.appLocalizations.agree,
                            );
                          }
                        },
                      ),
                      // const SizedBox(height: 20),
                      // _BottomButtons(
                      //   onSubmit: () {
                      //     if (bloc.state.checkBox) {
                      //       _onSubmit(context, bloc);
                      //     } else {
                      //       ToastUtils.warningToast(
                      //         context.appLocalizations.agree,
                      //       );
                      //     }
                      //   },
                      // ),
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

  Future<void> _onSubmit(final BuildContext context, LoginBloc bloc) async {
    if (!Form.of(context).validate()) {
      return;
    }
    bloc.updateSignUpLoading(true);
    await bloc.callValidateEmail(
      successFunction: () async {
        if (!LoginBloc.of(context).state.signUpApi.isApiInProgress) {
          await LoginBloc.of(context).callSignup();
        }
        if (context.mounted &&
            LoginBloc.of(context).state.signUpApi.error == null) {
          unawaited(OtpPage.push(context));
          bloc.updateSignUpLoading(false);
        }
      },
    );
  }
}

class _BottomButtons extends StatelessWidget {
  const _BottomButtons({
    required this.onSubmit,
  });
  final VoidCallback onSubmit;

  @override
  Widget build(final BuildContext context) {
    return LoginBlocSelector(
      selector: (final state) => state.signUpLoading,
      builder: (final isSignupApiInProgress) =>
          LoginBlocSelector.isSignupEnabled(
        builder: (isSignupEnabled) => CustomGradientButton(
          onSubmit: onSubmit,
          label: context.appLocalizations.sign_up,
          isButtonEnabled: isSignupEnabled,
          isLoadingEnabled: isSignupApiInProgress,
        ),
      ),
    );
  }
}
