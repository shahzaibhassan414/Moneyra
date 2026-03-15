import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyra/Constants/Constants.dart';
import 'package:moneyra/Models/category_model.dart';
import 'package:moneyra/Utils/amount_format_controller.dart';
import 'package:moneyra/Utils/feedback_utils.dart';
import '../../Constants/custom_colors.dart';
import '../../Controllers/user_controller.dart';
import '../../Utils/custom_button.dart';
import '../../Utils/custom_text_field.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final UserController userController = Get.find<UserController>();

  final TextEditingController _nameController = TextEditingController();
  final _budgetController = AmountFormatterController();
  String _selectedIcon = Constants.availableCategoryIcons.first;
  bool _isLoading = false;

  Future<void> _saveCategory() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final user = userController.user.value;
      if (user == null) return;

      final budgetText = _budgetController.text.replaceAll(',', '');
      final double budget = double.tryParse(budgetText) ?? 0.0;

      final newCategory = CategoryModel(
        name: _nameController.text.trim(),
        emoji: _selectedIcon,
        budget: budget,
      );

      List<CategoryModel> updatedCategories = List.from(user.additionalCategories);
      updatedCategories.add(newCategory);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'additionalCategories': updatedCategories.map((cat) => cat.toJson()).toList(),
      });

      await userController.fetchUserData();

      if (mounted) {
        FeedbackUtils.showSuccess(context, 'Category added successfully!');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) FeedbackUtils.showInfo(context, 'Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : CustomColors.backgroundGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: isDark ? CustomColors.white : CustomColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add New Category',
          style: TextStyle(
            color: isDark ? CustomColors.white : CustomColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: CustomColors.primaryBlue.withOpacity(0.055),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _selectedIcon,
                      style: const TextStyle(fontSize: 32),
                    )),
              ),
              const SizedBox(height: 32),

              CustomTextField(
                label: 'Category Name',
                hint: 'e.g., Grocery, Gym',
                controller: _nameController,
                icon: Icons.edit_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              CustomTextField(
                label: 'Monthly Budget (Optional)',
                hint: '0',
                controller: _budgetController,
                keyboardType: TextInputType.number,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(userController.user.value?.currencySymbol ?? '\$'),
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Select Icon',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? CustomColors.white : CustomColors.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: Constants.availableCategoryIcons.length,
                itemBuilder: (context, index) {
                  bool isSelected =
                      _selectedIcon == Constants.availableCategoryIcons[index];
                  return InkWell(
                    onTap: () => setState(() =>
                        _selectedIcon = Constants.availableCategoryIcons[index]),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? CustomColors.primaryGreen.withOpacity(0.1)
                            : (isDark
                                ? const Color(0xFF1E1E1E)
                                : CustomColors.white),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? CustomColors.primaryGreen
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          Constants.availableCategoryIcons[index],
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 48),

              Center(
                child: CustomButton(
                  text: 'Save Category',
                  isLoading: _isLoading,
                  onPressed: _saveCategory,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
