import 'package:flutter/material.dart';

class MessaggioPalestra {
  final String titolo;
  final String corpo;
  final String data;
  final IconData icona;
  bool enlighted;

  MessaggioPalestra({
    required this.titolo,
    required this.corpo,
    required this.data,
    required this.icona,
    this.enlighted = false
  });
}