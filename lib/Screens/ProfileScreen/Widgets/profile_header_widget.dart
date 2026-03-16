import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyra/Controllers/user_controller.dart';
import '../../../Constants/custom_colors.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key});

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
    final UserController userController = Get.find<UserController>();

    return Obx(() {
      final user = userController.user.value;
      String initials = _getInitials(user?.fullName);

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
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: CustomColors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: CustomColors.white, width: 3),
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.fullName ?? 'User',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CustomColors.white,
              ),
            ),
            Text(
              user?.email ?? 'email@example.com',
              style: const TextStyle(fontSize: 14, color: CustomColors.white70),
            ),
          ],
        ),
      );
    });
  }
}
