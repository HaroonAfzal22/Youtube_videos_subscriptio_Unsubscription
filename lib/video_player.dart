import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class videoPlayerScreen extends StatefulWidget {
  const videoPlayerScreen({ Key? key }) : super(key: key);

  @override
  State<videoPlayerScreen> createState() => _videoPlayerScreenState();
}

class _videoPlayerScreenState extends State<videoPlayerScreen> {
 late YoutubePlayerController _controller;
  bool _isPlayerReady=false;

  @override
  // void initState() {
  //   super.initState();
  //   _isPlayerReady = false;
  //   _controller = YoutubePlayerController(
  //     initialVideoId: widget.,
  //     flags: YoutubePlayerFlags(
  //       mute: false,
  //       autoPlay: true,
  //     ),
  //   )..addListener(_listener);
  // }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      //
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        // title: Text(widget.videoItem.video.title),
      ),
      body: Container(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {
            print('Player is ready.');
            _isPlayerReady = true;
          },
        ),
      ),
    );
  }
}