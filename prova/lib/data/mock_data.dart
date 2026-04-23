import 'package:prova/models/corso.dart';
import 'package:prova/models/esercizio.dart';
import 'package:prova/models/esercizio_programmato.dart';
import 'package:prova/models/gruppo_muscolare.dart';
import 'package:prova/models/scheda_allenamento.dart';
import 'package:prova/models/serie.dart';
import 'package:prova/models/utente.dart';

final esercizioPanca = Esercizio(nome: "Panca piana(Bilancere)", id: "1", istruzioni: "Scendi al petto e spingi", categoria: GruppoMuscolare.pettorali);
final esercizioSquat = Esercizio(
  id: '2', 
  nome: 'Squat', 
  istruzioni: 'Scendi sotto il parallelo', 
  categoria: GruppoMuscolare.gambe
);
final esercizioAddominali = Esercizio(nome: "Addominali", id: '3', istruzioni: "Fai gli addominali", categoria: GruppoMuscolare.addominali);
final pancaInclinata = Esercizio(nome: "Panca inclinata (Bilanciere)", id: '4', istruzioni: "Panca inclinata", categoria: GruppoMuscolare.pettorali);
final latPulldown = Esercizio(nome: "Lat Pulldown", id: "5", istruzioni: "Lat pulldown", categoria: GruppoMuscolare.dorsali);
final rematoreCavoSeduto = Esercizio(nome: "Rematore al cavo da seduto", id: "6", istruzioni: "Rematore al cavo da seduto", categoria: GruppoMuscolare.dorsali);
final pushdownTricipiti = Esercizio(nome: "Pushdown tricipiti con corda", id: "7", istruzioni: "Pushdown", categoria: GruppoMuscolare.tricipiti);
final skullCrusher = Esercizio(nome: "Skullcrusher", id: "8", istruzioni: "skullcrusher", categoria: GruppoMuscolare.tricipiti);
final latPulldownSingolo = Esercizio(nome: "Lat Pulldown Braccio Singolo", id: "9", istruzioni: "Singolo", categoria: GruppoMuscolare.dorsali);
final dip = Esercizio(nome: "Dip Tricipiti", id: "10", istruzioni: "Dip", categoria: GruppoMuscolare.tricipiti);
final rematoreInclinato = Esercizio(nome: "Rematore Inclinato (Bilanciere)", id: "11", istruzioni: "rematore inclinato", categoria: GruppoMuscolare.dorsali);


final yoga = Corso(id: "01", nome: "Yoga", orario: "18:30", partecipantiMassimi: 12,giorno: "Lunedi", urlImg: 'assets/corsaFunzionaleSfondo.jpg');
final gag = Corso(id: "02", nome: "G.A.G.", orario: "18:30", giorno: "Martedì", partecipantiMassimi: 12, urlImg: 'assets/corsaFunzionaleSfondo.jpg');
final corsaFunzionale = Corso(id: "03", nome: "Corsa Funzionale", orario: "14:30", giorno: "Mercoledì", partecipantiMassimi: 12, urlImg: 'assets/corsaFunzionaleSfondo.jpg');
final pilates = Corso(id: "04", nome: "Pilates", orario: "18:30", giorno: "Giovedì", partecipantiMassimi: 12, urlImg: 'assets/corsaFunzionaleSfondo.jpg');
final ginnasticaPosturale = Corso(id: "05", nome: "Ginnastica posturale", orario: "18:30", giorno: "Venerdì", partecipantiMassimi: 12, urlImg: 'assets/corsaFunzionaleSfondo.jpg');

List<Corso> corsiSettimanali = [yoga, gag, corsaFunzionale, pilates, ginnasticaPosturale];

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
  ]),
  EsercizioProgrammato(esercizio: pancaInclinata, serie: [
    Serie(ripetizioni: 10, peso: 50, riposoSecondi: 120, completata: false),
    Serie(ripetizioni: 10, peso: 50, riposoSecondi: 120, completata: false),
    Serie(ripetizioni: 10, peso: 50, riposoSecondi: 120, completata: false),
    Serie(ripetizioni: 10, peso: 50, riposoSecondi: 120, completata: false),
  ]),
  EsercizioProgrammato(esercizio: esercizioAddominali, serie: [
    Serie(ripetizioni: 10, peso: 0, riposoSecondi: 60, completata: false),
    Serie(ripetizioni: 10, peso: 0, riposoSecondi: 60, completata: false),
    Serie(ripetizioni: 10, peso: 0, riposoSecondi: 60, completata: false),
    Serie(ripetizioni: 10, peso: 0, riposoSecondi: 60, completata: false),
  ])
]);
final schedaSchiena = SchedaAllenamento(id: "2", titolo: "Schiena", esercizi: [
  EsercizioProgrammato(esercizio: latPulldown, serie: [
    Serie(ripetizioni: 10, peso: 45, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 50, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 55, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 60, completata: false, riposoSecondi: 120)
  ]),
  EsercizioProgrammato(esercizio: rematoreCavoSeduto, serie: [
    Serie(ripetizioni: 10, peso: 30, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 35, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 40, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 40, completata: false, riposoSecondi: 120)
  ]),
  EsercizioProgrammato(esercizio: pushdownTricipiti, serie: [
    Serie(ripetizioni: 10, peso: 15, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 15, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 15, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 15, completata: false, riposoSecondi: 120)
  ]),
  EsercizioProgrammato(esercizio: skullCrusher, serie: [
    Serie(ripetizioni: 10, peso: 18, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 18, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 18, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 18, completata: false, riposoSecondi: 120)
  ]),
  EsercizioProgrammato(esercizio: latPulldownSingolo, serie: [
    Serie(ripetizioni: 10, peso: 15, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 15, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 15, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 15, completata: false, riposoSecondi: 120)
  ]),
  EsercizioProgrammato(esercizio: dip, serie: [
    Serie(ripetizioni: 10, peso: 0, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 0, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 0, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 0, completata: false, riposoSecondi: 120)
  ]),
  EsercizioProgrammato(esercizio: rematoreInclinato, serie: [
    Serie(ripetizioni: 10, peso: 40, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 50, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 50, completata: false, riposoSecondi: 120),
    Serie(ripetizioni: 10, peso: 60, completata: false, riposoSecondi: 120)
  ])
]);

final List<Utente> utenti = [
  Utente(id: "01", nome: "Luca", email: "soldiluca.99@gmail.com", password: "Cipollino", allenamentiFatti: 0, fotoUrl: "https://i.pravatar.cc/300", pesoAttuale: 70, altezza: 180, allenamenti: [schedaUno, schedaSchiena], corsiPrenotati: [yoga]),
  Utente(id: "02", nome: "Daniele", email: "danielesoldi@gmail.com", password: "Daniele", allenamentiFatti: 120, fotoUrl: "https://i.pravatar.cc/300", pesoAttuale: 80, altezza: 180, allenamenti: [schedaUno, schedaUno])
]; 

final Utente utenteSalva = utenti[0]; // Simulazione di un utente già loggato in precedenza