import 'package:flutter/material.dart';
import 'package:prova/data/sessione.dart';

class PaginaMisurazioni extends StatefulWidget{
  const PaginaMisurazioni({
    super.key
  });

  @override
  State<PaginaMisurazioni> createState() => _PaginaMisurazioniState();
}

class _PaginaMisurazioniState extends State<PaginaMisurazioni>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("MISURAZIONI"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Foto progressi", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Card(
                    color: Colors.grey,
                    child:SizedBox(
                    height: 150,
                    width: 100,
                  ) ,
                  ),
                  Card(
                    color: Colors.grey,
                    child:SizedBox(
                    height: 150,
                    width: 100,
                  ) ,
                  ),
                  Card(
                    color: Colors.grey,
                    child:SizedBox(
                    height: 150,
                    width: 100,
                  ) ,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Grafico che apparirà in futuro")
                    ],
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                        ),
                      )
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Peso:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text("${Sessione().utenteCorrente!.pesoAttuale}", style: TextStyle(fontSize: 22))
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                        ),
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                        )
                      )
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Altezza:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text("${Sessione().utenteCorrente!.altezza}", style: TextStyle(fontSize: 22),)
                      ],
                    )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}