import 'dart:async';

import 'package:abdullah_asad/Helper/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:abdullah_asad/books/bookmarks_and_comments.dart';

class PDFScreen extends StatefulWidget {
  final String path;
  final String title;
  int current_page;

  PDFScreen({Key key, this.path, this.title, this.current_page}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver  {
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int pages = 0;
  bool isReady = false;
  String errorMessage = '';

  bool pageBookmarked  = false;
  PDFViewController _pdfViewController;

  final _formKey = GlobalKey<FormState>();
  var isKeyboardOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this); //used for keyboard detection
  }


  @override
  void didChangeMetrics() {
    if(utilIsAndroid(context)){
      final value = MediaQuery.of(context).viewInsets.bottom;
      if (value > 0) {
        if (isKeyboardOpen) {
          _onKeyboardChanged(false);
        }
        isKeyboardOpen = false;
      } else {
        isKeyboardOpen = true;
//        _onKeyboardChanged(true);
      }
    }

  }

  _onKeyboardChanged(bool isVisible) {
    if (isVisible) {
      print("KEYBOARD VISIBLE");
    } else {
      print("KEYBOARD HIDDEN");
      refreshWindow();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: app_bar(context, widget.title),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                  child:PDFView(
                    filePath: widget.path,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: true,
                    pageFling: true,
                    onRender: (_pages) {
                      setState(() {
                        pages = _pages;
                        isReady = true;
                      });
                      if(utilIsAndroid(context)){
                        _pdfViewController.setPage(widget.current_page);
                      }
                    },
                    onError: (error) {
                      setState(() {
                        errorMessage = error.toString();
                      });
                      print(error.toString());
                    },
                    onPageError: (page, error) {
                      setState(() {
                        errorMessage = '$page: ${error.toString()}';
                      });
                      print('$page: ${error.toString()}');
                    },
                    onViewCreated: (PDFViewController pdfViewController) {
                      _controller.complete(pdfViewController);
                      _pdfViewController = pdfViewController;
                    },
                    onPageChanged: (int page, int total) {
                      setState(() => this.pageBookmarked = !pageBookmarked);
                      print('page change: $page/$total');
                    },
                  )
              )
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: Builder(
            builder: (cntx) =>new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(icon: Icon(Icons.share), onPressed: () {
                }),
                IconButton(icon: pageBookmarked ? Icon(Icons.bookmark) :Icon(Icons.bookmark_border) , onPressed: () {
                  setState(() {
                    pageBookmarked = !pageBookmarked;
                  });

                  Scaffold.of(cntx).showSnackBar(SnackBar(
                    content: Text(pageBookmarked? "Bookmarked!" : "Removed Bookmark!"),
                    duration: Duration(seconds: 1),
                  ));

                },),//bookmark
                IconButton(icon: Icon(Icons.add_comment, color: Colors.black), onPressed: () { commentPopup(cntx);},),
                IconButton(icon: Icon(Icons.view_list), onPressed: () {

//                  showGeneralDialog(
//                      barrierColor: Colors.black.withOpacity(0.5),
//                      transitionBuilder: (context, a1, a2, widget) {
//                        return Transform.scale(
//                          scale: a1.value,
//                          child: Opacity(
//                              opacity: a1.value,
//                              child: BookMarksAndComments(
//                                title:  "nnn",
//                                pdfViewController: _pdfViewController,
//
//                              )
//                          ),
//                        );
//                      },
//                      transitionDuration: Duration(milliseconds: 250),
//                      barrierDismissible: true,
//                      barrierLabel: '',
//                      context: context,
//                      pageBuilder: (context, animation1, animation2) {});

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return
                          BookMarksAndComments(
                            title:  widget.title,
                            pdfViewController: _pdfViewController,
                          );
                      });
                },),
              ],
            ),
          )
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  refreshWindow () async {
    GlobalKey key = GlobalKey();
    final current_page_param = await _pdfViewController.getCurrentPage();

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PDFScreen(path: widget.path, title: widget.title, current_page: current_page_param, key: key,)),
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
                          Text(
                            "Add comment to this page",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: UtilColours.APP_BAR,
                                fontFamily: "Tajawal",
                                fontStyle: FontStyle.normal
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 4.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: TextField(
                          controller: myController,
                          decoration: InputDecoration(
                            hintText: "كان بشرية الأمريكي ٣٠, به،",
                            border: InputBorder.none,
                          ),
                          maxLines: 8,
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
                            "Save",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () async {

                          if(myController.text != "" ){
                            Scaffold.of(ctx).showSnackBar(SnackBar(
                              content: Text('Saved! ' + myController.text),
                              duration: Duration(seconds: 2),
                            ));

                          }
                          await Future.delayed(const Duration(seconds: 2), (){
                            Navigator.of(context, rootNavigator: true).pop(myController.text);
                          });

                        },
                      ),

                    ],
                  ),
                )
            ),
          );
        });
  }
}