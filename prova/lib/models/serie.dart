import 'package:prova/models/esercizio.dart';
import 'package:uuid/uuid.dart';
///Rappresenta una serie di un [Esercizio]
class Serie{//
  String? id;
  int? ripetizioni;
  double? peso;
  bool completata;
  int? riposoSecondi;
  final String? esercizioProgrammatoId;

  Serie({
    String? id,
    this.ripetizioni,
    this.peso, 
    this.completata = false,
    this.riposoSecondi,
    this.esercizioProgrammatoId
  }) : id = id ?? const Uuid().v4(); 

  Map<String, dynamic> toMap(String compIdEsercizio){
    return{
      'id': id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      'esercizio_programmato_id': compIdEsercizio,
      'peso': peso,
      'ripetizioni':ripetizioni,
      'riposo_sec':riposoSecondi,
    };
  }

  factory Serie.fromMap(Map<String, dynamic> map){
    return Serie(
      id: map['id'] as String?,
      esercizioProgrammatoId: map['esercizio_programmato_id'] as String?,
      peso: map['peso']!= null ? (map['peso'] as num).toDouble() : null,
      ripetizioni: map['ripetizioni'] as int?,
      riposoSecondi: map['riposo_sec'] as int?,
      completata: map['completata'] == 1,
    );
  }

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