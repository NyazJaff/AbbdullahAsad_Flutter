import 'dart:io';
import 'package:abdullah_asad/Helper/db_helper.dart';
import 'package:abdullah_asad/Helper/util.dart';
import 'package:abdullah_asad/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:abdullah_asad/books/book_detail.dart';
import 'package:abdullah_asad/books/pdfscreen.dart';
import 'package:abdullah_asad/utilities/layout_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ListBooks extends StatefulWidget {
  @override
  _ListBooksState createState() => _ListBooksState();
}

class _ListBooksState extends State<ListBooks> {
  String dir = "";
  var db = new DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    pullBooks();
    getSystemPath();
//    db.deleteBook();
    super.initState();
  }

  pullBooks() async {
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

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BookDetail(
                  post: post,
                )));
  }

  getSystemPath() async {
    this.dir = (await getApplicationDocumentsDirectory()).path;
    print(this.dir);
  }

//  Used to find the file on users device
  getFilePathBasedOnUrl(url) {
    var path = "$dir/" + url.substring(url.lastIndexOf("/") + 1);
    if(File(path).existsSync() == true){
      return path;
    }else{
      createFileOfUrl(url).then((value) {
        setState(() {
        });
      });
    }
    return path;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        extendBodyBehindAppBar: true,
//        backgroundColor: Colors.red,
        appBar: app_bar(context, "Books"),
        body: Scaffold(
            body: Stack(children: <Widget>[
          appBgImage(),
          Container(
            child: FutureBuilder(
                future: db.books(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitChasingDots(
                        color: UtilColours.APP_BAR,
                        size: 50.0,
                      )
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300.0,
                                    mainAxisSpacing: 0,
                                    crossAxisSpacing: 0.0,
                                    childAspectRatio: 0.80),
                            delegate: SliverChildBuilderDelegate(
                              (_, int index) {
                                return Container(
                                  child: BookListAdapter(
//                                            thumbnail:  Image.file(
//                                                File("$dir/" + snapshot.data[index].data["imageURL"].substring(snapshot.data[index].data["imageURL"].lastIndexOf("/") + 1))
//                                            ),
                                    thumbnail: File(getFilePathBasedOnUrl(
                                        snapshot.data[index].imageURL)),
                                    imageURL: snapshot.data[index].imageURL,
                                    pdfURL: snapshot.data[index].pdfURL,
                                    name: snapshot.data[index].name,
                                    description:
                                        snapshot.data[index].description,
                                    book: snapshot.data[index]
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
        ])));
  }
}

class BookListAdapter extends StatefulWidget {
  BookListAdapter({
    Key key,
    this.thumbnail,
    this.imageURL,
    this.pdfURL,
    this.name,
    this.description,
    this.book
  }) : super(key: key);

  final File thumbnail;
  final String imageURL;
  final String pdfURL;
  final String name;
  final String description;
  final Book book;

  @override
  _BookListAdapterState createState() => _BookListAdapterState();
}

class _BookListAdapterState extends State<BookListAdapter> {
  pdfFileDownload() {
    showToast(context, "Downloading!");
    createFileOfUrl(widget.pdfURL).then((f) {
      if (f.path != null) {
        showToast(context, "File is downloaded. Ready to open!");
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
            padding: new EdgeInsets.only(left: 15.0, bottom: 8.0, right: 16.0),
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: FileImage(widget.thumbnail),
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
                            icon: Icon(Icons.file_download,
                                color: UtilColours.APP_BAR),
                            label: Text("Download"),
                            color: UtilColours.APP_BAR_NAV_BUTTON,
                          ));
                    }
                    return Container();
                  },
                  future: doesUrlFileExits(context, widget.pdfURL),
                ),
              ],
            )),
        onTap: () {
          doesUrlFileExits(context, widget.pdfURL).then((exists) {
            if (exists != null && exists.path != null) {
              GlobalKey key = GlobalKey();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PDFScreen(
                          path: exists.path,
                          title: widget.name,
                          currentPage: 10,
                          bookId: widget.book.id,
                          key: key,
                        )),
              );
            } else {
              bookInfoPopup(context);
            }
          });
        },
      )),
    );
  }

  bookInfoPopup(ctx) {
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
                        children: <Widget>[],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20),
                        child: Container(
//                      width: MediaQuery.of(context).size.width * 0.55,
//                        width: 20,
                          height: MediaQuery.of(context).size.height * 0.22,
                          child: Align(
                            child: Image(
                              image: FileImage(widget.thumbnail),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(widget.name,
                            textAlign: TextAlign.center,
                            style: arabicTxtStyle()),
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
                              widget.description != null
                                  ? widget.description
                                  : "",
                              textAlign: TextAlign.center,
                              style: arabicTxtStyle(paramSize: 15)),
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
                            "Download شواطي",
                            style: arabicTxtStyle(
                                paramSize: 17, paramColour: Colors.white),
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
                )),
          );
        });
  }
}
