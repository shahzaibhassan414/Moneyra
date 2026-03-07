import 'package:flutter/material.dart';
import '../../Constants/custom_colors.dart';
import '../../Utils/AppBars/app_bar_home_screen.dart';
import '../AddTransactionScreen/add_transaction_screen.dart';
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
            Text(
              'Good morning, Alex!',
              style: TextStyle(
                fontSize: 16,
                color: CustomColors.secondaryText,
              ),
            ),
            Text(
              "Here's your balance.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CustomColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),

            HomeBalanceCard(balance: 2450.50),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: HomeOverviewCard(
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
                  child: HomeOverviewCard(
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

            Text(
              'Top Spending',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            HomeTopSpendingRow(
              label: 'Food 🍔',
              amount: 450,
              percent: 0.4,
              color: CustomColors.orange,
            ),
            HomeTopSpendingRow(
              label: 'Rent 🏠',
              amount: 900,
              percent: 0.8,
              color: CustomColors.primaryBlue,
            ),
            HomeTopSpendingRow(
              label: 'Entertainment 🎮',
              amount: 200,
              percent: 0.2,
              color: CustomColors.purple,
            ),

            const SizedBox(height: 32),

            Text(
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
                  HomeAiInsightsCard(
                    text:
                    'You spent 20% more on dining this week. Consider reducing coffee purchases by 10%.',
                  ),
                  const SizedBox(width: 16),
                  HomeAiInsightsCard(
                    text:
                    'Try saving \$50 by reducing online subscriptions.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
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
