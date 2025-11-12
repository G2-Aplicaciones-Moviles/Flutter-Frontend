import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/custom_input.dart';
import '../../core/widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final specialtyCtrl = TextEditingController();
  final licenseCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    specialtyCtrl.dispose();
    licenseCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  void _register(BuildContext context) {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa al menos correo y contraseña.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(RegisterSubmitted(email, pass));
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
            Navigator.pushReplacementNamed(context, '/home');
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
                const SizedBox(height: 16),
                CustomInput(
                  controller: specialtyCtrl,
                  hint: "Especialidades",
                  icon: Icons.star,
                ),
                const SizedBox(height: 16),
                CustomInput(
                  controller: licenseCtrl,
                  hint: "Número de colegiatura",
                  icon: Icons.badge,
                ),
                const SizedBox(height: 16),
                CustomInput(
                  controller: phoneCtrl,
                  hint: "Número de contacto",
                  icon: Icons.phone,
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: "Cancelar",
                        outlined: true,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PrimaryButton(
                        text: loading ? "Cargando..." : "Registrar",
                        onPressed: loading ? null : () => _register(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
