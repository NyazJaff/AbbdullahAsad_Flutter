import 'package:abdullah_asad/models/bookmarks_model.dart';
import 'package:flutter/material.dart';
import 'package:abdullah_asad/Helper/util.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:abdullah_asad/models/bookmarks_model.dart';
import 'package:abdullah_asad/models/comments_model.dart';

class BookMarksAndComments extends StatefulWidget{
  BookMarksAndComments({
    Key key,
    this.title,
    this.pdfViewController

  }) : super(key: key);

  final String title;
  PDFViewController pdfViewController;

  @override
  _BookMarksAndCommentsState createState() => _BookMarksAndCommentsState();
}

class _BookMarksAndCommentsState extends State<BookMarksAndComments> {
  List<Bookmark> bookmarks;
  List<Comment> comments;

  @override
  void initState(){
    super.initState();
    bookmarks = List();
    bookmarks.add(Bookmark(book: 2, page: 7));
    bookmarks.add(Bookmark(book: 5, page: 9));
    bookmarks.add(Bookmark(book: 6, page: 2));
    bookmarks.add(Bookmark(book: 8, page: 4));


    comments = List();
    comments.add(Comment(book: 2, page: 7, comment:  "Test Commsadasdas asdasdsad asdsad ent", bookName: "testess adas asdasd adas asdasdas adasteste"));
    comments.add(Comment(book: 2, page: 8, comment:  "Test Comment 2", bookName: "testesteste 1"));
    comments.add(Comment(book: 2, page: 9, comment:  "Test Comment 3", bookName: "test sdsad1"));
  }

  removeBookmark(index){
    setState(() {
      bookmarks.removeAt(index);
    });
  }

  removeComment(index){
    setState(() {
      comments.removeAt(index);
    });
  }


  bookmarkDeleteBG(){
    return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 15.0),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            )
          ],
        )
    );
  }

//  bookmarkViewBG(){
//    return Container(
//        alignment: Alignment.centerRight,
//        padding: EdgeInsets.only(left: 15.0),
//        color: Colors.blue,
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.start,
//          children: <Widget>[
//            Padding(
//              padding: EdgeInsets.only(right: 15),
//              child: Icon(FontAwesomeIcons.chevronCircleRight,
//                color: Colors.white,
//              ),
//            ),
//            Text(
//              "View",
//              style: TextStyle(color: Colors.white),
//            )
//          ],
//        )
//    );
//  }

  Widget bookmarkList(){
    return ListView.builder(
        itemCount: bookmarks.length,
        itemBuilder: (BuildContext context, int index){
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction){
              var comment = bookmarks[index];
              removeBookmark(index);
            },
            background: bookmarkDeleteBG(),
//            secondaryBackground: bookmarkDeleteBG(),
            child: Card(
              child: ListTile(
                  title: Text(bookmarks[index].page.toString()),
                  leading: new Icon(Icons.bookmark, color: UtilColours.APP_BAR,),
                  trailing: new IconButton(icon: Icon(Icons.delete), onPressed: (){
                    removeBookmark(index);
                  }),
                  onTap: () {
                    widget.pdfViewController.setPage(bookmarks[index].page);
                    Navigator.of(context, rootNavigator: true).pop();
                  }
              ),
            ),
          );
        });
  }

  Widget commentList(){
    return ListView.builder(
        itemCount: comments.length,
        itemBuilder: (BuildContext context, int index){
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction){
              var comment = comments[index];
              removeComment(index);
            },
            background: bookmarkDeleteBG(),
//            secondaryBackground: bookmarkDeleteBG(),
            child: Card(
              child: ListTile(
                  title: Text(comments[index].comment.toString()),
                  leading: new Icon(Icons.comment, color: UtilColours.APP_BAR,),
                  subtitle:  Container(
                    child: Column(
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          child:   Text("Book: " + comments[index].bookName.toString()),
                        ),
                        Container(
                          child:   Text("Page: " + comments[index].page.toString()),
                        ),

                      ],
                    ),),

                  trailing: new IconButton(icon: Icon(Icons.delete), onPressed: (){
                    removeComment(index);
                  }),
                  onTap: () {
                    widget.pdfViewController.setPage(comments[index].page);
                    Navigator.of(context, rootNavigator: true).pop();
                  }
              ),
            ),
          );
        });
  }


