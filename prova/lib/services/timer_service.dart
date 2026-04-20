import 'dart:async';

class TimerService {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  void start(){
    _stopwatch.start();
  }

  void stop(){
    _stopwatch.stop();
  }

  String get tempoFormattato{
    final durata = _stopwatch.elapsed;
    return "${durata.inMinutes.remainder(60).toString().padLeft(2, '0')}:${durata.inSeconds.remainder(60).toString().padLeft(2, '0')}";
  }
}