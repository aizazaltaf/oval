import 'dart:async';

import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/device_onboarding/bluetooth_scan_page.dart';
import 'package:admin/pages/main/iot_devices/view_all_devices.dart';
import 'package:admin/pages/main/more_dashboard/components/subcomponents/more_expansion_tile.dart';
import 'package:admin/pages/main/statistics/statistics_page.dart';
import 'package:admin/pages/main/user_management/bloc/user_management_bloc.dart';
import 'package:admin/pages/main/user_management/user_management_page.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/voice_control/voice_control_screen.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/main_theme_screen.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeatureExpandedTiles extends StatelessWidget {
  FeatureExpandedTiles({super.key});

  final List<FeatureModel> featuresElements = [
    FeatureModel(
      title: "Manage Devices",
      image: DefaultIcons.MANAGE_DEVICES_MORE,
      route: ViewAllDevices.push,
    ),
    FeatureModel(
      title: "Manage Users",
      image: DefaultIcons.MANAGE_USER_MORE,
      route: (context) async {
        final userManagementBloc = UserManagementBloc.of(context)
          ..reInitializeUserManagementFields();
        if (userManagementBloc.state.roles.isEmpty) {
          unawaited(userManagementBloc.callRoles());
        }
        unawaited(UserManagementPage.push(context));
      },
    ),
    FeatureModel(
      title: "Visitors",
      image: DefaultIcons.VST_MNG_MORE,
      route: (context) {
        StartupBloc.of(context).pageIndexChanged(1);
        VisitorManagementBloc.of(context).callFilters();
      },
    ),
    FeatureModel(
      title: "Visitor Book",
      image: DefaultIcons.VISITOR_BOOK_MORE,
      route: (context) {
        ToastUtils.infoToast(
          context.appLocalizations.coming_soon,
          context.appLocalizations.visitor_book_available_soon,
        );
      },
    ),
    FeatureModel(
      title: "Themes",
      image: DefaultIcons.THEMES_MORE,
      route: (context) async {
        ThemeBloc.of(context.mounted ? context : context)
            .updateActiveType("Feed");
        unawaited(MainThemeScreen.push(context, false));
      },
    ),
    FeatureModel(
      title: "Neighbourhoods",
      image: DefaultIcons.NEIGHBOURHOOD_MORE,
      route: (context) {
        ToastUtils.infoToast(
          context.appLocalizations.coming_soon,
          context.appLocalizations.neighbourhood_available_soon,
        );
      },
    ),
    FeatureModel(
      title: "Voice Control",
      image: DefaultIcons.VOICE_CONTROL_MORE,
      route: (context) {
        unawaited(VoiceControlScreen.push(context));
      },
    ),
    FeatureModel(
      title: "Statistics",
      image: DefaultIcons.STATISTICS_MORE,
      route: (context) => StatisticsPage.push(context: context),
    ),
    FeatureModel(
      title: "Payment History",
      image: DefaultIcons.PAYMENT_HISTORY_MORE,
      route: (context) {
        ToastUtils.infoToast(
          context.appLocalizations.coming_soon,
          context.appLocalizations.payment_history_available_soon,
        );
      },
    ),
    FeatureModel(
      title: "Add a New Doorbell",
      image: DefaultIcons.ADD_DOORBELL_MORE,
      route: BluetoothScanPage.push,
    ),
    FeatureModel(
      title: "Feature Guide",
      image: DefaultIcons.FEATURE_GUIDE_MORE,
      route: (context) {
        ToastUtils.infoToast(
          context.appLocalizations.coming_soon,
          context.appLocalizations.feature_guide_available_soon,
        );
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return StartupBlocSelector.moreCustomFeatureTileExpanded(
      builder: (featureTileExpansion) {
        return MoreExpansionTile(
          title: context.appLocalizations.features.toUpperCase(),
          isExpanded: featureTileExpansion,
          list: featuresElements,
          tileLeading: SvgPicture.asset(
            DefaultIcons.FEATURES_MORE_ICON,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              CommonFunctions.getThemeBasedPrimaryWhiteColor(context),
              BlendMode.srcIn,
            ),
          ),
          onTapTile: () {
            StartupBloc.of(context)
                .updateMoreCustomFeatureTileExpanded(!featureTileExpansion);
            if (!featureTileExpansion) {
              StartupBloc.of(context)
                ..updateMoreCustomSettingsTileExpanded(false)
                ..updateMoreCustomPaymentsTileExpanded(false);
            }
          },
        );
      },
    );
  }
}
