import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/dialogs/delete_dialog.dart';
import 'package:admin/pages/main/iot_devices/dialogs/edit_name_dialog.dart';
import 'package:admin/pages/main/iot_devices/dialogs/move_dialog.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuAnchorWidget extends StatelessWidget {
  MenuAnchorWidget({super.key, required this.iotDeviceModel});

  final IotDeviceModel iotDeviceModel;
  final MenuController menuController = MenuController();

  Widget _menuItem(
    BuildContext context,
    String text,
    String iconPath,
    Function onPress,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onPress.call();
      },
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(
              CommonFunctions.getThemeBasedWidgetColor(context),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);
    return MenuAnchor(
      controller: menuController,
      builder: (context, menuController, child) {
        return IconButton(
          onPressed: () => menuController.isOpen
              ? menuController.close()
              : menuController.open(),
          icon: const Icon(
            Icons.more_vert,
            size: 28,
          ),
        );
      },
      style: MenuStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        alignment: Alignment.center,
        backgroundColor: WidgetStateProperty.all(
          CommonFunctions.getThemeWidgetColor(context),
        ),
        surfaceTintColor: WidgetStateProperty.all(
          CommonFunctions.getThemeWidgetColor(context),
        ),
        padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
      ),
      menuChildren: [
        _menuItem(context, "Edit", DefaultVectors.EDIT_SMART_DEVICES, () {
          menuController.close();

          if (singletonBloc.isViewer()) {
            ToastUtils.errorToast(
              context.appLocalizations.viewer_cannot_edit_device,
            );
          } else {
            bloc
              ..updateSelectedRoom(
                bloc.state.getIotRoomsApi.data!
                    .firstWhereOrNull((e) => e.roomId == iotDeviceModel.roomId),
              )
              ..updateSelectedIotIndex(
                bloc.state.inRoomIotDeviceModel!
                    .indexWhere((e) => e.id == iotDeviceModel.id),
              );
            showDialog(
              context: context,
              builder: (context) {
                return EditNameDialog(
                  bloc: bloc,
                );
              },
            );
          }
        }),
        const PopupMenuDivider(),
        _menuItem(context, "Move", DefaultVectors.MOVE_SMART_DEVICES, () {
          menuController.close();

          if (singletonBloc.isViewer()) {
            ToastUtils.errorToast(
              context.appLocalizations.viewer_cannot_move_room,
            );
          } else {
            bloc
              ..updateSelectedRoom(
                bloc.state.getIotRoomsApi.data!
                    .firstWhereOrNull((e) => e.roomId == iotDeviceModel.roomId),
              )
              ..updateSelectedIotIndex(
                bloc.state.inRoomIotDeviceModel!
                    .indexWhere((e) => e.id == iotDeviceModel.id),
              );
            showDialog(
              context: context,
              builder: (context) {
                return MoveDialog(
                  bloc: bloc,
                );
              },
            );
          }
        }),
        const PopupMenuDivider(),
        _menuItem(context, "Delete", DefaultVectors.DELETE_SMART_DEVICES, () {
          menuController.close();

          if (singletonBloc.isViewer()) {
            ToastUtils.errorToast(
              context.appLocalizations.viewer_cannot_delete_device,
            );
          } else {
            bloc
              ..updateSelectedRoom(
                bloc.state.getIotRoomsApi.data!
                    .firstWhereOrNull((e) => e.roomId == iotDeviceModel.roomId),
              )
              ..updateSelectedIotIndex(
                bloc.state.inRoomIotDeviceModel!
                    .indexWhere((e) => e.id == iotDeviceModel.id),
              );
            showDialog(
              context: context,
              builder: (context) {
                return DeleteDialog(
                  bloc: bloc,
                );
              },
            );
          }
        }),
      ],
    );
  }
}
