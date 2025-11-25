import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:flutter/material.dart';

class VisitorManagementDeleteDialog extends StatelessWidget {
  const VisitorManagementDeleteDialog({
    super.key,
    required this.deleteDialogTitle,
    this.deleteDialogDesc,
    required this.confirmButtonTap,
    required this.cancelButtonTap,
    required this.confirmButtonTitle,
  });
  final String deleteDialogTitle;
  final String? deleteDialogDesc;
  final VoidCallback confirmButtonTap;
  final VoidCallback cancelButtonTap;
  final String confirmButtonTitle;

  @override
  Widget build(BuildContext context) {
    return AppDialogPopup(
      title: deleteDialogTitle,
      description: deleteDialogDesc,
      headerWidget: Image.asset(
        DefaultImages.WARNING_IMAGE,
        height: 120,
        width: 160,
      ),
      cancelButtonLabel: context.appLocalizations.general_cancel,
      confirmButtonLabel: confirmButtonTitle,
      cancelButtonOnTap: cancelButtonTap,
      confirmButtonOnTap: confirmButtonTap,
    );
  }
}
