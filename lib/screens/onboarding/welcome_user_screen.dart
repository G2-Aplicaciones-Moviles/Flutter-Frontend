import 'package:flutter/material.dart';

class WelcomeUserScreen extends StatelessWidget {
  final String username;

  const WelcomeUserScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "¡Bienvenido!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Gracias por completar tu información, $username.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Image.asset('assets/images/logo.png', height: 180),
              const SizedBox(height: 24),
              const Text(
                "Ahora puedes acceder a tu Perfil y descubrir lo que JameoFit tiene para ti.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AEEF),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Aquí puedes luego llevar al dashboard principal
                  Navigator.pop(context);
                },
                child: const Text(
                  "Continuar",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
