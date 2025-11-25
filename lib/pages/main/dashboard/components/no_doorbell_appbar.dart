import 'dart:async';

import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/device_onboarding/bluetooth_scan_page.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NoDoorbellAppbar extends StatelessWidget {
  const NoDoorbellAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = CommonFunctions.getThemeBasedWidgetColor(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            'G',
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white, fontSize: 24),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.appLocalizations.welcome,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  MdiIcons.mapMarkerOutline,
                  size: 20,
                  color: themeColor,
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    // unawaited(ScanDoorbell.push(context));
                    unawaited(BluetoothScanPage.push(context));
                  },
                  child: Text(
                    context.appLocalizations.add_doorbell_to_view_location,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 15,
                        ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: themeColor,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
