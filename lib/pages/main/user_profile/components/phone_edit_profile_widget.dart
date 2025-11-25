import 'package:admin/core/country_codes_translated.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/pages/main/user_profile/components/build_section_title.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class PhoneEditProfileWidget extends StatelessWidget {
  const PhoneEditProfileWidget({
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
          title: context.appLocalizations.number,
          needFontWeight400: true,
        ),
        SizedBox(
          height: 1.h,
        ),
        UserProfileBlocSelector.editPhoneNumber(
          builder: (editNumberValue) {
            return NameTextFormField(
              autoFocus: isFocus,
              initialValue: editNumberValue,
              hintText: context.appLocalizations.number,
              keyboardType: TextInputType.number,
              onChanged: userProfileBloc.updateEditPhoneNumber,
              validator: (val) {
                return null;
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12),
              ],
              prefix: CountryCodePicker(
                backgroundColor: Theme.of(context).primaryColorLight,
                dialogBackgroundColor: Theme.of(context).primaryColorLight,
                padding: const EdgeInsets.all(4),
                countryList: translatedCodes,
                onChanged: (countryCode) {
                  userProfileBloc.updateCountryCode(countryCode.dialCode!);
                },
                initialSelection: userProfileBloc.state.countryCode == "+1"
                    ? "US"
                    : userProfileBloc.state.countryCode,
                textStyle: Theme.of(context).textTheme.displayMedium,
              ),
            );
          },
        ),
        UserProfileBlocSelector.phoneErrorMessage(
          builder: (phoneError) {
            return phoneError.isEmpty
                ? const SizedBox.shrink()
                : CommonFunctions.defaultErrorWidget(
                    context: context,
                    message: phoneError,
                  );
          },
        ),
      ],
    );
  }
}
