import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyra/Controllers/user_controller.dart';
import 'package:moneyra/Utils/amount_format_controller.dart';
import 'package:moneyra/Utils/custom_button.dart';
import 'package:moneyra/Utils/custom_text_field.dart';
import 'package:moneyra/Utils/feedback_utils.dart';
import 'package:moneyra/Utils/format_amount.dart';
import '../../../Constants/custom_colors.dart';
import 'financial_item_tile.dart';

class ProfileFinancialPreferences extends StatefulWidget {
  const ProfileFinancialPreferences({super.key});

  @override
  State<ProfileFinancialPreferences> createState() => _ProfileFinancialPreferencesState();
}

class _ProfileFinancialPreferencesState extends State<ProfileFinancialPreferences> {
  void _showEditBottomSheet() {
    final UserController userController = Get.find<UserController>();
    final user = userController.user.value;
    
    final incomeController = AmountFormatterController(
      text: formatAmount(user?.monthlyIncome ?? 0),
    );
    
    String selectedCurrency = user?.currency ?? 'USD';
    String currencySymbol = user?.currencySymbol ?? '\$';
    String currencyName = ''; // Optional display name

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : CustomColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Financial Preferences',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? CustomColors.white : CustomColors.primaryText,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Monthly Income',
                hint: '0.00',
                controller: incomeController,
                keyboardType: TextInputType.number,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(currencySymbol),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Currency',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CustomColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  showCurrencyPicker(
                    context: context,
                    onSelect: (Currency currency) {
                      setModalState(() {
                        selectedCurrency = currency.code;
                        currencySymbol = currency.symbol;
                      });
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF121212) : CustomColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: CustomColors.grey200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$currencySymbol - $selectedCurrency',
                        style: TextStyle(
                          color: isDark ? CustomColors.white : CustomColors.primaryText,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: CustomColors.secondaryText),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Save Changes',
                onPressed: () async {
                  final newIncome = double.tryParse(incomeController.text.replaceAll(',', '')) ?? 0.0;
                  
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .update({
                      'monthlyIncome': newIncome,
                      'currency': selectedCurrency,
                      'currencySymbol': currencySymbol,
                    });
                    
                    await userController.fetchUserData();
                    
                    if (context.mounted) {
                      Navigator.pop(context);
                      FeedbackUtils.showSuccess(context, 'Preferences updated!');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      FeedbackUtils.showInfo(context, 'Update failed: $e');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Obx(() {
      final user = userController.user.value;
      final symbol = user?.currencySymbol ?? '\$';
      
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: CustomColors.black.withOpacity(0.05),
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
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: _showEditBottomSheet,
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
            FinancialItemTile(
              icon: Icons.payments_outlined,
              label: 'Monthly Income',
              value: '$symbol ${formatAmount(user?.monthlyIncome ?? 0)}',
            ),
            FinancialItemTile(
              icon: Icons.currency_exchange_outlined,
              label: 'Currency',
              value: '${user?.currency ?? 'USD'} ($symbol)',
            ),
            FinancialItemTile(
              icon: Icons.savings_outlined,
              label: 'Total Category Budgets',
              value: '$symbol ${formatAmount(_calculateTotalBudget(user))}',
            ),
          ],
        ),
      );
    });
  }

  double _calculateTotalBudget(user) {
    if (user == null) return 0.0;
    return (user.additionalCategories as List).fold(0.0, (sum, cat) => sum + cat.budget);
  }
}
