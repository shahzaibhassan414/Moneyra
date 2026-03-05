import 'package:flutter/material.dart';
import '../../../Constants/custom_colors.dart';

class AuthPrivacyNote extends StatelessWidget {
  const AuthPrivacyNote({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.security_outlined,
            size: 20,
            color: CustomColors.primaryBlue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your data is processed locally for privacy. Moneyra works offline to keep your finances secure.',
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.primaryBlue.withOpacity(0.8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
