import 'package:abdullah_asad/utilities/layout_helper.dart';
import 'package:flutter/material.dart';
import 'package:abdullah_asad/Helper/util.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:abdullah_asad/models/comments_model.dart';
import 'package:abdullah_asad/Helper/db_helper.dart';
import 'package:abdullah_asad/utilities/chasing_dots.dart';
class BookmarksAndComments extends StatefulWidget{
  BookmarksAndComments({
    Key key,
    this.title,
    this.bookId,
    this.pdfViewController

  }) : super(key: key);

  final String title;
  final int bookId;
  final PDFViewController pdfViewController;

  @override
  _BookmarksAndCommentsState createState() => _BookmarksAndCommentsState();
}

class _BookmarksAndCommentsState extends State<BookmarksAndComments> {
//  List<CommentAndBookmark> bookmarks;
  List<Comment> comments;
  var db = new DatabaseHelper();

  @override
  void initState(){
    super.initState();


//     db.getBookmarksOrComments(widget.bookId,DatabaseHelper.BOOKMARK).then((value) {
//       bookmarks = value;
//    });
//    bookmarks.add(Bookmark(book: 2, page: 7));
//    bookmarks.add(Bookmark(book: 5, page: 9));
//    bookmarks.add(Bookmark(book: 6, page: 2));
//    bookmarks.add(Bookmark(book: 8, page: 4));


    comments = List();
    comments.add(Comment(book: 2, page: 7, comment:  "هذا اختبار asdasdsad asdsad ent", bookName: "testess adas asdasd adas asdasdas هذا اختبار"));
    comments.add(Comment(book: 2, page: 8, comment:  "هذا اختبار Test Comment 2", bookName: "testesteste 1 هذا اختبار"));
    comments.add(Comment(book: 2, page: 9, comment:  "Test Comment 3 هذا اختبار", bookName: "test sdsad1 هذا اختبار"));
  }

  removeBookmark(index, pageIndex, type){
    db.deleteCommentOrBookmark(widget.bookId ,pageIndex, type).then((value) {
      setState(() {
//        bookmarks.removeAt(index);
      });
    });

  }

  removeComment(index, pageIndex, type){
    db.deleteCommentOrBookmark(widget.bookId, pageIndex, type);
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
    return FutureBuilder(
        future: db.getBookmarksOrComments(widget.bookId,DatabaseHelper.BOOKMARK),
        builder: (_, bookmarks) {
          if (bookmarks.connectionState == ConnectionState.waiting) {
            return Center(
                child: SpinKitChasingDots(
                  color: UtilColours.APP_BAR,
                  size: 50.0,
                )
            );
          } else {
            return ListView.builder(
                itemCount: bookmarks.data.length,
                itemBuilder: (BuildContext context, int index){
                  var bookmark = bookmarks.data[index];
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction){
                      removeBookmark(index, bookmark.pageIndex, DatabaseHelper.BOOKMARK );
                    },
                    background: bookmarkDeleteBG(),
//            secondaryBackground: bookmarkDeleteBG(),
                    child: Card(
                      child: ListTile(
                          title: Text((bookmark.pageIndex + 1).toString(), style: arabicTxtStyle(),),
                          leading: new Icon(Icons.bookmark, color: UtilColours.APP_BAR,),
                          trailing: new IconButton(icon: Icon(Icons.delete), onPressed: (){
                            removeBookmark(index, bookmark.pageIndex, DatabaseHelper.BOOKMARK );
                          }),
                          onTap: () {
                            widget.pdfViewController.setPage(bookmark.pageIndex);
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                      ),
                    ),
                  );
                });
          }
        });
  }

  Widget commentList(){
    return FutureBuilder(
        future: db.getBookmarksOrComments(widget.bookId,DatabaseHelper.COMMENT),
        builder: (_, comments) {
          if (comments.connectionState == ConnectionState.waiting) {
            return Center(
                child: SpinKitChasingDots(
                  color: UtilColours.APP_BAR,
                  size: 50.0,
                )
            );
          } else {
            return  ListView.builder(
                itemCount: comments.data.length,
                itemBuilder: (BuildContext context, int index){
                  var comment = comments.data[index];
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction){
                      removeComment(index, comment.pageIndex, DatabaseHelper.COMMENT);
                    },
                    background: bookmarkDeleteBG(),
//            secondaryBackground: bookmarkDeleteBG(),
                    child: Card(
                      child: ListTile(
                          title: Text(comment.comment.toString(), style: arabicTxtStyle(paramSize: 18.0)),
                          leading: new Icon(Icons.comment, color: UtilColours.APP_BAR,),
                          subtitle:  Container(
                            child: Column(
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
//                                Container(
//                                  child:   Text("Book: " + comment.bookName.toString(), style: arabicTxtStyle(paramSize: 18.0),),
//                                ),
                                Container(
                                  child:   Text("Page: " + (comment.pageIndex + 1).toString(), style: arabicTxtStyle(paramSize: 18.0)),
                                ),

                              ],
                            ),),

                          trailing: new IconButton(icon: Icon(Icons.delete), onPressed: (){
                            removeComment(index,comment.pageIndex, DatabaseHelper.COMMENT );
                          }),
                          onTap: () {
                            widget.pdfViewController.setPage(comment.pageIndex);
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                      ),
                    ),
                  );
                });
          }
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
              title: Text(widget.title,  style: arabicTxtStyle(paramColour: Colors.white)),
              bottom: new TabBar(
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(
                      child: Container(
                        child: Text(
                          'Bookmark المرجعية',
                          style: arabicTxtStyle(paramColour: Colors.white, paramSize: 18.0),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        child: Text(
                          'Comment تعليق',
                          style: arabicTxtStyle(paramColour: Colors.white, paramSize: 18.0),
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