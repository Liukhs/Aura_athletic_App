import 'package:flutter/material.dart';

class AllenamentoCompletatoPage extends StatefulWidget {
  
  @override
  State<AllenamentoCompletatoPage> createState()=> _AllenamentoCompletatoPageState();

}

class _AllenamentoCompletatoPageState extends State<AllenamentoCompletatoPage>{
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allenamento Completato'),
      ),
      body: Center(
        child: Text(
          'Complimenti! Hai completato il tuo allenamento.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}