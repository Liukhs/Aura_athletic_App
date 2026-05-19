class AllenamentoCompletato {
  final String id;
  final String nome;
  final String tempoMinuti;
  final double volume;
  final int bpm;

  AllenamentoCompletato({
    required this.id,
    required this.nome,
    required this.tempoMinuti,
    required this.volume,
    required this.bpm
  });

  factory AllenamentoCompletato.fromMap(Map<String, dynamic> map){
    return AllenamentoCompletato(
      id: map['id'] as String,
      nome: map['titolo_scheda'] as String,
      tempoMinuti: map['durata_secondi'] as String,
      volume: map['volume_totale'] as double,
      bpm: 120
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'titolo_scheda': nome,
      'durata_secondi': tempoMinuti,
      'volume_totale':volume,
      'bpm': bpm
    };
  }
}