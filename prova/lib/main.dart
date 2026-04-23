import 'package:flutter/material.dart';
import 'package:prova/pages/home_page.dart';
import 'package:prova/pages/profile_page.dart';
import 'package:prova/pages/schede_page.dart';
import 'package:prova/pages/riepilogo_page.dart';
import 'package:prova/data/mock_data.dart';
import 'package:prova/pages/login_page.dart';
import 'package:prova/models/utente.dart';
import 'package:prova/widgets/auth_wrapper.dart';
import 'package:prova/data/sessione.dart';
import 'package:prova/pages/allenamento_page.dart';
import 'package:prova/models/scheda_allenamento.dart';

void main(){
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
      home: const AuthWrapper(),
    );
  }
}

// --- QUESTA È LA SCHERMATA PRINCIPALE CHE GESTISCE IL MENU IN BASSO ---
class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex = 0;

  // Qui elenchiamo le pagine da visualizzare
  late List<Widget> _pagine;

  @override
  void initState(){
    super.initState();

    _currentIndex = widget.initialIndex;

    _pagine = [
      PaginaHome(),
      const PaginaScheda(),
      const PaginaRiepilogo(),
      PaginaProfilo()
    ];


  }

  @override
  Widget build(BuildContext context) {
    // Recuperiamo la scheda attiva dalla tua sessione
    return ListenableBuilder(
      listenable: Sessione(),
      builder: (context, child) {

        final SchedaAllenamento? attivo = Sessione().schedaAttiva;
        return Scaffold(
          // Lo Stack permette di mettere il banner sopra le pagine
          body: Stack(
            children: [
              _pagine[_currentIndex], // La pagina che stai visualizzando
              
              // Se c'è una sessione attiva, mostriamo il bannerino arancione
              if (attivo != null)
                Positioned(
                  bottom: 15, // Distanza dal fondo
                  left: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      // Torna alla pagina dell'allenamento usando la scheda attiva
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaginaAllenamento(scheda: attivo),
                        ),
                      ).then((_) => setState(() {})); // Rinfresca quando torni indietro
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.fitness_center, color: Colors.black),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "ALLENAMENTO ATTIVO: ${attivo.titolo.toUpperCase()}",
                              style: const TextStyle(
                                color: Colors.black, 
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed, // Evita spostamenti strani se hai 4+ icone
            backgroundColor: const Color(0xFF1E1E1E),
            selectedItemColor: Colors.orangeAccent,
            unselectedItemColor: Colors.grey,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Scheda'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Riepilogo'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profilo'),
            ],
          ),
        );
      }
    );
  }
}




