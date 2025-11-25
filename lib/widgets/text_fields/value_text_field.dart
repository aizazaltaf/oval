import 'package:admin/widgets/text_fields/text_form_field.dart';
import 'package:flutter/material.dart';

class ValueTextField extends StatefulWidget {
  const ValueTextField({
    super.key,
    this.hintText,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.fieldKey,
    this.value,
  });
  final String? value;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final Key? fieldKey;

  @override
  State<ValueTextField> createState() => _ValueTextFieldState();
}

class _ValueTextFieldState extends State<ValueTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(
      text: widget.value,
    );
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return AbsorbPointer(
      child: AppTextFormField(
        controller: controller,
        enabled: true,
        hintText: widget.hintText,
        helperText: widget.helperText,
        errorText: widget.errorText,
        obscureText: widget.obscureText,
        validator: widget.validator,
        suffixIcon: widget.suffixIcon,
        fieldKey: widget.fieldKey,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant final ValueTextField oldWidget) {
    final newValue = widget.value;
    if (oldWidget.value != newValue) {
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        if (newValue == null) {
          controller.clear();
        } else {
          controller.text = newValue;
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }
}
