import 'dart:convert';

import 'package:admin/core/images.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class ThermostatScreen extends StatelessWidget {
  const ThermostatScreen({super.key, required this.device});

  final IotDeviceModel device;

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);
    // IotDeviceModel device =
    //     bloc.state.inRoomIotDeviceModel![bloc.state.selectedIotIndex];
    var json = jsonDecode(device.configuration ?? "{}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      spacing: 10,
      children: [
        Expanded(
          flex: 3,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
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
                  spacing: 40,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 20,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Image.asset(
                              DefaultVectors.THERMOSTAT_IMAGE,
                              scale: 1.65,
                            ),
                          ),
                          Expanded(
                            child: IOTConfigHeaderLabel(
                              isDisable: device.stateAvailable == 3,
                              title: "Temp.",
                              value:
                                  // "${json["a"]?["current_temperature"] ?? 40}${device.thermostatTemperatureUnit}",
                                  "${(double.tryParse((device.temperature ?? 40).toString()) ?? 0.0).round()}${device.thermostatTemperatureUnit}",
                            ),
                          ),
                          Expanded(
                            child: IOTConfigHeaderLabel(
                              title: "Humidity",
                              isDisable: device.stateAvailable == 3,
                              value: "${json["a"]?["current_humidity"] ?? 40}%",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: IotBlocBuilder(
                        builder: (context, state) {
                          // device = bloc
                          //     .state.inRoomIotDeviceModel![bloc.state.selectedIotIndex];
                          json = jsonDecode(device.configuration ?? "{}");
                          return IgnorePointer(
                            ignoring: device.stateAvailable == 3,
                            child: Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${double.parse(
                                    (json["a"]?["min_temp"] ?? 0).toString(),
                                  )} ${device.thermostatTemperatureUnit}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(
                                        color: AppColors.darkBlueColor,
                                        fontSize: 15,
                                      ),
                                ),
                                SleekCircularSlider(
                                  innerWidget: (val) {
                                    return Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(
                                            15,
                                          ),
                                          child: Container(
                                            // width: 70,
                                            // height: 70,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
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
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
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
                                          padding: const EdgeInsets.all(
                                            40,
                                          ),
                                          child: DecoratedBox(
                                            // width: 70,
                                            // height: 70,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
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
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 4,
                                                  spreadRadius: 10,
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                // (device.mode?.toLowerCase() !=
                                                //             "off"
                                                //         ? context
                                                //             .appLocalizations.on
                                                //         : context
                                                //             .appLocalizations
                                                //             .off)
                                                //     .toUpperCase(),
                                                "${(double.tryParse((device.temperature ?? 40).toString()) ?? 0.0).round()}${device.thermostatTemperatureUnit}"
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
                                    );
                                  },
                                  appearance: CircularSliderAppearance(
                                    animationEnabled: false,
                                    startAngle: 135,
                                    angleRange: 270,
                                    customColors: CustomSliderColors(
                                      progressBarColor: (((bloc
                                                              .state
                                                              .inRoomIotDeviceModel?[bloc
                                                                  .state
                                                                  .selectedIotIndex]
                                                              .mode ??
                                                          "")
                                                      .toLowerCase() ==
                                                  "off".toLowerCase())
                                              ? false
                                              : device.stateAvailable != 3)
                                          ? AppColors.lightSlider
                                          : Theme.of(context).brightness ==
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
                                  min: double.parse(
                                    (json["a"]?["min_temp"] ?? 0).toString(),
                                  ),
                                  max: double.parse(
                                    (json["a"]?["max_temp"] ?? 100).toString(),
                                  ),
                                  initialValue: double.parse(
                                            (device.temperature ?? 0)
                                                .toString(),
                                          ) <=
                                          double.parse(
                                            (json["a"]?["min_temp"] ?? 100)
                                                .toString(),
                                          )
                                      ? double.parse(
                                          (json["a"]?["min_temp"] ?? 0)
                                              .toString(),
                                        )
                                      : double.parse(
                                                (device.temperature ?? 0)
                                                    .toString(),
                                              ) >=
                                              double.parse(
                                                (json["a"]?["max_temp"] ?? 100)
                                                    .toString(),
                                              )
                                          ? double.parse(
                                              (json["a"]?["max_temp"] ?? 100)
                                                  .toString(),
                                            )
                                          : double.parse(
                                              (device.temperature ??
                                                      json["a"]?["min_temp"] ??
                                                      0)
                                                  .toString(),
                                            ),
                                  onChange: (value) {
                                    bloc.updateDeviceTemperature(
                                      device.entityId!,
                                      value.round().toString(),
                                    );
                                  },
                                  onChangeEnd: (value) {
                                    if (device.stateAvailable != 3) {
                                      bloc.operateIotDevice(
                                        device.entityId,
                                        "climate/set_temperature",
                                        otherValues: {
                                          "entity_id": "${device.entityId}",
                                          "temperature":
                                              value.round().toString(),
                                        },
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  "${double.parse(
                                    (json["a"]?["max_temp"] ?? 100).toString(),
                                  )} ${device.thermostatTemperatureUnit}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(
                                        color: AppColors.darkBlueColor,
                                        fontSize: 15,
                                      ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Expanded(
          child: IotBlocSelector(
            selector: (state) =>
                state.operateIotDeviceResponse.isSocketInProgress,
            builder: (isLoading) {
              // device =
              //     bloc.state.inRoomIotDeviceModel![bloc.state.selectedIotIndex];
              json = jsonDecode(device.configuration ?? "{}");

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    IOTFilterButton(
                      leadingImage: getIcon(json["a"]?["mode"] ?? "Heat"),
                      isEnabled: device.stateAvailable != 3,
                      title: "Mode",
                      value: (device.mode ?? "Heat").capitalizeFirstOfEach(),
                      items: List<String>.from(
                        (json["a"]?['hvac_modes'] ?? [])
                            .map((v) => v.toString().capitalizeFirstOfEach()),
                      ),
                      onItemSelected: (data) {
                        if (data.toLowerCase() != device.mode?.toLowerCase()) {
                          bloc.operateIotDevice(
                            device.entityId,
                            "climate/set_hvac_mode",
                            otherValues: {
                              "entity_id": "${device.entityId}",
                              "hvac_mode": data.toLowerCase(),
                            },
                          );
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                    IOTFilterButton(
                      leadingImage: getIcon(
                        json["a"]?["preset_mode"] ?? "None",
                      ),
                      isEnabled: ((bloc
                                              .state
                                              .inRoomIotDeviceModel?[
                                                  bloc.state.selectedIotIndex]
                                              .mode ??
                                          "")
                                      .toLowerCase() ==
                                  "off".toLowerCase() ||
                              json["a"]?['preset_modes'] == null)
                          ? false
                          : device.stateAvailable != 3,
                      title: "Preset Mode",
                      value:
                          (device.presetMode ?? "None").capitalizeFirstOfEach(),
                      items: List<String>.from(
                        (json["a"]?['preset_modes'] ?? [])
                            .map((v) => v.toString().capitalizeFirstOfEach()),
                      ),
                      onItemSelected: (data) {
                        if (data.toLowerCase() !=
                            device.presetMode?.toLowerCase()) {
                          bloc.operateIotDevice(
                            device.entityId,
                            "climate/set_preset_mode",
                            otherValues: {
                              "entity_id": "${device.entityId}",
                              "preset_mode": data.toLowerCase(),
                            },
                          );
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                    IOTFilterButton(
                      leadingImage: getIcon(json["a"]?["fan_mode"] ?? "Off"),
                      isEnabled: ((bloc
                                          .state
                                          .inRoomIotDeviceModel![
                                              bloc.state.selectedIotIndex]
                                          .mode ??
                                      "")
                                  .toLowerCase() ==
                              "off".toLowerCase())
                          ? false
                          : device.stateAvailable != 3,
                      title: "Fan Mode",
                      value: (device.fanMode ?? "Off").capitalizeFirstOfEach(),
                      items: List<String>.from(
                        (json["a"]?['fan_modes'] ?? [])
                            .map((v) => v.toString().capitalizeFirstOfEach()),
                      ),
                      onItemSelected: (data) {
                        if (data.toLowerCase() !=
                            device.fanMode?.toLowerCase()) {
                          bloc.operateIotDevice(
                            device.entityId,
                            "climate/set_fan_mode",
                            otherValues: {
                              "entity_id": "${device.entityId}",
                              "fan_mode": data.toLowerCase(),
                            },
                          );
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String getIcon(String mode) {
    switch (mode.toLowerCase()) {
      case 'heat':
      case 'none':
      case 'on':
        return DefaultIcons.IOT_FIRE;

      case 'cool':
      case 'away':
      case 'auto':
        return DefaultIcons.SNOWFLAKE;

      case 'off':
      case 'diffuse':
      case 'hold':
        return DefaultIcons.POWER;

      default:
        return DefaultIcons.IOT_FIRE;
    }
  }
}

class IOTFilterButton extends StatelessWidget {
  const IOTFilterButton({
    super.key,
    required this.leadingImage,
    required this.title,
    required this.value,
    required this.items,
    required this.onItemSelected,
    required this.isEnabled,
  });

  final String leadingImage;
  final String title;
  final String value;
  final List<String> items;
  final Function(String data) onItemSelected;
  final bool isEnabled;

  String getIcon(String mode) {
    switch (mode.toLowerCase()) {
      case 'heat':
      case 'none':
      case 'on':
        return DefaultIcons.IOT_FIRE;

      case 'cool':
      case 'away':
      case 'auto':
        return DefaultIcons.SNOWFLAKE;

      case 'off':
      case 'diffuse':
      case 'hold':
        return DefaultIcons.POWER;

      default:
        return DefaultIcons.IOT_FIRE;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        final RenderBox renderBox = context.findRenderObject()! as RenderBox;
        final size = renderBox.size;
        final position = renderBox.localToGlobal(Offset.zero);

        if (isEnabled) {
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              position.dx,
              position.dy + size.height,
              position.dx + size.width,
              position.dy + size.height,
            ),
            items: (items.isNotEmpty
                    ? items
                    : [
                        "On",
                        "Auto",
                        "Diffuse",
                      ])
                .map(
                  (e) => PopupMenuItem<Map<String, String>>(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onItemSelected(e),
                      child: SizedBox(
                        height: 5.h,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(getIcon(e)),
                              const SizedBox(width: 20),
                              Text(
                                e,
                                style: TextStyle(
                                  color: AppColors.iOTDeviceConfigTextDarkColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            elevation: 10,
            surfaceTintColor: AppColors.white,
            shadowColor: AppColors.white,
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        }
      },
      child: Container(
        width: 30.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: !isEnabled ? Colors.grey : AppColors.thermostatModesEnabledBg,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              leadingImage,
              height: 20,
              colorFilter: ColorFilter.mode(
                !isEnabled ? Colors.white : Theme.of(context).primaryColor,
                BlendMode.srcIn,
              ),
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          !isEnabled ? Colors.white : AppColors.darkBlueColor,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: !isEnabled
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      fontSize: 11,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IOTConfigHeaderLabel extends StatelessWidget {
  const IOTConfigHeaderLabel({
    super.key,
    required this.title,
    required this.value,
    required this.isDisable,
  });

  final String title;
  final String value;
  final bool isDisable;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontSize: 25,
                color: isDisable ? Colors.white : AppColors.darkBlueColor,
              ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontSize: 15,
                color: isDisable ? Colors.white : AppColors.darkBlueColor,
              ),
        ),
      ],
    );
  }
}

class ThermostatValue extends StatelessWidget {
  const ThermostatValue(this.value, this.state, {super.key});

  final int value;
  final bool state;

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);

    final device =
        bloc.state.inRoomIotDeviceModel![bloc.state.selectedIotIndex];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              '$value${device.thermostatTemperatureUnit}',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w500,
                color: device.stateAvailable == 3 || state
                    ? Colors.white
                    : AppColors.primaryColor,
              ),
            ),
          ),
          Text(
            !state ? 'ON' : "OFF",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: device.stateAvailable == 3 || state
                  ? Colors.white
                  : AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
