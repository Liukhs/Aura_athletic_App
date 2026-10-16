import 'package:prova/data/sessione.dart';
import 'package:prova/models/esercizio_programmato.dart';
import 'package:uuid/uuid.dart';

class AllenamentoCompletato {
  final String id;
  final String? schedaId;
  final String nome;
  final String tempoMinuti;
  final double volume;
  final int bpm;
  final DateTime data;
  final List<EsercizioProgrammato> esercizi;

  

  AllenamentoCompletato({
    String? id,
    this.schedaId,
    required this.nome,
    required this.tempoMinuti,
    required this.volume,
    required this.bpm,
    DateTime? data,
    this.esercizi = const []
  }) : this.data = data ?? DateTime.now(),
        id = id ?? Uuid().v4(); 

  factory AllenamentoCompletato.fromMap(Map<String, dynamic> map){
    return AllenamentoCompletato(
      id: map['id'] as String,
      schedaId: map['scheda_id'] as String,
      nome: map['titolo_scheda'] as String,
      tempoMinuti: map['durata_secondi'] as String,
      volume: map['volume_totale'] as double,
      bpm: 120,
      data: DateTime.parse(map['data'])
    );
  }

  Map<String, dynamic> toMap(String userId){
    return{
      'id': id,
      'scheda_id': schedaId,
      'utente_id': userId,
      'titolo_scheda': nome,
      'durata_secondi': tempoMinuti,
      'volume_totale':volume,
      'bpm': bpm,
      'data': data.toIso8601String(),
    };
  }
}