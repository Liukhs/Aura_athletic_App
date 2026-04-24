import 'package:prova/models/gruppo_muscolare.dart';

class Esercizio{

  final String nome;
  final String id;
  final String istruzioni;
  final GruppoMuscolare categoria;
  final String? urlVideo;
  final String? urlThumb;
  Esercizio({
    required this.nome,
    required this.id,
    required this.istruzioni,
    required this.categoria,
    this.urlVideo,
    this.urlThumb
  });

  factory Esercizio.fromJson(
    Map<String, dynamic> json,
  ){
    return Esercizio(
      id: json['id'],
      nome: json['nome'],
      istruzioni: json['istruzioni'],
      categoria: GruppoMuscolare.values.byName(json['categoria']),
      urlVideo: json['urlVideo'],
      urlThumb: json['urlThumb']
    );
  }
  

}