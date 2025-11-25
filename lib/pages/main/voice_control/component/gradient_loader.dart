import 'package:flutter/material.dart';

class GradientLoader extends StatelessWidget {
  const GradientLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        strokeWidth: 4.5,
        backgroundColor: const Color.fromRGBO(68, 206, 255, 1), // track color
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ),
    );
  }
}
