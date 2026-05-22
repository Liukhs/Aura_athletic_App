import 'package:flutter/material.dart';
import 'package:prova/data/database_helper.dart';
import 'package:prova/data/sessione.dart';
import 'package:prova/models/utente.dart';
import 'package:prova/models/allenamento_completato.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:fl_chart/fl_chart.dart';
import 'package:prova/pages/calendario_page.dart';
import 'package:prova/pages/esercizi_page.dart';
import 'package:prova/pages/misurazioni_page.dart';
import 'package:prova/pages/statistiche_page.dart';

class PaginaProfilo extends StatefulWidget {
  const PaginaProfilo({super.key});

  @override
  State<PaginaProfilo> createState() => _PaginaProfiloState();
}

class _PaginaProfiloState extends State<PaginaProfilo> {
  // Recuperiamo l'utente dalla sessione
  late Utente utente;
  late Future<List<AllenamentoCompletato>> _futureCronologia;

  @override
  void initState() {
    super.initState();
    // Inizializziamo l'utente all'avvio
    utente = Sessione().utenteCorrente!;
    _futureCronologia = DatabaseHelper.instance.ottieniCronologiaLocale();
  }

  Future<void> _aggiornaImmagineProfilo() async{
    final picker = ImagePicker();

    final XFile? immagineScelta = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      imageQuality: 90,
    );
    if(immagineScelta == null) return;

    try{
      final directory = await getApplicationDocumentsDirectory();

      final nomeFile = "profilo_${utente.id}${p.extension(immagineScelta.path)}";
      final percorsoFinale = p.join(directory.path, nomeFile);

      final File nuovaImmagine = await File(immagineScelta.path).copy(percorsoFinale);

      await DatabaseHelper.instance.aggiornaFotoUtente(utente.id, nuovaImmagine.path);

      setState(() {
        utente.fotoUrl = nuovaImmagine.path;
        Sessione().utenteCorrente?.fotoUrl = nuovaImmagine.path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto profilo aggiornata!")),
      );
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Errore nel salvataggio della foto: $e")),
      );
    }
  }

  // Metodo per aggiornare la UI se serve (es. dopo un allenamento)
  void aggiorna() {
    setState(() {
      utente = Sessione().utenteCorrente!;
    });
  }
  void _mostraOpzioniFoto(){
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context){
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Colors.orangeAccent),
                title: const Text("Cambia immagine", style: TextStyle(color: Colors.white)),
                onTap: (){
                  Navigator.pop(context);
                  _aggiornaImmagineProfilo();
                  print("avvio picker di immagini");
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_red_eye_outlined, color: Colors.orangeAccent),
                title: const Text("Visualizza immagine", style: TextStyle(color: Colors.white)),
                onTap:(){
                  Navigator.pop(context);
                  _mostraFotoProfilo(context, utente.fotoUrl!);
                }
              )
            ],
          ),
        );
      }
    );
  }
  void _mostraFotoProfilo(BuildContext context, String urlImmagine){
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image:DecorationImage(
              image: FileImage(File(urlImmagine)),
              fit: BoxFit.cover
            ) 
          )
        )
        ),
      );

  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(utente.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.orangeAccent),
            onPressed: () => print("Modifica profilo"),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.orangeAccent),
            onPressed: () => DatabaseHelper.instance.stampaTuttoIlDatabase(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER: FOTO + INFO UTENTE ---
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: (){
                    _mostraOpzioniFoto();
                  },
                  child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.orangeAccent.withOpacity(0.2),
                  backgroundImage: (utente.fotoUrl != null && utente.fotoUrl!.isNotEmpty)
                      ? FileImage(File(utente.fotoUrl!)) as ImageProvider
                      : null,
                  child: (utente.fotoUrl == null || utente.fotoUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 40, color: Colors.orangeAccent)
                      : null,
                ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      utente.nome,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Allenamenti fatti: ${utente.allenamentiFatti}",
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- SEZIONE GRAFICO (IL TUO CONTAINER VUOTO) ---
            const Row(
              children: [
                Icon(Icons.show_chart, color: Colors.orangeAccent, size: 20),
                SizedBox(width: 8),
                Text("Analisi Progressi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  "Grafico volume/durata (Coming soon)",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- PANNELLO DI CONTROLLO (GRID 2x2) ---
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 4.0,
              children: [
                _buildPannelloButton(context, "Statistiche", Icons.auto_graph, PaginaStatistiche()),
                _buildPannelloButton(context, "Esercizi", Icons.fitness_center_sharp, PaginaEsercizi()),
                _buildPannelloButton(context, "Misurazioni", Icons.boy_rounded, PaginaMisurazioni()),
                _buildPannelloButton(context, "Calendario", Icons.calendar_month_rounded, PaginaCalendario()),
              ],
            ),

            const SizedBox(height: 30),
            // --- PRENOTAZIONI ---
            const Text(
              "Prenotazioni",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12,),
            utente.corsiPrenotati.isEmpty
            ? _buildVuoto("Non hai corsi prenotati.")
            : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: utente.corsiPrenotati.length,
              itemBuilder: (context, index){
                return _buildCardPrenotazione(index);
              },
            ),
            const SizedBox(height: 30),

            // --- CRONOLOGIA ALLENAMENTI ---
            const Text(
              "Cronologia Recente",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<AllenamentoCompletato>>(
              future: _futureCronologia,
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent));
                }
                if(!snapshot.hasData || snapshot.data!.isEmpty){
                  return _buildVuoto("Non hai ancora completato allenamenti");
                }
                final cronologia = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cronologia.length,
                  itemBuilder: (context, index){
                    final allenamento = cronologia[index];
                    return _buildCardCronologia(allenamento);
                  },
                );
              },
            ),
              const SizedBox(height: 12)
              ///utente.personalPrenotati.isEmpty
              ///? _buildVuoto("Non hai prenotato nessuna lezione con il personal.")
              ////:ListView.builder(
              ///  shrinkWrap: true,
              ///  physics: const NeverScrollableScrollPhysics(),
              ///  itemCount: utente.personalPrenotati.length,
              ///  itemBuilder: (context, index){
              ///    return _buildCardPrenotazione(index);
              ///  },
            ///  )
          ],
        ),
      ),
    );
  }

  // --- I TUOI METODI HELPER (SPOSTATI DENTRO LO STATE) ---

  Widget _buildPannelloButton(BuildContext context, String label, IconData icon, Widget destinazione) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinazione)
        ),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.orangeAccent, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildCardCronologia(AllenamentoCompletato allenamento) {
    
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.fitness_center, color: Colors.orangeAccent),
        title: Text(allenamento.nome),
        subtitle: Text("Vol: ${allenamento.volume} - Tempo: ${allenamento.tempoMinuti} - BPM: ${allenamento.bpm}"),
      ),
    );
  }

  Widget _buildCardPrenotazione(int index){
    final sessione = utente.corsiPrenotati[index];
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.fitness_center, color: Colors.orangeAccent,),
        title: Text(sessione.nome),
        subtitle: Text(sessione.orario),
      ),
    );
  }

  Widget _buildVuoto(String messaggio) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[800]),
          const SizedBox(height: 16),
          Text(
            messaggio,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}