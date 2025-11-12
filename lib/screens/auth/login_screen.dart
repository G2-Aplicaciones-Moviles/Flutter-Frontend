import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/custom_input.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/logo_header.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    final email = emailCtrl.text.trim();
    final password = passCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(LoginSubmitted(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Bienvenido a JameoFit",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state.status == AuthStatus.unauthenticated &&
              state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          final loading = state.status == AuthStatus.loading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Iniciar Sesión",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 16),
                const LogoHeader(
                  asset: 'assets/images/logo2.png',
                  size: 120,
                  showText: false,
                ),
                const SizedBox(height: 20),
                CustomInput(
                  controller: emailCtrl,
                  hint: "Correo electrónico",
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                CustomInput(
                  controller: passCtrl,
                  hint: "Contraseña",
                  icon: Icons.lock,
                  obscure: true,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(color: AppColors.textDark),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                PrimaryButton(
                  text: loading ? "Cargando..." : "Ingresar",
                  onPressed: loading ? null : () => _login(context),
                ),
                const SizedBox(height: 22),
                const Text(
                  "¿No tienes cuenta?",
                  style: TextStyle(color: AppColors.textLight),
                ),
                const SizedBox(height: 8),
                PrimaryButton(
                  text: "Crear cuenta",
                  outlined: true,
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.register),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
