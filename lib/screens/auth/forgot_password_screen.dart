import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/custom_input.dart';
import '../../core/widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Recuperar Contraseña",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/mail.png', height: 150),
            const SizedBox(height: 24),
            const Text(
              "Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textLight, fontSize: 15),
            ),
            const SizedBox(height: 24),
            CustomInput(controller: emailCtrl, hint: "Correo electrónico", icon: Icons.email),
            const SizedBox(height: 24),
            PrimaryButton(
              text: "Enviar enlace",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Correo de recuperación enviado")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
