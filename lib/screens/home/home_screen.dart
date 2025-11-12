import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'plans_screen.dart';
import 'patients_screen.dart';
import 'messages_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ProfileScreen(),
    PlansScreen(),
    PatientsScreen(),
    MessagesScreen(),
  ];

  final List<String> _titles = const [
    'Mi Perfil',
    'Planes',
    'Pacientes',
    'Mensajería',
  ];

  void _onSelect(int index) {
    setState(() => _selectedIndex = index);
    Navigator.pop(context); // Cierra el drawer al seleccionar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 35, backgroundImage: AssetImage('assets/images/logo.png')),
                  SizedBox(height: 8),
                  Text('Dra. María López', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Nutricionista', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            _buildDrawerItem(Icons.person, 'Mi perfil', 0),
            _buildDrawerItem(Icons.restaurant_menu, 'Planes', 1),
            _buildDrawerItem(Icons.people, 'Pacientes', 2),
            _buildDrawerItem(Icons.message, 'Mensajería', 3),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: _selectedIndex == index,
      onTap: () => _onSelect(index),
    );
  }
}
