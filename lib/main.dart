import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:stube/music.dart';
import 'package:stube/video.dart';

AudioPlayer _audioPlayer = AudioPlayer();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List songs = [];
  bool isloading = false;
  bool issearching = false;
  bool isok = false;
  String searchq = "";

  @override
  void initState() {
    super.initState();

    fetchSongs();
  }

  // void go_to_music_page(BuildContext context){
  //   Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => 
  //     new MusicApp()
  //   ));
  // }

  fetchSongs() async {
    // var REQURL = "https://youtube-music-shibam.herokuapp.com/youtube-data/songs";
    var response = await http.get(
        Uri.https('YOUR API PARAMETERS', 'YOUR API PARAMETERS'));
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        songs = items;
        isok = true;
      });
    } else {
      setState(() {
        songs = [];
        isok = false;
      });
    }
  }

  getSearchSongs() async {
    var response = await http.get(Uri.https(
        'API PARAMETER', 'API PARAMETER'));
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        songs = items;
        isok = true;
      });
    } else {
      setState(() {
        songs = [];
        isok = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: !issearching
            ? Text("Stube")
            : TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintText: "search songs",
                  hintStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (text) {
                  setState(() {
                    searchq = text;
                  });
                },
              ),
        actions: <Widget>[
          issearching
              ? IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    getSearchSongs();
                    setState(() {
                      this.issearching = !this.issearching;
                      isok = false;
                    });
                  })
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.issearching = !this.issearching;
                    });
                  })
        ],
        backgroundColor: Colors.blue[900],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    List items = ["1", "2"];
    if (isok == true) {
      return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (BuildContext context, int index) {
        return getCard(index);
      },
    );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget getCard(index) {
    var data = songs[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => 
        new VideoPlayer(data)
      ));
      },
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Column(
            children: [
              Row(
                children: <Widget>[
                  Container(
                    width: 300,
                    height: 180,
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(20 / 2),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                songs[index]['thumbnails'][0]['url']))),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(60 / 2),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(songs[index]['channel']
                                ['thumbnails'][0]['url']))),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    songs[index]['accessibility']['title'],
                    style: TextStyle(fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ))
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
