import 'package:flutter/material.dart';
import 'package:prova/data/database_helper.dart';
import 'package:prova/models/allenamento_completato.dart';
import 'package:table_calendar/table_calendar.dart';

class PaginaCalendario extends StatefulWidget{
  const PaginaCalendario({
    super.key
  });
  
  @override
  State<PaginaCalendario> createState() => _PaginaCalendarioState();
}

class _PaginaCalendarioState extends State<PaginaCalendario>{

  Map<DateTime, List<AllenamentoCompletato>> _futureMap = {};
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState(){
    super.initState();
    _caricaCronologia();
  }

  Future<void> _caricaCronologia() async{
    try{
      final listAllenamenti = await DatabaseHelper.instance.ottieniCronologiaLocale();

      final Map<DateTime, List<AllenamentoCompletato>> listaTemp = {};

      for(var allenamento in listAllenamenti){
        final dataNormalizzata = _normalizeDate(allenamento.data);
        if(listaTemp[dataNormalizzata] == null){
          listaTemp[dataNormalizzata] == [];
        }

        listaTemp[dataNormalizzata]!.add(allenamento);
      }
      setState(() {
        _futureMap = listaTemp;
      });
    } catch(e){
      print("Errore nel caricamento della mappa");
    }
  }
  
  
  DateTime _normalizeDate(DateTime date) => DateTime.utc(date.year, date.month, date.day);

  List<AllenamentoCompletato> _getEventiPerGiorno(DateTime day){
    return _futureMap[_normalizeDate(day)] ?? [];
  }
    
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("CALENDARIO"), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar<AllenamentoCompletato>(
              focusedDay: _focusedDay, 
              firstDay: DateTime.utc(2010, 01, 01), 
              lastDay: DateTime.utc(2030, 12, 31), 
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventiPerGiorno, 
              onDaySelected: (selectedDay, focusedDay) => {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                })
              },

              calendarStyle: const CalendarStyle(
                markerDecoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  shape: BoxShape.circle
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  shape: BoxShape.circle
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}