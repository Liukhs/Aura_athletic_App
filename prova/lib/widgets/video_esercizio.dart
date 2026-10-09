import 'package:flutter/material.dart';
import 'package:prova/models/esercizio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';

void mostraVideoEsercizio(BuildContext context, Esercizio esercizio) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => VideoEsercizio(esercizio: esercizio),
    ),
  );
}

class VideoEsercizio extends StatefulWidget {
  final Esercizio esercizio;
  const VideoEsercizio({super.key, required this.esercizio});

  @override
  State<VideoEsercizio> createState() => _VideoEsercizioState();
}

class _VideoEsercizioState extends State<VideoEsercizio> {
  late Future<Esercizio> _esercizioFuture;

  @override
  void initState() {
    _esercizioFuture = _caricaEsercizioDaSupabase(widget.esercizio.id);
  }

  Future<Esercizio> _caricaEsercizioDaSupabase(String esercizioId) async {
    final _supabase = Supabase.instance.client;

    final riga = await _supabase
        .from('exercises')
        .select(''' 
      id, 
      name, 
      category, 
      body_part,
      equipment,
      target,
      muscle_group,
      gif_path,
      instruction_steps
    ''')
        .eq('id', widget.esercizio.id)
        .maybeSingle();

    debugPrint(riga.toString());

    return Esercizio.fromDbMap(riga!);
  }

  Widget buildPill(String label) {
    return Container(
      width: 160,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0092CC).withOpacity(0.12),
        border: Border.all(color: Color(0xFF0092CC), width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: const Color(0xFF0092CC),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Dettaglio Esercizio",
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorColor: Color(0xFF0095CC),
            labelColor: Color(0xFF0095CC),
            dividerColor: Color(0xFF000000),
            tabs: <Widget>[
              Tab(text: "Riepilogo",),
              Tab(text: "Istruzioni",),
              Tab(text: "Statistiche",),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            FutureBuilder<Esercizio>(
              future: _esercizioFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Errore: ${snapshot.error}'));
                }

                if (snapshot.hasData) {
                  final esercizio = snapshot.data!;
                  final passi = esercizio.stepsFor('it');

                  return SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: 360,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.white),
                          child: Image.network(
                            esercizio.gifPath!,
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.medium,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 200,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                alignment: Alignment.center,
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Impossibile caricare l'immagine",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                esercizio.nome.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              SizedBox(height: 15),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: [
                                  buildPill(
                                    "Gruppo Muscolare: ${esercizio.muscleGroup}",
                                  ),
                                  buildPill(
                                    "Categoria: ${esercizio.categoria}",
                                  ),
                                  buildPill("Target: ${esercizio.target}"),
                                  buildPill(
                                    "Equipment: ${esercizio.equipaggiamento}",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            FutureBuilder<Esercizio>(
              future: _esercizioFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Errore: ${snapshot.error}'));
                }
                if (snapshot.hasData) {
                  final esercizio = snapshot.data!;
                  final passi = esercizio.stepsFor('it');

                  return SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: 360,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.white),
                          child: Image.network(
                            esercizio.gifPath!,
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.medium,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 200,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                alignment: Alignment.center,
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Impossibile caricare l'immagine",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                esercizio.nome.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              SizedBox(height: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (passi.isEmpty)
                                    const Text("istruzioni non disponibili")
                                  else
                                    for (final (i, passo) in passi.indexed)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${i + 1}. ',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                passo,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            Center(child: Text("It's sunny here")),
          ],
        ),
      ),
    );
  }
}
