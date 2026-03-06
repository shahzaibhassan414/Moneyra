import 'package:flutter/material.dart';
import '../Constants/custom_colors.dart';

class CustomButtonRed extends StatelessWidget {
  final String text;
  final Function() onTap;
  const CustomButtonRed({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: CustomColors.warningRed, width: 1),
          ),
        ),
        child:  Text(
          text,
          style: TextStyle(
            color: CustomColors.warningRed,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
