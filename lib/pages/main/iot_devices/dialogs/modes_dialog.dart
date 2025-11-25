import 'dart:convert';

import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:flutter/material.dart';

class ModesDialog extends StatelessWidget {
  const ModesDialog({super.key, required this.bloc});

  final IotBloc bloc;

  @override
  Widget build(BuildContext context) {
    final device =
        bloc.state.inRoomIotDeviceModel![bloc.state.selectedIotIndex];
    final json = jsonDecode(
      device.configuration ?? "{}",
    )["a"];
    if (json == null) {
      bloc.updateSelectedModes(null);
    } else {
      if (json["effect"] == null) {
        bloc.updateSelectedModes(null);
      } else {
        bloc.updateSelectedModes(json["effect"]);
      }
    }

    return Dialog(
      child: BlocProvider.value(
        value: bloc,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.cancel,
                    color: Theme.of(context).primaryColor,
                    size: 26,
                  ),
                ),
              ),
              Center(
                child: Text(
                  context.appLocalizations.select_modes,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              Flexible(
                child: IotBlocSelector(
                  selector: (state) => state.selectedModes,
                  builder: (selectedModes) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 4,
                        childAspectRatio: 0.8,
                      ),
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 15),
                      itemCount:
                          CommonFunctions.colorMap.keys.toList().length >=
                                  (json['effect_list'] ?? []).length
                              ? (json['effect_list'] ?? []).length
                              : CommonFunctions.colorMap.keys.toList().length,
                      itemBuilder: (context, index) {
                        final keys = CommonFunctions.colorMap.keys.toList();
                        final List<Color> colors =
                            CommonFunctions.getColorByKey(
                          keys[index >= keys.length ? keys.length - 1 : index],
                        ) is Color
                                ? []
                                : CommonFunctions.getColorByKey(
                                    keys[index >= keys.length
                                        ? keys.length - 1
                                        : index],
                                  );
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            bloc.updateSelectedModes(
                              json['effect_list'][index],
                            );
                          },
                          child: Column(
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selectedModes ==
                                                keys[index >= keys.length
                                                    ? keys.length - 1
                                                    : index] ||
                                            selectedModes ==
                                                json['effect_list'][index]
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selectedModes ==
                                                    keys[index >= keys.length
                                                        ? keys.length - 1
                                                        : index] ||
                                                selectedModes ==
                                                    json['effect_list'][index]
                                            ? Theme.of(context).primaryColor
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                      color: CommonFunctions.getColorByKey(
                                        keys[index >= keys.length
                                            ? keys.length - 1
                                            : index],
                                      ) is Color
                                          ? CommonFunctions.getColorByKey(
                                              keys[index >= keys.length
                                                  ? keys.length - 1
                                                  : index],
                                            )
                                          : null,
                                      gradient: CommonFunctions.getColorByKey(
                                        keys[index >= keys.length
                                            ? keys.length - 1
                                            : index],
                                      ) is Color
                                          ? null
                                          : LinearGradient(
                                              colors: colors,
                                              // tileMode: TileMode.clamp,
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              //   stops: stops
                                              // stops: [0.1, 0.2,1,0.2],
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                json['effect_list'][index]
                                    .toString()
                                    .replaceAll("_", " ")
                                    .capitalizeFirstOfEach(),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              CustomGradientButton(
                onSubmit: () {
                  bloc.operateIotDevice(
                    device.entityId,
                    Constants.turnOn,
                    otherValues: {
                      "effect": bloc.state.selectedModes,
                      "brightness": device.brightness,
                    },
                  );
                  Navigator.pop(context);
                },
                label: context.appLocalizations.apply,
              ),
              CustomCancelButton(
                onSubmit: () {
                  Navigator.pop(context);
                },
                label: context.appLocalizations.reset,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
