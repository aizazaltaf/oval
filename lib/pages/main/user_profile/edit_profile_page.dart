import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/components/email_edit_profile_widget.dart';
import 'package:admin/pages/main/user_profile/components/name_edit_profile_widget.dart';
import 'package:admin/pages/main/user_profile/components/phone_edit_profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({
    super.key,
    this.nameFocus = false,
    this.emailFocus = false,
    this.phoneFocus = false,
  });
  final bool nameFocus;
  final bool emailFocus;
  final bool phoneFocus;

  @override
  Widget build(BuildContext context) {
    final userProfileBloc = UserProfileBloc.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NameEditProfileWidget(
          userProfileBloc: userProfileBloc,
          isFocus: nameFocus,
        ),
        SizedBox(
          height: 2.h,
        ),
        EmailEditProfileWidget(
          userProfileBloc: userProfileBloc,
          isFocus: emailFocus,
        ),
        SizedBox(
          height: 2.h,
        ),
        PhoneEditProfileWidget(
          userProfileBloc: userProfileBloc,
          isFocus: phoneFocus,
        ),
      ],
    );
  }
}
