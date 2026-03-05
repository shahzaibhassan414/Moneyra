import 'package:flutter/material.dart';
import '../../../Constants/custom_colors.dart';

class SocialAuthSection extends StatelessWidget {
  const SocialAuthSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: TextStyle(
                  color: CustomColors.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _socialButton(
                label: 'Google',
                icon: Icons.g_mobiledata_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _socialButton(label: 'Apple', icon: Icons.apple),
            ),
          ],
        ),
      ],
    );
  }

  Widget _socialButton({required String label, required IconData icon}) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.black, size: 24),
      label: Text(
        label,
        style: const TextStyle(
          color: CustomColors.primaryText,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
