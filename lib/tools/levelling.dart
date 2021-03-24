import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class Levelling extends StatefulWidget {
  @override
  _LevellingState createState() => _LevellingState();
}

class _LevellingState extends State<Levelling> {
  YoutubePlayerController _controller;
  void runYoutubeApp() {
    _controller = YoutubePlayerController(
      initialVideoId: 'j8poe2vvD2Q',
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: false,
        autoPlay: false,
        enableKeyboard: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    runYoutubeApp();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: Scaffold(
        body: Container(width: size.width, child: player),
      ),
    );
  }
}
