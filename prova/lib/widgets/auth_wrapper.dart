import 'package:flutter/material.dart';
import 'package:prova/data/mock_data.dart';
import 'package:prova/data/sessione.dart';
import 'package:prova/main.dart';
import 'package:prova/pages/login_page.dart';

class AuthWrapper extends StatefulWidget{
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper>{

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      _decidiRotta();
    });
  }

  void _decidiRotta() async {
  // 1. Recuperiamo l'utente salvato
    var loggato = utenteSalva; 

    if (loggato != null) {
      for (var i in utenti) {
        if (loggato.email.toUpperCase() == i.email.toUpperCase() && 
            loggato.password == i.password) {
          
          Sessione().utenteCorrente = i;
          
          // --- IL CONTROLLO FONDAMENTALE ---
          // Se il widget è stato chiuso nel frattempo, fermati e non usare il context
          if (!mounted) return;

          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => const MainScreen())
          );
          return;
        }
      }
    }

    // Se arriviamo qui, l'utente non è loggato
    if (!mounted) return;

    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const PaginaLogin())
    );
}

  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.orangeAccent)),
    );
  }
}