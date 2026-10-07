import 'dart:async';
import 'dart:convert';

import 'package:prova/data/sessione.dart';
import 'package:prova/models/allenamento_completato.dart';
import 'package:prova/models/corso.dart';
import 'package:prova/models/esercizio_programmato.dart';
import 'package:prova/models/scheda_allenamento.dart';
import 'package:prova/models/utente.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:prova/models/esercizio.dart';
import 'package:prova/models/serie.dart';

class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDB('aura_athletic.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future _onConfigure(Database db) async{
    await db.execute('PRAGMA foreign_keys= ON');
  }

  Future _createDB(Database db, int version) async{

    await _creaTabelleSchede(db);
    await _creaEserciziCache(db);
  
    //tabella allenamenti finiti
    await db.execute('''
    CREATE TABLE sessioni_allenamento (
      id TEXT PRIMARY KEY,
      utente_id TEXT,
      scheda_id TEXT,
      data TEXT,
      titolo_scheda TEXT,
      durata_secondi TEXT,
      volume_totale REAL,
      bpm INTEGER,
      FOREIGN KEY (utente_id) REFERENCES user (id) ON DELETE CASCADE
    )
  ''');

    //tabella singoli risultati
    await db.execute('''
    CREATE TABLE risultati_esercizi (
      id TEXT PRIMARY KEY,
      sessione_id TEXT,
      exercise_id TEXT,
      nome_esercizio TEXT,
      numero_serie INTEGER,
      peso REAL,
      ripetizioni INTEGER,
      FOREIGN KEY (sessione_id) REFERENCES sessioni_allenamento (id) ON DELETE CASCADE
    )
  ''');

    await db.execute('''
    CREATE TABLE user (
      id TEXT PRIMARY KEY,
      nome TEXT,
      email TEXT NOT NULL,
      password TEXT,
      foto_path TEXT,
      peso REAL,
      altezza INTEGER,
      allenamenti_fatti INTEGER DEFAULT 0
    )
  ''');
  }

  Future _creaTabelleSchede(Database db) async{
    await db.execute('''
    CREATE TABLE schede (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      titolo TEXT NOT NULL
    )
    ''');
    await db.execute(''' 
    CREATE TABLE esercizi_programmati (
      id TEXT PRIMARY KEY,
      scheda_id TEXT NOT NULL,
      exercise_id TEXT NOT NULL,
      nome TEXT NOT NULL,
      image_path TEXT,
      gif_path TEXT,
      body_part TEXT,
      FOREIGN KEY (scheda_id) REFERENCES schede (id) ON DELETE CASCADE
    )
    ''');

    await db.execute(''' 
    CREATE TABLE serie (
      id TEXT PRIMARY KEY,
      esercizio_programmato_id TEXT NOT NULL,
      ripetizioni INTEGER,
      peso REAL,
      riposo_sec INTEGER,
      FOREIGN KEY (esercizio_programmato_id) REFERENCES esercizi_programmati (id) ON DELETE CASCADE
    )
    ''');

    await db.execute('CREATE INDEX idx_schede_user ON schede (user_id)');
    await db.execute('CREATE INDEX idx_esprog_scheda ON esercizi_programmati (scheda_id)');
    await db.execute('CREATE INDEX idx_serie_esprog ON serie (esercizio_programmato_id)');
  }

  Future _creaEserciziCache(Database db) async{
    await db.execute(''' 
    CREATE TABLE esercizi_cache (
      id TEXT PRIMARY KEY,
      dati TEXT NOT NULL,
      cached_at TEXT NOT NULL
    )
    ''');
  }

  Future close() async{
    final db = await instance.database;
    db.close();
  }

  Future<void> inserisciSchedaCompleta(SchedaAllenamento scheda, String user_id) async{
    final db = await instance.database;

    print('DB PATH: ${db.path}');
    print('DIO PORCO COLONNE: ${await db.rawQuery('PRAGMA table_info(esercizi_programmati)')}');
    await db.transaction((txn) async {

      await txn.delete('esercizi_programmati', where: 'scheda_id = ?', whereArgs: [scheda.id]);

      await txn.insert('schede', {...scheda.toMap(), 'user_id': user_id}, conflictAlgorithm: ConflictAlgorithm.replace);

      final batch = txn.batch();
      for(var i = 0; i < scheda.esercizi.length; i++){
        final esercizio = scheda.esercizi[i];
        batch.insert('esercizi_programmati', esercizio.toMap(scheda.id));
        for(var j = 0; j < esercizio.serie.length; j++){
          batch.insert('serie', esercizio.serie[j].toMap(esercizio.id));
        }
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> eliminaScheda(String schedaId) async{
    final db = await instance.database;
    await db.delete('schede', where: 'id = ?', whereArgs: [schedaId]);
  }

  Future<int> contaAllenamenti() async{
    final db = await instance.database;

    final result = await db.rawQuery('SELECT COUNT(*) FROM sessioni_allenamento');

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> salvaAllenamentoCompletato(AllenamentoCompletato allenamento) async{
    final db = await instance.database;

    await db.insert(
      'sessioni_allenamento', 
      allenamento.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
  
  Future<void> salvaAllenamenti(AllenamentoCompletato allenamento, int nAllenamenti, String userId) async{
    final db = await instance.database;
    await db.transaction((txn) async{
      await txn.insert(
        'sessioni_allenamento',
         allenamento.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace
        );

      await txn.update(
        'user',
        {
          'allenamenti_fatti': nAllenamenti,
        },
        //Clausola where usata per identificare quale utente aggiornare, in base all'id univoco
        where: 'id = ?',
        whereArgs: [userId],
      );
    });
  }

  Future<void> salvaUtenteCorrente({
    required String id,
    required String nome,
    required String email,
    required String password,
    String? fotoUrl,
    required double peso,
    required int altezza,
    int? allenamenti_fatti
  }) async{
    final db = await instance.database;

    final valori = {
      'id': id,
      'nome': nome,
      'email': email,
      'password': password,
      'foto_path': fotoUrl ?? "",
      'peso': peso,
      'altezza': altezza,
      'allenamenti_fatti': allenamenti_fatti ?? 0,
    };

    final aggiornate = await db.update('user', valori, where: 'id = ?', whereArgs: [id]);

    if(aggiornate == 0){
      await db.insert('user', {'id':id, ...valori});
    }

  }
  Future<void> aggiornaAllenamentiFatti(String id, int nAllenamenti) async{
    final db = await instance.database;

    await db.update(
      'user',
      {
        'allenamenti_fatti': nAllenamenti,
      },
      //Clausola where usata per identificare quale utente aggiornare, in base all'id univoco
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<void> aggiornaFotoUtente(String id, String path) async{
    final db = await instance.database;

    await db.update('user', {
      'foto_path': path,
    },
    where: 'id = ?',
    whereArgs: [id]
    );
  }

  Future<List<SchedaAllenamento>> ottieniSchedeComplete(String userId) async{
    final db = await instance.database;

    final List<Map<String, dynamic>> resSchede = await db.query('schede', where: 'user_id = ?', whereArgs: [userId]);

    List<SchedaAllenamento> schedeDart = [];

    for(var schedaMap in resSchede){
      String schedaId = schedaMap['id'] as String;

      final List<Map<String, dynamic>> resEsercizi = await db.query('esercizi_programmati', where: 'scheda_id = ?', whereArgs: [schedaId]);
      List<EsercizioProgrammato> eserciziDart = [];

      for(var esMap in resEsercizi){
        String esercizioProgrammatoId = esMap['id'] as String;

        final List<Map<String, dynamic>> resSerie = await db.query('serie', where: 'esercizio_programmato_id = ?', whereArgs: [esercizioProgrammatoId]);

        List<Serie> serieDart = resSerie.map((sMap) => Serie.fromMap(sMap)).toList();

        eserciziDart.add(EsercizioProgrammato.fromDbMap(esMap, serieDart));
      }
      schedeDart.add(SchedaAllenamento.fromDbMap(schedaMap, eserciziDart));

    }

    return schedeDart;
  }

  Future<void> salvaEsercizioInCache(Map<String, dynamic> riga) async{
    final db = await instance.database;
    await db.insert(
      'esercizi_cache',
      {
        'id': riga['id'] as String,
        'dati': jsonEncode(riga),
        'cachet_at': DateTime.now().toIso8601String()
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<Map<String, dynamic>?> leggiEsercizioDaCache(String id) async{
    final db = await instance.database;
    final res = await db.query('esercizi_cache', where: 'id = ?', whereArgs: [id], limit: 1);
    if(res.isEmpty) return null;
    return jsonDecode(res.first['dati'] as String) as Map<String, dynamic>;
  }

  Future<List<AllenamentoCompletato>> ottieniCronologiaLocale() async{
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query('sessioni_allenamento', orderBy: 'data DESC');

    return List.generate(maps.length, (i){
      return AllenamentoCompletato.fromMap(maps[i]);
    });
  }

  Future<void> stampaTuttoIlDatabase() async {
  try {
    final db = await instance.database;
    
    // Controlliamo che tabelle esistono davvero nel file .db
    var tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print("--- TABELLE PRESENTI NEL DB ---");
    print(tables);

    // Stampiamo il contenuto della tabella user
    var utenti = await db.query('user');
    print("--- CONTENUTO TABELLA USER ---");
    print(utenti);

    // Stampiamo gli allenamenti
    var sessioni = await db.query('sessioni_allenamento');
    print("--- CONTENUTO TABELLA SESSIONI ---");
    print(sessioni);
    
  } catch (e) {
    print("ERRORE DURANTE IL DEBUG DEL DB: $e");
  }
  }
  Future<Utente?> getUtenteById(String id) async{
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'id = ?',
      whereArgs: [id],
    );
    if(maps.isNotEmpty){
      return Utente.fromMap(maps.first);
    }

    return null;
  }

  Future<void> sostituisciSchedeUtente(String userId, List<SchedaAllenamento> schede) async{
    final db = await instance.database;
    await db.transaction((txn) async{
      await txn.delete('schede', where: 'user_id = ?', whereArgs: [userId]);

      final batch = txn.batch();
      for (final scheda in schede){
        batch.insert('schede', {...scheda.toMap(), 'user_id': userId});
        for(final esercizio in scheda.esercizi){
          batch.insert('esercizi_programmati', esercizio.toMap(scheda.id));
          for(final serie in esercizio.serie){
            batch.insert('serie', serie.toMap(esercizio.id));
          }
        }
      }
      await batch.commit(noResult: true);
    });
  }
}

