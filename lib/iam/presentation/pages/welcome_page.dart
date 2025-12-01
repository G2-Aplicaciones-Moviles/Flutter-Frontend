import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png", height: 200),

            const SizedBox(height: 20),
            const Text(
              "JameoFit",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Tu compañero inteligente para alcanzar tus metas de salud y bienestar.",
              textAlign: TextAlign.center,
            ),
            const Text(
              "¡Empieza hoy tu transformación!",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, "/register"),
                child: const Text("Registrarse"),
              ),
            ),

            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, "/login"),
                child: const Text("Iniciar Sesión"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
