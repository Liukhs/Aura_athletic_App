import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:prova/data/database_helper.dart';
import 'package:prova/data/sessione.dart';
import 'package:prova/main.dart';
import 'package:prova/models/allenamento_completato.dart';
import 'package:prova/models/esercizio_programmato.dart';
import 'package:prova/models/scheda_allenamento.dart';
import 'package:prova/models/serie.dart';
import 'dart:async';
import 'package:prova/pages/riepilogo_page.dart';
import 'package:prova/services/notification_service.dart';
import 'package:prova/services/timer_service.dart';
import 'package:prova/widgets/thumbnail.dart';
import 'package:prova/widgets/video_esercizio.dart';

class PaginaAllenamento extends StatefulWidget {
  final SchedaAllenamento scheda;
  //final TextEditingController _controllerScheda = TextEditingController();

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
  bool _isEspanso = true;
  final TimerService _timerAllenamento = TimerService();
  String _tempoTotale = "00:00";
  Timer? _tickerTotale;
  double volume = 0;

  //Mappe utilizzate per tenere conto di tutti i controller e dei focus node all'interno delle righe delle serie
  final Map<String, TextEditingController> _pesoControllers = {};
  final Map<String, TextEditingController> _ripControllers = {};
  final Map<String, FocusNode> _pesoFocusNodes = {};
  final Map<String, FocusNode> _ripFocusNodes = {};

  String _serieKey(EsercizioProgrammato es, int index) {
    final esercizioIndex = widget.scheda.esercizi.indexOf(es);
    return '$esercizioIndex-$index';
  }

  TextEditingController _getPesoController(EsercizioProgrammato es, int index) {
    final key = _serieKey(es, index);
    return _pesoControllers.putIfAbsent(
      key,
      () => TextEditingController(text: es.serie[index].peso.toString()),
    );
  }

  TextEditingController _getRipController(EsercizioProgrammato es, int index) {
    final key = _serieKey(es, index);
    return _ripControllers.putIfAbsent(
      key,
      () => TextEditingController(text: es.serie[index].ripetizioni.toString()),
    );
  }

  FocusNode _getPesoFocusNode(EsercizioProgrammato es, int index) {
    final key = _serieKey(es, index);
    return _pesoFocusNodes.putIfAbsent(key, () => FocusNode());
  }

  FocusNode _getRipFocusNode(EsercizioProgrammato es, int index) {
    final key = _serieKey(es, index);
    return _ripFocusNodes.putIfAbsent(key, () => FocusNode());
  }

