import 'package:flutter/material.dart';
import 'package:prova/models/scheda_allenamento.dart';
import 'dart:async';

import 'package:prova/services/timer_service.dart';

class PaginaAllenamento extends StatefulWidget {
  final SchedaAllenamento scheda;

  const PaginaAllenamento({
    super.key,
    required this.scheda,
  });

  @override
  State<PaginaAllenamento> createState() => _PaginaAllenamentoState();
}

class _PaginaAllenamentoState extends State<PaginaAllenamento> {
  // --- VARIABILI DI STATO SPOSTATE QUI ---
  int _secondiRimanenti = 0;
  Timer? _timerRecupero;
  bool _mostraRecupero = false;
  final TimerService _timerAllenamento = TimerService();
  String _tempoTotale = "00:00";
  Timer? _tickerTotale;

  void initState(){
    super.initState();
    _timerAllenamento.start();

    _tickerTotale = Timer.periodic(const Duration(seconds: 1), (timer){
      setState(() {
        _tempoTotale = _timerAllenamento.tempoFormattato;
      });
    });
  }

  // --- LOGICA SPOSTATA QUI ---
  void _avviaRecupero(int secondi) {
    _timerRecupero?.cancel();

    setState(() {
      _secondiRimanenti = secondi;
      _mostraRecupero = true;
    });

    _timerRecupero = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondiRimanenti > 0) {
        setState(() {
          _secondiRimanenti--;
        });
      } else {
        timer.cancel();
        setState(() {
          _mostraRecupero = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timerRecupero?.cancel(); // Fondamentale per non avere leak di memoria
    _tickerTotale?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.scheda.titolo),
            Text(
              "Durata: $_tempoTotale", style: const TextStyle(fontSize: 12, color: Colors.orangeAccent)
            )
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ESERCIZI DI OGGI",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.scheda.esercizi.length,
              itemBuilder: (context, index) {
                final es = widget.scheda.esercizi[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Intestazione Esercizio
                        Row(
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.fitness_center, color: Colors.orangeAccent),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(es.esercizio.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  Text("Recupero: ${es.serie[0].riposoSecondi}s", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        // Intestazione Tabella
                        const Row(
                          children: [
                            Expanded(flex: 1, child: Text("SERIE", style: TextStyle(color: Colors.grey, fontSize: 12))),
                            Expanded(flex: 2, child: Center(child: Text("KG", style: TextStyle(color: Colors.grey, fontSize: 12)))),
                            Expanded(flex: 2, child: Center(child: Text("REPS", style: TextStyle(color: Colors.grey, fontSize: 12)))),
                            Expanded(flex: 1, child: SizedBox()),
                          ],
                        ),
                        const Divider(color: Colors.grey),
                        // Lista Serie
                        for (int i = 0; i < es.serie.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(flex: 1, child: Text("${i + 1}", style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold))),
                                Expanded(flex: 2, child: Center(child: Text("${es.serie[i].peso ?? '-'}", style: const TextStyle(fontSize: 16)))),
                                Expanded(flex: 2, child: Center(child: Text("${es.serie[i].ripetizioni}", style: const TextStyle(fontSize: 16)))),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        es.serie[i].completata = !es.serie[i].completata;
                                      });
                                      if (es.serie[i].completata) {
                                        _avviaRecupero(es.serie[i].riposoSecondi!);
                                      } else {
                                        _timerRecupero?.cancel();
                                        setState(() => _mostraRecupero = false);
                                      }
                                    },
                                    child: Icon(
                                      es.serie[i].completata ? Icons.check_box : Icons.check_box_outline_blank,
                                      color: es.serie[i].completata ? Colors.orangeAccent : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: _mostraRecupero
          ? Container(
              height: 70,
              color: const Color(0xFF1E1E1E),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.hourglass_bottom, color: Colors.orangeAccent),
                      SizedBox(width: 10),
                      Text("RECUPERO...", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                    ],
                  ),
                  Text(
                    "${_secondiRimanenti}s",
                    style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Monospace'),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}