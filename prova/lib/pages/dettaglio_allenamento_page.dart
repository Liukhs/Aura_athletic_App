import 'package:flutter/material.dart';
import 'package:prova/models/scheda_allenamento.dart';
import 'package:prova/pages/allenamento_page.dart';

class PaginaDettaglioAllenamento extends StatefulWidget{
  final SchedaAllenamento scheda;

  const PaginaDettaglioAllenamento({
    super.key,
    required this.scheda
  });
  @override
  State<PaginaDettaglioAllenamento> createState() => _PaginaDettaglioAllenamentoState();
}
class _PaginaDettaglioAllenamentoState extends State<PaginaDettaglioAllenamento>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(widget.scheda.titolo), centerTitle: true,),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaAllenamento(scheda:  widget.scheda)));
              }, style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("AVVIA ALLENAMENTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),    
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ESERCIZI IN PROGRAMMA",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.scheda.esercizi.length,
              itemBuilder: (context, index){
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
                        Row(
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.fitness_center, color: Colors.orangeAccent,),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(es.esercizio.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  Row(
                                    children: [
                                      const Icon(Icons.timer_outlined, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text("Recupero: ${es.serie[index].riposoSecondi}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          children: [
                            Expanded(flex: 1, child: Text("SERIE", textAlign: TextAlign.left, style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text("KG", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text("RIPETIZIONI", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold))),
                            Expanded(flex: 1, child: SizedBox())
                          ],
                        ),
                        const Divider(color: Colors.grey),

                        for(int i = 0; i<es.serie.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              //numero serie
                              Expanded(flex: 1, child: Text("${i+1}", style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Center(
                                child: Text("${es.serie[i].peso ?? '-'}", style: const TextStyle(fontSize: 16)),
                              )
                            ),
                            Expanded(flex: 2, child: Center(
                              child: Text("${es.serie[i].ripetizioni}", style: const TextStyle(fontSize: 16)),
                            )
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                es.serie[i].completata = !es.serie[i].completata;
                              });
                            },
                            child: Icon(es.serie[i].completata ? Icons.check_box : Icons.check_box_outline_blank,
                            color: es.serie[i].completata ? Colors.orangeAccent : Colors.grey,
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
          ),
        ],
      )
    );
  }
}
