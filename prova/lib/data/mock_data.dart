import 'package:prova/models/esercizio.dart';
import 'package:prova/models/esercizio_programmato.dart';
import 'package:prova/models/scheda_allenamento.dart';
import 'package:prova/models/serie.dart';
import 'package:prova/models/utente.dart';

final Utente utente = Utente(id: "01", nome: "Luca", email: "Soldiluca.99@gmail.com", password: "Cipollino", allenamentiFatti: 0, fotoUrl: "https://i.pravatar.cc/300", pesoAttuale: 70, altezza: 180);
final esercizioPanca = Esercizio(nome: "Panca piana(Bilancere)", id: "1", istruzioni: "Scendi al petto e spingi", categoria: "Petto");
final esercizioSquat = Esercizio(
  id: '2', 
  nome: 'Squat', 
  istruzioni: 'Scendi sotto il parallelo', 
  categoria: 'Gambe'
);

final schedaUno = SchedaAllenamento(id: "1", titolo: "Spinta", esercizi: [
  EsercizioProgrammato(esercizio: esercizioPanca, serie: [
    Serie(ripetizioni: 10, peso: 50.0, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 8, peso: 60.0, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 8, peso: 70.0, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 6, peso: 80.0, completata: false, riposoSecondi: 120)
  ]),
  EsercizioProgrammato(esercizio: esercizioSquat, serie: [
    Serie(ripetizioni: 10, peso: 40, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 50, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 8, peso: 60, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 8, peso: 70, completata: false, riposoSecondi: 120)
  ])
]);

final List<Utente> utenti = [
  Utente(id: "01", nome: "Luca", email: "soldiluca.99@gmail.com", password: "Cipollino", allenamentiFatti: 0, fotoUrl: "https://i.pravatar.cc/300", pesoAttuale: 70, altezza: 180, allenamenti: [schedaUno, schedaUno]),
  Utente(id: "02", nome: "Daniele", email: "danielesoldi@gmail.com", password: "Daniele", allenamentiFatti: 120, fotoUrl: "https://i.pravatar.cc/300", pesoAttuale: 80, altezza: 180, allenamenti: [schedaUno, schedaUno])
]; 
