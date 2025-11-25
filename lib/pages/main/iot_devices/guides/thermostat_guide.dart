import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showcaseview/showcaseview.dart';

class ThermostatGuide extends StatelessWidget {
  const ThermostatGuide({
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: SvgPicture.asset(
                DefaultImages.ARROW_UP_LEFT,
                height: 60,
                width: 60,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 35,
                ),
                CustomGradientButton(
                  onSubmit: () => ShowCaseWidget.of(innerContext).next(),
                  label: innerContext.appLocalizations.general_ok,
                  forDialog: true,
                  customCircularRadius: 0,
                ),
                const SizedBox(height: 15),
                CommonFunctions.guideTitle(
                  innerContext.appLocalizations.thermostat_guide_title,
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 60.w,
                  child: CommonFunctions.guideDescription(
                    innerContext.appLocalizations.thermostat_guide_desc,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 36.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
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
            Padding(
              padding: const EdgeInsets.only(right: 20),
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
          ],
        ),
      ],
    );
  }
}
