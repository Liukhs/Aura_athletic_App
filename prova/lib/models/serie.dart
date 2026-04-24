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

  factory Serie.fromJson(
    Map<String, dynamic> json
  ){
    return Serie(
      ripetizioni: json['ripetizioni'] as int,
      peso: (json['peso'] as num).toDouble(),
      riposoSecondi: json['riposoSecondi'] as int,
      completata: false
    );
  }

  Serie copy() => Serie(
    ripetizioni: ripetizioni,
    peso: peso,
    riposoSecondi: riposoSecondi,
    completata: false
  );
}