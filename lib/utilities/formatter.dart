import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Formatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.decimalPattern('en_US'); // 'en_US' for thousands separator

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove non-digit characters before applying the formatting
    String newText = newValue.text.replaceAll(',', '');

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Format the input with commas
    final formattedText = _formatter.format(int.parse(newText));

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
