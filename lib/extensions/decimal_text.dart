import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter(TargetPlatform platform) : _platform = platform;
  final TargetPlatform _platform;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (TargetPlatform.android == _platform) {
      final RegExp regEx = RegExp(r"^\d{0,9\.?\d{0,6}");
      final String newString = regEx.stringMatch(newValue.text) ?? "";
      return newString == newValue.text ? newValue : oldValue;
    } else {
      final RegExp regEx = RegExp(r"^\d{0,9}[\.,\,]?\d{0,6}");
      String newString = regEx.stringMatch(newValue.text) ?? "";
      newString = newString.replaceAll(RegExp(r'\,'), '.');
      final TextEditingValue editNewValue =
          newValue.copyWith(text: newValue.text.replaceAll(RegExp(r'\,'), '.'));
      return newString == editNewValue.text ? editNewValue : oldValue;
    }
  }
}
