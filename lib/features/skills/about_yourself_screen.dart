import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_hire/features/auth/models/user_model.dart';
import 'package:code_hire/features/auth/models/user_repository.dart';
import 'package:code_hire/routes/app_routes.dart';

class AboutYourselfScreen extends StatefulWidget {
  final UserModel userData;
  const AboutYourselfScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<AboutYourselfScreen> createState() => _AboutYourselfScreenState();
}

class _AboutYourselfScreenState extends State<AboutYourselfScreen> {
  final TextEditingController aboutController = TextEditingController();
  late String selectedLanguage;
  final UserRepository _userRepo = UserRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.userData.description;
    if (widget.userData.about.isNotEmpty) {
      aboutController.text = widget.userData.about;
    }
  }

  Future<void> _submitForm() async {
    if (aboutController.text.trim().length < 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write at least 20 characters about yourself'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final completeUser = widget.userData.copyWith(
        about: aboutController.text.trim(),
        description: selectedLanguage,
      );

      await _userRepo.createUser(completeUser);
      
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/logo.jpg', height: 40),
                  DropdownButton<String>(
                    value: selectedLanguage,
                    underline: const SizedBox(),
                    items: ['EN', 'FR', 'AR'].map((String lang) {
                      return DropdownMenuItem<String>(
                        value: lang,
                        child: Text(lang),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedLanguage = value!);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(child: Image.asset('assets/images/1.jpg', height: 200)),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 4, 26, 134),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('About yourself:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Expanded(
                child: TextField(
                  controller: aboutController,
                  maxLines: null,
                  minLines: 8,
                  decoration: const InputDecoration(
                    hintText: 'Tell us about your skills and experience...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 4, 26, 134),
                      side: const BorderSide(color: Color.fromARGB(255, 4, 26, 134)),
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text(''),
                  ),
                  const Text(
                    '3/3',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 4, 26, 134),
                    ),
                  ),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    OutlinedButton.icon(
                      onPressed: _submitForm,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 4, 26, 134),
                        side: const BorderSide(color: Color.fromARGB(255, 4, 26, 134)),
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text(''),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}