  void _selectAll(TextEditingController controller) {
    Future.delayed(Duration.zero, () {
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length,
      );
    });
  }
  

  void initState(){
    super.initState();
    _timerAllenamento.start();
    

    _tickerTotale = Timer.periodic(const Duration(seconds: 1), (timer){
      if(Sessione().orarioInizio != null){
        final differenza = DateTime.now().difference(Sessione().orarioInizio!);
      setState(() {
        _tempoTotale = _formattaDurata(differenza);
      });
      }
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
        NotificationService.fineRecupero();
        setState(() {
          _mostraRecupero = false;
        });
      }
    });
  }
  void _stoppaRecupero(){
    _secondiRimanenti = 0;
    _timerRecupero?.cancel();
    _mostraRecupero = false;
  }
  String _formattaDurata(Duration d){
    String dueCifre(int n) => n.toString().padLeft(2, '0');
    final ore = dueCifre(d.inHours.remainder(60));
    final minuti = dueCifre(d.inMinutes.remainder(60));
    final secondi = dueCifre(d.inSeconds.remainder(60));
    return "$ore:$minuti:$secondi";
  }
  void _calcolaVolume(){
    setState(() {
      volume = 0;
      widget.scheda.esercizi.forEach((esercizio) {
        for(int i = 0; i < esercizio.serie.length; i++){
          if(esercizio.serie[i].completata){
            volume = volume + ((esercizio.serie[i].peso ?? 0)*(esercizio.serie[i].ripetizioni ?? 0.0)); 
          }
        }
      });
    });
  }
  

  @override
  void dispose() {
    _timerRecupero?.cancel(); // Fondamentale per non avere leak di memoria
    _tickerTotale?.cancel();
    for (final controller in _pesoControllers.values) {
      controller.dispose();
    }
    for (final controller in _ripControllers.values) {
      controller.dispose();
    }
    for (final node in _pesoFocusNodes.values) {
      node.dispose();
    }
    for (final node in _ripFocusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void salvaAllenamento() async{
    Sessione().utenteCorrente!.allenamentiFatti += 1;
    AllenamentoCompletato daSalvare = AllenamentoCompletato(id: widget.scheda.id, nome: widget.scheda.titolo, tempoMinuti: _tempoTotale, volume: volume, bpm: 120, data: DateTime.now());
    final db = await DatabaseHelper.instance; 
    //await  DatabaseHelper.instance.salvaAllenamentoCompletato(daSalvare);
    //await DatabaseHelper.instance.aggiornaAllenamentiFatti(
    //  Sessione().utenteCorrente!.id,
    //  Sessione().utenteCorrente!.allenamentiFatti
    //);
    await DatabaseHelper.instance.salvaAllenamenti(daSalvare, Sessione().utenteCorrente!.allenamentiFatti);
  }



  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result){
        if(didPop){
          Sessione().schedaAttiva = widget.scheda;
          
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title:Row(
            children: [ 
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Allenamento")
            ],
          ),
          const Spacer(),
          ElevatedButton(onPressed: () {salvaAllenamento();
          //DatabaseHelper.instance.salvaAllenamentoCompletato(titolo: widget.scheda.titolo, id: widget.scheda.id, durata: _tempoTotale, volume: volume, bpm: 120);
          DatabaseHelper.instance.stampaTuttoIlDatabase();
          Sessione().schedaAttiva = null;
          Sessione().utenteCorrente!.allenamentiFatti += 1; 
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen(initialIndex: 2)),(route)=>false);}, 
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent, 
            foregroundColor: Colors.black, 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), 
            child: const Text("TERMINA", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)))
          ]
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Durata:", style: const TextStyle(fontSize: 12, color: Colors.orangeAccent)),
                        Text("${_tempoTotale}", style: const TextStyle(fontSize: 15, color: Colors.blue)),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Volume:", style: const TextStyle(fontSize: 12, color: Colors.orangeAccent)),
                        Text("${volume} Kg", style: const TextStyle(fontSize: 15, color: Colors.blue))
                      ],
                    )
                  ],
                ),
              ),
            ),
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
                                width: 60,
                                height: 60,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: widget.scheda.esercizi[index].esercizio.urlThumb != null ? Thumbnail(esercizio: widget.scheda.esercizi[index].esercizio) : const Icon(Icons.fitness_center, color: Colors.orangeAccent) 
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
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Aggiungi delle note...',
                              hintText: 'Note...',
                              border: OutlineInputBorder()
                            ),
                            //controller: widget._controllerScheda,
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
                              padding: const EdgeInsets.symmetric(vertical: 1.0),
                              child: _buildRigaSerie(es, i)
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _addRigaSerie(es);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent, 
                              foregroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 40), 
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                            ),
                            child: const Text("Aggiungi Serie", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          )
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
            ? GestureDetector(
              onVerticalDragUpdate: (details){
                if(details.delta.dy > 5){
                  setState(() {
                    _isEspanso = false;
                  });
                }else if(details.delta.dy < 500){
                  _isEspanso = true;
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                height: _isEspanso ? screenHeight : 70,
                width: double.infinity,
                color: const Color(0xFF1E1E1E),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: _isEspanso ? _buildFullScreenLayout() : _buildCompactLayout(),
                ),
              ),
            )
            : null,
      ),
    );
  }

  void _addRigaSerie(EsercizioProgrammato es){
    setState(() {
        es.serie.add(Serie(
          id: es.serie.last.id, 
          completata: false, 
          esercizioId: es.serie.last.esercizioId, 
          peso: es.serie.last.peso, 
          ripetizioni: es.serie.last.ripetizioni, 
          riposoSecondi: es.serie.last.riposoSecondi
        )
      );
    });    
  }

  Widget _buildCompactLayout(){
    return Container(
      key: ValueKey(1),
      height: 70,
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.symmetric(horizontal: 0),
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
          const SizedBox(width: 40),
          ElevatedButton(onPressed: ()=>{_stoppaRecupero()},
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Text("Salta")),
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
    );
  }
  Widget _buildFullScreenLayout(){
    return Column(
      key: ValueKey(2),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        const SizedBox(height: 20),
        const Text("RECUPERO IN CORSO", style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        CircularCountDownTimer(width: 300, height: 300, duration: _secondiRimanenti, fillColor: Colors.black, ringColor: Colors.orangeAccent, textStyle: TextStyle(
          fontSize: 80,
          color: Colors.orangeAccent,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
        isReverse: true,
        onComplete: (){
          _mostraRecupero = false;
        } 
        ),
        
        const SizedBox(height: 60),
        ElevatedButton(
          onPressed: _stoppaRecupero,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            backgroundColor: Colors.orangeAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
          ),
          child: const Text("SALTA", style: TextStyle(fontSize: 18, color: Colors.black),),
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  Widget _buildRigaSerie(EsercizioProgrammato es, int index){
    bool isFatta = es.serie[index].completata;
    final controllerPeso = _getPesoController(es, index);
    final controllerRip = _getRipController(es, index);
    final focusPeso = _getPesoFocusNode(es, index);
    final focusRip = _getRipFocusNode(es, index);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isFatta ? Colors.green.withOpacity(0.50) : Colors.transparent,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text("${index + 1}", style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Center(child: TextFormField(
            controller: controllerPeso,
            focusNode: focusPeso,
            onTap: (){
              _selectAll(controllerPeso);
            },
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,        // Toglie il bordo di default
              enabledBorder: InputBorder.none, // Toglie il bordo quando non è cliccato
              focusedBorder: InputBorder.none, // Toglie il bordo quando lo stai editando
              isDense: true,                   // Riduce lo spazio interno (padding)
              contentPadding: EdgeInsets.zero
            ),
            onChanged: (val){
              es.serie[index].peso = double.tryParse(val) ?? es.serie[index].peso; 
            }
          )
          )
          ),
          Expanded(flex: 2, child: Center(child: TextFormField(
            controller: controllerRip,
            focusNode: focusRip,
            onTap: (){
              _selectAll(controllerRip);
            },
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,        // Toglie il bordo di default
              enabledBorder: InputBorder.none, // Toglie il bordo quando non è cliccato
              focusedBorder: InputBorder.none, // Toglie il bordo quando lo stai editando
              isDense: true,                   // Riduce lo spazio interno (padding)
              contentPadding: EdgeInsets.zero
            ),
            onChanged: (val){
              es.serie[index].ripetizioni = int.tryParse(val) ?? es.serie[index].ripetizioni;
            }
          ))),
          Expanded(flex: 1, 
            child: GestureDetector(
              onTap: () {
                setState(() {
                  es.serie[index].completata = !es.serie[index].completata;
                });
                if (es.serie[index].completata) {
                  _avviaRecupero(es.serie[index].riposoSecondi!);
                  //volume = volume + ((es.serie[index].peso ?? 0.0)*(es.serie[index].ripetizioni ?? 0.0))
                  _calcolaVolume();
                } else {
                  _timerRecupero?.cancel();
                  setState(() => _mostraRecupero = false);
                }
              },
              child: Icon(
                es.serie[index].completata ? Icons.check_box : Icons.check_box_outline_blank,
                color: es.serie[index].completata ? Colors.orangeAccent : Colors.grey,
              ),
            ),
          )
        ],
      )
    );
  }

}