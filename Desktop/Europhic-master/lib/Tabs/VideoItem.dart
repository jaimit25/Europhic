import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// https://medium.com/flutterdevs/video-player-in-flutter-22202be72d6e
class VideoItems extends StatefulWidget {
  VideoPlayerController videoPlayerController;
  bool looping;
  bool autoplay;

  VideoItems({
    @required this.videoPlayerController,
    this.looping,
    this.autoplay,
    Key key,
  }) : super(key: key);

  @override
  _VideoItemsState createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {
  var _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      // aspectRatio: 5 / 8,
      // aspectRatio: 0.95,
      aspectRatio: 0.8,
      showControls: false,
      // allowFullScreen: false,
      // allowMuting: false,
      autoInitialize: true,
      autoPlay: widget.autoplay,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("clicked pause button");
        // widget.videoPlayerController.pause();
        widget.videoPlayerController.pause();
      },
      child: Container(
        height: 400,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        // color: Colors.green,
        // padding: const EdgeInsets.all(8.0),
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
    // _chewieController.pause();
  }
}
