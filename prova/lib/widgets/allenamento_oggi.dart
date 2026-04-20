import 'package:flutter/material.dart';
import 'package:prova/data/sessione.dart';
Widget CardAllenamentoOdierno(){
  final utenteLoggato = Sessione().utenteCorrente;
  final primaScheda = utenteLoggato!.allenamenti.first;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.orangeAccent, Colors.deepOrange],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.orangeAccent.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 5),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              primaScheda.titolo, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.fitness_center, color: Colors.white,),
          ],
        ),
        const SizedBox(height: 10),
        Text("${primaScheda.esercizi.length} esercizi previsti", style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.orangeAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: (){
            print("Allenamento iniziato");
          },
          child: const SizedBox(
            width: double.infinity,
            child: Text("INIZIA ORA", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        )
      ],
    ),
  );
}