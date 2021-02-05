import 'package:AbdullahAsadF/utilities/layout_helper.dart';
import 'package:AbdullahAsadF/view/lectures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:AbdullahAsadF/Helper/util.dart';
import 'Helper/db_helper.dart';
import 'package:easy_localization/easy_localization.dart';

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
              child: Stack(
                children: [
                  SingleChildScrollView(
                      child: AnimationLimiter(
                        child: Column(
                            children: AnimationConfiguration.toStaggeredList(
                                duration: const Duration(milliseconds: 1375),
                                childAnimationBuilder: (widget) => SlideAnimation(
                                  horizontalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: widget,
                                  ),
                                ),
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.only(top: 25.0)),
                                      util_winHeightSize(context) > 730 ? Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Align (
                                            alignment: Alignment(-1,-3),
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 2.0, top:  50.0),
                                              // child: IconButton (
                                              //   icon:  Icon(FontAwesomeIcons.userLock),
                                              //   iconSize: 25,
                                              //   color: UtilColours.PRIMARY_BROWN,
                                              //   onPressed: () {
                                              //   },
                                              // )
                                            ),
                                          )
                                        ],
                                      ) : Container(),
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
                                                  Navigator.pushNamed(context, '/speeches');
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
                                                      Container (
                                                          padding: EdgeInsets.all(6.0) ,
                                                          child: IconButton (
                                                            icon:  Icon(FontAwesomeIcons.bookOpen),
                                                            iconSize: 37,
                                                            color: UtilColours.PRIMARY_BROWN,
                                                            onPressed: () {
                                                              Navigator.pushNamed(context, '/books');
                                                            },
                                                          )
                                                      ),
                                                      Container (
                                                          padding: EdgeInsets.all(6.0),
                                                          child: IconButton (
                                                            icon:  Icon(FontAwesomeIcons.solidUser),
                                                            iconSize: 37,
                                                            color: UtilColours.PRIMARY_BROWN,
                                                            onPressed: () async {
                                                              Navigator.pushNamed(context, '/about_shikh');
                                                            },
                                                          )
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
                                                      Container (
                                                          padding: EdgeInsets.all(6.0),
                                                          child: IconButton (
                                                            icon:  Icon(FontAwesomeIcons.soundcloud),
                                                            iconSize: 37,
                                                            color: UtilColours.PRIMARY_BROWN,
                                                            onPressed: () {
                                                              Navigator.pushNamed(context, '/lectures');
                                                            },
                                                          )
                                                      ),
                                                      Container (
                                                          padding: EdgeInsets.all(6.0),
                                                          child: IconButton (
                                                            icon:  Icon(FontAwesomeIcons.broadcastTower),
                                                            iconSize: 37,
                                                            color: UtilColours.PRIMARY_BROWN,
                                                            onPressed: () {
                                                              Navigator.pushNamed(context, '/live_broadcast');
                                                            },
                                                          )
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
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Lectures(title:'question_and_answer'.tr(), parentId: 0, classType: DatabaseHelper.QUESTION_AND_ANSWER),),
                                                  );
                                                },
                                              )
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  addPadding(context),
                                  socialMediaLinks(),
                                  addPadding(context),
                                  getCurrentOrientation() == Orientation.landscape ? devNJaff() : Container(),
                                ]
                            )
                        ),
                      )
                  ),
                  getCurrentOrientation() == Orientation.landscape ? Container() : devNJaff(),
                ],
              ),
            ),
          ]
      ),
    );
  }

  Widget addPadding(context){
   return Padding(padding: EdgeInsets.only(top: util_winHeightSize(context) > 700 ? util_winHeightSize(context)  * 0.2 : util_winHeightSize(context) *  0.04));
  }

  Widget devNJaff(){
    return Align(
      alignment: Alignment(0.0, 0.98),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          width: 75,
          height: 45,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/brand/dev N.Jaff.png'),
            ),
          ),
          child: FlatButton(
            padding: EdgeInsets.all(0.0),
            onPressed: () async {
              await InAppBrowser.openWithSystemBrowser(
                  url: "http://nyazjaff.co.uk");
            },
            child: null,
          ),
        ),
      ),
    );
  }

  Widget socialMediaLinks(){
    return  Container(
      child: Align(
        alignment: FractionalOffset(0, 0.8),
        child: Container(
          child: Row (
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
//                            Text(MediaQuery.of(context).size.height.toString()),
//                             Padding(
//                               padding: EdgeInsets.all(7.0),
//                               child: Container (
//                                   color: Color(0xff3b5998),
//                                   width: 40.0,
//                                   height: 40.0,
//                                   child: IconButton (
//                                     icon:  Icon(FontAwesomeIcons.facebookF),
//                                     iconSize: 25,
//                                     color: Colors.white.withOpacity(1),
//                                     onPressed: () {
//                                     },
//                                   )
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.all(7.0),
//                               child: Container (
//                                   color: Color(0xff00acee),
//                                   width: 40.0,
//                                   height: 40.0,
//                                   child: IconButton (
//                                     icon:  Icon(FontAwesomeIcons.twitter),
//                                     iconSize: 25,
//                                     color: Color(0xffffffff),
//                                     onPressed: () async {
//                                       await InAppBrowser.openWithSystemBrowser(
//                                           url: "https://twitter.com/Aaalsaad7");
//                                     },
//                                   )
//                               ),
//                             ),
//               Padding(
//                 padding: EdgeInsets.all(7.0),
//                 child: Container (
//                     color: Colors.white,
//                     width: 40.0,
//                     height: 40.0,
//                     child: IconButton (
//                       icon:  Icon(FontAwesomeIcons.youtube),
//                       iconSize: 25,
//                       color: Color(0xffc4302b),
//                       onPressed: () async {
//                         await InAppBrowser.openWithSystemBrowser(
//                             url: "https://www.youtube.com/channel/UCHfgtjpGxCLabIfRG-Zvpyw/videos");
//                       },
//                     )
//                 ),
//               ),
              // Padding(
              //   padding: EdgeInsets.all(7.0),
              //   child: Container (
              //       color: Color(0xff0088cc),
              //       width: 40.0,
              //       height: 40.0,
              //       child: IconButton (
              //         icon:  Icon(FontAwesomeIcons.telegramPlane),
              //         iconSize: 25,
              //         color: Color(0xffffffff),
              //         onPressed: () async {
              //           await InAppBrowser.openWithSystemBrowser(
              //               url: "https://t.me/Aaalsaad7");
              //         },
              //       )
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Container (
                    color: Color(0xffffffff),
                    width: 40.0,
                    height: 40.0,
                    child: IconButton (
                      icon:  Icon(FontAwesomeIcons.periscope),
                      iconSize: 25,
                      color: Color(0xffdb5248),
                      onPressed: () async {
                        await InAppBrowser.openWithSystemBrowser(
                            url: "https://mixlr.com/%D8%B4%D8%A8%D9%83%D8%A9-%D8%AE%D9%8A%D8%B1-%D8%A3%D9%85%D8%A9");
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
                      onPressed: () async {
                        await InAppBrowser.openWithSystemBrowser(
                            url: "http://abdullah-asad.com/");
                      },
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}