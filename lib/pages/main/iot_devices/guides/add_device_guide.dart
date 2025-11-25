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

class AddDeviceGuide extends StatelessWidget {
  const AddDeviceGuide({
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
          padding: EdgeInsets.only(bottom: 24.h),
          child: Row(
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
              TextButton(
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
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomGradientButton(
                    onSubmit: () => ShowCaseWidget.of(innerContext).next(),
                    label: innerContext.appLocalizations.general_ok,
                    forDialog: true,
                    customCircularRadius: 0,
                  ),
                  const SizedBox(height: 15),
                  CommonFunctions.guideTitle(
                    innerContext.appLocalizations.add_device_guide_title,
                  ),
                  const SizedBox(height: 5),
                  CommonFunctions.guideDescription(
                    innerContext.appLocalizations.add_device_guide_desc,
                  ),
                ],
              ),
              SizedBox(width: 3.w),
              SvgPicture.asset(
                DefaultImages.ARROW_DOWN_RIGHT,
                height: 60,
                width: 60,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
