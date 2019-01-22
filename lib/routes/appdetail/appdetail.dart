import 'package:flutter/material.dart';
import 'package:namma_chennai/model/apps.dart';
import 'package:namma_chennai/model/userapps.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Firestore db = Firestore.instance;
CollectionReference collectionRef = db.collection('myapps');

class AppDetailScreen extends StatefulWidget {
  Apps app;

  AppDetailScreen({this.app});

  @override
  AppDetailState createState() => new AppDetailState(app: this.app);
}

class AppDetailState extends State<AppDetailScreen> {
  Apps app;

  AppDetailState({this.app});

  installApp() {
    UserApps myApp = new UserApps(app.appId);
    // myApp.isInstalled = true;
    // TO DO set user id here
    collectionRef
          .document()
          .setData(myApp.toJson())
          .catchError((e) {
        print(e);
      });
    // Some animation here and then go back
    Navigator.of(context).pop();
  }

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
        body: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 40.0, right: 10.0, left: 10.0),
              child: Container(
                  height: 500.0,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: Image.network(
                            app.iconUrl,
                            width: 50,
                          ),
                          title: Text(app.name,
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold)),
                        ),
                        elevation: 4.0,
                      ),
                      Card(
                          elevation: 4.0,
                          child: Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text("Developer Information",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text("\n\nDeveloper Name: " +
                                        app.devName +
                                        "\n\nDeveloper Email: " +
                                        app.devEmail),
                                  ),
                                ],
                              ))),
                      Expanded(child: Container()),
                      FlatButton(
                        color: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: () {
                          installApp();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18.0, horizontal: 98.0),
                          child: Text(
                            'Install',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}
