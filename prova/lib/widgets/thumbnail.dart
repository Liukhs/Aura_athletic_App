import 'package:flutter/material.dart';
import 'package:prova/models/esercizio.dart';
import 'package:prova/pages/dettaglio_allenamento_page.dart';
import 'package:prova/widgets/video_esercizio.dart';

class Thumbnail extends StatelessWidget{
  final Esercizio esercizio;

  const Thumbnail({super.key, required this.esercizio});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () => mostraVideoEsercizio(context, esercizio.urlVideo!),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
          image: esercizio.urlThumb != null 
          ? DecorationImage(
            image: NetworkImage(esercizio.urlThumb!),
            fit: BoxFit.cover
          )
          :null
        ),
      ),
    );
  }
}