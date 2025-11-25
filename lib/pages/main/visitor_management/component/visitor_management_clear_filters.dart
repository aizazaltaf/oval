import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class VisitorManagementClearFilters extends StatelessWidget {
  const VisitorManagementClearFilters({
    super.key,
    required this.bloc,
    required this.onTap,
  });
  final VisitorManagementBloc bloc;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            height: 1.h,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              context.appLocalizations.clear_filter,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: CommonFunctions.getThemeBasedWidgetColor(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
