import 'package:flutter/material.dart';
import 'package:prova/data/database_helper.dart';
import 'package:prova/data/sessione.dart';
import 'package:prova/main.dart';
import 'package:prova/models/utente.dart';
import 'package:prova/services/corsi_repository.dart';
import 'package:prova/services/data_service.dart';
import 'package:prova/services/schede_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _LoginPageState();
}

// --- CLASSE DELLO STATO (SEPARATA) ---
class _LoginPageState extends State<PaginaLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisibile = false;
  

  void _eseguiLogin() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Utente? utenteTrovato;
    String? errore;



    try{
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim()
      );
      final supaUser = res.user!;

      final riga = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', supaUser.id)
          .maybeSingle();
      
      

      if(riga != null){
        
       
        
        await DatabaseHelper.instance.salvaUtenteCorrente(
          id: supaUser.id, 
          nome: riga['nome'] ?? '', 
          email: supaUser.email ?? '', 
          password: '', 
          peso: (riga['peso'] as num?)?.toDouble() ?? 0, 
          altezza: (riga['altezza'] as num?)?.toInt() ?? 0, 
          allenamenti_fatti: (riga['allenamenti_fatti'] as num?)?.toInt() ?? 0, 
          fotoUrl: riga['foto_url']
        );

        Sessione().utenteCorrente = await DatabaseHelper.instance.getUtenteById(supaUser.id);
        utenteTrovato = Sessione().utenteCorrente!;
        
        //for(var scheda in utenteTrovato.allenamenti){
          //await DatabaseHelper.instance.inserisciSchedaCompleta(scheda, utenteTrovato.id);
        //}

        try{
          await SchedeRepository()
            .sincronizza(supaUser.id)
            .timeout(const Duration(seconds: 8));
        }catch(e){
          debugPrint('[sync schede] $e');
        }

        try{
          await CorsiRepository()
            .sincronizzaCorsi()
            .timeout(const Duration(seconds: 8));
        }catch(e){
          debugPrint('[Sync corsi] $e');
        }

        final schede = await DatabaseHelper.instance.ottieniSchedeComplete(supaUser.id);
        for(var scheda in schede){
          Sessione().utenteCorrente!.allenamenti.add(scheda);
        }
        //Sessione().utenteCorrente!.allenamenti.addAll(schede);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email_salvata', Sessione().utenteCorrente!.email);
        await prefs.setString('id_utente', Sessione().utenteCorrente!.id);

        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()),);
      }else{
        await Supabase.instance.client.auth.signOut();
        _mostraErrore("Credenziali non valide. Riprova");
      }
    }on AuthException catch (e){
      errore = 'credenziali non valide';
    }
    if(!mounted) return;
    Navigator.pop(context);

    if(errore != null){
      _mostraErrore(errore);
      return;
    }
    if(utenteTrovato == null){
      _mostraErrore("Credenziali non valide. riprova");
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen())
    );
  }


  void _mostraErrore(String messaggio) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(messaggio),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- LOGO PALESTRA ---
                const Icon(
                  Icons.fitness_center,
                  size: 80,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(height: 20),
                // --- TITOLO ---
                const Text(
                  "AURA ATHLETIC APP",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Accesso riservato agli iscritti",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 50),
                // -- CAMPO EMAIL
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // --- CAMPO PASSWORD ---
                TextField(
                  controller: _passwordController,
                  obscureText: _passwordVisibile ? false : true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisibile ? Icons.visibility : Icons.visibility_off, color: Colors.grey,),
                        onPressed:(){ setState(() {
                          _passwordVisibile = !_passwordVisibile;
                        });
                        },
                        ),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      )),
                ),
                const SizedBox(height: 30),
                // --- BOTTONE ACCEDI ---
                ElevatedButton(
                  onPressed: _eseguiLogin,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0),
                  child: const Text(
                    "ACCEDI",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}