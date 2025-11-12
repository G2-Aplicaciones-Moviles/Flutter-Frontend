import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';
import 'core/repositories/auth_repository.dart';
import 'routes/app_routes.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'core/constants/colors.dart';

void main() {
  runApp(const JameoFitApp());
}

class JameoFitApp extends StatelessWidget {
  const JameoFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthRepository();

    return BlocProvider(
      create: (_) => AuthBloc(authRepo)..add(AppStarted()),
      child: MaterialApp(
        title: 'JameoFit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Inter',
          scaffoldBackgroundColor: AppColors.background,
        ),
        // ✅ Aquí definimos solo initialRoute y routes
        initialRoute: AppRoutes.welcome,
        routes: AppRoutes.routes,
      ),
    );
  }
}
