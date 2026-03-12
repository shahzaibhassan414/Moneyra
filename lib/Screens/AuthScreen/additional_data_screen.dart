import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/Constants.dart';
import '../../Constants/custom_colors.dart';
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

  final TextEditingController _incomeController = TextEditingController();
  bool _isLoading = false;
  String _selectedCurrency = 'USD';
  String _currencyName = 'US Dollar';
  String _currencySymbol = '\$';
  
  final List<String> _selectedCategoryNames = [];

  Future<void> _saveAdditionalData() async {
    final SharedPreferences prefs = await _prefs;
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'monthlyIncome': double.tryParse(_incomeController.text) ?? 0.0,
          'currency': _selectedCurrency,
          'currencySymbol': _currencySymbol,
          'additionalCategories': _selectedCategoryNames,
          'isSetupComplete': true,
        });

        if (mounted) {
          prefs.setBool("isLogin", true);
          FeedbackUtils.showSuccess(context, 'Setup complete! Welcome to Moneyra.');
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

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : CustomColors.backgroundGray,
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
                  color: isDark ? CustomColors.white : CustomColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Help us tailor Moneyra to your needs',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: CustomColors.secondaryText),
              ),
              const SizedBox(height: 48),
              
              CustomTextField(
                label: 'Monthly Income',
                hint: 'e.g., 5000',
                controller: _incomeController,
                icon: Icons.account_balance_wallet_rounded,
                keyboardType: TextInputType.number,
                validator: (value){
                  if(value == null || value.isEmpty){
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
                      backgroundColor: isDark ? const Color(0xFF1E1E1E) : CustomColors.white,
                      titleTextStyle: TextStyle(color: isDark ? CustomColors.white : CustomColors.primaryText),
                      subtitleTextStyle: const TextStyle(color: CustomColors.secondaryText),
                      // currencySymbolTextStyle: TextStyle(color: isDark ? CustomColors.white : CustomColors.primaryText),
                      bottomSheetHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : CustomColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? Colors.transparent : CustomColors.grey100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_currencySymbol - $_currencyName ($_selectedCurrency)',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? CustomColors.white : CustomColors.primaryText,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: CustomColors.secondaryText),
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
                  final String catName = cat['name'];
                  bool isSelected = _selectedCategoryNames.contains(catName);
                  
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedCategoryNames.remove(catName);
                        } else {
                          _selectedCategoryNames.add(catName);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? CustomColors.primaryBlue : (isDark ? CustomColors.darkBlack : CustomColors.white),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : (isDark ? Colors.transparent : CustomColors.grey100),
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: CustomColors.primaryBlue.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ] : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cat['emoji'],
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            catName,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? CustomColors.white : (isDark ? CustomColors.white : CustomColors.primaryText),
                            ),
                          ),
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
