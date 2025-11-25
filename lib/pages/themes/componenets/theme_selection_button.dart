import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThemeSelectionButton extends StatelessWidget {
  const ThemeSelectionButton({
    super.key,
    this.icon,
    this.iconColor,
    required this.image,
    required this.title,
    required this.onPressed,
  });
  final String? icon;
  final Color? iconColor;
  final String image;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 22,
            child: icon == null
                ? Center(
                    child: SvgPicture.asset(
                      image,
                      colorFilter: ColorFilter.mode(
                        iconColor ?? Theme.of(context).primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                : Image.asset(icon!),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
