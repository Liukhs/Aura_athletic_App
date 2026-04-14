import 'package:flutter/material.dart';
import 'package:prova/models/scheda_allenamento.dart';

class PaginaDettaglioAllenamento extends StatelessWidget{
  final SchedaAllenamento scheda;

  const PaginaDettaglioAllenamento({
    super.key,
    required this.scheda
  });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(scheda.titolo), centerTitle: true,),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(onPressed: (){
                print("Allenamento attivato");
              }, style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("AVVIA ALLENAMENTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),    
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ESERCIZI IN PROGRAMMA",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scheda.esercizi.length,
              itemBuilder: (context, index){
                final es = scheda.esercizi[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: const Color(0xFF1E1E1E),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[800],
                      child: Text("${index+1}", style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(es.esercizio.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${es.serie} serie x ${es.ripetizioni} reps"),
                    trailing: Text("${es.recupero} s rec", style: const TextStyle(color: Colors.orangeAccent)),
                  ),
                );
              },
            ),
          )
        ],
      )
    );
  }
}