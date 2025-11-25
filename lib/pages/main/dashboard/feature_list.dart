import 'dart:async';

import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/dashboard/components/feature_items.dart';
import 'package:admin/pages/main/dashboard/components/header_tiles.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/dashboard/view_model/filters_model.dart';
import 'package:admin/pages/main/device_onboarding/bluetooth_scan_page.dart';
import 'package:admin/pages/main/iot_devices/view_all_devices.dart';
import 'package:admin/pages/main/statistics/bloc/statistics_bloc.dart';
import 'package:admin/pages/main/statistics/components/statistics_filters_widget.dart';
import 'package:admin/pages/main/statistics/statistics_page.dart';
import 'package:admin/pages/main/voice_control/voice_control_screen.dart';
import 'package:admin/pages/themes/bloc/theme_bloc.dart';
import 'package:admin/pages/themes/main_theme_screen.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class FeatureNoDoorBellList extends StatelessWidget {
  FeatureNoDoorBellList({super.key});

  static void disabledFeaturesOnTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AppDialogPopup(
          headerWidget: Image.asset(
            DefaultImages.WARNING_IMAGE,
            height: 60,
            width: 60,
          ),
          title: context.appLocalizations.warning,
          description: context.appLocalizations.add_doorbell_to_access_feature,
          confirmButtonLabel: context.appLocalizations.add_doorbell,
          confirmButtonOnTap: () {
            Navigator.pop(dialogContext);
            // unawaited(ScanDoorbell.push(context));
            BluetoothScanPage.push(context);
          },
        );
      },
    );
  }

  final List<FeatureModel> featureList = [
    FeatureModel(
      title: "Voice\nControl",
      image: DefaultIcons.VOICE_CONTROL_MORE,
      color: const Color.fromRGBO(172, 0, 176, 1),
      route: (context) {
        unawaited(VoiceControlScreen.push(context));
      },
    ),
    FeatureModel(
      title: "Shop\nDoorbell",
      image: DefaultIcons.SHOP_DOORBELL_MORE,
      color: const Color.fromRGBO(18, 156, 129, 1),
      route: (context) {
        CommonFunctions.openUrl(context.appLocalizations.shop_doorbell_url);
      },
    ),
    FeatureModel(
      title: "Add\nDoorbell",
      image: DefaultIcons.ADD_DOORBELL_MORE,
      color: const Color.fromRGBO(206, 58, 206, 1),
      route: (context) {
        // unawaited(ScanDoorbell.push(context));
        unawaited(BluetoothScanPage.push(context));
      },
    ),
    FeatureModel(
      title: "Themes",
      image: DefaultIcons.THEMES_MORE,
      color: const Color.fromRGBO(40, 53, 235, 1),
      route: (context) async {
        ThemeBloc.of(context.mounted ? context : context)
            .updateActiveType("Feed");
        unawaited(MainThemeScreen.push(context, false));
      },
    ),
  ];

  final List<FeatureModel> disabledFeatures = [
    FeatureModel(
      title: "Smart\nDevices",
      image: DefaultIcons.MANAGE_DEVICES_MORE,
      route: (context) {
        disabledFeaturesOnTap(context);
      },
    ),
    FeatureModel(
      title: "Manage\nUsers",
      image: DefaultIcons.MANAGE_USER_MORE,
      route: (context) {
        disabledFeaturesOnTap(context);
      },
    ),
    FeatureModel(
      title: "Statistics",
      image: DefaultIcons.STATISTICS_MORE,
      route: (context) {
        disabledFeaturesOnTap(context);
      },
    ),
    FeatureModel(
      title: "Visitor Book",
      image: DefaultIcons.VISITOR_BOOK_MORE,
      route: (context) async {
        disabledFeaturesOnTap(context);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            context.appLocalizations.add_doorbell,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 22),
          ),
        ),
        TextButton(
          onPressed: null,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            overlayColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          child: FeatureItems(
            route: (context) async {
              // unawaited(ScanDoorbell.push(context));
              unawaited(BluetoothScanPage.push(context));
            },
            svgBool: false,
            cardColor: AppColors.darkBluePrimaryColor,
            image: DefaultImages.NO_DOORBELL_SCAN,
            title: context.appLocalizations.add_doorbell,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          context.appLocalizations.quick_access,
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        const SizedBox(height: 10),
        FeatureListView(featureList: featureList),
        const SizedBox(height: 10),
        FeatureListView(featureList: disabledFeatures, isDisabled: true),
      ],
    );
  }
}

