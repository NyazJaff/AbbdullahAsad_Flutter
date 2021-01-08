import 'package:abdullah_asad/view/lectures.dart';
import 'package:abdullah_asad/view/live_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:abdullah_asad/home.dart';
import 'package:abdullah_asad/books/list_books.dart';
import 'package:abdullah_asad/books/pdfscreen.dart';
import 'package:abdullah_asad/view/about_shikh.dart';

import 'Helper/db_helper.dart';
import 'view/mp3_player.dart';
void main() async {
//
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      //Route
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/books': (context) => ListBooks(),
        '/pdfScreen': (context) => PDFScreen(),
//        '/q&a': (context) => QuestionAndAnswer("Q&a", 0),
        '/live_broadcast': (context) => LiveBroadcast(),
        '/about_shikh': (context) => AbdoutShikh(),
        '/lectures': (context) => Lectures(title:'Lectures', parentId: 0, classType: DatabaseHelper.LECTURES),
        '/speeches': (context) => Lectures(title:'Speech', parentId: 0, classType: DatabaseHelper.SPEECH),
        '/mp3Player': (context) => Mp3Player(title:'Speeches'),
      },

      //Localization
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("fa", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales
        Locale("en", "UK"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
//      locale: Locale("ar", "IR"),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

