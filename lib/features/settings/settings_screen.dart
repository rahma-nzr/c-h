import 'package:code_hire/routes/app_routes.dart';
import 'package:flutter/material.dart';
//import 'package:code_hire/features/settings/about_app_screen.dart';
import 'package:code_hire/features/auth/screens/forgot_password_screen.dart';
import '../../core/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Color.fromARGB(255, 4, 26, 134),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 10),
          Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About the App',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'CodeHire is a platform connecting developers with opportunities. '
                      'Version 1.0.0',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Developed by:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Your Company Name'),
                    const SizedBox(height: 8),
                    const Text(
                      'Contact:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('contact@codehire.com'),
                  ],
                ),
              ),
            ),

       
          ListTile(
            leading: const Icon(Icons.lock, color: Color.fromARGB(255, 4, 26, 134)),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
              );
            },
          ),
          const Divider(),

      
          ListTile(
            leading: const Icon(Icons.language, color: AppColors.primaryColor),
            title: const Text('Change Language'),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          const Divider(),

         
          ListTile(
  leading: const Icon(Icons.bar_chart, color: AppColors.primaryColor),
  title: const Text('User Statistics'),
  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  onTap: () {
    Navigator.pushNamed(context, AppRoutes.statisticsScreen);
  },
),
const Divider(),


          // زر تسجيل الخروج
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.primaryColor),
            title: const Text('Logout'),
            onTap: () {
              _showLogoutConfirmation(context);
            },
          ),

          
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                Navigator.pop(context);
                // ضع هنا تغيير اللغة
              },
            ),
            ListTile(
              title: const Text('Français'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Confirm Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            // ✅ Firebase logout
            await FirebaseAuth.instance.signOut();

            Navigator.pop(context); // Close dialog
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
          child: const Text('Logout'),
        ),
      ],
    ),
  );
}
}