import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';

class ThreeRoomDotGuide extends StatelessWidget {
  const ThreeRoomDotGuide({
    super.key,
    required this.innerContext,
    required this.bloc,
  });
  final BuildContext innerContext;
  final IotBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20, top: 100),
          child: Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                ShowCaseWidget.of(innerContext).dismiss(); // Skip logic
                bloc.updateThreeDotMenuGuideShow(true);
                StartupBloc.of(innerContext).callUpdateGuide(
                  guideKey: Constants.threeDotMenuGuideKey,
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
        ),
        const SizedBox(
          height: 100,
        ),
        Padding(
          padding: EdgeInsets.only(left: 48.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomGradientButton(
                    onSubmit: () {
                      ShowCaseWidget.of(innerContext).dismiss(); // Skip logic
                      bloc.updateThreeDotMenuGuideShow(true);
                      StartupBloc.of(innerContext).callUpdateGuide(
                        guideKey: Constants.threeDotMenuGuideKey,
                      );
                    },
                    label: innerContext.appLocalizations.general_ok,
                    forDialog: true,
                    customCircularRadius: 0,
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  SvgPicture.asset(
                    DefaultImages.ARROW_UP,
                    height: 60,
                    width: 60,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              CommonFunctions.guideTitle(
                innerContext.appLocalizations.three_dot_menu_guide_title,
              ),
              const SizedBox(height: 5),
              CommonFunctions.guideDescription(
                innerContext.appLocalizations.three_dot_menu_guide_desc,
              ),
              const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: context.appLocalizations.edit_guide_title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: context.appLocalizations.edit_guide_desc),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: context.appLocalizations.move_guide_title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: context.appLocalizations.move_guide_desc),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: context.appLocalizations.delete_guide_title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: context.appLocalizations.delete_guide_desc),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
