import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/apps.dart';
import 'package:namma_chennai/routes/webview/webview.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';

SharedPrefs _sharedPrefs = new SharedPrefs();
Firestore db = Firestore.instance;
CollectionReference collectionRef = db.collection('userapps');
CollectionReference collectionRef2 = db.collection('apps');

class MyApps extends StatefulWidget {
  @override
  MyAppsState createState() => new MyAppsState();
}

class MyAppsState extends State<MyApps> {
  List<Widget> listW = new List<Widget>();
  List<Apps> apps = new List();
  String userId;

  getAllMyApps() {
    collectionRef
        .where("user_id", isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      List<DocumentSnapshot> docs = snapshot.documents;
      for (DocumentSnapshot doc in docs) {
        List<dynamic> appIds = doc["apps"];
        for (String appId in appIds) {
          collectionRef2
              .where("app_id", isEqualTo: appId)
              .snapshots()
              .listen((QuerySnapshot snapshot2) {
            List<DocumentSnapshot> docs2 = snapshot2.documents;
            for (DocumentSnapshot doc2 in docs2) {
              Apps app = new Apps.fromSnapShot(doc2);
              apps.add(app);
            }
            renderObjects();
          });
        }
      }
    });
  }

  renderObjects() {
    listW.add(ListTile(
      title: Text("My Apps"),
    ));

    for (Apps app in apps) {
      listW.add(Card(
        margin: EdgeInsets.all(5),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebViewScreen(url: app.appUrl, name: app.appName)));
          },
          child: ListTile(
            leading: Image.network(
              app.appIconUrl,
              width: 50,
            ),
            title: Text(app.appName),
            subtitle: Text(app.appUrl),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ),
      ));
    }

    setState(() {
      this.listW = listW;
    });
  }

  @override
  void initState() {
    super.initState();
    _sharedPrefs.getApplicationSavedInformation("loggedinuser").then((val) {
      userId = val;
      getAllMyApps();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          elevation: 0,
          centerTitle: false,
          title: Text('Namma Chennai'),
        ),
        body: Column(
          children: listW,
        ));
  }
}
