import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prova/models/esercizio.dart';
import 'package:prova/models/corso.dart';
import 'package:prova/models/scheda_allenamento.dart';
import 'package:prova/models/utente.dart';

class DataService {
  final String url = "https://raw.githubusercontent.com/Liukhs/aura_app_db/refs/heads/main/data_aura.json";

  Future<List<Utente>> loadAllData() async{
    try{
      final response = await http.get(Uri.parse(url));

      if(response.statusCode == 200){
        final Map<String, dynamic> data = json.decode(response.body);
        print("1 JSON scaricato, inizio a cercare gli esercizi");

        List<Esercizio> tuttiGliEsercizi = (data['esercizi'] as List)
        .map((e) => Esercizio.fromJson(e))
        .toList();
        
        print("2 Esercizi completati, inzio ricerca corsi");
        List<Corso> tuttiICorsi = (data['corsi'] as List)
        .map((e)=> Corso.fromJson(e))
        .toList();

        print("Corsi completati inizio ricerca schede allenamento");
        List<SchedaAllenamento> tutteLeSchede = (data['schede_predefinite'] as List)
        .map((e) => SchedaAllenamento.fromJson(e, tuttiGliEsercizi))
        .toList();

        print("Schede completate, inizio ricerca sugli utenti");
        List<Utente> tuttiGliUtenti = (data['utenti'] as List)
        .map((e) => Utente.fromJson(e, tutteLeSchede, tuttiICorsi))
        .toList();

        print("Sto ritornando gli utenti, tutto concluso");
        return tuttiGliUtenti;
      }else{
        throw Exception("Errore nel download: ${response.statusCode}");
      }
    }catch (e){
      print("errore fatale: $e");
      rethrow;
    }
  }
}