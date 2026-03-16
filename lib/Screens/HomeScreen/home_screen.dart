import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyra/Screens/HomeScreen/Widgets/top_spending_widget.dart';
import '../../Constants/custom_colors.dart';
import '../../Controllers/user_controller.dart';
import '../AddIncomeScreen/add_income_screen.dart';
import '../AddTransactionScreen/add_transaction_screen.dart';
import 'Widgets/home_ai_insights_card.dart';
import 'Widgets/home_balance_card.dart';
import 'Widgets/home_overview_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return 'U';
    List<String> names = name.trim().split(" ");
    String initials = "";
    int numWords = names.length > 2 ? 2 : names.length;
    for (var i = 0; i < numWords; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0];
      }
    }
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: CustomColors.backgroundGray,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: CustomColors.backgroundGray,
              elevation: 0,
              centerTitle: true,
              expandedHeight: 70,
              toolbarHeight: 70,
              leadingWidth: 70,
              leading: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Obx(() {
                  final user = userController.user.value;
                  return Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [CustomColors.primaryBlue, CustomColors.softTeal],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? CustomColors.primaryGreen.withValues(alpha: 0.5) : CustomColors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.primaryBlue.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(user?.fullName),
                          style: const TextStyle(
                            color: CustomColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              title: Text(
                'Moneyra',
                style: TextStyle(
                  color: isDark ? CustomColors.white : CustomColors.primaryBlue,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ];
        },
        body: Obx(() {
          final user = userController.user.value;
          final bool isLoading = userController.isLoading.value;
          
          // Use this month's aggregated values
          final income = userController.thisMonthIncome.value;
          final expense = userController.thisMonthExpense.value;
          final balance = income - expense;

          if (isLoading && user == null) {
            return const Center(
              child: CircularProgressIndicator(color: CustomColors.primaryBlue),
            );
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
                  balance: balance.toString(),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: HomeOverviewCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddIncomeScreen(),
                            ),
                          );
                        },
                        title: 'Income',
                        amount: income.toString(),
                        percentage: '+12%',
                        isPositive: true,
                        icon: Icons.arrow_downward_rounded,
                        color: CustomColors.lightBlue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: HomeOverviewCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddTransactionScreen(),
                            ),
                          );
                        },
                        title: 'Expenses',
                        amount: expense.toString(),
                        percentage: '-5%',
                        isPositive: false,
                        icon: Icons.arrow_upward_rounded,
                        color: CustomColors.warningRed,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                const TopSpendingWidget(),

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
                        text:
                            'You spent 20% more on dining this week. Consider reducing coffee purchases by 10%.',
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
      ),
    );
  }
}
