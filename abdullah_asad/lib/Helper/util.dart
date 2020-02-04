import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

double util_winHeightSize(BuildContext context){
  return MediaQuery.of(context).size.height;
}

app_bar(BuildContext context, title){
  return  AppBar(
    leading: new IconButton(
      icon: new Icon(Icons.arrow_back, color: UtilColours.APP_BAR_NAV_BUTTON),
      onPressed: () => Navigator.of(context).pop(),
    ),
    backgroundColor: UtilColours.APP_BAR,
//          backgroundColor: Color(0x44000000),
    elevation: 0,
    title: Text(title,  style: TextStyle(
        color: UtilColours.APP_BAR_NAV_BUTTON,
        fontFamily: "Tajawal"
    )),
  );
}

class UtilColours {
  static const Color PRIMARY_BROWN = Color(0xffc6ac6e);
  static const Color SAVE_BUTTON = Color(0xff00bfa5);

  static const Color APP_BAR = Color(0xff38606A);
  static const Color APP_BAR_NAV_BUTTON = Color(0xffE1D7D5);
}

bool utilIsAndroid(context){
  bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
  return isAndroid;
}
Future<File> createFileOfPdfUrl(pdfUrl) async {
  final url = pdfUrl;
  final filename = url.substring(url.lastIndexOf("/") + 1);
  String dir = (await getApplicationDocumentsDirectory()).path;

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
  return file;
}

showToast(context, message){
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: 2),
  ));
}
Future<File> doesUrlFileExits(context, url) async{
  final filename = url.substring(url.lastIndexOf("/") + 1);
  String dir = (await getApplicationDocumentsDirectory()).path;
  if(File(await '$dir/$filename').existsSync() == true){
    return File(await '$dir/$filename');
  }
  return null;
}

deleteUrlFileIfExits(url) async{

  //TODO write deletion
  final filename = url.substring(url.lastIndexOf("/") + 1);
  String dir = (await getApplicationDocumentsDirectory()).path;
  if(File(await '$dir/$filename').existsSync() == true){
    return true;
  }
  return false;
}