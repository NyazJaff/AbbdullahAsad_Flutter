import 'dart:async';
import 'package:abdullah_asad/Helper/util.dart';
import 'package:flutter/material.dart';
import 'package:abdullah_asad/layout_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';


class QuestionAndAnswer extends StatefulWidget {
  @override
  _QuestionAndAnswerState createState() => _QuestionAndAnswerState();
}

class _QuestionAndAnswerState extends State<QuestionAndAnswer> {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        extendBodyBehindAppBar: true,
//        backgroundColor: Colors.red,
        appBar: app_bar(context, "Q&A"),
        body:Scaffold(
            body: Stack (
                children: <Widget>[
                  appBgImage(),
                  new Padding(
                    padding: const EdgeInsets.all(10.0),
                  )
                ]
            )
        )
    );
  }
}
