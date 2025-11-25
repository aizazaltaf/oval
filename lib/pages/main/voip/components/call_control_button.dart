import 'package:flutter/material.dart';

class CallControlButton extends StatelessWidget {
  const CallControlButton({
    super.key,
    required this.isActive,
    required this.isCallConnected,
    required this.icon,
    required this.onPressed,
    this.iconActiveColor,
    this.iconInActiveColor,
    this.buttonBGActiveColor,
    this.buttonBGInActiveColor,
  });
  final bool isActive;
  final bool isCallConnected;
  final IconData icon;
  final Color? iconActiveColor;
  final Color? iconInActiveColor;
  final Color? buttonBGActiveColor;
  final Color? buttonBGInActiveColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: !isCallConnected
            ? const Color.fromRGBO(239, 239, 239, 1)
            : isActive
                ? buttonBGActiveColor ?? const Color.fromRGBO(0, 130, 176, 0.1)
                : buttonBGInActiveColor ??
                    const Color.fromRGBO(0, 130, 176, 0.1),
        child: Icon(
          icon,
          size: 22,
          color: !isCallConnected
              ? const Color.fromRGBO(161, 161, 161, 1)
              : isActive
                  ? iconActiveColor ?? Theme.of(context).primaryColor
                  : iconInActiveColor ?? const Color.fromRGBO(161, 161, 161, 1),
        ),
      ),
    );
  }
}
