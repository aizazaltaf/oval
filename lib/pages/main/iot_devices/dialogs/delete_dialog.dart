import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

final _logger = Logger('delete_dialog.dart');

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    super.key,
    required this.bloc,
    this.isNotRoom = true,
    this.fromVoice = false,
  });

  final IotBloc bloc;
  final bool isNotRoom;
  final bool fromVoice;

  @override
  Widget build(BuildContext context) {
    if (bloc.state.inRoomIotDeviceModel == null) {
      return const SizedBox.shrink();
    } else if (bloc.state.selectedIotIndex >
            bloc.state.inRoomIotDeviceModel!.length - 1 &&
        isNotRoom) {
      return const SizedBox.shrink();
    }
    if (bloc.state.inRoomIotDeviceModel == null) {
      return const SizedBox.shrink();
    }

    final device = isNotRoom
        ? bloc.state.inRoomIotDeviceModel![bloc.state.selectedIotIndex]
        : null;

    return BlocProvider.value(
      value: bloc,
      child: IotBlocSelector(
        selector: (state) => isNotRoom
            ? (state.deleteIotDevice.isSocketInProgress ||
                state.deleteCurtainDevice.isApiInProgress)
            : state.editIotDevice.isApiInProgress,
        builder: (isLoading) {
          return AppDialogPopup(
            isLoadingEnabled: isLoading,
            needCross: false,
            title: isNotRoom
                ? context.appLocalizations.delete_iot_device
                : context.appLocalizations.delete_room_dialog_title,
            confirmButtonLabel: context.appLocalizations.general_yes,
            confirmButtonOnTap: () {
              if (isNotRoom) {
                if (device!.entityId!.isSwitchBot()) {
                  bloc.deleteCurtainDevices(device.entityId!, () {
                    bloc.callIotApi();
                    // Future.delayed(
                    //   Duration(
                    //     seconds: Constants.durationRefreshSeconds,
                    //   ),
                    //   bloc.withDebounceUpdateWhenDeviceUnreachable,
                    // );
                    Navigator.pop(context, true);
                  });
                } else {
                  bloc.deleteIotDevice(device.id, device.entityId!, () {
                    bloc.callIotApi();
                    // Future.delayed(
                    //   Duration(
                    //     seconds: Constants.durationRefreshSeconds,
                    //   ),
                    //   bloc.withDebounceUpdateWhenDeviceUnreachable,
                    // );
                    Navigator.pop(context, true);
                  });
                }
              } else {
                if (bloc.state.selectedRoom != null) {
                  bloc.deleteRoom(bloc.state.selectedRoom!, (val) {
                    Navigator.pop(context, val);
                  });
                } else {
                  _logger.severe(bloc.state.selectedRoom.toString());
                }
              }
            },
            cancelButtonLabel: context.appLocalizations.general_no,
            cancelButtonOnTap: () {
              if (!isLoading) {
                Navigator.pop(context);
              }
            },
          );
        },
      ),
    );

    //   Dialog(
    //     child: BlocProvider.value(
    //     value: bloc,
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         spacing: 10,
    //         children: [
    //           Text(
    //             isNotRoom
    //                 ? context.appLocalizations.delete_iot_device
    //                 : context.appLocalizations.delete_room_dialog_title,
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 8),
    //             child: Row(
    //               spacing: 10,
    //               crossAxisAlignment: CrossAxisAlignment.end,
    //               children: [
    //                 Expanded(
    //                   child: CustomCancelButton(
    //                     onSubmit: () {
    //                       Navigator.pop(context);
    //                     },
    //                     label: context.appLocalizations.general_no,
    //                   ),
    //                 ),
    //                 Expanded(
    //                   child: IotBlocSelector(
    //                     selector: (state) => isNotRoom
    //                         ? (state.deleteIotDevice.isSocketInProgress ||
    //                             state.deleteCurtainDevice.isApiInProgress)
    //                         : state.editIotDevice.isApiInProgress,
    //                     builder: (isLoading) {
    //                       return CustomGradientButton(
    //                         isLoadingEnabled: isLoading,
    //                         onSubmit: () {
    //                           if (isNotRoom) {
    //                             if (device!.entityId!.isSwitchBotCurtain()) {
    //                               bloc.deleteCurtainDevices(device.entityId!,
    //                                   () {
    //                                 bloc.callIotApi();
    //                                 Future.delayed(
    //                                   Duration(
    //                                     seconds:
    //                                         Constants.durationRefreshSeconds,
    //                                   ),
    //                                   bloc.withDebounceUpdateWhenDeviceUnreachable,
    //                                 );
    //                                 Navigator.pop(context, true);
    //                               });
    //                             } else {
    //                               bloc.deleteIotDevice(
    //                                   device.id, device.entityId!, () {
    //                                 bloc.callIotApi();
    //                                 Future.delayed(
    //                                   Duration(
    //                                     seconds:
    //                                         Constants.durationRefreshSeconds,
    //                                   ),
    //                                   bloc.withDebounceUpdateWhenDeviceUnreachable,
    //                                 );
    //                                 Navigator.pop(context, true);
    //                               });
    //                             }
    //                           } else {
    //                             bloc.deleteRoom(bloc.state.selectedRoom!,
    //                                 (val) {
    //                               Navigator.pop(context, val);
    //                             });
    //                           }
    //                         },
    //                         label: context.appLocalizations.general_yes,
    //                       );
    //                     },
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