//  Widget commentList(){
//    return ListView.builder(
//        itemCount: comments.length,
//        padding: EdgeInsets.all(20.0),
//        itemBuilder: (BuildContext context, int index){
//          return Dismissible(
//            key: UniqueKey(),
//            onDismissed: (direction){
//              var comment = comments[index];
//              removeBookmark(index);
//            },
//            background: bookmarkDeleteBG(),
////            secondaryBackground: bookmarkDeleteBG(),
//            child: Card(
//              child: ListTile(
//                  title: Text(comments[index].page.toString()),
//                  leading: new Icon(Icons.bookmark, color: UtilColours.APP_BAR,),
//                  trailing: new Icon(Icons.delete),
//                  onTap: () {
//                    widget.pdfViewController.setPage(comments[index].page);
//                    Navigator.pop(context);
//                  }
//              ),
//            ),
//          );
//        });
//  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp (
        home:  DefaultTabController (
          length: 2,
          child: new Scaffold(
            appBar: AppBar(
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: UtilColours.APP_BAR_NAV_BUTTON),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: UtilColours.APP_BAR,
//          backgroundColor: Color(0x44000000),
              elevation: 0,
              title: Text(widget.title,  style: TextStyle(color: UtilColours.APP_BAR_NAV_BUTTON)),
              bottom: new TabBar(
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(
                      child: Container(
                        child: Text(
                          'Bookmark',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        child: Text(
                          'Comment',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    )
                  ]
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                Container(
                  child:  bookmarkList(),
//                    Column(
//                       children: <Widget>[
//                         IconButton(icon: Icon(Icons.view_list), onPressed: () {
//                           widget.pdfViewController.setPage(5);
//                           Navigator.pop(context);
//                         },),
//                       ],
//                    )
                ),
                Container(
                  child: commentList(),
                )

              ],
            ),
          ),
        ),
        theme: ThemeData(primaryColor: Colors.deepOrange)
    );
  }
}


//class Bookmark extends StatefulWidget {
//  const Bookmark( { Key key}) : super(key:key);
//
//  @override
//  _BookmarkState createState() => _BookmarkState();
//}
//
//class _BookmarkState extends State<Bookmark> {
//  int colorVal = 0xffff5722;
//
//  @override
//  void initState(){
//    super.initState();
//  }
//
//  TabController _tabController;
//  @override
//  Widget build(BuildContext context) {
//    return
//      DefaultTabController (
//        length: 2,
//        child: Scaffold(
//          body: TabBarView(
//            controller: _tabController,
//            children: <Widget>[
//              Container(
//                  child: Text("ddd")
//              ),
//              Container(
//                  child: Text("ddd")
//              )
//
//            ],
//          ),
//        ),
//      );
//  }
//}
//
//
//class Comment extends StatefulWidget {
//  const Comment( { Key key}) : super(key:key);
//
//  @override
//  _CommentState createState() => _CommentState();
//}
//
//class _CommentState extends State<Comment> {
//  int colorVal = 0xffff5722;
//
//  @override
//  void initState(){
//    super.initState();
//  }
//
//  TabController _tabController;
//  @override
//  Widget build(BuildContext context) {
//    return
//      DefaultTabController (
//        length: 2,
//        child: Scaffold(
//          body: TabBarView(
//            controller: _tabController,
//            children: <Widget>[
//              Container(
//                  child: Text("ddd")
//              ),
//              Container(
//                  child: Text("ddd")
//              )
//            ],
//          ),
//        ),
//      );
//  }
//}