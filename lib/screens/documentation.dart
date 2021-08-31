import 'package:final_project/documentation/docs.dart';
import 'package:final_project/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Documentation extends StatefulWidget {
  @override
  _DocumentationState createState() => _DocumentationState();
}

class _DocumentationState extends State<Documentation> {
  Widget expansionTile({String title, List<String> children}) {
    return ExpansionTile(
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment(-1, 0),
      title: Text(title),
      children: children.map((e) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 30.0, top: 15, right: 20, bottom: 10),
          child: SelectableText(
            e,
            textAlign: TextAlign.justify,
            textScaleFactor: 1.2,
          ),
        );
      }).toList(),
    );
  }

  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool initialExpanded = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppBar(context),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              expansionTile(title: 'Levelling', children: levelling),
              expansionTile(
                  title: 'Types of Levelling', children: typesOfLevelling),
              expansionTile(
                  title: 'Application of Levelling',
                  children: applicationsOfLevelling),
              expansionTile(title: 'Traversing', children: traversing),
              expansionTile(
                  title: 'Types of Traversing', children: typesOfTraversing),
              expansionTile(
                  title: 'Application of Traversing',
                  children: applicationsOfTraversing),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Learn how to explore the website',
                      style: TextStyle(fontFamily: 'Akaya', fontSize: 22)),
                ),
              ),
              Container(
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: VideoPlayer(_controller),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.play();
        },
      ),
    );
  }
}
