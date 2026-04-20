import 'package:flutter/material.dart';
import 'package:prova/models/scheda_allenamento.dart';
import 'package:prova/data/mock_data.dart';
import 'package:prova/pages/dettaglio_allenamento_page.dart';
import 'package:prova/data/sessione.dart';

class PaginaScheda extends StatelessWidget {
  
  const PaginaScheda({super.key});
  

  @override
  Widget build(BuildContext context) {

    final utenteLoggato = Sessione().utenteCorrente!;
    final List<SchedaAllenamento> mieSchede = utenteLoggato.allenamenti;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('LA MIA SCHEDA', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: mieSchede.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  child: Icon(Icons.calendar_today, color: Colors.black),
                ),
                title: Text(mieSchede[index].titolo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.orangeAccent),
                onTap: () {
                  // Qui collegherai l'apertura del giorno specifico
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaDettaglioAllenamento(scheda: mieSchede[index])));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}