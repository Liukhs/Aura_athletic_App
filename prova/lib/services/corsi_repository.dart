import 'package:prova/data/sessione.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prova/data/database_helper.dart';
import 'package:prova/models/corso.dart';

class CorsiRepository {
  // Creiamo istanza di Supabase
  final _supabase = Supabase.instance.client;

  /// Scarica la lista dei corsi dalla rete
  Future<void> sincronizzaCorsi() async{
    final corsi = await scaricaCorsiDaSupabase();
    Sessione().sostituisciScheduleCorsi(corsi);
  }

  Future<List<Corso>> scaricaCorsiDaSupabase() async{
    final righe = await _supabase.from('corsi').select(''' 
      id, nome, giorno, orario, posti_max, posti_occupati, img_url
    ''');

    return righe.map<Corso>(_corsoDaRiga).toList();
  }

  Corso _corsoDaRiga(Map<String, dynamic> riga){

    return Corso.fromJson(riga);
  }


}