import 'package:flutter/services.dart';

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    final String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Format the digits into "123-456-789"
    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      if (i == 3 || i == 6) {
        formatted += '-';
      }
      formatted += digits[i];
    }

    // Ensure the cursor position is maintained
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
