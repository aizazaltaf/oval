import 'package:admin/extensions/context.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class AppDropDownButton<T> extends StatefulWidget {
  const AppDropDownButton({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.displayDropDownItems,
    this.hintText,
    this.prefixWidget,
    this.dropdownRadius = 40,
    this.expandedDropdownRadius = 14,
    this.dropDownTextStyle,
    required this.buttonHeight,
    required this.dropDownWidth,
    required this.dropDownHeight,
  });
  final BuiltList<T> items;
  final T? selectedValue;
  final Widget? prefixWidget;
  final ValueChanged<T?> onChanged;
  final String Function(T)
      displayDropDownItems; // Function to convert the item to a string
  final String? hintText;
  final double buttonHeight;
  final double dropdownRadius;
  final double expandedDropdownRadius;
  final double dropDownWidth;
  final double dropDownHeight;
  final TextStyle? dropDownTextStyle;

  @override
  State<AppDropDownButton<T>> createState() => _AppDropDownButtonState<T>();
}

class _AppDropDownButtonState<T> extends State<AppDropDownButton<T>> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        onMenuStateChange: (val) {
          setState(() {
            isExpanded = val;
          });
        },
        hint: Row(
          children: [
            widget.prefixWidget ?? const SizedBox.shrink(),
            if (widget.prefixWidget != null)
              const SizedBox(
                width: 16,
              )
            else
              const SizedBox.shrink(),
            Text(
              widget.hintText ?? context.appLocalizations.select_an_item,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 14,
                    color: CommonFunctions.getThemeBasedWidgetColor(context),
                    fontWeight: FontWeight.w500,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        items: widget.items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Row(
                  children: [
                    widget.prefixWidget ?? const SizedBox.shrink(),
                    if (widget.prefixWidget != null)
                      const SizedBox(
                        width: 16,
                      )
                    else
                      const SizedBox.shrink(),
                    Text(
                      widget.displayDropDownItems(
                        item,
                      ), // Use the display function here
                      style: widget.dropDownTextStyle ??
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: CommonFunctions.getThemeBasedWidgetColor(
                                  context,
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        value: widget.selectedValue,
        onChanged: widget.onChanged,
        buttonStyleData: ButtonStyleData(
          height: widget.buttonHeight,
          width: widget.dropDownWidth,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.dropdownRadius),
            color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
          ),
          elevation: 2,
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            isExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: CommonFunctions.getThemeBasedWidgetColor(context),
          ),
          iconSize: 22,
          iconEnabledColor: AppColors.darkBlueColor,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: widget.dropDownHeight,
          width: widget.dropDownWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.expandedDropdownRadius),
            color: CommonFunctions.getThemePrimaryLightWhiteColor(context),
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all<double>(6),
            thumbVisibility: WidgetStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
