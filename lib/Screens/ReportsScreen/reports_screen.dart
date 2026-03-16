import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyra/Controllers/user_controller.dart';
import 'package:moneyra/Utils/AppBars/app_bar_with_center_text.dart';
import '../../Constants/custom_colors.dart';
import 'Widgets/reports_trend_chart.dart';
import 'Widgets/spend_by_catrgory_list.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: CustomColors.backgroundGray,
      appBar: const AppBarWithCenterText(text: 'Reports & Trends'),
      body: Obx(() {
        final transactions = userController.allTransactions;
        final user = userController.user.value;

        if (userController.isLoading.value && transactions.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: CustomColors.primaryBlue));
        }

        return SingleChildScrollView(
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
              reportTrendsChart(transactions),
              const SizedBox(height: 32),

              const Text(
                'Transaction History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              spendByCategoryList(
                context,
                transactions, 
                user?.currencySymbol ?? '\$'
              ),
            ],
          ),
        );
      }),
    );
  }
}
