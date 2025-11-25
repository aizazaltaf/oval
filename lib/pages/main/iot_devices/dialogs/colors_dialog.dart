import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/navigator/bloc/pilot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ColorsDialog extends StatefulWidget {
  const ColorsDialog({super.key, required this.bloc});

  final IotBloc bloc;

  @override
  State<ColorsDialog> createState() => _ColorsDialogState();
}

class _ColorsDialogState extends State<ColorsDialog> {
  final availableColors = [
    AppColors.purple,
    AppColors.lightPurple,
    AppColors.pink,
    AppColors.darkPurple,
    AppColors.white,
    AppColors.lavender,
    AppColors.green,
    AppColors.yellow,
    AppColors.lightRed,
    AppColors.redOrange,
    AppColors.red,
    AppColors.blue,
  ];

  Color _pickerColor = const Color(0xffffffff);

  set pickerColor(Color color) {
    _pickerColor = color;
  }

  @override
  Widget build(BuildContext context) {
    final device = widget
        .bloc.state.inRoomIotDeviceModel![widget.bloc.state.selectedIotIndex];

    return Dialog(
      child: BlocProvider.value(
        value: widget.bloc,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: SizedBox(
              height: 97.h,
              width: 100.w,
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
                  ColorPicker(
                    pickerColor: _pickerColor,
                    onColorChanged: (val) {
                      pickerColor = val;
                    },
                    displayThumbColor: true,
                    paletteType: PaletteType.hueWheel,
                    labelTypes: const [
                      ColorLabelType.rgb,
                      ColorLabelType.hex,
                      ColorLabelType.hsl,
                      ColorLabelType.hsv,
                    ],
                  ),
                  BlockPicker(
                    availableColors: availableColors,
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
                              color:
                                  isCurrentColor ? color : Colors.transparent,
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
                    pickerColor: _pickerColor,
                    onColorChanged: (val) {
                      pickerColor = val;
                    },
                  ),
                  CustomGradientButton(
                    onSubmit: () {
                      widget.bloc.operateIotDevice(
                        device.entityId,
                        Constants.turnOn,
                        otherValues: {
                          Constants.rgbwColor:
                              // "[${_pickerColor.r.toInt() * 255},${_pickerColor.g.toInt() * 255},${_pickerColor.b.toInt() * 255},${255}]",
                              [
                            _pickerColor.r * 255,
                            _pickerColor.g * 255,
                            _pickerColor.b * 255,
                            _pickerColor.a * 255,
                          ],
                          // "brightness": device.brightness,
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
        ),
      ),
    );
  }
}
