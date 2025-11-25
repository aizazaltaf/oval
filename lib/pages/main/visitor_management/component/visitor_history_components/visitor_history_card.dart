import 'package:admin/models/data/visit_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class VisitorHistoryCard extends StatelessWidget {
  const VisitorHistoryCard({
    super.key,
    required this.visit,
    required this.bloc,
    required this.visitor,
  });
  final VisitModel visit;
  final VisitorsModel visitor;
  final VisitorManagementBloc bloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        bloc.updateDeleteVisitorHistoryIdsList(
          BuiltList<String>([visit.id.toString()]),
        );
      },
      child: Column(
        children: [
          SizedBox(
            height: 1.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5),
            decoration: BoxDecoration(
              color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 7,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                VisitorManagementBlocSelector.deleteVisitorHistoryIdsList(
                  builder: (list) => list == null
                      ? const SizedBox.shrink()
                      : Checkbox(
                          value: list.contains(visit.id.toString()),
                          activeColor: AppColors.darkBluePrimaryColor,
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              5,
                            ), // Adjust corner radius
                          ),
                          fillColor: WidgetStateProperty.resolveWith((states) {
                            // active
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.darkBluePrimaryColor;
                            }
                            return null;
                            // inactive
                          }),
                          side: WidgetStateBorderSide.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return BorderSide(
                                width: 0.25,
                                color: AppColors.darkBlueColor,
                              );
                            }
                            // inactive
                            return BorderSide(
                              width: 0.25,
                              color: AppColors.textLightColor,
                            );
                          }),
                          onChanged: (checkBoxVal) {
                            final BuiltList<String> updatedList;
                            if (checkBoxVal == true) {
                              updatedList = bloc
                                  .state.deleteVisitorHistoryIdsList!
                                  .rebuild(
                                (builder) => builder.add(visit.id.toString()),
                              );
                            } else {
                              updatedList = bloc
                                  .state.deleteVisitorHistoryIdsList!
                                  .rebuild(
                                (builder) =>
                                    builder.remove(visit.id.toString()),
                              );
                            }
                            bloc.updateDeleteVisitorHistoryIdsList(updatedList);
                          },
                        ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VisitorManagementBlocSelector(
                      selector: (state) => state.deleteVisitorHistoryIdsList,
                      builder: (list) {
                        return SizedBox(
                          width: list == null
                              ? MediaQuery.of(context).size.width * 0.85
                              : MediaQuery.of(context).size.width * 0.7,
                          child: Row(
                            children: [
                              Text(
                                CommonFunctions.getDayNameFromDate(
                                  lastVisitDateTime: visit.createdAt,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: CommonFunctions
                                          .getThemeBasedWidgetColor(
                                        context,
                                      ),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                              ),
                              const Spacer(),
                              Text(
                                CommonFunctions.getTimeAmPm(
                                  lastVisitDateTime: visit.createdAt,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Text(
                      CommonFunctions.getMonthDate(
                        lastVisitDateTime: visit.createdAt,
                      ),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: const Color.fromRGBO(159, 159, 159, 1),
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // const Divider(),
        ],
      ),
    );
  }
}
