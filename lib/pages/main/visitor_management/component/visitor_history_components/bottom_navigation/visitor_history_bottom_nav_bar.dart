import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_management_delete_dialog.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class VisitorHistoryBottomNavBar extends StatelessWidget {
  const VisitorHistoryBottomNavBar({
    super.key,
    required this.visitor,
    required this.bloc,
    required this.parentContext,
    required this.innerContext,
  });
  final VisitorsModel? visitor;
  final VisitorManagementBloc bloc;
  final BuildContext parentContext;
  final BuildContext innerContext;

  @override
  Widget build(BuildContext context) {
    return VisitorManagementBlocSelector.deleteVisitorHistoryIdsList(
      builder: (list) => list == null
          ? const SizedBox.shrink()
          // SizedBox(
          //     height: 12.h,
          //     child: VisitorManagementBlocSelector(
          //       selector: (state) => state.visitorHistoryApi.data,
          //       builder: (visitorResponse) => VisitorHistoryModesMenu(
          //         visitor: visitor,
          //         bloc: bloc,
          //         innerContext: innerContext,
          //       ),
          //     ),
          //   )
          : Padding(
              padding: EdgeInsets.only(bottom: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomCancelButton(
                    label: context.appLocalizations.general_cancel,
                    onSubmit: () {
                      bloc.updateDeleteVisitorHistoryIdsList(null);
                    },
                  ),
                  CustomGradientButton(
                    forDialog: true,
                    onSubmit: () {
                      if (list.isEmpty) {
                        ToastUtils.warningToast(
                          context.appLocalizations.delete_visits_errCheckBox,
                        );
                      } else {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => VisitorManagementDeleteDialog(
                            deleteDialogTitle:
                                context.appLocalizations.delete_visitor,
                            deleteDialogDesc: context.appLocalizations
                                .delete_visitor_history_dialog_title,
                            confirmButtonTap: () {
                              if (visitor != null) {
                                bloc.callDeleteVisitorHistory(
                                  visitor: visitor!,
                                  visitorPagePopup: () {
                                    Navigator.pop(parentContext);
                                  },
                                );
                                Navigator.of(context).pop();
                              }
                            },
                            cancelButtonTap: () {
                              Navigator.of(context).pop();
                            },
                            confirmButtonTitle:
                                context.appLocalizations.general_yes,
                          ),
                        );
                      }
                    },
                    label: context.appLocalizations.general_delete,
                  ),
                ],
              ),
            ),
    );
  }
}
