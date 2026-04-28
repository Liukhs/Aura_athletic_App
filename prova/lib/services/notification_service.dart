import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class NotificationService{
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> fineRecupero() async{
    if(await Vibration.hasVibrator() ?? false){
      Vibration.vibrate(pattern: [0, 500, 100, 500]);
    }

    FlutterRingtonePlayer().playNotification(
      volume: 1.0,
      looping: false
    );

  }
}