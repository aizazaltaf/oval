import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/statistics/bloc/statistics_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';

class StatisticsDropdownGuide extends StatelessWidget {
  const StatisticsDropdownGuide({
    super.key,
    required this.innerContext,
    required this.bloc,
  });
  final BuildContext innerContext;
  final StatisticsBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 23.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomGradientButton(
              onSubmit: () => bloc.updateCurrentGuideKey("calendar"),
              label: innerContext.appLocalizations.general_ok,
              forDialog: true,
              customCircularRadius: 0,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            SvgPicture.asset(
              DefaultImages.ARROW_UP,
              height: 60,
              width: 60,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 15),
        CommonFunctions.guideTitle(
          innerContext.appLocalizations.statistics_dropdown_guide_title,
        ),
        CommonFunctions.guideDescription(
          innerContext.appLocalizations.statistics_dropdown_guide_desc,
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(right: 10.w, top: 50.h),
          child: TextButton(
            onPressed: () {
              ShowCaseWidget.of(innerContext).dismiss(); // Skip logic
              bloc.updateStatisticsGuideShow(true);
              StartupBloc.of(innerContext).callUpdateGuide(
                guideKey: Constants.statisticsGuideKey,
              );
            },
            child: Text(
              innerContext.appLocalizations.general_skip,
              style: Theme.of(innerContext).textTheme.bodyMedium?.copyWith(
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
