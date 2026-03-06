import 'package:flutter/material.dart';
import '../../../Constants/custom_colors.dart';

Widget buildOverallBudgetCard({required double spent, required double total}) {
  double percent = (spent / total).clamp(0.0, 1.0);
  bool isOver = spent > total;

  return Container(
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Spent',
                  style: TextStyle(color: CustomColors.secondaryText, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  '\$1,749.50',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primaryText,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Budget Limit',
                  style: TextStyle(color: CustomColors.secondaryText, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${total.toStringAsFixed(0)}',
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
                  color: isOver ? CustomColors.warningRed : CustomColors.primaryGreen,
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
            color: isOver ? CustomColors.warningRed : CustomColors.secondaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}