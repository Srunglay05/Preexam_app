import 'package:flutter/services.dart';

class MaxValueInputFormatter extends TextInputFormatter {
  final int max;

  MaxValueInputFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    int value = int.tryParse(newValue.text) ?? 0;

    if (value > max) {
      return TextEditingValue(
        text: max.toString(),
        selection: TextSelection.collapsed(
          offset: max.toString().length,
        ),
      );
    }
    return newValue;
  }
}
