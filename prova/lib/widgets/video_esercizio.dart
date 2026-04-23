import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
    _controller = VideoPlayerController.asset(widget.url)
    ..initialize().then((_){
      
      _controller.setVolume(0);
      
      setState(() {});
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
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}