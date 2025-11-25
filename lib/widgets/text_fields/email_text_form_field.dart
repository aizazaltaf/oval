import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/text_fields/text_form_field.dart';
import 'package:flutter/material.dart';

class EmailTextFormField extends StatelessWidget {
  const EmailTextFormField({
    super.key,
    this.enabled,
    // this.initialValue,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.needAutoFillHints = true,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
  });
  final bool? enabled;
  // final String? initialValue;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool needAutoFillHints;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;

  @override
  Widget build(final BuildContext context) {
    final TextEditingController effectiveController =
        controller ?? TextEditingController();

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: effectiveController,
      builder: (context, value, _) {
        final isEmpty = value.text.isEmpty;
        final iconColor = isEmpty
            ? Colors.grey
            : CommonFunctions.getThemeBasedWidgetColor(context);

        return AppTextFormField(
          enabled: enabled,
          // initialValue: initialValue,
          hintText: hintText,
          helperText: helperText,
          errorText: errorText,
          prefixIcon: Icon(
            Icons.email_outlined,
            size: 20,
            color: iconColor,
          ),
          controller: effectiveController,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: textInputAction,
          keyboardType: TextInputType.emailAddress,
          autofillHints: needAutoFillHints ? const [AutofillHints.email] : null,
        );
      },
    );
  }
}
