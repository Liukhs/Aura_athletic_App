import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void mostraVideoEsercizio(BuildContext context, String urlEsercizio){
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: VideoEsercizio(url: urlEsercizio)),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CHIUDI"),
            )
          ],
        ),
      )
    );
  }
class VideoEsercizio extends StatefulWidget {
  final String url;
  const VideoEsercizio({super.key, required this.url});

  @override
  State<VideoEsercizio> createState() => _VideoEsercizioState();
}

class _VideoEsercizioState extends State<VideoEsercizio>{
  late VideoPlayerController _controller;

  @override
  void initState(){
    super.initState();
    //_controller = VideoPlayerController.asset(widget.url)
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
    ..initialize().then((_){
      print("Video inizializzato con successo");
      _controller.setLooping(true);
      _controller.setVolume(0);
      _controller.play();
      setState(() {});
    }).catchError((error){
      print("ERRORE FATALE CARICAMENTO VIDEO: $error");
    });
  }

  @override
  void dispose(){
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }
  
  

  @override
  Widget build(BuildContext context){
    if (!_controller.value.isInitialized) {
    return const Center(child: CircularProgressIndicator());
    }
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}