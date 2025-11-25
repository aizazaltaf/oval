import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/user_profile/bloc/change_password_bloc.dart';
import 'package:admin/pages/main/user_profile/components/build_section_title.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/text_fields/password_text_form_field.dart';
import 'package:flutter/material.dart';

class ConfirmNewPasswordWidget extends StatelessWidget {
  const ConfirmNewPasswordWidget({super.key, required this.changePasswordBloc});
  final ChangePasswordBloc changePasswordBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildSectionTitle(
          title: context.appLocalizations.login_confirm_password,
          needFontWeight400: true,
        ),
        ChangePasswordBlocSelector.confirmPasswordObscure(
          builder: (obscureText) {
            return PasswordTextFormField(
              hintText: context.appLocalizations.hint_password,
              obscureText: obscureText,
              onChanged: (onChanged) {
                changePasswordBloc.updateConfirmPassword(onChanged);
                if (changePasswordBloc.state.confirmPassword !=
                    changePasswordBloc.state.newPassword) {
                  changePasswordBloc.updateConfirmPasswordError(
                    context.appLocalizations.confirm_change_password_error,
                  );
                } else {
                  changePasswordBloc.updateConfirmPasswordError("");
                }
                changePasswordBloc.getConfirmButtonEnabled();
              },
              onPressed: () {
                changePasswordBloc.updateConfirmPasswordObscure(!obscureText);
              },
            );
          },
        ),
        ChangePasswordBlocSelector.confirmPasswordError(
          builder: (error) {
            return error.isEmpty
                ? const SizedBox.shrink()
                : CommonFunctions.defaultErrorWidget(
                    context: context,
                    message: error,
                  );
          },
        ),
      ],
    );
  }
}
