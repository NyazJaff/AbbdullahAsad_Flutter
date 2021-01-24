import 'package:AbdullahAsadF/view/lectures.dart';
import 'package:AbdullahAsadF/view/live_broadcast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:AbdullahAsadF/home.dart';
import 'package:AbdullahAsadF/books/list_books.dart';
import 'package:AbdullahAsadF/books/pdfscreen.dart';
import 'package:AbdullahAsadF/view/about_shikh.dart';
import 'Helper/db_helper.dart';

void main() async {

  runApp(EasyLocalization (
    child: new MyApp(),
    supportedLocales: [
      Locale('en', 'UK'),
      Locale('ar', 'SA'),
      Locale('ar', 'KU')
    ],
    path: 'assets/langs',
    fallbackLocale: Locale('ar', 'SA'),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var locale = EasyLocalization.of(context).locale;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //Route
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/books': (context) => ListBooks(),
        '/pdfScreen': (context) => PDFScreen(),
//        '/q&a': (context) => QuestionAndAnswer("Q&a", 0),
        '/live_broadcast': (context) => LiveBroadcast(),
        '/about_shikh': (context) => AbdoutShikh(),
        '/lectures': (context) => Lectures(title:'lectures'.tr(), parentId: 0, classType: DatabaseHelper.LECTURES),
        '/speeches': (context) => Lectures(title:'speech'.tr(), parentId: 0, classType: DatabaseHelper.SPEECH),
      },

      //Localization
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        EasyLocalization.of(context).delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: EasyLocalization.of(context).supportedLocales,
      locale: EasyLocalization.of(context).locale,

      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily:
          locale.toString() == 'ar_SA' ? 'Tajawal' :
          locale.toString() == 'ar_KU' ? 'Kurdi' :
          'ProximaNova',
        ),
      ),
    );
  }
}