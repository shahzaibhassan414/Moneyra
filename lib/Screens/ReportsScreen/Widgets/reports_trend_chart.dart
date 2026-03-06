import 'package:flutter/material.dart';
import '../../../Constants/custom_colors.dart';

Widget reportTrendsChart() {
  final List<double> values = [0.4, 0.7, 0.5, 0.9, 0.6, 0.8, 0.4];
  final List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: CustomColors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: CustomColors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'This Week',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColors.primaryText,
              ),
            ),
            Text(
              '\$1,240.00',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColors.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(values.length, (index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 20,
                    height: 100 * values[index],
                    decoration: BoxDecoration(
                      color: index == 3
                          ? CustomColors.primaryBlue
                          : CustomColors.lightBlue.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    days[index],
                    style: const TextStyle(
                      fontSize: 12,
                      color: CustomColors.secondaryText,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    ),
  );
}
