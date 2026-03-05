import 'package:flutter/material.dart';
import 'package:moneyra/Screens/AuthScreen/Widgets/auth_toggle_text.dart';
import 'package:moneyra/Utils/custom_button.dart';
import 'package:moneyra/Utils/custom_text_field.dart';
import '../../Constants/custom_colors.dart';
import '../BottomNav/bottom_nav.dart';

class SignInWidget extends StatelessWidget {
  final VoidCallback onToggle;
  SignInWidget({super.key, required this.onToggle});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Welcome back',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: CustomColors.secondaryText),
        ),
        const SizedBox(height: 48),
        CustomTextField(
          label: 'Email Address',
          hint: 'name@example.com',
          controller: _emailController,
          icon: Icons.email_outlined,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'Password',
          hint: 'Enter your password',
          controller: _passwordController,
          icon: Icons.lock_outline,
          isPassword: true,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: CustomColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: 'Sign In',
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavWrapper()),
          ),
        ),
        const SizedBox(height: 32),
        AuthToggleText(
          question: "Don't have an account? ",
          action: "Sign Up",
          onTap: onToggle,
        ),
      ],
    );
  }
}
