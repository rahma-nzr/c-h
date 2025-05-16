import 'package:code_hire/features/auth/models/user_model.dart';
import 'package:code_hire/features/auth/screens/statistics_screen.dart';
import 'package:code_hire/features/contract/contract_screen.dart';
import 'package:code_hire/features/home/job_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:code_hire/core/theme.dart';
import 'package:code_hire/routes/app_routes.dart';
import 'package:code_hire/features/splash/splash_screen.dart';
import 'package:code_hire/features/auth/screens/login_screen.dart';
import 'package:code_hire/features/auth/screens/signup_screen.dart';
import 'package:code_hire/features/skills/choose_skills_screen.dart';
import 'package:code_hire/features/skills/about_yourself_screen.dart';
import 'package:code_hire/features/auth/screens/forgot_password_screen.dart';
import 'package:code_hire/features/auth/screens/reset_password_screen.dart';
import 'package:code_hire/features/home/home_screen.dart';
import 'package:code_hire/features/profile/profile_screen.dart';
import 'package:code_hire/features/profile/edit_profile_screen.dart';
import 'package:code_hire/features/home/request_list_screen.dart';
import 'package:code_hire/features/auth/screens/statistics_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      child: const CodeHireApp(),
    ),
  );
}

class CodeHireApp extends StatelessWidget {
  const CodeHireApp({Key? key}) : super(key: key);
  
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CodeHire',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.splash:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case AppRoutes.login:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case AppRoutes.signup:
            return MaterialPageRoute(builder: (_) => const SignUpScreen());
          case AppRoutes.forgotPassword:
            return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
          case AppRoutes.resetPassword:
            return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
          case AppRoutes.home:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case AppRoutes.profile:
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case AppRoutes.contractForm:
            return MaterialPageRoute(builder: (_) => const ContractFormScreen(requestId: '', businessOwnerName: '',));
          case AppRoutes.jobDetails:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => JobDetailsScreen(
                jobId: args['jobId'],
                title: args['title'],
                description: args['description'],
                clientName: args['clientName'],
                duration: args['duration'],
                budget: args['budget'],
                skills: List<String>.from(args['skills']),
                clientId: '', companyName: '',
              ),
            );
          case AppRoutes.chooseSkills:
            return MaterialPageRoute(
              builder: (_) => ChooseSkillsScreen(
                userData: settings.arguments as UserModel,
              ),
            );
          case AppRoutes.aboutYourself:
            return MaterialPageRoute(
              builder: (_) => AboutYourselfScreen(
                userData: settings.arguments as UserModel,
              ),
            );


              // In main.dart
// Add this to the onGenerateRoute switch statement
case AppRoutes.requests:
  final args = settings.arguments as Map<String, dynamic>;
  return MaterialPageRoute(
    builder: (_) => RequestsListScreen(
      developerId: args['developerId'],
    ),
  );



          case AppRoutes.editProfile:
            return MaterialPageRoute(
              builder: (_) => EditProfileScreen(
                user: settings.arguments as UserModel,
              ),
            );
          
          // ✅ Add this new route for the statistics screen
          case AppRoutes.statisticsScreen:
            return MaterialPageRoute(
              builder: (_) => const StatisticsScreen(),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text('Route ${settings.name} not found'),
                ),
              ),
            );
            
        }
      },
    );
  }
}
