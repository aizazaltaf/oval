import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/notifications/guides/audio_call_guide.dart';
import 'package:admin/pages/main/notifications/guides/chat_guide.dart';
import 'package:admin/pages/main/notifications/guides/video_call_guide.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';

class DummyVisitorNotification extends StatelessWidget {
  const DummyVisitorNotification({
    super.key,
    required this.innerContext,
    required this.bloc,
  });
  final BuildContext innerContext;
  final NotificationBloc bloc;

  @override
  Widget build(BuildContext context) {
    final DateTime localDate =
        DateTime.parse(DateTime.now().toString()).toLocal();

    final String formattedDate = DateFormat('MMM dd').format(localDate);
    final String formattedTime = DateFormat('h:mm a').format(localDate);
    final String keyDate = DateFormat('MMM dd, yyyy').format(localDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            keyDate,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 10,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Row(
              children: [
                Expanded(
                  child: SvgPicture.asset(
                    DefaultVectors.VISITOR_NOTIF,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Visitor Alert!",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const Spacer(),
                          Text(
                            formattedDate,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: Colors.grey,
                                  fontSize: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .fontSize! -
                                      2,
                                ),
                          ),
                          Text(
                            " • ",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: Colors.grey,
                                  fontSize: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .fontSize! -
                                      2,
                                ),
                          ),
                          Text(
                            formattedTime,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: Colors.grey,
                                  fontSize: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .fontSize! -
                                      2,
                                ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Someone is at the door (Front Door) whose face is unclear.",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .fontSize! -
                                        2,
                                  ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(Icons.keyboard_arrow_up_outlined),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.h),
              image: const DecorationImage(
                image: AssetImage(
                  DefaultImages.FRONT_CAMERA_THUMBNAIL,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Showcase.withWidget(
                key: bloc.audioCallGuideKey,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                targetPadding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 5,
                ),
                tooltipPosition: TooltipPosition.bottom,
                targetBorderRadius: BorderRadius.circular(15),
                container:
                    AudioCallGuide(innerContext: innerContext, bloc: bloc),
                child: buttonText(context, context.appLocalizations.audio_call),
              ),
              Showcase.withWidget(
                key: bloc.videoCallGuideKey,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                targetPadding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 5,
                ),
                tooltipPosition: TooltipPosition.bottom,
                targetBorderRadius: BorderRadius.circular(15),
                container:
                    VideoCallGuide(innerContext: innerContext, bloc: bloc),
                child: buttonText(context, context.appLocalizations.video_call),
              ),
              Showcase.withWidget(
                key: bloc.chatGuideKey,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                targetPadding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 5,
                ),
                tooltipPosition: TooltipPosition.bottom,
                targetBorderRadius: BorderRadius.circular(15),
                container: ChatGuide(innerContext: innerContext, bloc: bloc),
                child: buttonText(context, context.appLocalizations.start_chat),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buttonText(BuildContext context, String buttonTitle) {
    return Text(
      buttonTitle,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: AppColors.blueLinearGradientColor,
          ),
    );
  }
}
