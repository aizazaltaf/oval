import 'dart:convert';

import 'package:admin/core/images.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

final _logger = Logger('curtain_screen.dart');

enum CloseDirection {
  closeUp,
  closeDown,
  fullyOpen,
}

extension CloseDirectionExtension on CloseDirection {
  String get command => switch (this) {
        CloseDirection.closeUp => 'closeUp',
        CloseDirection.closeDown => 'closeDown',
        CloseDirection.fullyOpen => 'fullyOpen',
      };

  String get label => switch (this) {
        CloseDirection.closeUp => 'Closed\nUp',
        CloseDirection.closeDown => 'Closed\nDown',
        CloseDirection.fullyOpen => 'Fully Open',
      };

  int get value => switch (this) {
        CloseDirection.closeUp => 100,
        CloseDirection.closeDown => 0,
        CloseDirection.fullyOpen => 50,
      };
}

class CurtainScreen extends StatefulWidget {
  const CurtainScreen({super.key, required this.device});

  final IotDeviceModel? device;

  @override
  CurtainScreenState createState() => CurtainScreenState();
}

class CurtainScreenState extends State<CurtainScreen>
    with SingleTickerProviderStateMixin {
  double position = 100; // Start with curtain fully closed
  IotDeviceModel? device;

  @override
  void initState() {
    super.initState();

    device = widget.device;
    // bloc.state.inRoomIotDevice Model?[bloc.state.selectedIotIndex];
    position = double.parse(device?.curtainPosition ?? 0.toString());
  }

  String returnCurtainCommand(bool targetClosed) {
    // if (device!.entityId!.isSwitchBotBlind()) {
    //   // Blind Tilt
    //   return targetClosed ? "closeUp" : "fullyOpen";
    // } else {
    // Curtain / Curtain 3
    return targetClosed ? "turnOff" : "turnOn";
    // }
  }

  void _handleOpenCurtain(IotBloc bloc) {
    final json = jsonDecode(device?.details?['extra_param'] ?? "{}");

    if (device!.entityId!.isSwitchBotBlind()) {
      bloc.operateCurtain(
        deviceId: device!.curtainDeviceId!,
        command: CloseDirection.fullyOpen.command,
        entityId: device!.entityId!,
        parameter: "default",
        val: CloseDirection.fullyOpen.value.toString(),
        // 0 = open
        callback: () async {
          setState(() {
            position = CloseDirection.fullyOpen.value.toDouble();
          });
        },
        token: json["api_token"],
        secret: json['api_key'],
      );
    } else {
      // Open = targetClosed = false
      final command = returnCurtainCommand(false);

      bloc.operateCurtain(
        deviceId: device!.curtainDeviceId!,
        command: command,
        entityId: device!.entityId!,
        parameter: "default",
        val: "0",
        // 0 = open
        callback: () async {
          setState(() {
            position = 0;
          });
        },
        token: json["api_token"],
        secret: json['api_key'],
      );
    }
  }

  void _handleCloseCurtain(
    IotBloc bloc, {
    CloseDirection command = CloseDirection.closeDown,
  }) {
    final json = jsonDecode(device?.details?['extra_param'] ?? "{}");

    if (device!.entityId!.isSwitchBotBlind()) {
      bloc.operateCurtain(
        deviceId: device!.curtainDeviceId!,
        command: command.command,
        parameter: "default",
        val: command.value.toString(),
        entityId: device!.entityId!,
        callback: () async {
          setState(() {
            position = command.value.toDouble();
          });
        },
        token: json["api_token"],
        secret: json['api_key'],
      );
    } else {
      // Close = targetClosed = true
      final command = returnCurtainCommand(true);

      bloc.operateCurtain(
        deviceId: device!.curtainDeviceId!,
        command: command,
        entityId: device!.entityId!,
        parameter: "default",
        val: "100",
        // 100 = closed
        callback: () async {
          setState(() {
            position = 100;
          });
        },
        token: json["api_token"],
        secret: json['api_key'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);

    return IotBlocSelector.curtainApis(
      builder: (data) {
        return device!.entityId!.isSwitchBotBlind()
            ? blindsWidget(data, bloc)
            : curtainWidget(data, bloc);
      },
    );
  }

  String setPositionBlinds(bloc, val) {
    // return double.parse(
    //   bloc bloc.operateCurtain(
    //         deviceId: device!.curtainDeviceId!,
    //         command: "setPosition",
    //         parameter: device!.entityId!.isSwitchBotBlind()
    //             ? (setPositionBlinds(bloc, 0))
    //             : "0,ff,${0}",
    //         val: 0.toString(),
    //         entityId: device!.entityId!,
    //         callback: () async {},
    //         token: json["api_token"],
    //         secret: json['api_key'],
    //       );
    //       .state
    //       .inRoomIotDeviceModel![bloc
    //       .state
    //       .selectedIotIndex]
    //       .curtainPosition!,
    // ) >
    //     val
    //     ? "up;${val.round()}"
    //     : "down;${val.round()}";

    ///old
//     final currentPos = double.tryParse(
//           bloc.state.inRoomIotDeviceModel![bloc.state.selectedIotIndex]
//               .curtainPosition!,
//         ) ??
//         0.0;
//
// // Blind Tilt → must be multiple of 2
//     final adjustedVal = (val.round() / 2).round() * 2;
//
//     return currentPos > val ? "up;$adjustedVal" : "down;$adjustedVal";
    if (val < 50) {
      // 0 → 100, 50 → 0
      _logger.severe("Api Value: down;${sendPercentageBlinds(val)}");

      return "down;${sendPercentageBlinds(val)}";
    } else if (val == 50) {
      // special case: directly return 100
      return "up;0";
    } else {
      // 50 → 100%, 100 → 100%
      _logger.severe("Api Value: up;${sendPercentageBlinds(val)}");

      return "up;${sendPercentageBlinds(val)}";
    }
  }

  Widget _buildControlButton({
    required VoidCallback onTap,
    required String text,
    required String icon,
    required bool needButtonDisabled,
    bool width = false,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (device?.stateAvailable != 3) {
          if (!needButtonDisabled) {
            onTap.call();
          }
        } else {
          ToastUtils.errorToast(
            "Network error. Device can’t be added due to internet issue.",
          );
        }
      },
      child: Container(
        width: width ? 35.w : null,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: device?.stateAvailable == 3
              ? Colors.grey
              : device!.curtainDeviceId == null || !needButtonDisabled
                  ? Colors.white
                  : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          spacing: 10,
          children: [
            SizedBox(
              height: 5.w,
              child: device!.curtainDeviceId != null
                  ? icon.contains("svg")
                      ? SvgPicture.asset(
                          icon,
                          colorFilter: ColorFilter.mode(
                            device?.stateAvailable == 3
                                ? Colors.white
                                : needButtonDisabled
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                            BlendMode.srcIn,
                          ),
                          height: 20,
                          width: 20,
                        )
                      : Image.asset(
                          icon,
                          color: device?.stateAvailable == 3
                              ? Colors.white
                              : needButtonDisabled
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                          height: 20,
                          width: 20,
                        )
                  : Image.asset(
                      icon,
                      color: Colors.grey[100],
                      height: 20,
                      width: 20,
                    ),
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: device?.stateAvailable == 3
                        ? Colors.white
                        : needButtonDisabled
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String returnCurtainImage() {
    String vector;

    if (position < 50) {
      vector = DefaultVectors.CURTAIN_FIFTY;
    } else {
      vector = DefaultVectors.CURTAIN_HUNDRED;
    }

    return vector;
  }

  String returnBlindImage() {
    String vector;

    if (position.round() != 50) {
      vector = DefaultVectors.BLIND_CLOSE_INNER;
    } else {
      vector = DefaultVectors.BLIND_OPEN;
    }

    return vector;
  }

  /// Converts the **UI slider position (0–100)** into the **percentage**
  /// that should be **sent to the device (blinds motor)**.
  ///
  /// Mapping:
  /// - 0 → 100% (fully down)
  /// - 50 → 100% (center fully open)
  /// - 100 → 100% (fully up)
  num sendPercentageBlinds(int pos) {
    if (pos < 50) {
      // Lower half: 0 → 0%, 50 → 100%
      return (pos / 50) * 100;
    } else if (pos == 50) {
      return 100;
    } else {
      // Upper half: 50 → 100%, 100 → 0%
      return ((100 - pos) / 50) * 100;
    }
  }

  /// Converts the **device’s internal position (0–100)** into the **percentage**
  /// that should be **displayed on UI (human-readable)**.
  ///
  /// Mapping:
  /// - 0 → 0%
  /// - 50 → 100%
  /// - 100 → 0%
  double getDisplayPercentageBlinds(int pos) {
    _logger.severe("Slider Position: $pos");

    if (pos < 50) {
      // Lower half: 0 → 0%, 50 → 100%
      return (pos / 50) * 100;
    } else if (pos == 50) {
      // Center fully open
      return 100;
    } else {
      // Upper half: 50 → 100%, 100 → 0%
      return ((100 - pos) / 50) * 100;
    }
  }

  Column blindsWidget(data, bloc) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                children: [
                  Positioned(
                    top: 1,
                    left: -4,
                    bottom: 2,
                    child: Row(
                      spacing: 10,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              alwaysIncludeSemantics: true,
                              child: child,
                            );
                          },
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          key: ValueKey(
                            data,
                          ),
                          child: Image.asset(
                            returnBlindImage(),
                            width: 250,
                            fit: BoxFit.fill,
                          ), // Important for switching
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 20,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${getDisplayPercentageBlinds(position.round()).round()}%",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      fontSize: 40,
                                      color: device?.stateAvailable == 3
                                          ? Colors.white
                                          : AppColors.darkBlueColor,
                                    ),
                              ),
                              Text(
                                position.round() == 50
                                    ? CloseDirection.fullyOpen.label
                                    : position.round() < 50
                                        ? CloseDirection.closeDown.label
                                            .replaceAll("\n", " ")
                                        : CloseDirection.closeUp.label
                                            .replaceAll("\n", " "),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      color: device?.stateAvailable == 3
                                          ? Colors.white
                                          : AppColors.darkBlueColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Background Image
                  // Positioned.fill(
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 40,
                  //       vertical: 30,
                  //     ),
                  //     child: Image.asset(
                  //       DefaultVectors.CURTAIN_BG,
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  // // Curtain Rod (Danda)
                  // Positioned(
                  //   top: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 10),
                  //     child: Image.asset(
                  //       DefaultVectors.CURTAIN_DANDA,
                  //       fit: BoxFit.fitWidth,
                  //     ),
                  //   ),
                  // ),
                  // // Single Curtain Panel
                  // Positioned(
                  //   top: 25,
                  //   left: 20,
                  //   bottom: 20,
                  //   child: SizedBox(
                  //     width: MediaQuery.of(context).size.width - 40,
                  //     child: ClipRect(
                  //       child: AnimatedContainer(
                  //         duration: const Duration(milliseconds: 150),
                  //         width:
                  //             (MediaQuery.of(context).size.width - 40) *
                  //                 (position / 100),
                  //         height: MediaQuery.of(context).size.height,
                  //         child: Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: List.generate(
                  //             (position / 10).round(),
                  //             (i) => SizedBox(
                  //               width:
                  //                   (MediaQuery.of(context).size.width -
                  //                           40) /
                  //                       10,
                  //               child: Image.asset(
                  //                 DefaultVectors.SINGLE_CURTAIN,
                  //                 height: double.infinity,
                  //                 fit: BoxFit.fill,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        // Slider Control
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    CloseDirection.closeDown.label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.darkBlueColor,
                        ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor:
                                    AppColors.curtainSliderActiveColor,
                                thumbColor: AppColors.curtainSliderActiveColor,
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 7.5,
                                ),
                                inactiveTickMarkColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                activeTickMarkColor: Colors.transparent,
                                valueIndicatorColor:
                                    AppColors.curtainSliderActiveColor,
                                inactiveTrackColor: AppColors.white,
                              ),
                              child: Slider(
                                value: position,
                                max: 100,
                                divisions: 50,
                                onChanged: (value) {
                                  if (device?.stateAvailable != 3) {
                                    if (device!.curtainDeviceId != null) {
                                      setState(() {
                                        position = value.round().toDouble();
                                      });
                                    }
                                  }
                                },
                                onChangeEnd: (val) {
                                  if (device?.stateAvailable != 3) {
                                    if (device!.curtainDeviceId != null) {
                                      // if (val == 0) {
                                      //   _handleOpenCurtain(bloc);
                                      // } else if (val == 100) {
                                      //   _handleCloseCurtain(bloc);
                                      // } else {
                                      final json = jsonDecode(
                                        device?.details?['extra_param'] ?? "{}",
                                      );
                                      if (position.round() == 0) {
                                        _handleCloseCurtain(
                                          bloc,
                                        );
                                      } else if (position.round() == 100) {
                                        _handleCloseCurtain(
                                          bloc,
                                          command: CloseDirection.closeUp,
                                        );
                                      } else if (position.round() == 50) {
                                        _handleOpenCurtain(bloc);
                                      } else {
                                        bloc.operateCurtain(
                                          deviceId: device!.curtainDeviceId!,
                                          command: "setPosition",
                                          parameter: setPositionBlinds(
                                            bloc,
                                            val.round(),
                                          ),
                                          val: val.round().toString(),
                                          entityId: device!.entityId!,
                                          callback: () async {},
                                          token: json["api_token"],
                                          secret: json['api_key'],
                                        );
                                      }
                                      // }
                                    }
                                  }
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _handleOpenCurtain(bloc);
                              },
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  child: Container(
                                    height: 20, // height of line
                                    width: 2,
                                    color: AppColors
                                        .curtainSliderActiveColorWithOpacity,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          CloseDirection.fullyOpen.label,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppColors.darkBlueColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    CloseDirection.closeUp.label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.darkBlueColor,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Control Buttons
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: device!.entityId!.isSwitchBotBlind()
              ? Wrap(
                  spacing: 10,
                  alignment: WrapAlignment.center,
                  runSpacing: 10,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const SizedBox(width: 20),
                    _buildControlButton(
                      width: device!.entityId!.isSwitchBotBlind(),
                      onTap: () {
                        if (device!.curtainDeviceId != null) {
                          _handleCloseCurtain(
                            bloc,
                          );
                        }
                      },
                      needButtonDisabled:
                          position == CloseDirection.closeDown.value.toDouble(),
                      text: "Close Down",
                      icon: DefaultVectors.BLIND_CLOSE,
                    ),

                    // const SizedBox(width: 20),
                    _buildControlButton(
                      width: device!.entityId!.isSwitchBotBlind(),
                      onTap: () {
                        if (device!.curtainDeviceId != null) {
                          _handleCloseCurtain(
                            bloc,
                            command: CloseDirection.closeUp,
                          );
                        }
                      },
                      needButtonDisabled:
                          position == CloseDirection.closeUp.value.toDouble(),
                      text: "Close Up",
                      icon: DefaultVectors.BLIND_CLOSE,
                    ),

                    _buildControlButton(
                      onTap: () {
                        if (device!.curtainDeviceId != null) {
                          _handleOpenCurtain(bloc);
                        }
                      },
                      text: "Fully Open",
                      needButtonDisabled:
                          position.round() == CloseDirection.fullyOpen.value,
                      width: device!.entityId!.isSwitchBotBlind(),
                      icon: DefaultVectors.BLIND_OPEN_ICON,
                    ),
                  ],
                )
              : Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildControlButton(
                      onTap: () {
                        if (device!.curtainDeviceId != null) {
                          _handleOpenCurtain(bloc);
                        }
                      },
                      text: "Fully Open",
                      needButtonDisabled:
                          position == CloseDirection.fullyOpen.value.toDouble(),
                      width: device!.entityId!.isSwitchBotBlind(),
                      icon: DefaultVectors.BLIND_OPEN_ICON,
                    ),
                    // const SizedBox(width: 20),
                    _buildControlButton(
                      width: device!.entityId!.isSwitchBotBlind(),
                      onTap: () {
                        if (device!.curtainDeviceId != null) {
                          _handleCloseCurtain(
                            bloc,
                          );
                        }
                      },
                      needButtonDisabled:
                          position == CloseDirection.closeDown.value.toDouble(),
                      text: "Close Down",
                      icon: DefaultVectors.BLIND_CLOSE,
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Column curtainWidget(data, bloc) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                children: [
                  Positioned(
                    top: 1,
                    left: 0,
                    bottom: 2,
                    child: Row(
                      spacing: 10,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              alwaysIncludeSemantics: true,
                              child: child,
                            );
                          },
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          key: ValueKey(
                            data,
                          ),
                          child: Image.asset(
                            returnCurtainImage(),
                            width: 250,
                          ), // Important for switching
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 40,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${position.round() == 0 ? 100 : position.round()}%",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      fontSize: 40,
                                      color: device?.stateAvailable == 3
                                          ? Colors.white
                                          : AppColors.darkBlueColor,
                                    ),
                              ),
                              Text(
                                position.round() == 50
                                    ? "Half Open"
                                    : position.round() == 100
                                        ? "Closed"
                                        : position.round() == 0
                                            ? "Open"
                                            : "Closed",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      color: device?.stateAvailable == 3
                                          ? Colors.white
                                          : AppColors.darkBlueColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Background Image
                  // Positioned.fill(
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 40,
                  //       vertical: 30,
                  //     ),
                  //     child: Image.asset(
                  //       DefaultVectors.CURTAIN_BG,
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  // // Curtain Rod (Danda)
                  // Positioned(
                  //   top: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 10),
                  //     child: Image.asset(
                  //       DefaultVectors.CURTAIN_DANDA,
                  //       fit: BoxFit.fitWidth,
                  //     ),
                  //   ),
                  // ),
                  // // Single Curtain Panel
                  // Positioned(
                  //   top: 25,
                  //   left: 20,
                  //   bottom: 20,
                  //   child: SizedBox(
                  //     width: MediaQuery.of(context).size.width - 40,
                  //     child: ClipRect(
                  //       child: AnimatedContainer(
                  //         duration: const Duration(milliseconds: 150),
                  //         width:
                  //             (MediaQuery.of(context).size.width - 40) *
                  //                 (position / 100),
                  //         height: MediaQuery.of(context).size.height,
                  //         child: Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: List.generate(
                  //             (position / 10).round(),
                  //             (i) => SizedBox(
                  //               width:
                  //                   (MediaQuery.of(context).size.width -
                  //                           40) /
                  //                       10,
                  //               child: Image.asset(
                  //                 DefaultVectors.SINGLE_CURTAIN,
                  //                 height: double.infinity,
                  //                 fit: BoxFit.fill,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        // Slider Control
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Fully\nOpen',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.darkBlueColor,
                        ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.curtainSliderActiveColor,
                        thumbColor: AppColors.curtainSliderActiveColor,
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 7.5,
                        ),
                        inactiveTickMarkColor: Colors.transparent,
                        overlayColor: Colors.transparent,
                        activeTickMarkColor: Colors.transparent,
                        valueIndicatorColor: AppColors.curtainSliderActiveColor,
                        inactiveTrackColor: AppColors.white,
                      ),
                      child: Slider(
                        value: position,
                        max: 100,
                        onChanged: (value) {
                          if (device!.curtainDeviceId != null) {
                            setState(() {
                              position = value;
                            });
                          }
                        },
                        onChangeEnd: (val) {
                          if (device!.curtainDeviceId != null) {
                            // if (val == 0) {
                            //   _handleOpenCurtain(bloc);
                            // } else if (val == 100) {
                            //   _handleCloseCurtain(bloc);
                            // } else {
                            final json = jsonDecode(
                              device?.details?['extra_param'] ?? "{}",
                            );
                            bloc.operateCurtain(
                              deviceId: device!.curtainDeviceId!,
                              command: "setPosition",
                              parameter: "0,ff,${val.round()}",
                              val: val.round().toString(),
                              entityId: device!.entityId!,
                              callback: () async {},
                              token: json["api_token"],
                              secret: json['api_key'],
                            );
                            // }
                          }
                        },
                      ),
                    ),
                  ),
                  Text(
                    'Fully\nClose',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.darkBlueColor,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Control Buttons
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(
                onTap: () {
                  if (device!.curtainDeviceId != null) {
                    _handleOpenCurtain(bloc);
                  }
                },
                text: 'Open',
                needButtonDisabled: (position / 10).round() == 0,
                width: device!.entityId!.isSwitchBotBlind(),
                icon: DefaultVectors.CURTAIN_ICON_SVG,
              ),
              // const SizedBox(width: 20),
              _buildControlButton(
                width: device!.entityId!.isSwitchBotBlind(),
                onTap: () {
                  if (device!.curtainDeviceId != null) {
                    _handleCloseCurtain(
                      bloc,
                    );
                  }
                },
                needButtonDisabled: (position / 10).round() == 10,
                text: 'Close',
                icon: DefaultVectors.CLOSE_CURTAIN,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
