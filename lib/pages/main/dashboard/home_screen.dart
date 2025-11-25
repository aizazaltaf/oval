import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/pages/main/dashboard/components/app_bar_widget.dart';
import 'package:admin/pages/main/dashboard/components/no_internet_doorbell_dashboard.dart';
import 'package:admin/pages/main/dashboard/feature_list.dart';
import 'package:admin/pages/main/dashboard/monitor_cameras.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/iot_device.dart';
import 'package:admin/pages/main/notifications/bloc/notification_bloc.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // static Future<void> getSectionsList() async {
  //   final String? sections =
  //       singletonBloc.getBox.read(Constants.pinnedSections);
  //   if (sections != null && sections.isNotEmpty) {
  //     final BuiltList<String> sectionsList = sections
  //         .split(',') // Split by comma and space
  //         .map((item) => item) // Remove quotes
  //         .toBuiltList();
  //     singletonBloc.profileBloc.updateSectionList(sectionsList);
  //   }
  // }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final startupBloc = StartupBloc.of(context);
    //   if (startupBloc.state.dashboardApiCalling &&
    //       !CustomOverlayLoader.isShowing) {
    //     Constants.showLoader();
    //   } else if (!startupBloc.state.dashboardApiCalling) {
    //     Constants.dismissLoader();
    //   }
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // StartupBloc.of(context).updateMonitorCamerasCarouselIndex(0);
  }

  Future<void> dashboardRefresh(BuildContext context) async {
    final notificationBloc = NotificationBloc.of(context);
    final visitorBloc = VisitorManagementBloc.of(context);
    final iotBloc = IotBloc.of(context);
    final startupBloc = StartupBloc.of(context)
      ..updateDashboardApiCalling(true);
    await startupBloc.callEverything();
    unawaited(iotBloc.callIotRoomsApi(needLoaderDismiss: false));
    await iotBloc.callIotApi(needLoaderDismiss: false);
    await iotBloc.socketListener();
    unawaited(
      Future.delayed(const Duration(seconds: 3), () {
        startupBloc.updateDashboardApiCalling(false);
      }),
    );
    await notificationBloc.callStatusApi();
    await visitorBloc.initialCall(isRefresh: true);
    await notificationBloc.callNotificationApi(refresh: true);
    notificationBloc.updateFilter(false);
    visitorBloc.updateVisitorNewNotification(false);
    // unawaited(HomeScreen.getSectionsList());
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Show your dashboard call
          unawaited(dashboardRefresh(context));
        });

        // Return completed future so RefreshIndicator hides instantly
        return Future.value();
      },
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      color: Theme.of(context).primaryColor,
      backgroundColor:
          Theme.of(context).cupertinoOverrideTheme?.barBackgroundColor,
      child: Column(
        children: [
          StartupBlocSelector.isInternetConnected(
            builder: (isInternetConnected) {
              if (!isInternetConnected &&
                  singletonBloc.profileBloc.state?.selectedDoorBell != null) {
                return const SizedBox.shrink();
              }
              return StartupBlocSelector.userDeviceModel(
                builder: (devices) {
                  return StartupBlocSelector.dashboardApiCalling(
                    builder: (isDashboardApiCalling) {
                      if (isDashboardApiCalling) {
                        return const SizedBox.shrink();
                      }
                      return const AppBarWidget();
                    },
                  );
                },
              );
            },
          ),
          Expanded(
            child: StartupBlocBuilder(
              builder: (context, state) {
                return StartupBlocSelector.isInternetConnected(
                  builder: (isInternetConnected) {
                    return StartupBlocSelector(
                      selector: (startupState) =>
                          startupState.dashboardApiCalling,
                      builder: (isDashboardApiCalling) {
                        // Use WidgetsBinding to schedule overlay calls after build
                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (isDashboardApiCalling) {
                          Constants.showLoader(showCircularLoader: false);
                        } else if (!isDashboardApiCalling) {
                          Constants.dismissLoader();
                        }
                        // });
                        if (!isInternetConnected &&
                            singletonBloc.profileBloc.state?.selectedDoorBell !=
                                null) {
                          return NoInternetDoorbellDashboard();
                        }
                        if ((state.userDeviceModel == null ||
                                isDashboardApiCalling) &&
                            isInternetConnected) {
                          return const SizedBox.shrink();
                        } else if ((state.userDeviceModel == null ||
                                isDashboardApiCalling) &&
                            !isInternetConnected) {
                          return const NoDoorBell();
                        } else if (state.userDeviceModel!.isEmpty) {
                          return const NoDoorBell();
                        }
                        return const DoorBellWidget();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NoDoorBell extends StatelessWidget {
  const NoDoorBell({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = StartupBloc.of(context);
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 5),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: CarouselSlider(
                  items: [
                    DefaultImages.SLIDER1,
                    DefaultImages.SLIDER2,
                    DefaultImages.SLIDER3,
                  ]
                      .map(
                        (item) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (item == DefaultImages.SLIDER1) {
                              CommonFunctions.openUrl(
                                Constants.visitIrvineiUrl,
                              );
                            } else if (item == DefaultImages.SLIDER2) {
                              CommonFunctions.openUrl(
                                Constants.shopDoorbellMoreUrl,
                              );
                            } else {
                              CommonFunctions.openUrl(
                                Constants.guardPlansUrl,
                              );
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              item,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                    height: 160,
                    viewportFraction: 1,
                    autoPlay: true,
                    initialPage: bloc.state.noDoorbellCarouselIndex,
                    autoPlayInterval: const Duration(seconds: 3),
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      bloc.updateNoDoorbellCarouselIndex(index);
                    },
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              StartupBlocSelector(
                selector: (state) => state.noDoorbellCarouselIndex,
                builder: (index) {
                  return AnimatedSmoothIndicator(
                    activeIndex: index,
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 6,
                      activeDotColor: AppColors.darkBluePrimaryColor,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: FeatureNoDoorBellList(),
        ),
        SizedBox(
          height: 3.h,
        ),
      ],
    );
  }
}

class DoorBellWidget extends StatefulWidget {
  const DoorBellWidget({
    super.key,
  });

  @override
  State<DoorBellWidget> createState() => _DoorBellWidgetState();
}

class _DoorBellWidgetState extends State<DoorBellWidget> {
  // late StartupBloc startupBloc;

  @override
  void initState() {
    // WidgetsBinding.instance.addObserver(this);
    // startupBloc = StartupBloc.of(context);
    // HomeScreen.getSectionsList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CommonFunctions.showSubscriptionExpiredDialog(context);
    });
    super.initState();
  }

  // @override
  // Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) {
  //     await startupBloc.callUserDetails();
  //     await startupBloc.callPlanFeaturesManagement();
  //   }
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this); // Remove observer
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: [
          // ProfileBlocBuilder(
          //   builder: (context, state) {
          //     return ProfileBlocSelector.sectionList(
          //       builder: (sectionList) {
          //         if (sectionList == null || sectionList.isEmpty) {
          //           return Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          FeatureDoorBellList(),
          const SizedBox(height: 10),
          const MonitorCameras(),
          const SizedBox(height: 10),
          // IotBlocSelector.iotDeviceModel(
          //   builder: (list) {
          //     if (CommonFunctions.getIotFilteredList(list).isNotEmpty) {
          //       return const SizedBox(height: 10);
          //     }
          //     return const SizedBox.shrink();
          //   },
          // ),
          const SmartDevices(),
          //             ],
          //           );
          //         }
          //         return getPinnedWidgetLength(sectionList.length);
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  // Widget getWidget(String name) {
  //   switch (name) {
  //     case "smart":
  //       return const SmartDevices();
  //     case "monitor":
  //       return const MonitorCameras();
  //     default:
  //       return FeatureDoorBellList();
  //   }
  // }
  //
  // Widget getPinnedWidgetLength(int length) {
  //   final BuiltList<String> sectionList =
  //       singletonBloc.profileBloc.state!.sectionList ??
  //           <String>[].toBuiltList();
  //   final List<String> sectionNames = ["smart", "monitor", "feature"];
  //   switch (length) {
  //     case 1:
  //       final String name = sectionList[0];
  //       return Column(
  //         children: [
  //           const SizedBox(height: 20),
  //           getWidget(sectionList[0]),
  //           const SizedBox(height: 20),
  //           getSinglePinnedWidget(name),
  //         ],
  //       );
  //     case 2:
  //       final List<String> list = [];
  //       for (int i = 0; i < sectionNames.length; i++) {
  //         if (!sectionList.contains(sectionNames[i])) {
  //           list.add(sectionNames[i]);
  //         }
  //       }
  //       final String name = list[0];
  //       return Column(
  //         children: [
  //           const SizedBox(height: 20),
  //           getWidget(sectionList[0]),
  //           const SizedBox(height: 20),
  //           getWidget(sectionList[1]),
  //           const SizedBox(height: 20),
  //           getWidget(name),
  //         ],
  //       );
  //     default:
  //       return Column(
  //         children: [
  //           getWidget(sectionList[0]),
  //           const SizedBox(height: 20),
  //           getWidget(sectionList[1]),
  //           const SizedBox(height: 20),
  //           getWidget(sectionList[2]),
  //         ],
  //       );
  //   }
  // }
  //
  // Widget getSinglePinnedWidget(String name) {
  //   switch (name) {
  //     case "smart":
  //       return Column(
  //         children: [
  //           const MonitorCameras(),
  //           const SizedBox(height: 20),
  //           FeatureDoorBellList(),
  //         ],
  //       );
  //     case "monitor":
  //       return Column(
  //         children: [
  //           const SmartDevices(),
  //           const SizedBox(height: 20),
  //           FeatureDoorBellList(),
  //         ],
  //       );
  //     default:
  //       return const Column(
  //         children: [
  //           SmartDevices(),
  //           SizedBox(height: 20),
  //           MonitorCameras(),
  //         ],
  //       );
  //   }
  // }
}
