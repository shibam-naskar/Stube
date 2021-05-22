import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';




class VideoPlayer extends StatefulWidget {
  VideoPlayer(this.data) : super();
  final data;
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  String videoURL = "https://www.youtube.com/watch?v=vVQp_yXtH7E";
  YoutubePlayerController mYoutubePlayerController;

  @override
  void initState() {
    super.initState();
    mYoutubePlayerController =
        YoutubePlayerController(initialVideoId: YoutubePlayer.convertUrlToId(widget.data['link']), flags: const YoutubePlayerFlags(autoPlay: true, mute: false));
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: mYoutubePlayerController),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Stube"),
            backgroundColor: Colors.blue[900],
          ),
          body: Column(
            children: [
              Container(
                child: player,
              ),
              Container(
                child: Row(
                  children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(60 / 2),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(widget.data['channel']['thumbnails'][0]['url']))),
                    ),
                  ),
                  Text(widget.data['channel']['name'],style: TextStyle(fontSize: 10),)
                  ],
                  
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Devloped By SHIBAM NASKAR",style: TextStyle(fontSize: 10),)
                  ],
                ),
              )
              
            ],
          ),
        );
      },
    );
  }
}