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

class HistoryListviewGuide extends StatelessWidget {
  const HistoryListviewGuide({
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
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomGradientButton(
                    onSubmit: () {
                      bloc.updateCurrentGuideKey("history_edit_name");
                    },
                    label: context.appLocalizations.general_ok,
                    forDialog: true,
                    customCircularRadius: 0,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  SvgPicture.asset(
                    DefaultImages.ARROW_UP,
                    height: 50,
                    width: 50,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CommonFunctions.guideTitle(
                innerContext.appLocalizations.history_list_guide_title,
              ),
              CommonFunctions.guideDescription(
                innerContext.appLocalizations.history_list_guide_desc,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 5, top: 48.h),
              child: TextButton(
                onPressed: () => bloc.updateCurrentGuideKey("chart"),
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
              padding: EdgeInsets.only(right: 30, top: 48.h),
              child: TextButton(
                onPressed: () {
                  ShowCaseWidget.of(innerContext).dismiss(); // Skip logic
                  bloc.updateHistoryGuideShow(true);
                  StartupBloc.of(context).callUpdateGuide(
                    guideKey: Constants.visitorHistoryGuideKey,
                  );
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
        ),
      ],
    );
  }
}
