import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AmountFormatterController extends TextEditingController {
  final NumberFormat _formatter = NumberFormat('#,###.##'); // Supports decimals

  AmountFormatterController({super.text});

  @override
  set value(TextEditingValue newValue) {
    // 1. Get the new text and remove existing commas
    final String newText = newValue.text.replaceAll(',', '');

    if (newText.isEmpty) {
      super.value = newValue;
      return;
    }

    // 2. Parse the number
    final double? number = double.tryParse(newText);

    if (number != null) {
      // 3. Format the number
      // Special case: if the user just typed a dot, don't format it away yet
      String formatted;
      if (newText.endsWith('.')) {
        formatted = '${_formatter.format(number.toInt())}.';
      } else {
        formatted = _formatter.format(number);
      }

      // 4. Update the value with formatted text and maintain cursor position
      super.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    } else {
      // If parsing fails (invalid input), keep the old value
      super.value = newValue;
    }
  }
}