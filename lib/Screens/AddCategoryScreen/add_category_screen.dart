import 'package:flutter/material.dart';
import '../../Constants/custom_colors.dart';
import '../../Utils/custom_button.dart';
import '../../Utils/custom_text_field.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  IconData _selectedIcon = Icons.category_rounded;
  Color _selectedColor = CustomColors.primaryBlue;

  final List<IconData> _availableIcons = [
    Icons.restaurant_rounded,
    Icons.shopping_cart_rounded,
    Icons.home_rounded,
    Icons.directions_car_rounded,
    Icons.movie_rounded,
    Icons.fitness_center_rounded,
    Icons.medical_services_rounded,
    Icons.school_rounded,
    Icons.flight_rounded,
    Icons.pets_rounded,
    Icons.sports_esports_rounded,
    Icons.local_gas_station_rounded,
    Icons.work_rounded,
    Icons.card_giftcard_rounded,
    Icons.account_balance_rounded,
  ];

  final List<Color> _availableColors = [
    CustomColors.primaryBlue,
    CustomColors.primaryGreen,
    CustomColors.warningRed,
    CustomColors.softTeal,
    CustomColors.lightBlue,
    CustomColors.gold,
    CustomColors.orange,
    CustomColors.purple,
    CustomColors.amber,
    Colors.pink,
    Colors.brown,
    Colors.indigo,
  ];

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Circle
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _selectedColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _selectedIcon,
                  size: 64,
                  color: _selectedColor,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Name Field
            CustomTextField(
              label: 'Category Name',
              hint: 'e.g., Grocery, Gym',
              controller: _nameController,
              icon: Icons.edit_rounded,
            ),
            const SizedBox(height: 32),

            // Icon Selection
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
              itemCount: _availableIcons.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedIcon == _availableIcons[index];
                return InkWell(
                  onTap: () => setState(() => _selectedIcon = _availableIcons[index]),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? _selectedColor.withOpacity(0.1) 
                          : (isDark ? const Color(0xFF1E1E1E) : CustomColors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? _selectedColor : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      _availableIcons[index],
                      color: isSelected ? _selectedColor : CustomColors.secondaryText,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Color Selection
            Text(
              'Select Color',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? CustomColors.white : CustomColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _availableColors.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  bool isSelected = _selectedColor == _availableColors[index];
                  return InkWell(
                    onTap: () => setState(() => _selectedColor = _availableColors[index]),
                    child: Container(
                      width: 50,
                      decoration: BoxDecoration(
                        color: _availableColors[index],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? (isDark ? CustomColors.white : CustomColors.black) : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: isSelected 
                          ? Icon(Icons.check_rounded, color: CustomColors.white, size: 24) 
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 48),

            // Save Button
            CustomButton(
              text: 'Save Category',
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  // Logic to save category goes here
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
