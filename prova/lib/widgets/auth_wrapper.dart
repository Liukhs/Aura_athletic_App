import 'package:flutter/material.dart';
import 'package:prova/data/sessione.dart';
import 'package:prova/main.dart';
import 'package:prova/data/database_helper.dart';
import 'package:prova/services/data_service.dart'; // Il file che abbiamo creato
import 'package:prova/models/utente.dart';
import 'package:prova/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});


  Future<List<Utente>> caricaDatiEVerificaSessione() async{
    List<Utente> utenti = await DataService().loadAllData();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? emailSalvata = prefs.getString('email_salvata');

    if(emailSalvata != null){
      try{
        final utente = utenti.firstWhere((u) => u.email == emailSalvata);
        final localData = await DatabaseHelper.instance.getUtenteById(utente.id);

        if(localData != null){
          utente.fotoUrl = localData.fotoUrl;
        }
        Sessione().utenteCorrente = utente;
        await DatabaseHelper.instance.salvaUtenteCorrente(id: utente.id, nome: utente.nome, email: utente.email, password: utente.password, peso: utente.pesoAttuale ?? 0, altezza: utente.altezza ?? 0, allenamenti_fatti: utente.allenamentiFatti, fotoUrl: utente.fotoUrl);
        for (var scheda in utente.allenamenti) {
          await DatabaseHelper.instance.inserisciSchedaCompleta(scheda);
        }
      }catch (e){
        print("[ERRORE] $e");
      }
    }
    return utenti;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Utente>>(
      // Chiamiamo il servizio che scarica tutto dal GitHub
      future: caricaDatiEVerificaSessione(), 
      builder: (context, snapshot) {
        
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if(Sessione().utenteCorrente != null){
          return const MainScreen();
        } else{
          return PaginaLogin();
        }
      },
    );
  }
}