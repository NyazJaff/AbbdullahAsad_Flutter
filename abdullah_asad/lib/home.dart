import 'package:abdullah_asad/layout_helper.dart';
import 'package:abdullah_asad/question_and_answer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:abdullah_asad/Helper/util.dart';
import 'Helper/db_helper.dart';
import 'models/book_model.dart';

class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var db = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called

    return Scaffold(
      body: Stack (
        children: <Widget>[
          appBgImage(),
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 25.0)),
                      Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Align (
                            alignment: Alignment(-1,-3),
                            child: Padding(
                                padding: EdgeInsets.only(left: 2.0, top:  3.0),
                                child: IconButton (
                                  icon:  Icon(FontAwesomeIcons.userLock),
                                  iconSize: 25,
                                  color: UtilColours.PRIMARY_BROWN,
                                  onPressed: () {
                                    print("pressed");
                                  },
                                )
                            ),
                          )
                        ],
                      ),
                      Column (
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 10.0)),
                          Container (
//                      width: MediaQuery.of(context).size.width * 0.55,
                            width: 255,
                            child: Align (
                              alignment: Alignment.topCenter,
                              child: Image (
                                image: AssetImage("assets/brand/header_title.png"),
                              ),
                            ),
                          ),
                          Container (
                              child: IconButton (
                                icon:  Icon(FontAwesomeIcons.solidCopy),
                                iconSize: 40,
                                color: UtilColours.PRIMARY_BROWN,
                                onPressed: () {
                                  print("pressed");
                                },
                              )
                          )
                        ],
                      ),
                      Column (
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column (
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: Container (
                                              child: IconButton (
                                                icon:  Icon(FontAwesomeIcons.bookOpen),
                                                iconSize: 37,
                                                color: UtilColours.PRIMARY_BROWN,
                                                onPressed: () {
                                                  Navigator.pushNamed(context, '/books');
                                                },
                                              )
                                          )
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Container (
                                            child: IconButton (
                                              icon:  Icon(FontAwesomeIcons.solidUser),
                                              iconSize: 37,
                                              color: UtilColours.PRIMARY_BROWN,
                                              onPressed: () async {
                                              },
                                            )
                                        ),
                                      ),
                                    ]
                                ),
                                Container (
//                      width: MediaQuery.of(context).size.width * 0.55,
                                  width: 150,
                                  child: Align (
                                    child: Image (
                                      image: AssetImage("assets/brand/logo512.png"),
                                    ),
                                  ),
                                ),
                                Column (
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Container (
                                            child: IconButton (
                                              icon:  Icon(FontAwesomeIcons.soundcloud),
                                              iconSize: 37,
                                              color: UtilColours.PRIMARY_BROWN,
                                              onPressed: () {
                                                print("pressed");
                                              },
                                            )
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Container (
                                            child: IconButton (
                                              icon:  Icon(FontAwesomeIcons.broadcastTower),
                                              iconSize: 37,
                                              color: UtilColours.PRIMARY_BROWN,
                                              onPressed: () {
                                                Navigator.pushNamed(context, '/live_broadcast');
                                              },
                                            )
                                        ),
                                      ),
                                    ]
                                ),
                              ]),
                          Container (
                              child: IconButton (
                                icon:  Icon(FontAwesomeIcons.questionCircle),
                                iconSize: 37,
                                color: UtilColours.PRIMARY_BROWN,
                                onPressed: () {
                                  GlobalKey key = GlobalKey();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            QuestionAndAnswer(title: "test", parentId: 0, key: key,)),
                                  );
                                },
                              )
                          )
                        ],
                      ),


                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: util_winHeightSize(context) > 530 ? util_winHeightSize(context)  * 0.3 : util_winHeightSize(context) *  0.04)),
                  Container(
                    child: Align(
                      alignment: FractionalOffset(0, 0.8),
                      child: Container(
                        child: Row (
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
//                            Text(MediaQuery.of(context).size.height.toString()),
                            Padding(
                              padding: EdgeInsets.all(7.0),
                              child: Container (
                                  color: Color(0xff3b5998),
                                  width: 40.0,
                                  height: 40.0,
                                  child: IconButton (
                                    icon:  Icon(FontAwesomeIcons.facebookF),
                                    iconSize: 25,
                                    color: Colors.white.withOpacity(1),
                                    onPressed: () {
                                      print("pressed");
                                    },
                                  )
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(7.0),
                              child: Container (
                                  color: Color(0xff00acee),
                                  width: 40.0,
                                  height: 40.0,
                                  child: IconButton (
                                    icon:  Icon(FontAwesomeIcons.twitter),
                                    iconSize: 25,
                                    color: Color(0xffffffff),
                                    onPressed: () {
                                      print("pressed");
                                    },
                                  )
                              ),
                            ),
                            Padding(
//                      IconButton (
//                        icon:  Icon(FontAwesomeIcons.youtubeSquare),
//                        iconSize: 45,
//                        color: Color(0xffc4302b),
//                        onPressed: () {
//                          print("pressed");
//                        },
//                      ),
                              padding: EdgeInsets.all(7.0),
                              child: Container (
                                  color: Colors.white,
                                  width: 40.0,
                                  height: 40.0,
                                  child: IconButton (
                                    icon:  Icon(FontAwesomeIcons.youtube),
                                    iconSize: 25,
                                    color: Color(0xffc4302b),
                                    onPressed: () {
                                      print("pressed");
                                    },
                                  )
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(7.0),
                              child: Container (
                                  color: Color(0xff0088cc),
                                  width: 40.0,
                                  height: 40.0,
                                  child: IconButton (
                                    icon:  Icon(FontAwesomeIcons.telegramPlane),
                                    iconSize: 25,
                                    color: Color(0xffffffff),
                                    onPressed: () {
                                      print("pressed");
                                    },
                                  )
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(7.0),
                              child: Container (
                                  color: Color(0xff0088cc),
                                  width: 40.0,
                                  height: 40.0,
                                  child: IconButton (
                                    icon:  Icon(FontAwesomeIcons.globe),
                                    iconSize: 25,
                                    color: Color(0xffffffff),
                                    onPressed: () {
                                      print("pressed");
                                    },
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),

        ]
      )
    );
  }
}