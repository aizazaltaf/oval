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

class StatisticsChipsGuide extends StatelessWidget {
  const StatisticsChipsGuide({
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
      children: [
        SizedBox(
          height: 32.h,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.22,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset(
                DefaultImages.ARROW_UP_LEFT,
                height: 60,
                width: 60,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              CustomGradientButton(
                onSubmit: () {
                  ShowCaseWidget.of(innerContext).dismiss(); // Skip logic
                  bloc.updateStatisticsGuideShow(true);
                  StartupBloc.of(innerContext).callUpdateGuide(
                    guideKey: Constants.statisticsGuideKey,
                  );
                },
                label: innerContext.appLocalizations.general_ok,
                forDialog: true,
                customCircularRadius: 0,
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.22,
          ),
          child: CommonFunctions.guideTitle(
            innerContext.appLocalizations.statistics_chips_guide_title,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.22,
          ),
          child: CommonFunctions.guideDescription(
            innerContext.appLocalizations.statistics_chips_guide_desc,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 5.w, top: 40.h),
              child: TextButton(
                onPressed: () {
                  bloc.updateCurrentGuideKey("calendar");
                },
                child: Text(
                  innerContext.appLocalizations.general_back,
                  style: Theme.of(innerContext).textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(right: 10.w, top: 40.h),
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
        ),
      ],
    );
  }
}
