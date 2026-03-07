import 'package:flutter/material.dart';
import '../../../Constants/custom_colors.dart';
import 'financial_item_tile.dart';

class ProfileFinancialPreferences extends StatelessWidget {
  const ProfileFinancialPreferences({super.key});

  @override
  Widget build(BuildContext context) {
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
              Text(
                'Financial Preferences',
                style: TextStyle(
                  color: CustomColors.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
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
          FinancialItemTile(
            icon: Icons.payments_outlined,
            label: 'Monthly Income',
            value: '\$4,000',
          ),
          FinancialItemTile(
            icon: Icons.currency_exchange_outlined,
            label: 'Currency',
            value: 'USD (\$)',
          ),
          FinancialItemTile(
            icon: Icons.savings_outlined,
            label: 'Savings Goal',
            value: '\$500/month',
          ),
        ],
      ),
    );
  }
}
