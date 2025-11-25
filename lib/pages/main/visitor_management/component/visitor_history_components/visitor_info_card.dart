import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/dashboard/components/profile_image_viewer.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_profile_image.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VisitorInfoCard extends StatelessWidget {
  const VisitorInfoCard({
    super.key,
    required this.visitor,
    required this.bloc,
  });

  final VisitorsModel? visitor;
  final VisitorManagementBloc bloc;

  @override
  Widget build(BuildContext context) {
    if (visitor == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: 100.w,
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => ProfileImageViewer(
                  visitor: visitor!,
                ),
              );
            },
            child: VisitorProfileImage(visitor: visitor!),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                visitor!.name.contains("A new") ? "Unknown" : visitor!.name,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: CommonFunctions.getThemeBasedWidgetColor(
                        context,
                      ),
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                    ),
              ),
              VisitorManagementBlocSelector(
                selector: (state) => state.statisticsVisitorApi.isApiInProgress,
                builder: (isLoading) {
                  int totalCount = 0;
                  if (isLoading) {
                    totalCount = 0;
                  } else {
                    if (bloc.state.statisticsList.isNotEmpty) {
                      for (final element in bloc.state.statisticsList) {
                        totalCount = totalCount + element.visitCount;
                      }
                    }
                  }
                  return Text(
                    "Total Visits: $totalCount",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                  );
                },
              ),
            ],
          ),
          const Spacer(),
          CustomGradientButton(
            forDialog: true,
            customHeight: 30,
            customWidth: 120,
            customCircularRadius: 5,
            suffix: Icon(
              MdiIcons.calendarOutline,
              size: 18,
              color: Colors.white,
            ),
            onSubmit: () async {
              DateTime parsedDate;
              try {
                parsedDate = DateFormat(
                  "dd-MM-yyyy",
                ).parse(bloc.state.filterValue!);
              } catch (e) {
                parsedDate = DateTime.now();
              }
              final result = await showCustomDatePicker(
                context: context,
                value: [parsedDate],
              );
              if (result != null) {
                if (result is List && result.isNotEmpty) {
                  await bloc.callFilters(
                    forVisitorHistoryPage: true,
                    visitorId: bloc.state.selectedVisitor?.id.toString(),
                    filterValue:
                        DateFormat('dd-MM-yyyy').format(result[0] as DateTime),
                  );
                }
              }
            },
            label: context.appLocalizations.calendar,
            customButtonFontSize: 14,
          ),
        ],
      ),
    );
  }
}
