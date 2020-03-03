import 'dart:async';
import 'package:abdullah_asad/Helper/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abdullah_asad/layout_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Helper/db_helper.dart';


class QuestionAndAnswer extends StatefulWidget {
  QuestionAndAnswer({
    Key key,
    this.title,
    this.parentId,
  }) : super(key: key);


  final String title;
  final int parentId;
  @override
  _QuestionAndAnswerState createState() => _QuestionAndAnswerState();
}

class _QuestionAndAnswerState extends State<QuestionAndAnswer> {
  var db = new DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pullQandA();
  }

  pullQandA() async{
      int largestId = await db.largestBookId();
      bool foundRecord = false;
      QuerySnapshot document = await Firestore.instance
          .collection("BookItem")
          .where('id', isGreaterThan: largestId)
          .getDocuments();
      document.documents.forEach((document) async {
        await db.saveBook(new Book(
            id: document['id'],
            name: document['name'],
            description: document['description'],
            imageURL: document['imageURL'],
            pdfURL: document['pdfURL']));
        createFileOfUrl(document['imageURL']).then((value) {
          setState(() {});
        });
        if (foundRecord == false) {
          foundRecord = true;
        }
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
                      future: db.getBookmarksOrComments(1,DatabaseHelper.COMMENT),
                      builder: (_, comments) {
                        if (comments.connectionState == ConnectionState.waiting) {
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
                                itemCount: comments.data.length,
                                itemBuilder: (BuildContext context, int index){
                                  var comment = comments.data[index];
                                  return ListTile(
                                      title: Text(comment.comment.toString(), style: arabicTxtStyle(paramSize: 18.0)),
                                      leading: new Icon(Icons.comment, color: UtilColours.APP_BAR,),
                                      subtitle:  Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Container(
                                              child:   Text("Page: " + (comment.pageIndex + 1).toString(), style: arabicTxtStyle(paramSize: 18.0)),
                                            ),

                                          ],
                                        ),),

                                      trailing: new IconButton(icon: Icon(Icons.delete), onPressed: (){
                                        print("todo");
                                      }),
                                      onTap: () {
                                        GlobalKey key = GlobalKey();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  QuestionAndAnswer(title: "testsss", parentId: 0, key: key,)),
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
