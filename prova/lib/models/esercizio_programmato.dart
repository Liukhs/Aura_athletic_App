import 'esercizio.dart';
import 'package:prova/models/serie.dart';

class EsercizioProgrammato {
  final Esercizio esercizio;
  List<Serie> serie;
  

  EsercizioProgrammato({
    required this.esercizio,
    required this.serie,
  });

  factory EsercizioProgrammato.fromJson(
    Map<String, dynamic> json,
    List<Esercizio> tuttiGliEsercizi
  ){
    return EsercizioProgrammato(
      esercizio: tuttiGliEsercizi.firstWhere(
        (e) => e.id == json['esercizioId'],
        orElse: ()=>throw Exception("Esercizio ${json['esercizioID']} non trovato")
      ),
      serie: (json['serie'] as List).map((s)=> Serie.fromJson(s)).toList()
    );
  }

  EsercizioProgrammato copy() => EsercizioProgrammato(esercizio: esercizio, serie: serie.map((s) => s.copy()).toList());
}