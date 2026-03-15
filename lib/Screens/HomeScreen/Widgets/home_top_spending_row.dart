import 'package:flutter/material.dart';
import 'package:moneyra/Utils/currency_formatter.dart';
import '../../../Constants/custom_colors.dart';

class HomeTopSpendingRow extends StatelessWidget {
  final String label;
  final String emoji;
  final double amount;
  final String currency;
  final double budget;
  
  const HomeTopSpendingRow({
    super.key,
    required this.label,
    required this.emoji,
    required this.amount,
    required this.currency,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (budget > 0) ? (amount / budget).clamp(0.0, 1.0) : 0.0;
    bool isOverBudget = budget > 0 && amount > budget;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: CustomColors.primaryText,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(amount),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isOverBudget ? CustomColors.warningRed : CustomColors.primaryText,
                    ),
                  ),
                  if (budget > 0)
                    Text(
                      "of ${CurrencyFormatter.format(budget)}",
                      style: const TextStyle(
                        fontSize: 10,
                        color: CustomColors.secondaryText,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: CustomColors.grey200,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget ? CustomColors.warningRed : CustomColors.primaryBlue,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
