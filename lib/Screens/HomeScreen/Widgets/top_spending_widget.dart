import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyra/Controllers/user_controller.dart';
import 'package:moneyra/Constants/Constants.dart';
import '../../../Constants/custom_colors.dart';
import '../../../Utils/empty_state_widget.dart';
import 'home_top_spending_row.dart';

class TopSpendingWidget extends StatelessWidget {
  const TopSpendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Spending',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: CustomColors.primaryText,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (userController.topExpenses.isEmpty) {
            return EmptyStateWidget(title: "No Spending Data Yet",);
          }

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

          List<MapEntry<String, double>> sortedCategories = aggregatedExpenses.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return ListView.builder(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedCategories.length > 5 ? 5 : sortedCategories.length,
            itemBuilder: (context, index) {
              final entry = sortedCategories[index];
              final String categoryName = entry.key;
              final double totalAmount = entry.value;

              final user = userController.user.value;
              double categoryBudget = 0.0;
              
              // Find the budget for this category from user's profile
              if (user != null) {
                final matchedCat = user.additionalCategories.firstWhereOrNull(
                  (c) => c.name == categoryName,
                );
                if (matchedCat != null) {
                  categoryBudget = matchedCat.budget;
                }
              }

              // Find emoji for the category from Constants
              final categoryData = Constants.transactionCategories.firstWhere(
                (c) => c.name == categoryName,
                orElse: () => Constants.incomeCategories.firstWhere(
                  (c) => c.name == categoryName,
                  orElse: () => Constants.transactionCategories.last,
                ),
              );

              return HomeTopSpendingRow(
                label: categoryName,
                emoji: categoryData.emoji,
                amount: totalAmount,
                currency: user?.currencySymbol ?? '\$',
                budget: categoryBudget,
              );
            },
          );
        }),
      ],
    );
  }
}
