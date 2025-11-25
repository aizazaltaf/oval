// import 'package:admin/extensions/context.dart';
// import 'package:admin/models/data/visitors_model.dart';
// import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
// import 'package:admin/pages/main/visitor_management/component/visitor_history_components/bottom_navigation/bottom_nav_item.dart';
// import 'package:admin/pages/main/visitor_management/component/visitor_history_components/bottom_navigation/visitor_history_add_remove_unwanted_dialog.dart';
// import 'package:admin/pages/main/visitor_management/component/visitor_history_components/bottom_navigation/visitor_history_edit_name_dialog.dart';
// import 'package:admin/pages/main/visitor_management/guides/visitor_history_guides/edit_name_guide.dart';
// import 'package:admin/pages/main/visitor_management/guides/visitor_history_guides/message_guide.dart';
// import 'package:admin/pages/main/visitor_management/guides/visitor_history_guides/neighbourhood_guide.dart';
// import 'package:admin/pages/main/visitor_management/guides/visitor_history_guides/unwanted_visitor_guide.dart';
// import 'package:admin/utils/toast_utils.dart';
// import 'package:admin/widgets/common_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:showcaseview/showcaseview.dart';
//
// class VisitorHistoryModesMenu extends StatelessWidget {
//   const VisitorHistoryModesMenu({
//     super.key,
//     required this.visitor,
//     required this.bloc,
//     required this.innerContext,
//   });
//   final VisitorsModel? visitor;
//   final VisitorManagementBloc bloc;
//   final BuildContext innerContext;
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         decoration: BoxDecoration(
//           color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
//           boxShadow: [
//             BoxShadow(
//               color: Theme.of(context).brightness == Brightness.light
//                   ? Colors.black26
//                   : Colors.white,
//               blurRadius: 10,
//             ),
//           ],
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(25),
//             topRight: Radius.circular(25),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.only(top: 12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Showcase.withWidget(
//                 key: bloc.historyEditNameGuideKey,
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 tooltipPosition: TooltipPosition.top,
//                 targetBorderRadius: BorderRadius.circular(12),
//                 container:
//                     EditNameGuide(innerContext: innerContext, bloc: bloc),
//                 child: BottomNavItem(
//                   title: context.appLocalizations.edit_name,
//                   onTap: () => showDialog(
//                     context: context,
//                     builder: (context) => VisitorHistoryEditNameDialog(
//                       bloc: bloc,
//                       visitorName: visitor!.name,
//                       imageUrl: visitor!.imageUrl.toString(),
//                       visitorId: visitor!.id.toString(),
//                     ),
//                   ),
//                   icon: Icons.edit,
//                 ),
//               ),
//               Showcase.withWidget(
//                 key: bloc.historyUnwantedGuideKey,
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 tooltipPosition: TooltipPosition.top,
//                 container: UnwantedVisitorGuide(
//                   innerContext: innerContext,
//                   bloc: bloc,
//                 ),
//                 child: BottomNavItem(
//                   title: visitor!.isWanted == 0
//                       ? context.appLocalizations.add_in_unwanted_visitor_list
//                       : context.appLocalizations.remove_from_unwanted_list,
//                   onTap: () => showDialog(
//                     context: context,
//                     builder: (context) => VisitorHistoryAddRemoveUnwantedDialog(
//                       bloc: bloc,
//                       confirmButtonTap: () {
//                         bloc.callMarkWantedOrUnwantedVisitor(visitor!);
//                         Navigator.of(context).pop();
//                       },
//                       isWanted: visitor!.isWanted,
//                     ),
//                   ),
//                   icon: visitor!.isWanted == 0
//                       ? Icons.add_circle_outline_outlined
//                       : Icons.cancel_outlined,
//                 ),
//               ),
//               Showcase.withWidget(
//                 key: bloc.historyNeighbourhoodGuideKey,
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 tooltipPosition: TooltipPosition.top,
//                 container: NeighbourhoodGuide(
//                   innerContext: innerContext,
//                   bloc: bloc,
//                 ),
//                 child: BottomNavItem(
//                   title: context.appLocalizations.share_to_neighbourhood,
//                   onTap: () => ToastUtils.infoToast(
//                     context.appLocalizations.coming_soon,
//                     context
//                         .appLocalizations.share_to_neighbourhood_available_soon,
//                   ),
//                   needDisabled: true,
//                   icon: Icons.ios_share_outlined,
//                 ),
//               ),
//               Showcase.withWidget(
//                 key: bloc.historyMessageGuideKey,
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 tooltipPosition: TooltipPosition.top,
//                 container: MessageGuide(
//                   innerContext: innerContext,
//                   bloc: bloc,
//                 ),
//                 child: BottomNavItem(
//                   title: context.appLocalizations.general_message,
//                   needDisabled: true,
//                   onTap: () => ToastUtils.infoToast(
//                     context.appLocalizations.coming_soon,
//                     context.appLocalizations.message_available_soon,
//                   ),
//                   icon: Icons.message_outlined,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
