import 'package:flutter/material.dart';
import 'package:moneyra/Utils/AppBars/app_bar_with_center_text.dart';
import '../../Constants/custom_colors.dart';
import 'Widgets/budget_overall_budget_card.dart';
import 'Widgets/budget_category_breakdown_card.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundGray,
      appBar: AppBarWithCenterText(text: 'Monthly Budget'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildOverallBudgetCard(spent: 1749.50, total: 2500.00),
            const SizedBox(height: 32),

            const Text(
              'Category Breakdowns',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),

            budgetCategoryBreakDownItem(
              category: 'Food & Dining 🍔',
              spent: 450.00,
              budget: 400.00,
              color: CustomColors.orange,
            ),
            budgetCategoryBreakDownItem(
              category: 'Rent & Utilities 🏠',
              spent: 900.00,
              budget: 1000.00,
              color: CustomColors.primaryBlue,
            ),
            budgetCategoryBreakDownItem(
              category: 'Entertainment 🎮',
              spent: 200.00,
              budget: 150.00,
              color: CustomColors.purple,
            ),
            budgetCategoryBreakDownItem(
              category: 'Transport 🚗',
              spent: 199.50,
              budget: 300.00,
              color: CustomColors.softTeal,
            ),
          ],
        ),
      ),
    );
  }
}
