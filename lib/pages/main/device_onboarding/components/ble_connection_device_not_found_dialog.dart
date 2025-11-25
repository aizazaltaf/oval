import 'package:admin/extensions/context.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:flutter/material.dart';

class BleConnectionDeviceNotFoundDialog extends StatelessWidget {
  const BleConnectionDeviceNotFoundDialog({
    super.key,
    required this.dialogContext,
  });

  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return AppDialogPopup(
      needCross: false,
      headerWidget: const Icon(
        Icons.bluetooth,
        size: 36,
      ),
      title: context.appLocalizations.ble_connection,
      description: context.appLocalizations.ble_connection_device_not_found,
      confirmButtonLabel: context.appLocalizations.okay,
      confirmButtonOnTap: () {
        Navigator.pop(dialogContext);
      },
    );
  }
}
