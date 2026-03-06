import 'package:flutter/material.dart';
import '../../Constants/custom_colors.dart';
import '../../Utils/custom_button.dart';
import '../../Utils/custom_text_field.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _aiController = TextEditingController();
  
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food', 'icon': Icons.restaurant_rounded, 'emoji': '🍔'},
    {'name': 'Rent', 'icon': Icons.home_rounded, 'emoji': '🏠'},
    {'name': 'Entertainment', 'icon': Icons.sports_esports_rounded, 'emoji': '🎮'},
    {'name': 'Transport', 'icon': Icons.directions_car_rounded, 'emoji': '🚗'},
    {'name': 'Shopping', 'icon': Icons.shopping_bag_rounded, 'emoji': '🛍️'},
    {'name': 'Salary', 'icon': Icons.payments_rounded, 'emoji': '💰'},
  ];

  void _handleAIInput(String text) {
    final amountRegex = RegExp(r'\$?\d+(\.\d+)?');
    final match = amountRegex.firstMatch(text);
    
    if (match != null) {
      String amount = match.group(0)!.replaceAll('\$', '');
      setState(() {
        _amountController.text = amount;
        
        if (text.toLowerCase().contains('lunch') || text.toLowerCase().contains('food')) {
          _selectedCategory = 'Food';
        } else if (text.toLowerCase().contains('rent')) {
          _selectedCategory = 'Rent';
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
          'Add Transaction',
          style: TextStyle(
            color: CustomColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CustomColors.primaryBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: CustomColors.primaryBlue.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome_rounded, color: CustomColors.gold, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'AI Quick Add',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _aiController,
                    onChanged: _handleAIInput,
                    decoration: InputDecoration(
                      hintText: 'e.g., Spent \$15 on lunch',
                      hintStyle: const TextStyle(color: CustomColors.secondaryText),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: CustomColors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: CustomColors.grey100),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: CustomColors.primaryBlue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Amount Field
            CustomTextField(
              label: 'Amount',
              hint: '0.00',
              controller: _amountController,
              icon: Icons.attach_money_rounded,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Category Dropdown
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Category',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CustomColors.primaryText,
                ),
              ),
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
                  items: _categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat['name'],
                      child: Row(
                        children: [
                          Icon(cat['icon'], color: CustomColors.primaryBlue, size: 20),
                          const SizedBox(width: 12),
                          Text('${cat['emoji']} ${cat['name']}'),
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

            // Date Picker
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CustomColors.primaryText,
                ),
              ),
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
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Note Field
            CustomTextField(
              label: 'Note (Optional)',
              hint: 'What was this for?',
              controller: _noteController,
              icon: Icons.edit_note_rounded,
            ),
            const SizedBox(height: 40),

            // Save/Cancel Buttons
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
                    text: 'Save',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
