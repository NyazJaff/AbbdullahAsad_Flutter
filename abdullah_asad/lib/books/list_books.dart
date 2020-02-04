import 'dart:async';
import 'dart:io';

import 'package:abdullah_asad/Helper/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import 'package:abdullah_asad/books/book_detail.dart';
import 'package:abdullah_asad/books/pdfscreen.dart';

class ListBooks extends StatefulWidget {
  @override
  _ListBooksState createState() => _ListBooksState();
}

class _ListBooksState extends State<ListBooks> {

  Future _data;
  String dir = "";

  Future<File> createFileOfUrl(String url) async {
    final filename = url.substring(url.lastIndexOf("/") + 1);
    this.dir = (await getApplicationDocumentsDirectory()).path;

    File file;
    if(File(await '$dir/$filename').existsSync() == true){
      file = File(await '$dir/$filename');
    }else{
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);

      file = new File('$dir/$filename');
      await file.writeAsBytes(bytes);
    }
    setState(() {});

    return file;
  }

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("BookItem").getDocuments();
    return qn.documents;
  }


  getPostsF() async {
    QuerySnapshot document = await Firestore.instance.collection("BookItem").getDocuments();
    document.documents.forEach((document){
      createFileOfUrl(document['imageURL']);
//      print(document['name']);
    });
  }


  Future<String> getGroupInfo(String groupId) async {
    var document =
    Firestore.instance.collection("group").document(groupId).get();
    return await document.then((doc) {
      return doc["name"];
    });

  }

  navigateToDetail(DocumentSnapshot post){
    Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetail(post: post,)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _data = getPosts();
    print(getPostsF());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        extendBodyBehindAppBar: true,
//        backgroundColor: Colors.red,
        appBar: app_bar(context, "Books"),
        body:Scaffold(
            body: Stack (
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/brand/bg_tran.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    child: FutureBuilder(
                        future:  _data,
                        builder: (_, snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Center (
                              child: Text ("Loading ... "),
                            );
                          } else{
                            return
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 30.0),
                                child: CustomScrollView(
                                  slivers: <Widget>[
                                    SliverGrid (
                                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 300.0,
                                          mainAxisSpacing: 0,
                                          crossAxisSpacing: 0.0,
                                          childAspectRatio: 0.80
                                      ),
                                      delegate: SliverChildBuilderDelegate(
                                            (_, int index) {
                                          return
                                            Container(
                                              child: CustomListItemTwo(
//                                            thumbnail:  Image.file(
//                                                File("$dir/" + snapshot.data[index].data["imageURL"].substring(snapshot.data[index].data["imageURL"].lastIndexOf("/") + 1))
//                                            ),
                                                thumbnail: AssetImage("assets/brand/book_test.png"),
                                                pdfURL: snapshot.data[index]["pdfURL"],
                                                title: snapshot.data[index].data["name"],

                                              ),

                                            );
                                        },
                                        childCount: snapshot.data.length,
                                      ),
                                    ),
                                  ],
                                ),
                              );

                          }
                        }),
                  )
                ]
            )
        )
    );
  }
}



class CustomListItemTwo extends StatefulWidget {
  CustomListItemTwo({
    Key key,
    this.thumbnail,
    this.pdfURL,
    this.title,
  }) : super(key: key);

  final ImageProvider thumbnail;
  final String pdfURL;
  final String title;

  @override
  _CustomListItemTwoState createState() => _CustomListItemTwoState();
}

class _CustomListItemTwoState extends State<CustomListItemTwo> {

  pdfFileDownload(){
    showToast(context, "Downloading!");
    createFileOfPdfUrl(widget.pdfURL).then((f) {
      if (f.path != null) {
        showToast(context,
            "File is downloaded. Ready to open!");
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      child: SizedBox(
          child: InkWell(
            child: Container(
                padding: new EdgeInsets.only(
                    left: 15.0, bottom: 8.0, right: 16.0),
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: widget.thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
                child: new Stack(
                  children: <Widget>[
                    FutureBuilder(
                      builder: (context, exists) {
                        if (exists.connectionState == ConnectionState.done &&
                            exists.data == null) {
                          return Positioned(
                              right: 0,
                              left: 0,
                              bottom: 0.0,
                              child: RaisedButton.icon(
                                onPressed: () {
                                  pdfFileDownload();
                                },
                                icon: Icon(
                                    Icons.file_download,
                                    color: UtilColours.APP_BAR),
                                label: Text("Download"),
                                color: UtilColours.APP_BAR_NAV_BUTTON,
                              )
                          );
                        }
                        return Container();
                      },
                      future: doesUrlFileExits(context, widget.pdfURL),
                    ),

                  ],
                )

            ),
            onTap: () {
              doesUrlFileExits(context, widget.pdfURL).then((exists) {
                if (exists != null && exists.path != null) {
                  print("image clik");
                  GlobalKey key = GlobalKey();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PDFScreen(
                              path: exists.path,
                              title: widget.title,
                              current_page: 10,
                              key: key,)),
                  );
                } else {
                  commentPopup(context);
                }
              });
            },
          )
      ),
    );
  }

  commentPopup(ctx) {
    final myController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
                width: 300.0,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20),
                        child: Container (
//                      width: MediaQuery.of(context).size.width * 0.55,
//                        width: 20,
                          height: MediaQuery.of(context).size.height * 0.22,
                          child: Align (
                            child: Image (
                              image: AssetImage("assets/brand/book_test.png"),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: UtilColours.APP_BAR,
                            fontFamily: "Tajawal",
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 4.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "أسر لم تُصب لهيمنة الإتحاد, تكتيكاً وبالرغم السيطرة دار أي. وبعض أساسي لإنعدام تم تلك, عل عدد أدنى قبضتهم, لكل وجزر الضروري لم. لكل يذكر السادس أفريقيا في, أما أم جدول اوروبا. فقد ما لفشل قامت قُدُماً, ضرب مع صفحة بالرّد. موالية الخطّة الولايات لم دنو, أخذ تم مارد إحكام لإعادة. كان بشرية الأمريكي ٣٠, به، بخطوط المارق شواطيء ثم.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15.0,
                                color: UtilColours.APP_BAR,
                                fontFamily: "Tajawal",
                                fontStyle: FontStyle.normal
                            ),
                          ),
                        ),
                      ),

                      InkWell(
                        child: Container(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            color: UtilColours.SAVE_BUTTON,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0)),
                          ),
                          child: Text(
                            "Download",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () async {
                          Navigator.of(context, rootNavigator: true).pop();
                          pdfFileDownload();
                        },
                      ),

                    ],
                  ),
                )
            ),
          );
        });
  }

  openBookDetails(Widget body) {



  }

}