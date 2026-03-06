import 'package:flutter/material.dart';
import '../../../Constants/custom_colors.dart';

class AppBarWithCenterText extends StatefulWidget implements PreferredSizeWidget {
  final String text;
  const AppBarWithCenterText({super.key, required this.text});

  @override
  State<AppBarWithCenterText> createState() => _AppBarWithCenterTextState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarWithCenterTextState extends State<AppBarWithCenterText> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.transparent,
      elevation: 0,
      title:  Text(
        widget.text,
        style: TextStyle(
          color: CustomColors.primaryText,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
