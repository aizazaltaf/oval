import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/dashboard/components/camera_settings_tile.dart';
import 'package:admin/pages/main/device_onboarding/bloc/device_onboarding_bloc.dart';
import 'package:admin/pages/main/device_onboarding/components/wifi_bottomsheet.dart';
import 'package:admin/pages/main/iot_devices/components/app_switch.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/list_view_seperated.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:flutter/material.dart';

class WifiListPage extends StatelessWidget {
  const WifiListPage({
    super.key,
    required this.fromDoorbellControlsPage,
    this.isDoorbellWifiConnected = false,
  });

  final bool fromDoorbellControlsPage;
  final bool isDoorbellWifiConnected;

  static const routeName = "WifiListPage";

  static Future<void> push(
    final BuildContext context, {
    bool isDoorbellWifiConnected = false,
    bool fromDoorbellControlsPage = false,
  }) {
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => WifiListPage(
        fromDoorbellControlsPage: fromDoorbellControlsPage,
        isDoorbellWifiConnected: isDoorbellWifiConnected,
      ),
    );
  }

  static Future<void> pushReplacement(
    final BuildContext context, {
    bool isDoorbellWifiConnected = false,
    bool fromDoorbellControlsPage = false,
  }) {
    return pushReplacementMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => WifiListPage(
        fromDoorbellControlsPage: fromDoorbellControlsPage,
        isDoorbellWifiConnected: isDoorbellWifiConnected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceOnboardingBloc = DeviceOnboardingBloc.of(context);
    return AppScaffold(
      appTitle: fromDoorbellControlsPage
          ? "Wifi"
          : context.appLocalizations.add_doorbell,
      onBackPressed: () {
        DeviceOnboardingBloc.of(context).disconnectDevice();
        Navigator.pop(context);
      },
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            _buildWifiStatusCard(context),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).disabledColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.appLocalizations.ble_wifi_desc,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              context.appLocalizations.available_wifi,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            _buildWifiList(context, deviceOnboardingBloc),
          ],
        ),
      ),
    );
  }

  Widget _buildWifiStatusCard(BuildContext context) {
    return DeviceOnboardingBlocSelector.connectedSSID(
      builder: (connectedSSID) {
        if (connectedSSID == null) {
          return CameraSettingTile(
            isCard: true,
            isDisabled: false,
            title: "Wifi",
            trailing: AppSwitchWidget(
              thumbSize: 18,
              value: true,
              onChanged: (value) {},
            ),
          );
        }
        return Card(
          color: CommonFunctions.getReverseThemeBasedWidgetColor(context),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text("Wifi", style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.check, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(
                      connectedSSID,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWifiList(
    BuildContext pageContext,
    DeviceOnboardingBloc deviceOnboardingBloc,
  ) {
    final reverseThemeWidgetColor =
        CommonFunctions.getReverseThemeBasedWidgetColor(pageContext);
    return DeviceOnboardingBlocSelector(
      selector: (state) => state.wifiNetworks,
      builder: (wifiNetworks) {
        if (wifiNetworks.isEmpty) {
          return Container(
            alignment: Alignment.center,
            child: const Text("Waiting for Wi-Fi list..."),
          );
        }

        return Card(
          color: reverseThemeWidgetColor,
          child: ListViewSeparatedWidget(
            list: wifiNetworks,
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              if (index == wifiNetworks.length - 1) {
                return const SizedBox.shrink();
              }
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(),
              );
            },
            itemBuilder: (itemContext, index) {
              final ssid = wifiNetworks[index];
              return ListTile(
                title: Text(ssid),
                onTap: () {
                  deviceOnboardingBloc
                    ..updateIsWifiConnecting(false)
                    ..updateWifiPassword("");
                  showModalBottomSheet(
                    showDragHandle: true,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    backgroundColor: reverseThemeWidgetColor,
                    elevation: 8,
                    context: pageContext,
                    builder: (bottomSheetContext) {
                      return WifiBottomSheet(
                        ssid: ssid,
                        deviceOnboardingBloc: deviceOnboardingBloc,
                        bottomSheetContext: bottomSheetContext,
                        fromDoorbellControlPage: fromDoorbellControlsPage,
                        pageContext: pageContext,
                        isDoorbellWifiConnected: isDoorbellWifiConnected,
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
