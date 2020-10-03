import 'dart:async';
import 'package:abdullah_asad/Helper/util.dart';
import 'package:flutter/material.dart';
import 'package:abdullah_asad/utilities/layout_helper.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: app_bar(context, widget.title),
        body: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Container(
            decoration: simpleDecorationStyle,
            child: Column(
                children: <Widget>[

                  Text('sdsdssd')
                ]
            ),
          ),
        )
    );
  }
}
