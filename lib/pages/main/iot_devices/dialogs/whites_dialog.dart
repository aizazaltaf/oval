import 'dart:math';

import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class WhitesDialog extends StatefulWidget {
  const WhitesDialog({super.key, required this.bloc});

  final IotBloc bloc;

  @override
  State<WhitesDialog> createState() => _WhitesDialogState();
}

class _WhitesDialogState extends State<WhitesDialog> {
  List<Color> availableWhitesColors = [
    AppColors.lightWhitesBlockPicker1,
    AppColors.lightWhitesBlockPicker2,
    AppColors.lightWhitesBlockPicker3,
    AppColors.lightWhitesBlockPicker4,
    AppColors.lightWhitesBlockPicker5,
    AppColors.lightWhitesBlockPicker6,
    AppColors.lightWhitesBlockPicker7,
  ];

  final List<String> colorNames = [
    "Very Warm Yellow",
    "Soft Yellow",
    "Pale Yellow",
    "Daylight White",
    "Cool White",
    "Warm White",
    "Neutral White",
  ];

  void changeWhitesColor(Color color) {
    whitesColor = color;
    lastWhiteBlockPicker = true;
  }

  bool lastWhiteBlockPicker = false;
  Color whitesColor = AppColors.lightWhitesBlockPicker1;
  String selectedWhiteColorName = "Very Warm Yellow";

