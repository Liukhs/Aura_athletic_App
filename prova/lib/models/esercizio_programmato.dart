import 'esercizio.dart';
import 'package:prova/models/serie.dart';
import 'package:prova/models/gruppo_muscolare.dart';
import 'package:uuid/uuid.dart';

class EsercizioProgrammato {
  final String id;
  final Esercizio esercizio;
  List<Serie> serie;
  

  EsercizioProgrammato({
    String? id,
    required this.esercizio,
    List<Serie>? serie,
  }): id = id ?? const Uuid().v4(),
      serie = serie ?? [Serie()];

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
  factory EsercizioProgrammato.fromDbMap(Map<String, dynamic> dbMap, List<Serie> serieEsercizio){
    return EsercizioProgrammato(id: dbMap['id'] as String, esercizio: Esercizio(
      id: dbMap['exercise_id'] as String,
      nome: dbMap['nome'] as String,
      imagePath: dbMap['image_path'] as String?,
      gifPath: dbMap['gif_path'] as String?,
      parteDelCorpo: dbMap['body_parts'] as String?
    ),
    serie: serieEsercizio,
    );
  }

  Map<String, dynamic> toMap(String schedaId){
    return{
      'id': id,
      'scheda_id': schedaId,
      'nome': esercizio.nome,
      'exercise_id': esercizio.id,
      'image_path': esercizio.imagePath,
      'gif_path': esercizio.gifPath,
      'body_part': esercizio.parteDelCorpo,
    };
  }


  EsercizioProgrammato copy() => EsercizioProgrammato(id: id, esercizio: esercizio, serie: serie.map((s) => s.copy()).toList());
}