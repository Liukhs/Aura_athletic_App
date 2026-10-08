import 'package:flutter/material.dart';
import 'package:prova/models/esercizio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';

void mostraVideoEsercizio(BuildContext context, Esercizio esercizio){
    print(esercizio.debugExercise());
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoEsercizio(esercizio: esercizio),
      )
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
  void initState(){
    _esercizioFuture = _caricaEsercizioDaSupabase(widget.esercizio.id);
  }

  Future<Esercizio> _caricaEsercizioDaSupabase(String esercizioId) async{
    final _supabase = Supabase.instance.client;

    final riga = await _supabase.from('exercises').select(''' 
      id, 
      name, 
      category, 
      body_part,
      equipment,
      target,
      muscle_group,
      gif_path
    ''')
    .eq('id', widget.esercizio.id)
    .maybeSingle();
    
    debugPrint(riga.toString());

    return Esercizio.fromDbMap(riga!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Dettaglio Esercizio", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<Esercizio>(
        future: _esercizioFuture, 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }

          if(snapshot.hasError){
            return Center(child: Text('Errore: ${snapshot.error}'),);
          }

          if(snapshot.hasData){
            final esercizio = snapshot.data!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: 360,

                   child:                  
                Image.network(
                  esercizio.gifPath!,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                  loadingBuilder: (context, child, loadingProgress){
                    if(loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace){
                    return Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.broken_image, color: Colors.white, size: 48,),
                          SizedBox(height: 8,),
                          Text("Impossibile caricare l'immagine", style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    );
                  },
                ),
                ),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      esercizio.nome, 
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.1
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Primario: ${esercizio.muscleGroup}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white
                      )
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Categoria: ${esercizio.categoria}"
                    )
                  ],
                )
              ),
              ],
            );
          }
          return const SizedBox.shrink();
      }),
    );
  }
  
}

