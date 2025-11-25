import 'package:admin/constants.dart';
import 'package:admin/core/country_codes_translated.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/widgets/custom_checkbox_list_tile.dart';
import 'package:admin/widgets/formatter/phone_number_formatter.dart';
import 'package:admin/widgets/text_fields/email_text_form_field.dart';
import 'package:admin/widgets/text_fields/name_text_form_field.dart';
import 'package:admin/widgets/text_fields/password_text_form_field.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
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
          Text(
            context.appLocalizations.name,
          ),
          const SizedBox(height: 10),
          NameTextFormField(
            hintText: context.appLocalizations.name,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-Z\s]'),
              ), // Allow alphabets and spaces
              LengthLimitingTextInputFormatter(30),
            ],
            prefix: Icon(MdiIcons.accountOutline, size: 20),
            onChanged: bloc.updateName,
            validator:
                Validators.required(context.appLocalizations.name_required),
          ),

          const SizedBox(height: 10),

          Text(
            context.appLocalizations.login_email_address,
          ),
          const SizedBox(height: 10),
          LoginBlocSelector(
            selector: (final state) => state.signUpApi.error,
            builder: (final error) => EmailTextFormField(
              controller: TextEditingController(text: bloc.state.email),
              hintText: context.appLocalizations.hint_email,
              errorText: error?.message,
              needAutoFillHints: false,
              textInputAction: TextInputAction.next,
              onChanged: bloc.updateEmail,
              validator: Validators.compose([
                Validators.required(context.appLocalizations.login_errEmailReq),
                Validators.patternRegExp(
                  Constants.emailRegex,
                  context.appLocalizations.login_errEmailInvalid,
                ),
              ]),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.appLocalizations.number,
          ),
          const SizedBox(height: 10),
          LoginBlocSelector.countryCode(
            builder: (countryCode) {
              return NameTextFormField(
                inputFormatters: [
                  PhoneNumberInputFormatter(),
                  LengthLimitingTextInputFormatter(12),
                ],
                keyboardType: TextInputType.number,
                onChanged: bloc.updatePhoneNumber,
                prefix: CountryCodePicker(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  dialogBackgroundColor: Theme.of(context).primaryColorLight,
                  // barrierColor: Theme.of(context).primaryColorLight,
                  padding: const EdgeInsets.all(4),
                  countryList: translatedCodes,
                  onChanged: (countryCode) {
                    bloc.updateCountryCode(countryCode.dialCode!);
                    // controller
                    //     .updateSelectedCountry(countryCode.dialCode!);
                  },
                  initialSelection: bloc.state.countryCode == "+1"
                      ? "US"
                      : bloc.state.countryCode,
                  searchDecoration: const InputDecoration(hintText: "Search"),
                  dialogTextStyle: Theme.of(context).textTheme.displayMedium,
                  textStyle: Theme.of(context).textTheme.displayMedium,
                ),
                hintText: "123-456-789",
                validator: Validators.compose([
                  Validators.required(
                    context.appLocalizations.phone_number_required,
                  ),
                  Validators.minLength(
                    9,
                    context.appLocalizations.incorrect_phone_number,
                  ),
                ]),
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            context.appLocalizations.login_password,
          ),
          const SizedBox(height: 10),
          // LoginBlocSelector(
          //   selector: (final state) => state.signUpApi.error,
          //   builder: (final error) =>
          LoginBlocSelector.obscureTextSignupPassword(
            builder: (obscureText) {
              return PasswordTextFormField(
                hintText: context.appLocalizations.hint_password,
                // errorText: error?.message,
                onChanged: bloc.updatePassword,
                needAutoFillHints: false,
                obscureText: obscureText,
                onPressed: () {
                  bloc.updateObscureTextSignupPassword(!obscureText);
                },
                validator: (value) {
                  final password = value ?? '';

                  // Check if the password is empty
                  if (password.isEmpty) {
                    return context.appLocalizations.login_errPasswordReq;
                  }

                  // Check for minimum length
                  if (password.length < 8) {
                    return context.appLocalizations.password_min_length;
                  }

                  // Check for at least one uppercase letter
                  // if (!RegExp(r'[A-Z]').hasMatch(password)) {
                  //   return context.appLocalizations.password_uppercase_required;
                  // }
                  //
                  // // Check for at least one lowercase letter
                  // if (!RegExp(r'[a-z]').hasMatch(password)) {
                  //   return context.appLocalizations.password_lowercase_required;
                  // }
                  //
                  // // Check for at least one number
                  // if (!RegExp(r'[0-9]').hasMatch(password)) {
                  //   return context.appLocalizations.password_number_required;
                  // }
                  //
                  // // Check for at least one special character
                  // if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
                  //   return context
                  //       .appLocalizations.password_special_character_required;
                  // }

                  // Check for full password
                  if (!RegExp(
                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]+$',
                  ).hasMatch(password)) {
                    return context.appLocalizations.password_error_required;
                  }

                  return null; // Valid password,
                },
                // onFieldSubmitted: (final _) => onSubmit(),
              );
            },
          ),
          // ),
          const SizedBox(height: 10),
          SizedBox(
            width: 100.w,
            height: 6.h,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    context.appLocalizations.password_strength,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: LoginBlocSelector.strength(
                    builder: (c) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(5),
                              value: bloc.state.strength,
                              backgroundColor: Colors.grey[300],
                              color: bloc.state.strengthColor,
                              // minHeight: 8,
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Text(
                              bloc.state.strengthLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: bloc.state.strengthColor,
                                  ),
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
          Text(
            context.appLocalizations.password_strength_hint,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            context.appLocalizations.login_confirm_password,
          ),
          const SizedBox(height: 10),
          // LoginBlocSelector(
          //   selector: (final state) => state.signUpApi.error,
          //   builder: (final error) =>
          LoginBlocSelector.obscureTextSignupConfirmPassword(
            builder: (obscureText) {
              return PasswordTextFormField(
                hintText: context.appLocalizations.hint_password,
                // errorText: error?.message,
                onChanged: bloc.updateConfirmPassword,
                needAutoFillHints: false,
                obscureText: obscureText,
                onPressed: () {
                  bloc.updateObscureTextSignupConfirmPassword(!obscureText);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.appLocalizations.login_errPasswordReq;
                  }
                  if (value != bloc.state.password) {
                    return context.appLocalizations.login_errPasswordMismatch;
                  }
                  return null;
                },
                onFieldSubmitted: (final _) => onSubmit(),
              );
            },
          ),
          // ),
          const SizedBox(height: 10),
          SizedBox(
            width: 90.w,
            height: 10.h,
            child: LoginBlocSelector.checkBox(
              builder: (isChecked) {
                return CustomCheckboxListTile(
                  value: isChecked,
                  onChanged: (val) {
                    bloc.updateCheckBox(val ?? false);
                  },
                  title: context.appLocalizations.check_box,
                  terms: context.appLocalizations.terms_and_condition,
                );
              },
            ),
          ),

          // Text(
          //   context.appLocalizations.forget_password,
          //   style: Theme.of(context).textTheme.titleSmall!.copyWith(
          //         fontSize: 15,
          //         color: Colors.black,
          //         fontWeight: FontWeight.w500,
          //       ),
          // ),
        ],
      ),
    );
  }
}
