import 'package:flutter/material.dart';

// IAM (backend real)
import '../Nutritionists/presentation/bloc/nutritionist_bloc.dart';
import '../iam/presentation/pages/login_page.dart';
import '../iam/presentation/pages/register_page.dart';
import '../iam/presentation/pages/welcome_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../Nutritionists/presentation/bloc/nutritionist_bloc.dart';


// Nutritionists
import '../Nutritionists/presentation/pages/create_nutritionist_profile_page.dart';

// Patients
import '../Patients/presentation/pages/PatientsListScreen.dart';
import '../Patients/presentation/pages/PatientsDetailScreen.dart';
import '../Patients/data/models/NutritionistPatientModel.dart';

class AppRoutes {
  // ROUTE NAMES
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static const String nutritionistProfile = '/nutritionist-profile';
  static const String patientsList = '/patients-list';
  static const String patientsDetail = '/patients-detail';

  // ROUTER TABLE
  static final Map<String, WidgetBuilder> routes = {
    welcome: (_) => const WelcomePage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),

    // Pantalla Home (lista de pacientes)
    home: (_) => const PatientsListScreen(),

    // Perfil de nutricionista (primer ingreso)
    nutritionistProfile: (context) {
      final userId = ModalRoute.of(context)!.settings.arguments as int;

      return BlocProvider(
        create: (_) => NutritionistBloc(),
        child: CreateNutritionistProfilePage(userId: userId),
      );
    },


    // Lista de pacientes
    patientsList: (_) => const PatientsListScreen(),

    // Detalle del paciente
    //patientsDetail: (context) {
      //final patient = ModalRoute.of(context)!.settings.arguments
      //as NutritionistPatientModel;
      //return PatientsDetailScreen(paciente: patient);
    //},
  };
}
