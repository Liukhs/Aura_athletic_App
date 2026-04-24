import 'package:prova/models/esercizio.dart';
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
  factory SchedaAllenamento.fromJson(
    Map<String, dynamic> json,
    List<Esercizio> tuttiGliEsercizi,

  ){
    return SchedaAllenamento(
      id: json['id'],
      titolo: json['titolo'],
      esercizi: (json['eserciziProgrammati'] as List)
      .map((item){
        return EsercizioProgrammato.fromJson(item, tuttiGliEsercizi);
      }).toList()
    );
  }

  SchedaAllenamento copy() => SchedaAllenamento(id: id, titolo: titolo, esercizi: esercizi.map((e)=> e.copy()).toList());
}