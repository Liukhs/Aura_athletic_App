import 'package:prova/models/esercizio.dart';
///Rappresenta una serie di un [Esercizio]
class Serie{//
  int? ripetizioni;
  double? peso;
  bool completata;
  int? riposoSecondi;

  Serie({
    this.ripetizioni,
    this.peso, 
    this.completata = false,
    this.riposoSecondi
  });

  Serie copy() => Serie(
    ripetizioni: ripetizioni,
    peso: peso,
    riposoSecondi: riposoSecondi,
    completata: false
  );
}