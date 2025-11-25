import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';

class FilterVisitorGuide extends StatelessWidget {
  const FilterVisitorGuide({
    super.key,
    required this.innerContext,
    required this.bloc,
  });
  final BuildContext innerContext;
  final VisitorManagementBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 32.w),
          child: Row(
            children: [
              CustomGradientButton(
                onSubmit: () {
                  bloc.updateVisitorGuideShow(true);
                  ShowCaseWidget.of(innerContext).next();
                },
                label: context.appLocalizations.general_ok,
                forDialog: true,
                customCircularRadius: 0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width > 500 ? 21.w : 14.w,
              ),
              SvgPicture.asset(
                DefaultImages.ARROW_UP,
                height: 70,
                width: 70,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(left: 32.w),
          child: CommonFunctions.guideTitle(
            innerContext.appLocalizations.visitor_filter_guide_title,
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.only(left: 32.w),
          child: CommonFunctions.guideDescription(
            innerContext.appLocalizations.visitor_filter_guide_desc,
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(right: 10, top: 55.h),
          child: TextButton(
            onPressed: () {
              ShowCaseWidget.of(innerContext).dismiss(); // Skip logic
              bloc.updateVisitorGuideShow(true);
              StartupBloc.of(context)
                  .callUpdateGuide(guideKey: Constants.visitorGuideKey);
            },
            child: Text(
              context.appLocalizations.general_skip,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
