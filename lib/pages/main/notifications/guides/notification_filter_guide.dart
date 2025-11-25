import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';

class NotificationFilterGuide extends StatelessWidget {
  const NotificationFilterGuide({
    super.key,
    required this.innerContext,
    required this.bloc,
  });
  final BuildContext innerContext;
  final NotificationBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 5.w),
          child: TextButton(
            onPressed: () {
              ShowCaseWidget.of(innerContext).dismiss(); // Skip logic
              bloc.updateNotificationGuideShow(true);
              StartupBloc.of(innerContext).callUpdateGuide(
                guideKey: Constants.notificationGuideKey,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomGradientButton(
                      onSubmit: () => bloc.updateCurrentGuideKey("audio"),
                      label: innerContext.appLocalizations.general_ok,
                      forDialog: true,
                      customCircularRadius: 0,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.08),
                    SvgPicture.asset(
                      DefaultImages.ARROW_UP,
                      height: 80,
                      width: 80,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                CommonFunctions.guideTitle(
                  innerContext.appLocalizations.notification_filter_guide_title,
                ),
                const SizedBox(height: 15),
                CommonFunctions.guideDescription(
                  innerContext.appLocalizations.notification_filter_guide_desc,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
