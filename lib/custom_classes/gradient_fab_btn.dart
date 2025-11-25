import 'package:flutter/material.dart';

class GradientFloatingButton extends StatelessWidget {
  const GradientFloatingButton({
    super.key,
    required this.child,
    this.padding,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor,
            spreadRadius: 1,
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment(0.8, 0),
          colors: <Color>[
            Color.fromRGBO(4, 130, 176, 1),
            Color.fromRGBO(4, 130, 176, 1),
            // Color.fromRGBO(0, 130, 176, 1),
          ], // red to yellow
        ),
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}
