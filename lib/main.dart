import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'iam/presentation/bloc/auth_bloc.dart';
import 'routes/app_routes.dart';
import 'core/constants/colors.dart';

void main() {
  runApp(const JameoFitApp());
}

class JameoFitApp extends StatelessWidget {
  const JameoFitApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'JameoFit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Inter',
          scaffoldBackgroundColor: AppColors.background,
        ),
        initialRoute: AppRoutes.welcome,
        routes: AppRoutes.routes,
      ),
    );
  }
}
