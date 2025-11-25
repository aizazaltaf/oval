import 'dart:math';

import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showcaseview/showcaseview.dart';

class ChatGuide extends StatelessWidget {
  const ChatGuide({
    super.key,
    required this.innerContext,
    required this.bloc,
  });
  final BuildContext innerContext;
  final NotificationBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 420),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomGradientButton(
                      onSubmit: () {
                        ShowCaseWidget.of(innerContext).dismiss(); // Skip logic
                        bloc.updateNotificationGuideShow(true);
                        StartupBloc.of(innerContext).callUpdateGuide(
                          guideKey: Constants.notificationGuideKey,
                        );
                      },
                      label: innerContext.appLocalizations.general_ok,
                      forDialog: true,
                      customCircularRadius: 0,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(pi),
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
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(innerContext).size.width * 0.6,
                child: CommonFunctions.guideTitle(
                  innerContext
                      .appLocalizations.visitor_notification_guide_title,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(innerContext).size.width * 0.6,
                child: CommonFunctions.guideDescription(
                  innerContext.appLocalizations.chat_guide_desc,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.18),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => bloc.updateCurrentGuideKey("video"),
                  child: Text(
                    innerContext.appLocalizations.general_back,
                    style:
                        Theme.of(innerContext).textTheme.bodyMedium?.copyWith(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ShowCaseWidget.of(innerContext).dismiss(); // Skip logic
                    bloc.updateNotificationGuideShow(true);
                    StartupBloc.of(innerContext).callUpdateGuide(
                      guideKey: Constants.notificationGuideKey,
                    );
                  },
                  child: Text(
                    innerContext.appLocalizations.general_skip,
                    style:
                        Theme.of(innerContext).textTheme.bodyMedium?.copyWith(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
