import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/pages/main/more_dashboard/components/subcomponents/feature_expanded_tiles.dart';
import 'package:admin/pages/main/more_dashboard/components/subcomponents/payment_expanded_tiles.dart';
import 'package:admin/pages/main/more_dashboard/components/subcomponents/settings_expanded_tiles.dart';
import 'package:flutter/material.dart';

class MoreExpansionWidget extends StatelessWidget {
  const MoreExpansionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25),
      child: StartupBlocSelector.userDeviceModel(
        builder: (list) {
          return (list == null || list.isEmpty)
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    FeatureExpandedTiles(),
                    SettingsExpandedTiles(),
                    PaymentExpandedTiles(),
                  ],
                );
        },
      ),
    );
  }
}
