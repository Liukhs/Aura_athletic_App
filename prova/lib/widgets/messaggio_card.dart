import 'package:flutter/material.dart';
import 'package:prova/models/messaggio_palestra.dart';

class MessaggioCard extends StatelessWidget{
  final MessaggioPalestra messaggio;

  const MessaggioCard({
    required this.messaggio
  });

  @override
  Widget build(BuildContext context){
    double width = MediaQuery.of(context).size.width * 0.85;

  return Container(
    width: width,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.orangeAccent.withValues(alpha: 0.2), Colors.transparent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: messaggio.enlighted ? Colors.redAccent : Colors.orangeAccent.withValues(alpha: 0.3))
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.orangeAccent,
          child: Icon(messaggio.icona, color: Colors.black, size: 20,)
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(messaggio.titolo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)
              ),
              const SizedBox(height: 5),
              Text(messaggio.corpo, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8))
              ),
              const SizedBox(height: 5,),
              Text(messaggio.data, style: const TextStyle(color: Colors.orangeAccent, fontSize: 10),
              )
            ],
          ),
        )
      ],
    ),
  );
}

}

