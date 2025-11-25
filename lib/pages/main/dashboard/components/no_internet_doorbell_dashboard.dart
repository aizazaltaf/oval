import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/dashboard/components/app_bar_widget.dart';
import 'package:admin/pages/main/dashboard/components/feature_items.dart';
import 'package:admin/pages/main/dashboard/components/header_tiles.dart';
import 'package:admin/pages/main/dashboard/monitor_cameras.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:flutter/material.dart';

class NoInternetDoorbellDashboard extends StatelessWidget {
  NoInternetDoorbellDashboard({super.key});

  final List<FeatureModel> featureList = [
    FeatureModel(
      title: "Smart\nDevices",
      image: DefaultIcons.MANAGE_DEVICES_MORE,
      route: (c) {},
    ),
    FeatureModel(
      title: "Voice\nControl",
      image: DefaultIcons.VOICE_CONTROL_MORE,
      route: (c) {},
    ),
    FeatureModel(
      title: "Statistics",
      image: DefaultIcons.STATISTICS_MORE,
      route: (c) {},
    ),
    FeatureModel(
      title: "Themes",
      image: DefaultIcons.THEMES_MORE,
      route: (c) {},
    ),
  ];

  Widget featureListWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HorizontalHeaderTitles(
          title: context.appLocalizations.quick_access,
          viewAllBool: false,
          pinnedTitle: context.appLocalizations.feature,
          viewAllClick: () {},
          pinnedOption: false,
        ),
        const SizedBox(height: 10),
        GridView.builder(
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
              isDisabled: true,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProfileBlocSelector.selectedDoorBell(
      builder: (selectedDoorbell) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              const AppBarWidget(),
              featureListWidget(context),
              const SizedBox(height: 10),
              HorizontalHeaderTitles(
                title: context.appLocalizations.monitor_cameras,
                pinnedOption: false,
                viewAllClick: () {},
                pinnedTitle: context.appLocalizations.monitor,
                viewAllBool: false,
              ),
              const SizedBox(height: 5),
              IgnorePointer(
                child: MonitorCamerasWidget(
                  deviceModel: selectedDoorbell!,
                  length: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
