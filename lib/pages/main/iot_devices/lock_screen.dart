import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:flutter/material.dart';

class LockScreen extends StatelessWidget {
  const LockScreen({super.key, required this.device});

  final IotDeviceModel device;

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);
    // final device =
    //     bloc.state.inRoomIotDeviceModel![bloc.state.selectedIotIndex];
    return IotBlocSelector(
      selector: (state) => state.operateIotDeviceResponse.isSocketInProgress,
      builder: (isLoading) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: IotBlocSelector(
            selector: (state) => state
                .inRoomIotDeviceModel?[state.selectedIotIndex].stateAvailable,
            builder: (isStateAvailable) {
              return Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 1,
                          bottom: 2,
                          child: AnimatedSwitcher(
                            duration: const Duration(seconds: 01),
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
                              isStateAvailable,
                            ),
                            child: Image.asset(
                              isStateAvailable == 2
                                  ? DefaultVectors.NEW_LOCK_UNLOCK
                                  : DefaultVectors.NEW_LOCK,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 30,
                          right: 50,
                          bottom: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isStateAvailable == 2 ? "Unlocked" : "Locked",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      fontSize: 40,
                                      color: isStateAvailable == 3
                                          ? Colors.white
                                          : AppColors.darkBlueColor,
                                    ),
                              ),
                              Text(
                                isStateAvailable == 3 ? "Unavailable" : "State",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      color: isStateAvailable == 3
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
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 25,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (isStateAvailable == 2) {
                              bloc.operateIotDevice(
                                device.entityId,
                                Constants.lock,
                                // ifNeededToUse: () async {
                                //   unawaited(EasyLoading.show());
                                //
                                //   await Future.delayed(
                                //     const Duration(seconds: 5),
                                //   );
                                //   bloc.withDebounceUpdateWhenDeviceUnreachable(
                                //     entityId: device.entityId,
                                //   );
                                //   unawaited(EasyLoading.dismiss());
                                // },
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isStateAvailable == 3
                                  ? Colors.grey
                                  : isStateAvailable == 1
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              spacing: 10,
                              children: [
                                Image.asset(
                                  DefaultVectors.DOORLOCKED_ICON,
                                  height: 20,
                                  width: 20,
                                  color: isStateAvailable == 3
                                      ? Colors.white
                                      : isStateAvailable == 1
                                          ? Colors.white
                                          : (isStateAvailable == 2)
                                              ? Theme.of(context).primaryColor
                                              : null,
                                ),
                                Text(
                                  'Lock',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: isStateAvailable == 3
                                            ? Colors.white
                                            : isStateAvailable == 1
                                                ? Colors.white
                                                : Theme.of(context)
                                                    .primaryColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (isStateAvailable == 1) {
                              bloc.operateIotDevice(
                                device.entityId,
                                Constants.unlock,
                                // ifNeededToUse: () async {
                                //   unawaited(EasyLoading.show());
                                //
                                //   await Future.delayed(
                                //     const Duration(seconds: 5),
                                //   );
                                //   bloc.withDebounceUpdateWhenDeviceUnreachable(
                                //     entityId: device.entityId,
                                //   );
                                //   unawaited(EasyLoading.dismiss());
                                // },
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isStateAvailable == 3
                                  ? Colors.grey
                                  : isStateAvailable == 2
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              spacing: 10,
                              children: [
                                Image.asset(
                                  DefaultVectors.DOOROPEN_ICON,
                                  height: 20,
                                  width: 20,
                                  color: isStateAvailable == 3
                                      ? Colors.white
                                      : isStateAvailable == 2
                                          ? Colors.white
                                          : (isStateAvailable == 1)
                                              ? Theme.of(context).primaryColor
                                              : null,
                                ),
                                Text(
                                  'Unlock',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: isStateAvailable == 3
                                            ? Colors.white
                                            : isStateAvailable == 2
                                                ? Colors.white
                                                : Theme.of(context)
                                                    .primaryColor,
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
              );
            },
          ),
        );
      },
    );
  }
}
