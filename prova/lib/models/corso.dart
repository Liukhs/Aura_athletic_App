import 'package:flutter/material.dart';
///Classe rappresentate un corso offerto dalla palestra
///
///Contiene informazioni su orario, quantità di posti disponibili, immagine di anteprima ecc
class Corso{
  /// [id] - identificatore univoco del corso
  final String id;
  /// [nome] - [orario] - [giorno] - indicatori rispettivamente del nome del corso, orario di inizio e giorno 
  final String nome;
  final String orario;
  final String giorno;
  /// [partecipantiTotali] - [partecipantiMassimi] - ovviamente ogni corso ha un numero di partecipanti effettivo(in base alle prenotazioni) e un numero di partecipanti massimo
  final int partecipantiMassimi;
  int partecipantiTotali;
  /// [urlImg] - immagine anteprima del corso per la card
  final String? urlImg;

  /// Costruttore della classe corso
  Corso({
    required this.id,
    required this.nome,
    required this.orario,
    required this.giorno,
    required this.partecipantiMassimi,
    this.partecipantiTotali = 0,
    this.urlImg
  });

  factory Corso.fromJson(
    Map<String, dynamic> json,
  ){
    return Corso(
      id: json['id'] ?? '',
      nome: json['nome'] ?? 'Corso senza nome',
      orario: json['orario'] ?? '--:--',
      giorno: json['giorno'] ?? '',
      partecipantiMassimi: json['partecipantimax'] as int,
      partecipantiTotali: json['partecipantiTot'] as int,
      urlImg: json['urlImg'] ?? ''
    );
  }

  
}