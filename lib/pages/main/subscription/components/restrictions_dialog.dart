import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';

class RestrictionsDialog extends StatelessWidget {
  const RestrictionsDialog({super.key, required this.dialogContext});

  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return AppDialogPopup(
      title: context.appLocalizations.upgrade_your_plan_to_unlock_this_feature,
      confirmButtonLabel: context.appLocalizations.upgrade_now,
      confirmButtonOnTap: () {
        CommonFunctions.openUrl(Constants.upgradeDowngradeUrl);
        Navigator.pop(dialogContext);
      },
      cancelButtonLabel: context.appLocalizations.general_cancel,
      cancelButtonOnTap: () {
        Navigator.pop(dialogContext);
      },
    );
  }
}
