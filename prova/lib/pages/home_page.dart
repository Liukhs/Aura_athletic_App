import 'package:flutter/material.dart';
import 'package:prova/data/mock_data.dart';
import 'package:prova/data/sessione.dart';
import 'package:prova/models/corso.dart';
import 'package:prova/widgets/allenamento_oggi.dart';
import 'package:prova/widgets/post_card.dart';
import 'package:prova/widgets/widget_corso.dart';

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
                  print("Pulsante ricerca premuto");
                },
                ),
                const SizedBox(width: 10),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("I corsi di questa settimana", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index){
                    return cardCorso(context, corsiSettimanali[index]);
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
        );
      }
    );
  }
}