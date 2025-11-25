import 'dart:ui';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/iot_devices/add_manually_screen.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/iot_devices/dialogs/device_type_dialog.dart';
import 'package:admin/pages/main/iot_devices/view_all_scanned_devices.dart';
import 'package:admin/staggered.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/loading_widget.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:super_tooltip/super_tooltip.dart';

class AutoScannerPage extends StatefulWidget {
  const AutoScannerPage._();

  static const routeName = 'autoScan';

  static Future<void> push(final BuildContext context) {
    final bloc = IotBloc.of(context)..clearIotBrandSelected();

    // if (singletonBloc.profileBloc.state!.locationId != null) {
    if (singletonBloc.profileBloc.state!.selectedDoorBell?.locationId != null) {
      bloc.scanDevices();
    }
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const AutoScannerPage._(),
    );
  }

  static final _superToolTipController = SuperTooltipController();

  @override
  State<AutoScannerPage> createState() => _AutoScannerPageState();
}

class _AutoScannerPageState extends State<AutoScannerPage> {
  bool onNetwork = true;
  bool connected = false;
  bool all = false;
  Set<String> deviceType = {};

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);
    return AppScaffold(
      appTitle: context.appLocalizations.add_new_device,
      appBarAction: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SuperTooltip(
            arrowTipDistance: 24,
            arrowLength: 8,
            arrowTipRadius: 6,
            shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
            backgroundColor:
                CommonFunctions.getThemePrimaryLightWhiteColor(context),
            borderColor: Colors.white,
            barrierColor: Colors.transparent,
            shadowBlurRadius: 7,
            shadowSpreadRadius: 0,
            showBarrier: true,
            controller: AutoScannerPage._superToolTipController,
            content: IntrinsicWidth(
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        onNetwork = true;
                        connected = false;
                        all = false;
                        setState(() {});
                        AutoScannerPage._superToolTipController.hideTooltip();
                      },
                      child: buildNetworkStatusChip(
                        context,
                        context.appLocalizations.on_network,
                        onNetwork,
                      ),
                      // Container(
                      //   width: 45.w,
                      //   padding: const EdgeInsets.all(5),
                      //   decoration: BoxDecoration(
                      //     color: onNetwork
                      //         ? AppColors.curtainSliderInActiveColor
                      //         : null,
                      //     borderRadius: BorderRadius.circular(5),
                      //   ),
                      //   child: RichText(
                      //     text: TextSpan(
                      //       children: [
                      //         TextSpan(
                      //           // text: Text(
                      //           text: context.appLocalizations.on_network,
                      //           // textAlign: TextAlign.start,
                      //           style: Theme.of(context)
                      //               .textTheme
                      //               .bodyLarge
                      //               ?.copyWith(
                      //                   color: onNetwork
                      //                       ? AppColors.blueLinearGradientColor
                      //                       : null),
                      //           // )
                      //         ),
                      //         // WidgetSpan(
                      //         //   child: SizedBox(
                      //         //     width: 10.w,
                      //         //   ),
                      //         // ),
                      //         WidgetSpan(
                      //           child: Icon(
                      //             Icons.check,
                      //             color: onNetwork
                      //                 ? AppColors.blueLinearGradientColor
                      //                 : null,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ),
                    const PopupMenuDivider(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        onNetwork = false;
                        connected = true;
                        all = false;
                        setState(() {});
                        AutoScannerPage._superToolTipController.hideTooltip();
                      },
                      child:
                          // Container(
                          //   width: 45.w,
                          //   padding: const EdgeInsets.all(5),
                          //   decoration: BoxDecoration(
                          //     color: connected
                          //         ? AppColors.curtainSliderInActiveColor
                          //         : null,
                          //     borderRadius: BorderRadius.circular(5),
                          //   ),
                          //   child: RichText(
                          //     text: TextSpan(
                          //       children: [
                          //         TextSpan(
                          //           // text: Text(
                          //           text: context
                          //               .appLocalizations.connected_on_irvinei_app,
                          //           style: Theme.of(context)
                          //               .textTheme
                          //               .bodyLarge
                          //               ?.copyWith(
                          //                   color: connected
                          //                       ? AppColors.blueLinearGradientColor
                          //                       : null),
                          //           // )
                          //         ),
                          //         // WidgetSpan(
                          //         //   child: SizedBox(
                          //         //     width: 10.w,
                          //         //   ),
                          //         // ),
                          //         WidgetSpan(
                          //           child: Icon(
                          //             Icons.check,
                          //             color: connected
                          //                 ? AppColors.blueLinearGradientColor
                          //                 : null,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          buildNetworkStatusChip(
                        context,
                        context.appLocalizations.connected_on_irvinei_app,
                        connected,
                      ),
                    ),
                    const PopupMenuDivider(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return DeviceTypeDialog(bloc);
                          },
                        ).then((val) {
                          if (val != null) {
                            deviceType = val;
                          }
                          setState(() {});
                        });
                        AutoScannerPage._superToolTipController.hideTooltip();
                      },
                      child: SizedBox(
                        width: 60.w,
                        child: Text(
                          context.appLocalizations.device_type,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    const PopupMenuDivider(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        onNetwork = false;
                        connected = false;
                        all = true;
                        setState(() {});
                        AutoScannerPage._superToolTipController.hideTooltip();
                      },
                      child:
                          // Container(
                          //   width: 45.w,
                          //   padding: const EdgeInsets.all(5),
                          //   decoration: BoxDecoration(
                          //     color:
                          //         all ? AppColors.curtainSliderInActiveColor : null,
                          //     borderRadius: BorderRadius.circular(5),
                          //   ),
                          //   child: RichText(
                          //     text: TextSpan(
                          //       children: [
                          //         TextSpan(
                          //           // text: Text(
                          //           text: context.appLocalizations.all_devices,
                          //           style: Theme.of(context)
                          //               .textTheme
                          //               .bodyLarge
                          //               ?.copyWith(
                          //                   color: all
                          //                       ? AppColors.blueLinearGradientColor
                          //                       : null),
                          //           // )
                          //         ),
                          //         // WidgetSpan(
                          //         //   child: SizedBox(
                          //         //     width: 10.w,
                          //         //   ),
                          //         // ),
                          //         WidgetSpan(
                          //           child: Icon(
                          //             Icons.check,
                          //             color: all
                          //                 ? AppColors.blueLinearGradientColor
                          //                 : null,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          buildNetworkStatusChip(
                        context,
                        context.appLocalizations.all_devices,
                        all,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              child: Icon(
                MdiIcons.tuneVerticalVariant,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: IotBlocSelector(
          selector: (state) => state.getScannerResponse.isSocketInProgress,
          builder: (isLoading) {
            return CustomGradientButton(
              // isButtonEnabled: !isLoading,
              onSubmit: () {
                bloc.clearIotBrandSelected();
                AddManuallyScreen.push(context).then((v) {
                  bloc.setCacheValueForBrands();
                });
              },
              label: context.appLocalizations.add_manually,
            );
          },
        ),
      ),
      body: StartupBlocSelector.isInternetConnected(
        builder: (isConnected) {
          return IotBlocSelector(
            selector: (state) =>
                state.getScannerResponse.isSocketInProgress || state.isScanning,
            builder: (isLoading) {
              return RefreshIndicator(
                color: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context)
                    .cupertinoOverrideTheme
                    ?.barBackgroundColor,
                onRefresh: bloc.scanDevices,
                child: ListView(
                  // spacing: 10,
                  physics: isLoading
                      ? const NeverScrollableScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: isLoading ? 78.h : 75.h,
                      width: 100.w,
                      child:
                          // Stack(
                          //   children: [
                          //     if (
                          !isConnected
                              ? Container(
                                  height: 90.h,
                                  width: 100.w,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: svg.Svg(
                                        DefaultIcons.RADAR,
                                      ),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      context
                                          .appLocalizations.no_device_available,
                                    ),
                                  ),
                                )
                              : isLoading
                                  ?
                                  // )
                                  BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 10,
                                        sigmaY: 10,
                                      ),
                                      // Adjust blur intensity
                                      child: ColoredBox(
                                        color: Colors.black.withAlpha(50),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          spacing: 10,
                                          children: [
                                            const CircularProgressIndicator(
                                              color: Color.fromRGBO(
                                                68,
                                                206,
                                                255,
                                                1,
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Center(
                                                child: Text(
                                                  context.appLocalizations
                                                      .connecting_near_device,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ), // Adjust opacity for overlay effect
                                      ),
                                    )
                                  // else
                                  : Center(
                                      child:
                                          // bloc.state.scannedDevices.isEmpty
                                          //     ? Container(
                                          //         height: 90.h,
                                          //         width: 100.w,
                                          //         decoration: const BoxDecoration(
                                          //           image: DecorationImage(
                                          //             image: svg.Svg(
                                          //               DefaultIcons.RADAR,
                                          //             ), // your svg wrapper
                                          //             fit: BoxFit.fitWidth,
                                          //           ),
                                          //         ),
                                          //         child: Center(
                                          //           child: Text(
                                          //             context
                                          //                 .appLocalizations.no_device_available,
                                          //           ),
                                          //         ),
                                          //       )
                                          //     :
                                          Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                context.appLocalizations
                                                    .stable_wifi,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          IotBlocSelector.viewDevicesAll(
                                            builder: (devices) {
                                              if ((devices?.length ?? 0) > 5) {
                                                return Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      ViewAllScannedDevices
                                                          .push(
                                                        context,
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 20,
                                                      ),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              "${context.appLocalizations.more_dashboard} ${context.appLocalizations.devices} ",
                                                              style: Theme.of(
                                                                context,
                                                              )
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                    color: Theme
                                                                        .of(
                                                                      context,
                                                                    ).primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .navigate_next,
                                                              color: Theme.of(
                                                                context,
                                                              ).primaryColor,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return const SizedBox.shrink();
                                              }
                                            },
                                          ),
                                          Expanded(
                                            flex: 18,
                                            child: RandomWidgetsOverlay(
                                              onNetwork: onNetwork,
                                              connected: connected,
                                              all: all,
                                              deviceType: deviceType,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                      // ],
                      // ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildNetworkStatusChip(
    BuildContext context,
    String text,
    bool isSelected,
  ) {
    return Container(
      width: 60.w,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.curtainSliderInActiveColor : null,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isSelected ? AppColors.blueLinearGradientColor : null,
                ),
          ),
          if (isSelected)
            Icon(
              Icons.check,
              color: isSelected ? AppColors.blueLinearGradientColor : null,
            ),
        ],
      ),
      // RichText(
      //   text: TextSpan(
      //     children: [
      //       TextSpan(
      //         text: text,
      //         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
      //               color:
      //                   isSelected ? AppColors.blueLinearGradientColor : null,
      //             ),
      //       ),
      //       WidgetSpan(
      //         child: Icon(
      //           Icons.check,
      //           color: isSelected ? AppColors.blueLinearGradientColor : null,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class RandomWidgetsOverlay extends StatelessWidget {
  const RandomWidgetsOverlay({
    super.key,
    this.itemSize = 150,
    this.onNetwork = false,
    this.connected = false,
    this.all = false,
    this.deviceType,
  });

  final double itemSize;
  final bool onNetwork;
  final bool connected;
  final bool all;
  final Set<String>? deviceType;

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Get devices list (same logic as your original)
        List<FeatureModel> viewDevices = [];
        if (onNetwork) {
          if (deviceType == null || (deviceType ?? {}).isEmpty) {
            viewDevices = bloc.state.scannedDevices.toList();
          } else {
            viewDevices = bloc.state.scannedDevices.where((e) {
              if (deviceType!.contains(bloc.getType(e.image))) {
                return true;
              } else {
                return false;
              }
            }).toList();
          }
        } else if (connected) {
          viewDevices = bloc.state.iotDeviceModel!
              .whereNot((e) => e.entityId!.isHub())
              .map(
                (e) => FeatureModel(
                  title: (e.details?['ip_address'] ?? "").toString(),
                  value: (e.details?['mac_address'] ?? "").toString(),
                  image: e.imagePreview!,
                  brand: e.deviceName,
                  roomId: e.roomId,
                ),
              )
              .toList();
          if (!(deviceType == null || (deviceType ?? {}).isEmpty)) {
            viewDevices = viewDevices.where((e) {
              if (deviceType!.contains(bloc.getType(e.image))) {
                return true;
              } else {
                return false;
              }
            }).toList();
          }
        } else {
          final forMerge = bloc.state.iotDeviceModel!
              .whereNot((e) => e.entityId!.isHub())
              .map(
                (e) => FeatureModel(
                  title: (e.details?['ip_address'] ?? "").toString(),
                  value: (e.details?['mac_address'] ?? "").toString(),
                  image: e.imagePreview!,
                  brand: e.deviceName,
                  roomId: e.roomId,
                ),
              )
              .toList();

          viewDevices = [...forMerge, ...bloc.state.scannedDevices];
          if (!(deviceType == null || (deviceType ?? {}).isEmpty)) {
            viewDevices = viewDevices.where((e) {
              if (deviceType!.contains(bloc.getType(e.image))) {
                return true;
              } else {
                return false;
              }
            }).toList();
          }
        }

        bloc.updateViewDevicesAll(viewDevices.toBuiltList());

        // Debug: Print device count for troubleshooting

        return viewDevices.isEmpty
            ? Container(
                height: 90.h,
                width: 100.w,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: svg.Svg(
                      DefaultIcons.RADAR,
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Center(
                  child: Text(
                    context.appLocalizations.no_device_available,
                  ),
                ),
              )
            : DecoratedBox(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: svg.Svg(DefaultIcons.RADAR),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: StaggeredGridView(
                  crossAxisCount: 3,
                  // Fixed number of columns for better control
                  mainAxisSpacing: 30,
                  // Increased spacing to prevent touching
                  crossAxisSpacing: 30,
                  // Increased spacing to prevent touching
                  randomSeed: DateTime.now().millisecondsSinceEpoch % 1000,
                  // Dynamic seed for varied positions
                  preserveAspectRatio: true,
                  // Preserve device widget aspect ratios
                  maxItemHeight: itemSize * 1.4,
                  // Increased max height for better visibility
                  minItemHeight: itemSize * 0.8,
                  // Increased min height for better visibility
                  children: _buildDeviceWidgets(viewDevices, bloc, itemSize),
                ),
              );
      },
    );
  }

  /// Build device widgets with overflow protection
  List<Widget> _buildDeviceWidgets(
    List<FeatureModel> viewDevices,
    IotBloc bloc,
    double itemSize,
  ) {
    final deviceCount = viewDevices.length >= 5 ? 5 : viewDevices.length;

    return List.generate(deviceCount, (i) {
      return _OverflowSafeDeviceWidget(
        index: i,
        viewDevices: viewDevices,
        bloc: bloc,
        itemSize: itemSize,
      );
    });
  }

// // Helper method to check if two rectangles overlap
// bool _doRectanglesOverlap(Rect rect1, Rect rect2) {
//   return rect1.overlaps(rect2);
// }
//
// // Helper method to generate a valid position
// Offset _generateValidPosition(
//   Random random,
//   double containerWidth,
//   double containerHeight,
//   double itemWidth,
//   double itemHeight,
//   List<Rect> existingRects,
//   int maxAttempts,
// ) {
//   const padding = 20.0;
//
//   for (int attempt = 0; attempt < maxAttempts; attempt++) {
//     final x = padding +
//         random.nextDouble() * (containerWidth - itemWidth - padding * 2);
//     final y = padding +
//         random.nextDouble() * (containerHeight - itemHeight - padding * 2);
//
//     final newRect = Rect.fromLTWH(x, y, itemWidth, itemHeight);
//     bool overlaps = false;
//
//     // Check overlap with existing rectangles
//     for (final existingRect in existingRects) {
//       if (_doRectanglesOverlap(newRect, existingRect)) {
//         overlaps = true;
//         break;
//       }
//     }
//
//     if (!overlaps) {
//       return Offset(x, y);
//     }
//   }
//
//   // If no valid position found after max attempts, try grid placement
//   return _findGridPosition(
//     containerWidth,
//     containerHeight,
//     itemWidth,
//     itemHeight,
//     existingRects,
//   );
// }
//
// // Helper method to find a grid position when random placement fails
// Offset _findGridPosition(
//   double containerWidth,
//   double containerHeight,
//   double itemWidth,
//   double itemHeight,
//   List<Rect> existingRects,
// ) {
//   const padding = 20.0;
//   final cols = (containerWidth / (itemWidth + padding)).floor();
//   final rows = (containerHeight / (itemHeight + padding)).floor();
//
//   for (int row = 0; row < rows; row++) {
//     for (int col = 0; col < cols; col++) {
//       final x = col * (itemWidth + padding) + padding;
//       final y = row * (itemHeight + padding) + padding;
//
//       final newRect = Rect.fromLTWH(x, y, itemWidth, itemHeight);
//       bool overlaps = false;
//
//       for (final existingRect in existingRects) {
//         if (_doRectanglesOverlap(newRect, existingRect)) {
//           overlaps = true;
//           break;
//         }
//       }
//
//       if (!overlaps) {
//         return Offset(x, y);
//       }
//     }
//   }
//
//   // If even grid placement fails, return a fallback position
//   return const Offset(padding, padding);
// }
//
// @override
// Widget build(BuildContext context) {
//   final bloc = IotBloc.of(context);
//   return LayoutBuilder(
//     builder: (context, constraints) {
//       final random = Random();
//       final double containerWidth = constraints.maxWidth - 40;
//       final double containerHeight = constraints.maxHeight - 40;
//       final List<Rect> placedRects = []; // Store rectangles of placed widgets
//       final List<Widget> randomWidgets = [];
//
//       // Get devices list
//       List<FeatureModel> viewDevices = [];
//       if (onNetwork) {
//         if (deviceType == null || (deviceType ?? {}).isEmpty) {
//           viewDevices = bloc.state.scannedDevices.toList();
//         } else {
//           viewDevices = bloc.state.scannedDevices.where((e) {
//             if (deviceType!.contains(bloc.getType(e.image))) {
//               return true;
//             } else {
//               return false;
//             }
//           }).toList();
//         }
//       } else if (connected) {
//         viewDevices = bloc.state.iotDeviceModel!
//             .whereNot((e) => e.entityId!.isHub())
//             .map(
//               (e) => FeatureModel(
//                 title: (e.details?['ip_address'] ?? "").toString(),
//                 value: (e.details?['mac_address'] ?? "").toString(),
//                 image: e.imagePreview!,
//                 brand: e.deviceName,
//               ),
//             )
//             .toList();
//         if (!(deviceType == null || (deviceType ?? {}).isEmpty)) {
//           viewDevices = viewDevices.where((e) {
//             if (deviceType!.contains(bloc.getType(e.image))) {
//               return true;
//             } else {
//               return false;
//             }
//           }).toList();
//         }
//       } else {
//         final forMerge = bloc.state.iotDeviceModel!
//             .whereNot((e) => e.entityId!.isHub())
//             .map(
//               (e) => FeatureModel(
//                 title: (e.details?['ip_address'] ?? "").toString(),
//                 value: (e.details?['mac_address'] ?? "").toString(),
//                 image: e.imagePreview!,
//                 brand: e.deviceName,
//                 roomId: e.roomId,
//               ),
//             )
//             .toList();
//
//         viewDevices = [...forMerge, ...bloc.state.scannedDevices];
//         if (!(deviceType == null || (deviceType ?? {}).isEmpty)) {
//           viewDevices = viewDevices.where((e) {
//             if (deviceType!.contains(bloc.getType(e.image))) {
//               return true;
//             } else {
//               return false;
//             }
//           }).toList();
//         }
//       }
//
//       // Calculate actual widget dimensions including text
//       final double widgetWidth = itemSize / 1.75;
//       final double widgetHeight =
//           itemSize / 1.75 + 40; // Account for text height
//
//       // Place widgets
//       for (int i = 0; i < viewDevices.length; i++) {
//         final position = _generateValidPosition(
//           random,
//           containerWidth,
//           containerHeight,
//           widgetWidth,
//           widgetHeight,
//           placedRects,
//           100, // Maximum attempts for random placement
//         );
//
//         // Add the new rectangle to placed rectangles
//         placedRects.add(
//           Rect.fromLTWH(
//             position.dx,
//             position.dy,
//             widgetWidth,
//             widgetHeight,
//           ),
//         );
//
//         randomWidgets.add(
//           // Positioned(
//           //   left: position.dx,
//           //   top: position.dy,
//           //   child:
//           GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onTap: () {
//               bloc.onTapScannedDevices(viewDevices, i, context);
//             },
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: itemSize / 2.5,
//                   width: itemSize / 2.5,
//                   child: IotBlocSelector(
//                     selector: (state) =>
//                         state.getDeviceConfigResponse.isSocketInProgress ||
//                         state.curtainAddAPI.isApiInProgress,
//                     builder: (isLoading) {
//                       return Stack(
//                         children: [
//                           Container(
//                             height: itemSize / 1.2,
//                             decoration: BoxDecoration(
//                               color: AppColors.scanContainerColor,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Center(
//                               child: SvgPicture.asset(
//                                 viewDevices[i].image,
//                                 colorFilter: const ColorFilter.mode(
//                                   Colors.white,
//                                   BlendMode.srcIn,
//                                 ),
//                                 width: itemSize / 5,
//                                 height: itemSize / 5,
//                               ),
//                             ),
//                           ),
//                           if (bloc.state.scannedDevices.any(
//                             (e) =>
//                                 e.value == viewDevices[i].value ||
//                                 e.title == viewDevices[i].title,
//                           ))
//                             IotBlocSelector(
//                               selector: (state) => state
//                                       .scannedDevices.isNotEmpty
//                                   ? state
//                                       .scannedDevices[bloc
//                                           .state.scannedDevices
//                                           .indexWhere(
//                                       (e) => e.value == viewDevices[i].value,
//                                     )]
//                                       .isSelected
//                                   : false,
//                               builder: (isSelected) {
//                                 return Positioned(
//                                   bottom: 0,
//                                   right: 0,
//                                   child: LoadingWidget(
//                                     isLoading: isLoading && isSelected,
//                                     label: DecoratedBox(
//                                       decoration: BoxDecoration(
//                                         color:
//                                             AppColors.scannedFilterIconsColor,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: const Icon(
//                                         Icons.add,
//                                         color: Colors.white,
//                                         size: 18,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   width: itemSize / 1.75,
//                   child: Center(
//                     child: Text(
//                       (viewDevices[i].brand ?? "").capitalizeFirstOfEach(),
//                       maxLines: 1,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: itemSize / 1.75,
//                   child: Center(
//                     child: Text(
//                       viewDevices[i].title,
//                       textAlign: TextAlign.center,
//                       maxLines: 1,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // ),
//         );
//       }
//       bloc.updateViewDevicesAll(viewDevices.toBuiltList());
//       return viewDevices.isEmpty
//           ? Container(
//               height: 90.h,
//               width: 100.w,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: svg.Svg(
//                     DefaultIcons.RADAR,
//                   ), // your svg wrapper
//                   fit: BoxFit.fitWidth,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   context.appLocalizations.no_device_available,
//                 ),
//               ),
//             )
//           :
//           // Stack(
//           //         children: [
//           DecoratedBox(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: svg.Svg(DefaultIcons.RADAR), // your svg wrapper
//                   fit: BoxFit.fitWidth,
//                 ),
//               ),
//               child: StaggeredGridView(
//                 crossAxisCount: 3,
//                 mainAxisSpacing: 12,
//                 crossAxisSpacing: 12,
//                 randomSeed: 42,
//                 preserveAspectRatio: true, // Add this line
//                 maxItemHeight: itemSize * 1.5, // Add this line
//                 minItemHeight: itemSize * 0.8, // Add this line
//                 children: randomWidgets.length > 5
//                     ? randomWidgets.sublist(0, 5)
//                     : randomWidgets,
//               ),
//             );
//       // Wrap(
//       //   spacing: 30,
//       //   runSpacing: 30,
//       //   children: [
//       //     ...randomWidgets.length > 5
//       //         ? randomWidgets.sublist(0, 5)
//       //         : randomWidgets,
//       //   ],
//       // ),
//       // ...(),
//       // ],
//       // );
//     },
//   );
// }
}

/// Device widget with overflow protection
class _OverflowSafeDeviceWidget extends StatelessWidget {
  const _OverflowSafeDeviceWidget({
    required this.index,
    required this.viewDevices,
    required this.bloc,
    required this.itemSize,
  });

  final int index;
  final List<FeatureModel> viewDevices;
  final IotBloc bloc;
  final double itemSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        bloc.onTapScannedDevices(viewDevices, index, context);
      },
      child: Container(
        padding:
            const EdgeInsets.all(8), // Increased padding for better spacing
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevent overflow
          children: [
            // Icon container with better sizing
            SizedBox(
              height: itemSize / 2.8, // Slightly larger for better visibility
              width: itemSize / 2.8, // Slightly larger for better visibility
              child: IotBlocSelector(
                selector: (state) =>
                    state.getDeviceConfigResponse.isSocketInProgress ||
                    state.curtainAddAPI.isApiInProgress,
                builder: (isLoading) {
                  return Stack(
                    children: [
                      Container(
                        height: itemSize / 1.4, // Better proportioned size
                        decoration: BoxDecoration(
                          color: AppColors.scanContainerColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            viewDevices[index].image,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                            width: itemSize /
                                5, // Larger icon for better visibility
                            height: itemSize /
                                5, // Larger icon for better visibility
                          ),
                        ),
                      ),
                      if (bloc.state.scannedDevices.any(
                        (e) =>
                            e.value == viewDevices[index].value ||
                            e.title == viewDevices[index].title,
                      ))
                        IotBlocSelector(
                          selector: (state) => state.scannedDevices.isNotEmpty
                              ? state
                                  .scannedDevices[
                                      bloc.state.scannedDevices.indexWhere(
                                  (e) => e.value == viewDevices[index].value,
                                )]
                                  .isSelected
                              : false,
                          builder: (isSelected) {
                            return Positioned(
                              bottom: 0,
                              right: 0,
                              child: LoadingWidget(
                                isLoading: isLoading && isSelected,
                                showCircularLoader: false,
                                label: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.scannedFilterIconsColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18, // Slightly larger icon
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8), // Increased spacing
            // Text with overflow protection and larger fonts
            Flexible(
              child: SizedBox(
                width: itemSize / 1.6, // Slightly wider for better text display
                child: Text(
                  (viewDevices[index].brand ?? "").capitalizeFirstOfEach(),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600, // Bolder font weight
                    fontSize: 13, // Increased font size
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4), // Increased spacing
            Flexible(
              child: SizedBox(
                width: itemSize / 1.6, // Slightly wider for better text display
                child: Text(
                  viewDevices[index].title.isNotEmpty &&
                          viewDevices[index].roomId == null
                      ? viewDevices[index].title
                      : bloc.state.getIotRoomsApi.data!
                              .firstWhereOrNull(
                                (e) => e.roomId == viewDevices[index].roomId,
                              )
                              ?.roomName ??
                          "",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11, // Increased font size
                    color: Colors.grey,
                    fontWeight: FontWeight.w400, // Added font weight
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
