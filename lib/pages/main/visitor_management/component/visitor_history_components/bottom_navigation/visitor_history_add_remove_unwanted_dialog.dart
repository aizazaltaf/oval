import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:flutter/material.dart';

class VisitorHistoryAddRemoveUnwantedDialog extends StatelessWidget {
  const VisitorHistoryAddRemoveUnwantedDialog({
    super.key,
    required this.bloc,
    required this.confirmButtonTap,
    required this.isWanted,
  });
  final VisitorManagementBloc bloc;
  final int isWanted;
  final VoidCallback confirmButtonTap;

  @override
  Widget build(BuildContext context) {
    return AppDialogPopup(
      title: isWanted == 0
          ? context.appLocalizations.add_unwanted_visitor_dialog_title
          : context.appLocalizations.remove_unwanted_visitor_dialog_title,
      description: isWanted == 0
          ? context.appLocalizations.add_unwanted_visitor_dialog_desc
          : context.appLocalizations.remove_unwanted_visitor_dialog_desc,
      cancelButtonLabel: context.appLocalizations.general_no,
      headerWidget: Image.asset(
        DefaultImages.WARNING_IMAGE,
        height: 120,
        width: 160,
      ),
      confirmButtonLabel: context.appLocalizations.general_yes,
      cancelButtonOnTap: () => Navigator.of(context).pop(),
      confirmButtonOnTap: confirmButtonTap,
    );
  }
}
