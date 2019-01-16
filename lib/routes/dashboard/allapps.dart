import 'package:flutter/material.dart';

class AllApps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var icons = [
      {
        "title": "Ola",
        "iconUrl": "https://www.olacabs.com/webstatic/img/favicon.ico",
        "url": "https://www.olacabs.com/"
      },
      {
        "title": "Flipkart",
        "iconUrl":
            "https://img1a.flixcart.com/www/promos/new/20150528-140547-favicon-retina.ico",
        "url": "https://www.flipkart.com"
      },
      {
        "title": "Amazon",
        "iconUrl": "https://www.amazon.com/favicon.ico",
        "url": "https://www.amazon.com"
      },
      {
        "title": "TamilNadu Government",
        "iconUrl":
            "http://www.tn.gov.in/sites/all/themes/bootstrap/favicon.ico",
        "url": "http://www.tn.gov.in/"
      },
      {
        "title": "Google",
        "iconUrl": "https://www.google.com/favicon.ico",
        "url": "https://www.google.com"
      },
    ];

    List<Widget> listW = new List<Widget>();
    listW.add(ListTile(
      title: Text("Top Apps"),
    ));

    for (var icon in icons) {
      print(icon);
      listW.add(Card(
        margin: EdgeInsets.all(5),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/appview");
          },
          child: ListTile(
            leading: Image.network(
              icon["iconUrl"],
              width: 50,
            ),
            title: Text(icon["title"]),
            subtitle: Text(icon["url"]),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ),
      ));
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          elevation: 0,
          centerTitle: false,
          title: Text('Namma App Kadai'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: Card(
                child: ListView(
                  children: listW,
                ),
              )
            ),
          ],
        ));
  }
}
