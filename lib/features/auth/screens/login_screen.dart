import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:code_hire/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;
  String selectedLanguage = 'EN';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    _initializeLanguage();
  }

  Future<void> _initializeLanguage() async {
    final locale = context.locale;
    setState(() {
      selectedLanguage = locale.languageCode.toUpperCase();
    });
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
      if (rememberMe) {
        emailController.text = prefs.getString('savedEmail') ?? '';
      }
    });
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setBool('rememberMe', true);
      await prefs.setString('savedEmail', emailController.text.trim());
    } else {
      await prefs.remove('rememberMe');
      await prefs.remove('savedEmail');
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        
        await _saveCredentials();
        
        Navigator.pushNamedAndRemoveUntil(
          context, 
          AppRoutes.home, 
          (route) => false
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = '';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.'.tr();
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided.'.tr();
        } else {
          errorMessage = e.message ?? 'Login error'.tr();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred.'.tr())),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                  Image.asset(
                    'assets/images/logo.jpg',
                    height: 40,
                  ),
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
              // Person image
              Center(
                child: Image.asset(
                  'assets/images/1.jpg',
                  height: 200,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'sign_in'.tr(),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 4, 26, 134),
                  ),
                ),
              ),

              const SizedBox(height: 20),
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
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'password'.tr(),
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'validation_password'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value ?? false;
                                });
                              },
                              activeColor: const Color.fromARGB(255, 4, 26, 134),
                            ),
                            Text('remember_me'.tr()),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.forgotPassword);
                              },
                              child: Text(
                                'forgot_password'.tr(),
                                style: const TextStyle(color: Color.fromARGB(255, 4, 26, 134)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        isLoading
                            ? const CircularProgressIndicator()
                            : OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color.fromARGB(255, 4, 26, 134),
                                  side: const BorderSide(color: Color.fromARGB(255, 4, 26, 134)),
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                onPressed: _login,
                                child: Text(
                                  'sign_in'.tr(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                        const SizedBox(height: 14),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.signup);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "not_member".tr(),
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: "sign_up_now".tr(),
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 4, 26, 134),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
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