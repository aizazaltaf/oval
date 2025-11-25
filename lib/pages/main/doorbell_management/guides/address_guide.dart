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

class AddressGuide extends StatelessWidget {
  const AddressGuide({
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(left: 10, bottom: 30.h),
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
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(bottom: 30.h),
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
        Container(
          margin: const EdgeInsets.only(left: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomGradientButton(
                onSubmit: () {
                  ShowCaseWidget.of(innerContext).dismiss(); // Skip logic
                  bloc.updateMapGuideShow(true);
                  StartupBloc.of(innerContext).callUpdateGuide(
                    guideKey: Constants.mapsGuideKey,
                  );
                },
                label: innerContext.appLocalizations.general_ok,
                forDialog: true,
                customCircularRadius: 0,
              ),
              const SizedBox(height: 20),
              CommonFunctions.guideTitle(
                innerContext.appLocalizations.map_address_guide_title,
              ),
              Row(
                children: [
                  CommonFunctions.guideDescription(
                    innerContext.appLocalizations.map_address_guide_desc,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.07),
                  SvgPicture.asset(
                    DefaultImages.ARROW_DOWN_RIGHT,
                    height: 70,
                    width: 70,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ],
              ),
            ],
          ),
        ),
        // SizedBox(height: MediaQuery.of(context).size.width * 0.1),
      ],
    );
  }
}
