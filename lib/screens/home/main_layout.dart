import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Nutritionists/presentation/pages/nutritionist_profile_view.dart';
import '../../Nutritionists/presentation/pages/pending_requests_screen.dart';
import '../../Nutritionists/presentation/pages/patients_with_chat_screen.dart';
import '../../Nutritionists/presentation/bloc/pending_requests_cubit.dart';
import '../../Nutritionists/presentation/bloc/patients_cubit.dart';
import '../../Nutritionists/data/repositories/nutritionist_requests_repository.dart';
import '../../Nutritionists/data/repositories/chat_contacts_repository.dart';
import '../../Patients/presentation/pages/PatientsListScreen.dart';
import '../../MealPlan/presentation/pages/meal_plans_list_page.dart';
import '../../Recipes/presentation/bloc/recipes_bloc.dart';
import '../../Recipes/presentation/pages/recipes_list_page.dart';

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
      // 0 - Perfil del Nutricionista
      NutritionistProfileView(userId: widget.userId),

      // 1 - Solicitudes Pendientes
      BlocProvider(
        create: (_) => PendingRequestsCubit(
          NutritionistRequestsRepository(),
          ChatContactsRepository(),
        )..loadRequests(widget.userId),
        child: PendingRequestsScreen(nutritionistId: widget.userId),
      ),

      // 2 - Pacientes con Chat (Mensajería)
      BlocProvider(
        create: (_) => PatientsCubit(ChatContactsRepository())
          ..loadPatients(widget.userId),
        child: PatientsWithChatScreen(nutritionistId: widget.userId),
      ),

      // 3 - Planes de Comida
      MealPlansListPage(userId: widget.userId),

      // 4 - Recetas
      BlocProvider(
        create: (_) => RecipesBloc()..add(LoadTemplatesByNutritionistEvent(widget.userId)),
        child: RecipesListPage(
          key: ValueKey("recipes_${DateTime.now()}"),
          nutritionistId: widget.userId,
        ),
      ),
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

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Perfil"),
              selected: selectedIndex == 0,
              onTap: () {
                setState(() => selectedIndex = 0);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.inbox),
              title: const Text("Solicitudes"),
              selected: selectedIndex == 1,
              onTap: () {
                setState(() => selectedIndex = 1);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.message),
              title: const Text("Mensajería"),
              selected: selectedIndex == 2,
              onTap: () {
                setState(() => selectedIndex = 2);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text("Planes de Comida"),
              selected: selectedIndex == 3,
              onTap: () {
                setState(() => selectedIndex = 3);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.food_bank),
              title: const Text("Recetas"),
              selected: selectedIndex == 4,
              onTap: () {
                setState(() => selectedIndex = 4);
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
