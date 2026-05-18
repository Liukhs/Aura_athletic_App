import 'esercizio.dart';
import 'package:prova/models/serie.dart';
import 'package:prova/models/gruppo_muscolare.dart';

class EsercizioProgrammato {
  final String id;
  final Esercizio esercizio;
  List<Serie> serie;
  

  EsercizioProgrammato({
    required this.id,
    required this.esercizio,
    required this.serie,
  });

  factory EsercizioProgrammato.fromJson(
    Map<String, dynamic> json,
    List<Esercizio> tuttiGliEsercizi
  ){
    return EsercizioProgrammato(
      id: json['esercizioId'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      esercizio: tuttiGliEsercizi.firstWhere(
        (e) => e.id == json['esercizioId'],
        orElse: ()=>throw Exception("Esercizio ${json['esercizioID']} non trovato")
      ),
      serie: (json['serie'] as List).map((s)=> Serie.fromJson(s)).toList()
    );
  }
  factory EsercizioProgrammato.fromDbMap(Map<String, dynamic> dbMap, List<Esercizio> tuttiGliEsercizi, List<Serie> serieEsercizio){
    return EsercizioProgrammato(id: dbMap['id'] as String, esercizio: tuttiGliEsercizi.firstWhere(
      (e) => e.nome == dbMap['nome'],
      orElse: () => Esercizio(nome: "default", id: dbMap['nome'] as String, istruzioni: dbMap['istruzioni'], categoria: GruppoMuscolare.values.byName(dbMap['categoria'] as String))
    ),
    serie: serieEsercizio,
    );
  }

  Map<String, dynamic> toMap(String schedaId){
    return{
      'id': id,
      'scheda_id': schedaId,
      'nome': esercizio.nome,
      'categoria': esercizio.categoria.name,
      'istruzioni': esercizio.istruzioni
    };
  }


  EsercizioProgrammato copy() => EsercizioProgrammato(id: id, esercizio: esercizio, serie: serie.map((s) => s.copy()).toList());
}