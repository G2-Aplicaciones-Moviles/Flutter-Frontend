import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/logo_header.dart';
import '../../routes/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LogoHeader(
                asset: 'assets/images/logo3.png',
                size: 300,
                showText: false,
              ),
              const SizedBox(height: 16),
              const Text(
                "Bienvenido a JameoFit",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 8),
              const Text(
                "Tu compañero inteligente para alcanzar tus metas de salud y bienestar.\n\n¡Empieza hoy tu transformación!",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textLight),
              ),
              const SizedBox(height: 36),
              PrimaryButton(
                text: "Registrarse",
                onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: "Iniciar Sesión",
                outlined: true,
                onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
