import 'package:flutter/material.dart';
import '../../../Constants/custom_colors.dart';
import 'financial_item_tile.dart';

Widget profileFinancialPreferences() {
  return Container(
    padding: const EdgeInsets.all(20),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Financial Preferences',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: CustomColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        financialItemTile(Icons.payments_outlined, 'Monthly Income', '\$4,000'),
        financialItemTile(
          Icons.currency_exchange_outlined,
          'Currency',
          'USD (\$)',
        ),
        financialItemTile(
          Icons.savings_outlined,
          'Savings Goal',
          '\$500/month',
        ),
      ],
    ),
  );
}
