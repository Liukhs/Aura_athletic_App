import 'package:flutter/material.dart';
import 'package:prova/data/database_helper.dart';
import 'package:prova/models/esercizio.dart';
import 'package:prova/models/scheda_allenamento.dart';

import 'package:prova/pages/dettaglio_allenamento_page.dart';
import 'package:prova/data/sessione.dart';
import 'package:prova/pages/allenamento_page.dart';

class PaginaScheda extends StatefulWidget {

  final List<Esercizio> tuttiGliEsercizi;
  
  const PaginaScheda({super.key, required this.tuttiGliEsercizi});

  @override
  State<PaginaScheda> createState() => _paginaSchedaState();
}

class _paginaSchedaState extends State<PaginaScheda>{

  late Future<List<SchedaAllenamento>> _futureSchede;

  @override
  void initState(){
    super.initState();
    _ricaricaSchedeLocalmente();
  }

  void _ricaricaSchedeLocalmente(){
    setState(() {
      _futureSchede = DatabaseHelper.instance.ottieniSchedeComplete(widget.tuttiGliEsercizi);
    });
  }

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
      body: FutureBuilder<List<SchedaAllenamento>>(
        future: _futureSchede,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent,));
          }
          if(snapshot.hasError){
            return Center(child: Text("Errore Database: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
          }

          final mieSchede = snapshot.data ?? [];
          if(mieSchede.isEmpty){
            return const Center(
              child: Text(
                "Nessuna scheda salvata localmente.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            itemCount: mieSchede.length,
            itemBuilder: (context, index){
              final schedaSelezionata = mieSchede[index];
              return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: InkWell(
      onTap: () {
        // --- DESTINAZIONE 1: DETTAGLIO ---
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaginaDettaglioAllenamento(scheda: schedaSelezionata)),
        );
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.orangeAccent,
              child: Icon(Icons.calendar_today, color: Colors.black),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                schedaSelezionata.titolo,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // --- DESTINAZIONE 2: AVVIO DIRETTO ---
            IconButton(
              icon: const Icon(Icons.play_circle_fill, color: Colors.orangeAccent, size: 40),
              onPressed: () {
                // Qui usi il .copy() perché l'allenamento sta partendo davvero!
                final nuovaScheda = schedaSelezionata.copy();
                Sessione().schedaAttiva = nuovaScheda;
                Sessione().orarioInizio = DateTime.now();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaginaAllenamento(scheda: nuovaScheda)
                  ),
                ).then((_){
                  if(mounted){
                    _ricaricaSchedeLocalmente();
                  }
                });
              },
            ),
          ],
        ),
      ),
    ),
  );

            }
          );

  
},
      ),
    );
  }
}