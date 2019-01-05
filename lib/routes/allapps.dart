import 'package:flutter/material.dart';
import 'package:namma_chennai/loader/color_loader.dart';
import 'package:namma_chennai/loader/dot_type.dart';

class AllAppsScreen extends StatelessWidget {
  final Color color;

  AllAppsScreen(this.color);

  @override
  Widget build(BuildContext context) {
    var icons = {
      1: {
        "title": "Ola",
        "iconUrl": "https://www.olacabs.com/webstatic/img/favicon.ico",
        "url": "https://www.olacabs.com/"
      },
      2: {
        "title": "Flipkart",
        "iconUrl":
            "https://img1a.flixcart.com/www/promos/new/20150528-140547-favicon-retina.ico",
        "url": "https://www.flipkart.com"
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
    listW.add(ListTile(
      title: Text("Top Trending"),
    ));
    for (var x in [1, 2, 3, 4, 5]) {
      listW.add(Card(
        margin: EdgeInsets.all(5),
        child: InkWell(
          onTap: () {},
          child: ListTile(
            leading: Image.network(
              icons[x]["iconUrl"],
              width: 50,
            ),
            title: Text(icons[x]["title"]),
            subtitle: Text(icons[x]["url"]),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ),
      ));
    }

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: false,
        title: new Text('Namma App Kadai'),
      ),
      body: new DefaultTabController(
        length: 4,
        child: new Column(
          children: <Widget>[
            new Container(
              child: new Material(
                color: Colors.orange[100],
                child: new TabBar(
                  labelColor: Colors.black,
                  indicator: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 2.0,
                      ),
                    ),
                  ),
                  tabs: [
                    new Tab(
                      text: "New",
                    ),
                    new Tab(
                      text: "Installed",
                    ),
                    new Tab(
                      text: "All",
                    ),
                    new Tab(
                      text: "Old",
                    ),
                  ],
                ),
              ),
            ),
            new Expanded(
              child: new TabBarView(
                children: [
                  Container(
                      child: Card(
                    child: ListView(
                      children: listW + listW + listW,
                    ),
                  )),
                  new Icon(Icons.directions_transit),
                  new Icon(Icons.directions_bike),
                  new Icon(Icons.directions_bike),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
