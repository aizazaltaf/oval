import 'dart:async';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/doorbell_locations.dart';
import 'package:admin/pages/main/doorbell_management/bloc/doorbell_management_bloc.dart';
import 'package:admin/pages/main/doorbell_management/dialog.dart';
import 'package:admin/pages/main/doorbell_management/guides/address_guide.dart';
import 'package:admin/pages/main/doorbell_management/guides/circle_marker_guide.dart';
import 'package:admin/pages/main/doorbell_management/guides/pin_marker_guide.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:latlong2/latlong.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:super_tooltip/super_tooltip.dart';

class DoorbellMapPage extends StatefulWidget {
  const DoorbellMapPage._({
    this.fromLocationSettings = false,
    this.openPopUp = false,
    this.isEdit = false,
    this.location,
  });

  final bool fromLocationSettings;
  final bool openPopUp;
  final bool isEdit;
  final DoorbellLocations? location;

  static const routeName = "doorbellMapPage";

  static Future<void> push(
    final BuildContext context,
  ) {
    return pushReplacementMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const DoorbellMapPage._(),
    );
  }

  static Future<void> pushFromLocationScreen(
    final BuildContext context, {
    final bool fromLocationSettings = false,
    final bool openPopUp = false,
    final bool isEdit = false,
    DoorbellLocations? location,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => DoorbellMapPage._(
        fromLocationSettings: fromLocationSettings,
        openPopUp: openPopUp,
        isEdit: isEdit,
        location: location,
      ),
    );
  }

  @override
  State<DoorbellMapPage> createState() => _DoorbellMapPageState();
}

class _DoorbellMapPageState extends State<DoorbellMapPage> {
  MapController mapController = MapController();
  bool mapReady = false;

