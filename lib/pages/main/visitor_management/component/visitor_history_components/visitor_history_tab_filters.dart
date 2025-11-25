import 'package:admin/pages/main/dashboard/view_model/filters_model.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

class VisitorHistoryTabFilters extends StatelessWidget {
  const VisitorHistoryTabFilters({super.key, required this.bloc});

  final VisitorManagementBloc bloc;

  static List<FiltersModel> historyFilters = [
    FiltersModel(title: "All", value: null),
    FiltersModel(title: "Today", value: "today"),
    FiltersModel(title: "Yesterday", value: "yesterday"),
    FiltersModel(title: "This Week", value: "this_week"),
    FiltersModel(title: "This Month", value: "this_month"),
  ];

  @override
  Widget build(BuildContext context) {
    final Color tabLineColor = CommonFunctions.getTabLineColor(context);
    final Color tabSelectedColor = CommonFunctions.getTabSelectedColor(context);
    return SizedBox(
      height: 38,
      child: VisitorManagementBlocSelector(
        selector: (state) =>
            state.statisticsVisitorApi.isApiInProgress ||
            state.visitorHistoryApi.isApiInProgress,
        builder: (inProgress) {
          return VisitorManagementBlocSelector.historyFilterValue(
            builder: (filter) {
              return ListView.builder(
                controller: bloc.historyFilterScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: historyFilters.toBuiltList().length,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (!inProgress) {
                        if (historyFilters[index].value != filter) {
                          bloc
                            ..scrollToIndex(
                              index,
                              context,
                            )
                            ..callFilters(
                              filterValue: historyFilters[index].value,
                              forVisitorHistoryPage: true,
                              visitorId:
                                  bloc.state.selectedVisitor!.id.toString(),
                            );
                        }
                      }
                    },
                    child: IntrinsicWidth(
                      stepWidth:
                          MediaQuery.of(context).size.width > 500 ? 130 : 20,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: 20,
                              left: (index == 0) ? 10.0 : 0.0,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  historyFilters[index].title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: historyFilters[index].value == filter
                                        ? tabSelectedColor
                                        : AppColors.lightGreyColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6.5,
                                ),
                                if (historyFilters[index].value == filter)
                                  Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: tabSelectedColor,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        topRight: Radius.circular(3),
                                      ),
                                    ),
                                  )
                                else
                                  const SizedBox(
                                    height: 4,
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              right: 20,
                              left: (index == 0) ? 20.0 : 0.0,
                            ),
                            color: tabLineColor,
                            height: 1.2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
