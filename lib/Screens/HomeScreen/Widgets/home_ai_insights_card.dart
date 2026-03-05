import 'package:flutter/material.dart';
import '../../../Constants/custom_colors.dart';

Widget homeAIInsightCard(String text) {
  return Container(
    width: 280,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: CustomColors.lightBlue.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: CustomColors.lightBlue.withValues(alpha:0.1)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 20),
            const SizedBox(width: 8),
            Text(
              'AI Tip',
              style: TextStyle(
                color: CustomColors.lightBlue.withValues(alpha:0.8),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: CustomColors.primaryText,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text('Ignore', style: TextStyle(color: CustomColors.secondaryText, fontSize: 12)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.lightBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Apply Tip', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ],
    ),
  );
}