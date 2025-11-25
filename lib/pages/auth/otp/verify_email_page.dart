import 'package:admin/extensions/context.dart';
import 'package:admin/pages/auth/login/bloc/login_bloc.dart';
import 'package:admin/pages/auth/login/login_page.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({
    super.key,
    required this.email,
    this.fromLogin = true,
    this.isPhoneChanged,
  });
  final String email;
  final bool? isPhoneChanged;
  final bool fromLogin;
  static const routeName = 'VerifyEmailPage';

  static Future<void> push({
    required BuildContext context,
    required String email,
    bool? isPhoneChanged,
    bool fromLogin = true,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => VerifyEmailPage(
        email: email,
        fromLogin: fromLogin,
        isPhoneChanged: isPhoneChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LoginBloc.of(context);
    return PopScope(
      canPop: !fromLogin,
      child: AuthScaffold(
        showBackIcon: false,
        appTitle: context.appLocalizations.otp.toUpperCase(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 60),
          child: CustomGradientButton(
            onSubmit: () {
              if (fromLogin) {
                bloc.reInitializeState();
                LoginPage.push(context: context);
              } else {
                UserProfileBloc.of(context).updateIsProfileEditing(false);
                Navigator.pop(context);
                if (isPhoneChanged == true) {
                  Navigator.pop(context);
                }
              }
            },
            label: context.appLocalizations.login_btnDone,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 80,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                context.appLocalizations.sent_email,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.w500, fontSize: 22),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: context.appLocalizations.sent_email_desc_1,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: AppColors.lightGreyColor,
                            ),
                      ),
                      TextSpan(
                        text: email,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: AppColors.darkBluePrimaryColor,
                            ),
                      ),
                      TextSpan(
                        text: context.appLocalizations.sent_email_desc_2,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: AppColors.lightGreyColor,
                            ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
