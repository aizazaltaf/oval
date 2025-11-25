import 'package:flutter/material.dart';

Widget statisticsShimmerWidget(double height, double value, double width) {
  return SizedBox(
    height: height,
    width: width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: (value / 40) * height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    ),
  );
}
