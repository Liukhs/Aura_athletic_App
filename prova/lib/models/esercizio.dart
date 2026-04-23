import 'package:prova/models/gruppo_muscolare.dart';

class Esercizio{

  final String nome;
  final String id;
  final String istruzioni;
  final GruppoMuscolare categoria;
  final String? urlVideo;
  Esercizio({
    required this.nome,
    required this.id,
    required this.istruzioni,
    required this.categoria,
    this.urlVideo
  });
  

}