import 'dart:async';

import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/locations/bloc/location_bloc.dart';
import 'package:admin/pages/main/locations/location_settings_page.dart';
import 'package:admin/pages/main/more_dashboard/components/subcomponents/more_expansion_tile.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';

class SettingsExpandedTiles extends StatelessWidget {
  SettingsExpandedTiles({super.key});

  final List<FeatureModel> settingsElements = [
    FeatureModel(
      title: "Modes Settings",
      image: DefaultIcons.MODE_SETTINGS_MORE,
      route: (context) {
        ToastUtils.infoToast(
          context.appLocalizations.coming_soon,
          context.appLocalizations.modes_settings_available_soon,
        );
      },
    ),
    FeatureModel(
      title: "Locations Settings",
      image: DefaultIcons.LOCATIONS_SETTINGS_MORE,
      route: (context) async {
        LocationBloc.of(context).reInitializeLocationFields();
        unawaited(LocationSettingsPage.push(context));
      },
    ),
    FeatureModel(
      title: "Shop Doorbell",
      image: DefaultIcons.SHOP_DOORBELL_MORE,
      route: (context) {
        CommonFunctions.openUrl(context.appLocalizations.shop_doorbell_url);
      },
    ),
    // FeatureModel(
    //   title: "Subscriptions",
    //   image: DefaultIcons.PAYMENT_METHOD_MORE,
    //   route: (context) {
    //     // SubscriptionPlanPage.push(context: context);
    //     ToastUtils.infoToast(
    //       context.appLocalizations.coming_soon,
    //       context.appLocalizations.payment_methods_available_soon,
    //     );
    //   },
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return StartupBlocSelector.moreCustomSettingsTileExpanded(
      builder: (settingsTileExpansion) {
        return MoreExpansionTile(
          title: context.appLocalizations.settings.toUpperCase(),
          isExpanded: settingsTileExpansion,
          list: settingsElements,
          tileLeading: Icon(
            Icons.settings_outlined,
            size: 24,
            color: CommonFunctions.getThemeBasedPrimaryWhiteColor(context),
          ),
          onTapTile: () {
            StartupBloc.of(context)
                .updateMoreCustomSettingsTileExpanded(!settingsTileExpansion);
            if (!settingsTileExpansion) {
              StartupBloc.of(context)
                ..updateMoreCustomFeatureTileExpanded(false)
                ..updateMoreCustomPaymentsTileExpanded(false);
            }
          },
        );
      },
    );
  }
}
