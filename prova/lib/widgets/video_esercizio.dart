import 'package:flutter/material.dart';
import 'package:prova/models/esercizio.dart';
import 'package:video_player/video_player.dart';

void mostraVideoEsercizio(BuildContext context, Esercizio esercizio){
    print("${esercizio}");
    print("muscle Group -> ${esercizio.muscleGroup}");
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: VideoEsercizio(url: esercizio.gifPath!)),
            /*Padding(
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
                    "Primario: ${esercizio.muscleGroup!}",
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
            ),*/
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CHIUDI"),
            )
          ],
        ),
      )
    );
  }
class VideoEsercizio extends StatelessWidget {
  final String url;
  const VideoEsercizio({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress){
        if(loadingProgress == null) return child;
        return Container(
          height: 200,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
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
              Icon(Icons.broken_image, color: Colors.white, size: 48,),
              SizedBox(height: 8,),
              Text("Impossibile caricare immagine", style: TextStyle(color: Colors.white))
            ],
          ),
        );
      },
    );
    
  }
  
}

