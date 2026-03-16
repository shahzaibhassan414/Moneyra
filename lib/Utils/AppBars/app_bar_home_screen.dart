import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyra/Controllers/user_controller.dart';
import '../../../Constants/custom_colors.dart';

class AppBarHomeScreen extends StatefulWidget implements PreferredSizeWidget {
  const AppBarHomeScreen({super.key});

  @override
  State<AppBarHomeScreen> createState() => _AppBarHomeScreenState();

  @override
  Size get preferredSize => const Size.fromHeight(70); 
}

class _AppBarHomeScreenState extends State<AppBarHomeScreen> {
  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return 'U';
    List<String> names = name.trim().split(" ");
    String initials = "";
    int numWords = names.length > 2 ? 2 : names.length;
    for (var i = 0; i < numWords; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0];
      }
    }
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final UserController userController = Get.find<UserController>();

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 70,
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Obx(() {
          final user = userController.user.value;
          return Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [CustomColors.primaryBlue, CustomColors.softTeal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? CustomColors.primaryGreen.withOpacity(0.5) : CustomColors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: CustomColors.primaryBlue.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  _getInitials(user?.fullName),
                  style: const TextStyle(
                    color: CustomColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
      title: Text(
        'Moneyra',
        style: TextStyle(
          color: isDark ? CustomColors.white : CustomColors.primaryBlue,
          fontWeight: FontWeight.w900,
          fontSize: 22,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none_rounded,
                color: isDark ? CustomColors.white : CustomColors.primaryText,
                size: 28,
              ),
            ),
            Positioned(
              top: 15,
              right: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: CustomColors.warningRed,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
