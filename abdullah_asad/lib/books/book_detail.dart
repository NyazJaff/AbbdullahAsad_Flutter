import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:abdullah_asad/books/pdfscreen.dart';
import 'dart:io' as io;

class BookDetail extends StatefulWidget {
  final DocumentSnapshot post;

  BookDetail({this.post});

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {

  String pathPDF = "";
  String corruptedPathPDF = "";

  @override
  void initState(){
    super.initState();

//    fromAsset('assets/pdfs/guide.pdf', 'guide.pdf').then((f) {
//      setState(() {
//        corruptedPathPDF = f.path;
//      });
//    });
//    fromAsset('assets/pdfs/guide.pdf', 'guide.pdf').then((f) {
//      setState(() {
//        pathPDF = f.path;
//      });
//    });

    createFileOfPdfUrl().then((f) {
      setState(() {
        pathPDF = f.path;
        GlobalKey key = GlobalKey();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PDFScreen(path: pathPDF, title: widget.post.data["name"], key: key,)),
        );
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    final url = widget.post.data["pdfURL"];
    final filename = url.substring(url.lastIndexOf("/") + 1);
    String dir = (await getApplicationDocumentsDirectory()).path;

    File file;
    if(io.File(await '$dir/$filename').existsSync() == true){
      file = io.File(await '$dir/$filename');
      print("File Found **************");
    }else{
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);

      file = new File('$dir/$filename');
      await file.writeAsBytes(bytes);
      print("File Download **************");
    }

    return file;
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.data["name"]) ,
      ),
      body: Scaffold(
        body: Center(child: Builder(
          builder: (BuildContext context) {
            return Column(
              children: <Widget>[
                Container(
                  child: ListTile(
                    title: Text(widget.post.data["name"]),
                    subtitle: Text(widget.post.data["name"]),
                  ),
                ),
                RaisedButton(
                    child: Text("Open PDF"),
                    onPressed: () {
                      if (this.pathPDF?.isEmpty == false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PDFScreen(path: pathPDF)),
                        );
                      }
                    }),
              ],
            );
          },
        )),
      ),
    );
  }
}
