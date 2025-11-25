import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';

class BuildSectionTitle extends StatelessWidget {
  const BuildSectionTitle({
    super.key,
    required this.title,
    this.pendingEmail,
    this.needFontWeight400,
  });
  final String title;
  final String? pendingEmail;
  final bool? needFontWeight400;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: CommonFunctions.getThemeBasedWidgetColor(context),
                fontSize: 16,
                fontWeight: needFontWeight400 == true
                    ? FontWeight.w400
                    : FontWeight.w600,
              ),
        ),
        const Spacer(),
        if (pendingEmail != null &&
            title == context.appLocalizations.login_email_address)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              UserProfileBloc.of(context).callUpdateProfile(pendingEmail: true);
            },
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: CommonFunctions.getThemeBasedWidgetColor(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
