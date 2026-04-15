import 'package:prova/models/esercizio.dart';

class Serie{
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
}