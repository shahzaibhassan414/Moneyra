import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyra/Models/category_model.dart';
import 'package:moneyra/Utils/feedback_utils.dart';
import '../../Constants/Constants.dart';
import '../../Constants/custom_colors.dart';
import '../../Controllers/user_controller.dart';
import '../../Utils/amount_format_controller.dart';
import '../../Utils/custom_button.dart';
import '../../Utils/custom_text_field.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _amountController = AmountFormatterController();
  final TextEditingController _noteController = TextEditingController();
  
  bool _isLoading = false;
  late String _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _selectedCategory = Constants.incomeCategories.first.name;
  }

  Future<void> _saveIncome() async {
    final amountText = _amountController.text.replaceAll(',', '');
    if (amountText.isEmpty) {
      FeedbackUtils.showInfo(context, 'Please enter an amount');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = userController.user.value;
      if (user != null) {
        // 1. Add to transactions collection with type 'income'
        await FirebaseFirestore.instance.collection('transactions').add({
          'userId': user.uid,
          'amount': double.parse(amountText),
          'category': _selectedCategory,
          'note': _noteController.text.trim(),
          'type': 'income',
          'date': Timestamp.fromDate(_selectedDate),
          'createdAt': FieldValue.serverTimestamp(),
        });

        // 2. Update user's monthlyIncome in Firestore
        // Note: You might want to distinguish between base salary and extra income
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
              'monthlyIncome': FieldValue.increment(double.parse(amountText)),
            });

        await userController.fetchUserData();

        if (mounted) {
          FeedbackUtils.showSuccess(context, 'Income added successfully!');
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        FeedbackUtils.showInfo(context, 'Failed to save: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String getCurrency() {
    return userController.user.value?.currencySymbol ?? '\$';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CustomColors.primaryGreen, // Green for income
              onPrimary: CustomColors.white,
              onSurface: CustomColors.primaryText,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundGray,
      appBar: AppBar(
        backgroundColor: CustomColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: CustomColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Income',
          style: TextStyle(color: CustomColors.primaryText, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter details for your new income',
              style: TextStyle(color: CustomColors.secondaryText, fontSize: 14),
            ),
            const SizedBox(height: 32),

            CustomTextField(
              label: 'Amount',
              hint: '0.00',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(getCurrency(), style: const TextStyle(fontWeight: FontWeight.bold, color: CustomColors.primaryGreen)),
              ),
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            const Text(
              'Category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CustomColors.primaryText),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CustomColors.grey100),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  items: Constants.incomeCategories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat.name,
                      child: Row(
                        children: [
                          Text(cat.emoji, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Text(cat.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CustomColors.primaryText),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CustomColors.grey100),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, color: CustomColors.primaryGreen, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            CustomTextField(
              label: 'Note (Optional)',
              hint: 'Where did this come from?',
              controller: _noteController,
              icon: Icons.edit_note_rounded,
            ),
            const SizedBox(height: 48),

            CustomButton(
              text: 'Save Income',
              isLoading: _isLoading,
              onPressed: _saveIncome,
            ),
          ],
        ),
      ),
    );
  }
}
