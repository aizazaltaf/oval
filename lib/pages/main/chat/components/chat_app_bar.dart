import 'package:admin/core/images.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_profile_image.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  ChatAppBar({super.key, this.visitor});

  VisitorsModel? visitor;

  // Required when using AppBar inside Scaffold
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    String visitorName = visitor?.name ?? "Unknown";
    if (visitorName.contains("A new visitor")) {
      visitorName = "Unknown";
    }
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.black,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            color: CommonFunctions.getThemeBasedWidgetColor(context),
            size: 30,
          ),
        ),
      ),
      leadingWidth: 30,
      title: Row(
        children: [
          if (visitor != null)
            VisitorProfileImage(
              visitor: visitor!,
              size: 40,
            )
          else
            ClipOval(
              child: Image.asset(
                fit: BoxFit.cover,
                height: 40,
                width: 40,
                DefaultImages.USER_IMG_PLACEHOLDER,
              ),
            ),
          const SizedBox(width: 12),
          Text(
            visitorName,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
          ),
        ],
      ),
    );
  }
}
