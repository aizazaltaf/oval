import 'dart:async';
import 'dart:convert';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/services.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/doorbell_management/bloc/doorbell_management_bloc.dart';
import 'package:admin/pages/main/doorbell_management/doorbell_map.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/list_view.dart';
import 'package:admin/widgets/loading_widget.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanDoorbell extends StatefulWidget {
  const ScanDoorbell({super.key});

  static const routeName = "scanDoorbell";

  static Future<void> push(
    final BuildContext context,
  ) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const ScanDoorbell(),
    );
  }

  static Future<void> pushReplacement(
    final BuildContext context,
  ) {
    return pushReplacementMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => const ScanDoorbell(),
    );
  }

  @override
  State<ScanDoorbell> createState() => _ScanDoorbellState();
}

class _ScanDoorbellState extends State<ScanDoorbell> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  PermissionStatus? status;

  MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.unrestricted,
    autoStart: false,
    formats: [BarcodeFormat.qrCode],
  );

  @override
  void initState() {
    getCameraPermission();
    super.initState();
  }

  @override
  void dispose() {
    //  implement dispose
    disposeScanner();
    super.dispose();
  }

  Future<void> disposeScanner() async {
    await scannerController.stop();
    await scannerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = DoorbellManagementBloc.of(context);
    return AppScaffold(
      appTitle: context.appLocalizations.scan_doorbell,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: NoGlowListViewWrapper(
          child: Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              Text(
                context.appLocalizations.scan_barcode_on_doorbell,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2.h,
              ),
              DoorbellManagementBlocSelector(
                selector: (state) => state.scanDoorBellApi.isApiInProgress,
                builder: (isLoading) {
                  return LoadingWidget(
                    isLoading: isLoading,
                    label: _qrScanner(context, bloc),
                  );
                },
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isDetected = false;
  Widget _qrScanner(BuildContext context, DoorbellManagementBloc bloc) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: MobileScanner(
          key: qrKey,
          controller: scannerController,
          onDetect: (p1) async {
            // Timer? debounceTimer;
            if (!isDetected) {
              isDetected = true;
              Future.delayed(const Duration(seconds: 1), () {
                isDetected = false;
              });

              // p1.scannedDataStream.listen((scanData) async {
              // await controller.stop();

              if (!(await Services.isInternetWorking())) {
                return;
              }
              try {
                final response = jsonDecode(p1.barcodes[0].rawValue!);
                if (response.toString().contains("device_id") &&
                    !bloc.state.scanDoorBellApi.isApiInProgress) {
                  bloc.updateDeviceId(response["device_id"]);

                  if (!bloc.state.scanDoorBellApi.isApiInProgress) {
                    await bloc.scanDoorBell(
                      bloc.state.deviceId ?? "",
                      () async {
                        if (response["location"] != "0.0,0.0") {
                          bloc
                            ..updateCenter(
                              LatLng(
                                double.parse(
                                  response['location'].toString().split(',')[0],
                                ),
                                double.parse(
                                  response['location'].toString().split(',')[1],
                                ),
                              ),
                            )
                            ..updateMarkerPosition(
                              LatLng(
                                double.parse(
                                  response['location'].toString().split(',')[0],
                                ),
                                double.parse(
                                  response['location'].toString().split(',')[1],
                                ),
                              ),
                            );
                          if (context.mounted) {
                            unawaited(
                              singletonBloc.socketEmitter(
                                roomName: Constants.doorbell,
                                roomId: bloc.state.deviceId,
                                deviceId: bloc.state.deviceId,
                                request: Constants.doorbellScanned,
                              ),
                            );
                            bloc
                              ..updateLocationName("")
                              ..updateStreetBlockName("")
                              ..updateCompanyAddress("");
                            unawaited(DoorbellMapPage.push(context));
                            await scannerController.stop();
                          }
                        } else {
                          bool serviceEnabled;
                          LocationPermission permission;

                          // Test if location services are enabled.
                          serviceEnabled =
                              await Geolocator.isLocationServiceEnabled();
                          if (!serviceEnabled) {
                            // Location services are not enabled don't continue
                            // accessing the position and request users of the
                            // App to enable the location services.
                            if (context.mounted) {
                              ToastUtils.infoToast(
                                context.appLocalizations.warning,
                                context.appLocalizations.unable_location,
                              );
                              await apiService.scanDoorbell(
                                bloc.state.deviceId!,
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
                            }
                          }

                          permission = await Geolocator.checkPermission();
                          if (permission == LocationPermission.denied) {
                            permission = await Geolocator.requestPermission();
                            if (permission == LocationPermission.denied) {
                              // Permissions are denied, next time you could try
                              // requesting permissions again (this is also where
                              // Android's shouldShowRequestPermissionRationale
                              // returned true. According to Android guidelines
                              // your App should show an explanatory UI now.
                              if (context.mounted) {
                                ToastUtils.infoToast(
                                  context.appLocalizations.warning,
                                  context.appLocalizations.unable_location,
                                );
                              }
                              await apiService.scanDoorbell(
                                bloc.state.deviceId!,
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
                              return;
                            }
                          }

                          if (permission == LocationPermission.deniedForever) {
                            // Permissions are denied forever, handle appropriately.
                            if (context.mounted) {
                              return ToastUtils.infoToast(
                                context.appLocalizations.warning,
                                context.appLocalizations.unable_location,
                              );
                            }
                            await apiService.scanDoorbell(
                              bloc.state.deviceId!,
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
                          }

                          // When we reach here, permissions are granted and we can
                          // continue accessing the position of the device.
                          final Position position =
                              await Geolocator.getCurrentPosition();
                          bloc
                            ..updateCenter(
                              LatLng(position.latitude, position.longitude),
                            )
                            ..updateMarkerPosition(
                              LatLng(position.latitude, position.longitude),
                            );
                          if (context.mounted) {
                            unawaited(
                              singletonBloc.socketEmitter(
                                roomName: Constants.doorbell,
                                roomId: bloc.state.deviceId,
                                deviceId: bloc.state.deviceId,
                                request: Constants.doorbellScanned,
                              ),
                            );
                            bloc
                              ..updateLocationName("")
                              ..updateCompanyAddress("");
                            unawaited(DoorbellMapPage.push(context));
                            await scannerController.stop();
                          }
                        }
                        // });
                      },
                    );
                  }
                } else {
                  bloc.updateScanDoorBellApi(ApiState());
                  if (context.mounted) {
                    ToastUtils.infoToast(
                      context.appLocalizations.warning,
                      "QR code not recognized. Please try again.",
                    );
                  }
                  await apiService.scanDoorbell(bloc.state.deviceId!, 0);
                  unawaited(
                    singletonBloc.socketEmitter(
                      roomName: Constants.doorbell,
                      roomId: bloc.state.deviceId,
                      deviceId: bloc.state.deviceId,
                      request: Constants.doorbellProcessTermination,
                    ),
                  );
                }
              } catch (e) {
                bloc.updateScanDoorBellApi(ApiState());
                if (context.mounted) {
                  ToastUtils.infoToast(
                    context.appLocalizations.warning,
                    context.appLocalizations.unable_location,
                  );
                }
                await apiService.scanDoorbell(bloc.state.deviceId!, 0);
                unawaited(
                  singletonBloc.socketEmitter(
                    roomName: Constants.doorbell,
                    roomId: bloc.state.deviceId,
                    deviceId: bloc.state.deviceId,
                    request: Constants.doorbellProcessTermination,
                  ),
                );
              }
            }
            // });
          },
        ),
      ),
    );
  }

  Future<void> getCameraPermission() async {
    await Permission.camera.request();
    await scannerController.start();
  }
}
