import 'dart:async';
import 'package:abdullah_asad/Helper/util.dart';
import 'package:flutter/material.dart';
import 'package:abdullah_asad/layout_helper.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:webview_flutter/webview_flutter.dart';


class LiveBroadcast extends StatefulWidget {
  @override
  _LiveBroadcastState createState() => _LiveBroadcastState();
}

class _LiveBroadcastState extends State<LiveBroadcast> {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  void playYoutubeVideo() {
    FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: "AIzaSyAT1Tp_KlzOA7nUvGXP8VMtKaUNGujEgj4",
      videoUrl: "https://www.youtube.com/watch?v=wgTBLj7rMPM",
      fullScreen: false,
      autoPlay: false,
      appBarColor: Colors.green,
      backgroundColor: Colors.green
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        extendBodyBehindAppBar: true,
//        backgroundColor: Colors.red,
        appBar: app_bar(context, "Broadcast "),
        body:Scaffold(
            body: Stack (
                children: <Widget>[
                  appBgImage(),
                  new Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new RaisedButton(
                        child: new Text("Play Default Video"),
                        onPressed: playYoutubeVideo),
                  ),
                        WebView(
                        initialUrl: 'https://abdullah-asad.com/',
    javascriptMode: JavascriptMode.unrestricted,
    onWebViewCreated: (WebViewController webViewController) {
    _controller.complete(webViewController);
    },
    // TODO(iskakaushik): Remove this when collection literals makes it to stable.
    // ignore: prefer_collection_literals
    javascriptChannels: <JavascriptChannel>[
    _toasterJavascriptChannel(context),
    ].toSet(),
    navigationDelegate: (NavigationRequest request) {
    if (request.url.startsWith('https://www.youtube.com/')) {
    print('blocking navigation to $request}');
    return NavigationDecision.prevent;
    }
    print('allowing navigation to $request');
    return NavigationDecision.navigate;
    },
    onPageStarted: (String url) {
    print('Page started loading: $url');
    },
    onPageFinished: (String url) {
    print('Page finished loading: $url');
    },
    gestureNavigationEnabled: true,
    )
                ]
            )
        )
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
