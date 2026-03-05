import 'package:flutter/material.dart';
import '../../Constants/custom_colors.dart';
import '../HomeScreen/bottom_nav_wrapper.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  void toggleAuth() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundGray,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Moneyra',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primaryBlue,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Switch between Sign In and Sign Up widgets
                isLogin 
                  ? SignInWidget(onToggle: toggleAuth) 
                  : SignUpWidget(onToggle: toggleAuth),

                const SizedBox(height: 32),
                
                // Divider & Social remains common
                const _SocialAuthSection(),
                
                const SizedBox(height: 60),
                
                // Privacy & Offline Note remains common
                const _PrivacyNote(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



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
        _AuthTextField(
          label: 'Full Name',
          hint: 'John Doe',
          controller: _nameController,
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 20),
        _AuthTextField(
          label: 'Email Address',
          hint: 'name@example.com',
          controller: _emailController,
          icon: Icons.email_outlined,
        ),
        const SizedBox(height: 20),
        _AuthTextField(
          label: 'Password',
          hint: 'Create a password',
          controller: _passwordController,
          icon: Icons.lock_outline,
          isPassword: true,
        ),
        const SizedBox(height: 32),
        _PrimaryButton(
          text: 'Create Account',
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavWrapper())),
        ),
        const SizedBox(height: 32),
        _AuthToggleText(
          question: "Already have an account? ",
          action: "Login",
          onTap: onToggle,
        ),
      ],
    );
  }
}

// Helper Widgets to keep code DRY
class _AuthTextField extends StatelessWidget {
  final String label, hint;
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;

  const _AuthTextField({required this.label, required this.hint, required this.controller, required this.icon, this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: CustomColors.primaryText)),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: CustomColors.secondaryText, size: 20),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: CustomColors.primaryBlue, width: 1.5)),
        ),
      ),
    ]);
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: CustomColors.primaryBlue, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _AuthToggleText extends StatelessWidget {
  final String question, action;
  final VoidCallback onTap;
  const _AuthToggleText({required this.question, required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(question, style: const TextStyle(color: CustomColors.secondaryText)),
      GestureDetector(onTap: onTap, child: Text(action, style: const TextStyle(color: CustomColors.primaryBlue, fontWeight: FontWeight.bold))),
    ]);
  }
}

class _SocialAuthSection extends StatelessWidget {
  const _SocialAuthSection();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('OR', style: TextStyle(color: CustomColors.secondaryText, fontSize: 12, fontWeight: FontWeight.bold))),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ]),
      const SizedBox(height: 32),
      Row(children: [
        Expanded(child: _socialButton(label: 'Google', icon: Icons.g_mobiledata_rounded)),
        const SizedBox(width: 16),
        Expanded(child: _socialButton(label: 'Apple', icon: Icons.apple)),
      ]),
    ]);
  }

  Widget _socialButton({required String label, required IconData icon}) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.black, size: 24),
      label: Text(label, style: const TextStyle(color: CustomColors.primaryText, fontWeight: FontWeight.w600)),
      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), side: BorderSide(color: Colors.grey.shade300), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        const Icon(Icons.security_outlined, size: 20, color: CustomColors.primaryBlue),
        const SizedBox(width: 12),
        Expanded(child: Text('Your data is processed locally for privacy. Moneyra works offline to keep your finances secure.', style: TextStyle(fontSize: 12, color: CustomColors.primaryBlue.withOpacity(0.8), height: 1.4))),
      ]),
    );
  }
}
