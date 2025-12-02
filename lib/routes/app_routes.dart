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

// MealPlan
import '../MealPlan/presentation/pages/meal_plans_list_page.dart';
import '../MealPlan/presentation/pages/create_meal_plan_page.dart';
import '../MealPlan/presentation/pages/meal_plan_detail_page.dart';
import '../MealPlan/presentation/pages/add_recipes_page.dart';
import '../MealPlan/data/models/meal_plan_model.dart';

// HOME LAYOUT
import '../screens/home/main_layout.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String nutritionistProfile = '/nutritionist-profile';
  static const String patientsList = '/patients-list';
  static const String mealPlansList = '/meal-plans-list';
  static const String createMealPlan = '/create-meal-plan';
  static const String mealPlanDetail = '/meal-plan-detail';
  static const String addRecipesToMealPlan = '/add-recipes-to-meal-plan';

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

    // MEAL PLANS LIST
    mealPlansList: (context) {
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

      return MealPlansListPage(userId: args);
    },

    // CREATE MEAL PLAN
    createMealPlan: (context) {
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

      return CreateMealPlanPage(userId: args);
    },

    // MEAL PLAN DETAIL
    mealPlanDetail: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;

      if (args == null || args is! MealPlanModel) {
        return const Scaffold(
          body: Center(
            child: Text(
              "Error: Meal Plan no recibido",
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          ),
        );
      }

      return MealPlanDetailPage(mealPlan: args);
    },

    // ADD RECIPES TO MEAL PLAN
    addRecipesToMealPlan: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      if (args == null || args["mealPlan"] is! MealPlanModel || args["userId"] is! int) {
        return const Scaffold(
          body: Center(
            child: Text(
              "Error: Datos no recibidos",
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          ),
        );
      }

      return AddRecipesToMealPlanPage(
        mealPlan: args["mealPlan"] as MealPlanModel,
        userId: args["userId"] as int,
      );
    },
  };
}
