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

class AddRoomGuide extends StatelessWidget {
  const AddRoomGuide({
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
          padding: EdgeInsets.only(
            bottom: 10.h,
            right: 20,
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                ShowCaseWidget.of(innerContext).dismiss(); // Skip logic
                bloc.updateManageDevicesGuideShow(true);
                StartupBloc.of(innerContext).callUpdateGuide(
                  guideKey: Constants.manageDevicesGuideKey,
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SvgPicture.asset(
              DefaultImages.ARROW_DOWN_LEFT,
              height: 60,
              width: 60,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomGradientButton(
                  onSubmit: () {
                    bloc.updateManageDevicesGuideShow(true);
                    ShowCaseWidget.of(innerContext).next();
                  },
                  label: innerContext.appLocalizations.general_ok,
                  forDialog: true,
                  customCircularRadius: 0,
                ),
                const SizedBox(height: 15),
                CommonFunctions.guideTitle(
                  innerContext.appLocalizations.add_room_guide_title,
                ),
                const SizedBox(height: 5),
                CommonFunctions.guideDescription(
                  innerContext.appLocalizations.add_room_guide_desc,
                ),
                const SizedBox(height: 15),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
