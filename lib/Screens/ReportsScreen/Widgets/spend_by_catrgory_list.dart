import 'package:flutter/material.dart';
import '../../../Constants/custom_colors.dart';

Widget spendByCategoryList() {
  final categories = [
    {
      'name': 'Food & Dining',
      'amount': 450.0,
      'icon': Icons.restaurant,
      'color': CustomColors.orange,
    },
    {
      'name': 'Rent & Bills',
      'amount': 900.0,
      'icon': Icons.home,
      'color': CustomColors.primaryBlue,
    },
    {
      'name': 'Entertainment',
      'amount': 200.0,
      'icon': Icons.movie,
      'color': CustomColors.purple,
    },
    {
      'name': 'Transport',
      'amount': 150.0,
      'icon': Icons.directions_car,
      'color': CustomColors.softTeal,
    },
  ];

  return Column(
    children: categories.map((cat) {
      return Container(
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
                color: (cat['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                cat['icon'] as IconData,
                color: cat['color'] as Color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat['name'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${((cat['amount'] as double) / 1700 * 100).toStringAsFixed(1)}% of total spent',
                    style: const TextStyle(
                      fontSize: 12,
                      color: CustomColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '\$${(cat['amount'] as double).toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColors.primaryText,
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );
}
