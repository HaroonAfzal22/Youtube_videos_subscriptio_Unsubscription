import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class PlayerScren extends StatefulWidget {
   PlayerScren({required this.VideoId,required this.VideoTitle});
   String VideoId;
   String  VideoTitle;

  @override
  State<PlayerScren> createState() => _PlayerScrenState();
}

class _PlayerScrenState extends State<PlayerScren> {

 late  YoutubePlayerController _controller;
  late bool _isPlayerReady;

  @override
  void initState() {
    super.initState();
    _isPlayerReady = false;
    _controller = YoutubePlayerController(
      initialVideoId: widget.VideoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
      // ..addListener(_listener);
  }

  // void _listener() {
  //   if (_isPlayerReady && mounted && !_controller!.value.isFullScreen) {
  //     //
  //   }
  // }

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.VideoTitle),
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
