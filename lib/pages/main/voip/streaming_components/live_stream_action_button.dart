import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LiveStreamActionButton extends StatelessWidget {
  const LiveStreamActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.padding = 6.0,
  });
  final VoidCallback onPressed;
  final String icon;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF7e869a),
          shape: BoxShape.circle,
        ),
        width: 40,
        padding: EdgeInsets.all(padding),
        child: SvgPicture.asset(
          icon,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
          width: 25,
          height: 25,
        ),
      ),
    );
  }
}
