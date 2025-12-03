import 'package:flutter/material.dart';
import '../../Nutritionists/presentation/pages/nutritionist_profile_view.dart';
import '../../Patients/presentation/pages/PatientsListScreen.dart';
import '../../MealPlan/presentation/pages/meal_plans_list_page.dart';

class MainLayout extends StatefulWidget {
  final int userId;

  const MainLayout({super.key, required this.userId});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      NutritionistProfileView(
        key: ValueKey(DateTime.now()),
        userId: widget.userId,
      ),
      const PatientsListScreen(),
      const Center(child: Text("Mensajería (pendiente)")),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("JameoFit"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text(
                "JameoFit",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),

            // PERFIL
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Perfil"),
              selected: selectedIndex == 0,
              onTap: () {
                setState(() => selectedIndex = 0);
                Navigator.pop(context);
              },
            ),

            // GESTIÓN DE PLANES
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text("Gestión de Planes"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                  context,
                  "/meal-plans-list",
                  arguments: widget.userId,
                );
              },
            ),

            // RECETAS
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text("Mis Recetas"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  "/recipes-list",
                  arguments: widget.userId, // nutritionistId
                );
              },
            ),

            // PACIENTES (sigue usando este layout)
            ListTile(
              leading: const Icon(Icons.groups),
              title: const Text("Pacientes"),
              selected: selectedIndex == 1,
              onTap: () {
                setState(() => selectedIndex = 1);
                Navigator.pop(context);
              },
            ),

            // MENSAJERÍA
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text("Mensajería"),
              selected: selectedIndex == 2,
              onTap: () {
                setState(() => selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      body: pages[selectedIndex],
    );
  }
}