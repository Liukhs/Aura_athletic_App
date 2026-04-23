import 'package:prova/models/esercizio_programmato.dart';

class SchedaAllenamento{
  final String id;
  final String titolo;
  final List<EsercizioProgrammato> esercizi;

  SchedaAllenamento({
    required this.id,
    required this.titolo,
    required this.esercizi
  });

  SchedaAllenamento copy() => SchedaAllenamento(id: id, titolo: titolo, esercizi: esercizi.map((e)=> e.copy()).toList());
}