import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyra/Utils/AppBars/app_bar_with_center_text.dart';
import '../../Constants/custom_colors.dart';
import '../../Controllers/user_controller.dart';
import 'Widgets/budget_overall_budget_card.dart';
import 'Widgets/budget_category_breakdown_card.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    
    return Scaffold(
      backgroundColor: CustomColors.backgroundGray,
      appBar: const AppBarWithCenterText(text: 'Monthly Budget'),
      body: Obx(() {
        final user = userController.user.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator(color: CustomColors.primaryBlue));
        }

        // 1. Group transactions by category name
        Map<String, double> aggregatedExpenses = {};
        for (var tx in userController.topExpenses) {
          final String categoryName = tx['category'] ?? 'Other';
          final double amount = double.tryParse(tx['amount'].toString()) ?? 0.0;
          
          if (aggregatedExpenses.containsKey(categoryName)) {
            aggregatedExpenses[categoryName] = aggregatedExpenses[categoryName]! + amount;
          } else {
            aggregatedExpenses[categoryName] = amount;
          }
        }

        // 2. Prepare the list of items to show
        final breakdownItems = user.additionalCategories.map((cat) {
          final double spent = aggregatedExpenses[cat.name] ?? 0.0;
          return {
            'name': '${cat.name} ${cat.emoji}',
            'spent': spent,
            'budget': cat.budget,
          };
        }).toList();

        // 3. Sort by spent amount (Descending - Highest first)
        breakdownItems.sort((a, b) => (b['spent'] as double).compareTo(a['spent'] as double));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildOverallBudgetCard(
              spent: user.monthlyExpense,
              total: user.monthlyIncome,
              currency: user.currencySymbol,
            ),
            const SizedBox(height: 32),

            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Category Breakdowns',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryText,
                ),
              ),
            ),
            const SizedBox(height: 16),

            breakdownItems.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'No categories set up yet.',
                        style: TextStyle(color: CustomColors.secondaryText),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: breakdownItems.length,
                      padding: const EdgeInsets.only(bottom: 20),
                      itemBuilder: (context, index) {
                        final item = breakdownItems[index];
                        return budgetCategoryBreakDownItem(
                          category: item['name'] as String,
                          spent: item['spent'] as double,
                          budget: item['budget'] as double,
                          currency: user.currencySymbol,
                        );
                      },
                    ),
                  ),
          ],
        );
      }),
    );
  }
}
