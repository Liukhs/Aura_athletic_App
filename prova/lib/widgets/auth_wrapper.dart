import 'package:flutter/material.dart';
import 'package:prova/data/sessione.dart';
import 'package:prova/main.dart';
import 'package:prova/services/data_service.dart'; // Il file che abbiamo creato
import 'package:prova/models/utente.dart';
import 'package:prova/pages/home_page.dart';
import 'package:prova/pages/login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Utente>>(
      // Chiamiamo il servizio che scarica tutto dal GitHub
      future: DataService().loadAllData(), 
      builder: (context, snapshot) {
        
        // 1. Mentre scarica i dati da GitHub mostriamo un caricamento
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Se c'è un errore (es. niente internet o URL sbagliato)
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Errore nel caricamento dati: ${snapshot.error}")),
          );
        }

        // 3. Dati scaricati con successo!
        if (snapshot.hasData) {
          final tuttiGliUtenti = snapshot.data!;

          // --- LOGICA DI CONTROLLO SESSIONE ---
          // Qui cerchiamo se esiste l'utente che ci interessa.
          // In futuro qui userai SharedPreferences per leggere l'ID salvato.
          String emailSalvata = "soldiluca.99@gmail.com"; 

          // Cerchiamo l'utente nella lista appena scaricata
          final utenteTrovato = tuttiGliUtenti.firstWhere(
            (u) => u.email == emailSalvata,
            orElse: () => Utente(id: '', nome: '', email: '', password: '', allenamentiFatti: 0), // Utente vuoto se non trovato
          );

          if (utenteTrovato.id.isNotEmpty) {
            // Se lo abbiamo trovato, andiamo alla Home passando l'utente
            Sessione().utenteCorrente = utenteTrovato;
            return MainScreen();
          } else {
            // Altrimenti, lo mandiamo al Login
            return const PaginaLogin();
          }
        }

        return const PaginaLogin();
      },
    );
  }
}