class FeatureDoorBellList extends StatelessWidget {
  FeatureDoorBellList({super.key});

  final List<FeatureModel> featureList = [
    FeatureModel(
      title: "Smart\nDevices",
      image: DefaultIcons.MANAGE_DEVICES_MORE,
      color: const Color.fromRGBO(251, 104, 150, 1),
      route: (context) async {
        unawaited(ViewAllDevices.push(context));
      },
    ),
    // FeatureModel(
    //   title: "Manage Users",
    //   image: DefaultVectors.MANAGE_USERS_DASH,
    //   color: const Color.fromRGBO(49, 204, 46, 1),
    //   route: (context) async {
    //     UserManagementBloc.of(context).reInitializeUserManagementFields();
    //     unawaited(UserManagementPage.push(context));
    //   },
    // ),
    FeatureModel(
      title: "Voice\nControl",
      image: DefaultIcons.VOICE_CONTROL_MORE,
      color: const Color.fromRGBO(172, 0, 176, 1),
      route: (context) {
        unawaited(VoiceControlScreen.push(context));
      },
    ),
    FeatureModel(
      title: "Statistics",
      image: DefaultIcons.STATISTICS_MORE,
      color: const Color.fromRGBO(238, 179, 4, 1),
      route: (context) async {
        StatisticsBloc.of(context)
          ..updateSelectedDropDownValue(Constants.peakVisitorsHourKey)
          ..updateSelectedTimeInterval(
            FiltersModel(
              title: "This Week",
              value: "this_week",
              isSelected: true,
            ),
          );
        StatisticsFiltersWidget.clearTimeIntervals();
        StatisticsFiltersWidget.timeIntervalFilters[0].isSelected = true;
        unawaited(StatisticsPage.push(context: context));
      },
    ),
    FeatureModel(
      title: "Themes",
      image: DefaultIcons.THEMES_MORE,
      color: const Color.fromRGBO(40, 53, 235, 1),
      route: (context) async {
        ThemeBloc.of(context.mounted ? context : context)
            .updateActiveType("Feed");
        unawaited(MainThemeScreen.push(context, false));
      },
    ),
    // FeatureModel(
    //   title: "Visitor Book",
    //   image: DefaultVectors.VISITOR_BOOK_DASH,
    //   color: const Color.fromRGBO(195, 195, 195, 1),
    //   route: (context) {
    //     ToastUtils.infoToast(
    //       context.appLocalizations.coming_soon,
    //       context.appLocalizations.visitor_book_available_soon,
    //     );
    //   },
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HorizontalHeaderTitles(
          title: context.appLocalizations.quick_access,
          pinnedOption: false,
          pinnedTitle: context.appLocalizations.feature,
          viewAllClick: () {
            StartupBloc.of(context)
              ..updateMoreCustomFeatureTileExpanded(true)
              ..updateMoreCustomSettingsTileExpanded(false)
              ..pageIndexChanged(3);
          },
        ),
        const SizedBox(height: 10),
        FeatureListView(featureList: featureList),
      ],
    );
  }
}

class FeatureListView extends StatelessWidget {
  const FeatureListView({
    super.key,
    required this.featureList,
    this.isDisabled = false,
  });

  final List<FeatureModel> featureList;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: featureList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: MediaQuery.of(context).size.height / 8,
      ),
      itemBuilder: (context, index) {
        final FeatureModel model = featureList[index];
        return QuickAccessItems(
          route: model.route!,
          image: model.image,
          title: model.title,
          color: model.color,
          isDisabled: isDisabled,
        );
      },
    );
  }
}
