import 'dart:convert';

import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/dialogs/colors_dialog.dart';
import 'package:admin/pages/main/iot_devices/dialogs/modes_dialog.dart';
import 'package:admin/pages/main/iot_devices/dialogs/whites_dialog.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class BulbScreen extends StatelessWidget {
  const BulbScreen({super.key, required this.device});

  final IotDeviceModel device;

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);

    return IotBlocSelector.selectedIotIndex(
      builder: (data) {
        final bool modeEnabled = (jsonDecode(device.configuration ?? "{}")?["a"]
                    ?["effect_list"] as List<dynamic>?)
                ?.isNotEmpty ??
            false;
        final bool colorEnabled =
            ((jsonDecode(device.configuration ?? "{}")?["a"]
                            ?["supported_color_modes"] as List<dynamic>?) ??
                        [])
                    .toString()
                    .contains("rgb") ||
                ((jsonDecode(device.configuration ?? "{}")?["a"]
                            ?["supported_color_modes"] as List<dynamic>?) ??
                        [])
                    .toString()
                    .contains("hs");
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: IotBlocSelector(
                  selector: (state) {
                    // Add bounds checking in the selector itself
                    if (state.inRoomIotDeviceModel == null ||
                        state.selectedIotIndex >=
                            state.inRoomIotDeviceModel!.length) {
                      return null;
                    }
                    return state.inRoomIotDeviceModel![state.selectedIotIndex]
                        .stateAvailable;
                  },
                  builder: (isStateAvailable) {
                    return Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(seconds: 1),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    alwaysIncludeSemantics: true,
                                    child: child,
                                  );
                                },
                                switchInCurve: Curves.easeIn,
                                switchOutCurve: Curves.easeOut,
                                child: Image.asset(
                                  isStateAvailable == 1
                                      ? DefaultVectors.LIGHTON
                                      : DefaultVectors.LIGHTOFF,
                                  key: ValueKey(
                                    isStateAvailable,
                                  ), // Important for switching
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IotBlocSelector(
                                        selector: (state) {
                                          // Add bounds checking in the selector itself
                                          if (state.inRoomIotDeviceModel ==
                                                  null ||
                                              state.selectedIotIndex >=
                                                  state.inRoomIotDeviceModel!
                                                      .length) {
                                            return null;
                                          }
                                          return state
                                              .inRoomIotDeviceModel![
                                                  state.selectedIotIndex]
                                              .brightness;
                                        },
                                        builder: (brightness) {
                                          return Text(
                                            "${((brightness ?? 0) / 255 * 100).round()}%",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                  fontSize: 40,
                                                  color: isStateAvailable != 3
                                                      ? AppColors.darkBlueColor
                                                      : Colors.white,
                                                ),
                                          );
                                        },
                                      ),
                                      Text(
                                        "Intensity",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              color: isStateAvailable != 3
                                                  ? AppColors.darkBlueColor
                                                  : Colors.white,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: IotBlocSelector(
                            selector: (state) {
                              // Add bounds checking in the selector itself
                              if (state.inRoomIotDeviceModel == null ||
                                  state.selectedIotIndex >=
                                      state.inRoomIotDeviceModel!.length) {
                                return null;
                              }
                              return state
                                  .inRoomIotDeviceModel![state.selectedIotIndex]
                                  .stateAvailable;
                            },
                            builder: (isStateAvailable) {
                              return IotBlocSelector(
                                selector: (state) {
                                  // Add bounds checking in the selector itself
                                  if (state.inRoomIotDeviceModel == null ||
                                      state.selectedIotIndex >=
                                          state.inRoomIotDeviceModel!.length) {
                                    return null;
                                  }
                                  return state
                                      .inRoomIotDeviceModel![
                                          state.selectedIotIndex]
                                      .brightness;
                                },
                                builder: (brightness) {
                                  return Row(
                                    spacing: 5,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "0%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              color: CommonFunctions
                                                  .getThemeBasedWidgetColor(
                                                context,
                                              ),
                                              fontSize: 15,
                                            ),
                                      ),
                                      IgnorePointer(
                                        ignoring: device.stateAvailable == 3,
                                        child: SleekCircularSlider(
                                          innerWidget: (val) {
                                            return GestureDetector(
                                              onTap: () {
                                                if (device.stateAvailable ==
                                                    1) {
                                                  bloc.operateIotDevice(
                                                    device.entityId,
                                                    Constants.turnOff,
                                                  );
                                                } else if (device
                                                        .stateAvailable ==
                                                    2) {
                                                  bloc.operateIotDevice(
                                                    device.entityId,
                                                    Constants.turnOn,
                                                    brightness: bloc
                                                                .state
                                                                .inRoomIotDeviceModel![bloc
                                                                    .state
                                                                    .selectedIotIndex]
                                                                .brightness !=
                                                            0
                                                        ? bloc
                                                            .state
                                                            .inRoomIotDeviceModel![bloc
                                                                .state
                                                                .selectedIotIndex]
                                                            .brightness
                                                            .round()
                                                        : 255,
                                                    otherValues: bloc
                                                                .state
                                                                .inRoomIotDeviceModel![bloc
                                                                    .state
                                                                    .selectedIotIndex]
                                                                .brightness !=
                                                            0
                                                        ? {
                                                            "brightness":
                                                                "${bloc.state.inRoomIotDeviceModel![bloc.state.selectedIotIndex].brightness.round()}",
                                                          }
                                                        : null,
                                                  );
                                                }
                                              },
                                              child: Stack(
                                                alignment: Alignment.topCenter,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                      15,
                                                    ),
                                                    child: Container(
                                                      // width: 70,
                                                      // height: 70,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            CommonFunctions
                                                                .getThemeWidgetColor(
                                                              context,
                                                            ),
                                                            CommonFunctions
                                                                .getThemeWidgetColor(
                                                              context,
                                                            ),
                                                          ],
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                        ),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 4,
                                                            spreadRadius: 2,
                                                            offset: Offset(
                                                              0,
                                                              2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                      45,
                                                    ),
                                                    child: DecoratedBox(
                                                      // width: 70,
                                                      // height: 70,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            CommonFunctions
                                                                .getThemeWidgetColor(
                                                              context,
                                                            ),
                                                            CommonFunctions
                                                                .getThemeWidgetColor(
                                                              context,
                                                            ),
                                                          ],
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                        ),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 4,
                                                            spreadRadius: 10,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          (device.stateAvailable ==
                                                                      1
                                                                  ? context
                                                                      .appLocalizations
                                                                      .on
                                                                  : context
                                                                      .appLocalizations
                                                                      .off)
                                                              .toUpperCase(),
                                                          style: Theme.of(
                                                            context,
                                                          )
                                                              .textTheme
                                                              .headlineLarge!
                                                              .copyWith(
                                                                color: Theme.of(
                                                                  context,
                                                                ).primaryColor,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Container(
                                                  //   margin:
                                                  //       const EdgeInsets.only(
                                                  //     top: 150,
                                                  //   ),
                                                  //   child: Text(
                                                  //     brightness
                                                  //         .round()
                                                  //         .toString(),
                                                  //     style: Theme.of(context)
                                                  //         .textTheme
                                                  //         .titleLarge,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            );
                                          },
                                          appearance: CircularSliderAppearance(
                                            animationEnabled: false,
                                            startAngle: 135,
                                            angleRange: 270,
                                            customColors: CustomSliderColors(
                                              progressBarColor:
                                                  isStateAvailable == 1
                                                      ? AppColors.lightSlider
                                                      : Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.grey
                                                          : Colors.grey[100],
                                              trackColor: Colors.white,
                                            ),
                                            customWidths: CustomSliderWidths(
                                              handlerSize: 8,
                                              shadowWidth: 5,
                                              trackWidth: 4,
                                              progressBarWidth: 4,
                                            ),
                                          ),
                                          max: 255,
                                          initialValue: brightness!,
                                          onChange: bloc.updateBrightness,
                                          onChangeEnd: (value) {
                                            if (device.stateAvailable != 3) {
                                              bloc.operateIotDevice(
                                                device.entityId,
                                                Constants.turnOn,
                                                otherValues: {
                                                  "brightness":
                                                      "${value.round()}",
                                                },
                                                brightness: value.round(),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      Text(
                                        "100%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              color: CommonFunctions
                                                  .getThemeBasedWidgetColor(
                                                context,
                                              ),
                                              fontSize: 15,
                                            ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 10,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (modeEnabled && device.stateAvailable != 3) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ModesDialog(bloc: bloc);
                            },
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: modeEnabled && device.stateAvailable != 3
                              ? Colors.white
                              : AppColors.darkGreyBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            // if (modeAndColorEnabled &&
                            //     device.stateAvailable != 3)
                            SvgPicture.asset(
                              DefaultVectors.LIGHT_MODE,
                              height: 20,
                              width: 20,
                            ),
                            // else
                            //   SvgPicture.asset(
                            //     DefaultVectors.LIGHT_MODE,
                            //   ),
                            Text(
                              context.appLocalizations.mode,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: modeEnabled &&
                                            device.stateAvailable != 3
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                    fontSize: 15,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (colorEnabled && device.stateAvailable != 3) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ColorsDialog(bloc: bloc);
                            },
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colorEnabled && device.stateAvailable != 3
                              ? Colors.white
                              : AppColors.darkGreyBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            SvgPicture.asset(
                              DefaultVectors.LIGHT_COLORS,
                              height: 20,
                              width: 20,
                            ),
                            Text(
                              context.appLocalizations.color,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: colorEnabled &&
                                            device.stateAvailable != 3
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                    fontSize: 15,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (device.stateAvailable != 3) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return WhitesDialog(bloc: bloc);
                            },
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: device.stateAvailable != 3
                              ? Colors.white
                              : AppColors.darkGreyBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            SvgPicture.asset(
                              DefaultVectors.LIGHT_WHITES,
                              height: 20,
                              width: 20,
                            ),
                            Text(
                              context.appLocalizations.whites,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: device.stateAvailable != 3
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                    fontSize: 15,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
