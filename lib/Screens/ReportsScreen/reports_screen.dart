import 'package:flutter/material.dart';
import 'package:moneyra/Utils/AppBars/app_bar_with_center_text.dart';
import '../../Constants/custom_colors.dart';
import 'Widgets/reports_trend_chart.dart';
import 'Widgets/spend_by_catrgory_list.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundGray,
      appBar: AppBarWithCenterText(text: 'Reports & Trends'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spending Trends',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            reportTrendsChart(),
            const SizedBox(height: 32),

            const Text(
              'Spending by Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            spendByCategoryList(),
          ],
        ),
      ),
    );
  }
}
