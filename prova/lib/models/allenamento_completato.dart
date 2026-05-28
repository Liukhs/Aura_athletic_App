import 'package:prova/data/sessione.dart';

class AllenamentoCompletato {
  final String id;
  final String nome;
  final String tempoMinuti;
  final double volume;
  final int bpm;
  final DateTime data;
  

  AllenamentoCompletato({
    required this.id,
    required this.nome,
    required this.tempoMinuti,
    required this.volume,
    required this.bpm,
    DateTime? data,
  }) : this.data = data ?? DateTime.now(); 

  factory AllenamentoCompletato.fromMap(Map<String, dynamic> map){
    return AllenamentoCompletato(
      id: map['id'] as String,
      nome: map['titolo_scheda'] as String,
      tempoMinuti: map['durata_secondi'] as String,
      volume: map['volume_totale'] as double,
      bpm: 120,
      data: DateTime.parse(map['data'])
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'scheda_id': id,
      'utente_id': Sessione().utenteCorrente!.id,
      'titolo_scheda': nome,
      'durata_secondi': tempoMinuti,
      'volume_totale':volume,
      'bpm': bpm,
      'data': data.toIso8601String(),
    };
  }
}