  @override
  Widget build(BuildContext context) {
    final device = widget
        .bloc.state.inRoomIotDeviceModel![widget.bloc.state.selectedIotIndex];

    return Dialog(
      child: BlocProvider.value(
        value: widget.bloc,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.cancel,
                    color: Theme.of(context).primaryColor,
                    size: 26,
                  ),
                ),
              ),
              Center(
                child: Text(
                  context.appLocalizations.choose_color,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const CustomColorPickerScreen(),
              BlockPicker(
                availableColors: availableWhitesColors,
                layoutBuilder: (context, colors, child) {
                  return GridView.count(
                    crossAxisCount: 7,
                    shrinkWrap: true,
                    children: [
                      for (final Color color in colors) child(color),
                    ],
                  );
                },
                itemBuilder: (color, isCurrentColor, changeColor) {
                  return InkWell(
                    onTap: changeColor,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(0.4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrentColor ? color : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                      ),
                    ),
                  );
                },
                pickerColor: whitesColor,
                onColorChanged: changeWhitesColor,
              ),
              CustomGradientButton(
                onSubmit: () {
                  int colorTempVal = 0;
                  if (lastWhiteBlockPicker) {
                    if (whitesColor == availableWhitesColors[0]) {
                      colorTempVal = 153;
                    } else if (whitesColor == availableWhitesColors[1]) {
                      colorTempVal = 250;
                    } else if (whitesColor == availableWhitesColors[2]) {
                      colorTempVal = 370;
                    } else if (whitesColor == availableWhitesColors[3]) {
                      colorTempVal = 200;
                    } else if (whitesColor == availableWhitesColors[4]) {
                      colorTempVal =
                          device.detailsJson.contains("wyze") ? 200 : 100;
                    } else if (whitesColor == availableWhitesColors[5]) {
                      colorTempVal = 333;
                    } else if (whitesColor == availableWhitesColors[6]) {
                      colorTempVal = 500;
                    }
                  } else {
                    if (selectedWhiteColorName == colorNames[0]) {
                      colorTempVal = 500;
                    } else if (selectedWhiteColorName == colorNames[1]) {
                      colorTempVal = 350;
                    } else if (selectedWhiteColorName == colorNames[2]) {
                      colorTempVal = 250;
                    } else if (selectedWhiteColorName == colorNames[3]) {
                      colorTempVal = 50;
                    } else if (selectedWhiteColorName == colorNames[4]) {
                      colorTempVal = 150;
                    } else if (selectedWhiteColorName == colorNames[5]) {
                      colorTempVal = 100;
                    } else if (selectedWhiteColorName == colorNames[6]) {
                      colorTempVal = 200;
                    }
                  }
                  widget.bloc.operateIotDevice(
                    device.entityId,
                    Constants.turnOn,
                    otherValues: {
                      Constants.colorTemp: colorTempVal,
                    },
                  );
                  Navigator.pop(context);
                },
                label: context.appLocalizations.apply,
              ),
              CustomCancelButton(
                onSubmit: () {
                  Navigator.pop(context);
                },
                label: context.appLocalizations.reset,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomColorPickerScreen extends StatefulWidget {
  const CustomColorPickerScreen({super.key});

  @override
  CustomColorPickerScreenState createState() => CustomColorPickerScreenState();
}

class CustomColorPickerScreenState extends State<CustomColorPickerScreen> {
  Offset thumbPosition = const Offset(150, 150); // Start at the center
  Color selectedColor = const Color(0xFFFFD700); // Very Warm Yellow
  String selectedColorName = "Very Warm Yellow";
  String selectedFormat = "Hex"; // Dropdown value

  final List<Color> whiteAndYellowShades = [
    const Color(0xFFFFD700), // Very Warm Yellow
    const Color(0xFFFFE135), // Soft Yellow
    const Color(0xFFFFFF99), // Pale Yellow
    const Color(0xFFFFFFFF), // Daylight White
    const Color(0xFFF0F8FF), // Cool White
    const Color(0xFFFFF5E1), // Warm White
    const Color(0xFFE8E8E8), // Neutral White
  ];

  final List<String> colorNames = [
    "Very Warm Yellow",
    "Soft Yellow",
    "Pale Yellow",
    "Daylight White",
    "Cool White",
    "Warm White",
    "Neutral White",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (details) {
            setState(() {
              Offset newPosition = details.localPosition;

              // Calculate the distance from the center
              const Size size = Size(300, 300); // Size of the color picker
              final Offset center = Offset(size.width / 2, size.height / 2);
              final double dx = newPosition.dx - center.dx;
              final double dy = newPosition.dy - center.dy;
              final double distance = sqrt(dx * dx + dy * dy);

              // If the new position is outside the circle, restrict it to the circle's edge
              if (distance > size.width / 2) {
                final double angle = atan2(dy, dx);
                newPosition = Offset(
                  center.dx + cos(angle) * size.width / 2,
                  center.dy + sin(angle) * size.width / 2,
                );
              }

              thumbPosition = newPosition;
              selectedColor = _getColorAtPosition(thumbPosition);
              selectedColorName = _getClosestColorName(selectedColor);
              // iotController.selectedWhiteColorName =
              //     _getClosestColorName(selectedColor);
              // iotController.lastWhiteBlockPicker = false;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black12),
            ),
            width: 300,
            height: 300,
            child: CustomPaint(
              painter: ColorCirclePainter(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: thumbPosition.dx - 15, // Center the thumb
                    top: thumbPosition.dy - 15,
                    child: CustomPaint(
                      size: const Size(30, 30),
                      painter: ThumbPainter(selectedColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                dropdownColor: Colors.white,
                value: selectedFormat,
                items: <String>['Hex', 'RGB'].map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedFormat = newValue!;
                  });
                },
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildColumn(
                      "R",
                      selectedColor.r.toInt().toRadixString(16),
                    ),
                    _buildColumn(
                      "G",
                      selectedColor.g.toInt().toRadixString(16),
                    ),
                    _buildColumn(
                      "B",
                      selectedColor.b.toInt().toRadixString(16),
                    ),
                    _buildColumn(
                      "A",
                      selectedFormat == "Hex"
                          ? selectedColor.a.toInt().toRadixString(16)
                          : '${(selectedColor.a / 255 * 100).round()}%',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Color _getColorAtPosition(Offset position) {
    const Size size = Size(300, 300);
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = min(size.width / 2, size.height / 2);

    final double dx = position.dx - center.dx;
    final double dy = position.dy - center.dy;
    final double distance = sqrt(dx * dx + dy * dy);

    if (distance > radius) {
      return selectedColor; // Stay with the previous color if out of bounds
    }

    double angle = atan2(dy, dx);
    angle = angle < 0 ? 2 * pi + angle : angle;

    // Divide the circle into 7 equal parts (3 for yellow shades, 4 for white shades)
    final int index = (angle / (2 * pi / 7)).floor();
    return whiteAndYellowShades[index];
  }

  String _getClosestColorName(Color color) {
    final int index = whiteAndYellowShades.indexOf(color);
    return colorNames[index];
  }
}

class ColorCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    const Gradient gradient = SweepGradient(
      colors: [
        Color(0xFFFFD680), // Very Warm Yellow
        Color(0xFFFFE135), // Soft Yellow
        Color(0xFFFFFF99), // Pale Yellow
        Color(0xFFFFFFFF), // Daylight White
        Color(0xFFF0F8FF), // Cool White
        Color(0xFFFFF5E1), // Warm White
        Color(0xFFE8E8E8), // Neutral White
      ],
      stops: [
        0.0,
        1 / 6,
        2 / 6,
        3 / 6,
        4 / 6,
        5 / 6,
        1.0,
      ],
    );

    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ThumbPainter extends CustomPainter {
  ThumbPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas
      ..drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2,
        fillPaint,
      )
      ..drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2,
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
