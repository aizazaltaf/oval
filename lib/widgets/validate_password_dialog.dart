import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:admin/widgets/text_fields/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ValidatePasswordDialog extends StatelessWidget {
  const ValidatePasswordDialog({
    super.key,
    required this.userProfileBloc,
    required this.successFunction,
  });
  final UserProfileBloc userProfileBloc;
  final VoidCallback successFunction;

  void onChangedPassword(BuildContext context, String val) {
    userProfileBloc.updateValidatePassword(val);
    if (userProfileBloc.state.validatePassword.isEmpty) {
      userProfileBloc.updatePasswordErrorMessage(
        context.appLocalizations.login_errPasswordReq,
      );
    } else {
      userProfileBloc.updatePasswordErrorMessage("");
    }
    userProfileBloc.validatePasswordEnableValidations();
  }

  @override
  Widget build(BuildContext context) {
    userProfileBloc
      ..updateConfirmButtonEnabled(false)
      ..updatePasswordErrorMessage("");
    return BlocProvider.value(
      value: userProfileBloc,
      child: Dialog(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.appLocalizations.enter_password_confirm_changes,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: CommonFunctions.getThemeBasedWidgetColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                context.appLocalizations.login_password,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: CommonFunctions.getThemeBasedWidgetColor(context),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
              ),
              SizedBox(
                height: 2.h,
              ),
              UserProfileBlocSelector.obscurePassword(
                builder: (obscureText) {
                  return PasswordTextFormField(
                    hintText: context.appLocalizations.hint_password,
                    obscureText: obscureText,
                    onChanged: (val) => onChangedPassword(context, val),
                    validator: (val) {
                      return null;
                    },
                    onFieldSubmitted: (val) {
                      if (userProfileBloc.state.confirmButtonEnabled) {
                        userProfileBloc.callValidatePassword(
                          popFunction: () {
                            Navigator.pop(context);
                          },
                          successFunction: successFunction,
                        );
                      }
                    },
                    onPressed: () {
                      userProfileBloc.updateObscurePassword(!obscureText);
                    },
                  );
                },
              ),
              UserProfileBlocSelector.passwordErrorMessage(
                builder: (passwordError) {
                  return passwordError.isEmpty
                      ? SizedBox(
                          height: 4.h,
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 2.h),
                          child: CommonFunctions.defaultErrorWidget(
                            context: context,
                            message: passwordError,
                          ),
                        );
                },
              ),
              UserProfileBlocSelector(
                selector: (state) => state.validatePasswordApi.isApiInProgress,
                builder: (inProgress) {
                  return UserProfileBlocSelector.confirmButtonEnabled(
                    builder: (enable) {
                      return CustomGradientButton(
                        isButtonEnabled: enable,
                        isLoadingEnabled: inProgress,
                        onSubmit: () {
                          if (enable) {
                            userProfileBloc.callValidatePassword(
                              popFunction: () {
                                Navigator.pop(context);
                              },
                              successFunction: successFunction,
                            );
                          }
                        },
                        label: context.appLocalizations.confirm,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
