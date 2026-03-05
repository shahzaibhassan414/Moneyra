import 'package:flutter/material.dart';

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
        _AuthTextField(
          label: 'Email Address',
          hint: 'name@example.com',
          controller: _emailController,
          icon: Icons.email_outlined,
        ),
        const SizedBox(height: 20),
        _AuthTextField(
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
            child: const Text('Forgot Password?', style: TextStyle(color: CustomColors.primaryBlue, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 32),
        _PrimaryButton(
          text: 'Sign In',
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavWrapper())),
        ),
        const SizedBox(height: 32),
        _AuthToggleText(
          question: "Don't have an account? ",
          action: "Sign Up",
          onTap: onToggle,
        ),
      ],
    );
  }
}