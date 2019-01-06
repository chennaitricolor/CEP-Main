import 'package:flutter/material.dart';
import 'package:namma_chennai/loader/color_loader.dart';
import 'package:namma_chennai/loader/dot_type.dart';

class AppViewScreen extends StatefulWidget {
  String url;
  AppViewScreen({this.url});

  @override
  _AppViewScreenState createState() =>
      new _AppViewScreenState(appUrl: this.url);
}

class _AppViewScreenState extends State<AppViewScreen> {
  String appUrl;

  _AppViewScreenState({this.appUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 224, 224, 224),
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          elevation: 0,
          centerTitle: false,
          title: const Text('Namma App Kadai'),
        ),
        body: new Stack(
          children: <Widget>[
            // The containers in the background
            new Column(
              children: <Widget>[
                new Container(
                  height: MediaQuery.of(context).size.height * .1,
                  color: Colors.redAccent,
                ),
              ],
            ),
            // The card widget with top padding,
            // incase if you wanted bottom padding to work,
            // set the `alignment` of container to Alignment.bottomCenter
            new Container(
              alignment: Alignment.topCenter,
              padding: new EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .03,
                  right: 10.0,
                  left: 10.0),
              child: new Container(
                  height: 500.0,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      new Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: Image.network(
                            "https://www.olacabs.com/webstatic/img/favicon.ico",
                            width: 50,
                          ),
                          title: Text("Hello world"),
                          subtitle: Text("https://www.google.com/"),
                        ),
                        elevation: 4.0,
                      ),
                      Card(
                          elevation: 4.0,
                          child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text("Information"),
                                    subtitle: Text(
                                        "\nIt is very good app, It called as app. deveployed by tech for cities team."),
                                  ),
                                  ListTile(
                                    title: Text("Key features"),
                                    subtitle: Text(
                                      "\n1. It can do this\n1. It can do this\n1. It can do this\n1. It can do this\n1. It can do this\n1. It can do this",
                                    ),
                                  ),
                                ],
                              ))),
                      SizedBox(
                        height: 5,
                      ),
                      FlatButton(
                        color: Colors.orangeAccent,
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigator.pushNamedAndRemoveUntil(
                          //     context, '/dashboard', (_) => false);
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 150.0),
                          child: Text(
                            'Install',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ));
  }
}
