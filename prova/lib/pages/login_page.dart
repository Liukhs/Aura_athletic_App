import 'package:flutter/material.dart';
import 'package:prova/data/sessione.dart';
import 'package:prova/main.dart';
import 'package:prova/models/utente.dart';
import 'package:prova/services/data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    try{
      List<Utente> tuttiGliUtenti = await DataService().loadAllData();

      if(!mounted) return;
      Navigator.pop(context);

      final emailInserita = _emailController.text.trim();
      final passwordInserita = _passwordController.text.trim();

      Utente? utenteTrovato;
      for(Utente u in tuttiGliUtenti){
        if(u.email == emailInserita && u.password == passwordInserita){
          utenteTrovato = u;
          break;
        }
      }

      if(utenteTrovato != null){
        Sessione().utenteCorrente = utenteTrovato;

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email_salvata', utenteTrovato.email);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()),);
      }else{
        _mostraErrore("Credenziali non valide. Riprova");
      }
    }catch (e){
      if(!mounted) return;
      Navigator.pop(context);
      _mostraErrore("Errore di connessione o nel database");
    }
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