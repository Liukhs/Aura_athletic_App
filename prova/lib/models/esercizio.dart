import 'package:prova/models/gruppo_muscolare.dart';

class Esercizio{

  final String id;
  final String nome;
  final String? categoria;
  final String? parteDelCorpo;
  final String? equipaggiamento;
  final String? target;
  final String? muscleGroup;
  final List<String> secondaryMuscle;
  final Map<String, List<String>> instrucionSteps;
  final String? imagePath;
  final String? gifPath;
  final String? attribution;
  Esercizio({
    required this.nome,
    required this.id,
    this.categoria,
    this.parteDelCorpo,
    this.equipaggiamento,
    this.target,
    this.muscleGroup,
    this.secondaryMuscle = const [],
    this.instrucionSteps = const {},
    this.imagePath,
    this.gifPath,
    this.attribution
  });

  
  factory Esercizio.fromJson(
    Map<String, dynamic> json,
  ){
    final rawSteps = json['instruction_steps'] as Map<String, dynamic>? ?? {};
    return Esercizio(
      id: json['id'] as String,
      nome: json['name'] as String,
      categoria: json['category'] as String?,
      parteDelCorpo: json['body_part'] as String?,
      equipaggiamento: json['equipment'] as String?,
      target: json['target'] as String?,
      muscleGroup: json['muscle_group'] as String?,
      secondaryMuscle: (json['secondary_muscles'] as List?)?.cast<String>() ?? const [],
      instrucionSteps: rawSteps.map((lang, steps) => MapEntry(lang, (steps as List).cast<String>())),
      imagePath: json['image_path'] as String?,
      gifPath: json['gif_path'] as String?,
      attribution: json['attribution'] as String?
    );
  }

  factory Esercizio.fromJsonProva(
    Map<String, dynamic> json
  ){
    return Esercizio(
      id: json['id'] as String,
      nome: json['nome'] as String,
      categoria: json['categoria'] as String,
      parteDelCorpo: json['categoria'] as String,
      equipaggiamento: json['istruzioni'] as String,
      target: json['categoria'] as String,
      muscleGroup: json['categoria'] as String,
      imagePath: json['urlThumb'] as String,
      gifPath: json['urlVideo'] as String,
      attribution: json['categoria'] as String 
    );
  }

  List<String> stepsFor(String lang) =>
    instrucionSteps[lang] ?? instrucionSteps['en'] ?? const[];

  String? imageUrl(String baseUrl) =>
    imagePath == null ? null : '$baseUrl/$imagePath';

  String? gifUrl(String baseUrl) =>
    gifPath == null ? null : '$baseUrl/$gifPath';
  

}