import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme/app_colors.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/signup_success_screen.dart';
import 'screens/home_screen.dart';
import 'screens/result_screen.dart';
import 'screens/history_screen.dart';
import 'screens/add_history_screen.dart';
import 'screens/history_detail_screen.dart';
import 'screens/education_screen.dart';
import 'screens/education_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/profile_detail_screen.dart';
import 'screens/reminder_screen.dart';
import 'screens/reminder_settings_screen.dart';
import 'screens/eligibility_check_screen.dart';

void main() {
  runApp(const BloodCareApp());
}

class BloodCareApp extends StatelessWidget {
  const BloodCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryRed,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryRed,
          primary: AppColors.primaryRed,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/signup_success': (context) => const SignupSuccessScreen(),
        '/home': (context) => const HomeScreen(),
        '/result': (context) => const ResultScreen(),
        '/history': (context) => const HistoryScreen(),
        '/add_history': (context) => const AddHistoryScreen(),
        '/history_detail': (context) => const HistoryDetailScreen(),
        '/education': (context) => const EducationScreen(),
        '/education_detail': (context) => const EducationDetailScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
        '/profile_detail': (context) => const ProfileDetailScreen(),
        '/reminder': (context) => const ReminderScreen(),
        '/reminder_settings': (context) => const ReminderSettingsScreen(),
        '/eligibility_check': (context) => const EligibilityCheckScreen(),
      },
    );
  }
}
