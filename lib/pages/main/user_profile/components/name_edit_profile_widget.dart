import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/components/build_section_title.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NameEditProfileWidget extends StatelessWidget {
  const NameEditProfileWidget({
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
          title: context.appLocalizations.name,
          needFontWeight400: true,
        ),
        SizedBox(
          height: 1.h,
        ),
        UserProfileBlocSelector.editName(
          builder: (editNameValue) {
            return NameTextFormField(
              autoFocus: isFocus,
              initialValue: editNameValue,
              hintText: context.appLocalizations.name,
              onChanged: userProfileBloc.updateEditName,
              validator: (val) {
                return null;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z\s]'),
                ), // Allow alphabets and spaces
                LengthLimitingTextInputFormatter(30),
              ],
              prefix: Icon(MdiIcons.accountOutline, size: 20),
            );
          },
        ),
        UserProfileBlocSelector.nameErrorMessage(
          builder: (nameError) {
            return nameError.isEmpty
                ? const SizedBox.shrink()
                : CommonFunctions.defaultErrorWidget(
                    context: context,
                    message: nameError,
                  );
          },
        ),
      ],
    );
  }
}
