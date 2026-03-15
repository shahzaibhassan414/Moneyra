import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moneyra/Utils/custom_text_field.dart';
import '../../Constants/custom_colors.dart';
import '../../Utils/custom_button.dart';
import '../../Utils/feedback_utils.dart';
import '../BottomNav/bottom_nav.dart';
import 'Widgets/auth_toggle_text.dart';
import 'additional_data_screen.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onToggle;
  const SignUpWidget({super.key, required this.onToggle});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {

    setState(() => _isLoading = true);

    try {
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (credential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
          'uid': credential.user!.uid,
          'fullName': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'isActive' : true,
        });

        if (mounted) {
          FeedbackUtils.showSuccess(context, 'Account created successfully!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdditionalDataScreen()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
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
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: 'Email Address',
            hint: 'name@example.com',
            controller: _emailController,
            icon: Icons.email_outlined,
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Please enter your email address';
              }else if (EmailValidator.validate(
                  _emailController.text) ==
                  false){
                return "Invalid e-mail, Please try again";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: 'Password',
            hint: 'Create a password',
            controller: _passwordController,
            icon: Icons.lock_outline,
            isPassword: true,
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: 'Confirm Password',
            hint: 'Confirm your password',
            controller: _confirmPasswordController,
            icon: Icons.lock_outline,
            isPassword: true,
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Please enter your confirm password';
              } else if (value != _passwordController.text) {
                return 'Password do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Create Account',
            onPressed: (){
              if(formKey.currentState!.validate()){
                _signUp();
              }
            },
            isLoading: _isLoading,
          ),
          const SizedBox(height: 32),
          AuthToggleText(
            question: "Already have an account? ",
            action: "Login",
            onTap: widget.onToggle,
          ),
        ],
      ),
    );
  }
}
