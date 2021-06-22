import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieVideoPlayerContainer extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoPlay;
  var aspectRatio;
  final id;
  ChewieVideoPlayerContainer(
      {this.videoPlayerController,
      this.looping,
      this.autoPlay,
      this.aspectRatio,
      this.id});

  @override
  _ChewieVideoPlayerState createState() => _ChewieVideoPlayerState();
}

class _ChewieVideoPlayerState extends State<ChewieVideoPlayerContainer> {
  ChewieController _chewieController;

  @override
  void didUpdateWidget(ChewieVideoPlayerContainer oldWidget) {
    _initializeChewiePlayer();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _initializeChewiePlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  _initializeChewiePlayer() async {
    if (widget.videoPlayerController == null) {
      return;
    }
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: widget.aspectRatio == null ? 3 / 2 : widget.aspectRatio,
        looping: false,
        autoInitialize: true,
        autoPlay: widget.autoPlay != null ? widget.autoPlay : true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              "",
              textScaleFactor: 1.0,
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }
}
