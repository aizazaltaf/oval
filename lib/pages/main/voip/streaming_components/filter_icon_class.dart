import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/custom_checkbox_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AlertsFilterEnum {
  motionAlerts,
  securityAlerts,
  aiAlerts,
  weaponAlert,
  intruder,
  possibleDoorbellTheft,
  eavesDropper,
  visitorAlert,
  fire,
  babyRunningAway,
  drowning,
  petRunningAway,
  boundaryMovement,
  parcel
}

class FilterIconClass extends StatelessWidget {
  FilterIconClass({super.key, required this.callUserId});
  final String callUserId;

  final List<AiAlertsEnumsModel> recordedStreamFilters = [
    AiAlertsEnumsModel(
      label: "Motion Alerts",
      value: AlertsFilterEnum.motionAlerts.name,
    ),
    AiAlertsEnumsModel(
      label: "Security Alerts",
      value: AlertsFilterEnum.securityAlerts.name,
      list: [
        AiAlertsEnumsModel(
          label: "Weapon Alert",
          value: AlertsFilterEnum.weaponAlert.name,
        ),
        AiAlertsEnumsModel(
          label: "Intruder",
          value: AlertsFilterEnum.intruder.name,
        ),
        AiAlertsEnumsModel(
          label: "Possible Doorbell Theft",
          value: AlertsFilterEnum.possibleDoorbellTheft.name,
        ),
        AiAlertsEnumsModel(
          label: "Eaves Dropper",
          value: AlertsFilterEnum.eavesDropper.name,
        ),
      ],
    ),
    AiAlertsEnumsModel(
      label: "AI Alerts",
      value: AlertsFilterEnum.aiAlerts.name,
      list: [
        AiAlertsEnumsModel(
          label: "Visitor Alert",
          value: AlertsFilterEnum.visitorAlert.name,
        ),
        AiAlertsEnumsModel(
          label: "Fire",
          value: AlertsFilterEnum.fire.name,
        ),
        AiAlertsEnumsModel(
          label: "Baby Running Away",
          value: AlertsFilterEnum.babyRunningAway.name,
        ),
        AiAlertsEnumsModel(
          label: "Drowning",
          value: AlertsFilterEnum.drowning.name,
        ),
        AiAlertsEnumsModel(
          label: "Pet Running Away",
          value: AlertsFilterEnum.petRunningAway.name,
        ),
        AiAlertsEnumsModel(
          label: "Boundary Movement",
          value: AlertsFilterEnum.boundaryMovement.name,
        ),
        AiAlertsEnumsModel(
          label: "Parcel",
          value: AlertsFilterEnum.parcel.name,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final VoipBloc bloc = VoipBloc.of(context);
    return GestureDetector(behavior: HitTestBehavior.opaque,
      onTap: () {
        /// clear temp list and add selected filters to temp list
        bloc.copySelectedFiltersToTempFilters();

        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 10,
                children: [
                  Text(
                    'By Alert',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: recordedStreamFilters.length,
                    itemBuilder: (context, index) {
                      final AiAlertsEnumsModel filter =
                          recordedStreamFilters[index];
                      final List<AiAlertsEnumsModel>? children = filter.list;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            CustomCheckboxListTile(
                              value: bloc.isAnyChildOrParentSelected(
                                parent: filter.value,
                                children: [],
                              ),
                              onChanged: (value) => bloc.toggleFilter(
                                filter.value,
                                value ?? false,
                                children: (children ?? [])
                                    .map((e) => e.value)
                                    .toList(),
                              ),
                              title: filter.label,
                            ),
                            const SizedBox(height: 5),
                            if (children != null &&
                                bloc.isAnyChildOrParentSelected(
                                  parent: filter.value,
                                  children:
                                      children.map((e) => e.value).toList(),
                                ))
                              GridView.builder(
                                shrinkWrap: true,
                                itemCount: children.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 4,
                                ),
                                padding: const EdgeInsets.only(left: 20),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final AiAlertsEnumsModel child =
                                      children[index];
                                  return CustomCheckboxListTile(
                                    value: bloc.isAnyChildOrParentSelected(
                                      parent: child.value,
                                      children: [],
                                    ),
                                    onChanged: (value) => bloc.toggleFilter(
                                      child.value,
                                      value ?? false,
                                      children:
                                          children.map((e) => e.value).toList(),
                                    ),
                                    title: child.label,
                                  );
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomCancelButton(
                          onSubmit: () {
                            Navigator.pop(context);
                          },
                          label: context.appLocalizations.clear,
                        ),
                      ),
                      Expanded(
                        child: CustomGradientButton(
                          onSubmit: () {
                            bloc.applyFilters(context, callUserId);
                          },
                          label: context.appLocalizations.apply,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: SvgPicture.asset(
        DefaultIcons.FILTER,
      ),
    );
  }
}

class AiAlertsEnumsModel {
  AiAlertsEnumsModel({
    required this.label,
    required this.value,
    this.list,
  });
  String label;
  String value;
  List<AiAlertsEnumsModel>? list;
}
