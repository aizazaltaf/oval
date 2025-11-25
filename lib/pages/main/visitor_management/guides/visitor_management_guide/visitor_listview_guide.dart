import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:showcaseview/showcaseview.dart';

class VisitorListviewGuide extends StatelessWidget {
  const VisitorListviewGuide({
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                Expanded(
                  child: CustomGradientButton(
                    onSubmit: () {
                      ShowCaseWidget.of(innerContext).dismiss();
                      bloc.updateVisitorGuideShow(true);
                      StartupBloc.of(context)
                          .callUpdateGuide(guideKey: Constants.visitorGuideKey);
                    },
                    label: context.appLocalizations.general_ok,
                    forDialog: true,
                    customCircularRadius: 0,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                Image.asset(
                  DefaultImages.SWIPE_LEFT,
                  height: 50,
                  width: 50,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
              ),
              child: CommonFunctions.guideTitle(
                innerContext.appLocalizations.visitor_list_guide_title,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
              ),
              child: CommonFunctions.guideDescription(
                innerContext.appLocalizations.visitor_list_guide_desc,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 2.w, top: 38.h),
              child: TextButton(
                onPressed: () => ShowCaseWidget.of(innerContext).previous(),
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
              padding: EdgeInsets.only(right: 10.w, top: 38.h),
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
        ),
      ],
    );
  }
}
