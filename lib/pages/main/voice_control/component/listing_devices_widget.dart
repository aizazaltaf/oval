import 'package:admin/bloc/profile_bloc.dart';
import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/main/voice_control/component/chat_widget.dart';
import 'package:admin/pages/main/voice_control/component/initial_command_widget.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/circular_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ListingDevicesWidget extends StatelessWidget {
  const ListingDevicesWidget({
    super.key,
    required this.bloc,
    required this.ctx,
  });
  final VoiceControlBloc bloc;
  final BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    // final double vh = MediaQuery.of(context).size.height;
    return VoiceControlBlocSelector.chatUpdate(
      builder: (chatUpdate) {
        return VoiceControlBlocSelector.chatData(
          builder: (chatData) {
            return Column(
              children: [
                if (chatData.isEmpty)
                  Expanded(
                    child: bloc.state.listingDevices == null
                        // ? Center(
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(vertical: 40),
                        //       child: Image.asset(
                        //         DefaultAnimations.VOICE_CONTROL_GIF,
                        //         fit: BoxFit.fill,
                        //       ),
                        //     ),
                        //   )
                        ? Column(
                            children: [
                              const SizedBox(height: 40),
                              ProfileBlocSelector.name(
                                builder: (name) {
                                  return Text(
                                    "Hello, ${singletonBloc.profileBloc.state!.name}!",
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontSize: 20,
                                        ),
                                  );
                                },
                              ),
                              Text(
                                "How can I help you today?",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                              SizedBox(
                                height: 260,
                                width: 90.w,
                                child: Image.asset(
                                  DefaultAnimations.VOICE_CONTROL_GIF,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              VoiceControlBlocSelector.isTyping(
                                builder: (isTyping) {
                                  if (isTyping) {
                                    return const SizedBox.shrink();
                                  }
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InitialCommandWidget(
                                            text: Constants
                                                .initialVoiceControlCommands[0],
                                            bloc: bloc,
                                            ctx: ctx,
                                          ),
                                          const SizedBox(width: 10),
                                          InitialCommandWidget(
                                            text: Constants
                                                .initialVoiceControlCommands[1],
                                            bloc: bloc,
                                            ctx: ctx,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      InitialCommandWidget(
                                        text: Constants
                                            .initialVoiceControlCommands[2],
                                        bloc: bloc,
                                        ctx: ctx,
                                      ),
                                      const SizedBox(height: 10),
                                      InitialCommandWidget(
                                        text: Constants
                                            .initialVoiceControlCommands[3],
                                        bloc: bloc,
                                        ctx: ctx,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  )
                else
                  const SizedBox.shrink(),
                // if (chatData.isEmpty)
                //   SizedBox(height: 0.06 * vh)
                // else
                //   const SizedBox.shrink(),
                if (chatData.isEmpty)
                  const SizedBox.shrink()
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: VoiceControlBlocSelector.listingDevices(
                        builder: (listingDevices) {
                          return ListView.separated(
                            controller: bloc.scrollController,
                            itemBuilder: (context, index) => chatData[index]
                                        .senderImage !=
                                    null
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 80),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: ChatWidget(index: index),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: CircularProfileImage(
                                            size: 6.h,
                                            profileImageUrl: singletonBloc
                                                .profileBloc.state?.image,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : chatData[index].text ==
                                        context.appLocalizations.server_issue
                                    ? Container(
                                        padding: const EdgeInsets.all(10),
                                        margin: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.error_outline,
                                              color: AppColors.red,
                                            ),
                                            Expanded(
                                              child: Text(
                                                chatData[index].text!,
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      color: AppColors.red,
                                                      fontSize: 13,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 80),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                right: 8,
                                              ),
                                              child: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  radius: 50 / 2,
                                                  backgroundImage: AssetImage(
                                                    DefaultImages.EYE,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: ChatWidget(
                                                index: index,
                                                isSender: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10,
                            ),
                            itemCount: chatData.length,
                            shrinkWrap: true,
                          );
                        },
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
