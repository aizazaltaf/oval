import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_drop_down_button.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class MoveDialog extends StatelessWidget {
  const MoveDialog({
    super.key,
    required this.bloc,
    this.iotCamera,
    this.cameraRoomId,
  });

  final IotBloc bloc;
  final IotDeviceModel? iotCamera;
  final int? cameraRoomId;

  @override
  Widget build(BuildContext context) {
    final isCamera = iotCamera != null;
    final device = iotCamera ??
        bloc.state.inRoomIotDeviceModel![bloc.state.selectedIotIndex];
    if (isCamera) {
      bloc.updateSelectedFormRoom(
        bloc.state.getIotRoomsApi.data!
            .firstWhere((e) => e.roomId == cameraRoomId),
      );
    } else {
      bloc.updateSelectedFormRoom(
        bloc.state.getIotRoomsApi.data!
            .firstWhere((e) => e.roomId == device.roomId),
      );
    }
    return Dialog(
      child: BlocProvider.value(
        value: bloc,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  context.appLocalizations.move_to,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: CommonFunctions.getThemeBasedWidgetColor(
                          context,
                        ),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
              const SizedBox(height: 20),
              IotBlocSelector.selectedFormRoom(
                builder: (selectedRoom) {
                  return AppDropDownButton(
                    dropDownTextStyle:
                        Theme.of(context).textTheme.displayMedium,
                    items: bloc.state.getIotRoomsApi.data!,
                    selectedValue: selectedRoom,
                    onChanged: bloc.updateSelectedFormRoom,
                    displayDropDownItems: (item) => item.roomName!,
                    buttonHeight: 6.h,
                    dropdownRadius: 10,
                    dropDownWidth: 70.w,
                    dropDownHeight: 22.h,
                  );
                },
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textTheme: const TextTheme(
                      titleSmall: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      IotBlocSelector(
                        selector: (state) =>
                            state.editIotDevice.isApiInProgress,
                        builder: (isLoading) {
                          return CustomGradientButton(
                            isLoadingEnabled: isLoading,
                            onSubmit: () {
                              bloc.editIotDevice(
                                device.id,
                                device.deviceName,
                                device.entityId,
                                bloc.state.selectedFormRoom!.roomId,
                                () {
                                  if (isCamera) {
                                    unawaited(
                                      StartupBloc.of(context).getUserDoorbells(
                                        id: singletonBloc.profileBloc.state
                                            ?.selectedDoorBell?.locationId,
                                      ),
                                    );
                                  }
                                  ToastUtils.successToast(
                                    context
                                        .appLocalizations.successfully_updated,
                                  );
                                  Navigator.pop(context, true);
                                },
                                camera: isCamera,
                              );
                            },
                            label: context.appLocalizations.move,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomCancelButton(
                        onSubmit: () {
                          Navigator.pop(context);
                        },
                        customWidth: 100.w,
                        label: context.appLocalizations.general_cancel,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
