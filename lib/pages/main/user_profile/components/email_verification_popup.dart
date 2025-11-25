import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/logout/bloc/logout_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class EmailVerificationPopup extends StatelessWidget {
  const EmailVerificationPopup({super.key, required this.logoutBloc});
  final LogoutBloc logoutBloc;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocProvider.value(
        value: logoutBloc,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.appLocalizations.email_verification_popup_title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color:
                            CommonFunctions.getThemeBasedWidgetColor(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {},
                  child: CustomGradientButton(
                    onSubmit: () {
                      logoutBloc.callLogoutAllSessions();
                      Navigator.pop(context);
                    },
                    customWidth: 100.w,
                    label: context.appLocalizations.general_ok,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
