import 'dart:async';

import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/pages/auth/login/login_form.dart';
import 'package:admin/pages/auth/signup/signup_page.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static const routeName = 'login';

  static Future<void> push({required BuildContext context}) {
    return navigateToFirstAppScreen(
      context,
      builder: (final _) => const LoginPage(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return LoginBlocBuilder(
      builder: (context, state) {
        return LoginBlocSelector(
          selector: (final state) => state.loginApi.isApiInProgress,
          builder: (final disableForm) => AppForm(
            disable: disableForm,
            child: AuthScaffold(
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Builder(
                      builder: (buttonContext) => _BottomButtons(
                        onSubmit: () => _onSubmit(buttonContext),
                      ),
                    ),
                    const SizedBox(height: 30),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "${context.appLocalizations.do_you_have_account} ",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          TextSpan(
                            text: context.appLocalizations.sign_up,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                LoginBloc.of(context)
                                  ..reInitializeState()
                                  ..updateSignUpLoading(false);
                                unawaited(SignupPage.push(context));
                              },
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
                  ],
                ),
              ),
              body: NoGlowListViewWrapper(
                child: Builder(
                  builder: (final context) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Center(
                            child: Image.asset(
                              Theme.of(context).brightness == Brightness.light
                                  ? DefaultImages.APPLICATION_ICON_PNG
                                  : DefaultImages.DARK_LOGO,
                              height: 90,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: Text(
                              context.appLocalizations.welcome_back,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          LoginBlocSelector(
                            selector: (final state) =>
                                state.loginApi.isApiInProgress,
                            builder: (final isLoginApiInProgress) =>
                                LoginBlocSelector.isLoginEnabled(
                              builder: (isLoginEnabled) {
                                return LoginForm(
                                  onSubmit: () {
                                    if (isLoginEnabled) {
                                      _onSubmit(context);
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSubmit(final BuildContext context) {
    if (!Form.of(context).validate()) {
      return;
    }
    LoginBloc.of(context).callLogin(context);
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
      selector: (final state) => state.loginApi.isApiInProgress,
      builder: (final isLoginApiInProgress) => LoginBlocSelector.isLoginEnabled(
        builder: (isLoginEnabled) {
          return CustomGradientButton(
            onSubmit: onSubmit,
            label: context.appLocalizations.login_btnDone,
            isButtonEnabled: isLoginEnabled,
            isLoadingEnabled: isLoginApiInProgress,
          );
        },
      ),
    );
  }
}
