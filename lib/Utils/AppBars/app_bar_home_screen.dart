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
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      title:  Text(
        'Moneyra',
        style: TextStyle(
          color: isDark ? CustomColors.primaryGreen :CustomColors.primaryBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // IconButton(
        //   onPressed: () {},
        //   icon:  Icon(
        //     Icons.notifications_none_rounded,
        //     color: isDark ? CustomColors.white : CustomColors.primaryText,
        //   ),
        // ),
        // const SizedBox(width: 20),
      ],
    );
  }
}
