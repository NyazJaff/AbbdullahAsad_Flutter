import 'dart:async';
import 'package:abdullah_asad/Helper/util.dart';
import 'package:abdullah_asad/models/epic.dart';
import 'package:abdullah_asad/mp3_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abdullah_asad/utilities/layout_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Helper/db_helper.dart';


class QandA extends StatefulWidget {
  QandA({
    Key key,
    this.title,
    this.parentId,
  }) : super(key: key);


  final String title;
  final int parentId;
  @override
  _QandAState createState() => _QandAState();
}

class _QandAState extends State<QandA> {
  var db = new DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    db.deleteEpic().then((value) {setState(() {});});
    pullQandA();
//    migrateSpeeches();
  }

  pullQandA() async {
      int largestId = await db.largestEpicFirebaseId(DatabaseHelper.QUESTION_AND_ANSWER);
      bool foundRecord = false;
      QuerySnapshot document = await Firestore.instance
          .collection("QuestionAndAnswer")
          .where('id', isGreaterThan: largestId)
          .getDocuments();
      document.documents.forEach((document) async {
        await db.saveEpic(db.formatEpicForSave(document, DatabaseHelper.QUESTION_AND_ANSWER));
        foundRecord = true;
      });
      if(foundRecord){
        setState(() {});
      }
  }

  migrateSpeeches() async{
    QuerySnapshot document = await Firestore.instance
        .collection("Lecture")
        .where('fragmentName', isEqualTo: "speech")
        .getDocuments();
    document.documents.forEach((document) async {
      print(document);
      DocumentReference ref = await Firestore.instance.collection("Speech")
          .add({
        'id': document['id'],
        'mp3URL': document['mp3URL'],
        'name': document['name'],
        'parentId': document['parentId'],
        'pdfURL': document['pdfURL'],
        'type': document['type'],
      });
      print(ref.documentID);

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        extendBodyBehindAppBar: true,
//        backgroundColor: Colors.red,
        appBar: app_bar(context, widget.title),
        body:Scaffold(
            body: Stack (
                children: <Widget>[
                  appBgImage(),
                  new Padding(
                    padding: const EdgeInsets.all(10.0),
                  ),
                  FutureBuilder(
                      future: db.getQandA(widget.parentId),
                      builder: (_, listQandA) {
                        if (listQandA.connectionState == ConnectionState.waiting) {
                          return Center(
                              child: SpinKitChasingDots(
                                color: UtilColours.APP_BAR,
                                size: 50.0,
                              )
                          );
                        } else {
                          return   new Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.separated(
                                itemCount: listQandA.data.length,
                                itemBuilder: (BuildContext context, int index){
                                  var qAndA = listQandA.data[index];
                                  print(qAndA.toString());
                                  return ListTile(
                                      title: Text(qAndA.title.toString(), style: arabicTxtStyle(paramSize: 18.0)),
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
                                        print(qAndA.firebaseId);
                                        GlobalKey key = GlobalKey();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              qAndA.type == "RECORD" ?
                                              Mp3Player(title: qAndA.title, key: key) :
                                              QandA(title: qAndA.title, parentId: qAndA.firebaseId, key: key)
                                          ),
                                        );
                                      }
                                  );
                                }, separatorBuilder: (BuildContext context, int index) {
                              return Divider();
                            },)
                          );
                        }
                      })
                ]
            )
        )
    );
  }
}
