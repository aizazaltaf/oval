import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/logout/bloc/logout_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/change_password_bloc.dart';
import 'package:admin/pages/main/user_profile/components/change_pwd_components/confirm_new_password_widget.dart';
import 'package:admin/pages/main/user_profile/components/change_pwd_components/new_password_widget.dart';
import 'package:admin/pages/main/user_profile/components/change_pwd_components/old_password_widget.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  static const routeName = "changePassword";

  static Future<void> push(final BuildContext context) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const ChangePasswordPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final changePasswordBloc = ChangePasswordBloc.of(context)
      ..reInitializeFields();
    return AppScaffold(
      bottomNavigationBar: ChangePasswordBlocSelector.confirmButtonEnabled(
        builder: (enable) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: ChangePasswordBlocSelector(
              selector: (state) => state.changePasswordApi.isApiInProgress,
              builder: (inProgress) {
                return CustomGradientButton(
                  isButtonEnabled: enable,
                  isLoadingEnabled: inProgress,
                  onSubmit: () {
                    if (enable) {
                      bool finalCheck = enable;
                      if (changePasswordBloc.state.oldPassword ==
                          changePasswordBloc.state.newPassword) {
                        changePasswordBloc.updateNewPasswordError(
                          context.appLocalizations.new_password_error,
                        );
                        finalCheck = false;
                      }
                      if (changePasswordBloc.state.confirmPassword !=
                          changePasswordBloc.state.newPassword) {
                        changePasswordBloc.updateConfirmPasswordError(
                          context
                              .appLocalizations.confirm_change_password_error,
                        );
                        finalCheck = false;
                      }
                      if (finalCheck) {
                        changePasswordBloc.callChangePassword(
                          logoutBloc: LogoutBloc.of(context),
                        );
                      } else {
                        changePasswordBloc.updateConfirmButtonEnabled(false);
                      }
                    }
                  },
                  label: context.appLocalizations.submit,
                );
              },
            ),
          );
        },
      ),
      appTitle: context.appLocalizations.change_password,
      body: NoGlowListViewWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 5.h,
              ),
              OldPasswordWidget(changePasswordBloc: changePasswordBloc),
              SizedBox(
                height: 2.h,
              ),
              NewPasswordWidget(changePasswordBloc: changePasswordBloc),
              SizedBox(
                height: 2.h,
              ),
              ConfirmNewPasswordWidget(changePasswordBloc: changePasswordBloc),
            ],
          ),
        ),
      ),
    );
  }
}
