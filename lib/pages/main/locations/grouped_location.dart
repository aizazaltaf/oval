import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/locations/bloc/location_bloc.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class GroupedLocation extends StatelessWidget {
  const GroupedLocation({super.key});

  static const routeName = "groupedLocation";

  static Future<void> push(final BuildContext context) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const GroupedLocation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appTitle: context.appLocalizations.location,
      body: NoGlowListViewWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  height: 1.h,
                ),
                ProfileBlocSelector.locations(
                  builder: (locations) {
                    return LocationBlocSelector.search(
                      builder: (search) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: locations!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, j) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 1.h,
                                ),
                                Text(
                                  locations[j].name ?? "",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: StartupBloc.of(context)
                                      .state
                                      .userDeviceModel
                                      ?.length,
                                  itemBuilder: (context, index) {
                                    if (locations[j].id ==
                                        StartupBloc.of(context)
                                            .state
                                            .userDeviceModel![index]
                                            .locationId) {
                                      return Text(
                                        StartupBloc.of(context)
                                                .state
                                                .userDeviceModel![index]
                                                .name ??
                                            "",
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
