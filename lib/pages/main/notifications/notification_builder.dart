import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NotificationBuilder extends StatelessWidget {
  const NotificationBuilder({super.key, this.status = false});
  final bool status;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: null,
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Stack(
        children: [
          Icon(
            MdiIcons.bell,
            size: 24,
            color: CommonFunctions.getThemeBasedWidgetColor(context),
          ),
          if (status)
            const Positioned(
              top: 1,
              right: 1,
              child: Icon(
                Icons.circle,
                color: Colors.red,
                size: 12,
              ),
            ),
        ],
      ),
    );
  }
}
