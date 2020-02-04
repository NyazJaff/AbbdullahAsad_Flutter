import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:abdullah_asad/home.dart';
import 'package:abdullah_asad/books/list_books.dart';
import 'package:abdullah_asad/books/pdfscreen.dart';

import 'package:flutter_cupertino_localizations/flutter_cupertino_localizations.dart';

void main() => runApp(MyApp());

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
        '/second': (context) => ListBooks(),
        '/pdfScreen': (context) => PDFScreen(),
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

