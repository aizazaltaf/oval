// import 'package:admin/extensions/context.dart';
// import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
// import 'package:admin/pages/main/visitor_management/component/visitor_management_components/visitor_card.dart';
// import 'package:admin/pages/main/visitor_management/guides/visitor_management_guide/visitor_listview_guide.dart';
// import 'package:admin/widgets/common_functions.dart';
// import 'package:admin/widgets/list_view_seperated.dart';
// import 'package:admin/widgets/progress_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sizer/flutter_sizer.dart';
// import 'package:showcaseview/showcaseview.dart';
//
// class VisitorManagementListView extends StatefulWidget {
//   const VisitorManagementListView({
//     super.key,
//     required this.bloc,
//     required this.innerContext,
//   });
//   final VisitorManagementBloc bloc;
//   final BuildContext innerContext;
//
//   @override
//   State<VisitorManagementListView> createState() =>
//       _VisitorManagementListViewState();
// }
//
// class _VisitorManagementListViewState extends State<VisitorManagementListView> {
//   String getEmptyListError(BuildContext context) {
//     return "${(widget.bloc.state.filterValue == null || widget.bloc.state.filterValue!.isEmpty) ? "" : ""
//         " of ${widget.bloc.getAppliedFilterTitle(widget.bloc.state.filterValue, context)}"}.";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return VisitorManagementBlocSelector(
//       selector: (state) => state.visitorManagementApi,
//       builder: (api) => (api.isApiInProgress &&
//               widget.bloc.state.visitorManagementApi.data == null)
//           ? Container(
//               alignment: Alignment.center,
//               padding: EdgeInsets.only(top: 30.h),
//               child: const ButtonProgressIndicator(),
//             )
//           : widget.bloc.state.visitorManagementApi.data == null ||
//                   widget.bloc.state.visitorManagementApi.data!.data.isEmpty
//               ? Container(
//                   padding: EdgeInsets.only(top: 30.h),
//                   child: Text(
//                     "${context.appLocalizations.no_records_available}"
//                     "${getEmptyListError(context)}",
//                     textAlign: TextAlign.center,
//                     maxLines: 2,
//                     style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                           fontWeight: FontWeight.w500,
//                           color:
//                               CommonFunctions.getThemeBasedWidgetColor(context),
//                           fontSize: 16,
//                         ),
//                   ),
//                 )
//               : VisitorManagementBlocSelector.search(
//                   builder: (search) {
//                     bool searchContains = false;
//                     return Expanded(
//                       child: ListViewSeparatedWidget(
//                         controller:
//                             widget.bloc.visitorManagementScrollController,
//                         list: widget.bloc.state.visitorManagementApi.data!.data,
//                         padding: const EdgeInsets.only(
//                           left: 20,
//                           right: 20,
//                           bottom: kBottomNavigationBarHeight - 20,
//                         ),
//                         physics: const AlwaysScrollableScrollPhysics(),
//                         separatorBuilder: (context, index) =>
//                             const SizedBox.shrink(),
//                         itemBuilder: (context, index) {
//                           if (search != null) {
//                             String visitorName = widget.bloc.state
//                                 .visitorManagementApi.data!.data[index].name
//                                 .toLowerCase();
//                             if (visitorName.contains("a new visitor")) {
//                               visitorName = "unknown";
//                             }
//                             if (visitorName
//                                 .contains(search.toLowerCase().trim())) {
//                               searchContains = true;
//                               return VisitorCard(
//                                 bloc: widget.bloc,
//                                 visitor: widget.bloc.state.visitorManagementApi
//                                     .data!.data[index],
//                               );
//                             } else {
//                               if (!searchContains &&
//                                   index ==
//                                       widget.bloc.state.visitorManagementApi
//                                               .data!.data.length -
//                                           1) {
//                                 return Container(
//                                   padding: EdgeInsets.only(top: 30.h),
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     context.appLocalizations
//                                         .no_records_available_for_this_search,
//                                     textAlign: TextAlign.center,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyMedium!
//                                         .copyWith(
//                                           fontWeight: FontWeight.w500,
//                                           color: CommonFunctions
//                                               .getThemeBasedWidgetColor(
//                                             context,
//                                           ),
//                                           fontSize: 16,
//                                         ),
//                                   ),
//                                 );
//                               }
//                               return const SizedBox.shrink();
//                             }
//                           }
//                           if (index == 0) {
//                             return Showcase.withWidget(
//                               key: widget.bloc.visitorListGuideKey,
//                               height: 300,
//                               width: MediaQuery.of(context).size.width,
//                               tooltipPosition: TooltipPosition.bottom,
//                               targetBorderRadius: BorderRadius.circular(12),
//                               container: VisitorListviewGuide(
//                                 innerContext: widget.innerContext,
//                                 bloc: widget.bloc,
//                               ),
//                               child: VisitorCard(
//                                 bloc: widget.bloc,
//                                 visitor: widget.bloc.state.visitorManagementApi
//                                     .data!.data[index],
//                               ),
//                             );
//                           }
//                           return VisitorCard(
//                             bloc: widget.bloc,
//                             visitor: widget.bloc.state.visitorManagementApi
//                                 .data!.data[index],
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }
