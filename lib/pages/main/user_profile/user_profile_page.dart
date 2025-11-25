import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/user_profile/change_password_page.dart';
import 'package:admin/pages/main/user_profile/components/build_section_title.dart';
import 'package:admin/pages/main/user_profile/components/build_user_info_row.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildSectionTitle(title: context.appLocalizations.full_name),
        SizedBox(
          height: 2.h,
        ),
        ProfileBlocSelector.name(
          builder: (name) {
            return Padding(
              padding: const EdgeInsets.only(left: 12),
              child: BuildUserInfoRow(
                title: singletonBloc.profileBloc.state?.name ?? "",
                userInfoType: 0,
                iconPath: MdiIcons.accountOutline,
              ),
            );
          },
        ),
        SizedBox(
          height: 2.h,
        ),
        ProfileBlocSelector.pendingEmail(
          builder: (pendingEmail) {
            return BuildSectionTitle(
              title: context.appLocalizations.login_email_address,
              pendingEmail: pendingEmail,
            );
          },
        ),
        SizedBox(
          height: 2.h,
        ),
        ProfileBlocSelector.email(
          builder: (email) {
            return Padding(
              padding: const EdgeInsets.only(left: 12),
              child: BuildUserInfoRow(
                title: singletonBloc.profileBloc.state?.email ?? "",
                userInfoType: 1,
                iconPath: Icons.email_outlined,
              ),
            );
          },
        ),
        SizedBox(
          height: 2.h,
        ),
        BuildSectionTitle(title: context.appLocalizations.number),
        SizedBox(
          height: 0.5.h,
        ),
        ProfileBlocSelector.phone(
          builder: (phone) {
            return const BuildUserInfoRow(userInfoType: 3);
          },
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(
            style: const ButtonStyle(
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
            ),
            onPressed: () => ChangePasswordPage.push(context),
            child: Container(
              margin: const EdgeInsets.only(top: 29),
              child: Text(
                context.appLocalizations.change_password_button,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.darkPurpleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
