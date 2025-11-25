import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/device_onboarding/wifi_list_page.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:flutter/material.dart';

class BluetoothConnectionEstablishedDialog extends StatelessWidget {
  const BluetoothConnectionEstablishedDialog({
    super.key,
    required this.dialogContext,
    required this.navigationContext,
  });

  final BuildContext dialogContext;
  final BuildContext navigationContext;

  @override
  Widget build(BuildContext context) {
    return AppDialogPopup(
      needCross: false,
      headerWidget: const Icon(
        Icons.bluetooth,
        size: 36,
      ),
      title: context.appLocalizations.ble_connection,
      description: context.appLocalizations.ble_connection_established_desc,
      confirmButtonLabel: context.appLocalizations.okay,
      confirmButtonOnTap: () {
        Navigator.pop(dialogContext);
        WifiListPage.pushReplacement(navigationContext);
      },
    );
  }
}
