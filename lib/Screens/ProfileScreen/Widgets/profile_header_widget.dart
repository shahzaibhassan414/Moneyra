import 'package:flutter/material.dart';

import '../../../Constants/custom_colors.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 80, bottom: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [CustomColors.primaryBlue, CustomColors.softTeal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.account_balance_wallet,
            size: 100,
            color: CustomColors.primaryGreen,
          ),
          const SizedBox(height: 16),
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CustomColors.white,
            ),
          ),
          const Text(
            'john@email.com',
            style: TextStyle(fontSize: 14, color: CustomColors.white70),
          ),
        ],
      ),
    );
  }
}

