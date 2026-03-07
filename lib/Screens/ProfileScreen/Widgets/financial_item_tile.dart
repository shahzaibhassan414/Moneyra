import 'package:flutter/material.dart';
import '../../../Constants/custom_colors.dart';

class FinancialItemTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const FinancialItemTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: CustomColors.secondaryText),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: CustomColors.secondaryText)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
