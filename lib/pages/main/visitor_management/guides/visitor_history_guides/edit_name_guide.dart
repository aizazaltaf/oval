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

class EditNameGuide extends StatelessWidget {
  const EditNameGuide({
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
                bottom: MediaQuery.of(innerContext).size.height * 0.54,
              ),
              child: TextButton(
                onPressed: () => bloc.updateCurrentGuideKey("history_list"),
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
                bottom: MediaQuery.of(innerContext).size.height * 0.54,
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
            SizedBox(width: 8.w),
            RotatedBox(
              quarterTurns: 2,
              child: SvgPicture.asset(
                DefaultImages.ARROW_UP,
                height: 70,
                width: 70,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            SizedBox(width: 5.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomGradientButton(
                  onSubmit: () {
                    bloc.updateCurrentGuideKey("history_unwanted");
                  },
                  label: innerContext.appLocalizations.general_ok,
                  forDialog: true,
                  customCircularRadius: 0,
                ),
                const SizedBox(height: 20),
                CommonFunctions.guideTitle(
                  innerContext.appLocalizations.history_edit_name_guide_title,
                ),
                CommonFunctions.guideDescription(
                  innerContext.appLocalizations.history_edit_name_guide_desc,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
