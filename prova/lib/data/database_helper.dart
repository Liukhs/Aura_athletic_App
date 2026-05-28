import 'dart:async';

import 'package:prova/data/sessione.dart';
import 'package:prova/models/allenamento_completato.dart';
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
    //Tabella schede
    await db.execute('''
    CREATE TABLE schede (
      id TEXT PRIMARY KEY,
      titolo TEXT NOT NULL
    )
  ''');
    //tabella esercizi_programmati(legata a schede)
    await db.execute('''
    CREATE TABLE esercizi_programmati (
      id TEXT PRIMARY KEY,
      scheda_id TEXT NOT NULL,
      nome TEXT NOT NULL,
      categoria TEXT,
      istruzioni TEXT,
      FOREIGN KEY (scheda_id) REFERENCES schede (id) ON DELETE CASCADE
    )
  ''');
    //Tabella serie
    await db.execute('''
    CREATE TABLE serie (
      id TEXT PRIMARY KEY,
      esercizio_programmato_id TEXT NOT NULL,
      peso REAL,
      ripetizioni INTEGER,
      riposo INTEGER, -- Spazio per i secondi di recupero che avevi chiesto
      completata INTEGER NOT NULL DEFAULT 0, -- 0 = false, 1 = true
      FOREIGN KEY (esercizio_programmato_id) REFERENCES esercizi_programmati (id) ON DELETE CASCADE
    )
  ''');

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
      nome_esercizio TEXT,
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
      password TEXT NOT NULL,
      foto_path TEXT,
      peso REAL,
      altezza INTEGER,
      allenamenti_fatti INTEGER DEFAULT 0
    )
  ''');
  }

  Future close() async{
    final db = await instance.database;
    db.close();
  }

  Future<void> inserisciSchedaCompleta(SchedaAllenamento scheda) async{
    final db = await instance.database;
    await db.transaction((txn) async {
      await txn.insert('schede', scheda.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      for (var esercizio in scheda.esercizi) {
        await txn.insert('esercizi_programmati', esercizio.toMap(scheda.id), conflictAlgorithm: ConflictAlgorithm.replace);
        for (var serie in esercizio.serie) {
          await txn.insert('serie', serie.toMap(esercizio.id), conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    });
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
  
  Future<void> salvaAllenamenti(AllenamentoCompletato allenamento, int nAllenamenti) async{
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
        whereArgs: [Sessione().utenteCorrente!.id]
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

    await db.insert('user', {
      'id': id,
      'nome': nome,
      'email': email,
      'password': password,
      'foto_path': fotoUrl ?? "",
      'peso': peso,
      'altezza': altezza,
      'allenamenti_fatti': allenamenti_fatti ?? 0
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
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

  Future<List<SchedaAllenamento>> ottieniSchedeComplete(List<Esercizio> tuttiGliEsercizi) async{
    final db = await instance.database;

    final List<Map<String, dynamic>> resSchede = await db.query('schede');

    List<SchedaAllenamento> schedeDart = [];

    for(var schedaMap in resSchede){
      String schedaId = schedaMap['id'] as String;

      final List<Map<String, dynamic>> resEsercizi = await db.query('esercizi_programmati', where: 'scheda_id = ?', whereArgs: [schedaId]);
      List<EsercizioProgrammato> eserciziDart = [];

      for(var esMap in resEsercizi){
        String esercizioProgrammatoId = esMap['id'] as String;

        final List<Map<String, dynamic>> resSerie = await db.query('serie', where: 'esercizio_programmato_id = ?', whereArgs: [esercizioProgrammatoId]);

        List<Serie> serieDart = resSerie.map((sMap) => Serie.fromMap(sMap)).toList();

        eserciziDart.add(EsercizioProgrammato.fromDbMap(esMap, tuttiGliEsercizi, serieDart));
      }
      schedeDart.add(SchedaAllenamento.fromDbMap(schedaMap, eserciziDart));

    }

    return schedeDart;


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
}