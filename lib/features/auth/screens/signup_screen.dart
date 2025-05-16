import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:code_hire/features/auth/models/user_model.dart';
import 'package:code_hire/routes/app_routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String selectedLanguage = 'EN';

  @override
  void initState() {
    super.initState();
    _initializeLanguage();
  }

  Future<void> _initializeLanguage() async {
    final locale = context.locale;
    setState(() {
      selectedLanguage = locale.languageCode.toUpperCase();
    });
  }

  void _goToSkillsPage() {
    if (_formKey.currentState!.validate()) {
      final userData = UserModel(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNo: phoneController.text.trim(),
        password: passwordController.text.trim(),
        skills: [],
        about: '',
        description: selectedLanguage,
      );
      
      Navigator.pushNamed(
        context,
        AppRoutes.chooseSkills,
        arguments: userData,
      );
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
              // Logo and Language
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
                      setState(() {
                        selectedLanguage = value!;
                        if (value == 'EN') {
                          context.setLocale(const Locale('en'));
                        } else if (value == 'FR') {
                          context.setLocale(const Locale('fr'));
                        } else if (value == 'AR') {
                          context.setLocale(const Locale('ar'));
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(child: Image.asset('assets/images/1.jpg', height: 200)),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'sign_up'.tr(),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 4, 26, 134),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'email'.tr(),
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'validation_email'.tr();
                            }
                            if (!value.contains('@')) {
                              return 'validation_email'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: fullNameController,
                          decoration: InputDecoration(
                            labelText: 'full_name'.tr(),
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'validation_full_name'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: 'phone_number'.tr(),
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'validation_phone'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'password'.tr(),
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'validation_password_length'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'confirm_password'.tr(),
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value != passwordController.text) {
                              return 'validation_password_match'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color.fromARGB(255, 4, 26, 134),
                                side: const BorderSide(color: Color.fromARGB(255, 4, 26, 134)),
                              ),
                              icon: const Icon(Icons.arrow_back),
                              label: const Text(''),
                            ),
                            const Text(
                              '1/3',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 4, 26, 134),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: _goToSkillsPage,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color.fromARGB(255, 4, 26, 134),
                                side: const BorderSide(color: Colors.deepPurple),
                              ),
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text(''),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}