import 'dart:async';

import 'package:admin/extensions/context.dart';
import 'package:admin/pages/auth/forgot_password/forgot_password.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/text_fields/email_text_form_field.dart';
import 'package:admin/widgets/text_fields/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.onSubmit,
  });
  final VoidCallback onSubmit;

  @override
  Widget build(final BuildContext context) {
    final bloc = LoginBloc.of(context);
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginBlocSelector(
            selector: (final state) => state.loginApi.error,
            builder: (final error) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.appLocalizations.login_email,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                const SizedBox(height: 10),
                LoginBlocSelector.emailField(
                  builder: (controller) {
                    return EmailTextFormField(
                      controller: controller,
                      hintText: context.appLocalizations.hint_email,
                      textInputAction: TextInputAction.next,
                      // errorText: error == null
                      //     ? null
                      //     : error.message ==
                      //             "Invalid email or password, Please try again."
                      //         ? error.message
                      //         : null,
                      onChanged: bloc.updateEmail,
                      validator: Validators.compose([
                        Validators.required(
                          context.appLocalizations.login_errEmailReq,
                        ),
                        Validators.email(
                          context.appLocalizations.login_errEmailInvalid,
                        ),
                      ]),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          LoginBlocSelector(
            selector: (final state) => state.loginApi.error,
            builder: (final error) => LoginBlocSelector.obscureText(
              builder: (obscureText) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.appLocalizations.login_password,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 10),
                    LoginBlocSelector.passwordField(
                      builder: (controller) {
                        return PasswordTextFormField(
                          controller: controller,
                          hintText: context.appLocalizations.hint_password,
                          errorText: error?.message,
                          obscureText: obscureText,
                          onPressed: () {
                            bloc.updateObscureText(!obscureText);
                          },
                          onChanged: bloc.updatePassword,
                          validator: Validators.compose([
                            Validators.required(
                              context.appLocalizations.login_errPasswordReq,
                            ),
                            Validators.maxLength(48, "Password is too long"),
                            Validators.minLength(8, "Password is too short"),
                            Validators.patternRegExp(
                              RegExp(
                                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]+$',
                              ),
                              context.appLocalizations.invalid_password,
                            ),
                          ]),
                          onFieldSubmitted: (final _) => onSubmit(),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                overlayColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: () {
                LoginBloc.of(context).reInitializeState();
                unawaited(
                  ForgotPasswordPage.push(context)
                      .then((v) => FocusNode().unfocus()),
                );
              },
              child: Text(
                context.appLocalizations.forget_password,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      // decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).primaryColor,
                      fontSize: 15,
                      color: AppColors.darkBluePrimaryColor,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
