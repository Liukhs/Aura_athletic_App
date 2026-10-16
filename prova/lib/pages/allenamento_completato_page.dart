import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prova/data/database_helper.dart';
import 'package:prova/models/allenamento_completato.dart';
import 'package:prova/models/esercizio.dart';
import 'package:prova/models/scheda_allenamento.dart';
import 'package:prova/models/serie_completate.dart';
import 'package:prova/services/esercizi_repository.dart';
import 'package:prova/widgets/thumbnail.dart';
import 'package:sqflite/sqflite.dart';


class AllenamentoCompletatoPage extends StatefulWidget {
  final AllenamentoCompletato scheda;
  

  AllenamentoCompletatoPage({
    super.key,
    required this.scheda,
    
  });
  
  @override
  State<AllenamentoCompletatoPage> createState()=> _AllenamentoCompletatoPageState();

}

class _AllenamentoCompletatoPageState extends State<AllenamentoCompletatoPage>{

  late Future<List<SerieCompletate>> _futureCronologia;
  late Future<Esercizio> _esercizioFuture;

  void initState(){
    super.initState();
    _caricaSerie(widget.scheda.id);
  }

  void _caricaSerie(String sessioneId){
    _futureCronologia = DatabaseHelper.instance.ottieniCronologiaSerie(sessioneId);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riepilogo allenamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _intestazione(),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<SerieCompletate>>(
                future: _futureCronologia,
                builder: (context, snapshot){
                  if(snapshot.connectionState != ConnectionState.done){
                    return const Center(child: CircularProgressIndicator());
                  }
                  if(snapshot.hasError){
                    return Center(child: Text("Errore ${snapshot.error}"),);
                  }
                  final serie = snapshot.data ?? [];
                  if(serie.isEmpty){
                    return const Center(child: Text("nessuna serei registrata per questo allenamento"),);
                  }
                  return _listaEsercizi(serie);
                },
              ) 
            )
          ],
        ),
      )
    );
  }

  Widget _intestazione(){
    final a = widget.scheda;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(a.nome, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        const SizedBox(height: 4,),
        Text('${DateFormat('dd/MM/yyyy').format(a.data)}  •  Volume: ${a.volume.toStringAsFixed(0)} kg', style: const TextStyle(color: Colors.grey),)
      ],
    );
  }

  Widget _listaEsercizi(List<SerieCompletate> serie){
    final Map<String, List<SerieCompletate>> perEsercizio = {};

    for(final s in serie){
      perEsercizio.putIfAbsent(s.exerciseId ?? s.nomeEsercizio, () => []).add(s);
    }

    debugPrint("DEBUG ESERCIZIO ${perEsercizio.toString()}");

    final gruppi = perEsercizio.values.toList();
    debugPrint(gruppi.toString());

    return ListView.builder(
      itemCount: gruppi.length,
      itemBuilder: (context, index) {
        final serieEsercizio = gruppi[index];
        
        
          return _cardEsercizi(serieEsercizio);
         
      },
    );
  }

  String _peso(double p) => p == p.roundToDouble() ? p.toStringAsFixed(0) : p.toString();

  Widget _thumbnailEsercizio(String exerciseId){
    _esercizioFuture = EserciziRepository().dettaglio(exerciseId);
    
    return FutureBuilder<Esercizio>(
      future: _esercizioFuture, 
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return Thumbnail(esercizio: snapshot.data!);
        }
        return const Icon(Icons.fitness_center, color: Colors.blueAccent);
      }
    );
  }

  

  Widget _cardEsercizi(List<SerieCompletate> serie){
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(8)
                      ),
                      
                      child: _thumbnailEsercizio(serie[0].exerciseId!)
                  ),
                  const SizedBox(width: 6),
                  Container(
                    height: 60,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                    serie[0].nomeEsercizio,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18) 
                  ),
                  )
                  
                ],
              ),
              
              const SizedBox(height: 8,),
              for(final s in serie)...[
                _buildRigaSerie(s, s.nomeEsercizio),
                const SizedBox(height: 8)
              ]
            ],
          ),
        ),
      );
    
  }

  Widget _buildRigaSerie(SerieCompletate serie, String nomeEsercizio){
    return Row(
      children: [
        Container(
          width: 60,
          child: Text(
            "${serie.numeroSerie}"
          ),
        ),
        Container(
          constraints: const BoxConstraints(
            minWidth: 80
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blueAccent
          ),
          child: Text(
            "${serie.peso}x${serie.ripetizioni}"
          ),
        )

      ],
    );
  }

  
}