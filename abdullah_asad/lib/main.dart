import 'package:abdullah_asad/live_broadcast.dart';
import 'package:abdullah_asad/question_and_answer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:abdullah_asad/home.dart';
import 'package:abdullah_asad/books/list_books.dart';
import 'package:abdullah_asad/books/pdfscreen.dart';

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
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MyHomePage(),
        '/books': (context) => ListBooks(),
        '/pdfScreen': (context) => PDFScreen(),
//        '/q&a': (context) => QuestionAndAnswer("Q&a", 0),
        '/live_broadcast': (context) => LiveBroadcast(),
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

