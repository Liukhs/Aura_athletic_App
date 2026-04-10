import 'package:flutter/material.dart';
import 'package:prova/widgets/post_card.dart';

class PaginaHome extends StatelessWidget{
  const PaginaHome({super.key});

  @override
  Widget build(BuildContext context){
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
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return PostAllenamento(
            utente: "Utente ${index+1}",
            descrizione: "Oggi allenamento spacca-muscoli! Sessione numero ${index+1} completata. #GymLife"
          );
        }
      ),
    );
  }
}