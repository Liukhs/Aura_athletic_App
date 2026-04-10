import 'package:flutter/material.dart';
import 'package:prova/pages/home_page.dart';
import 'package:prova/pages/profile_page.dart';
import 'package:prova/pages/schede_page.dart';

void main() {
  runApp(const GymApp());
}

class GymApp extends StatelessWidget {
  const GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const MainScreen(),
    );
  }
}

// --- QUESTA È LA SCHERMATA PRINCIPALE CHE GESTISCE IL MENU IN BASSO ---
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Qui elenchiamo le pagine da visualizzare
  final List<Widget> _pagine = [
    const PaginaHome(),
    const PaginaScheda(),
    const PaginaProfilo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pagine[_currentIndex], // Qui viene mostrata la pagina selezionata
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // Aggiorna lo schermo quando clicchi
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Scheda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profilo'),
        ],
      ),
    );
  }
}




