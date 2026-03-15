import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moneyra/Utils/currency_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/Constants.dart';
import '../../Constants/custom_colors.dart';
import '../../Models/category_model.dart';
import '../../Utils/amount_format_controller.dart';
import '../../Utils/custom_button.dart';
import '../../Utils/custom_text_field.dart';
import '../../Utils/feedback_utils.dart';
import '../BottomNav/bottom_nav.dart';

class AdditionalDataScreen extends StatefulWidget {
  const AdditionalDataScreen({super.key});

  @override
  State<AdditionalDataScreen> createState() => _AdditionalDataScreenState();
}

class _AdditionalDataScreenState extends State<AdditionalDataScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final _incomeController = AmountFormatterController();
  bool _isLoading = false;
  String _selectedCurrency = 'USD';
  String _currencyName = 'US Dollar';
  String _currencySymbol = '\$';

  final List<CategoryModel> _selectedCategories = [];

  Future<void> _saveAdditionalData() async {
    final SharedPreferences prefs = await _prefs;
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
              'monthlyIncome':
                  double.tryParse(_incomeController.text.replaceAll(',', '')) ??
                  0.0,
              'monthlyExpense': 0.0,
              'currency': _selectedCurrency,
              'currencySymbol': _currencySymbol,
              'additionalCategories': _selectedCategories
                  .map((cat) => cat.toJson())
                  .toList(),
              'isSetupComplete': true,
            });

        if (mounted) {
          prefs.setBool("isLogin", true);
          FeedbackUtils.showSuccess(
            context,
            'Setup complete! Welcome to Moneyra.',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavWrapper()),
          );
        }
      }
    } catch (e) {
      if (mounted) FeedbackUtils.showInfo(context, e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showBudgetBottomSheet(CategoryModel category) {
    final budgetController = AmountFormatterController();
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : CustomColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
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
            Row(
              children: [
                Text(category.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Text(
                  'Set Budget for ${category.name}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? CustomColors.white
                        : CustomColors.primaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Monthly Budget',
              hint: '0.00',
              controller: budgetController,
              keyboardType: TextInputType.number,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(_currencySymbol),
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Confirm',
              onPressed: () {
                final amount =
                    double.tryParse(
                      budgetController.text.replaceAll(',', ''),
                    ) ??
                    0.0;
                setState(() {
                  _selectedCategories.add(
                    CategoryModel(
                      name: category.name,
                      emoji: category.emoji,
                      budget: amount,
                    ),
                  );
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundGray,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                'Personalize your Experience',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Help us tailor Moneyra to your needs',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: CustomColors.secondaryText,
                ),
              ),
              const SizedBox(height: 48),
              CustomTextField(
                label: 'Monthly Income',
                hint: 'e.g., 5,000',
                controller: _incomeController,
                icon: Icons.account_balance_wallet_rounded,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your monthly income';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Default Currency',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryText,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  showCurrencyPicker(
                    context: context,
                    showFlag: true,
                    showCurrencyName: true,
                    showCurrencyCode: true,
                    onSelect: (Currency currency) {
                      setState(() {
                        _selectedCurrency = currency.code;
                        _currencyName = currency.name;
                        _currencySymbol = currency.symbol;
                      });
                    },
                    theme: CurrencyPickerThemeData(
                      backgroundColor: CustomColors.white,
                      titleTextStyle: TextStyle(
                        color: CustomColors.primaryText,
                      ),
                      subtitleTextStyle: const TextStyle(
                        color: CustomColors.secondaryText,
                      ),
                      bottomSheetHeight:
                          MediaQuery.of(context).size.height * 0.7,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: CustomColors.grey100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_currencySymbol - $_currencyName ($_selectedCurrency)',
                        style: TextStyle(
                          fontSize: 16,
                          color: CustomColors.primaryText,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: CustomColors.secondaryText,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Choose Additional Categories',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: Constants.transactionCategories.length,
                itemBuilder: (context, index) {
                  final cat = Constants.transactionCategories[index];
                  bool isSelected = _selectedCategories.any(
                    (c) => c.name == cat.name,
                  );
                  CategoryModel? selectedInstance = isSelected
                      ? _selectedCategories.firstWhere(
                          (c) => c.name == cat.name,
                        )
                      : null;

                  return InkWell(
                    onTap: () {
                      if (isSelected) {
                        setState(() {
                          _selectedCategories.removeWhere(
                            (c) => c.name == cat.name,
                          );
                        });
                      } else {
                        _showBudgetBottomSheet(cat);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? CustomColors.primaryBlue.withValues(alpha: 0.08)
                            : (CustomColors.white),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? CustomColors.primaryBlue
                              : CustomColors.grey100,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: CustomColors.black.withValues(
                                    alpha: 0.03,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(cat.emoji, style: const TextStyle(fontSize: 24)),
                          const SizedBox(height: 4),
                          Text(
                            cat.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.primaryText,
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(height: 2),
                            Text(
                              '$_currencySymbol${CurrencyFormatter.format(selectedInstance?.budget)}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: CustomColors.secondaryText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: 'Complete Setup',
                onPressed: _saveAdditionalData,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
