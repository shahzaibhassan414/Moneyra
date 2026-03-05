import 'package:flutter/material.dart';
import '../../../Constants/custom_colors.dart';

class AppBarHomeScreen extends StatefulWidget implements PreferredSizeWidget {
  const AppBarHomeScreen({super.key});

  @override
  State<AppBarHomeScreen> createState() => _AppBarHomeScreenState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarHomeScreenState extends State<AppBarHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'Moneyra',
        style: TextStyle(
          color: CustomColors.primaryBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: CustomColors.primaryText,
          ),
        ),
        const SizedBox(width: 8),
        const CircleAvatar(
          radius: 18,
          backgroundColor: CustomColors.primaryBlue,
          child: Icon(Icons.person, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
