import 'package:prova/models/esercizio.dart';
import 'package:prova/models/esercizio_programmato.dart';
import 'package:prova/models/scheda_allenamento.dart';

final esercizioPanca = Esercizio(nome: "Panca piana(Bilancere)", id: "1", istruzioni: "Scendi al petto e spingi", categoria: "Petto");
final esercizioSquat = Esercizio(
  id: '2', 
  nome: 'Squat', 
  istruzioni: 'Scendi sotto il parallelo', 
  categoria: 'Gambe'
);

final schedaUno = SchedaAllenamento(id: "1", titolo: "Spinta", esercizi: [
  EsercizioProgrammato(esercizio: esercizioPanca, serie: 4, ripetizioni: 10, recupero: 120),
  EsercizioProgrammato(esercizio: esercizioSquat, serie: 4, ripetizioni: 10, recupero: 120)
]);