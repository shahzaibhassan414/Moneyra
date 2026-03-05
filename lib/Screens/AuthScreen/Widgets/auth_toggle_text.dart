import 'package:flutter/material.dart';

import '../../../Constants/custom_colors.dart';

class AuthToggleText extends StatelessWidget {
  final String question, action;
  final VoidCallback onTap;
  const AuthToggleText({super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: const TextStyle(color: CustomColors.secondaryText),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: const TextStyle(
              color: CustomColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
