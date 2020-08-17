import 'dart:async';
import 'package:abdullah_asad/Helper/util.dart';
import 'package:abdullah_asad/models/epic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abdullah_asad/utilities/layout_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

import 'Helper/db_helper.dart';



class Mp3Player extends StatefulWidget {
  Mp3Player({
    Key key,
    this.title,
  }) : super(key: key);


  final String title;
  @override
  _Mp3PlayerState createState() => _Mp3PlayerState();
}

class _Mp3PlayerState extends State<Mp3Player> {
  var db = new DatabaseHelper();
  AudioPlayer audioPlayer = AudioPlayer(playerId: 'my_unique_playerId');
  String status = 'hidden';


  @override
  void initState() {
    super.initState();
  }

  Future<void> hide() async {
//      await MediaNotification.hide();
//      setState(() => status = 'hidden');
  }

  Future<void> show(title, author) async {
//    print("test");
//      await MediaNotification.show(title: title, author: author);
//      setState(() => status = 'play');
  }

  play() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    int result = await audioPlayer.play('$dir/testaudio.mp3', isLocal: true);
    if (result == 1) {
      print(result);
    }
  }

  pause() async {
    int result = await audioPlayer.pause();
  }

  stop() async {
    int result = await audioPlayer.stop();
  }

  resume() async {
    int result = await audioPlayer.resume();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: app_bar(context, widget.title),
        body:Scaffold(
            body: Column (
                children: <Widget>[
                  appBgImage(),
                  new Padding(
                    padding: const EdgeInsets.all(10.0),
                  ),
                  RaisedButton(onPressed: play, child: const Text('play')),
                  RaisedButton(onPressed: pause, child: const Text('pause')),
                  RaisedButton(onPressed: stop, child: const Text('stop')),
                  RaisedButton(onPressed: resume, child: const Text('resume')),
//                  FlatButton(
//                    child: Text('Show notification'),
//                    onPressed: () => show('Title', 'Song author'),
//                  ),
//                  FlatButton(
//                    child: Text('Update notification'),
//                    onPressed: () => show('New title', 'New song author'),
//                  ),
//                  FlatButton(
//                    child: Text('Hide notification'),
//                    onPressed: hide,
//                  ),
//                  Text('Status: ' + status)
                ]
            )
        )
    );
  }
}
