import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:super_tooltip/super_tooltip.dart';

class VisitorFilterPanel extends StatelessWidget {
  const VisitorFilterPanel({
    super.key,
    required this.bloc,
    this.forVisitorHistoryPage = false,
    this.visitorId,
  });
  final VisitorManagementBloc bloc;
  final bool forVisitorHistoryPage;
  final String? visitorId;

  TextStyle textStyle(BuildContext context, String filterKey) {
    const fixedFilters = {"today", "yesterday", "this_week", "this_month"};
    bool isSelected = false;

    if (bloc.state.filterValue != null) {
      if (fixedFilters.contains(bloc.state.filterValue)) {
        // highlight the matching fixed filter
        isSelected = filterKey == bloc.state.filterValue;
      } else {
        // any other non-null value => treat as custom
        isSelected = filterKey == "custom";
      }
    }
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: isSelected
              ? Theme.of(context).primaryColor
              : CommonFunctions.getThemeBasedWidgetColor(context),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 12,
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        bloc.state.superToolTipController.showTooltip();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: SuperTooltip(
          arrowTipDistance: 20,
          arrowLength: 8,
          arrowTipRadius: 6,
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
          backgroundColor:
              CommonFunctions.getThemePrimaryLightWhiteColor(context),
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
                  tooTipTap(context, context.appLocalizations.today, "today"),
                  tooTipTap(
                    context,
                    context.appLocalizations.yesterday,
                    "yesterday",
                  ),
                  tooTipTap(
                    context,
                    context.appLocalizations.this_week,
                    "this_week",
                  ),
                  tooTipTap(
                    context,
                    context.appLocalizations.this_month,
                    "this_month",
                  ),
                  VisitorManagementBlocSelector(
                    selector: (state) => forVisitorHistoryPage
                        ? state.visitorHistoryApi.isApiInProgress
                        : state.visitorManagementApi.isApiInProgress,
                    builder: (inProgress) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          await bloc.state.superToolTipController.hideTooltip();
                          if (!inProgress) {
                            bool hasLastFilterDate = false;
                            final DateFormat format = DateFormat(
                              "dd-MM-yyyy",
                            ); // Match the format of input string
                            DateTime parsedDate = DateTime.now();
                            try {
                              parsedDate =
                                  format.parse(bloc.state.filterValue!);
                              hasLastFilterDate = true;
                            } catch (e) {
                              hasLastFilterDate = false;
                            }
                            final result = await showCustomDatePicker(
                              context: context.mounted ? context : context,
                              value: hasLastFilterDate
                                  ? [parsedDate]
                                  : [DateTime.now()],
                            );
                            if (result != null) {
                              if (bloc.state.filterValue !=
                                  DateFormat('dd-MM-yyyy')
                                      .format(result[0] as DateTime)) {
                                await bloc.callFilters(
                                  filterValue: DateFormat('dd-MM-yyyy')
                                      .format(result[0] as DateTime),
                                  visitorId: visitorId,
                                  forVisitorHistoryPage: forVisitorHistoryPage,
                                );
                              }
                            }
                            await bloc.state.superToolTipController
                                .hideTooltip();
                          }
                        },
                        child: SizedBox(
                          width: 27.w,
                          child: Text(
                            context.appLocalizations.custom,
                            style: textStyle(context, "custom"),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          controller: bloc.state.superToolTipController,
          child: Icon(
            MdiIcons.tuneVerticalVariant,
            size: 24,
            color: CommonFunctions.getThemeBasedWidgetColor(context),
          ),
        ),
      ),
    );
  }

  Widget tooTipTap(BuildContext context, String text, String filter) {
    return VisitorManagementBlocSelector(
      selector: (state) => forVisitorHistoryPage
          ? state.visitorHistoryApi.isApiInProgress
          : state.visitorManagementApi.isApiInProgress,
      builder: (inProgress) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                await bloc.state.superToolTipController.hideTooltip();
                if (!inProgress) {
                  if (bloc.state.filterValue != filter) {
                    await bloc.callFilters(
                      filterValue: filter,
                      visitorId: visitorId,
                      forVisitorHistoryPage: forVisitorHistoryPage,
                    );
                  }
                }
              },
              child: SizedBox(
                width: 27.w,
                child: Text(
                  text,
                  style: textStyle(context, filter),
                ),
              ),
            ),
            const PopupMenuDivider(),
          ],
        );
      },
    );
  }
}
