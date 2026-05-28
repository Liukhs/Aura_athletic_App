import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class NotificationService{
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> fineRecupero() async{
    if(await Vibration.hasVibrator() ?? false){
      Vibration.vibrate(pattern: [0, 500, 100, 500]);
    }

    await _player.setAudioContext(AudioContext(
      android: const AudioContextAndroid(
        usageType: AndroidUsageType.media,
        contentType: AndroidContentType.music,
        audioFocus: AndroidAudioFocus.gainTransientMayDuck
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: {
          AVAudioSessionOptions.duckOthers,
          AVAudioSessionOptions.interruptSpokenAudioAndMixWithOthers
        },
      ),
    ));

    await _player.play(AssetSource('sounds/ui-alarm-alert-bells-ra-music-1-00-02.mp3'));
    

  }
}