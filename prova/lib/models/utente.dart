import 'package:flutter/material.dart';
import 'package:prova/models/scheda_allenamento.dart';

class Utente{
  final String id;
  final String nome;
  final String email;
  final String password;
  final String? fotoUrl;
  final double? pesoAttuale;
  final int? altezza;
  final int allenamentiFatti;
  final List<SchedaAllenamento> allenamenti;

  Utente({
    required this.id,
    required this.nome,
    required this.email,
    required this.password,
    this.fotoUrl,
    this.pesoAttuale,
    this.altezza,
    required this.allenamentiFatti,
    this.allenamenti = const []
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