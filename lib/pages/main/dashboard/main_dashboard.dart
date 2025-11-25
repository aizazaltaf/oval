import 'dart:async';
import 'dart:io';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/dashboard/components/bottomsheet.dart';
import 'package:admin/pages/main/dashboard/home_screen.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/more_dashboard/dashboard_more_page.dart';
import 'package:admin/pages/main/notifications/notification_service.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/visitor_management_page.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/bottom_navigation_bar/motion_tab_bar.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({
    super.key,
    this.fromOneTimeInitialize = false,
    this.isUpdate = false,
    this.showBottom = false,
  });

  final bool fromOneTimeInitialize;
  final bool isUpdate;
  final bool showBottom;
  static const routeName = "mainDashboard";

  // static Future<void> push(
  //   final BuildContext context, {
  //   final String? forOthersPush,
  // }) {
  //   if (forOthersPush == null) {
  //     ToastUtils.successToast(context.appLocalizations.doorbell_success);
  //   }
  //   return navigateToFirstAppScreen(
  //     context,
  //     builder: (final _) => const MainDashboard(),
  //   );
  // }

  // static Future<void> pushRemove(
  //   final BuildContext context, {
  //   final String? forOthersPush,
  //   final bool isUpdate = false,
  //   final bool showBottom = false,
  // }) {
  //   // Close all dialogs, sheets, snackBars, etc.
  //   Navigator.of(context, rootNavigator: true)
  //       .popUntil((route) => route.isFirst);
  //
  //   if (forOthersPush != null) {
  //     ToastUtils.successToast(context.appLocalizations.doorbell_success);
  //   }
  //   if (isUpdate) {
  //     Future.delayed(const Duration(milliseconds: 300), () {
  //       StartupBloc.of(context.mounted ? context : context).pageIndexChanged(1);
  //     });
  //   }
  //   if (showBottom) {
  //     Future.delayed(const Duration(milliseconds: 300), () {
  //       StartupBloc.of(context.mounted ? context : context).pageIndexChanged(0);
  //     });
  //   }
  //   return navigateToFirstAppScreen(
  //     context,
  //     builder: (final _) => MainDashboard(
  //       isUpdate: isUpdate,
  //       showBottom: showBottom,
  //     ),
  //   );
  // }

  // static Future<void> navigateToFirst(final BuildContext context) {
  //   return navigateToFirstAppScreen(
  //     context,
  //     builder: (final _) => const MainDashboard(),
  //   );
  // }

  static Future<void> pushRemove(
    final BuildContext context, {
    final String? forOthersPush,
    final bool isUpdate = false,
    final bool showBottom = false,
  }) {
    Navigator.of(context, rootNavigator: true)
        .popUntil((route) => route.isFirst);
    if (forOthersPush != null) {
      ToastUtils.successToast(context.appLocalizations.doorbell_success);
    }
    if (isUpdate) {
      Future.delayed(const Duration(milliseconds: 300), () {
        StartupBloc.of(context.mounted ? context : context).pageIndexChanged(1);
      });
    }
    if (showBottom) {
      Future.delayed(const Duration(milliseconds: 300), () {
        StartupBloc.of(context.mounted ? context : context).pageIndexChanged(0);
      });
    }
    return navigateToFirstAppScreen(
      context,
      builder: (final _) => MainDashboard(
        isUpdate: isUpdate,
        showBottom: showBottom,
      ),
    );
  }

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  StartupBloc? bloc;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.fromOneTimeInitialize) {
      initializeTts();
      StartupBloc.of(context).oneTimeInitialize(this);
      VoiceControlBloc.of(context.mounted ? context : context)
          .initSpeech(context.mounted ? context : context);
    }
    init();
    if (widget.showBottom) {
      showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        context: context.mounted ? context : context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        builder: (c) {
          StartupBloc.of(c).getUserDoorbells(
            id: singletonBloc.profileBloc.state?.selectedDoorBell?.locationId ==
                    null
                ? null
                : int.tryParse(
                    // singletonBloc
                    //     .profileBloc.state!.locationId!,
                    singletonBloc
                        .profileBloc.state!.selectedDoorBell!.locationId
                        .toString(),
                  ),
          );
          return DisplayLocationBottomSheet();
        },
      );
    }
  }

  Future initializeTts() async {
    await singletonBloc.textToSpeech.setLanguage("en-US"); // Set the language
    await singletonBloc.textToSpeech.setPitch(1); // Set the pitch
  }

  Future<void> init() async {
    bloc = StartupBloc.of(context);
    singletonBloc.iotBloc = IotBloc.of(context.mounted ? context : context);
    singletonBloc.voipBloc = VoipBloc.of(context.mounted ? context : context);

    if (bloc!.state.needDashboardCall && bloc!.state.isInternetConnected) {
      bloc?.updateDashboardApiCalling(true);
      await bloc!.callEverything();
      await IotBloc.of(context.mounted ? context : context).iotInitializer();
      unawaited(
        Future.delayed(const Duration(seconds: 3), () {
          bloc?.updateDashboardApiCalling(false);
        }),
      );
    }

    unawaited(notificationNavigation());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setSystemUIStyle();
    // final bloc = VoipBloc.of(context);
    // {
    //   bloc.streamingPeerConnection?.dispose();
    //   bloc.streamingPeerConnection = null;
    // }
  }

  void _setSystemUIStyle() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: isDarkMode
            ? Colors.transparent
            : Platform.isIOS
                ? Colors.black
                : Colors.transparent,
        statusBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
  }

  // Future<void> joinRoom() async {
  //   if (singletonBloc.profileBloc.state != null) {
  //     singletonBloc.socket?.emit("joinRoom", {
  //       // "room": singletonBloc.profileBloc.state!.locationId,
  //       "room": singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
  //           .toString(),
  //       "device_id": await CommonFunctions.getDeviceModel(),
  //     });
  //   } else {
  //     Future.delayed(const Duration(seconds: 2), () async {
  //       unawaited(joinRoom());
  //     });
  //   }
  // }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // final pip = Pip();
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      await bloc?.socketMethod();
      // await pip.stop();
    } else if (state == AppLifecycleState.paused) {
      // if (await pip.isAutoEnterSupported()) {
      //   await pip.start();
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodies = [
      const Center(
        child: HomeScreen(),
      ),
      Center(child: VisitorManagementPage(noInitState: widget.isUpdate)),
      const SizedBox(),
      const DashboardMorePage(),
    ];
    final bloc = StartupBloc.of(context);
    return PopScope(
      child: AppScaffold(
        body: StartupBlocSelector.indexedStackValue(
          builder: (value) {
            return bodies[value];
          },
        ),
        bottomNavigationBar: StartupBlocSelector(
          selector: (state) => state.userDeviceModel,
          builder: (userDevices) {
            return StartupBlocSelector.planFeaturesApi(
              builder: (api) {
                return MotionTabBar(
                  controller: bloc.state.motionTabBarController,
                  labels: [
                    context.appLocalizations.home_dashboard,
                    context.appLocalizations.visitor_log_dashboard,
                    context.appLocalizations.neighbourhood_dashboard,
                    context.appLocalizations.more_dashboard,
                  ],
                  disabled: userDevices == null || userDevices.isEmpty,
                  icons: [
                    Icons.home_filled,
                    MdiIcons.accountGroupOutline,
                    Icons.holiday_village_outlined,
                    MdiIcons.widgetsOutline,
                  ],
                  initialSelectedTab: 'Home',
                  tabIconColor: Theme.of(context).tabBarTheme.indicatorColor,
                  tabIconSize: 36,
                  tabIconSelectedSize: 36,
                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: Theme.of(context).tabBarTheme.indicatorColor,
                      ),
                  tabSelectedColor: Theme.of(context).primaryColorLight,
                  tabIconSelectedColor:
                      Theme.of(context).tabBarTheme.indicatorColor,
                  tabBarColor:
                      CommonFunctions.getThemePrimaryLightWhiteColor(context),
                  onTabItemSelected: (int value) async {
                    if (bloc.state.indexedStackValue != value) {
                      bloc.pageIndexChanged(value);
                    }

                    if (value == 1) {
                      final VisitorManagementBloc visitorBloc =
                          VisitorManagementBloc.of(context)..removeSearch();
                      if (!visitorBloc
                          .state.visitorManagementApi.isApiInProgress) {
                        if (visitorBloc.state.visitorManagementApi.data ==
                            null) {
                          await visitorBloc.initialCall();
                        } else if (visitorBloc
                            .state.visitorManagementApi.data!.data.isEmpty) {
                          await visitorBloc.initialCall();
                        } else if (visitorBloc.state.visitorNewNotification) {
                          await visitorBloc.initialCall(isRefresh: true);
                        }
                      }
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> notificationNavigation() async {
    // Check if the function has already been executed
    if (singletonBloc.isNotificationNavigationExecuted) {
      return;
    }

    final NotificationAppLaunchDetails? launchNotificationResponse =
        await NotificationService.notificationsPlugin
            .getNotificationAppLaunchDetails();

    if (launchNotificationResponse != null) {
      NotificationService.handleNotificationTap(
        launchNotificationResponse.notificationResponse,
      );
    }

    // Set the flag to true to prevent future executions
    singletonBloc.isNotificationNavigationExecuted = true;
  }
}

class CustomTickerProvider extends ChangeNotifier implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}
