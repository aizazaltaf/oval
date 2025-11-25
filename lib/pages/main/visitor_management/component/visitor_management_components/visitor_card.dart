import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/chat/visitor_chat_history_screen.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/bottom_navigation/visitor_history_add_remove_unwanted_dialog.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/bottom_navigation/visitor_history_edit_name_dialog.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_management_delete_dialog.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_profile_image.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:super_tooltip/super_tooltip.dart';

class VisitorCard extends StatelessWidget {
  VisitorCard({super.key, required this.visitor, required this.bloc});
  final VisitorsModel visitor;
  final VisitorManagementBloc bloc;

  final SuperTooltipController moreTooltipController = SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    final themeWidgetColor = CommonFunctions.getThemeBasedWidgetColor(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        bloc.visitorNameTap(context, visitor);
      },
      child: Column(
        children: [
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5),
            child: Row(
              children: [
                VisitorProfileImage(
                  visitor: visitor,
                ),
                SizedBox(width: 2.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width > 500 ? 80.w : 70.w,
                      child: Row(
                        children: [
                          Text(
                            visitor.name.contains("A new")
                                ? "Unknown"
                                : visitor.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: themeWidgetColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        VisitorHistoryEditNameDialog(
                                      bloc: bloc,
                                      visitor: visitor,
                                      imageUrl: visitor.imageUrl.toString(),
                                      visitorId: visitor.id.toString(),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.border_color_outlined,
                                  size: 20,
                                  color: themeWidgetColor,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              moreVisitorCard(context),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (visitor.isWanted == 1)
                      Text(
                        "(Unwanted Visitor)",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                      ),
                    Text(
                      CommonFunctions.getPerfectTime(
                        lastVisitDateTime:
                            visitor.lastVisit ?? DateTime.now().toString(),
                      ),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).disabledColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget moreVisitorCard(BuildContext context) {
    return SuperTooltip(
      controller: moreTooltipController,
      arrowTipDistance: 20,
      arrowLength: 8,
      arrowTipRadius: 6,
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
      backgroundColor: CommonFunctions.getThemePrimaryLightWhiteColor(context),
      borderColor: Colors.white,
      barrierColor: Colors.transparent,
      shadowBlurRadius: 7,
      shadowSpreadRadius: 0,
      showBarrier: true,
      content: IntrinsicWidth(
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tooTipTap(
                context: context,
                text: visitor.isWanted == 0
                    ? context.appLocalizations.add_in_unwanted_visitor_list
                    : context.appLocalizations.remove_from_unwanted_list,
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => VisitorHistoryAddRemoveUnwantedDialog(
                    bloc: bloc,
                    confirmButtonTap: () {
                      bloc.callMarkWantedOrUnwantedVisitor(visitor);
                      Navigator.of(context).pop();
                    },
                    isWanted: visitor.isWanted,
                  ),
                ),
              ),
              const PopupMenuDivider(),
              tooTipTap(
                context: context,
                text: context.appLocalizations.delete_visitor,
                onTap: () => showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => VisitorManagementDeleteDialog(
                    deleteDialogDesc: context
                        .appLocalizations.visitor_management_delete_dialog_desc,
                    deleteDialogTitle: context.appLocalizations.delete_visitor,
                    confirmButtonTap: () {
                      bloc.callDeleteVisitor(visitor);
                      Navigator.of(context).pop();
                    },
                    cancelButtonTap: () {
                      Navigator.of(context).pop();
                    },
                    confirmButtonTitle: context.appLocalizations.general_delete,
                  ),
                ),
              ),
              const PopupMenuDivider(),
              tooTipTap(
                context: context,
                text: context.appLocalizations.share_to_neighbourhood,
                onTap: () => ToastUtils.infoToast(
                  context.appLocalizations.coming_soon,
                  context
                      .appLocalizations.share_to_neighbourhood_available_soon,
                ),
              ),
              const PopupMenuDivider(),
              tooTipTap(
                context: context,
                text: context.appLocalizations.general_message,
                onTap: () {
                  VisitorChatHistoryScreen.push(
                    context: context,
                    visitor: visitor,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      child: Icon(
        MdiIcons.dotsVertical,
        size: 24,
        color: CommonFunctions.getThemeBasedWidgetColor(context),
      ),
    );
  }

  Widget tooTipTap({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            await moreTooltipController.hideTooltip();
            onTap.call();
          },
          child: SizedBox(
            width: 180,
            child: Text(
              text,
              style: textStyle(context),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: CommonFunctions.getThemeBasedWidgetColor(context),
          fontWeight: FontWeight.w400,
          fontSize: 12,
        );
  }
}
