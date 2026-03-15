import 'package:intl/intl.dart';

String formatAmount(dynamic amount) {
  if (amount == null) return '0';
  
  String cleanAmount = amount.toString().replaceAll(',', '');
  
  final number = double.tryParse(cleanAmount) ?? 0.0;
  
  if (number == number.toInt()) {
    return NumberFormat('#,###').format(number);
  } else {
    return NumberFormat('#,##0.00').format(number);
  }
}
