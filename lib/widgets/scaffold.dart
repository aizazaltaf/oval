import 'dart:math';

import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/main/voice_control/component/gradient_loader.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.appTitle,
    this.leading,
    this.onBackPressed,
    this.floatingActionButton,
    this.appBarAction,
    this.bottomNavigationBar,
    this.showDrawer = false,
    this.showBackIcon = true,
    this.decorated = false,
    this.centerTitle = true,
    this.needShowNoInternetBar = true,
  });

  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget? leading;
  final PreferredSizeWidget? appBar;
  final bool showDrawer;
  final Widget? floatingActionButton;
  final VoidCallback? onBackPressed;
  final bool needShowNoInternetBar;
  final bool showBackIcon;
  final List<Widget>? appBarAction;
  final String? appTitle;
  final bool decorated;
  final bool centerTitle;

  @override
  Widget build(final BuildContext context) {
    return StartupBlocSelector(
      selector: (state) => state.isInternetConnected,
      builder: (isInternetConnected) {
        return decorated
            ? DecoratedBox(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(DefaultVectors.ROOM_BACKGROUND),
                  ),
                ),
                child: SafeArea(
                  // bottom: false,
                  child: Scaffold(
                    extendBodyBehindAppBar: true,
                    bottomNavigationBar: bottomNavigationBar,
                    floatingActionButton: floatingActionButton,
                    appBar: appBar ??
                        (appTitle == null
                            ? isInternetConnected
                                ? null
                                : AppBar(
                                    backgroundColor: Colors.transparent,
                                    bottom: CommonFunctions.noInternetBar(
                                      context,
                                      needShowNoInternetBar:
                                          needShowNoInternetBar,
                                    ),
                                  )
                            : AppBar(
                                leading: leading ??
                                    (showBackIcon
                                        ? GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: onBackPressed ??
                                                () async {
                                                  Navigator.pop(context);
                                                },
                                            child: Icon(
                                              Icons.keyboard_arrow_left,
                                              color: CommonFunctions
                                                  .getThemeBasedWidgetColor(
                                                context,
                                              ),
                                              size: 30,
                                            ),
                                          )
                                        : const SizedBox.shrink()),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                scrolledUnderElevation: 0,
                                title: Text(
                                  appTitle!,
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                centerTitle: centerTitle,
                                actions: appBarAction,
                              )),
                    backgroundColor: Colors.transparent,
                    body: SafeArea(
                      maintainBottomViewPadding: true,
                      child: VoiceControlBlocSelector.isListening(
                        builder: (isListening) {
                          return VoiceControlBlocSelector.isVoiceRecording(
                            builder: (isVoiceRecording) {
                              return Stack(
                                children: [
                                  body!,
                                  if (isListening && isVoiceRecording) ...[
                                    GestureDetector(
                                      onTap: () async {
                                        VoiceControlBloc.of(context)
                                          ..updateIsVoiceRecording(
                                            false,
                                          )
                                          ..updateIsLoading(
                                            false,
                                          )
                                          ..updateIsListening(
                                            false,
                                          );
                                      },
                                      child: Transform.rotate(
                                        angle: pi,
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: ClipOval(
                                            child: WaveWidget(
                                              config: CustomConfig(
                                                gradients: AppColors
                                                    .scaffoldWaveWidgetColor,
                                                durations: [3500, 1940],
                                                heightPercentages: [0.2, 0.25],
                                              ),
                                              size: const Size(70, 70),
                                              waveAmplitude: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        VoiceControlBloc.of(context)
                                          ..updateIsVoiceRecording(
                                            false,
                                          )
                                          ..updateIsLoading(
                                            false,
                                          )
                                          ..updateIsListening(
                                            false,
                                          );
                                      },
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: ClipOval(
                                          child: WaveWidget(
                                            config: CustomConfig(
                                              gradients: AppColors
                                                  .reversedScaffoldWaveWidgetColor,
                                              durations: [3500, 1940],
                                              heightPercentages: [0.2, 0.25],
                                            ),
                                            size: const Size(70, 70),
                                            waveAmplitude: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ] else if (isListening &&
                                      !isVoiceRecording) ...[
                                    const Align(
                                      alignment: Alignment.bottomCenter,
                                      child: GradientLoader(),
                                    ),
                                  ],
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              )
            : ColoredBox(
                color: Theme.of(context).colorScheme.onPrimary,
                child: SafeArea(
                  // bottom: false,
                  child: Scaffold(
                    extendBodyBehindAppBar: true,
                    bottomNavigationBar: bottomNavigationBar,
                    floatingActionButton: floatingActionButton,
                    appBar: appBar ??
                        (appTitle == null
                            ? isInternetConnected
                                ? null
                                : AppBar(
                                    backgroundColor: Colors.transparent,
                                    bottom: CommonFunctions.noInternetBar(
                                      context,
                                      needShowNoInternetBar:
                                          needShowNoInternetBar,
                                    ),
                                  )
                            : AppBar(
                                leading: leading ??
                                    (showBackIcon
                                        ? GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: onBackPressed ??
                                                () async {
                                                  Navigator.pop(context);
                                                },
                                            child: Icon(
                                              Icons.keyboard_arrow_left,
                                              color: CommonFunctions
                                                  .getThemeBasedWidgetColor(
                                                context,
                                              ),
                                              size: 30,
                                            ),
                                          )
                                        : const SizedBox.shrink()),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                scrolledUnderElevation: 0,
                                title: Text(
                                  appTitle!,
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                bottom: CommonFunctions.noInternetBar(
                                  context,
                                  needShowNoInternetBar: needShowNoInternetBar,
                                ),
                                centerTitle: centerTitle,
                                actions: appBarAction,
                              )),
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    body: ColoredBox(
                      color: Colors.transparent,
                      child: SafeArea(
                        maintainBottomViewPadding: true,
                        child: VoiceControlBlocSelector.isListening(
                          builder: (isListening) {
                            return VoiceControlBlocSelector.isVoiceRecording(
                              builder: (isVoiceRecording) {
                                return Stack(
                                  children: [
                                    body!,
                                    if (isListening && isVoiceRecording) ...[
                                      GestureDetector(
                                        onTap: () async {
                                          VoiceControlBloc.of(context)
                                            ..updateIsVoiceRecording(
                                              false,
                                            )
                                            ..updateIsLoading(
                                              false,
                                            )
                                            ..updateIsListening(
                                              false,
                                            );
                                        },
                                        child: Transform.rotate(
                                          angle: pi,
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: ClipOval(
                                              child: WaveWidget(
                                                config: CustomConfig(
                                                  gradients: AppColors
                                                      .scaffoldWaveWidgetColor,
                                                  durations: [3500, 1940],
                                                  heightPercentages: [
                                                    0.2,
                                                    0.25,
                                                  ],
                                                ),
                                                size: const Size(70, 70),
                                                waveAmplitude: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          VoiceControlBloc.of(context)
                                            ..updateIsVoiceRecording(
                                              false,
                                            )
                                            ..updateIsLoading(
                                              false,
                                            )
                                            ..updateIsListening(
                                              false,
                                            );
                                        },
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: ClipOval(
                                            child: WaveWidget(
                                              config: CustomConfig(
                                                gradients: AppColors
                                                    .reversedScaffoldWaveWidgetColor,
                                                durations: [3500, 1940],
                                                heightPercentages: [0.2, 0.25],
                                              ),
                                              size: const Size(70, 70),
                                              waveAmplitude: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ] else if (isListening &&
                                        !isVoiceRecording) ...[
                                      const Align(
                                        alignment: Alignment.bottomCenter,
                                        child: GradientLoader(),
                                      ),
                                    ],
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.appTitle,
    this.leading,
    this.onBackPressed,
    this.floatingActionButton,
    this.appBarAction,
    this.bottomNavigationBar,
    this.showDrawer = false,
    this.showBackIcon = true,
    this.centerTitle = true,
  });

  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget? leading;
  final PreferredSizeWidget? appBar;
  final bool showDrawer;
  final Widget? floatingActionButton;
  final VoidCallback? onBackPressed;
  final bool showBackIcon;
  final List<Widget>? appBarAction;
  final String? appTitle;
  final bool centerTitle;

  @override
  Widget build(final BuildContext context) {
    return StartupBlocSelector(
      selector: (state) => state.isInternetConnected,
      builder: (isInternetConnected) {
        return ColoredBox(
          color: Theme.of(context).colorScheme.onPrimary,
          child: SafeArea(
            // bottom: true,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              bottomNavigationBar: bottomNavigationBar,
              floatingActionButton: floatingActionButton,
              appBar: appBar ??
                  (appTitle == null
                      ? isInternetConnected
                          ? null
                          : AppBar(
                              backgroundColor: Colors.transparent,
                              bottom: CommonFunctions.noInternetBar(context),
                            )
                      : AppBar(
                          leading: leading ??
                              (showBackIcon
                                  ? GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: onBackPressed ??
                                          () async {
                                            Navigator.pop(context);
                                          },
                                      child: Icon(
                                        Icons.keyboard_arrow_left,
                                        color: CommonFunctions
                                            .getThemeBasedWidgetColor(context),
                                        size: 30,
                                      ),
                                    )
                                  : const SizedBox.shrink()),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          scrolledUnderElevation: 0,
                          bottom: CommonFunctions.noInternetBar(context),
                          title: Text(
                            appTitle!,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          centerTitle: centerTitle,
                          actions: appBarAction,
                        )),
              backgroundColor: Colors.transparent,
              body: ColoredBox(
                color: Colors.transparent,
                child: SafeArea(maintainBottomViewPadding: true, child: body!),
              ),
            ),
          ),
        );
      },
    );
  }
}

// class DialogBox extends StatelessWidget {
//   const DialogBox({
//     super.key,
//     this.bloc,
//     this.title,
//     this.onTap,
//   });
//   final String? title;
//   final StartupBloc? bloc;
//   final GestureTapCallback? onTap;
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20.0),
//       ),
//       backgroundColor: const Color(0xff1D242B),
//       child: Container(
//         padding: EdgeInsets.all(16.0),
//         height: 150.0,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(title ?? context.appLocalizations.logout_message,
//                 style: Theme.of(context).textTheme.bodyLarge),
//             SizedBox(height: 24.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(behavior: HitTestBehavior.opaque,
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                       height: 5.h,
//                       width: 10.h,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.h),
//                         gradient: LinearGradient(
//                             begin: const Alignment(-0.24, 0),
//                             end: const Alignment(1.27, 1),
//                             colors: [
//                               LightCodeColors.purpleA400,
//                               const Color(0XFF0077C0)
//                             ]),
//                       ),
//                       child: Center(
//                         child: Text(context.appLocalizations.no,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleSmall!
//                                 .copyWith(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w700,
//                                 )),
//                       )),
//                 ),
//                 SizedBox(width: 8.0),
//                 GestureDetector(behavior: HitTestBehavior.opaque,
//                   onTap: onTap ??
//                       () {
//                         Navigator.pop(context);
//                         bloc!.updateIndex(0);
//                         singletonBloc.profileBloc.updateProfile(null);
//                       },
//                   child: Container(
//                       height: 5.h,
//                       width: 10.h,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.h),
//                         gradient: LinearGradient(
//                             begin: const Alignment(-0.24, 0),
//                             end: const Alignment(1.27, 1),
//                             colors: [
//                               LightCodeColors.purpleA400,
//                               const Color(0XFF0077C0)
//                             ]),
//                       ),
//                       child: Center(
//                         child: Text(context.appLocalizations.yes,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleSmall!
//                                 .copyWith(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w700,
//                                 )),
//                       )),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
