import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/text_fields/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NameTextFormField extends StatefulWidget {
  const NameTextFormField({
    super.key,
    this.enabled,
    this.initialValue,
    this.hintText,
    this.hintStyle,
    this.helperText,
    this.textCapitalization,
    this.errorText,
    this.controller,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.maxLines,
    this.onFieldSubmitted,
    this.obscure = false,
    this.autoFocus = false,
    this.textInputAction,
    this.focusNode,
    this.prefix,
    this.customDefaultBorderSide,
    this.suffix,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.customCircularBorder,
  });

  final bool? enabled;
  final bool? obscure;
  final String? initialValue;
  final String? hintText;
  final TextStyle? hintStyle;
  final BorderSide? customDefaultBorderSide;
  final String? helperText;
  final String? errorText;
  final int? maxLines;
  final TextCapitalization? textCapitalization;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final TextInputType keyboardType;
  final Widget? prefix;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final bool? autoFocus;
  final GestureTapCallback? onTap;
  final FocusNode? focusNode;
  final double? customCircularBorder;

  @override
  State<NameTextFormField> createState() => _NameTextFormFieldState();
}

class _NameTextFormFieldState extends State<NameTextFormField> {
  late TextEditingController _controller;
  bool _controllerCreatedInternally = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue ?? '');
      _controllerCreatedInternally = true;
    } else {
      _controller = widget.controller!;
    }
  }

  @override
  void didUpdateWidget(covariant NameTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the initialValue changes and controller was created internally, update text
    if (_controllerCreatedInternally &&
        widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      if (widget.initialValue != oldWidget.initialValue) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller.text = widget.initialValue ?? '';
        });
      }
    }
    // If controller changes from outside, update our ref
    if (oldWidget.controller != widget.controller) {
      if (widget.controller != null) {
        _controller.removeListener(_onTextChanged);
        _controller = widget.controller!;
        _controllerCreatedInternally = false;
        _controller.addListener(_onTextChanged);
      } else if (!_controllerCreatedInternally) {
        _controller = TextEditingController(text: widget.initialValue ?? '');
        _controllerCreatedInternally = true;
        _controller.addListener(_onTextChanged);
      }
    }
  }

  @override
  void dispose() {
    if (_controllerCreatedInternally) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    // no need to call setState, icon color reacts via ValueListenableBuilder below
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        final isEmpty = value.text.isEmpty;
        final iconColor = isEmpty
            ? Colors.grey
            : CommonFunctions.getThemeBasedWidgetColor(context);

        Widget? colorIcon(Widget? icon) {
          if (icon == null) {
            return null;
          }
          return IconTheme(data: IconThemeData(color: iconColor), child: icon);
        }

        return AppTextFormField(
          enabled: widget.enabled,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle,
          helperText: widget.helperText,
          obscureText: widget.obscure ?? false,
          errorText: widget.errorText,
          controller: _controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          prefixIcon: colorIcon(widget.prefix),
          suffixIcon: colorIcon(widget.suffix),
          customDefaultBorderSide: widget.customDefaultBorderSide,
          customCircularBorder: widget.customCircularBorder,
          inputFormatters: widget.inputFormatters,
          focusNode: widget.focusNode,
          onFieldSubmitted: widget.onFieldSubmitted,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          autofocus: widget.autoFocus ?? false,
          onTap: widget.onTap,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.words,
          autofillHints: const [AutofillHints.name],
        );
      },
    );
  }
}
