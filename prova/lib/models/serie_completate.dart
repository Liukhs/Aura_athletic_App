

import 'package:uuid/uuid.dart';

class SerieCompletate {
  final String id;
  final String? sessioneId;
  final String? exerciseId;
  final String nomeEsercizio;
  final int numeroSerie;
  final double peso;
  final int ripetizioni;

  SerieCompletate({
    String? id,
    this.sessioneId,
    this.exerciseId,
    required this.nomeEsercizio,
    required this.numeroSerie,
    required this.peso,
    required this.ripetizioni
  }) : id = id ?? Uuid().v4();

  factory SerieCompletate.fromMap(Map<String, dynamic> map){
    return SerieCompletate(
      id: map['id'] as String,
      sessioneId: map['sessione_id'] as String,
      exerciseId: map['exercise_id'] as String,
      nomeEsercizio: map['nome_esercizio'] as String,
      numeroSerie: map['numero_serie'] as int,
      peso: (map['peso'] as num).toDouble(),
      ripetizioni: map['ripetizioni'] as int,
    );
  }

  Map<String, dynamic> toMap(String sessioneId){
    return{
      'id': id,
      'sessione_id': sessioneId,
      'exercise_id': exerciseId,
      'nome_esercizio': nomeEsercizio,
      'numero_serie': numeroSerie,
      'peso': peso,
      'ripetizioni': ripetizioni
    };
  }

}