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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: app_bar(context, widget.title),
        body:Scaffold(
            body: Stack (
                children: <Widget>[
                  appBgImage(),
                  new Padding(
                    padding: const EdgeInsets.all(10.0),
                  ),
                  records.length > 0
                  ? ListView.separated(
                    itemCount: records.length,
                    itemBuilder: (BuildContext context, int index){
                      var qAndA = records[index];
                      print(qAndA.toString());
                      return
                        ListTile(
                            title: Text(qAndA.name.toString(), style: arabicTxtStyle(paramSize: 18.0)),
                            leading: new Icon(qAndA.type == "RECORD" ? Icons.description : Icons.menu, color: UtilColours.APP_BAR,),
                            subtitle:  Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
//                                              child: Text("Page: ".toString(), style: arabicTxtStyle(paramSize: 18.0)),
                                  ),

                                ],
                              ),),
//                                      trailing: new IconButton(icon: Icon(Icons.delete), onPressed: (){
//                                      }),
                            onTap: () {
                              GlobalKey key = GlobalKey();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    qAndA.type == "RECORD" ?
                                    Mp3Player(title: qAndA.name, key: key) :
                                    Speeches(title: qAndA.name, parentId: qAndA.firebaseId, key: key)
                                ),
                              );
                            }
                        );
                    }, separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },)
                  :Container(
                      child: Center(
                          child: SpinKitChasingDots(
                            color: UtilColours.APP_BAR,
                            size: 50.0,
                          )
                      )
                  )
                ]
            )
        )
    );
  }
}
