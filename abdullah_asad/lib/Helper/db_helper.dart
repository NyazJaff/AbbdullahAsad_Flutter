import 'dart:io';

import 'package:abdullah_asad/models/book_model.dart';
import 'package:abdullah_asad/models/comments_and_bookmarks_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static const String COMMENT = "COMMENT";
  static const String BOOKMARK = "BOOKMARK";


  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper()=>_instance;

  static Database _db;

  Future<Database>get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDb();
    return _db;
  }
  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "abdullahAlSaad.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Book ("
        "id INTEGER PRIMARY KEY, "
        "name TEXT, "
        "description TEXT, "
        "pdfURL TEXT, "
        "imageURL TEXT"
        ")");
    print("Table Book is created");
    await db.execute("CREATE TABLE CommentAndBookmark ("
        "id INTEGER PRIMARY KEY, "
        "bookId INTEGER, "
        "pageIndex INTEGER, "
        "comment TEXT, "
        "type TEXT, "
        "CONSTRAINT kf_book "
        "FOREIGN KEY (bookId) "
        "REFERENCES Book(id)"
        ")");
    print("Table CommentAndBookmark is created");
  }

 largestBookId() async {
    var dbClient = await db;
    List<Map> result =  await dbClient.rawQuery("SELECT MAX(id) as id from Book");
    int largestId = 0;
    result.forEach((element) {
      if(element['id'] != null){
        largestId = element['id'];
      }
    });
    print('largest Book Id: ' + largestId.toString());
    return largestId;
  }

  Future<int> saveBook(Book book) async {
    var dbClient = await db;
    int res = await dbClient.insert(("Book"), book.toMap());
//    print(book.toString() + "saved");
    return res;
  }

  Future<int> deleteBook() async {
    var dbClient = await db;
    int res = await dbClient.delete("Book");
//    print(("book deleted!"));
    return res;
  }

  Future<List<Book>> books() async {
    // Get a reference to the database.
    var dbClient = await db;

    // Query the table for all The Books.
    final List<Map<String, dynamic>> maps = await dbClient.query('book');

    // Convert the List<Map<String, dynamic> into a List<Book>.
    return List.generate(maps.length, (i) {
      return Book(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        imageURL: maps[i]['imageURL'],
        pdfURL: maps[i]['pdfURL'],
      );
    });
  }


  Future<int> saveCommentOrBookmark(CommentAndBookmark object) async {
    var dbClient = await db;
    int res = await dbClient.insert(("CommentAndBookmark"), object.toMap());
//    print(object.toString() + "saved");
    return res;
  }

  Future<int> deleteAllCommentOrBookmark() async {
    var dbClient = await db;
    int res = await dbClient.delete("CommentAndBookmark");
//    print(("CommentAndBookmark deleted!"));
    return res;
  }

  Future<List<CommentAndBookmark>> getBookmarksOrComments(int bookId, String type) async {
    var dbClient = await db;
    List<Map> maps =  await dbClient.rawQuery("SELECT * from CommentAndBookmark where bookId=? and type=? order by pageIndex DESC", [bookId, type]);
    return List.generate(maps.length, (i) {
      return CommentAndBookmark(
        id: maps[i]['id'],
        bookId: maps[i]['bookId'],
        pageIndex: maps[i]['pageIndex'],
        comment: maps[i]['comment'],
        type: maps[i]['type'],
      );
    });
  }

  Future<bool> checkIfPageMarkedBookmark(int bookId, int pageIndex) async{
    var dbClient = await db;
    List<Map> result =  await dbClient.rawQuery("SELECT * from CommentAndBookmark where bookId=? and pageIndex=? and type=?", [bookId, pageIndex, BOOKMARK]);
    if (result.length > 0){
      return true;
    }else{
      return false;
    }
  }

//  updatePageBookmarkStatus(int bookId, int pageIndex, status )
  Future<bool> deleteCommentOrBookmark(int bookId, int pageIndex, String type) async{
    var dbClient = await db;
    var deleted = false;

    dbClient.rawDelete('DELETE FROM CommentAndBookmark where bookId=? and pageIndex=? and type=?', [bookId, pageIndex, type]).then((value) {
      print(value);
      deleted = true;
    });
    return deleted;
  }
}