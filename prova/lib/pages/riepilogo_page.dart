import 'package:flutter/material.dart';
import 'package:prova/models/allenamento_completato.dart';
import 'package:prova/models/scheda_allenamento.dart';
import 'package:prova/models/utente.dart';
import 'package:prova/widgets/post_card.dart';
import 'package:prova/data/sessione.dart';

class PaginaRiepilogo extends StatefulWidget{
  const PaginaRiepilogo({super.key});

  @override
  State<PaginaRiepilogo> createState() => _PaginaRiepilogoState();
}

class _PaginaRiepilogoState extends State<PaginaRiepilogo>{

  List<AllenamentoCompletato> cronologia = [];

  @override
  void initState(){
    super.initState();
    _caricaCronologia();
  }

  void _caricaCronologia(){
    final utente = Sessione().utenteCorrente;

    if(utente != null){
      setState(() {
        cronologia = utente.cronologiaAllenamenti.reversed.toList();
      });
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('I MIEI ALLENAMENTI', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.orangeAccent,),
            onPressed: (){
              print("Pulsante ricerca premuto");
            },
            ),
            const SizedBox(width: 10),
        ],
      ),
      body: cronologia.isEmpty ? _buildVuoto() : ListView.builder(
        itemCount: cronologia.length,
        
        itemBuilder: (context, index){
          final allenamento = cronologia[index];
          return _buildCardAllenamento(allenamento);
        },
      )
    );
  }

  Widget _buildVuoto(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[800]),
          const SizedBox(height: 16),
          const Text("Non hai ancora completato allenamenti.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))
        ],
      ),
    );
  }

  Widget _buildCardAllenamento(AllenamentoCompletato sessione){
    final utente = Sessione().utenteCorrente;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //HEADER
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orangeAccent,
              backgroundImage: (utente?.fotoUrl != null && utente!.fotoUrl!.isNotEmpty) ? NetworkImage(utente.fotoUrl!) : null,
              child: (utente?.fotoUrl == null || utente!.fotoUrl!.isEmpty) ? const Icon(Icons.person, color: Colors.black,): null,
              ),
              title: Text(Sessione().utenteCorrente!.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Disponibile ora'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              sessione.nome,
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
                          Text(sessione.tempoMinuti.toString(), style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                    Expanded(child: Column(
                      children: [
                        const Text("Volume", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 5),
                        Text(sessione.volume.toString(), style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text("BpM", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 5),
                          Text(sessione.bpm.toString(), style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16)),
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