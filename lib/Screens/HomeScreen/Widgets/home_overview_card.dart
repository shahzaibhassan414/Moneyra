import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Constants/custom_colors.dart';
import '../../../Controllers/user_controller.dart';
import '../../../Utils/currency_formatter.dart';

class HomeOverviewCard extends StatelessWidget {
  final String title;
  final String amount;
  final String percentage;
  final bool isPositive;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const HomeOverviewCard({
    super.key,
    required this.title,
    required this.amount,
    required this.percentage,
    required this.isPositive,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: CustomColors.grey100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 14, color: color),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: CustomColors.secondaryText,
                    fontSize: 12,
                  ),
                ),
                if (onTap != null) ...[
                  const Spacer(),
                  Icon(Icons.add_circle_outline_rounded, size: 16, color: color.withValues(alpha: 0.5)),
                ]
              ],
            ),
            const SizedBox(height: 12),
            Obx(() {
              final user = userController.user.value;
              return Text(
                "${user?.currencySymbol ?? ''}${CurrencyFormatter.format(amount)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              );
            }),
            const SizedBox(height: 4),
            Text(
              percentage,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isPositive ? CustomColors.green : CustomColors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
