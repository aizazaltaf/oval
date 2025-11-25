import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showcaseview/showcaseview.dart';

class UnwantedVisitorGuide extends StatelessWidget {
  const UnwantedVisitorGuide({
    super.key,
    required this.innerContext,
    required this.bloc,
  });
  final BuildContext innerContext;
  final VisitorManagementBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(
                left: 2,
                bottom: MediaQuery.of(innerContext).size.height * 0.48,
              ),
              child: TextButton(
                onPressed: () =>
                    bloc.updateCurrentGuideKey("history_edit_name"),
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
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(
                right: 30,
                bottom: MediaQuery.of(innerContext).size.height * 0.48,
              ),
              child: TextButton(
                onPressed: () {
                  ShowCaseWidget.of(innerContext).dismiss(); // Skip logic
                  bloc.updateHistoryGuideShow(true);
                  StartupBloc.of(innerContext).callUpdateGuide(
                    guideKey: Constants.visitorHistoryGuideKey,
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: 24.w),
            Transform.rotate(
              angle: -10, // Rotating 45 degrees
              child: SvgPicture.asset(
                DefaultImages.ARROW_UP,
                height: 70,
                width: 70,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomGradientButton(
                  onSubmit: () {
                    bloc.updateCurrentGuideKey("history_neighbourhood");
                  },
                  label: innerContext.appLocalizations.general_ok,
                  forDialog: true,
                  customCircularRadius: 0,
                ),
                const SizedBox(height: 20),
                CommonFunctions.guideTitle(
                  innerContext.appLocalizations.history_unwanted_title,
                ),
                CommonFunctions.guideDescription(
                  innerContext.appLocalizations.history_unwanted_desc,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
