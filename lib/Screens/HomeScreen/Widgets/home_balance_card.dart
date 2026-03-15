import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyra/Utils/currency_formatter.dart';
import '../../../Constants/custom_colors.dart';
import '../../../Controllers/user_controller.dart';

class HomeBalanceCard extends StatelessWidget {
  final String balance;
  const HomeBalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    double numericBalance = double.tryParse(balance.replaceAll(',', '')) ?? 0.0;
    bool isPositive = numericBalance >= 0;
    
    Color cardColor = isPositive ? CustomColors.primaryGreen : CustomColors.warningRed;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Balance',
            style: TextStyle(color: CustomColors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
        Obx(() {
          final user = userController.user.value;
          return Text(
            "${user!.currencySymbol}${CurrencyFormatter.format(balance)}",
            style: const TextStyle(
              color: CustomColors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          );
        }),

          const SizedBox(height: 20),
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(15, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    height: (10 + (index % 5) * 6).toDouble(),
                    decoration: BoxDecoration(
                      color: CustomColors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
