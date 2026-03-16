import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyra/Models/category_model.dart';
import 'package:moneyra/Models/user_model.dart';
import 'package:moneyra/Utils/feedback_utils.dart';
import '../../Constants/Constants.dart';
import '../../Constants/custom_colors.dart';
import '../../Controllers/user_controller.dart';
import '../../Utils/amount_format_controller.dart';
import '../../Utils/custom_button.dart';
import '../../Utils/custom_text_field.dart';
import '../AddCategoryScreen/add_category_screen.dart';

class AddTransactionScreen extends StatefulWidget {
  final Map<String, dynamic>? transactionToEdit;
  const AddTransactionScreen({super.key, this.transactionToEdit});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = AmountFormatterController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _aiController = TextEditingController();

  bool _isLoading = false;
  late String _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    if (widget.transactionToEdit != null) {
      // Edit Mode
      final tx = widget.transactionToEdit!;
      _amountController.text = tx['amount'].toString();
      _noteController.text = tx['note'] ?? '';
      _selectedCategory = tx['category'];
      _selectedDate = (tx['date'] as dynamic)?.toDate() ?? DateTime.now();
    } else {
      // Add Mode
      final user = userController.user.value;
      if (user != null && user.additionalCategories.isNotEmpty) {
        _selectedCategory = user.additionalCategories.first.name;
      } else {
        _selectedCategory = Constants.transactionCategories.first.name;
      }
    }
  }

  Future<void> _saveTransaction() async {
    final amountText = _amountController.text.replaceAll(',', '');
    if (amountText.isEmpty) {
      FeedbackUtils.showInfo(context, 'Please enter an amount');
      return;
    }

    final double newAmount = double.parse(amountText);
    setState(() => _isLoading = true);

    try {
      final user = userController.user.value;
      if (user != null) {
        if (widget.transactionToEdit != null) {
          // UPDATE MODE
          final String txId = widget.transactionToEdit!['id'];
          final double oldAmount = double.parse(widget.transactionToEdit!['amount'].toString());
          final String oldType = widget.transactionToEdit!['type'] ?? 'expense';

          // 1. Update the transaction
          await FirebaseFirestore.instance.collection('transactions').doc(txId).update({
            'amount': newAmount,
            'category': _selectedCategory,
            'note': _noteController.text.trim(),
            'date': Timestamp.fromDate(_selectedDate),
          });

          // 2. Adjust User Balance (Subtract old, add new)
          final double diff = newAmount - oldAmount;
          if (oldType == 'income') {
            await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
              'monthlyIncome': FieldValue.increment(diff),
            });
          } else {
            await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
              'monthlyExpense': FieldValue.increment(diff),
            });
          }
        } else {
          // ADD MODE
          await FirebaseFirestore.instance.collection('transactions').add({
            'userId': user.uid,
            'amount': newAmount,
            'category': _selectedCategory,
            'note': _noteController.text.trim(),
            'type': 'expense',
            'date': Timestamp.fromDate(_selectedDate),
            'createdAt': FieldValue.serverTimestamp(),
          });

          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'monthlyExpense': FieldValue.increment(newAmount),
          });
        }

        await userController.refreshAllData();

        if (mounted) {
          FeedbackUtils.showSuccess(context, 'Transaction saved!');
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) FeedbackUtils.showInfo(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String getCurrency() {
    return userController.user.value?.currencySymbol ?? '\$';
  }

  void _handleAIInput(String text) {
    final amountRegex = RegExp(r'\$?\d+(\.\d+)?');
    final match = amountRegex.firstMatch(text);

    if (match != null) {
      String amount = match.group(0)!.replaceAll('\$', '');
      setState(() {
        _amountController.text = amount;
        if (text.toLowerCase().contains('grocery') ||
            text.toLowerCase().contains('food')) {
          _selectedCategory = 'Groceries';
        } else if (text.toLowerCase().contains('bill')) {
          _selectedCategory = 'Bills';
        }
      });
    }
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
              primary: CustomColors.primaryBlue,
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
    bool isEdit = widget.transactionToEdit != null;

    return Scaffold(
      backgroundColor: CustomColors.backgroundGray,
      appBar: AppBar(
        backgroundColor: CustomColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: CustomColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? 'Edit Transaction' : 'Add Transaction',
          style: const TextStyle(color: CustomColors.primaryText, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            if (!isEdit) ...[
              _buildAiSection(),
              const SizedBox(height: 32),
            ],

            CustomTextField(
              label: 'Amount',
              hint: '0.00',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(getCurrency()),
              ),
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CustomColors.primaryText),
              ),
            ),
            const SizedBox(height: 12),
            
            Obx(() {
              final user = userController.user.value;
              final List<CategoryModel> cats = user?.additionalCategories.isNotEmpty == true 
                  ? user!.additionalCategories 
                  : Constants.transactionCategories;
              
              if (!cats.any((c) => c.name == _selectedCategory)) {
                _selectedCategory = cats.first.name;
              }

              return Container(
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
                    items: cats.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat.name,
                        child: Row(
                          children: [
                            Text(cat.emoji),
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
              );
            }),

            const SizedBox(height: 24),
            _buildDatePicker(),
            const SizedBox(height: 24),
            
            CustomTextField(
              label: 'Note (Optional)',
              hint: 'What was this for?',
              controller: _noteController,
              icon: Icons.edit_note_rounded,
            ),
            const SizedBox(height: 40),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: CustomColors.grey200),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: CustomColors.secondaryText)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: isEdit ? 'Update' : 'Save',
                    isLoading: _isLoading,
                    onPressed: _saveTransaction,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomColors.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CustomColors.primaryBlue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: CustomColors.gold, size: 20),
              SizedBox(width: 8),
              Text('AI Quick Add', style: TextStyle(fontWeight: FontWeight.bold, color: CustomColors.primaryBlue)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _aiController,
            onChanged: _handleAIInput,
            decoration: InputDecoration(
              hintText: 'e.g., Spent ${getCurrency()} 15 on lunch',
              hintStyle: const TextStyle(color: CustomColors.secondaryText),
              border: InputBorder.none,
              filled: true,
              fillColor: CustomColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: CustomColors.grey100)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: CustomColors.primaryBlue)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CustomColors.primaryText)),
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
                const Icon(Icons.calendar_today_rounded, color: CustomColors.primaryBlue, size: 20),
                const SizedBox(width: 12),
                Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