  @override
  void initState() {
    final bloc = DoorbellManagementBloc.of(context)..getLocationCoordinates();
    if (singletonBloc.profileBloc.state?.guides == null ||
        singletonBloc.profileBloc.state?.guides?.mapsGuide == null ||
        singletonBloc.profileBloc.state?.guides?.mapsGuide == 0) {
      bloc
        ..updateMapGuideShow(false)
        ..updateCurrentGuideKey("circle_marker");
    } else {
      bloc.updateMapGuideShow(true);
    }
    super.initState();

    if (widget.isEdit) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        showDialogForFilters(
          context.mounted ? context : context,
          focus: true,
          fromLocation: true,
        );
      });
    } else {
      openPopUp(context);
    }
  }

  void openPopUp(BuildContext context) {
    if (widget.openPopUp) {
      Future.delayed(const Duration(milliseconds: 300), () {
        showDialogForFilters(
          context.mounted ? context : context,
          focus: true,
          fromLocation: true,
        );
      });
    }
  }

  Timer? _debounce;
  bool? _isBacking;

  Future<bool> _onWillPop(parentContext, bloc) async {
    return await showDialog(
          context: parentContext,
          builder: (context) => StatefulBuilder(
            builder: (context, snapshot) {
              return AppDialogPopup(
                title: context.appLocalizations.exit_popup,
                confirmButtonOnTap: () async {
                  if (_debounce?.isActive ?? false) {
                    _debounce!.cancel();
                    _isBacking = false;
                  }
                  snapshot(() {
                    _isBacking = true;
                  });
                  _debounce =
                      Timer(const Duration(milliseconds: 500), () async {
                    await apiService.scanDoorbell(
                      bloc.state.deviceId,
                      0,
                    );

                    unawaited(
                      singletonBloc.socketEmitter(
                        roomName: Constants.doorbell,
                        roomId: bloc.state.deviceId,
                        deviceId: bloc.state.deviceId,
                        request: Constants.doorbellProcessTermination,
                      ),
                    );

                    if (context.mounted) {
                      _isBacking = false;
                      Constants.dismissLoader();
                      Navigator.pop(context, true);
                    }
                  });
                },
                confirmButtonLabel: context.appLocalizations.confirm,
                cancelButtonLabel: context.appLocalizations.general_cancel,
                isLoadingEnabled: _isBacking ?? false,
                cancelButtonOnTap: () => Navigator.pop(context, false),
              );
            },
          ),
        ) ??
        false; // Return false if dismissed
  }

  @override
  Widget build(BuildContext context) {
    final bloc = DoorbellManagementBloc.of(context);
    return PopScope(
      canPop: false, // Override normal pop behavior
      onPopInvokedWithResult: (didPop, result) async {
        // if (didPop) {
        //   return;
        // }
        // if (!widget.fromLocationSettings && widget.location == null) {
        //   final shouldPop = await _onWillPop(context);
        //   if (shouldPop && context.mounted) {
        //     Navigator.of(context).pop(); // Allow pop only if confirmed
        //   }
        // } else if (context.mounted) {
        //   Navigator.of(context).pop(); // Allow pop in other cases
        // }
        if (didPop) {
          return;
        }
        if (!widget.fromLocationSettings && widget.location == null) {
          final bool shouldPop = await _onWillPop(context, bloc);
          if (context.mounted && shouldPop) {
            Navigator.pop(context, result);
          }
        } else {
          if (context.mounted) {
            Navigator.pop(context, result);
          }
        }
      },
      child: DoorbellManagementBlocSelector(
        selector: (state) => state.mapGuideShow,
        builder: (guideShow) {
          return ShowCaseWidget(
            builder: (_) => Builder(
              builder: (innerContext) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  if (!guideShow) {
                    ShowCaseWidget.of(innerContext).startShowCase(
                      [
                        bloc.circleMarkerGuideKey,
                        bloc.pinMarkerGuideKey,
                        bloc.mapAddressGuideKey,
                      ],
                    );
                  }
                  bloc.updateMapGuideShow(true);
                });
                return AppScaffold(
                  appTitle: context.appLocalizations.your_doorbell_location,
                  leading: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      if (!widget.fromLocationSettings &&
                          widget.location == null) {
                        final bool shouldPop = await _onWillPop(context, bloc);
                        if (context.mounted && shouldPop) {
                          Navigator.pop(
                            context,
                          );
                        }
                      } else {
                        Navigator.pop(
                          context,
                        );
                      }
                    },
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: CommonFunctions.getThemeBasedWidgetColor(context),
                      size: 30,
                    ),
                  ),
                  body: NoGlowListViewWrapper(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              initialZoom: 20,
                              onMapReady: () {
                                setState(() => mapReady = true);
                              },
                              initialCenter: bloc.state.center ??
                                  const LatLng(37.7749, -122.4194),
                              onTap: (tapPosition, point) {
                                bloc.updatePosition(
                                  point,
                                  bloc.state.center!,
                                  context
                                      .appLocalizations.meter_radius_doorbell,
                                );
                              },
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaXJ2aW5laSIsImEiOiJjbTFnNXNjMG8wMGs0MnFzMno3cmZwYWR6In0.GrhMmzT3gCCAKWlM50zl-w',
                                additionalOptions: const {
                                  'accessToken':
                                      'pk.eyJ1IjoiaXJ2aW5laSIsImEiOiJjbTFnNXNjMG8wMGs0MnFzMno3cmZwYWR6In0.GrhMmzT3gCCAKWlM50zl-w',
                                },
                                // urlTemplate:
                                //     'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: "com.irveni.admin",
                                // additionalOptions: const {
                                //   "accessToken":
                                //       'pk.eyJ1IjoiaXJ2aW5laSIsImEiOiJjbTFnNXNjMG8wMGs0MnFzMno3cmZwYWR6In0.GrhMmzT3gCCAKWlM50zl-w',
                                //   'id': 'mapbox.mapbox-streets-v8',
                                // },
                              ),
                              if (mapReady)
                                CircleLayer(
                                  circles: [
                                    CircleMarker(
                                      point: bloc.state.center ??
                                          const LatLng(37.7749, -122.4194),
                                      useRadiusInMeter: true,
                                      color: Colors.blue.withValues(alpha: 0.2),
                                      borderStrokeWidth: 1,
                                      borderColor: Colors.blue,
                                      radius: 10,
                                    ),
                                  ],
                                ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    rotate: true,
                                    width: 40,
                                    height: 40,
                                    point: bloc.state.center ??
                                        const LatLng(37.7749, -122.4194),
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () async {
                                        await bloc.state.superToolTipController
                                            .showTooltip();
                                      },
                                      child: Showcase.withWidget(
                                        key: bloc.circleMarkerGuideKey,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        targetBorderRadius:
                                            BorderRadius.circular(40),
                                        tooltipPosition: TooltipPosition.bottom,
                                        container: CircleMarkerGuide(
                                          innerContext: innerContext,
                                          bloc: bloc,
                                        ),
                                        child: SuperTooltip(
                                          arrowTipDistance: 20,
                                          arrowLength: 8,
                                          arrowTipRadius: 6,
                                          shadowColor: const Color.fromRGBO(
                                            0,
                                            0,
                                            0,
                                            0.1,
                                          ),
                                          backgroundColor: CommonFunctions
                                              .getThemePrimaryLightWhiteColor(
                                            context,
                                          ),
                                          borderColor: Colors.white,
                                          barrierColor: Colors.transparent,
                                          shadowBlurRadius: 7,
                                          shadowSpreadRadius: 0,
                                          showBarrier: true,
                                          controller:
                                              bloc.state.superToolTipController,
                                          content: Material(
                                            color: Colors.transparent,
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '  ${context.appLocalizations.your_doorbell_location}',
                                              ),
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            backgroundColor: AppColors
                                                .blueLinearGradientColor,
                                            child: Text(
                                              'A',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              DoorbellManagementBlocSelector.markerPosition(
                                builder: (markerPosition) {
                                  return MarkerLayer(
                                    alignment: Alignment.centerRight,
                                    markers: [
                                      Marker(
                                        rotate: true,
                                        width: 40,
                                        height: 40,
                                        point: markerPosition!,
                                        child: Showcase.withWidget(
                                          key: bloc.pinMarkerGuideKey,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          container: PinMarkerGuide(
                                            innerContext: innerContext,
                                            bloc: bloc,
                                          ),
                                          targetBorderRadius:
                                              BorderRadius.circular(40),
                                          tooltipPosition:
                                              TooltipPosition.bottom,
                                          child: const Icon(
                                            Icons.location_on,
                                            size: 40,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SingleChildScrollView(
                            child: Column(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Image.asset(
                                          DefaultVectors
                                              .DOORBELL_NEW_IMAGE_SIDE_VIEW,
                                          // height: 3.h,
                                        ),
                                      ),
                                      // const SizedBox(
                                      //   width: 5,
                                      // ),
                                      SizedBox(
                                        height: 20.h,
                                        child: const VerticalDivider(
                                          width: 10,
                                          color: Colors.black,
                                          thickness: 1,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            right: 10,
                                          ),
                                          child: Column(
                                            children: [
                                              DoorbellManagementBlocSelector
                                                  .placeMark(
                                                builder: (placeMark) {
                                                  if (placeMark == null) {
                                                    return const ButtonProgressIndicator();
                                                  }
                                                  Constants.dismissLoader();
                                                  return Showcase.withWidget(
                                                    key:
                                                        bloc.mapAddressGuideKey,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    tooltipPosition:
                                                        TooltipPosition.top,
                                                    container: AddressGuide(
                                                      innerContext:
                                                          innerContext,
                                                      bloc: bloc,
                                                    ),
                                                    child: Text(
                                                      bloc.getAddress(
                                                        placeMark,
                                                      ),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium,
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                context.appLocalizations
                                                    .location_marker_text,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: AppColors
                                                          .textBlueColor,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DoorbellManagementBlocSelector.placeMark(
                                  builder: (placeMark) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              if (placeMark != null) {
                                                showDialogForFilters(
                                                  context,
                                                  fromLocation: widget
                                                      .fromLocationSettings,
                                                );
                                              }
                                            },
                                            child: Card(
                                              elevation: 5,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  60,
                                                ),
                                              ),
                                              child: Container(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                child: const Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  BuiltList<DoorbellLocations> filterOutViewerDoorbells() {
    BuiltList<DoorbellLocations> doorbells =
        <DoorbellLocations>[].toBuiltList();
    if (singletonBloc.profileBloc.state!.locations != null) {
      for (int i = 0;
          i < singletonBloc.profileBloc.state!.locations!.length;
          i++) {
        if (singletonBloc.profileBloc.state!.locations![i].roles[0] !=
            "Viewer") {
          doorbells = doorbells.rebuild(
            (b) => b.add(singletonBloc.profileBloc.state!.locations![i]),
          );
        }
      }
    }
    return doorbells;
  }

  void showDialogForFilters(
    BuildContext parentContext, {
    bool fromLocation = false,
    bool focus = false,
  }) {
    final bloc = DoorbellManagementBloc.of(parentContext)
      ..updateProceedButtonEnabled(false);
    final BuiltList<DoorbellLocations> filterDoorbells =
        filterOutViewerDoorbells();
    if (widget.fromLocationSettings) {
      bloc
        ..updateBackPress(true)
        ..updateLocationName(widget.location!.name!)
        ..updateCompanyAddress(widget.location!.houseNo!)
        ..updateStreetBlockName(widget.location!.street!);
    } else {
      bloc.updateBackPress(filterDoorbells.isEmpty);
      if (bloc.state.streetBlockName.isEmpty) {
        bloc.updateStreetBlockName(
          bloc.state.placeMark!.street!.length > 10
              ? bloc.state.placeMark!.street!.substring(0, 10)
              : bloc.state.placeMark!.street!,
        );
      }
    }
    if (filterDoorbells.isNotEmpty) {
      bloc.updateSelectedLocation(filterDoorbells.first);
    }
    // if we edit or has already entered the location details, proceed button will be true
    if (!widget.fromLocationSettings &&
        bloc.state.locationName.isNotEmpty &&
        bloc.state.companyAddress.isNotEmpty &&
        bloc.state.streetBlockName.isNotEmpty) {
      bloc.updateProceedButtonEnabled(true);
    }
    showDialog(
      context: parentContext,
      builder: (context) {
        return DoorbellLocationsDialog(
          bloc,
          parentContext,
          filterDoorbells: filterDoorbells.toSet().toBuiltList(),
          fromLocationSettings: fromLocation,
          focus: focus,
          updateLocation: widget.location,
        );
      },
    );
  }
}
