import 'package:admin/core/config.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/dashboard/components/logout_dialog.dart';
import 'package:admin/pages/main/logout/login_activity_page.dart';
import 'package:admin/pages/main/more_dashboard/components/more_expansion_widgets.dart';
import 'package:admin/pages/main/more_dashboard/components/more_list_tile_card.dart';
import 'package:admin/pages/main/more_dashboard/components/profile_info_panel.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DashboardMorePage extends StatelessWidget {
  const DashboardMorePage({super.key, this.isNavigated = false});

  static const routeName = "dashboardMorePage";
  final bool isNavigated;

  static Future<void> push(final BuildContext context, final bool isNavigated) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => DashboardMorePage(isNavigated: isNavigated),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ProfileInfoPanel(isNavigated: isNavigated),
        const MoreExpansionWidget(),
        Container(
          margin: const EdgeInsets.only(left: 25),
          child: Column(
            children: [
              MoreListTileCard(
                title: context.appLocalizations.invite_a_friend_and_Neighbour
                    .toUpperCase(),
                leadingWidget: SvgPicture.asset(
                  DefaultIcons.INVITE_FRIEND_MORE,
                  height: 14,
                  width: 14,
                  colorFilter: ColorFilter.mode(
                    CommonFunctions.getThemeBasedPrimaryWhiteColor(context),
                    BlendMode.srcIn,
                  ),
                ),
                onSubmit: () {
                  ToastUtils.infoToast(
                    context.appLocalizations.coming_soon,
                    context.appLocalizations
                        .invite_friend_neighbour_available_soon,
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              MoreListTileCard(
                title: context.appLocalizations.logged_in_devices.toUpperCase(),
                leadingPadding: const EdgeInsets.only(right: 4),
                leadingWidget: Icon(
                  CupertinoIcons.device_phone_portrait,
                  size: 24,
                  color: CommonFunctions.getThemeBasedPrimaryWhiteColor(
                    context,
                  ),
                ),
                onSubmit: () => LoginActivityPage.push(context),
              ),
              const SizedBox(
                height: 10,
              ),
              MoreListTileCard(
                title:
                    context.appLocalizations.general_information.toUpperCase(),
                leadingPadding: const EdgeInsets.only(right: 7),
                leadingWidget: Icon(
                  Icons.info_outline_rounded,
                  size: 24,
                  color:
                      CommonFunctions.getThemeBasedPrimaryWhiteColor(context),
                ),
                onSubmit: () {
                  ToastUtils.infoToast(
                    context.appLocalizations.coming_soon,
                    context.appLocalizations.general_information_available_soon,
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              MoreListTileCard(
                title:
                    context.appLocalizations.terms_and_conditions.toUpperCase(),
                leadingPadding: const EdgeInsets.all(6),
                leadingWidget: SvgPicture.asset(
                  DefaultIcons.TERMS_CONDITIONS,
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    CommonFunctions.getThemeBasedPrimaryWhiteColor(context),
                    BlendMode.srcIn,
                  ),
                ),
                onSubmit: () {
                  ToastUtils.infoToast(
                    context.appLocalizations.coming_soon,
                    context
                        .appLocalizations.terms_and_conditions_available_soon,
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              MoreListTileCard(
                title: context.appLocalizations.whats_new.toUpperCase(),
                leadingWidget: Icon(
                  Icons.question_mark,
                  size: 24,
                  color:
                      CommonFunctions.getThemeBasedPrimaryWhiteColor(context),
                ),
                leadingPadding: const EdgeInsets.only(right: 6),
                onSubmit: () async {
                  final PackageInfo packageInfo =
                      await PackageInfo.fromPlatform();

                  final String version = packageInfo.version; // e.g., "1.0.0"
                  final String buildNumber =
                      packageInfo.buildNumber; // e.g., "5"
                  if (context.mounted) {
                    ToastUtils.infoToast(
                      context.appLocalizations.coming_soon,
                      context.appLocalizations.whats_new_available_soon
                          .replaceFirst(
                        "What's New",
                        "What's New (${config.environment.name} $version+$buildNumber)",
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              MoreListTileCard(
                title: context.appLocalizations.logout.toUpperCase(),
                leadingPadding: const EdgeInsets.only(left: 6, right: 3),
                leadingWidget: Icon(
                  Icons.logout_outlined,
                  size: 24,
                  color:
                      CommonFunctions.getThemeBasedPrimaryWhiteColor(context),
                ),
                onSubmit: () {
                  final voiceControlBloc = VoiceControlBloc.of(context);
                  showDialog(
                    context: context,
                    builder: (context) =>
                        LogoutDialog(voiceControlBloc: voiceControlBloc),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
