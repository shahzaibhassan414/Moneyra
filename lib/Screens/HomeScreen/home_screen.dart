import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyra/Screens/HomeScreen/Widgets/top_spending_widget.dart';
import '../../Constants/custom_colors.dart';
import '../../Controllers/user_controller.dart';
import '../../Utils/AppBars/app_bar_home_screen.dart';
import '../AddTransactionScreen/add_transaction_screen.dart';
import 'Widgets/home_ai_insights_card.dart';
import 'Widgets/home_balance_card.dart';
import 'Widgets/home_overview_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: CustomColors.backgroundGray,
      appBar: const AppBarHomeScreen(),
      body: Obx(() {
        final user = userController.user.value;
        final bool isLoading = userController.isLoading.value;

        if (isLoading && user == null) {
          return const Center(child: CircularProgressIndicator(color: CustomColors.primaryBlue));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, ${user?.fullName ?? "User"}!',
                style: const TextStyle(
                  fontSize: 16,
                  color: CustomColors.secondaryText,
                ),
              ),
              const Text(
                "Here's your balance.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryText,
                ),
              ),
              const SizedBox(height: 16),

              HomeBalanceCard(
                balance: user == null 
                    ? '0' 
                    : (user.monthlyIncome - user.monthlyExpense).toString(),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: HomeOverviewCard(
                      title: 'Income',
                      amount: user?.monthlyIncome.toString() ?? "0",
                      percentage: '+12%',
                      isPositive: true,
                      icon: Icons.arrow_downward_rounded,
                      color: CustomColors.lightBlue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: HomeOverviewCard(
                      title: 'Expenses',
                      amount: user?.monthlyExpense.toString() ?? "0",
                      percentage: '-5%',
                      isPositive: false,
                      icon: Icons.arrow_upward_rounded,
                      color: CustomColors.warningRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),


              TopSpendingWidget(),

              const SizedBox(height: 32),

              const Text(
                'AI Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const HomeAiInsightsCard(
                      text: 'You spent 20% more on dining this week. Consider reducing coffee purchases by 10%.',
                    ),
                    const SizedBox(width: 16),
                    const HomeAiInsightsCard(
                      text: 'Try saving \$50 by reducing online subscriptions.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        backgroundColor: CustomColors.primaryBlue,
        child: const Icon(
          Icons.add_rounded,
          color: CustomColors.white,
          size: 32,
        ),
      ),
    );
  }
}
