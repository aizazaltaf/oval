import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/dashboard/components/camera_settings_tile.dart';
import 'package:admin/pages/main/device_onboarding/bloc/device_onboarding_bloc.dart';
import 'package:admin/pages/main/device_onboarding/components/ble_connection_device_not_found_dialog.dart';
import 'package:admin/pages/main/doorbell_management/scan_doorbell.dart';
import 'package:admin/pages/main/iot_devices/components/app_switch.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/list_view_seperated.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScanPage extends StatefulWidget {
  const BluetoothScanPage({super.key, required this.deviceName});

  static const routeName = "BluetoothScan";

  final String deviceName;

  static Future<void> push(final BuildContext context) async {
    final name = await CommonFunctions.getDeviceName();
    if (context.mounted) {
      return pushMaterialPageRoute(
        context,
        name: routeName,
        builder: (final _) => BluetoothScanPage(
          deviceName: name,
        ),
      );
    }
  }

  @override
  State<BluetoothScanPage> createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage> {
  late DeviceOnboardingBloc deviceOnboardingBloc;

  late String? deviceName;

  @override
  void initState() {
    super.initState();
    deviceOnboardingBloc = DeviceOnboardingBloc.of(context);
    deviceOnboardingBloc
      ..updatePermissionStatus("checking")
      ..updateConnectedSsid(null)
      ..initializeBluetooth();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      backgroundColor:
          Theme.of(context).cupertinoOverrideTheme!.barBackgroundColor,
      onRefresh: () async {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Show your dashboard call
          deviceOnboardingBloc.startScanning();
        });

        // Return completed future so RefreshIndicator hides instantly
        return Future.value();
      },
      child: AppScaffold(
        appTitle: context.appLocalizations.add_doorbell,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 40,
          ),
          child: CustomGradientButton(
            onSubmit: () {
              ScanDoorbell.pushReplacement(context);
            },
            label: context.appLocalizations.scan_doorbell,
          ),
        ),
        onBackPressed: () {
          DeviceOnboardingBloc.of(context)
            ..disconnectDevice()
            ..updateIsScanning(false);
          Navigator.pop(context);
        },
        body: DeviceOnboardingBlocSelector(
          selector: (state) => state.permissionStatus,
          builder: (permissionStatus) {
            if (permissionStatus == 'checking') {
              return const SizedBox.shrink();
            }

            if (permissionStatus == 'denied') {
              return _buildPermissionDeniedView();
            }

            return DeviceOnboardingBlocSelector(
              selector: (state) => state.isBluetoothEnabled,
              builder: (isBluetoothEnabled) {
                if (!isBluetoothEnabled) {
                  return _buildBluetoothDisabledView();
                }
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildBluetoothScanView(),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPermissionDeniedView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bluetooth_disabled,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              "Bluetooth & Location Permissions Required",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "This app needs both Bluetooth and Location permissions to scan for devices.\n\n"
              "Please grant both permissions when prompted, or enable them manually in your device settings.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBluetoothDisabledView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bluetooth_disabled,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              context.appLocalizations.bluetooth_disabled,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              context.appLocalizations.bluetooth_enable_description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            CustomGradientButton(
              onSubmit: () {
                DeviceOnboardingBloc.of(context).requestBluetoothEnable();
              },
              label: context.appLocalizations.enable_bluetooth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBluetoothScanView() {
    return ListView(
      children: [
        _buildBluetoothStatusCard(),
        const SizedBox(height: 20),
        Text(
          context.appLocalizations.available_devices,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        DeviceOnboardingBlocSelector.isScanning(
          builder: (isScanning) {
            if (isScanning) {
              return const SizedBox.shrink();
            }
            return _buildDeviceList();
          },
        ),
      ],
    );
  }

  Widget _buildBluetoothStatusCard() {
    return DeviceOnboardingBlocSelector(
      selector: (state) => state.isBluetoothEnabled,
      builder: (isBluetoothEnabled) {
        return Card(
          color: CommonFunctions.getReverseThemeBasedWidgetColor(context),
          child: Column(
            children: [
              CameraSettingTile(
                isDisabled: false,
                title: "Bluetooth",
                trailing: AppSwitchWidget(
                  thumbSize: 18,
                  value: isBluetoothEnabled,
                  onChanged: (value) {
                    final bloc = DeviceOnboardingBloc.of(context);
                    if (value) {
                      bloc.requestBluetoothEnable();
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Device Name",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.deviceName.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: Theme.of(context).disabledColor,
                              ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeviceList() {
    return DeviceOnboardingBlocSelector(
      selector: (state) => state.scannedDevices,
      builder: (devices) {
        if (devices.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (dialogContext) {
                return BleConnectionDeviceNotFoundDialog(
                  dialogContext: dialogContext,
                );
              },
            );
          });
          return Container(
            margin: const EdgeInsets.only(top: 200),
            alignment: Alignment.center,
            child: Text(
              context.appLocalizations.no_ble_devices_found,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          );
        }

        return Card(
          color: CommonFunctions.getReverseThemeBasedWidgetColor(context),
          child: ListViewSeparatedWidget(
            list: devices,
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              if (index == devices.length - 1) {
                return const SizedBox.shrink();
              }
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(),
              );
            },
            itemBuilder: (context, index) {
              final device = devices[index];
              return _buildDeviceTile(device);
            },
          ),
        );
      },
    );
  }

  Widget _buildDeviceTile(BluetoothDevice device) {
    return DeviceOnboardingBlocSelector(
      selector: (state) => state.connectedDeviceId,
      builder: (connectedDeviceId) {
        final isConnected = connectedDeviceId == device.remoteId.toString();
        final bloc = DeviceOnboardingBloc.of(context);
        return ListTile(
          onTap: () => bloc.connectToDevice(context, device),
          title: Text(
            device.platformName.isNotEmpty
                ? device.platformName
                : context.appLocalizations.unknown_device,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          trailing: DeviceOnboardingBlocSelector(
            selector: (state) => state.isConnecting,
            builder: (isConnecting) {
              if (isConnecting) {
                return const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }

              if (isConnected) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    Text(
                      context.appLocalizations.connected,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.green,
                          ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
