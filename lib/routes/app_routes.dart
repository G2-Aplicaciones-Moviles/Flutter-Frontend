import 'package:flutter/material.dart';

// IAM
import '../iam/presentation/pages/login_page.dart';
import '../iam/presentation/pages/register_page.dart';
import '../iam/presentation/pages/welcome_page.dart';

// Nutritionists
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Nutritionists/presentation/bloc/nutritionist_bloc.dart';
import '../Nutritionists/presentation/pages/create_nutritionist_profile_page.dart';

// Patients
import '../Patients/presentation/pages/PatientsListScreen.dart';

// HOME LAYOUT
import '../screens/home/main_layout.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String nutritionistProfile = '/nutritionist-profile';
  static const String patientsList = '/patients-list';

  static final Map<String, WidgetBuilder> routes = {
    welcome: (_) => const WelcomePage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),

    // HOME que recibe userId
    home: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;

      if (args == null || args is! int) {
        return const Scaffold(
          body: Center(
            child: Text(
              "Error: userId no recibido en Home",
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          ),
        );
      }

      return MainLayout(userId: args);
    },

    // CREAR PERFIL NUTRICIONISTA
    nutritionistProfile: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;

      if (args == null || args is! int) {
        return const Scaffold(
          body: Center(
            child: Text(
              "Error: userId no recibido",
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          ),
        );
      }

      return BlocProvider(
        create: (_) => NutritionistBloc(),
        child: CreateNutritionistProfilePage(userId: args),
      );
    },

    patientsList: (_) => const PatientsListScreen(),
  };
}
