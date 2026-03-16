import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyra/Utils/currency_formatter.dart';
import '../../../Constants/custom_colors.dart';

Widget reportTrendsChart(List<Map<String, dynamic>> transactions) {
  // 1. Get the last 7 days (including today)
  final now = DateTime.now();
  final List<DateTime> last7Days = List.generate(7, (index) {
    return DateTime(now.year, now.month, now.day).subtract(Duration(days: 6 - index));
  });

  // 2. Map day name to its spending total
  Map<DateTime, double> dailySpending = {for (var day in last7Days) day: 0.0};

  double totalWeekSpent = 0.0;

  for (var tx in transactions) {
    final DateTime date = (tx['date'] as dynamic)?.toDate() ?? DateTime.now();
    final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    final String type = tx['type'] ?? 'expense';
    
    if (type == 'expense' && dailySpending.containsKey(normalizedDate)) {
      final double amount = double.tryParse(tx['amount'].toString()) ?? 0.0;
      dailySpending[normalizedDate] = (dailySpending[normalizedDate] ?? 0.0) + amount;
      totalWeekSpent += amount;
    }
  }

  // 3. Find max value for scaling
  double maxSpent = dailySpending.values.fold(0.0, (max, val) => val > max ? val : max);
  if (maxSpent == 0) maxSpent = 1.0; 

  final List<double> scaledValues = last7Days.map((day) => dailySpending[day]! / maxSpent).toList();
  final List<String> days = last7Days.map((day) => DateFormat('E').format(day).substring(0, 1)).toList();

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: CustomColors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: CustomColors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Last 7 Days',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColors.primaryText,
              ),
            ),
            Text(
              CurrencyFormatter.format(totalWeekSpent),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColors.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 125, // Height matching the bar area
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAxisLabel(maxSpent),
                  _buildAxisLabel(maxSpent / 2),
                  _buildAxisLabel(0),
                ],
              ),
            ),
            SizedBox(width: 16),
            // Left side: The Chart
            Expanded(
              child: SizedBox(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(scaledValues.length, (index) {
                    final isToday = index == 6;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 20,
                          height: 100 * scaledValues[index],
                          decoration: BoxDecoration(
                            color: isToday
                                ? CustomColors.primaryBlue
                                : CustomColors.lightBlue.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          days[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            color: isToday ? CustomColors.primaryBlue : CustomColors.secondaryText,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildAxisLabel(double value) {
  String label;
  if (value >= 1000) {
    label = '${(value / 1000).toStringAsFixed(1)}k';
  } else {
    label = value.toInt().toString();
  }
  
  return Text(
    label,
    style: const TextStyle(
      fontSize: 10,
      color: CustomColors.secondaryText,
      fontWeight: FontWeight.w500,
    ),
  );
}
