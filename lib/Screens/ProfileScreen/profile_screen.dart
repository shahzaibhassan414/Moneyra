import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moneyra/Screens/AuthScreen/auth_screen.dart';
import 'package:moneyra/Screens/ProfileScreen/Widgets/profile_header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/custom_colors.dart';
import '../../Utils/custom_button_red.dart';
import '../../Utils/custom_toggle_button.dart';
import '../../Utils/feedback_utils.dart';
import 'Widgets/profile_financial_preferences.dart';
import 'Widgets/profile_section_title.dart';
import 'Widgets/settings_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _budgetAlerts = true;
  bool _aiSuggestions = true;
  bool _monthlyReports = false;

  Future<void> _logout() async {
    final SharedPreferences prefs = await _prefs;
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        prefs.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false,
        );
        FeedbackUtils.showSuccess(context, 'Logged out successfully');
      }
    } catch (e) {
      if (mounted) FeedbackUtils.showInfo(context, 'Error logging out: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundGray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderWidget(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ProfileFinancialPreferences(),
                  const SizedBox(height: 24),
                  ProfileSectionTitle(
                    title: 'Notifications',
                    children: [
                      CustomToggleButton(
                        title: 'Budget Alerts',
                        value: _budgetAlerts,
                        onChanged: (v) => setState(() => _budgetAlerts = v),
                      ),
                      CustomToggleButton(
                        title: 'AI Suggestions',
                        value: _aiSuggestions,
                        onChanged: (v) => setState(() => _aiSuggestions = v),
                      ),
                      CustomToggleButton(
                        title: 'Monthly Reports',
                        value: _monthlyReports,
                        onChanged: (v) => setState(() => _monthlyReports = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ProfileSectionTitle(
                    title: 'Data & Privacy',
                    children: [
                      SettingsTile(
                        icon: Icons.ios_share_outlined,
                        title: 'Export Financial Data',
                      ),
                      SettingsTile(
                        icon: Icons.sync_outlined,
                        title: 'Backup & Sync',
                      ),
                      SettingsTile(
                        icon: Icons.security_outlined,
                        title: 'Privacy Policy',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ProfileSectionTitle(
                    title: 'Support',
                    children: [
                      SettingsTile(
                        icon: Icons.help_outline,
                        title: 'Contact Support',
                      ),
                      SettingsTile(
                        icon: Icons.feedback_outlined,
                        title: 'Send Feedback',
                      ),
                      SettingsTile(
                        icon: Icons.star_outline,
                        title: 'Rate the App',
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  CustomButtonRed(
                    text: 'Log Out',
                    onTap: _logout,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
