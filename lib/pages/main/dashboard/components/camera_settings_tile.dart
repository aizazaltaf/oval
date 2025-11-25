import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:flutter/material.dart';

class CameraSettingTile extends StatefulWidget {
  const CameraSettingTile({
    super.key,
    this.leading,
    required this.title,
    this.trailing,
    this.subtitle,
    this.style,
    this.titleColor,
    this.onTap,
    this.needSlider = false,
    this.sliderVal,
    this.minSliderVal,
    this.maxSliderVal,
    this.isCard = false,
    this.sliderOnChanged,
    required this.isDisabled,
  });

  final Widget? leading;
  final String title;
  final Widget? subtitle;
  final Widget? trailing;
  final Color? titleColor;
  final bool isDisabled;
  final TextStyle? style;
  final VoidCallback? onTap;
  final bool needSlider;
  final bool isCard;
  final double? sliderVal;
  final double? minSliderVal;
  final double? maxSliderVal;
  final Function? sliderOnChanged;

  @override
  State<CameraSettingTile> createState() => _CameraSettingTileState();
}

class _CameraSettingTileState extends State<CameraSettingTile> {
  late double? newSliderVal;

  @override
  void initState() {
    // implement initState
    super.initState();
    newSliderVal = widget.sliderVal;
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCard
        ? Card(
            color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: childWidget(),
          )
        : childWidget();
  }

  Widget childWidget() {
    return Column(
      children: [
        ListTile(
          leading: widget.leading,
          title: Text(
            widget.title,
            style: widget.style
                    ?.copyWith(color: widget.isDisabled ? Colors.grey : null) ??
                Theme.of(context).textTheme.displayMedium?.copyWith(
                      color:
                          widget.isDisabled ? Colors.grey : widget.titleColor,
                    ),
          ),
          subtitle: (widget.needSlider) ? sliderWidget() : widget.subtitle,
          trailing: !widget.needSlider ? widget.trailing : null,
          onTap: widget.onTap,
        ),
        // if (widget.needSlider) sliderWidget(),
      ],
    );
  }

  Widget sliderWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(widget.minSliderVal.toString()),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Theme.of(context).primaryColor,
                thumbColor: Theme.of(context).primaryColor,
                trackHeight: 4,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 7.5),
                inactiveTickMarkColor: Colors.transparent,
                overlayColor:
                    Theme.of(context).primaryColor.withValues(alpha: 0.2),
                activeTickMarkColor: Colors.transparent,
                valueIndicatorColor: Theme.of(context).primaryColor,
                inactiveTrackColor: AppColors.cancelButtonColor,
                padding: EdgeInsets.zero,
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: Slider(
                min: widget.minSliderVal ?? 0,
                value: newSliderVal ?? 50,
                max: widget.maxSliderVal ?? 100,
                label: newSliderVal?.toInt().toString(),
                divisions: 100,
                onChanged: (val) {
                  setState(() {
                    newSliderVal = val;
                  });
                },
                onChangeEnd: (val) {
                  setState(() {
                    newSliderVal = val;
                    widget.sliderOnChanged!(newSliderVal);
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(widget.maxSliderVal.toString()),
        ],
      ),
    );
  }
}
