import 'package:flutter/material.dart';
import 'package:prova/models/allenamento_completato.dart';
import 'package:prova/models/corso.dart';
import 'package:prova/models/scheda_allenamento.dart';
///Classe per la rappresentazione di un utente della palestra.
///Contiene tutte le informazioni sull'utente ad'ora inserite
///(DA SISTEMARE)
class Utente{
  ///[id] - identificativo univoco dell'utente
  final String id;
  ///[nome] - Nome mostrato all'interno dell'applicazione
  final String nome;
  ///[email] - Email utilizzata per l'accesso all'applicazione e la creazione dell'account
  final String email;
  ///[password] - Password di accesso all'account
  final String password;
  ///[fotoUrl] - url della foto del profilo dell'account
  final String? fotoUrl;
  ///[pesoAttuale] - [altezza] Parametri del cliente
  final double? pesoAttuale;
  final int? altezza;
  ///[allenamentiFatti] - [allenamenti] - [cronologiaAllenamenti] - [corsiPrenotati] - liste di contenimento di schede, allenamenti e corsi dell'utente
  final int allenamentiFatti;
  final List<SchedaAllenamento> allenamenti;
  List<AllenamentoCompletato> cronologiaAllenamenti = [];
  List<Corso> corsiPrenotati = [];

  ///Costruttore della classe utente
  Utente({
    required this.id,
    required this.nome,
    required this.email,
    required this.password,
    this.fotoUrl,
    this.pesoAttuale,
    this.altezza,
    required this.allenamentiFatti,
    this.allenamenti = const [],
    this.corsiPrenotati = const []
  });

  Utente copyWith({
    String? nome,
    String? email,
    String? password,
    String? fotoUrl,
    double? pesoAttuale,
    int? altezza,
    int? allenamentiFatti,
    List<SchedaAllenamento>? allenamenti,
  }){
    return Utente(
      id: this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      password: password ?? this.password,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      pesoAttuale: pesoAttuale ?? this.pesoAttuale,
      altezza: altezza ?? this.altezza,
      allenamentiFatti: allenamentiFatti ?? this.allenamentiFatti,
      allenamenti: allenamenti ?? this.allenamenti,
    );
  }
  
}