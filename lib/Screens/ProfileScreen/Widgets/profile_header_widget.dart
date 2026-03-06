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
          Stack(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: CustomColors.white,
                child: CircleAvatar(
                  radius: 46,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?u=moneyra',
                  ), // Placeholder
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: CustomColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 20,
                    color: CustomColors.primaryBlue,
                  ),
                ),
              ),
            ],
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

