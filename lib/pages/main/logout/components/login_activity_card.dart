import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/models/data/login_session_model.dart';
import 'package:admin/pages/main/logout/bloc/logout_bloc.dart';
import 'package:admin/pages/main/user_profile/bloc/user_profile_bloc.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/validate_password_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class LoginActivityCard extends StatelessWidget {
  LoginActivityCard({super.key, required this.loginActivity});
  final LoginSessionModel loginActivity;

  final SuperTooltipController superToolTipController =
      SuperTooltipController();

  String getDateTimeOfLogin() {
    return "${CommonFunctions.formatDateForApi(DateTime.parse(loginActivity.updatedAt ?? '').toLocal(), dateFormat: "MM-dd-yyyy")} "
        "at ${CommonFunctions.timeFormation(DateTime.parse(loginActivity.updatedAt ?? '').toLocal())}";
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LogoutBloc.of(context);
    final userProfileBloc = UserProfileBloc.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Icon(
              CupertinoIcons.device_phone_portrait,
              size: 25,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loginActivity.deviceName?.capitalizeFirstOfEach() ??
                      loginActivity.deviceType ??
                      '',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            CommonFunctions.getThemeBasedWidgetColor(context),
                      ),
                ),
                Text(
                  loginActivity.location ?? '',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color:
                            CommonFunctions.getThemeBasedWidgetColor(context),
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getDateTimeOfLogin(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                      ),
                      LogoutBlocSelector.currentDeviceToken(
                        builder: (deviceToken) {
                          return Text(
                            loginActivity.status != null
                                ? loginActivity.status.toString()
                                : loginActivity.deviceToken ==
                                        bloc.state.currentDeviceToken
                                    ? context.appLocalizations.current_session
                                    : context.appLocalizations.active_session,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: loginActivity.status == null
                                      ? loginActivity.deviceToken ==
                                              bloc.state.currentDeviceToken
                                          ? AppColors.primaryColor
                                          : Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: superToolTipController.showTooltip,
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.only(right: 20),
              child: SuperTooltip(
                arrowTipDistance: 20,
                arrowLength: 8,
                arrowTipRadius: 6,
                shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
                backgroundColor:
                    CommonFunctions.getThemePrimaryLightWhiteColor(context),
                borderColor: Colors.white,
                barrierColor: Colors.transparent,
                shadowBlurRadius: 7,
                shadowSpreadRadius: 0,
                showBarrier: true,
                content: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (loginActivity.status != null) {
                        if (loginActivity.status!.toLowerCase() ==
                            Constants.sessionExpired) {
                          ToastUtils.errorToast(
                            "Session is already expired.",
                          );
                        } else {
                          userProfileBloc.updatePasswordErrorMessage("");
                          showDialog(
                            context: context,
                            builder: (innerContext) => ValidatePasswordDialog(
                              successFunction: () async {
                                await bloc.callLogoutOfSpecificDevice(
                                  deviceToken: loginActivity.deviceToken!,
                                );
                              },
                              userProfileBloc: userProfileBloc,
                            ),
                          );
                        }
                      } else {
                        userProfileBloc.updatePasswordErrorMessage("");
                        showDialog(
                          context: context,
                          builder: (innerContext) => ValidatePasswordDialog(
                            successFunction: () async {
                              await bloc.callLogoutOfSpecificDevice(
                                deviceToken: loginActivity.deviceToken!,
                              );
                            },
                            userProfileBloc: userProfileBloc,
                          ),
                        );
                      }
                      superToolTipController.hideTooltip();
                    },
                    child: Text(context.appLocalizations.logout),
                  ),
                ),
                controller: superToolTipController,
                child: Icon(
                  Icons.more_vert,
                  color: CommonFunctions.getThemeBasedWidgetColor(context),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
