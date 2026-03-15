import 'package:flutter/material.dart';
import 'package:moneyra/Utils/currency_formatter.dart';
import '../../../Constants/custom_colors.dart';

Widget buildOverallBudgetCard({
  required double spent,
  required double total,
  required String currency,
}) {
  double percent = (spent / total).clamp(0.0, 1.0);

  return Container(
    margin: EdgeInsets.all(20),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: CustomColors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: CustomColors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Spent',
                  style: TextStyle(
                    color: CustomColors.secondaryText,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "$currency${CurrencyFormatter.format(spent)}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color:
                    percent * 100 > 90 ?
                    CustomColors.warningRed :
                    percent * 100 > 75 ?
                    CustomColors.red.withValues(alpha: 0.5) :
                    percent * 100 > 50 ?
                        CustomColors.amber :
                    CustomColors.primaryBlue,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Budget Limit',
                  style: TextStyle(
                    color: CustomColors.secondaryText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$currency${CurrencyFormatter.format(total)}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Stack(
          children: [
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: CustomColors.grey200,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percent,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color:  percent * 100 > 90 ?
                  CustomColors.warningRed :
                  percent * 100 > 75 ?
                  CustomColors.red.withValues(alpha: 0.5) :
                  percent * 100 > 50 ?
                  CustomColors.amber :
                  CustomColors.primaryBlue,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '${(percent * 100).toStringAsFixed(0)}% of your budget used',
          style: TextStyle(
            color:  percent * 100 > 90 ?
            CustomColors.warningRed :
            percent * 100 > 75 ?
            CustomColors.red.withValues(alpha: 0.5) :
            percent * 100 > 50 ?
            CustomColors.amber :
            CustomColors.secondaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
