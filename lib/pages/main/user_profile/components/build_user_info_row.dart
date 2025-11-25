import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class BuildUserInfoRow extends StatelessWidget {
  const BuildUserInfoRow({
    super.key,
    this.title = "",
    this.iconPath,
    required this.userInfoType,
  });

  final String title;
  final IconData? iconPath;
  final int userInfoType;

  @override
  Widget build(BuildContext context) {
    final ProfileBloc profileBloc = singletonBloc.profileBloc;
    String code = "";
    String phoneNumberWithoutDialCode = "";
    if (userInfoType == 3) {
      if (profileBloc.state?.phone != null) {
        code = CommonFunctions.getDialCode(profileBloc.state!.phone!);
        phoneNumberWithoutDialCode =
            profileBloc.state!.phone!.replaceFirst(code, '');
        if (code == "+1") {
          code = "US";
        }
      }
    }
    return Row(
      children: [
        if (userInfoType == 3)
          CountryCodePicker(
            initialSelection: code,
            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: CommonFunctions.getThemeBasedWidgetColor(context),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
            enabled: false,
          )
        else
          Icon(
            iconPath,
            size: 20,
            color: CommonFunctions.getThemeBasedWidgetColor(context),
          ),
        if (userInfoType == 3)
          const SizedBox.shrink()
        else
          SizedBox(
            width: 3.w,
          ),
        SizedBox(
          width: (userInfoType == 1 || userInfoType == 2)
              ? MediaQuery.of(context).size.width * 0.58
              : null,
          child: Text(
            userInfoType == 3 ? phoneNumberWithoutDialCode : title,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: CommonFunctions.getThemeBasedWidgetColor(context),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
        const Spacer(),
        // Email verification
        if (userInfoType == 1)
          ProfileBlocSelector.pendingEmail(
            builder: (emailPending) {
              return emailPending == null
                  ? Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: AppColors.successToastPrimaryColors,
                    )
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        ToastUtils.infoToast(
                          null,
                          "Your new email address will be reflected after verification.",
                        );
                      },
                      child: Icon(
                        Icons.error,
                        size: 20,
                        color: AppColors.errorToastPrimaryColors,
                      ),
                    );
            },
          )
        else
          const SizedBox.shrink(),
        // Phone Verification
        if (userInfoType == 3)
          Icon(
            Icons.check_circle_rounded,
            size: 20,
            color: AppColors.successToastPrimaryColors,
          )
        else
          const SizedBox.shrink(),

        /// Pending Email (Removed)
        // userInfoType == 2
        //     ? Icon(Icons.error,
        //         size: 20, color: AppColors.errorToastPrimaryColors)
        //     : const SizedBox.shrink()
      ],
    );
  }
}
