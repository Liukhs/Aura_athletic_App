import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prova/data/database_helper.dart';
import 'package:prova/models/allenamento_completato.dart';
import 'package:prova/models/scheda_allenamento.dart';
import 'package:prova/models/utente.dart';
import 'package:prova/widgets/post_card.dart';
import 'package:prova/data/sessione.dart';
import 'package:prova/pages/allenamento_completato_page.dart';

class PaginaRiepilogo extends StatefulWidget{
  const PaginaRiepilogo({super.key});

  @override
  State<PaginaRiepilogo> createState() => _PaginaRiepilogoState();
}

class _PaginaRiepilogoState extends State<PaginaRiepilogo>{

  
  late Future<List<AllenamentoCompletato>> _futureCronologia;

  @override
  void initState(){
    super.initState();
    _caricaCronologia();
  }

  void _caricaCronologia(){
    setState(() {
      _futureCronologia = DatabaseHelper.instance.ottieniCronologiaLocale();
    });
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
      body: FutureBuilder<List<AllenamentoCompletato>>(
        future: _futureCronologia,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent));
          }
          if(!snapshot.hasData || snapshot.data!.isEmpty){
            return _buildVuoto();
          }
          final cronologia = snapshot.data!;

          return ListView.builder(
            itemCount: cronologia.length,
            itemBuilder: (context, index){
              final allenamento = cronologia[index];
              return _buildCardAllenamento(allenamento);
            }
          );
        }
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
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder:(context)=> AllenamentoCompletatoPage()));
        },
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //HEADER
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orangeAccent,
              backgroundImage: (utente?.fotoUrl != null && utente!.fotoUrl!.isNotEmpty) ? FileImage(File(utente.fotoUrl!)) as ImageProvider : null,
              child: (utente?.fotoUrl == null || utente!.fotoUrl!.isEmpty) ? const Icon(Icons.person, color: Colors.black,): null,
              ),
              title: Text(Sessione().utenteCorrente!.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Disponibile ora'),
              trailing: Text("${sessione.data.day}/${sessione.data.month}/${sessione.data.year}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
                
              ],
            )
        ],
      ),
      ),
    );
  }
}