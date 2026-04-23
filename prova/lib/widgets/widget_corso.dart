import 'package:flutter/material.dart';
import 'package:prova/data/sessione.dart';
import 'package:prova/models/corso.dart';

Widget cardCorso(BuildContext context, Corso corso){
    int postiLiberi = corso.partecipantiMassimi - corso.partecipantiTotali;
    return Container(
        width: 280,
        margin: EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.orangeAccent.withOpacity(0.6)),
            image: corso.urlImg != null && corso.urlImg!.isNotEmpty 
            ? DecorationImage(
                image: AssetImage(corso.urlImg!),
                fit: BoxFit.cover
            )
            : null
        ),
        child: Stack(
            children: [
                Positioned.fill(
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                    Colors.black.withOpacity(0.9),
                                    Colors.black.withOpacity(0.1),
                                    Colors.black.withOpacity(0.7),
                                ],
                                stops: const [0.0, 0.45, 1.0]
                            )
                        ),
                    ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    child: SizedBox(
                        width: double.infinity,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Text(
                                    corso.nome.toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        letterSpacing: 1.5,
                                    ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                    "${corso.giorno} ore: ${corso.orario}",
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                    ),
                                ),
                                const SizedBox(height: 8),
                                
                                Text(
                                    postiLiberi > 0 ?
                                    "${postiLiberi} posti disponibili" 
                                    : "SOLD OUT!",
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                    ),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orangeAccent,
                                        foregroundColor: Colors.black,
                                        elevation: 5,
                                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    ),
                                    onPressed: (){
                                        final messaggio = Sessione().prenotaCorso(corso);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text(messaggio),
                                                backgroundColor: messaggio.contains("successo") ? Colors.green : Colors.redAccent,
                                                duration: const Duration(seconds: 2),
                                                behavior: SnackBarBehavior.floating,
                                            ),
                                        );
                                    },
                                    child: const Text(
                                        "PRENOTA",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                        ),
                                    ),
                                )
                            ],
                        ),
                    ),
                )
            ],
        )
    );
}