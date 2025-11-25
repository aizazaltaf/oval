import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/bottom_navigation/visitor_history_edit_name_dialog.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/visitor_chart.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/visitor_history_card.dart';
import 'package:admin/pages/main/visitor_management/guides/visitor_history_guides/history_listview_guide.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/list_view_seperated.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:showcaseview/showcaseview.dart';

class VisitorHistoryListView extends StatefulWidget {
  const VisitorHistoryListView({
    super.key,
    required this.bloc,
    required this.visitor,
    required this.innerContext,
  });

  final VisitorManagementBloc bloc;
  final BuildContext innerContext;
  final VisitorsModel? visitor;

  @override
  State<VisitorHistoryListView> createState() => _VisitorHistoryListViewState();
}

class _VisitorHistoryListViewState extends State<VisitorHistoryListView> {
  String getEmptyListError(BuildContext context) {
    return "${(widget.bloc.state.historyFilterValue == null || widget.bloc.state.historyFilterValue!.isEmpty) ? "" : ""
        " of ${widget.bloc.getAppliedFilterTitle(widget.bloc.state.historyFilterValue, context)}"}.";
  }

  void showUnknownVisitorsDialog(BuildContext context, int index) {
    final int listLength = (widget.bloc.state.visitorHistoryApi.data == null &&
            widget.bloc.state.visitorHistoryApi.data!.data.isEmpty)
        ? 0
        : widget.bloc.state.visitorHistoryApi.data!.data.length;
    if (listLength > 1 &&
        index == 1 &&
        !widget.bloc.state.visitHistoryFirstBool) {
      widget.bloc.updateVisitHistoryFirstBool(true);
      WidgetsBinding.instance.addPostFrameCallback((callback) {
        if (widget.visitor != null) {
          showDialog(
            context: context,
            builder: (context) => VisitorHistoryEditNameDialog(
              bloc: widget.bloc,
              visitor: widget.visitor!,
              imageUrl: widget.visitor!.imageUrl.toString(),
              visitorId: widget.visitor!.id.toString(),
              fromVisitorHistory: true,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.visitor == null) {
      return const SizedBox.shrink();
    }
    return VisitorManagementBlocSelector(
      selector: (state) =>
          state.visitorHistoryApi.isApiInProgress ||
          state.statisticsVisitorApi.isApiInProgress,
      builder: (isLoading) {
        if (isLoading) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 30.h),
            child: const ButtonProgressIndicator(),
          );
        } else {
          Constants.dismissLoader();

          return widget.bloc.state.visitorHistoryApi.data == null ||
                  widget.bloc.state.visitorHistoryApi.data!.data.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 30.h),
                  child: Text(
                    "${context.appLocalizations.no_records_available}"
                    "${getEmptyListError(context)}",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2,
                          color: CommonFunctions.getThemeBasedWidgetColor(
                            context,
                          ),
                          fontSize: 16,
                        ),
                  ),
                )
              : Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VisitorManagementBlocSelector(
                        selector: (state) =>
                            state.statisticsVisitorApi.isApiInProgress,
                        builder: (isLoading) => isLoading
                            ? const SizedBox.shrink()
                            : VisitorManagementBlocSelector(
                                selector: (state) => state.statisticsList,
                                builder: (statisticsTitle) => Row(
                                  children: [
                                    if (widget.bloc.state.statisticsList
                                            .isEmpty ||
                                        widget.bloc.state.statisticsList.every(
                                          (element) => element.visitCount == 0,
                                        ))
                                      const SizedBox.shrink()
                                    else
                                      RotatedBox(
                                        quarterTurns: 3,
                                        child: Text(
                                          context.appLocalizations.no_of_visits,
                                          style: TextStyle(
                                            color: AppColors.darkBlackColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.26,
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      child: VisitorChart(
                                        statisticsList:
                                            widget.bloc.state.statisticsList,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        context.appLocalizations.visit_log,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: CommonFunctions.getThemeBasedWidgetColor(
                                context,
                              ),
                            ),
                      ),
                      Expanded(
                        child: ListViewSeparatedWidget(
                          list: widget.bloc.state.visitorHistoryApi.data!.data,
                          controller:
                              widget.bloc.visitorHistoryScrollController,
                          padding: const EdgeInsets.only(
                            bottom: kBottomNavigationBarHeight - 20,
                          ),
                          physics: const AlwaysScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              const SizedBox.shrink(),
                          itemBuilder: (context, index) {
                            if (!isLoading &&
                                widget.visitor!.name.contains('A new')) {
                              showUnknownVisitorsDialog(context, index);
                            }
                            if (index == 0) {
                              return Showcase.withWidget(
                                key: widget.bloc.historyListGuideKey,
                                height: 500,
                                width: MediaQuery.of(context).size.width,
                                tooltipPosition: TooltipPosition.bottom,
                                targetBorderRadius: BorderRadius.circular(12),
                                container: HistoryListviewGuide(
                                  innerContext: widget.innerContext,
                                  bloc: widget.bloc,
                                ),
                                child: VisitorHistoryCard(
                                  bloc: widget.bloc,
                                  visit: widget.bloc.state.visitorHistoryApi
                                      .data!.data[index],
                                  visitor: widget.visitor!,
                                ),
                              );
                            }
                            return VisitorHistoryCard(
                              bloc: widget.bloc,
                              visit: widget.bloc.state.visitorHistoryApi.data!
                                  .data[index],
                              visitor: widget.visitor!,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
        }
      },
    );
  }
}
