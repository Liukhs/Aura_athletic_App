import 'package:flutter/material.dart';

class PostAllenamento extends StatelessWidget{
  final String utente;
  final String descrizione;

  const PostAllenamento({
    super.key,
    required this.utente,
    required this.descrizione
  });

  @override
  Widget build(BuildContext context){
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //HEADER
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.orangeAccent,
              child: Icon(Icons.person, color: Colors.black),
              ),
              title: Text(utente, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Disponibile ora'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(descrizione), 
            ),
            //FOOTER
            Row(
              children: [
                IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
                IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline)),
              ],
            )
        ],
      ),
    );
  }
}