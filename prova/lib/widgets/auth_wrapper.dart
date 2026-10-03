import 'package:flutter/material.dart';
import 'package:prova/data/sessione.dart';
import 'package:prova/main.dart';
import 'package:prova/data/database_helper.dart';
import 'package:prova/pages/login_page.dart';
import 'package:prova/services/schede_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper>{
  late final Future<void> _caricamento;

  @override
  void initState(){
    super.initState();
    _caricamento = _verificaSessione();
  }
  

  Future<void> _verificaSessione() async{
    final supaUser = Supabase.instance.client.auth.currentUser;

    if(supaUser == null) return;

    

    try{
      final db = DatabaseHelper.instance;

      final utente = await db.getUtenteById(supaUser.id);
      if(utente == null){
        
        await Supabase.instance.client.auth.signOut();
        return;
      }

      try {
        await SchedeRepository()
          .sincronizza(supaUser.id)
          .timeout(const Duration(seconds: 8));
      } catch (e) {
        debugPrint('[sync schede] $e');
      }
      final schede = await db.ottieniSchedeComplete(supaUser.id);
      final utenteConSchede = utente.copyWith(allenamenti: schede);
      utenteConSchede.allenamentiFatti = await db.contaAllenamenti();

      Sessione().inizializzaSessione(utenteConSchede);
    } catch(e, stack){
      debugPrint('[ERRORE SESSIONE] $e\n$stack');
      return;
    }
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder<void>(
      future: _caricamento,
      builder: (context, snapshot){
        if(snapshot.connectionState != ConnectionState.done){
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return Sessione().utenteCorrente != null
          ? const MainScreen()
          : const PaginaLogin();
      },
    );
  }
}