import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prova/data/database_helper.dart';
import 'package:prova/models/esercizio.dart';
import 'package:prova/models/esercizio_programmato.dart';
import 'package:prova/models/scheda_allenamento.dart';
import 'package:prova/models/serie.dart';

// Nel catalogo i percorsi sono relativi (images/..., videos/...).
// Questo è l'unico punto in cui si decide da dove arrivano i file:
// in futuro basterà cambiare questa riga (es. con Supabase Storage).
const String mediaBaseUrl =
    'https://raw.githubusercontent.com/hasaneyldrm/exercises-dataset/main';

class SchedeRepository{
  /// Creiamo l'istanza di Supabase
  final _supabase = Supabase.instance.client;
  
  /// Scarica le schede dell'utente da Supabase e sostituisce la copia locale.
  /// Se la rete manca, scaricaDaSupabase() lancia un'eccezione PRIMA di toccare
  /// il database locale: le schede già salvate restano intatte.
  Future<void> sincronizza(String userId) async{
    final schede = await scaricaDaSupabase();
    await DatabaseHelper.instance.sostituisciSchedeUtente(userId, schede);
  }

  /// Una sola richiesta: schede + esercizi + serie + dati del catalogo.
  /// Non serve filtrare per utente: la RLS restituisce solo le sue schede.
  Future<List<SchedaAllenamento>> scaricaDaSupabase() async{
    final righe = await _supabase.from('schede').select(''' 
      id, titolo,
      esercizi_programmati (
        id, ordine, exercise_id,
        exercises ( name, image_path, gif_path, body_part, muscle_group, category ),
        serie_programmate( id, ordine, ripetizioni, peso, riposo_sec)
        )
    ''').order('created_at');

    return righe.map<SchedaAllenamento>(_schedaDaRiga).toList();
  }

  SchedaAllenamento _schedaDaRiga(Map<String, dynamic> riga){
    // Le liste annidate non arrivano per forza in ordine: si ordinano qui.
    final eserciziRighe = List<Map<String, dynamic>>.from(riga['esercizi_programmati'] as List)
    ..sort((a,b) => (a['ordine'] as int).compareTo(b['ordine'] as int));

    final esercizi = eserciziRighe.map((e) {
      final catalogo = e['exercises'] as Map<String, dynamic>;

      print('---- CATALOGO ESERCIZI-----\n');
      print('$catalogo');

      

      final serieRighe =
          List<Map<String, dynamic>>.from(e['serie_programmate'] as List)
            ..sort((a, b) => (a['ordine'] as int).compareTo(b['ordine'] as int));

      return EsercizioProgrammato(
        id: e['id'] as String,
        esercizio: Esercizio(
          id: e['exercise_id'] as String,
          nome: catalogo['name'] as String,
          imagePath: _url(catalogo['image_path'] as String?),
          gifPath: _url(catalogo['gif_path'] as String?),
          parteDelCorpo: catalogo['body_part'] as String?,
          muscleGroup: catalogo['muscle_group'] as String,
          categoria: catalogo['category'] as String,
        ),
        serie: serieRighe
          .map((s) => Serie(
            id: s['id'] as String,
            esercizioProgrammatoId: e['id'] as String,
            ripetizioni: s['ripetizioni'] as int,
            peso: (s['peso'] as num).toDouble(),
            riposoSecondi: s['riposo_sec'] as int,
          )).toList(),
      );
    }).toList();

    for(EsercizioProgrammato es in esercizi){
      print("----- TUTTI GLI ESERCIZI ----- \n ${es.esercizio.muscleGroup}");

    }

    return SchedaAllenamento(
      id: riga['id'] as String,
      titolo: riga['titolo'] as String,
      esercizi: esercizi,
    );
  }

  String? _url(String? percorso){
    if(percorso == null || percorso.isEmpty) return null;
    return '$mediaBaseUrl/$percorso';
  }
  
}