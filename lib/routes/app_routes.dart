import 'package:flutter/material.dart';
import 'package:jameofit_flutter/Patients/presentation/pages/PatientsListScreen.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String patientsListScreen = '/patients-list-screen';
  static const String patientsDetailScreen = '/patients-detail-screen';

  static Map<String, WidgetBuilder> get routes => {
    welcome: (_) => const WelcomeScreen(),
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
    home: (_) => const HomeScreen(),
    patientsListScreen: (_) => const PatientsListScreen(),
  };
}
