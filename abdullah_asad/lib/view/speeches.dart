import 'dart:async';
import 'package:abdullah_asad/Helper/util.dart';
import 'package:abdullah_asad/models/epic.dart';
import 'package:abdullah_asad/mp3_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abdullah_asad/utilities/layout_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Helper/db_helper.dart';

class Speeches extends StatefulWidget {
  Speeches({
    Key key,
    this.title,
    this.parentId,
  }) : super(key: key);


  final String title;
  final int parentId;

  @override
  _SpeechesState createState() => _SpeechesState();
}

class _SpeechesState extends State<Speeches> {
  var db = new DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pullSpeeches();
  }

  List<Epic> records = [];

  pullSpeeches() async {
    bool recordsFound = false;
      QuerySnapshot document = await Firestore.instance
          .collection("Speech")
          .where('parentId', isEqualTo: widget.parentId)
          .getDocuments();
      document.documents.forEach((document) async {
        print(document);
        recordsFound = true;
        records.add(db.formatEpicForSave(document, DatabaseHelper.LECTURES));
      });
      if(recordsFound){
      setState(() {});
      }
      return records;
  }

  currentCustomers(){
    List<dynamic> textList = [{"name": "nyaz"}, {"name": "aras"}, {"name": "zaida"}] ;
    return Container(
        child: ListView.separated (
          itemCount: textList.length,
          itemBuilder: (BuildContext context, int index){
            var record = textList[index];
            return ListTile(
                title: Text(record['name']),
                subtitle:  Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        child: Text("Page: ".toString()),
                      ),
                    ],
                  ),),
                onTap: () {
                  //Navigator.pushNamed(context, '/login');
                  print('sss');
                }
            );
          }, separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: app_bar(context, widget.title),
        body:Stack (
            children: <Widget>[
              appBgImage(),
              currentCustomers()
            ]
        )
    );
  }
}
