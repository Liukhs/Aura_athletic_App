import 'esercizio.dart';
import 'package:prova/models/serie.dart';

class EsercizioProgrammato {
  final Esercizio esercizio;
  List<Serie> serie;
  

  EsercizioProgrammato({
    required this.esercizio,
    required this.serie,
  });

  EsercizioProgrammato copy() => EsercizioProgrammato(esercizio: esercizio, serie: serie.map((s) => s.copy()).toList());
}