import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/text_fields/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    super.key,
    this.enabled,
    this.obscureText = true,
    this.needAutoFillHints = true,
    this.onPressed,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.fieldKey,
  });

  final bool? enabled;
  final bool obscureText;
  final bool needAutoFillHints;
  final TextEditingController? controller;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final Key? fieldKey;
  final VoidCallback? onPressed;

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  late final TextEditingController _internalController;
  bool _isExternalController = false;

  @override
  void initState() {
    super.initState();
    _isExternalController = widget.controller != null;
    _internalController =
        widget.controller ?? TextEditingController(); // create once
  }

  @override
  void dispose() {
    if (!_isExternalController) {
      _internalController.dispose(); // only dispose if we created it
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _internalController,
      builder: (context, value, _) {
        final isEmpty = value.text.isEmpty;
        final iconColor = isEmpty
            ? Colors.grey
            : CommonFunctions.getThemeBasedWidgetColor(context);

        return AppTextFormField(
          fieldKey: widget.fieldKey,
          enabled: widget.enabled,
          hintText: widget.hintText,
          helperText: widget.helperText,
          errorText: widget.errorText,
          controller: _internalController,
          prefixIcon: Icon(
            Icons.lock_outlined,
            size: 20,
            color: iconColor,
          ),
          suffixIcon: IconButton(
            onPressed: isEmpty ? null : widget.onPressed,
            icon: Icon(
              widget.obscureText ? Icons.visibility_off : MdiIcons.eyeOutline,
              color: iconColor,
            ),
          ),
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          textInputAction: widget.textInputAction,
          autofillHints:
              widget.needAutoFillHints ? const [AutofillHints.password] : null,
          keyboardType: TextInputType.visiblePassword,
          obscureText: widget.obscureText,
        );
      },
    );
  }
}
