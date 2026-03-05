import 'package:flutter/material.dart';
import '../../Constants/custom_colors.dart';
import '../../Utils/AppBars/app_bar_home_screen.dart';
import 'Widgets/home_ai_insights_card.dart';
import 'Widgets/home_balance_card.dart';
import 'Widgets/home_overview_card.dart';
import 'Widgets/home_top_spending_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundGray,
      appBar: const AppBarHomeScreen(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            const Text(
              'Good morning, Alex!',
              style: TextStyle(
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

            homeBalanceCard(2450.50),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: homeOverviewCard(
                    title: 'Income',
                    amount: '4,200.00',
                    percentage: '+12%',
                    isPositive: true,
                    icon: Icons.arrow_downward_rounded,
                    color: CustomColors.lightBlue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: homeOverviewCard(
                    title: 'Expenses',
                    amount: '1,749.50',
                    percentage: '-5%',
                    isPositive: false,
                    icon: Icons.arrow_upward_rounded,
                    color: CustomColors.warningRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Top Spending Categories
            const Text(
              'Top Spending',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            homeTopSpendingRow('Food 🍔', 450, 0.4, Colors.orange),
            homeTopSpendingRow('Rent 🏠', 900, 0.8, CustomColors.primaryBlue),
            homeTopSpendingRow('Entertainment 🎮', 200, 0.2, Colors.purple),

            const SizedBox(height: 32),

            // AI Suggestions / Insights
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
                  homeAIInsightCard(
                    'You spent 20% more on dining this week. Consider reducing coffee purchases by 10%.',
                  ),
                  const SizedBox(width: 16),
                  homeAIInsightCard(
                    'Try saving \$50 by reducing online subscriptions.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: CustomColors.primaryBlue,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
    );
  }
}
