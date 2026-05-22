import 'package:flutter/material.dart';

class PaginaStatistiche extends StatefulWidget{
  const PaginaStatistiche({
    super.key
  });

  @override
  State<PaginaStatistiche> createState() => _PaginaStatisticheState();
}

class _PaginaStatisticheState extends State<PaginaStatistiche>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("STATISTICHE")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(),
      ),
    );
  }
}