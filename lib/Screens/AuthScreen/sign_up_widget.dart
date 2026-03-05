import 'package:flutter/material.dart';
import 'package:moneyra/Utils/custom_text_field.dart';
import '../../Constants/custom_colors.dart';
import '../../Utils/custom_button.dart';
import '../BottomNav/bottom_nav.dart';
import 'Widgets/auth_toggle_text.dart';

class SignUpWidget extends StatelessWidget {
  final VoidCallback onToggle;
  SignUpWidget({super.key, required this.onToggle});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Create your account',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: CustomColors.secondaryText),
        ),
        const SizedBox(height: 48),
        CustomTextField(
          label: 'Full Name',
          hint: 'John Doe',
          controller: _nameController,
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'Email Address',
          hint: 'name@example.com',
          controller: _emailController,
          icon: Icons.email_outlined,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'Password',
          hint: 'Create a password',
          controller: _passwordController,
          icon: Icons.lock_outline,
          isPassword: true,
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: 'Create Account',
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavWrapper()),
          ),
        ),
        const SizedBox(height: 32),
        AuthToggleText(
          question: "Already have an account? ",
          action: "Login",
          onTap: onToggle,
        ),
      ],
    );
  }
}
