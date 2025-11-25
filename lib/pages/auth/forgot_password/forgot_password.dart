import 'dart:async';

import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/auth/forgot_password/forgot_password_success_screen.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/text_fields/email_text_form_field.dart';
import 'package:admin/widgets/text_fields/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});
  static const routeName = 'ForgotPassword';

  static Future<void> push(final BuildContext context) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => ForgotPasswordPage(),
    );
  }

  final TextEditingController forgotController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = LoginBloc.of(context);
    return PopScope(
      onPopInvokedWithResult: (_, r) {
        LoginBloc.of(context).reInitializeState();
      },
      child: LoginBlocSelector(
        selector: (final state) => state.forgetPasswordApi.isApiInProgress,
        builder: (final disableForm) => AppForm(
          disable: disableForm,
          child: AuthScaffold(
            onBackPressed: () {
              Navigator.pop(context);
            },
            bottomNavigationBar: SizedBox(
              height: 140,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _BottomButtons(
                      onSubmit: () => _onSubmit(context, bloc),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: context.appLocalizations.remember_password,
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
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
            appTitle: context.appLocalizations.forgotPassword,
            body: NoGlowListViewWrapper(
              child: Builder(
                builder: (final context) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // padding: EdgeInsets.zero,
                      // shrinkWrap: true,
                      children: [
                        Center(
                          child: Image.asset(
                            DefaultImages.LOCKFORGOTPASSWORD,
                            height: 200,
                            width: 200,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          context.appLocalizations.enter_email_verification,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          context.appLocalizations.login_email,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        EmailTextFormField(
                          controller: forgotController,
                          hintText: context.appLocalizations.hint_email,
                          textInputAction: TextInputAction.next,
                          onChanged: bloc.updateForgotEmail,
                          validator: Validators.compose([
                            Validators.required(
                              context.appLocalizations.login_errEmailReq,
                            ),
                            Validators.email(
                              context.appLocalizations.login_errEmailInvalid,
                            ),
                          ]),
                          onFieldSubmitted: (final _) =>
                              _onSubmit(context, bloc),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit(
    final BuildContext context,
    final LoginBloc bloc,
  ) async {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
    );
    if (bloc.state.forgotEmail.isEmpty ||
        !emailRegex.hasMatch(bloc.state.forgotEmail)) {
      return;
    }
    await LoginBloc.of(context).callForgotPassword(
      successFunction: () {
        unawaited(
          ForgotPasswordSuccessScreen.push(context, bloc.state.forgotEmail),
        );
        forgotController
          ..text = ''
          ..clear();
        LoginBloc.of(context).reInitializeState();
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
      selector: (final state) => state.forgetPasswordApi.isApiInProgress,
      builder: (final isForgotPasswordApiInProgress) =>
          LoginBlocSelector.isForgotEnabled(
        builder: (isForgotEnabled) {
          return CustomGradientButton(
            onSubmit: onSubmit,
            label: context.appLocalizations.send_recovery_link,
            isButtonEnabled: isForgotEnabled,
            isLoadingEnabled: isForgotPasswordApiInProgress,
            customButtonFontSize: 22,
            customButtonFontWeight: FontWeight.w400,
          );
        },
      ),
    );
  }
}
