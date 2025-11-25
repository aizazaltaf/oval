import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/user_profile/bloc/change_password_bloc.dart';
import 'package:admin/pages/main/user_profile/components/build_section_title.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/text_fields/password_text_form_field.dart';
import 'package:flutter/material.dart';

class OldPasswordWidget extends StatelessWidget {
  const OldPasswordWidget({super.key, required this.changePasswordBloc});
  final ChangePasswordBloc changePasswordBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildSectionTitle(
          title: context.appLocalizations.old_password,
          needFontWeight400: true,
        ),
        ChangePasswordBlocSelector.oldPasswordObscure(
          builder: (obscureText) {
            return PasswordTextFormField(
              hintText: context.appLocalizations.hint_password,
              obscureText: obscureText,
              onChanged: (onChanged) {
                changePasswordBloc.updateOldPassword(onChanged);
                if (onChanged.trim().isEmpty) {
                  changePasswordBloc.updateOldPasswordError(
                    context.appLocalizations.login_errPasswordReq,
                  );
                }
                // else if (Constants.passwordRegex.hasMatch(onChanged) == false) {
                //   changePasswordBloc.updateOldPasswordError(
                //       context.appLocalizations.old_password_error);
                // }
                else {
                  changePasswordBloc.updateOldPasswordError("");
                }
                changePasswordBloc.getConfirmButtonEnabled();
              },
              onPressed: () {
                changePasswordBloc.updateOldPasswordObscure(!obscureText);
              },
            );
          },
        ),
        ChangePasswordBlocSelector.oldPasswordError(
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
