import 'package:flutter/material.dart';

class PostAllenamento extends StatelessWidget{
  final String utente;
  final String descrizione;
  final String nome;
  final String time;
  final String volume;
  final String bpm;


  const PostAllenamento({
    super.key,
    required this.utente,
    required this.descrizione,
    required this.nome,
    required this.time,
    required this.volume,
    required this.bpm
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
            child: Text(
              nome,
              style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.orangeAccent,
              letterSpacing: 1.1
              ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text("Tempo", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 5),
                          Text(time, style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                    Expanded(child: Column(
                      children: [
                        const Text("Volume", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 5),
                        Text(volume, style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text("BpM", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 5),
                          Text(bpm, style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //FOOTER
            Row(
              children: [
                IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
                IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined))
              ],
            )
        ],
      ),
    );
  }
}