import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prova/models/esercizio.dart';

class EserciziRepository {
  final _db = Supabase.instance.client;
  static const pageSize = 20;


  Future<List<Esercizio>> lista ({
    String? parteDelCorpo,
    String? equipaggiamento,
    String? ricerca,
    int pagina = 0,
  }) async {
    var query = _db
      .from('exercises')
      .select('id, name, body_part, equipment, target, image_path');

    if(parteDelCorpo != null) query = query.eq('body_part', parteDelCorpo);
    if(equipaggiamento != null) query = query.eq('equipment', equipaggiamento);
    if(ricerca != null && ricerca.isNotEmpty) query = query.ilike('name', '%$ricerca%');

    final data = await query
      .order('name')
      .range(pagina * pageSize, (pagina + 1) * pageSize - 1);

    return data.map(Esercizio.fromJson).toList();
  }

  Future<Esercizio> dettaglio(String id) async {
    final data = 
      await _db.from('exercises').select().eq('id', id).single();
    return Esercizio.fromJson(data);
  }

   Future<List<String>> partiDelCorpo() async {
    final data = await _db.from('exercises').select('body_part');
    return data.map((r) => r['body_part'] as String).toSet().toList()..sort();
  }
}