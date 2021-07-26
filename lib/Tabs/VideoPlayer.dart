import 'package:flutter/material.dart';
import 'package:socialmedia/Tabs/VideoItem.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Flutter Video Player Demo'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          VideoItems(
            videoPlayerController: VideoPlayerController.network(
                'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4'),
            looping: false,
            autoplay: true,
          ),
        ],
      ),
    );
  }
}
