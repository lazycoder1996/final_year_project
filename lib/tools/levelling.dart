import 'package:final_project/utils/widgets.dart';
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

  TextOverflow textOverflow = TextOverflow.ellipsis;

  @override
  void initState() {
    super.initState();
    runYoutubeApp();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppBar(),
      body: SingleChildScrollView(
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'LEVELLING IN SURVEYING',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        fontFamily: 'Akaya'),
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Watch Videos',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          SizedBox(width: 20),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(Icons.ondemand_video_rounded),
                          )
                        ],
                      ))
                ],
              ),
            ),
            Container(
              height: 550,
              alignment: Alignment.center,
              child: Image.asset(
                'images/girl_with_level.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                // height: 500,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                        child: Text(
                          'Contents',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                        child: Text(
                          'Defintion',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                        child: Text(
                          'Types of level',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                        child: Text(
                          'The Reticule Diaphragm',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                        child: Text(
                          'Reading staffs',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                        child: Text(
                          'Holding staffs',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: Container(
            //       height: 30, width: size.width, child: Text('hello')),
            // ),
          ],
        ),
      )),
    );
    // const player = YoutubePlayerIFrame();
    // return YoutubePlayerControllerProvider(
    //   controller: _controller,
    //   child: Scaffold(
    //     body: Container(width: size.width, child: player),
    //   ),
    // );
  }
}
