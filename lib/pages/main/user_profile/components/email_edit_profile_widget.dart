import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/components/build_section_title.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class EmailEditProfileWidget extends StatelessWidget {
  const EmailEditProfileWidget({
    super.key,
    required this.userProfileBloc,
    this.isFocus = false,
  });
  final UserProfileBloc userProfileBloc;
  final bool isFocus;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BuildSectionTitle(
          title: context.appLocalizations.login_email_address,
          needFontWeight400: true,
        ),
        SizedBox(
          height: 1.h,
        ),
        UserProfileBlocSelector.editEmail(
          builder: (editEmailValue) {
            return NameTextFormField(
              autoFocus: isFocus,
              initialValue: editEmailValue,
              hintText: context.appLocalizations.login_email,
              onChanged: userProfileBloc.updateEditEmail,
              validator: (val) {
                return null;
              },
              prefix: const Icon(Icons.email_outlined, size: 20),
            );
          },
        ),
        UserProfileBlocSelector.emailErrorMessage(
          builder: (emailError) {
            return emailError.isEmpty
                ? const SizedBox.shrink()
                : CommonFunctions.defaultErrorWidget(
                    context: context,
                    message: emailError,
                  );
          },
        ),
      ],
    );
  }
}
