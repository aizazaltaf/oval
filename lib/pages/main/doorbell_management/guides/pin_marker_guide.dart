import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/doorbell_management/bloc/doorbell_management_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';

class PinMarkerGuide extends StatelessWidget {
  const PinMarkerGuide({
    super.key,
    required this.innerContext,
    required this.bloc,
  });
  final BuildContext innerContext;
  final DoorbellManagementBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 45.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomGradientButton(
                    onSubmit: () => ShowCaseWidget.of(innerContext).next(),
                    label: innerContext.appLocalizations.general_ok,
                    forDialog: true,
                    customCircularRadius: 0,
                  ),
                  const SizedBox(width: 10),
                  SvgPicture.asset(
                    DefaultImages.ARROW_UP,
                    height: 70,
                    width: 70,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CommonFunctions.guideTitle(
                innerContext.appLocalizations.pin_marker_guide_title,
              ),
              const SizedBox(height: 10),
              CommonFunctions.guideDescription(
                innerContext.appLocalizations.pin_marker_guide_desc,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 10, top: 25.h),
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
              padding: EdgeInsets.only(top: 25.h),
              child: TextButton(
                onPressed: () {
                  ShowCaseWidget.of(innerContext).dismiss(); // Skip logic
                  bloc.updateMapGuideShow(true);
                  StartupBloc.of(innerContext).callUpdateGuide(
                    guideKey: Constants.mapsGuideKey,
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
