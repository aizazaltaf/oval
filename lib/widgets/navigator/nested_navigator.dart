import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/main.dart';
import 'package:admin/pages/main/dashboard/main_dashboard.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_overlay_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

final _logger = Logger("nested_navigator.dart");

class NestedNavigator extends StatefulWidget {
  const NestedNavigator({
    super.key,
    required this.firstPageBuilder,
  });

  final WidgetBuilder firstPageBuilder;

  @override
  NestedNavigatorState createState() => NestedNavigatorState();
}

class NestedNavigatorState extends State<NestedNavigator>
    with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  DateTime? _lastPressed;
  late StartupBloc startupBloc;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this); // Add observer
    startupBloc = StartupBloc.of(context);
    super.initState();
  }

  @override
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state != AppLifecycleState.resumed) {
      AppLifecycleTracker.isAppRunning = false;
      return;
    }
    AppLifecycleTracker.isAppRunning = true;

    // Delay non-UI API calls safely
    Future.delayed(const Duration(seconds: 1), () async {
      await startupBloc.callUserDetails();
      await startupBloc.callPlanFeaturesManagement();
    });
    final box = await HydratedStorage.build(
      storageDirectory:
          HydratedStorageDirectory((await getTemporaryDirectory()).path),
    );

    final List<String> releasedLocations =
        List<String>.from(box.read('released_locations') ?? []);

    if (releasedLocations.isEmpty) {
      return;
    }

    // Capture BLoC references without using context after async gaps
    final profileBloc = singletonBloc.profileBloc;
    final StartupBloc startupBlocRef = startupBloc;

    for (final String locationId in releasedLocations) {
      try {
        final String? selectedLocationId =
            profileBloc.state?.selectedDoorBell?.locationId?.toString();

        if (selectedLocationId == locationId) {
          // Clear page indexes and call APIs via BLoC directly
          startupBlocRef
            ..clearPageIndexes()
            ..updateDashboardApiCalling(true);

          await startupBlocRef.callEverything();

          // UI updates: use post-frame callback to safely access context
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final navigatorState = singletonBloc.navigatorKey?.currentState;
            if (navigatorState?.context != null) {
              unawaited(
                CommonFunctions.updateLocationData(navigatorState!.context),
              );
              unawaited(MainDashboard.pushRemove(navigatorState.context));
            }
          });
        }
      } catch (e) {
        _logger.warning("Error handling release notification: $e");
      }
    }

    // Clear list after syncing
    await box.write('released_locations', []);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    singletonBloc.navigatorKey = navigatorKey;
    final startUpBloc = StartupBloc.of(context);
    final bloc = IotBloc.of(context);

    return PopScope(
      canPop: navigatorKey.currentState?.canPop() ?? false,
      onPopInvokedWithResult: (didPop, result) {
        if (!CustomOverlayLoader.isShowing) {
          if (navigatorKey.currentState?.canPop() ?? false) {
            final brandValue = Constants.brandMap[bloc.state.formDevice?.brand];

            if (bloc.state.currentFormStep != null) {
              if (brandValue == 3 && bloc.state.currentFormStep! == 3) {
                // Step cannot go below 2
                bloc.updateCurrentFormStep(bloc.state.currentFormStep! - 1);
              } else if (brandValue == 2 && bloc.state.currentFormStep! == 2) {
                // Step cannot go below 1
                bloc.updateCurrentFormStep(bloc.state.currentFormStep! - 1);
              } else {
                // Already at min step for this brand → pop navigator
                if (brandValue == 3 && bloc.state.currentFormStep! > 1) {
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return AppDialogPopup(
                        headerWidget: Image.asset(
                          DefaultImages.WARNING_IMAGE,
                          height: 60,
                          width: 60,
                        ),
                        title: context.appLocalizations.warning,
                        needCross: false,
                        description: context.appLocalizations.quit_process,
                        confirmButtonLabel: context.appLocalizations.quit,
                        cancelButtonLabel:
                            context.appLocalizations.general_cancel,
                        cancelButtonOnTap: () {
                          Navigator.pop(dialogContext);
                        },
                        confirmButtonOnTap: () {
                          Navigator.pop(dialogContext);
                          // unawaited(ScanDoorbell.push(context));
                          // BluetoothScanPage.push(context);
                          navigatorKey.currentState?.maybePop();
                          Future.delayed(const Duration(milliseconds: 500), () {
                            bloc.updateCurrentFormStep(null);
                          });
                        },
                      );
                    },
                  );
                } else {
                  navigatorKey.currentState?.maybePop();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    bloc.updateCurrentFormStep(null);
                  });
                }
                // navigatorKey.currentState?.maybePop();
                // Future.delayed(const Duration(milliseconds: 500), () {
                //   bloc.updateCurrentFormStep(null);
                // });
              }
            } else {
              navigatorKey.currentState?.maybePop();
            }
          } else {
            if (startUpBloc.state.indexedStackValue == 0) {
              if (didPop) {
                return;
              }

              final now = DateTime.now();
              if (_lastPressed == null ||
                  now.difference(_lastPressed!) > const Duration(seconds: 2)) {
                _lastPressed = now;

                ToastUtils.infoToast(
                  "Exit App",
                  "Double back press to exit the app",
                );
              } else {
                SystemNavigator.pop();
              }
            } else {
              startUpBloc.popIndexChanged(VisitorManagementBloc.of(context));
            }
          }
        }
      },
      child: Navigator(
        key: navigatorKey, // Unique key for navigation
        onGenerateRoute: (final settings) => MaterialPageRoute(
          settings: settings,
          builder: widget.firstPageBuilder,
        ),
      ),
    );
    // return Navigator(
    //   key: navigatorKey, // Unique key for navigation
    //   onGenerateRoute: (final settings) => MaterialPageRoute(
    //     settings: settings,
    //     builder: widget.firstPageBuilder,
    //   ),
    // );
  }
}
