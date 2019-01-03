import 'package:flutter/material.dart';
import 'package:namma_chennai/webview.dart';

class MyAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var icons = {
      1: {
        "title": "Ola",
        "iconUrl": "https://www.olacabs.com/webstatic/img/favicon.ico",
        "url": "https://www.olacabs.com/"
      },
      2: {
        "title": "Swiggy",
        "iconUrl": "https://www.swiggy.com/favicon.ico",
        "url": "https://www.swiggy.com"
      },
      3: {
        "title": "Amazon",
        "iconUrl": "https://www.amazon.com/favicon.ico",
        "url": "https://www.amazon.com"
      },
      4: {
        "title": "Tamilnadu",
        "iconUrl":
            "http://www.tn.gov.in/sites/all/themes/bootstrap/favicon.ico",
        "url": "http://www.tn.gov.in/"
      },
      5: {
        "title": "Google",
        "iconUrl": "https://www.google.com/favicon.ico",
        "url": "https://www.google.com"
      },
    };
    List<Widget> listW = new List<Widget>();
    for (var x in [1, 2, 3, 4, 5]) {
      listW.add(FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(url: icons[x]["url"]),
            ),
          );
        },
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        child: Column(
          // Replace with a Row for horizontal icon + text
          children: <Widget>[
            Image.network(
              icons[x]["iconUrl"],
              width: 50,
            ),
            SizedBox(
              height: 10,
            ),
            Text(icons[x]["title"])
          ],
        ),
      ));
    }
    return SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              // Box decoration takes a gradient
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topCenter,
                end: Alignment.center,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.2, 0.35, 0.6],
                tileMode: TileMode.clamp,
                colors: [
                  // Colors are easy thanks to Flutter's Colors class.
                  Colors.redAccent,
                  Colors.orange,
                  Color(0xFFEEEEEE),
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                new Text(
                  'Hi, ithu Namma Chennai',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30.0,
                      color: Colors.yellow),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        title: Text('Recent apps'),
                      ),
                      SizedBox(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                            scrollDirection: Axis.horizontal, children: listW),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        title: Text('Recommended apps'),
                      ),
                      SizedBox(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                            scrollDirection: Axis.horizontal, children: listW),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        title: Text('Future apps'),
                      ),
                      SizedBox(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                            scrollDirection: Axis.horizontal, children: listW),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        title: Text('Future apps'),
                      ),
                      SizedBox(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                            scrollDirection: Axis.horizontal, children: listW),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        title: Text('Future apps'),
                      ),
                      SizedBox(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                            scrollDirection: Axis.horizontal, children: listW),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
