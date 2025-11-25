import 'dart:convert';
import 'dart:io';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/device_onboarding/bloc/device_onboarding_state.dart';
import 'package:admin/pages/main/device_onboarding/components/bluetooth_connection_established_dialog.dart';
import 'package:admin/pages/main/doorbell_management/scan_doorbell.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_dialog_popup.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'device_onboarding_bloc.bloc.g.dart';

final _logger = Logger('device_onboarding_bloc.dart');

@BlocGen()
class DeviceOnboardingBloc
    extends BVCubit<DeviceOnboardingState, DeviceOnboardingStateBuilder>
    with _DeviceOnboardingBlocMixin {
  DeviceOnboardingBloc() : super(DeviceOnboardingState());

  factory DeviceOnboardingBloc.of(final BuildContext context) =>
      BlocProvider.of<DeviceOnboardingBloc>(context);

  String? sessionId;

  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;
  Timer? _locationServiceCheckTimer;
  BluetoothDevice? _connectedDevice;

  final bluetoothService = Guid("00001810-0000-1000-8000-00805f9b34fb");
  BluetoothCharacteristic? _wifiListCharacteristic;

  final ssidUuid = Guid("00002a11-0000-1000-8000-00805f9b34fb");
  final passwordUuid = Guid("00002a12-0000-1000-8000-00805f9b34fb");
  final statusUuid = Guid("00002a13-0000-1000-8000-00805f9b34fb");
  final wifiUuid = Guid("00002a14-0000-1000-8000-00805f9b34fb");

  @override
  Future<void> close() {
    _scanSubscription?.cancel();
    _adapterStateSubscription?.cancel();
    _locationServiceCheckTimer?.cancel();
    return super.close();
  }

  Future<void> initializeBluetooth({String? doorbellBluetoothName}) async {
    try {
      // Show loader at the start of initialization
      Constants.showLoader();

      // Check if Bluetooth is supported
      if (!await FlutterBluePlus.isSupported) {
        updatePermissionStatus('denied');
        Constants.dismissLoader();
        return;
      }

      if (kIsWeb) {
        updatePermissionStatus('denied');
        Constants.dismissLoader();
        return;
      }

      // Step 1: Check permissions first (before requesting)
      bool hasAllPermissions = false;
      bool isLocationEnabled = false;
      bool isBluetoothEnabled = false;

      if (Platform.isAndroid) {
        // Check current permission status
        final bluetoothScanStatus = await Permission.bluetoothScan.status;
        final bluetoothConnectStatus = await Permission.bluetoothConnect.status;
        final locationStatus = await Permission.locationWhenInUse.status;

        final permissionsGranted = bluetoothScanStatus.isGranted &&
            bluetoothConnectStatus.isGranted &&
            locationStatus.isGranted;

        if (!permissionsGranted) {
          // Request permissions if not granted
          final bluetoothScanRequest = await Permission.bluetoothScan.request();
          final bluetoothConnectRequest =
              await Permission.bluetoothConnect.request();
          final locationRequest = await Permission.locationWhenInUse.request();

          hasAllPermissions = bluetoothScanRequest.isGranted &&
              bluetoothConnectRequest.isGranted &&
              locationRequest.isGranted;

          if (!hasAllPermissions) {
            updatePermissionStatus('denied');
            Constants.dismissLoader();
            return;
          }
        } else {
          hasAllPermissions = true;
        }

        // Check location service status
        isLocationEnabled = await Geolocator.isLocationServiceEnabled();
        if (!isLocationEnabled) {
          // Try to enable location programmatically (opens settings)
          await Geolocator.openLocationSettings();
          // Wait a bit and check again
          await Future.delayed(const Duration(seconds: 1));
          isLocationEnabled = await Geolocator.isLocationServiceEnabled();
          if (!isLocationEnabled) {
            // Location cannot be enabled programmatically, show denied
            updatePermissionStatus('denied');
            Constants.dismissLoader();
            // Start periodic check for when user enables it manually
            _startLocationServiceCheck(
              doorbellBluetoothName: doorbellBluetoothName,
            );
            return;
          }
        }

        // Check Bluetooth adapter state
        final adapterState = await FlutterBluePlus.adapterState.first;
        if (adapterState == BluetoothAdapterState.unauthorized) {
          updatePermissionStatus('denied');
          Constants.dismissLoader();
          return;
        }

        isBluetoothEnabled = adapterState == BluetoothAdapterState.on;
        if (!isBluetoothEnabled) {
          // Try to enable Bluetooth programmatically
          try {
            await FlutterBluePlus.turnOn();
            // Wait a bit and check again
            await Future.delayed(const Duration(milliseconds: 500));
            final newAdapterState = await FlutterBluePlus.adapterState.first;
            isBluetoothEnabled = newAdapterState == BluetoothAdapterState.on;
          } catch (e) {
            debugPrint('Cannot enable Bluetooth programmatically: $e');
            // Bluetooth cannot be enabled programmatically, show denied
            updatePermissionStatus('denied');
            Constants.dismissLoader();
            // Set up listener for when user enables it manually
            _setupBluetoothStateListener(
              doorbellBluetoothName: doorbellBluetoothName,
            );
            return;
          }
        }
      } else if (Platform.isIOS) {
        // On iOS, Bluetooth permission is handled automatically by flutter_blue_plus
        // Check location permission
        final locationStatus = await Permission.locationWhenInUse.status;
        if (!locationStatus.isGranted && !locationStatus.isLimited) {
          // Request location permission
          final locationRequest = await Permission.locationWhenInUse.request();
          if (!locationRequest.isGranted && !locationRequest.isLimited) {
            updatePermissionStatus('denied');
            Constants.dismissLoader();
            return;
          }
        }
        hasAllPermissions = true;

        // Check location service status
        isLocationEnabled = await Geolocator.isLocationServiceEnabled();
        if (!isLocationEnabled) {
          // Try to enable location programmatically (opens settings)
          await Geolocator.openLocationSettings();
          // Wait a bit and check again
          await Future.delayed(const Duration(seconds: 1));
          isLocationEnabled = await Geolocator.isLocationServiceEnabled();
          if (!isLocationEnabled) {
            // Location cannot be enabled programmatically, show denied
            updatePermissionStatus('denied');
            Constants.dismissLoader();
            // Start periodic check for when user enables it manually
            _startLocationServiceCheck(
              doorbellBluetoothName: doorbellBluetoothName,
            );
            return;
          }
        }

        // Check Bluetooth adapter state
        final adapterState = await FlutterBluePlus.adapterState.first;
        if (adapterState == BluetoothAdapterState.unauthorized) {
          updatePermissionStatus('denied');
          Constants.dismissLoader();
          return;
        }

        isBluetoothEnabled = adapterState == BluetoothAdapterState.on;
        // On iOS, we cannot enable Bluetooth programmatically
        if (!isBluetoothEnabled) {
          updatePermissionStatus('denied');
          Constants.dismissLoader();
          // Set up listener for when user enables it manually
          _setupBluetoothStateListener(
            doorbellBluetoothName: doorbellBluetoothName,
          );
          return;
        }
      }

      // Step 2: If we have all permissions and services enabled, set up listeners and start scanning
      if (hasAllPermissions && isLocationEnabled && isBluetoothEnabled) {
        // Set up Bluetooth adapter state listener
        _setupBluetoothStateListener(
          doorbellBluetoothName: doorbellBluetoothName,
        );

        // Start periodic location service check
        _startLocationServiceCheck(
          doorbellBluetoothName: doorbellBluetoothName,
        );

        updatePermissionStatus('allowed');
        updateIsBluetoothEnabled(true);
        // Directly start scanning if everything is ready
        unawaited(startScanning(doorbellBluetoothName: doorbellBluetoothName));
      } else {
        updatePermissionStatus('denied');
        Constants.dismissLoader();
      }
    } catch (e) {
      debugPrint('Error initializing Bluetooth: $e');
      updatePermissionStatus('denied');
      Constants.dismissLoader();
    }
  }

  void _setupBluetoothStateListener({String? doorbellBluetoothName}) {
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((
      adapterState,
    ) async {
      final wasEnabled = state.isBluetoothEnabled;
      final isNowEnabled = adapterState == BluetoothAdapterState.on;
      updateIsBluetoothEnabled(isNowEnabled);

      if (isNowEnabled && !wasEnabled) {
        // Bluetooth just became enabled, check if location is also enabled
        final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
        if (isLocationEnabled && state.permissionStatus == 'allowed') {
          // Both are enabled and permissions are granted, start scanning
          if (!state.isScanning) {
            // Show loader before starting scan when Bluetooth is enabled
            // Use post-frame callback to ensure UI is ready
            Constants.showLoader();
            unawaited(
              startScanning(doorbellBluetoothName: doorbellBluetoothName),
            );
          }
        } else if (isLocationEnabled) {
          // Location is enabled, check permissions again
          await _checkAndUpdatePermissions(
            doorbellBluetoothName: doorbellBluetoothName,
          );
        }
      } else if (!isNowEnabled) {
        // Bluetooth was disabled
        updateIsBluetoothConnected(false);
        updateConnectedDeviceId(null);
        _connectedDevice = null;
        if (state.isScanning) {
          await stopScanning();
        }
      }
    });
  }

  void _startLocationServiceCheck({String? doorbellBluetoothName}) {
    _locationServiceCheckTimer?.cancel();
    _locationServiceCheckTimer = Timer.periodic(const Duration(seconds: 2), (
      timer,
    ) async {
      if (state.permissionStatus == 'denied') {
        final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
        final adapterState = await FlutterBluePlus.adapterState.first;
        final isBluetoothEnabled = adapterState == BluetoothAdapterState.on;

        if (isLocationEnabled && isBluetoothEnabled) {
          // Both services are now enabled, check permissions
          await _checkAndUpdatePermissions(
            doorbellBluetoothName: doorbellBluetoothName,
          );
        }
      } else {
        // Permissions are already allowed, stop checking
        timer.cancel();
      }
    });
  }

  Future<void> _checkAndUpdatePermissions({
    String? doorbellBluetoothName,
  }) async {
    if (kIsWeb) {
      return;
    }

    bool hasAllPermissions = false;

    if (Platform.isAndroid) {
      final bluetoothScanStatus = await Permission.bluetoothScan.status;
      final bluetoothConnectStatus = await Permission.bluetoothConnect.status;
      final locationStatus = await Permission.locationWhenInUse.status;

      hasAllPermissions = bluetoothScanStatus.isGranted &&
          bluetoothConnectStatus.isGranted &&
          locationStatus.isGranted;
    } else if (Platform.isIOS) {
      final locationStatus = await Permission.locationWhenInUse.status;
      hasAllPermissions = locationStatus.isGranted || locationStatus.isLimited;
    }

    if (hasAllPermissions) {
      final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      final adapterState = await FlutterBluePlus.adapterState.first;
      final isBluetoothEnabled = adapterState == BluetoothAdapterState.on;

      if (isLocationEnabled && isBluetoothEnabled) {
        // Set up bluetooth listener if not already set up
        if (_adapterStateSubscription == null) {
          _setupBluetoothStateListener(
            doorbellBluetoothName: doorbellBluetoothName,
          );
        }

        updatePermissionStatus('allowed');
        updateIsBluetoothEnabled(true);
        _locationServiceCheckTimer?.cancel();
        // Start scanning now that everything is ready
        if (!state.isScanning) {
          // Show loader before starting scan when coming back from settings
          // Use post-frame callback to ensure UI is ready after returning from settings
          Constants.showLoader();
          unawaited(
            startScanning(doorbellBluetoothName: doorbellBluetoothName),
          );
        }
      }
    }
  }

  Future<void> startScanning({String? doorbellBluetoothName}) async {
    if (state.isScanning) {
      return;
    }

    BluetoothDevice? bluetoothDevice;

    try {
      // Ensure loader is showing (it should already be from initializeBluetooth)
      Constants.showLoader();
      updateIsScanning(true);
      updateScannedDevices(BuiltList<BluetoothDevice>([]));

      // Verify Bluetooth is enabled and permissions are granted
      final adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState != BluetoothAdapterState.on) {
        debugPrint('Bluetooth is not enabled, cannot start scanning');
        updateIsScanning(false);
        Constants.dismissLoader();
        return;
      }

      // Verify location is enabled
      final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        debugPrint('Location is not enabled, cannot start scanning');
        updateIsScanning(false);
        Constants.dismissLoader();
        return;
      }

      // Listen to scan results
      _scanSubscription = FlutterBluePlus.onScanResults.listen(
        (results) {
          if (results.isNotEmpty) {
            final devices = results
                .map((result) => result.device)
                .where(
                  (device) => device.platformName.toLowerCase().contains(
                        doorbellBluetoothName?.toLowerCase() ?? 'irvinei',
                      ),
                )
                .toList();
            updateScannedDevices(BuiltList<BluetoothDevice>(devices));
            if (doorbellBluetoothName != null) {
              bluetoothDevice = devices.firstWhereOrNull(
                (e) => e.platformName.contains(doorbellBluetoothName),
              );
              if (bluetoothDevice != null) {
                final navigatorState = singletonBloc.navigatorKey?.currentState;
                if (navigatorState != null) {
                  final context = navigatorState.context;
                  try {
                    if (context.mounted) {
                      unawaited(
                        connectToDevice(
                          context,
                          bluetoothDevice!,
                          needConnectionDialog: false,
                        ),
                      );
                      stopScanning();
                    }
                  } catch (e) {
                    _logger.fine(e.toString());
                  }
                }
              }
            }
          }
        },
        onError: (e) {
          debugPrint('Scan error: $e');
          updateIsScanning(false);
          Constants.dismissLoader();
        },
      );

      // Start scanning with timeout
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 20),
        androidUsesFineLocation: true,
      );

      // Wait for scanning to complete (timeout or manual stop)
      await FlutterBluePlus.isScanning.where((val) => !val).first;
      unawaited(stopScanning());
      // updateIsScanning(false);
      // Dismiss loader when scanning completes
      if (doorbellBluetoothName != null && bluetoothDevice == null) {
        final navigatorState = singletonBloc.navigatorKey?.currentState;
        if (navigatorState != null) {
          final context = navigatorState.context;
          try {
            if (context.mounted) {
              Navigator.pop(context);
            }
          } catch (e) {
            _logger.fine(e.toString());
          }
        }
        ToastUtils.errorToast(
          "Error in getting wifi list. Please try again...",
        );
      }
      // Constants.dismissLoader();
      debugPrint(state.scannedDevices.toString());
    } catch (e) {
      debugPrint('Error starting scan: $e');
      unawaited(stopScanning());
    }
  }

  Future<void> stopScanning() async {
    if (!state.isScanning) {
      return;
    }

    try {
      await _scanSubscription?.cancel();
      await FlutterBluePlus.stopScan();
      updateIsScanning(false);
      Constants.dismissLoader();
    } catch (e) {
      debugPrint('Error stopping scan: $e');
      updateIsScanning(false);
      Constants.dismissLoader();
    }
  }

  Future<void> connectToDevice(
    BuildContext context,
    BluetoothDevice device, {
    bool needConnectionDialog = true,
  }) async {
    if (state.isConnecting) {
      return;
    }

    try {
      updateIsConnecting(true);

      // Disconnect previous device if any
      if (_connectedDevice != null && _connectedDevice!.isConnected) {
        await disconnectDevice();
      }

      // Connect to new device
      await device.connect(license: License.free);
      _connectedDevice = device;
      updateIsBluetoothConnected(true);
      updateConnectedDeviceId(device.remoteId.toString());

      // Discover services
      final services = await device.discoverServices();

      for (final service in services) {
        if (service.serviceUuid.str == bluetoothService.str) {
          _wifiListCharacteristic = service.characteristics.firstWhere(
            (e) => e.characteristicUuid.str == wifiUuid.str,
          );
          if (needConnectionDialog) {
            if (context.mounted) {
              unawaited(
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (dialogContext) {
                    return BluetoothConnectionEstablishedDialog(
                      dialogContext: dialogContext,
                      navigationContext: context,
                    );
                  },
                ),
              );
            }
          }
          await _startListeningToWifiList();
        }
      }

      // Listen to connection state changes
      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          disconnectDevice();
          debugPrint("$device disconnected");
          // updateWifiNetworks(BuiltList<String>()); // clear list
        }
      });
    } catch (e) {
      debugPrint('Error connecting to device: $e');
      updateIsBluetoothConnected(false);
      updateConnectedDeviceId(null);
      _connectedDevice = null;
      if (context.mounted && state.isConnecting) {
        unawaited(connectToDevice(context, device));
      }
    } finally {
      updateIsConnecting(false);
    }
  }

  Future<void> disconnectDevice() async {
    if (_connectedDevice != null && _connectedDevice!.isConnected) {
      try {
        await _connectedDevice!.disconnect();
        updateIsBluetoothConnected(false);
        updateConnectedDeviceId(null);
        _connectedDevice = null;
      } catch (e) {
        debugPrint('Error disconnecting device: $e');
      }
    }
  }

  Future<void> sendWifiCredentials({
    required String ssid,
    required String pwd,
  }) async {
    if (_connectedDevice == null || !_connectedDevice!.isConnected) {
      debugPrint("No connected Bluetooth device");
      return;
    }

    try {
      final List<BluetoothService> services =
          await _connectedDevice!.discoverServices();

      BluetoothCharacteristic? ssidChar;
      BluetoothCharacteristic? pwdChar;

      for (final service in services) {
        for (final c in service.characteristics) {
          if (c.uuid == ssidUuid) {
            ssidChar = c;
          }
          if (c.uuid == passwordUuid) {
            pwdChar = c;
          }
        }
      }

      if (ssidChar == null || pwdChar == null) {
        debugPrint("SSID or PASSWORD characteristic not found");
        return;
      }

      await ssidChar.write(utf8.encode(ssid));
      await pwdChar.write(utf8.encode(pwd));

      // updateSelectedWifiSsid(ssid);
      debugPrint("Sent Wi-Fi credentials: $ssid / $pwd");
    } catch (e) {
      ToastUtils.errorToast("Error in sending wifi credentials");
      debugPrint("Error sending Wi-Fi credentials: $e");
    }
  }

  // Future<void> requestPermissionsManually(BuildContext context) async {
  //   try {
  //     // Request permissions manually using permission_handler
  //     final bluetoothScanStatus = await Permission.bluetoothScan.request();
  //     final bluetoothConnectStatus =
  //         await Permission.bluetoothConnect.request();
  //     final locationStatus = await Permission.locationWhenInUse.request();
  //
  //     debugPrint('Permission status:');
  //     debugPrint('Bluetooth Scan: $bluetoothScanStatus');
  //     debugPrint('Bluetooth Connect: $bluetoothConnectStatus');
  //     debugPrint('Location: $locationStatus');
  //
  //     // Re-initialize Bluetooth after requesting permissions
  //     await initializeBluetooth(context);
  //   } catch (e) {
  //     debugPrint('Error requesting permissions: $e');
  //   }
  // }

  Future<void> openAppSettingsForPermissions() async {
    await openAppSettings();
  }

  Future<void> requestBluetoothEnable() async {
    try {
      await FlutterBluePlus.turnOn();
    } catch (e) {
      debugPrint('Error turning on Bluetooth: $e');
    }
  }

  Future<void> _startListeningToWifiList() async {
    if (_wifiListCharacteristic == null) {
      debugPrint("⚠️ No Wi-Fi list characteristic found.");
      return;
    }

    try {
      // await _wifiListCharacteristic?.setNotifyValue(true);

      final stopwatch = Stopwatch()..start();
      bool isSuccess = false;

      debugPrint("📡 Continuously reading Wi-Fi list characteristic...");

      while (stopwatch.elapsed.inSeconds < 30 && !isSuccess) {
        try {
          final value = await _wifiListCharacteristic!.read();

          if (value.isNotEmpty) {
            final decoded = utf8.decode(value).trim();
            debugPrint("🔹 Raw Wi-Fi Data: $decoded");

            // Parse and validate JSON
            final dataObj = jsonDecode(decoded);
            final ssids = dataObj["list"].cast<String>();
            updateWifiNetworks(BuiltList<String>(ssids));
            debugPrint("📶 Received Wi-Fi list: $ssids");
            isSuccess = true;
          }
        } catch (e) {
          debugPrint("Error parsing Wi-Fi list: $e");
        }

        // Wait a bit before next poll (avoid hammering BLE)
        await Future.delayed(const Duration(seconds: 1));
      }

      Constants.dismissLoader();

      if (!isSuccess) {
        debugPrint("⏹️ No Wi-Fi list received within 30s.");
        ToastUtils.errorToast("No Wi-Fi list received. Please try again.");
      }
    } catch (e) {
      debugPrint("❌ Error listening to Wi-Fi list: $e");
      ToastUtils.errorToast("Error in listening to Wi-Fi list");
      Constants.dismissLoader();
    }
  }

  void showWifiConnectionFailedDialog(BuildContext pageContext) {
    unawaited(
      showDialog(
        context: pageContext,
        builder: (dialogContext) {
          return AppDialogPopup(
            title: "Wi-Fi Connection Failed",
            description: "Please check your Wi-Fi and try again.",
            confirmButtonLabel: "Try again",
            confirmButtonOnTap: () {
              Navigator.pop(dialogContext);
            },
          );
        },
      ),
    );
  }

  void showWifiConnectedDialog(
    BuildContext pageContext, {
    required VoidCallback performFunction,
  }) {
    unawaited(
      showDialog(
        context: pageContext,
        builder: (dialogContext) {
          return AppDialogPopup(
            title:
                "Please note: All connected IoT devices must also be shifted to the new Wi-Fi network to function properly.",
            confirmButtonLabel: "Ok",
            confirmButtonOnTap: () {
              Navigator.pop(dialogContext);
              performFunction();
            },
          );
        },
      ),
    );
  }

  Future<void> listenToStatusUpdates({
    required String connectingSSID,
    required BuildContext pageContext,
    required BuildContext bottomSheetContext,
    required bool fromDoorbellControlPage,
  }) async {
    if (_connectedDevice == null || !_connectedDevice!.isConnected) {
      debugPrint("⚠️ No connected Bluetooth device");
      return;
    }

    updateIsWifiConnecting(true);
    Constants.showLoader(); // ✅ Ensure loader shows when starting

    try {
      final services = await _connectedDevice!.discoverServices();
      final statusChar = services
          .where((s) => s.serviceUuid.str == bluetoothService.str)
          .expand((s) => s.characteristics)
          .firstWhere(
            (c) => c.characteristicUuid.str == statusUuid.str,
          );

      debugPrint("📡 Started listening to STATUS characteristic...");

      final stopwatch = Stopwatch()..start();
      // bool isSuccess = false;
      bool responseReceived = false;

      while (stopwatch.elapsed.inSeconds < 60 && !responseReceived) {
        final value = await statusChar.read();
        if (value.isEmpty) {
          await Future.delayed(const Duration(seconds: 1));
          continue;
        }

        final decoded = utf8.decode(value).trim().toLowerCase();
        debugPrint("🔄 STATUS Update: $decoded");

        switch (decoded) {
          case 'connected':
            // isSuccess = true;
            responseReceived = true;
            if (pageContext.mounted) {
              unawaited(
                _handleWifiConnected(
                  connectingSSID: connectingSSID,
                  pageContext: pageContext,
                  fromDoorbellControlPage: fromDoorbellControlPage,
                ),
              );
            }

          case 'failed':
            responseReceived = true;
            if (pageContext.mounted) {
              unawaited(_handleWifiFailed(pageContext));
            }

          default:
            // Continue polling until timeout or valid response
            await Future.delayed(const Duration(seconds: 1));
        }
      }

      if (!responseReceived) {
        debugPrint("⏹️ STATUS not received after 30s.");
        if (pageContext.mounted) {
          await _handleWifiTimeout(pageContext);
        }
      }
    } catch (e) {
      debugPrint("❌ Error listening to STATUS updates: $e");
      Constants.dismissLoader();
      updateIsWifiConnecting(false);
      ToastUtils.errorToast(
        "Error listening for Wi-Fi response from doorbell.",
      );
    } finally {
      debugPrint("🛑 STATUS listening stopped.");
      updateIsWifiConnecting(false);
      Constants.dismissLoader();

      // Close bottom sheet safely
      if (bottomSheetContext.mounted) {
        Navigator.pop(bottomSheetContext);
      }
    }
  }

  Future<void> _handleWifiConnected({
    required String connectingSSID,
    required BuildContext pageContext,
    required bool fromDoorbellControlPage,
  }) async {
    debugPrint("✅ Doorbell Wi-Fi connected successfully!");

    Future.delayed(const Duration(seconds: 5), disconnectDevice);
    updateConnectedSsid(connectingSSID);
    updateIsDoorbellWifiConnected(true);
    updateIsWifiConnecting(false);
    Constants.dismissLoader();

    if (pageContext.mounted) {
      showWifiConnectedDialog(
        pageContext,
        performFunction: () {
          try {
            if (fromDoorbellControlPage) {
              Navigator.pop(pageContext);
            } else {
              ScanDoorbell.pushReplacement(pageContext);
            }
          } catch (e) {
            _logger.fine("Navigation issue after connected: $e");
          }
        },
      );
    }
  }

  Future<void> _handleWifiFailed(BuildContext pageContext) async {
    debugPrint("❌ Doorbell Wi-Fi connection failed.");
    updateConnectedSsid(null);
    updateIsWifiConnecting(false);
    Constants.dismissLoader();

    if (pageContext.mounted) {
      showWifiConnectionFailedDialog(pageContext);
    }
  }

  Future<void> _handleWifiTimeout(BuildContext pageContext) async {
    debugPrint("⏳ Doorbell Wi-Fi response timeout.");
    updateConnectedSsid(null);
    updateIsWifiConnecting(false);
    Constants.dismissLoader();

    if (pageContext.mounted) {
      showWifiConnectionFailedDialog(pageContext);
    }
  }

  Future<void> getWifiList() async {
    await CubitUtils.makeSocketCall<DeviceOnboardingState,
        DeviceOnboardingStateBuilder, Map<String, dynamic>>(
      cubit: this,
      apiState: state.getWifiResponse,
      updateApiState: (b, apiState) => b.getWifiResponse.replace(apiState),
      socket: singletonBloc.socket!,
      eventName: Constants.doorbell,
      responseEvent: Constants.doorbell,
      command: Constants.wifiList,
      timeout: const Duration(seconds: 10),
      onError: (_) {
        updateConnectedSsid(null);
        updateIsDoorbellWifiConnected(false);
        updateCheckDoorbellWifiConnection(false);
      },
      onSuccess: (data) {
        updateCheckDoorbellWifiConnection(true);
        final dataObj = jsonDecode(data["data"]);
        final ssids = dataObj["list"].cast<String>();
        updateWifiNetworks(BuiltList<String>(ssids));
        updateConnectedSsid(dataObj["current"]);
        updateIsDoorbellWifiConnected(true);
        updateCheckDoorbellWifiConnection(false);
      },
    );
  }

  Future<void> updateWifiState({
    required String ssid,
    required String pwd,
    required BuildContext bottomSheetContext,
    required BuildContext pageContext,
  }) async {
    updateIsWifiConnecting(true);
    await CubitUtils.makeSocketCall<DeviceOnboardingState,
        DeviceOnboardingStateBuilder, Map<String, dynamic>>(
      cubit: this,
      apiState: state.getWifiResponse,
      updateApiState: (b, apiState) => b.getWifiResponse.replace(apiState),
      socket: singletonBloc.socket!,
      eventName: Constants.doorbell,
      message: {"ssid": ssid, "password": pwd},
      responseEvent: Constants.wifiChange,
      command: Constants.wifiChange,
      timeout: const Duration(seconds: 60),
      onError: (_) {
        updateIsWifiConnecting(false);
        Constants.dismissLoader();
        Navigator.maybePop(bottomSheetContext);
        if (pageContext.mounted) {
          showWifiConnectionFailedDialog(pageContext);
        }
      },
      onSuccess: (data) {
        if (data["status"] ?? false) {
          updateConnectedSsid(ssid);
          updateIsWifiConnecting(false);
          Navigator.maybePop(bottomSheetContext);
          Constants.dismissLoader();
          showWifiConnectedDialog(
            pageContext,
            performFunction: () {
              if (pageContext.mounted) {
                Navigator.pop(pageContext);
              }
            },
          );
        } else {
          updateConnectedSsid(null);
          Constants.dismissLoader();
          updateIsWifiConnecting(false);
          Navigator.maybePop(bottomSheetContext);
          if (pageContext.mounted) {
            showWifiConnectionFailedDialog(pageContext);
          }
        }
      },
    );
  }
}
