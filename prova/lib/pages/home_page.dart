import 'package:flutter/material.dart';
import 'package:prova/data/sessione.dart';
import 'package:prova/models/corso.dart';
import 'package:prova/services/esercizi_repository.dart';
import 'package:prova/widgets/allenamento_oggi.dart';
import 'package:prova/widgets/post_card.dart';
import 'package:prova/widgets/widget_corso.dart';
import 'package:prova/widgets/messaggio_card.dart';

class PaginaHome extends StatelessWidget{
  
  PaginaHome({super.key});
  final utenteLoggato = Sessione().utenteCorrente;

  @override
  Widget build(BuildContext context){
    return ListenableBuilder(
      listenable: Sessione(),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('HOME', style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.orangeAccent,),
                onPressed: (){
                  testCatalogo(context);
                },
                ),
                const SizedBox(width: 10),
            ],
          ),
          body: SingleChildScrollView( 
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("I messaggi della palestra", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index){
                    final messaggio = Sessione().messaggiPalestra[index];
                    return MessaggioCard(messaggio: messaggio);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("I corsi di questa settimana", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Sessione().tuttiICorsi.length,
                  itemBuilder: (context, index){
                    return cardCorso(context, Sessione().tuttiICorsi[index]);
                  }
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Il tuo allenamento di oggi", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
              ),
              CardAllenamentoOdierno(context),  
            ],
          ),
          )
        );
      }
    );
  }
}

Future<void> testCatalogo(BuildContext context) async{
  try{
    
    final lista = await EserciziRepository().lista();
    final testo = lista.isEmpty
      ? 'VUOTO: Probabile policy RLS mancante'
      : 'CATALOGO OK: ${lista.length} esercizi, primo: ${lista.first.nome}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(testo), duration: const Duration(seconds: 20)),
      );
  }catch(e){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('CATALOGO ERRORE: $e'),
        duration: const Duration(seconds: 20),
        backgroundColor: Colors.redAccent,
      )
    );
  }
}