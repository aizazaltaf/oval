import 'package:admin/extensions/context.dart';
import 'package:admin/pages/auth/login/login_page.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';

class ForgotPasswordSuccessScreen extends StatelessWidget {
  const ForgotPasswordSuccessScreen({super.key, required this.forgotEmail});

  final String forgotEmail;

  static const routeName = 'forgot_password_success';

  static Future<void> push(
    final BuildContext context,
    final String forgotEmail,
  ) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => ForgotPasswordSuccessScreen(
        forgotEmail: forgotEmail,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      appTitle: context.appLocalizations.forgotPassword,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: CustomGradientButton(
          onSubmit: () {
            LoginPage.push(context: context);
          },
          label: context.appLocalizations.login_btnDone,
        ),
      ),
      body: NoGlowListViewWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 100,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                context.appLocalizations.link_sent,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.w500, fontSize: 24),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                context.appLocalizations.resent_email
                    .replaceFirst("abcd@gmail.com", forgotEmail),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightGreyColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
