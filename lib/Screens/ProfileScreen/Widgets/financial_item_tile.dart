import 'package:flutter/material.dart';
import '../../../Constants/custom_colors.dart';

Widget financialItemTile(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Icon(icon, size: 20, color: CustomColors.secondaryText),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: CustomColors.secondaryText)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}