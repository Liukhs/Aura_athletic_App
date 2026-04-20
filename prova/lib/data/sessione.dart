import 'package:prova/models/utente.dart';

class Sessione {
  static final Sessione _instance = Sessione._internal();

  factory Sessione() => _instance;
  Sessione._internal();

  Utente? utenteCorrente;
}