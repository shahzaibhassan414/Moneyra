import 'package:flutter/material.dart';

import '../../../Constants/custom_colors.dart';
import '../../../Utils/currency_formatter.dart';

Widget budgetCategoryBreakDownItem({
  required String category,
  required double spent,
  required double budget,
  required String currency,
}) {
  double percent = (spent / budget).clamp(0.0, 1.0);
  bool isOver = spent > budget;

  return Container(
    margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: CustomColors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isOver
            ? CustomColors.warningRed.withValues(alpha: 0.3)
            : CustomColors.grey100,
      ),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$currency${CurrencyFormatter.format(spent)}",
                    style: TextStyle(
                      color: isOver
                          ? CustomColors.warningRed
                          : CustomColors.primaryText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' / ${budget.toStringAsFixed(0)}',
                    style: const TextStyle(color: CustomColors.secondaryText),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: CustomColors.grey200,
            valueColor: AlwaysStoppedAnimation<Color>(
              isOver ? CustomColors.warningRed : CustomColors.primaryBlue,
            ),
            minHeight: 8,
          ),
        ),
        if (isOver)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: CustomColors.warningRed,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Overspent by $currency ${(spent - budget).toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: CustomColors.warningRed,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}
