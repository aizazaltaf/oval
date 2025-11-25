import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/user_profile/bloc/change_password_bloc.dart';
import 'package:admin/pages/main/user_profile/components/build_section_title.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/text_fields/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class NewPasswordWidget extends StatelessWidget {
  const NewPasswordWidget({super.key, required this.changePasswordBloc});
  final ChangePasswordBloc changePasswordBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildSectionTitle(
          title: context.appLocalizations.new_password,
          needFontWeight400: true,
        ),
        ChangePasswordBlocSelector.newPasswordObscure(
          builder: (obscureText) {
            return PasswordTextFormField(
              hintText: context.appLocalizations.hint_password,
              obscureText: obscureText,
              onChanged: (onChanged) {
                changePasswordBloc.updateNewPassword(onChanged);
                if (changePasswordBloc.state.newPassword.trim().isEmpty ||
                    changePasswordBloc.state.newPassword.length < 8 ||
                    !Constants.passwordRegex
                        .hasMatch(changePasswordBloc.state.newPassword)) {
                  changePasswordBloc.updateNewPasswordError(
                    context.appLocalizations.new_password_security_error,
                  );
                } else if (changePasswordBloc.state.oldPassword.trim() ==
                    changePasswordBloc.state.newPassword.trim()) {
                  changePasswordBloc.updateNewPasswordError(
                    context.appLocalizations.new_password_error,
                  );
                } else {
                  changePasswordBloc.updateNewPasswordError("");
                }
                changePasswordBloc
                  ..getPasswordStrength()
                  ..getConfirmButtonEnabled();
              },
              onPressed: () {
                changePasswordBloc.updateNewPasswordObscure(!obscureText);
              },
            );
          },
        ),
        ChangePasswordBlocSelector.newPasswordError(
          builder: (error) {
            return error.isEmpty
                ? const SizedBox.shrink()
                : CommonFunctions.defaultErrorWidget(
                    context: context,
                    message: error,
                  );
          },
        ),
        SizedBox(
          height: 1.h,
        ),
        SizedBox(
          width: 100.w,
          height: 6.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.appLocalizations.password_strength,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).disabledColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Container(
                width: 44.w,
                padding: const EdgeInsets.only(top: 7, right: 5),
                child: ChangePasswordBlocSelector.strength(
                  builder: (c) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        LinearProgressIndicator(
                          minHeight: 5,
                          borderRadius: BorderRadius.circular(5),
                          value: changePasswordBloc.state.strength,
                          backgroundColor: Colors.grey[300],
                          color: changePasswordBloc.state.strengthColor,
                          // minHeight: 8,
                        ),
                        Text(
                          changePasswordBloc.state.strengthLabel,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: changePasswordBloc.state.strengthColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Text(
          "• ${context.appLocalizations.least_8}\n"
          "• ${context.appLocalizations.least_1}\n"
          "• ${context.appLocalizations.least_1_number}",
        ),
      ],
    );
  }
}
