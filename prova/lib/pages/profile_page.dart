import 'package:flutter/material.dart';
import 'package:prova/data/sessione.dart';
import 'package:prova/models/utente.dart';

class PaginaProfilo extends StatelessWidget {
  final Utente utente = Sessione().utenteCorrente!;

  PaginaProfilo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sfondo scuro coerente con il resto dell'app
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(utente.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.orangeAccent),
            onPressed: () => print("Modifica profilo"),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.orangeAccent),
            onPressed: () => print("Impostazioni"),
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
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.orangeAccent.withOpacity(0.2),
                  backgroundImage: (utente.fotoUrl != null && utente.fotoUrl!.isNotEmpty)
                      ? NetworkImage(utente.fotoUrl!)
                      : null,
                  child: (utente.fotoUrl == null || utente.fotoUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 40, color: Colors.orangeAccent)
                      : null,
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

            // --- SEZIONE GRAFICO ---
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
            // GridView da modificare per non avere i tasti larghi quanto tutto lo spazio disponibile
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 4.0,
              children: [
                _buildPannelloButton("Statistiche", Icons.auto_graph),
                _buildPannelloButton("Esercizi", Icons.fitness_center_sharp),
                _buildPannelloButton("Misurazioni", Icons.boy_rounded),
                _buildPannelloButton("Calendario", Icons.calendar_month_rounded),
              ],
            ),

            const SizedBox(height: 30),

            // --- CRONOLOGIA ALLENAMENTI ---
            const Text(
              "Cronologia Recente",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xFF1E1E1E),
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.fitness_center, color: Colors.orangeAccent),
                    title: Text("Allenamento ${5 - index}"),
                    subtitle: const Text("12 Aprile - 1h 15m - 4500kg"),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () => print("Dettaglio allenamento"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Funzione per creare i bottoni della griglia
  Widget _buildPannelloButton(String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => print("Cliccato $label"),
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
}