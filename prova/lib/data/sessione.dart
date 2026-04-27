import 'package:flutter/material.dart';
import 'package:prova/models/scheda_allenamento.dart';
import 'package:prova/models/utente.dart';
import 'package:prova/models/corso.dart';
import 'package:prova/models/esercizio.dart';
/// classe di gestione dello stato globale dell'applicazione (Singleton).
/// 
/// Si occupa di mantenere i dati dell'utente corrente, la sessione di allenamento attiva e le notifiche per UI [notifyListeners]
class Sessione extends ChangeNotifier { //
  static final Sessione _instance = Sessione._internal();
  factory Sessione() => _instance;
  Sessione._internal();

  Utente? utenteCorrente;
 

  SchedaAllenamento? _schedaAttiva;
  DateTime? _orarioInizio;

  SchedaAllenamento? get schedaAttiva => _schedaAttiva;
  DateTime? get orarioInizio => _orarioInizio;

  List<Corso> tuttiICorsi = [];
  List<Esercizio> tuttiGliEsercizi = [];
  List<SchedaAllenamento> tutteLeSchede = [];

  void inizializzaDati(List<Esercizio> esercizi, List<Corso> corsi, List<SchedaAllenamento> schede){
    tuttiICorsi = corsi;
    tutteLeSchede =  schede;
    tuttiGliEsercizi = esercizi;
    notifyListeners();
  }

  set schedaAttiva(SchedaAllenamento? scheda){
    _schedaAttiva = scheda;

    notifyListeners();
  }

  set orarioInizio(DateTime? orario){
    _orarioInizio = orario;
    notifyListeners();
  }

  
  ///Inizializza ogni sessione dell'applicazione salvando l'utenteCorrente per i dati in app
  ///Salva anche utenteSalvato per permettere i prossimi accessi senza inserire email e password
  void inizializzaSessione(Utente utente){//
    utenteCorrente = utente;
    notifyListeners();
  }

  ///Termina effettivamente l'allenamento attivo togliendolo dalla sessione disattivando anche il timer globale dell'allenamento in questione
  void terminaAllenamento(){//
    _schedaAttiva = null;
    _orarioInizio = null;
    notifyListeners();
  }

  ///Funzione di prenotazione di un [Corso] - aggiungendolo alla lista [corsiPrenotati] di [Utente]
  ///
  ///Incrementa anche il conteggio dei partecipanti al corso e aggiorna i [Widget] in ascolto
  String prenotaCorso(Corso corso){//
    if(utenteCorrente == null) return "Errore, nessun utente loggato";

    bool giaPresente = utenteCorrente!.corsiPrenotati.any((c) => c.id == corso.id);

    if(giaPresente){
      return "Hai già prenotato questo corso!";
    }else{
      utenteCorrente!.corsiPrenotati.add(corso);
      corso.partecipantiTotali = corso.partecipantiTotali + 1;
      notifyListeners();
      return "Prenotazione salvata con successo";
    }

  }
}