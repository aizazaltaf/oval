import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/sub_user_model.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_bloc.dart';
import 'package:admin/pages/main/user_management/components/user_info_card.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:admin/widgets/validate_password_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key, required this.subUser});
  final SubUserModel subUser;

  static const routeName = "userInfo";

  static Future<void> push({
    required BuildContext context,
    required SubUserModel subUser,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => UserInfoPage(
        subUser: subUser,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = UserManagementBloc.of(context);
    return AppScaffold(
      appTitle: context.appLocalizations.user_info,
      appBarAction: [
        if ((subUser.role!.id == 1 || subUser.role!.id == 2) ||
            (subUser.email == singletonBloc.profileBloc.state!.email) ||
            (bloc.state.loggedInUserRoleId == 4))
          const SizedBox.shrink()
        else
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (deleteUserPopUp) => AppDialogPopup(
                    title: context.appLocalizations.delete_user,
                    headerWidget: Image.asset(
                      DefaultImages.WARNING_IMAGE,
                      height: 120,
                      width: 160,
                    ),
                    description:
                        context.appLocalizations.delete_user_dialog_title,
                    cancelButtonLabel: context.appLocalizations.general_cancel,
                    confirmButtonLabel: context.appLocalizations.general_delete,
                    cancelButtonOnTap: () {
                      Navigator.pop(deleteUserPopUp);
                    },
                    confirmButtonOnTap: () {
                      Navigator.pop(deleteUserPopUp);
                      showDialog(
                        context: context,
                        builder: (validatePasswordPopUp) {
                          final UserProfileBloc userProfileBloc =
                              UserProfileBloc.of(context);
                          return ValidatePasswordDialog(
                            userProfileBloc: userProfileBloc,
                            successFunction: () {
                              if (subUser.inviteId == null) {
                                bloc.callUserDelete(
                                  popFunction: () {
                                    Navigator.pop(context);
                                  },
                                  subUserId: subUser.id,
                                );
                              } else {
                                bloc.callUserInviteDelete(
                                  popFunction: () {
                                    Navigator.pop(context);
                                  },
                                  inviteId: subUser.inviteId!,
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
              child: const Icon(CupertinoIcons.delete),
            ),
          ),
      ],
      body: NoGlowListViewWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 2.h,
              ),
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.yellow,
                      width: 4,
                    ),
                  ),
                  child: ClipOval(
                    child: (subUser.profileImage == null ||
                            subUser.profileImage!.isEmpty)
                        ? Image.asset(
                            DefaultImages.USER_IMG_PLACEHOLDER,
                          )
                        : CachedNetworkImage(
                            imageUrl: "${subUser.profileImage}",
                            useOldImageOnUrlChange: true,
                            errorWidget: (context, exception, trace) {
                              return Image.asset(
                                fit: BoxFit.cover,
                                DefaultImages.USER_IMG_PLACEHOLDER,
                              );
                            },
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              UserInfoCard(
                title: context.appLocalizations.full_name,
                value: subUser.name ?? subUser.email.split("@").first,
                icon: DefaultIcons.USER,
              ),
              SizedBox(
                height: 3.h,
              ),
              UserInfoCard(
                title: context.appLocalizations.login_email_address,
                value: CommonFunctions.maskEmail(subUser.email),
                icon: DefaultIcons.EMAIL,
              ),
              if (subUser.phoneNumber == null)
                const SizedBox.shrink()
              else
                SizedBox(
                  height: 3.h,
                ),
              if (subUser.phoneNumber == null)
                const SizedBox.shrink()
              else
                UserInfoCard(
                  title: context.appLocalizations.number,
                  value: subUser.phoneNumber!,
                ),
              SizedBox(
                height: 3.h,
              ),
              UserInfoCard(
                title: context.appLocalizations.role,
                value: subUser.role!.name,
                icon: DefaultIcons.ACCOUNT_TYPE_BIG2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
