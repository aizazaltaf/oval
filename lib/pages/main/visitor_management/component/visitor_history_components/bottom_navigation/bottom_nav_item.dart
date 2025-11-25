import 'package:admin/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    super.key,
    required this.title,
    required this.onTap,
    this.needDisabled = false,
    required this.icon,
  });
  final String title;
  final VoidCallback onTap;
  final bool needDisabled;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: getVisitorHistoryModesMenuItemColor(context, needDisabled),
          ),
          SizedBox(
            height: 1.h,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              width: 23.5.w,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 12,
                      color: getVisitorHistoryModesMenuItemColor(
                        context,
                        needDisabled,
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color getVisitorHistoryModesMenuItemColor(
    BuildContext context,
    bool needDisabled,
  ) {
    return Theme.of(context).brightness == Brightness.light
        ? needDisabled
            ? AppColors.cancelButtonColor
            : AppColors.darkBlueColor
        : needDisabled
            ? AppColors.cancelButtonColor
            : Colors.white;
  }
}
