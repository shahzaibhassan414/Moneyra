import 'package:flutter/material.dart';
import 'package:moneyra/Screens/AuthScreen/sign_in_widget.dart';
import 'package:moneyra/Screens/AuthScreen/sign_up_widget.dart';
import '../../Constants/custom_colors.dart';
import 'Widgets/auth_privacy_note.dart';
import 'Widgets/social_auth_section.dart';

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

                isLogin
                    ? SignInWidget(onToggle: toggleAuth)
                    : SignUpWidget(onToggle: toggleAuth),

                const SizedBox(height: 32),

                const SocialAuthSection(),

                const SizedBox(height: 60),

                const AuthPrivacyNote(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
