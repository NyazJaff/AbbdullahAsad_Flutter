import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:abdullah_asad/home.dart';
import 'package:abdullah_asad/books/list_books.dart';
import 'package:abdullah_asad/books/pdfscreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        '/': (context) => MrTabs(),
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

class Category {
  const Category({ this.name, this.icon});
  final String name;
  final IconData icon;
}

const List<Category> categories = <Category> [
  Category(name: "Comments", icon: Icons.comment),
  Category(name: "Bookmarks", icon: Icons.bookmark)
];

class MrTabs extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
        home:  DefaultTabController (
          length: 2,
          child: new Scaffold(
            appBar: AppBar(
              title:  Text('Tabbed AppBar'),
              bottom: new TabBar(
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(
                      child: Container(
                        child: Text(
                          'Bookmark',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        child: Text(
                          'Comment',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    )
                  ]
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                HomeTopTabs(),
                HomeTopTabs()
              ],
            ),
          ),
        ),
        theme: ThemeData(primaryColor: Colors.deepOrange)
    );

  }
}



///
class HomeTopTabs extends StatefulWidget {
  const HomeTopTabs( { Key key}) : super(key:key);

  @override
  _HomeTopTabsState createState() => _HomeTopTabsState();
}

class _HomeTopTabsState extends State<HomeTopTabs> with SingleTickerProviderStateMixin{
  int colorVal = 0xffff5722;

  @override
  void initState(){
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }
  void _handleTabSelection(){
    setState(() {
      colorVal = 0xffff5722;
    });
  }

  TabController _tabController;
  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return DefaultTabController (
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorWeight: 4.0,
              indicatorColor: Color(0xffff5722),
              unselectedLabelColor: Colors.grey,
              tabs: <Widget>[
                Tab(
                  icon:Icon(FontAwesomeIcons.compass, color: _tabController.index == 0
                      ? Color( 0xffff5722)
                      : Colors.grey),
                  child: Text('For You', style: TextStyle(color: _tabController.index == 0
                      ? Color (0xffff5722)
                      : Colors.grey),),
                ),

                Tab(
                  icon:Icon(FontAwesomeIcons.chartBar, color: _tabController.index == 1
                      ? Color( 0xffff5722)
                      : Colors.grey),
                  child: Text('Top Charts', style: TextStyle(color: _tabController.index == 1
                      ? Color (colorVal)
                      : Colors.grey),),
                ),

              ]
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Container(
                child: Text("ddd")
            ),
            Container(
                child: Text("ddd")
            )

          ],
        ),
      ),
    );
  }
}


class HomeForYouTabs extends StatefulWidget {
  const HomeForYouTabs( { Key key}) : super(key:key);

  @override
  _HomeForYouTabsState createState() => _HomeForYouTabsState();
}

class _HomeForYouTabsState extends State<HomeForYouTabs>{
  int colorVal;


  TabController _tabController;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text("ddd")
    );
  }


}
