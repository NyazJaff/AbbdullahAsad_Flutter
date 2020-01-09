import 'dart:async';
import 'dart:io';

import 'package:abdullah_asad/Helper/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import 'package:abdullah_asad/books/book_detail.dart';

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
                                           GestureDetector(
                                              // When the child is tapped, show a snackbar.
                                              onTap: () {
                                                navigateToDetail(snapshot.data[index]);
//                                            final snackBar = SnackBar(content: Text("Tap"));
//
//                                            Scaffold.of(_).showSnackBar(snackBar);
                                          },
                                            child: Container(
                                              child: CustomListItemTwo(
//                                            thumbnail:  Image.file(
//                                                File("$dir/" + snapshot.data[index].data["imageURL"].substring(snapshot.data[index].data["imageURL"].lastIndexOf("/") + 1))
//                                            ),
                                                thumbnail: Image(image: AssetImage("assets/brand/book_test.png")),
                                                title: 'Flutter 1.0 Launch',
                                                subtitle: snapshot.data[index].data["name"],
                                                author: 'Dash',
                                                publishDate: 'Dec 28',
                                                readDuration: '5 mins',

                                              ),

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




class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo({
    Key key,
    this.thumbnail,
    this.title,
    this.subtitle,
    this.author,
    this.publishDate,
    this.readDuration,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: 0.7,
                child: thumbnail,
              ) ,
            )
            ,
//            Expanded(
//              child: Padding(
//                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Expanded(
//                        flex: 2,
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Text(
//                              '$title',
//                              maxLines: 2,
//                              overflow: TextOverflow.ellipsis,
//                              style: const TextStyle(
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
//                            const Padding(padding: EdgeInsets.only(bottom: 2.0)),
//                            Text(
//                              '$subtitle',
//                              maxLines: 2,
//                              overflow: TextOverflow.ellipsis,
//                              style: const TextStyle(
//                                fontSize: 12.0,
//                                color: Colors.black54,
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                      Expanded(
//                        flex: 1,
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          mainAxisAlignment: MainAxisAlignment.end,
//                          children: <Widget>[
//                            Text(
//                              '$author',
//                              style: const TextStyle(
//                                fontSize: 12.0,
//                                color: Colors.black87,
//                              ),
//                            ),
//                            Text(
//                              '$publishDate · $readDuration ★',
//                              style: const TextStyle(
//                                fontSize: 12.0,
//                                color: Colors.black54,
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ],
//                  )
//              ),
//            )
          ],
        ),
      ),
    );
  }
}