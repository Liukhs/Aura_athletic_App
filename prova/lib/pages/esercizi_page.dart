import 'package:flutter/material.dart';

class PaginaEsercizi extends StatefulWidget{
  const PaginaEsercizi({
    super.key
  });

  State<PaginaEsercizi> createState() => _PaginaEserciziState();
}

class _PaginaEserciziState extends State<PaginaEsercizi>{
  
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("ESERCIZI"), 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(),
      ),
    );
  }
}