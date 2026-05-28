import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PaginaCalendario extends StatefulWidget{
  const PaginaCalendario({
    super.key
  });
  
  @override
  State<PaginaCalendario> createState() => _PaginaCalendarioState();
}

class _PaginaCalendarioState extends State<PaginaCalendario>{
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("CALENDARIO"), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(focusedDay: DateTime.now(), firstDay: DateTime.utc(2010, 01, 01), lastDay: DateTime.utc(2030, 12, 31))
          ],
        ),
      ),
    );
  }
}