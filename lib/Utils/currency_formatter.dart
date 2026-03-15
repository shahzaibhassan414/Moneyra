import '../Services/user_service.dart';
import 'format_amount.dart';

class CurrencyFormatter {
  static String format(dynamic amount) {
    final user = UserService().currentUser;
    String symbol = user?.currency ?? '';

    String formattedNumber = formatAmount(amount);

    print("symbol");
    print(symbol);
    print(formattedNumber);
    return '$symbol $formattedNumber';
  }
}

String getCurrency() {
  final user = UserService().currentUser;
  String symbol = user!.currencySymbol;
  return symbol;
}