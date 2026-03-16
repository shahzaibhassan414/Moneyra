import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moneyra/Constants/Constants.dart';
import 'package:moneyra/Controllers/user_controller.dart';
import 'package:moneyra/Screens/AddTransactionScreen/add_transaction_screen.dart';
import 'package:moneyra/Utils/currency_formatter.dart';
import 'package:moneyra/Utils/feedback_utils.dart';
import '../../../Constants/custom_colors.dart';

Widget spendByCategoryList(BuildContext context, List<Map<String, dynamic>> transactions, String currencySymbol) {
  final UserController userController = Get.find<UserController>();

  if (transactions.isEmpty) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'No transactions found.',
          style: TextStyle(color: CustomColors.secondaryText),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, Map<String, dynamic> tx) {
    final double amount = double.tryParse(tx['amount'].toString()) ?? 0.0;
    final String type = tx['type'] ?? 'expense';
    final String id = tx['id'] ?? '';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: CustomColors.grey200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.edit_rounded, color: CustomColors.primaryBlue),
            title: const Text('Edit Transaction'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTransactionScreen(transactionToEdit: tx),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline_rounded, color: CustomColors.warningRed),
            title: const Text('Delete Transaction'),
            onTap: () async {
              Navigator.pop(context);
              bool? confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete?'),
                  content: const Text('Are you sure you want to remove this transaction?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete', style: const TextStyle(color: CustomColors.warningRed)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                try {
                  await userController.deleteTransaction(id, amount, type);
                  FeedbackUtils.showSuccess(Get.context!, 'Deleted successfully');
                } catch (e) {
                  FeedbackUtils.showInfo(Get.context!, 'Failed to delete');
                }
              }
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  return Column(
    children: transactions.map((tx) {
      final String categoryName = tx['category'] ?? 'Other';
      final double amount = double.tryParse(tx['amount'].toString()) ?? 0.0;
      final DateTime date = (tx['date'] as dynamic)?.toDate() ?? DateTime.now();
      final String type = tx['type'] ?? 'expense';
      final bool isIncome = type == 'income';

      final categoryData = Constants.transactionCategories.firstWhere(
        (c) => c.name == categoryName,
        orElse: () => Constants.incomeCategories.firstWhere(
          (c) => c.name == categoryName,
          orElse: () => Constants.transactionCategories.last,
        ),
      );

      return InkWell(
        onTap: () => _showOptions(context, tx),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CustomColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: CustomColors.grey100),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isIncome 
                      ? CustomColors.primaryGreen.withOpacity(0.1) 
                      : CustomColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  categoryData.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(date),
                      style: const TextStyle(
                        fontSize: 12,
                        color: CustomColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${isIncome ? '+' : '-'} ${CurrencyFormatter.format(amount)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isIncome ? CustomColors.primaryGreen : CustomColors.warningRed,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}
