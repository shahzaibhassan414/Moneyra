import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moneyra/Screens/AuthScreen/Widgets/auth_toggle_text.dart';
import 'package:moneyra/Utils/custom_button.dart';
import 'package:moneyra/Utils/custom_text_field.dart';
import 'package:moneyra/Utils/feedback_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/custom_colors.dart';
import '../BottomNav/bottom_nav.dart';
import 'additional_data_screen.dart';

class SignInWidget extends StatefulWidget {
  final VoidCallback onToggle;
  const SignInWidget({super.key, required this.onToggle});

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    final SharedPreferences prefs = await _prefs;
    setState(() => _isLoading = true);

    try {
      final UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (credential.user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .get();

        if (mounted) {
          final userData = userDoc.data();
          bool isSetupComplete = userData?['isSetupComplete'] ?? false;

          if (isSetupComplete) {
            prefs.setBool("isLogin", true);
            FeedbackUtils.showSuccess(context, 'Welcome back!');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavWrapper()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdditionalDataScreen()),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      String message = 'An error occurred';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      }
      if (mounted) FeedbackUtils.showInfo(context, message);
    } catch (e) {
      if (mounted) FeedbackUtils.showInfo(context, e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
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
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              } else if (EmailValidator.validate(_emailController.text) == false) {
                return "Invalid e-mail, Please try again";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: 'Password',
            hint: 'Enter your password',
            controller: _passwordController,
            icon: Icons.lock_outline,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                if (_emailController.text.isNotEmpty) {
                  FirebaseAuth.instance.sendPasswordResetEmail(
                    email: _emailController.text.trim(),
                  );
                  FeedbackUtils.showInfo(context, 'Password reset email sent!');
                } else {
                  FeedbackUtils.showInfo(
                    context,
                    'Please enter your email first.',
                  );
                }
              },
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
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _signIn();
              }
            },
            isLoading: _isLoading,
          ),
          const SizedBox(height: 32),
          AuthToggleText(
            question: "Don't have an account? ",
            action: "Sign Up",
            onTap: widget.onToggle,
          ),
        ],
      ),
    );
  }
}
